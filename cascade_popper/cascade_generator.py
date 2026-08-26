"""
Cascade-based Hypothesis Generator for ILP tasks.
Uses Windsurf Cascade (interactive AI assistant) to generate Prolog hypotheses based on:
- Background knowledge (BK)
- Positive and negative examples
- Language bias (mode declarations)
- Learned constraints from previous failures

Unlike LLM-based generation, Cascade works interactively:
1. Build prompt/context for the task
2. Cascade (you) provides hypotheses
3. Test and constrain loop continues
"""

import os
import re
from typing import List, Dict, Tuple, Optional, Set


class ModeDeclaration:
    """Represents a mode declaration for hypothesis generation."""
    def __init__(self, predicate, arity, is_head, arg_types, directions):
        self.predicate = predicate
        self.arity = arity
        self.is_head = is_head
        self.arg_types = arg_types
        self.directions = directions  # 'in' or 'out'


class Constraint:
    """Represents a learned constraint from failures."""
    def __init__(self, constraint_type, description, prolog_encoding=None, source_clause=None):
        self.constraint_type = constraint_type  # 'exclusion', 'dependency', 'cardinality', 'anti_subsumption'
        self.description = description
        self.prolog_encoding = prolog_encoding
        self.source_clause = source_clause


class TaskContext:
    """Contains all context needed for hypothesis generation."""
    def __init__(self, bk_predicates, positive_examples, negative_examples, 
                 mode_declarations, constraints=None, failed_hypotheses=None, 
                 target_predicate=""):
        self.bk_predicates = bk_predicates
        self.positive_examples = positive_examples
        self.negative_examples = negative_examples
        self.mode_declarations = mode_declarations
        self.constraints = constraints if constraints is not None else []
        self.failed_hypotheses = failed_hypotheses if failed_hypotheses is not None else []  # (hypothesis, reason)
        self.target_predicate = target_predicate


