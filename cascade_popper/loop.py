"""
Main Cascade-Popper Learning Loop.
Implements the generate-test-constrain loop using Windsurf Cascade for hypothesis generation.

Unlike LLM-Popper which calls OpenAI API, Cascade-Popper works interactively:
1. Build prompt/context for Cascade
2. Cascade provides hypotheses
3. Test hypotheses against examples
4. Learn constraints from failures
5. Update prompt and repeat
"""

import os
import time
import json
from datetime import datetime
from typing import Optional, List, Tuple

from .cascade_generator import CascadeHypothesisGenerator, Constraint
from .constraint_learner import ConstraintLearner, TestResult
from .tester import HypothesisTester


class LearningResult:
    """Result of the learning process."""
    def __init__(self, success, hypothesis, iterations, constraints_learned, time_taken, test_stats):
        self.success = success
        self.hypothesis = hypothesis
        self.iterations = iterations
        self.constraints_learned = constraints_learned
        self.time_taken = time_taken
        self.test_stats = test_stats


class CascadePopperLoop:
    """
    Main learning loop using Cascade for hypothesis generation.
    
    The loop follows:
    1. GENERATE: Cascade provides candidate hypotheses based on prompt
    2. TEST: Evaluate hypotheses against examples
    3. CONSTRAIN: Learn from failures to guide future generation
    4. REPEAT: Until solution found or max iterations reached
    
    Unlike LLMPopperLoop, this class works interactively with Cascade.
    """
    
    def __init__(self, task_dir: str, model: str = "cascade",
                 max_iterations: int = 20, verbose: bool = True):
        self.task_dir = task_dir
        self.max_iterations = max_iterations
        self.verbose = verbose
        self.model = model
        
        # Initialize components
        self.generator = CascadeHypothesisGenerator(model=model)
        self.constraint_learner = ConstraintLearner()
        self.tester = HypothesisTester(task_dir)
        
        # Load task
        self.generator.load_task(task_dir)
        
        # Track best hypothesis so far
        self.best_hypothesis: Optional[str] = None
        self.best_score: float = 0.0
        self.best_result: Optional[TestResult] = None
        
        # Session tracking
        self.iteration = 0
        self.tested_hypotheses: List[dict] = []
        self.start_time = time.time()
        self.solved = False
        self.total_time = 0.0
        
    def log(self, message: str):
        """Print message if verbose mode is on."""
        if self.verbose:
            print(message)
    
    def get_prompt(self, max_clauses: int = 3) -> str:
        """Get the current prompt for Cascade to generate hypotheses."""
        # Update generator with learned constraints
        for constraint in self.constraint_learner.get_constraints_for_prompt():
            self.generator.add_constraint(constraint)
        
        return self.generator.build_prompt(max_clauses)
    
    def test_hypothesis(self, hypothesis: str) -> str:
        """
        Test a hypothesis provided by Cascade.
        
        Args:
            hypothesis: Prolog clause(s) to test
            
        Returns:
            Formatted result string for Cascade
        """
        iter_start = time.time()
        self.iteration += 1
        
        # Clean up hypothesis
        hypothesis = hypothesis.strip()
        if not hypothesis.endswith('.'):
            hypothesis += '.'
        
        # Check subsumption pruning first
        should_prune, prune_reason = self.constraint_learner.check_subsumption_pruning(hypothesis)
        if should_prune:
            return f"""## PRUNED - Iteration {self.iteration}

**Hypothesis**: `{hypothesis}`

**PRUNED BY SUBSUMPTION**: {prune_reason}

This hypothesis is subsumed by a previously failed general clause.
It would also cover negative examples.

**Please provide a different hypothesis.**
"""
        
        # Test the hypothesis
        result = self.tester.test_hypothesis(hypothesis)
        stats = self.tester.get_statistics(result)
        
        # Calculate iteration time
        iter_time = time.time() - iter_start
        
        # Track this test
        self.tested_hypotheses.append({
            'iteration': self.iteration,
            'hypothesis': hypothesis,
            'time': round(iter_time, 3),
            'timestamp': datetime.now().isoformat(),
            'result': {
                'covered_pos': len(result.covered_pos),
                'missed_pos': len(result.missed_pos),
                'covered_neg': len(result.covered_neg),
                'is_complete': result.is_complete
            }
        })
        
        # Update best if improved
        score = stats['f1_score']
        if score > self.best_score:
            self.best_score = score
            self.best_hypothesis = hypothesis
            self.best_result = result
        
        # Check for solution
        if result.is_complete:
            self.solved = True
            self.total_time = time.time() - self.start_time
            self.save_session()
            
            # Auto-save hypothesis file
            hyp_path = self.save_hypothesis(hypothesis)
            
            return f"""## [OK] SOLUTION FOUND! - Iteration {self.iteration}

**Hypothesis**:
```prolog
{hypothesis}
```

### Coverage:
| Metric | Value |
|--------|-------|
| Positives Covered | {stats['true_positives']}/{stats['total_positives']} |
| Negatives Covered | 0/{stats['total_negatives']} |
| Precision | 1.000 |
| Recall | 1.000 |
| F1 Score | 1.000 |

### Statistics:
- **Iterations**: {self.iteration}
- **Time**: {self.total_time:.3f}s
- **Constraints learned**: {len(self.constraint_learner.learned_constraints)}

The hypothesis correctly covers all positive examples and excludes all negative examples.

**Hypothesis saved to**: `{hyp_path}`
"""
        
        # Learn constraints from failure
        constraints = self.constraint_learner.analyze_failure(result)
        for c in constraints:
            self.generator.add_failure(hypothesis, c.description)
        
        # Build failure feedback
        output = f"""## [X] Not a Solution - Iteration {self.iteration}

**Hypothesis**:
```prolog
{hypothesis}
```

### Coverage:
| Metric | Value |
|--------|-------|
| Positives Covered | {stats['true_positives']}/{stats['total_positives']} |
| Positives Missed | {stats['false_negatives']} |
| Negatives Covered (errors) | {stats['false_positives']}/{stats['total_negatives']} |
| Precision | {stats['precision']:.3f} |
| Recall | {stats['recall']:.3f} |
| F1 Score | {stats['f1_score']:.3f} |

"""
        
        if result.is_too_general:
            output += f"""### Problem: TOO GENERAL
The hypothesis covers **{len(result.covered_neg)} negative examples** (should be 0).

**Action needed**: Add more conditions to the body to exclude negatives.
Try adding literals that are true for positives but false for negatives.

"""
        elif result.is_too_specific:
            output += f"""### Problem: TOO SPECIFIC
The hypothesis misses **{len(result.missed_pos)} positive examples**.

**Action needed**: Either:
1. Generalize the current clause (remove/weaken conditions), or
2. Add another clause to cover the alternative pattern

"""
        
        # Show learned constraints
        if constraints:
            output += "### Learned Constraints:\n"
            for c in constraints:
                output += f"- **[{c.constraint_type}]** {c.description}\n"
            output += "\n"
        
        # Show best so far
        if self.best_hypothesis and self.best_hypothesis != hypothesis:
            output += f"""### Best Hypothesis So Far (F1={self.best_score:.3f}):
```prolog
{self.best_hypothesis}
```
"""
        
        output += "\n**Please provide a refined hypothesis based on the feedback above.**"
        
        self.save_session()
        return output
    
    def test_hypotheses(self, hypotheses_text: str) -> str:
        """
        Test multiple hypotheses from text (parses and tests each).
        
        Args:
            hypotheses_text: Text containing one or more Prolog clauses
            
        Returns:
            Combined results for all hypotheses
        """
        clauses = self.generator.parse_hypothesis_text(hypotheses_text)
        
        if not clauses:
            return "No valid Prolog clauses found in the input. Please provide clauses in the format:\n`predicate(A) :- body(A,B).`"
        
        results = []
        for clause in clauses:
            result = self.test_hypothesis(clause)
            results.append(result)
            
            # Stop if solution found
            if self.solved:
                break
        
        return "\n---\n".join(results)
    
    def get_status(self) -> str:
        """Get current session status."""
        ctx = self.generator.context
        
        status = f"""## Session Status

- **Task**: `{self.task_dir}`
- **Target**: `{ctx.target_predicate if ctx else 'unknown'}`
- **Positives**: {len(self.tester.pos_examples)}
- **Negatives**: {len(self.tester.neg_examples)}
- **Iteration**: {self.iteration}
- **Solved**: {self.solved}
- **Time elapsed**: {time.time() - self.start_time:.1f}s

"""
        
        if self.best_hypothesis:
            status += f"""### Best Hypothesis (F1={self.best_score:.3f}):
```prolog
{self.best_hypothesis}
```

"""
        
        if self.tested_hypotheses:
            status += f"### Last {min(5, len(self.tested_hypotheses))} Tests:\n"
            for t in self.tested_hypotheses[-5:]:
                r = t['result']
                icon = "[OK]" if r['is_complete'] else "[X]"
                status += f"- {icon} Iter {t['iteration']}: {r['covered_pos']} pos, {r['missed_pos']} missed, {r['covered_neg']} neg\n"
        
        if self.constraint_learner.learned_constraints:
            status += f"\n### Constraints Learned ({len(self.constraint_learner.learned_constraints)}):\n"
            for c in self.constraint_learner.learned_constraints[-5:]:
                status += f"- [{c.constraint_type}] {c.description[:60]}...\n"
        
        return status
    
    def save_session(self, path: str = None):
        """Save session state to file."""
        if path is None:
            path = os.path.join(self.task_dir, 'cascade_session.json')
        
        # Calculate total time if not already solved
        if not self.solved:
            current_total = time.time() - self.start_time
        else:
            current_total = self.total_time
        
        state = {
            'task_dir': self.task_dir,
            'model': self.model,
            'created_at': datetime.now().isoformat(),
            'solved': self.solved,
            'total_time_seconds': round(current_total, 3),
            'iteration': self.iteration,
            'tested_hypotheses': self.tested_hypotheses,
            'best_hypothesis': self.best_hypothesis,
            'best_score': self.best_score,
            'constraints': [
                {'type': c.constraint_type, 'description': c.description}
                for c in self.constraint_learner.learned_constraints
            ]
        }
        
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(state, f, indent=2)
        
        return path
    
    def save_hypothesis(self, hypothesis: str, path: str = None) -> str:
        """Save hypothesis to file."""
        if path is None:
            path = os.path.join(self.task_dir, 'hypothesis.pl')
        
        with open(path, 'w', encoding='utf-8') as f:
            f.write(f"% Solved by Cascade in {self.iteration} iterations\n")
            f.write(f"% Time: {self.total_time:.3f}s\n")
            f.write(f"% Model: {self.model}\n")
            f.write(hypothesis)
            if not hypothesis.endswith('\n'):
                f.write('\n')
        
        return path
    
    def load_session(self, path: str = None) -> bool:
        """Load session state from file."""
        if path is None:
            path = os.path.join(self.task_dir, 'cascade_session.json')
        
        if not os.path.exists(path):
            return False
        
        with open(path, 'r', encoding='utf-8') as f:
            state = json.load(f)
        
        self.iteration = state.get('iteration', 0)
        self.tested_hypotheses = state.get('tested_hypotheses', [])
        self.best_hypothesis = state.get('best_hypothesis')
        self.best_score = state.get('best_score', 0.0)
        self.model = state.get('model', 'cascade')
        self.solved = state.get('solved', False)
        self.total_time = state.get('total_time_seconds', 0.0)
        
        # Adjust start_time to account for previous session time
        if self.total_time > 0 and not self.solved:
            self.start_time = time.time() - self.total_time
        
        # Restore constraints
        for c_data in state.get('constraints', []):
            constraint = Constraint(
                constraint_type=c_data['type'],
                description=c_data['description']
            )
            self.constraint_learner.learned_constraints.append(constraint)
        
        return True
    
    def reset(self):
        """Reset the session."""
        self.iteration = 0
        self.tested_hypotheses = []
        self.best_hypothesis = None
        self.best_score = 0.0
        self.best_result = None
        self.solved = False
        self.total_time = 0.0
        self.start_time = time.time()
        
        self.generator.reset()
        self.constraint_learner.reset()
        
        # Remove session file
        session_path = os.path.join(self.task_dir, 'cascade_session.json')
        if os.path.exists(session_path):
            os.remove(session_path)


def solve_with_cascade(task_dir: str, model: str = "cascade",
                       max_iterations: int = 20, verbose: bool = True) -> CascadePopperLoop:
    """
    Create a CascadePopperLoop for solving an ILP task.
    
    Usage:
        loop = solve_with_cascade("example_abstraction/z1")
        print(loop.get_prompt())  # Show task to Cascade
        # Cascade provides hypothesis
        print(loop.test_hypothesis("p0(A) :- p1(A,B), p6(B)."))
        # Repeat until solved
    
    Args:
        task_dir: Path to task directory containing bk.pl, exs.pl, bias.pl
        model: Model name to record (for tracking)
        max_iterations: Maximum learning iterations
        verbose: Print progress
        
    Returns:
        CascadePopperLoop instance ready for interactive solving
    """
    loop = CascadePopperLoop(
        task_dir=task_dir,
        model=model,
        max_iterations=max_iterations,
        verbose=verbose
    )
    
    # Try to load existing session
    loop.load_session()
    
    return loop