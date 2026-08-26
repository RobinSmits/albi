"""
BK Adapter for Large Dataset Support in Cascade-Popper.

This module provides size-aware background knowledge handling:
- Small tasks (<100KB): Returns full BK (preserves existing quality)
- Large tasks (>100KB): Returns smart summary (enables scalability)

The adapter automatically detects task size and applies the appropriate strategy,
ensuring backward compatibility with existing small tasks while enabling
large datasets like trains2.
"""

import os
import re
from typing import List, Dict, Set, Optional, Tuple
from dataclasses import dataclass
from collections import defaultdict


# Configurable thresholds
BK_SIZE_THRESHOLD_BYTES = 100 * 1024  # 100KB
BK_LINE_THRESHOLD = 5000
MAX_PROMPT_BK_CHARS = 50000  # Max chars for BK in LLM prompt

# Example thresholds
EXAMPLE_COUNT_THRESHOLD = 1000  # Summarize if more than this many examples
MAX_EXAMPLES_IN_PROMPT = 200  # Max examples to show in LLM prompt (100 pos + 100 neg)


@dataclass
class TaskProfile:
    """Characterizes a task for strategy selection."""
    task_dir: str
    bk_path: str
    bk_size_bytes: int
    bk_line_count: int
    pos_count: int
    neg_count: int
    predicate_count: int
    is_large: bool
    has_many_examples: bool = False  # True if examples exceed threshold
    
    @property
    def total_examples(self) -> int:
        return self.pos_count + self.neg_count
    
    @property
    def strategy(self) -> str:
        """Return the strategy name for this task."""
        return "summarized" if self.is_large else "full"
    
    @property
    def example_strategy(self) -> str:
        """Return the example handling strategy."""
        return "sampled" if self.has_many_examples else "full"
    
    @property
    def size_category(self) -> str:
        """Human-readable size category."""
        if self.bk_size_bytes < 10 * 1024:
            return "small"
        elif self.bk_size_bytes < 100 * 1024:
            return "medium"
        else:
            return "large"
    
    def __str__(self) -> str:
        return (f"TaskProfile(bk={self.bk_size_bytes//1024}KB, "
                f"lines={self.bk_line_count}, "
                f"pos={self.pos_count}, neg={self.neg_count}, "
                f"bk_strategy={self.strategy}, "
                f"ex_strategy={self.example_strategy})")


@dataclass 
class PredicateInfo:
    """Information about a predicate in the BK."""
    name: str
    arity: int
    count: int
    sample_facts: List[str]
    
    @property
    def signature(self) -> str:
        return f"{self.name}/{self.arity}"