class CascadeHypothesisGenerator:
    """
    Generates hypotheses using Windsurf Cascade with Popper-style constraint guidance.
    
    Unlike LLMHypothesisGenerator which calls OpenAI API, this class:
    1. Builds prompts/context for Cascade to read
    2. Accepts hypotheses from Cascade interactively
    3. Tracks constraints and failed patterns
    
    The generate-test-constrain loop:
    1. Build prompt with constraints for Cascade
    2. Cascade provides hypothesis
    3. Hypothesis is tested
    4. Constraints are learned from failures
    5. Repeat
    """
    
    def __init__(self, model: str = "cascade"):
        self.model = model
        self.context: Optional[TaskContext] = None
        self.iteration = 0
        self.pending_hypotheses: List[str] = []
        
    def load_task(self, task_dir: str) -> TaskContext:
        """Load task files and create context for hypothesis generation."""
        bk_path = os.path.join(task_dir, "bk.pl")
        exs_path = os.path.join(task_dir, "exs.pl")
        bias_path = os.path.join(task_dir, "bias.pl")
        
        # Parse background knowledge
        bk_predicates = self._parse_bk(bk_path)
        
        # Parse examples
        pos_examples, neg_examples = self._parse_examples(exs_path)
        
        # Parse mode declarations
        mode_declarations = self._parse_bias(bias_path)
        
        # Determine target predicate from examples
        target_pred = ""
        if pos_examples:
            match = re.match(r"pos\((\w+)\(", pos_examples[0])
            if match:
                target_pred = match.group(1)
        
        self.context = TaskContext(
            bk_predicates=bk_predicates,
            positive_examples=pos_examples,
            negative_examples=neg_examples,
            mode_declarations=mode_declarations,
            target_predicate=target_pred
        )
        
        return self.context
    
    def _parse_bk(self, bk_path: str) -> List[Dict]:
        """Parse background knowledge file to extract predicate information."""
        predicates = {}
        
        if not os.path.exists(bk_path):
            return []
            
        with open(bk_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('%') or line.startswith(':-'):
                    continue
                    
                # Match facts like pred(arg1, arg2, ...).
                match = re.match(r"(\w+)\(([^)]*)\)\.", line)
                if match:
                    pred_name = match.group(1)
                    args = [a.strip() for a in match.group(2).split(',') if a.strip()]
                    
                    if pred_name not in predicates:
                        predicates[pred_name] = {
                            'name': pred_name,
                            'arity': len(args),
                            'sample_facts': [],
                            'count': 0
                        }
                    
                    predicates[pred_name]['count'] += 1
                    if len(predicates[pred_name]['sample_facts']) < 3:
                        predicates[pred_name]['sample_facts'].append(line)
        
        return list(predicates.values())
    
    def _parse_examples(self, exs_path: str) -> Tuple[List[str], List[str]]:
        """Parse examples file."""
        pos = []
        neg = []
        
        if not os.path.exists(exs_path):
            return pos, neg
            
        with open(exs_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('pos('):
                    pos.append(line)
                elif line.startswith('neg('):
                    neg.append(line)
        
        return pos, neg
    
    def _parse_bias(self, bias_path: str) -> List[ModeDeclaration]:
        """Parse bias file to extract mode declarations."""
        modes = []
        
        if not os.path.exists(bias_path):
            return modes
            
        head_preds = {}
        body_preds = {}
        types = {}
        directions = {}
        
        with open(bias_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('%'):
                    continue
                
                # head_pred(name, arity).
                match = re.match(r"head_pred\((\w+),\s*(\d+)\)\.", line)
                if match:
                    head_preds[match.group(1)] = int(match.group(2))
                    continue
                
                # body_pred(name, arity).
                match = re.match(r"body_pred\((\w+),\s*(\d+)\)\.", line)
                if match:
                    body_preds[match.group(1)] = int(match.group(2))
                    continue
                
                # type(pred, (type1, type2, ...)).
                match = re.match(r"type\((\w+),\s*\(([^)]+)\)\)\.", line)
                if match:
                    pred = match.group(1)
                    type_strs = [t.strip() for t in match.group(2).split(',')]
                    types[pred] = tuple(type_strs)
                    continue
                
                # direction(pred, (dir1, dir2, ...)).
                match = re.match(r"direction\((\w+),\s*\(([^)]+)\)\)\.", line)
                if match:
                    pred = match.group(1)
                    dir_strs = [d.strip() for d in match.group(2).split(',')]
                    directions[pred] = tuple(dir_strs)
        
        # Build mode declarations
        for pred, arity in head_preds.items():
            modes.append(ModeDeclaration(
                predicate=pred,
                arity=arity,
                is_head=True,
                arg_types=types.get(pred, tuple()),
                directions=directions.get(pred, tuple())
            ))
        
        for pred, arity in body_preds.items():
            modes.append(ModeDeclaration(
                predicate=pred,
                arity=arity,
                is_head=False,
                arg_types=types.get(pred, tuple()),
                directions=directions.get(pred, tuple())
            ))
        
        return modes
    
    def build_prompt(self, max_clauses: int = 3) -> str:
        """Build prompt for Cascade to generate hypotheses."""
        if not self.context:
            raise ValueError("No task context loaded. Call load_task() first.")
        
        ctx = self.context
        
        # Build constraint section
        constraints_text = ""
        if ctx.constraints:
            constraints_text = "\n### LEARNED CONSTRAINTS (Must be respected):\n"
            for i, c in enumerate(ctx.constraints, 1):
                constraints_text += f"{i}. [{c.constraint_type}] {c.description}\n"
        
        # Build failed hypotheses section
        failures_text = ""
        if ctx.failed_hypotheses:
            failures_text = "\n### PREVIOUSLY FAILED HYPOTHESES (Avoid similar patterns):\n"
            for hyp, reason in ctx.failed_hypotheses[-5:]:  # Show last 5 failures
                failures_text += f"- Failed: `{hyp}`\n  Reason: {reason}\n"
        
        # Build predicate information
        pred_info = "### AVAILABLE PREDICATES:\n"
        
        # Head predicates
        head_modes = [m for m in ctx.mode_declarations if m.is_head]
        if head_modes:
            pred_info += "**Head predicates** (can appear in clause head):\n"
            for m in head_modes:
                pred_info += f"  - `{m.predicate}/{m.arity}`\n"
        
        # Body predicates
        body_modes = [m for m in ctx.mode_declarations if not m.is_head]
        if body_modes:
            pred_info += "\n**Body predicates** (can appear in clause body):\n"
            for m in body_modes[:20]:  # Limit for readability
                pred_info += f"  - `{m.predicate}/{m.arity}`\n"
            if len(body_modes) > 20:
                pred_info += f"  ... and {len(body_modes) - 20} more\n"
        
        # Sample BK facts
        bk_sample = "\n### SAMPLE BACKGROUND KNOWLEDGE:\n"
        for pred in ctx.bk_predicates[:10]:
            bk_sample += f"\n**{pred['name']}/{pred['arity']}** ({pred['count']} facts):\n```prolog\n"
            for fact in pred['sample_facts']:
                bk_sample += f"{fact}\n"
            bk_sample += "```\n"
        
        # Examples
        examples_text = "\n### EXAMPLES:\n"
        examples_text += "**Positive examples** (hypothesis must cover ALL):\n```prolog\n"
        for ex in ctx.positive_examples[:10]:
            examples_text += f"{ex}\n"
        if len(ctx.positive_examples) > 10:
            examples_text += f"% ... and {len(ctx.positive_examples) - 10} more\n"
        examples_text += "```\n"
        
        examples_text += "\n**Negative examples** (hypothesis must cover NONE):\n```prolog\n"
        for ex in ctx.negative_examples[:10]:
            examples_text += f"{ex}\n"
        if len(ctx.negative_examples) > 10:
            examples_text += f"% ... and {len(ctx.negative_examples) - 10} more\n"
        examples_text += "```\n"
        
        prompt = f"""You are solving an Inductive Logic Programming (ILP) problem using Popper's
constraint-based approach.

# ILP Task - Iteration {self.iteration + 1}

### OBJECTIVE:
Learn a hypothesis H (set of Prolog clauses) that:
- Covers ALL positive examples: BK ∪ H ⊨ e for all positive e
- Covers NO negative examples: BK ∪ H ⊭ e for all negative e

Target predicate to learn: `{ctx.target_predicate}`
({len(ctx.positive_examples)} positive examples, {len(ctx.negative_examples)} negative examples)

{pred_info}
{bk_sample}
{examples_text}
{constraints_text}
{failures_text}

## REQUIREMENTS
1. Valid Prolog syntax ending with `.`
2. Use only available predicates listed above
3. Variables: uppercase letters (A, B, C, X, Y, Z)
4. All body variables must connect to head or other body literals
5. Respect ALL learned constraints
6. Avoid patterns similar to failed hypotheses

## YOUR TASK
Generate up to {max_clauses} candidate Prolog clause(s).

**Format**: One clause per line, e.g.:
```prolog
{ctx.target_predicate}(A) :- predicate1(A,B), predicate2(B).
```
"""
        return prompt
    
    def set_hypotheses(self, hypotheses: List[str]):
        """
        Set hypotheses provided by Cascade.
        
        Args:
            hypotheses: List of Prolog clause strings from Cascade
        """
        self.pending_hypotheses = []
        for hyp in hypotheses:
            hyp = hyp.strip()
            if hyp and not hyp.startswith('%') and not hyp.startswith('#'):
                if not hyp.endswith('.'):
                    hyp += '.'
                self.pending_hypotheses.append(hyp)
    
    def generate_hypothesis(self, max_clauses: int = 3) -> List[str]:
        """
        Return pending hypotheses set by Cascade.
        
        Unlike LLM version, this returns hypotheses that were set via set_hypotheses().
        If no hypotheses pending, returns empty list (Cascade needs to provide more).
        """
        self.iteration += 1
        
        if self.pending_hypotheses:
            result = self.pending_hypotheses[:max_clauses]
            self.pending_hypotheses = self.pending_hypotheses[max_clauses:]
            return result
        
        return []
    
    def parse_hypothesis_text(self, text: str) -> List[str]:
        """Parse hypothesis text from Cascade into clause list."""
        clauses = []
        
        for line in text.strip().split('\n'):
            line = line.strip()
            
            # Skip empty lines, comments, markdown
            if not line or line.startswith('%') or line.startswith('#') or line.startswith('```'):
                continue
            
            # Remove markdown code fence language identifier
            if line.lower() in ['prolog', 'pl']:
                continue
            
            # Check for clause pattern: head :- body. or head.
            if re.match(r'\w+\([^)]*\)\s*:-.*\.$', line) or re.match(r'\w+\([^)]*\)\.$', line):
                clauses.append(line)
        
        return clauses
    
    def add_constraint(self, constraint: Constraint):
        """Add a learned constraint to the context."""
        if self.context:
            self.context.constraints.append(constraint)
    
    def add_failure(self, hypothesis: str, reason: str):
        """Record a failed hypothesis."""
        if self.context:
            self.context.failed_hypotheses.append((hypothesis, reason))
    
    def reset(self):
        """Reset iteration counter and constraints for new task."""
        self.iteration = 0
        self.pending_hypotheses = []
        if self.context:
            self.context.constraints = []
            self.context.failed_hypotheses = []
    
    def get_task_summary(self) -> str:
        """Get a brief task summary."""
        if not self.context:
            return "No task loaded."
        
        ctx = self.context
        return f"""Task: Learn `{ctx.target_predicate}`
Positives: {len(ctx.positive_examples)}
Negatives: {len(ctx.negative_examples)}
Body predicates: {len([m for m in ctx.mode_declarations if not m.is_head])}
Iteration: {self.iteration}
Constraints: {len(ctx.constraints)}
Failed hypotheses: {len(ctx.failed_hypotheses)}"""