class BKAdapter:
    """
    Adapts BK handling based on task size.
    
    Small tasks: Returns full BK (preserves existing quality)
    Large tasks: Returns smart summary (enables scalability)
    
    Usage:
        adapter = BKAdapter(task_dir)
        if adapter.profile.is_large:
            bk_for_prompt = adapter.get_bk_for_prompt(examples)
        else:
            bk_for_prompt = adapter.get_full_bk()
    """
    
    def __init__(self, task_dir: str):
        self.task_dir = task_dir
        self.bk_path = os.path.join(task_dir, "bk.pl")
        self.exs_path = os.path.join(task_dir, "exs.pl")
        
        # Cached data
        self._full_bk: Optional[str] = None
        self._predicate_info: Optional[Dict[str, PredicateInfo]] = None
        self._entity_index: Optional[Dict[str, Set[str]]] = None
        
        # Analyze task on init
        self.profile = self._analyze_task()
    
    def _analyze_task(self) -> TaskProfile:
        """Analyze task to determine optimal strategy."""
        # BK stats
        bk_size = 0
        bk_lines = 0
        predicate_count = 0
        
        if os.path.exists(self.bk_path):
            bk_size = os.path.getsize(self.bk_path)
            predicates_seen = set()
            with open(self.bk_path, 'r', encoding='utf-8') as f:
                for line in f:
                    bk_lines += 1
                    line = line.strip()
                    if line and not line.startswith(('%', ':-')) and '(' in line:
                        pred = line.split('(')[0]
                        predicates_seen.add(pred)
            predicate_count = len(predicates_seen)
        
        # Example counts
        pos_count = 0
        neg_count = 0
        if os.path.exists(self.exs_path):
            with open(self.exs_path, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if line.startswith('pos('):
                        pos_count += 1
                    elif line.startswith('neg('):
                        neg_count += 1
        
        # Determine if large BK
        is_large = (bk_size > BK_SIZE_THRESHOLD_BYTES or 
                    bk_lines > BK_LINE_THRESHOLD)
        
        # Determine if many examples
        has_many_examples = (pos_count + neg_count) > EXAMPLE_COUNT_THRESHOLD
        
        return TaskProfile(
            task_dir=self.task_dir,
            bk_path=self.bk_path,
            bk_size_bytes=bk_size,
            bk_line_count=bk_lines,
            pos_count=pos_count,
            neg_count=neg_count,
            predicate_count=predicate_count,
            is_large=is_large,
            has_many_examples=has_many_examples
        )
    
    def get_full_bk(self) -> str:
        """Get the complete BK content (for small tasks or testing)."""
        if self._full_bk is None:
            if os.path.exists(self.bk_path):
                with open(self.bk_path, 'r', encoding='utf-8') as f:
                    self._full_bk = f.read()
            else:
                self._full_bk = ""
        return self._full_bk
    
    def get_bk_for_prompt(self, 
                          examples: List[str] = None,
                          max_chars: int = MAX_PROMPT_BK_CHARS) -> str:
        """
        Get BK content optimized for LLM prompt.
        
        Small tasks: Returns FULL BK (unchanged behavior)
        Large tasks: Returns SMART SUMMARY
        
        Args:
            examples: List of example strings (e.g., ["f(t800)", "f(t297)"])
            max_chars: Maximum characters for the BK portion
            
        Returns:
            BK content string suitable for LLM prompt
        """
        if not self.profile.is_large:
            # For small tasks, return Full BK
            return self.get_full_bk()
        
        # LARGE TASK: Use summarization
        return self._build_summarized_bk(examples, max_chars)
    
    def _build_summarized_bk(self, 
                             examples: List[str] = None,
                             max_chars: int = MAX_PROMPT_BK_CHARS) -> str:
        """Build a smart summary of the BK for large datasets."""
        parts = []
        
        # 1. Header with statistics
        parts.append(self._build_header())
        
        # 2. Schema summary (predicate signatures with counts)
        parts.append(self._build_schema_summary())
        
        # 3. Example-relevant facts (most important for hypothesis generation)
        if examples:
            relevant = self._extract_relevant_facts(examples)
            if relevant:
                parts.append(relevant)
        
        # 4. Stratified sample of all predicates
        parts.append(self._build_stratified_sample())
        
        # Combine and truncate if needed
        result = "\n\n".join(parts)
        if len(result) > max_chars:
            result = result[:max_chars-100] + "\n\n% ... (truncated for size)"
        
        return result
    
    def _build_discriminative_stats(self, examples: List[str] = None) -> str:
        """
        Analyze which predicates appear more frequently in positive vs negative examples.
        This provides a HUGE hint to the LLM about what matters.
        """
        print(f"[DEBUG] _build_discriminative_stats called with {len(examples) if examples else 0} examples")
        if not examples:
            print("[DEBUG] No examples provided - returning empty")
            return ""
            
        pos_ids = set()
        neg_ids = set()
        
        for ex in examples:
            # Better entity extraction: extract arguments from predicate pattern
            # e.g. pos(f(t1)) -> t1, pos(zendo(0)) -> 0
            
            # First try to extract from nested predicate pattern: pos(pred(arg))
            m = re.search(r'(?:pos|neg)\(\w+\(([^)]+)\)', ex)
            if m:
                args = [a.strip() for a in m.group(1).split(',')]
                valid_ids = args
            else:
                # Fallback: grab all alphanumeric strings that look like IDs
                found = re.findall(r'\b([a-z][a-z0-9_]*)\b', ex)
                valid_ids = [x for x in found if x not in ('pos', 'neg', 'f', 'goal', 'target', 'zendo')]
            
            if ex.startswith('pos('):
                pos_ids.update(valid_ids)
            elif ex.startswith('neg('):
                neg_ids.update(valid_ids)
        
        print(f"[DEBUG] Extracted pos_ids: {len(pos_ids)} - sample: {list(pos_ids)[:5]}")
        print(f"[DEBUG] Extracted neg_ids: {len(neg_ids)} - sample: {list(neg_ids)[:5]}")
        
        if not pos_ids or not neg_ids:
            print(f"[DEBUG] Missing IDs - pos_ids empty: {not pos_ids}, neg_ids empty: {not neg_ids}")
            return ""
            
        # Count how many EXAMPLES have each predicate (not facts)
        # e.g., "78 positive examples have green" not "258 green facts"
        pos_counts = defaultdict(int)  # predicate -> count of pos EXAMPLES that have it
        neg_counts = defaultdict(int)  # predicate -> count of neg EXAMPLES that have it
        
        # Helper to extract arguments from a fact
        def extract_fact_args(fact):
            match = re.search(r'\((.+)\)', fact)
            if not match:
                return []
            return [a.strip() for a in match.group(1).rstrip('.').split(',')]
        
        # Read all BK facts first
        scan_limit = 50000
        all_bk_facts = []
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f):
                if i >= scan_limit: break
                line = line.strip()
                if line and not line.startswith('%'):
                    all_bk_facts.append(line)
        
        # Build entity -> facts index for fast lookup
        entity_to_facts = defaultdict(list)
        for fact in all_bk_facts:
            args = extract_fact_args(fact)
            for arg in args:
                entity_to_facts[arg].append(fact)
        
        # For each example, find what predicates it has
        def get_predicates_for_example(example_id):
            """Get all predicates that appear in facts related to this example."""
            predicates = set()
            # Get entities related to this example (e.g., pieces)
            related_entities = {example_id}
            for fact in entity_to_facts.get(example_id, []):
                args = extract_fact_args(fact)
                predicates.add(fact.split('(')[0])
                if len(args) == 2:
                    related_entities.update(args)
            # Get predicates on related entities
            for entity in related_entities:
                for fact in entity_to_facts.get(entity, []):
                    predicates.add(fact.split('(')[0])
            return predicates
        
        # Count EXAMPLES that have each predicate
        for pid in pos_ids:
            preds = get_predicates_for_example(pid)
            for pred in preds:
                pos_counts[pred] += 1
        
        for nid in neg_ids:
            preds = get_predicates_for_example(nid)
            for pred in preds:
                neg_counts[pred] += 1
        
        # Calculate ratio/relevance
        scores = []
        all_preds = set(pos_counts.keys()) | set(neg_counts.keys())
        
        for pred in all_preds:
            p_c = pos_counts[pred]
            n_c = neg_counts[pred]
            total = p_c + n_c
            if total < 5: continue # Ignore rare predicates
            
            # Simple relevance score: deviation from balanced distribution
            # 1.0 = only in pos, -1.0 = only in neg
            score = (p_c - n_c) / total
            scores.append((pred, score, p_c, n_c))
            
        # Sort by relevance (absolute score)
        scores.sort(key=lambda x: abs(x[1]), reverse=True)
        
        if not scores:
            return ""
            
        lines = ["% DISCRIMINATIVE PREDICATE STATISTICS (Pos vs Neg Correlation)"]
        lines.append("% ----------------------------------------")
        lines.append("% Predicate | Correlation | Pos Occurrences | Neg Occurrences")
        lines.append("% (Score > 0.0 means correlates with POSITIVE, < 0.0 with NEGATIVE)")
        
        for pred, score, p_c, n_c in scores[:15]: # Show top 15
            relevance = "POSITIVE++" if score > 0.6 else \
                        "POSITIVE+" if score > 0.2 else \
                        "NEGATIVE++" if score < -0.6 else \
                        "NEGATIVE+" if score < -0.2 else "NEUTRAL"
            
            lines.append(f"% {pred:<15} : {score:+.2f} ({relevance})  [Pos:{p_c} vs Neg:{n_c}]")
            
        return "\n".join(lines)
    
    def _build_discriminative_patterns(self, examples: List[str] = None) -> str:
        """
        Find discriminative PATTERNS (not just single predicates):
        - Predicate pairs on same entity
        - Multi-entity patterns: entity with X AND related entity with Y
        Works for ANY ILP task by analyzing relational structure.
        """
        if not examples:
            return ""
        
        import re
        from itertools import combinations
        
        pos_examples = [ex for ex in examples if ex.startswith('pos(')]
        neg_examples = [ex for ex in examples if ex.startswith('neg(')]
        
        if not pos_examples or not neg_examples:
            return ""
        
        # Extract entity from example like pos(f(t10)). -> t10 or pos(zendo(0)). -> 0
        def extract_main_entity(ex):
            # Generic: match any predicate pattern like pred(arg) inside pos(...) or neg(...)
            # e.g., pos(f(t10)) -> t10, pos(zendo(0)) -> 0
            m = re.search(r'(?:pos|neg)\(\w+\(([^)]+)\)', ex)
            if m:
                args = m.group(1).split(',')
                return args[0].strip() if args else None
            # Fallback: extract any alphanumeric ID
            m = re.search(r'(?:pos|neg)\(([a-z][a-z0-9_]*)', ex)
            return m.group(1) if m else None
        
        # Read BK with scan limit for large datasets
        MAX_BK_FACTS_FOR_PATTERNS = 30000  # Limit to avoid memory/performance issues
        all_bk_facts = []
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f):
                if i >= MAX_BK_FACTS_FOR_PATTERNS:
                    break
                line = line.strip()
                if line and not line.startswith('%'):
                    all_bk_facts.append(line)
        
        # Identify predicate names and relational predicates (2-arity linking entities)
        predicate_names = set()
        relational_preds = set()  # 2-arity predicates that link entities
        for fact in all_bk_facts:
            if '(' in fact:
                pred = fact.split('(')[0]
                predicate_names.add(pred)
                # Check arity by counting commas
                args = fact.split('(')[1].rstrip(').').split(',')
                if len(args) == 2:
                    relational_preds.add(pred)
        
        # Helper: extract argument IDs from a fact
        def extract_args(text):
            match = re.search(r'\((.+)\)', text)
            if not match:
                return []
            args_str = match.group(1).rstrip('.')
            return [a.strip() for a in args_str.split(',')]
        
        # Build index: entity_id -> list of facts containing that ID as an argument (EXACT match)
        entity_to_facts = defaultdict(list)
        for fact in all_bk_facts:
            args = extract_args(fact)
            for arg in args:
                entity_to_facts[arg].append(fact)
        
        # Build entity -> property predicates mapping for an example
        def get_entity_properties(main_entity):
            """Get properties of main entity and all related entities."""
            entity_props = defaultdict(set)  # entity_id -> set of 1-arity predicates
            entity_relations = defaultdict(set)  # entity_id -> set of (relation, target_entity)
            
            # Find all entities connected to main_entity
            visited = {main_entity}
            queue = [main_entity]
            max_entities = 50  # Limit to avoid explosion
            
            while queue and len(visited) < max_entities:
                current = queue.pop(0)
                # Use index instead of scanning all facts (EXACT argument match)
                for fact in entity_to_facts.get(current, []):
                    pred = fact.split('(')[0]
                    args = extract_args(fact)
                    
                    if len(args) == 1 and args[0] == current:
                        # 1-arity predicate = property
                        entity_props[current].add(pred)
                    elif len(args) == 2:
                        # 2-arity predicate = relation
                        if args[0] == current and args[1] not in visited:
                            visited.add(args[1])
                            queue.append(args[1])
                            entity_relations[current].add((pred, args[1]))
                        elif args[1] == current and args[0] not in visited:
                            visited.add(args[0])
                            queue.append(args[0])
            
            return entity_props, entity_relations
        
        # Analyze patterns for positive and negative examples
        pos_patterns = defaultdict(int)  # pattern -> count of EXAMPLES (not pairs)
        neg_patterns = defaultdict(int)
        
        # Use ALL examples, not just samples, for accurate counting
        sample_pos = pos_examples
        sample_neg = neg_examples
        
        for ex in sample_pos:
            main_ent = extract_main_entity(ex)
            if not main_ent:
                continue
            props, rels = get_entity_properties(main_ent)
            
            # Collect all properties across all related entities
            all_props = set()
            for ent, pset in props.items():
                all_props.update(pset)
            
            # Pattern 1: Predicate pairs (any two properties in this example)
            for p1, p2 in combinations(sorted(all_props), 2):
                pos_patterns[(p1, p2)] += 1
            
            # Pattern 2: Multi-entity - property on one entity + property on related entity
            seen_multi = set()  # Count each pattern only once per example
            for ent, pset in props.items():
                for rel_pred, rel_ent in rels.get(ent, []):
                    for my_prop in pset:
                        for their_prop in props.get(rel_ent, []):
                            pattern = (f"{my_prop}(E1)", f"{rel_pred}(E1,E2)", f"{their_prop}(E2)")
                            if pattern not in seen_multi:
                                pos_patterns[pattern] += 1
                                seen_multi.add(pattern)
            
            # Pattern 3: SIBLING patterns - count EXAMPLES that have the pattern
            # e.g., train has car1 with three_wheels AND car2 with (long, roof_closed)
            seen_sibling = set()  # Count each pattern only once per example
            for parent_ent in props.keys():
                children = [(rel, child) for rel, child in rels.get(parent_ent, [])]
                if len(children) >= 2:
                    for i, (rel1, child1) in enumerate(children):
                        for rel2, child2 in children[i+1:]:
                            if rel1 == rel2:  # Same relation type (e.g., both has_car)
                                for prop1 in props.get(child1, []):
                                    for prop2 in props.get(child2, []):
                                        if prop1 != prop2:  # Different properties
                                            p1, p2 = sorted([prop1, prop2])
                                            pattern = ("SIBLING", rel1, p1, p2)
                                            if pattern not in seen_sibling:
                                                pos_patterns[pattern] += 1
                                                seen_sibling.add(pattern)
        
        for ex in sample_neg:
            main_ent = extract_main_entity(ex)
            if not main_ent:
                continue
            props, rels = get_entity_properties(main_ent)
            
            all_props = set()
            for ent, pset in props.items():
                all_props.update(pset)
            
            for p1, p2 in combinations(sorted(all_props), 2):
                neg_patterns[(p1, p2)] += 1
            
            # Multi-entity patterns - count each pattern only once per example
            seen_multi = set()
            for ent, pset in props.items():
                for rel_pred, rel_ent in rels.get(ent, []):
                    for my_prop in pset:
                        for their_prop in props.get(rel_ent, []):
                            pattern = (f"{my_prop}(E1)", f"{rel_pred}(E1,E2)", f"{their_prop}(E2)")
                            if pattern not in seen_multi:
                                neg_patterns[pattern] += 1
                                seen_multi.add(pattern)
            
            # SIBLING patterns - count EXAMPLES, not pairs
            seen_sibling = set()
            for parent_ent in props.keys():
                children = [(rel, child) for rel, child in rels.get(parent_ent, [])]
                if len(children) >= 2:
                    for i, (rel1, child1) in enumerate(children):
                        for rel2, child2 in children[i+1:]:
                            if rel1 == rel2:
                                for prop1 in props.get(child1, []):
                                    for prop2 in props.get(child2, []):
                                        if prop1 != prop2:
                                            p1, p2 = sorted([prop1, prop2])
                                            pattern = ("SIBLING", rel1, p1, p2)
                                            if pattern not in seen_sibling:
                                                neg_patterns[pattern] += 1
                                                seen_sibling.add(pattern)
        
        # Calculate discriminative scores
        all_patterns = set(pos_patterns.keys()) | set(neg_patterns.keys())
        scored_patterns = []
        
        for pattern in all_patterns:
            pos_c = pos_patterns.get(pattern, 0)
            neg_c = neg_patterns.get(pattern, 0)
            total = pos_c + neg_c
            if total < 3:  # Skip rare patterns
                continue
            score = (pos_c - neg_c) / total
            scored_patterns.append((pattern, score, pos_c, neg_c))
        
        # Sort by absolute score (most discriminative first)
        scored_patterns.sort(key=lambda x: abs(x[1]), reverse=True)
        
        # Build output
        lines = [
            "% DISCRIMINATIVE PATTERNS (Multi-Predicate Analysis)",
            "% ----------------------------------------",
            "% Patterns that distinguish POSITIVE from NEGATIVE examples:",
            "% Score > 0 = correlates with POSITIVE, < 0 = correlates with NEGATIVE"
        ]
        
        # Show top patterns by type
        pair_patterns = [(p, s, pc, nc) for p, s, pc, nc in scored_patterns 
                        if isinstance(p, tuple) and len(p) == 2 and p[0] != "SIBLING"]
        multi_patterns = [(p, s, pc, nc) for p, s, pc, nc in scored_patterns 
                         if isinstance(p, tuple) and len(p) == 3 and p[0] != "SIBLING"]
        sibling_patterns = [(p, s, pc, nc) for p, s, pc, nc in scored_patterns 
                           if isinstance(p, tuple) and len(p) == 4 and p[0] == "SIBLING"]
        
        if pair_patterns:
            lines.append("")
            lines.append("% Predicate PAIRS (appear together in examples):")
            for pattern, score, pc, nc in pair_patterns[:6]:
                relevance = "POSITIVE++" if score > 0.5 else "POSITIVE+" if score > 0.2 else \
                           "NEGATIVE++" if score < -0.5 else "NEGATIVE+" if score < -0.2 else "NEUTRAL"
                lines.append(f"%   ({pattern[0]}, {pattern[1]}): {score:+.2f} ({relevance}) [Pos:{pc} Neg:{nc}]")
        
        if multi_patterns:
            lines.append("")
            lines.append("% Parent-Child PATTERNS (entity -> related entity):")
            for pattern, score, pc, nc in multi_patterns[:6]:
                relevance = "POSITIVE++" if score > 0.5 else "POSITIVE+" if score > 0.2 else \
                           "NEGATIVE++" if score < -0.5 else "NEGATIVE+" if score < -0.2 else "NEUTRAL"
                pattern_str = " & ".join(pattern)
                lines.append(f"%   {pattern_str}")
                lines.append(f"%     -> {score:+.2f} ({relevance}) [Pos:{pc} Neg:{nc}]")
        
        if sibling_patterns:
            lines.append("")
            lines.append("% ═══════════════════════════════════════════════════════════════")
            lines.append("% SIBLING PATTERNS - CRITICAL FOR MULTI-VARIABLE RULES!")
            lines.append("% These patterns require TWO different related entities.")
            lines.append("% ═══════════════════════════════════════════════════════════════")
            
            # Show only patterns with score >= 0.8 and at least 3 positives
            strong_sibling = [(p, s, pc, nc) for p, s, pc, nc in sibling_patterns if s >= 0.8 and pc >= 3]
            
            for pattern, score, pc, nc in strong_sibling[:10]:
                rel, prop1, prop2 = pattern[1], pattern[2], pattern[3]
                if nc == 0:
                    lines.append(f"% ★ SAFE PATTERN (0 negatives):")
                    lines.append(f"%   f(A) :- {rel}(A,B), {prop1}(B), {rel}(A,C), {prop2}(C).")
                    lines.append(f"%   Covers {pc} positives, {nc} negatives")
                else:
                    lines.append(f"%   {rel}(X,Y1), {prop1}(Y1), {rel}(X,Y2), {prop2}(Y2)")
                    lines.append(f"%     -> {score:+.2f} [Pos:{pc} Neg:{nc}]")
        
        # Add explicit warning about single-entity patterns
        lines.append("")
        lines.append("% ═══════════════════════════════════════════════════════════════")
        lines.append("% WARNING: Single-entity patterns (one variable) are often TOO GENERAL!")
        lines.append("% Prefer SIBLING patterns with TWO different entities (B and C).")
        lines.append("% ═══════════════════════════════════════════════════════════════")
        
        return "\n".join(lines)
    
    def _build_grounded_examples(self, examples: List[str] = None) -> str:
        """
        Show grounded examples that cover the MOST predicates from BK.
        Find examples with maximum predicate diversity to show full data structure.
        """
        if not examples:
            return ""
        
        pos_examples = [ex for ex in examples if ex.startswith('pos(')]
        neg_examples = [ex for ex in examples if ex.startswith('neg(')]
        
        if not pos_examples or not neg_examples:
            return ""
        
        import re
        
        # Extract entity from example
        def extract_entity(ex):
            match = re.search(r'(?:pos|neg)\((.+)\)\.?', ex)
            return match.group(1) if match else ex
        
        # Get all predicates in the BK (with scan limit for large files)
        MAX_LINES_FOR_PRED_SCAN = 50000
        all_predicates = set()
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f):
                if i >= MAX_LINES_FOR_PRED_SCAN:
                    break
                line = line.strip()
                if line and not line.startswith('%') and '(' in line:
                    pred = line.split('(')[0]
                    all_predicates.add(pred)
        
        # Find example with MOST predicate coverage
        def get_predicate_coverage(example):
            entity = extract_entity(example)
            facts = self._get_all_related_facts(entity)
            preds_covered = set()
            for fact in facts:
                if '(' in fact:
                    pred = fact.split('(')[0]
                    preds_covered.add(pred)
            return preds_covered, facts
        
        # Find best positive (most predicate coverage)
        best_pos = None
        best_pos_preds = set()
        best_pos_facts = []
        for ex in pos_examples[:50]:  # Sample to avoid slow scan
            preds, facts = get_predicate_coverage(ex)
            if len(preds) > len(best_pos_preds):
                best_pos = ex
                best_pos_preds = preds
                best_pos_facts = facts
        
        # Find best negative (most predicate coverage)
        best_neg = None
        best_neg_preds = set()
        best_neg_facts = []
        for ex in neg_examples[:50]:
            preds, facts = get_predicate_coverage(ex)
            if len(preds) > len(best_neg_preds):
                best_neg = ex
                best_neg_preds = preds
                best_neg_facts = facts
        
        lines = [
            "% GROUNDED EXAMPLES - Maximum Predicate Coverage",
            "% " + "=" * 60,
            f"% Total predicates in BK: {len(all_predicates)}"
        ]
        
        # BEST POSITIVE (most diverse)
        lines.append("")
        lines.append("% [POSITIVE] Best coverage example")
        lines.append(f"% Example: {best_pos}")
        lines.append(f"% Predicates covered: {len(best_pos_preds)}/{len(all_predicates)}")
        lines.append(f"% Covered: {', '.join(sorted(best_pos_preds))}")
        lines.append("% BK facts:")
        for fact in best_pos_facts:
            lines.append(fact)
        
        # BEST NEGATIVE (most diverse)
        lines.append("")
        lines.append("% [NEGATIVE] Best coverage example")
        lines.append(f"% Example: {best_neg}")
        lines.append(f"% Predicates covered: {len(best_neg_preds)}/{len(all_predicates)}")
        lines.append(f"% Covered: {', '.join(sorted(best_neg_preds))}")
        lines.append("% BK facts:")
        for fact in best_neg_facts:
            lines.append(fact)
        
        lines.append("")
        lines.append("% " + "=" * 60)
        
        return "\n".join(lines)
    
    def _get_all_related_facts(self, entity_id: str, max_depth: int = 5) -> List[str]:
        """
        Get ALL BK facts related to an entity by following COMPLETE relational chains.
        E.g., for train t1: 
          - train(t1) -> finds c1 in has_car(t1,c1)
          - then finds ALL facts with c1: has_load(c1,l1), short(c1), two_wheels(c1)
          - then finds ALL facts with l1: circle(l1), etc.
        """
        import re
        
        # Extract initial IDs from the entity (e.g., 't1000' from 'f(t1000)' or '0' from 'zendo(0)')
        # Generic extraction: get argument(s) inside any predicate pattern like pred(arg) or pred(arg1,arg2)
        match = re.search(r'\w+\(([^)]+)\)', entity_id)
        if match:
            args_str = match.group(1)
            # Extract all arguments (could be numeric like '0' or alphanumeric like 't1000')
            args = [a.strip() for a in args_str.split(',')]
            # Filter out empty strings
            args = [a for a in args if a]
            main_entity = args[0] if args else None
        else:
            # Fallback: extract alphanumeric IDs
            ids = re.findall(r'\b([a-z][a-z0-9_]*)\b', entity_id)
            ids = [x for x in ids if x not in ('f', 'goal', 'target', 'zendo')]
            main_entity = ids[0] if ids else None
        
        if not main_entity:
            return []
        
        initial_ids = {main_entity}
        
        # Read BK facts with limit for large datasets
        MAX_BK_FACTS_FOR_CHAINS = 30000
        all_bk_facts = []
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f):
                if i >= MAX_BK_FACTS_FOR_CHAINS:
                    break
                line = line.strip()
                if line and not line.startswith('%'):
                    all_bk_facts.append(line)
        
        # Collect all predicate names (appear before '(' in facts) - these are NOT entity IDs
        predicate_names = set()
        for fact in all_bk_facts:
            if '(' in fact:
                pred = fact.split('(')[0]
                predicate_names.add(pred)
        
        # Helper function to extract ONLY argument IDs from a fact (NOT predicate names)
        def extract_argument_ids(text):
            # Get content inside parentheses
            match = re.search(r'\((.+)\)', text)
            if not match:
                return set()
            args_str = match.group(1)
            # Extract IDs from arguments - both alphanumeric (t1, p0_2) and numeric (0, 1, 100)
            # Split by comma and extract clean tokens
            ids = set()
            for arg in args_str.split(','):
                arg = arg.strip()
                # Match alphanumeric IDs like t1, p0_2, c1
                alpha_ids = re.findall(r'\b([a-z][a-z0-9_]*)\b', arg)
                ids.update(alpha_ids)
                # Match pure numeric IDs like 0, 1, 100
                if arg.isdigit():
                    ids.add(arg)
            return ids
        
        # Build index: entity_id -> list of facts containing that ID as an ARGUMENT
        entity_to_facts = defaultdict(list)
        for fact in all_bk_facts:
            fact_ids = extract_argument_ids(fact)
            for fid in fact_ids:
                if fid not in ('f', 'goal', 'target') and fid not in predicate_names:
                    entity_to_facts[fid].append(fact)
        
        # BFS to follow ALL relational chains
        known_ids = set(initial_ids)
        facts_found = []
        facts_set = set()  # Avoid duplicates
        ids_to_process = list(initial_ids)
        
        for depth in range(max_depth):
            if not ids_to_process:
                break
                
            next_ids = []
            for current_id in ids_to_process:
                # Get ALL facts containing EXACTLY this ID
                for fact in entity_to_facts.get(current_id, []):
                    if fact in facts_set:
                        continue
                    
                    facts_found.append(fact)
                    facts_set.add(fact)
                    
                    # Extract NEW IDs from this fact to follow (only arguments, not predicates)
                    fact_ids = extract_argument_ids(fact)
                    new_ids = fact_ids - known_ids - {'f', 'goal', 'target'} - predicate_names
                    for new_id in new_ids:
                        if new_id not in known_ids:
                            next_ids.append(new_id)
                            known_ids.add(new_id)
                    
                    if len(facts_found) >= 100:  # Limit total facts
                        break
                
                if len(facts_found) >= 100:
                    break
            
            ids_to_process = next_ids
            if len(facts_found) >= 100:
                break
        
        return facts_found

    def _build_header(self) -> str:
        """Build header with BK statistics."""
        p = self.profile
        return f"""% ============================================
% BACKGROUND KNOWLEDGE SUMMARY
% ============================================
% Original size: {p.bk_size_bytes:,} bytes ({p.bk_line_count:,} lines)
% Predicates: {p.predicate_count}
% Examples: {p.pos_count} positive, {p.neg_count} negative
% Strategy: Summarized (large dataset mode)
% ============================================"""
    
    def _build_schema_summary(self) -> str:
        """Build schema summary with predicate statistics."""
        pred_info = self._get_predicate_info()
        
        lines = ["% PREDICATE SCHEMA (name/arity: count)"]
        lines.append("% " + "-" * 40)
        
        # Sort by count (most common first)
        sorted_preds = sorted(pred_info.values(), 
                              key=lambda x: x.count, reverse=True)
        
        for info in sorted_preds:
            lines.append(f"% {info.signature}: {info.count} facts")
        
        return "\n".join(lines)
    
    def _get_predicate_info(self) -> Dict[str, PredicateInfo]:
        """Parse BK to extract predicate information."""
        if self._predicate_info is not None:
            return self._predicate_info
        
        predicates: Dict[str, Dict] = defaultdict(
            lambda: {'name': '', 'arity': 0, 'count': 0, 'samples': []}
        )
        
        if not os.path.exists(self.bk_path):
            self._predicate_info = {}
            return self._predicate_info
        
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith(('%', ':-')):
                    continue
                
                # Parse fact: pred(arg1, arg2, ...).
                match = re.match(r'(\w+)\(([^)]*)\)\.', line)
                if match:
                    pred_name = match.group(1)
                    args = match.group(2)
                    arity = len([a for a in args.split(',') if a.strip()]) if args.strip() else 0
                    
                    key = f"{pred_name}/{arity}"
                    predicates[key]['name'] = pred_name
                    predicates[key]['arity'] = arity
                    predicates[key]['count'] += 1
                    
                    # Keep up to 5 samples per predicate
                    if len(predicates[key]['samples']) < 5:
                        predicates[key]['samples'].append(line)
        
        # Convert to PredicateInfo objects
        self._predicate_info = {
            key: PredicateInfo(
                name=data['name'],
                arity=data['arity'],
                count=data['count'],
                sample_facts=data['samples']
            )
            for key, data in predicates.items()
        }
        
        return self._predicate_info
    
    def _build_entity_index(self) -> Dict[str, Set[str]]:
        """Build index: entity -> set of facts containing it."""
        if self._entity_index is not None:
            return self._entity_index
        
        self._entity_index = defaultdict(set)
        
        if not os.path.exists(self.bk_path):
            return self._entity_index
        
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith(('%', ':-')):
                    continue
                
                # Extract all entity references (lowercase identifiers)
                entities = re.findall(r'\b([a-z][a-z0-9_]*)\b', line)
                for entity in entities:
                    # Skip predicate names (first match before '(')
                    if '(' in line and entity == line.split('(')[0]:
                        continue
                    self._entity_index[entity].add(line)
        
        return self._entity_index
    
    def _extract_relevant_facts(self, 
                                examples: List[str],
                                max_facts: int = 200,
                                max_depth: int = 2) -> str:
        """
        Extract BK facts relevant to given examples using relational chaining.
        
        For trains2: f(t800) → has_car(t800, C) → has_load(C, L) → circle(L)
        
        Args:
            examples: List of example atoms (e.g., ["f(t800)", "f(t297)"])
            max_facts: Maximum facts to include
            max_depth: How many relational hops to follow
        """
        if not examples:
            return ""
        
        # Extract initial entities from examples
        entities = set()
        for ex in examples[:20]:  # Sample first 20 examples
            # Extract entities like t800, t297, etc.
            found = re.findall(r'\b([a-z][a-z0-9_]*)\b', ex)
            entities.update(found)
        
        # Follow relational chains
        all_facts = set()
        current_entities = entities.copy()
        
        for depth in range(max_depth):
            new_entities = set()
            
            with open(self.bk_path, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith(('%', ':-')):
                        continue
                    
                    # Check if any current entity appears in this fact
                    for entity in current_entities:
                        if entity in line:
                            all_facts.add(line)
                            # Extract new entities from this fact
                            found = re.findall(r'\b([a-z][a-z0-9_]*)\b', line)
                            new_entities.update(found)
                            break
                    
                    if len(all_facts) >= max_facts:
                        break
            
            if len(all_facts) >= max_facts:
                break
            
            # Remove predicates from entity set, keep only args
            current_entities = new_entities - entities
            entities.update(new_entities)
        
        if not all_facts:
            return ""
        
        # Group facts by predicate for readability
        grouped: Dict[str, List[str]] = defaultdict(list)
        for fact in sorted(all_facts):
            pred = fact.split('(')[0] if '(' in fact else 'other'
            grouped[pred].append(fact)
        
        lines = [f"% EXAMPLE-RELEVANT FACTS ({len(all_facts)} facts from {len(examples)} examples)"]
        lines.append("% " + "-" * 40)
        
        for pred in sorted(grouped.keys()):
            facts = grouped[pred]
            lines.append(f"% --- {pred} ({len(facts)} facts) ---")
            for fact in facts[:30]:  # Limit per predicate
                lines.append(fact)
            if len(facts) > 30:
                lines.append(f"% ... and {len(facts) - 30} more {pred} facts")
        
        return "\n".join(lines)
    
    def _build_stratified_sample(self, samples_per_pred: int = 5) -> str:
        """Build stratified sample: N facts per predicate."""
        pred_info = self._get_predicate_info()
        
        lines = [f"% STRATIFIED SAMPLE ({samples_per_pred} facts per predicate)"]
        lines.append("% " + "-" * 40)
        
        for key in sorted(pred_info.keys()):
            info = pred_info[key]
            lines.append(f"% --- {info.signature} ({info.count} total) ---")
            for fact in info.sample_facts:
                lines.append(fact)
        
        return "\n".join(lines)
    
    def get_examples_for_prompt(self, max_pos: int = 100, max_neg: int = 100) -> Tuple[str, dict]:
        """
        Get examples optimized for LLM prompt.
        
        Small example sets: Returns ALL examples (unchanged behavior)
        Large example sets: Returns stratified sample with statistics
        
        Args:
            max_pos: Maximum positive examples to include
            max_neg: Maximum negative examples to include
            
        Returns:
            Tuple of (examples_text, stats_dict)
        """
        if not os.path.exists(self.exs_path):
            return "", {"pos_total": 0, "neg_total": 0, "pos_shown": 0, "neg_shown": 0}
        
        pos_examples = []
        neg_examples = []
        
        with open(self.exs_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('pos(') and line.endswith(').'):
                    pos_examples.append(line)
                elif line.startswith('neg(') and line.endswith(').'):
                    neg_examples.append(line)
        
        stats = {
            "pos_total": len(pos_examples),
            "neg_total": len(neg_examples),
            "pos_shown": len(pos_examples),
            "neg_shown": len(neg_examples),
            "sampled": False
        }
        
        # If not many examples, return all (preserve existing behavior)
        if not self.profile.has_many_examples:
            with open(self.exs_path, 'r', encoding='utf-8') as f:
                return f.read(), stats
        
        # LARGE EXAMPLE SET: Sample strategically
        stats["sampled"] = True
        
        # Sample positives: first N/2, last N/2 (to get diversity)
        if len(pos_examples) > max_pos:
            half = max_pos // 2
            sampled_pos = pos_examples[:half] + pos_examples[-half:]
            stats["pos_shown"] = len(sampled_pos)
        else:
            sampled_pos = pos_examples
        
        # Sample negatives: first N/2, last N/2
        if len(neg_examples) > max_neg:
            half = max_neg // 2
            sampled_neg = neg_examples[:half] + neg_examples[-half:]
            stats["neg_shown"] = len(sampled_neg)
        else:
            sampled_neg = neg_examples
        
        # Build output with clear headers
        lines = []
        lines.append(f"% ============================================")
        lines.append(f"% EXAMPLES (SAMPLED - {stats['pos_shown'] + stats['neg_shown']} of {stats['pos_total'] + stats['neg_total']} total)")
        lines.append(f"% ============================================")
        lines.append(f"% Positive: showing {stats['pos_shown']} of {stats['pos_total']}")
        lines.append(f"% Negative: showing {stats['neg_shown']} of {stats['neg_total']}")
        lines.append(f"% ============================================")
        lines.append("")
        
        # Add sampled positives
        lines.append("% --- POSITIVE EXAMPLES ---")
        for ex in sampled_pos:
            lines.append(ex)
        if stats["pos_shown"] < stats["pos_total"]:
            lines.append(f"% ... and {stats['pos_total'] - stats['pos_shown']} more positive examples")
        
        lines.append("")
        
        # Add sampled negatives
        lines.append("% --- NEGATIVE EXAMPLES ---")
        for ex in sampled_neg:
            lines.append(ex)
        if stats["neg_shown"] < stats["neg_total"]:
            lines.append(f"% ... and {stats['neg_total'] - stats['neg_shown']} more negative examples")
        
        return "\n".join(lines), stats
    
    def get_full_examples(self) -> str:
        """Get full examples content (for Prolog testing - never sampled)."""
        if os.path.exists(self.exs_path):
            with open(self.exs_path, 'r', encoding='utf-8') as f:
                return f.read()
        return ""
    
    def get_facts_for_entity(self, entity: str) -> List[str]:
        """Get all BK facts mentioning a specific entity."""
        facts = []
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if entity in line and not line.startswith(('%', ':-')):
                    facts.append(line)
        return facts
    
    def get_predicate_facts(self, predicate: str, limit: int = 100) -> List[str]:
        """Get facts for a specific predicate."""
        facts = []
        with open(self.bk_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith(f"{predicate}("):
                    facts.append(line)
                    if len(facts) >= limit:
                        break
        return facts


def create_adapter(task_dir: str) -> BKAdapter:
    """Factory function to create a BKAdapter."""
    return BKAdapter(task_dir)
