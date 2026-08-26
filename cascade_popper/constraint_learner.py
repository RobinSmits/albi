"""
Constraint Learner for Cascade-Popper.
Analyzes hypothesis test failures and generates constraints to prune the search space.
"""

import re
from typing import List, Dict, Tuple, Set, Optional
from .cascade_generator import Constraint
from .subsumption import SubsumptionChecker


class TestResult:
    """Result of testing a hypothesis."""
    def __init__(self, hypothesis, covered_pos, missed_pos, covered_neg, is_consistent):
        self.hypothesis = hypothesis
        self.covered_pos = covered_pos
        self.missed_pos = missed_pos
        self.covered_neg = covered_neg
        self.is_consistent = is_consistent
    
    @property
    def is_too_general(self):
        """Covers negative examples."""
        return len(self.covered_neg) > 0
    
    @property
    def is_too_specific(self):
        """Misses positive examples."""
        return len(self.missed_pos) > 0 and len(self.covered_neg) == 0
    
    @property
    def is_complete(self):
        """Covers all positives and no negatives."""
        return len(self.missed_pos) == 0 and len(self.covered_neg) == 0


class ConstraintLearner:
    """
    Learns constraints from hypothesis test failures.
    
    Implements Popper's key innovation: instead of blindly trying the next
    hypothesis after a failure, analyze WHY it failed and create constraints
    to avoid similar failures.
    """
    
    def __init__(self):
        self.learned_constraints: List[Constraint] = []
        self.failed_patterns: Set[str] = set()
        self.subsumption_checker = SubsumptionChecker()
        
    def analyze_failure(self, result: TestResult, 
                       bk_predicates: List[Dict] = None) -> List[Constraint]:
        """
        Analyze a failed hypothesis and generate constraints.
        
        Args:
            result: TestResult from hypothesis testing
            bk_predicates: Background knowledge for deeper analysis
            
        Returns:
            List of learned constraints
        """
        constraints = []
        
        if result.is_too_general:
            constraints.extend(self._analyze_too_general(result, bk_predicates))
        elif result.is_too_specific:
            constraints.extend(self._analyze_too_specific(result, bk_predicates))
        
        self.learned_constraints.extend(constraints)
        return constraints
    
    def _analyze_too_general(self, result: TestResult, 
                            bk_predicates: List[Dict] = None) -> List[Constraint]:
        """
        Analyze hypothesis that covers negative examples.
        
        Key insight: The hypothesis is missing a discriminating literal
        that would exclude the negative examples while keeping positives.
        """
        constraints = []
        
        # Extract clause structure
        clause_info = self._parse_clause(result.hypothesis)
        if not clause_info:
            return constraints
        
        head_pred, body_literals = clause_info
        
        # Constraint 1: Subsumption - don't generate clauses subsumed by this one
        constraint = Constraint(
            constraint_type="anti_subsumption",
            description=f"Don't generate clauses that are more general than or equal to: {result.hypothesis}",
            prolog_encoding=f"anti_subsumes({self._clause_to_id(result.hypothesis)})",
            source_clause=result.hypothesis
        )
        constraints.append(constraint)
        
        # Constraint 2: Suggest specialization needed
        body_preds = [lit[0] for lit in body_literals]
        neg_count = len(result.covered_neg)
        
        constraint = Constraint(
            constraint_type="specialization",
            description=f"Clause with body [{', '.join(body_preds)}] covers {neg_count} negatives. "
                       f"Need additional discriminating literal(s) in body.",
            source_clause=result.hypothesis
        )
        constraints.append(constraint)
        
        # Track failed pattern
        pattern = self._extract_pattern(body_literals)
        self.failed_patterns.add(pattern)
        
        # Register for formal subsumption checking
        self.subsumption_checker.add_failed_general(result.hypothesis)
        
        return constraints
    
    def _analyze_too_specific(self, result: TestResult,
                             bk_predicates: List[Dict] = None) -> List[Constraint]:
        """
        Analyze hypothesis that misses positive examples.
        
        Key insight: The hypothesis is too restrictive. Either:
        1. Need a more general clause, or
        2. Need an additional clause for the missed cases
        """
        constraints = []
        
        clause_info = self._parse_clause(result.hypothesis)
        if not clause_info:
            return constraints
        
        head_pred, body_literals = clause_info
        
        # Constraint 1: Record that this exact pattern is too specific
        body_preds = [lit[0] for lit in body_literals]
        missed_count = len(result.missed_pos)
        covered_count = len(result.covered_pos)
        
        if covered_count == 0:
            # Clause covers nothing - completely wrong pattern
            constraint = Constraint(
                constraint_type="exclusion",
                description=f"Pattern [{', '.join(body_preds)}] covers no positives. Avoid this combination.",
                source_clause=result.hypothesis
            )
            constraints.append(constraint)
        else:
            # Clause covers some but not all - need additional clause
            constraint = Constraint(
                constraint_type="incomplete",
                description=f"Clause covers {covered_count} positives but misses {missed_count}. "
                           f"Need additional clause for alternative pattern.",
                source_clause=result.hypothesis
            )
            constraints.append(constraint)
        
        # Register for formal subsumption checking
        self.subsumption_checker.add_failed_specific(result.hypothesis)
        
        return constraints
    
    def check_subsumption_pruning(self, candidate: str) -> Tuple[bool, str]:
        """
        Check if candidate should be pruned due to subsumption constraints.
        
        Per Popper (Cropper & Morel 2021):
        1. Generalisation constraint: If H was too general (covered negatives),
           prune any H' that is MORE GENERAL than H (H' subsumes H)
        2. Specialisation constraint: If H was too specific (missed positives),
           prune any H' that is MORE SPECIFIC than H (H subsumes H')
        
        Returns: (should_prune, reason)
        """
        # Check generalisation constraint
        is_more_general, failed_clause = self.subsumption_checker.is_subsumed_by_failed_general(candidate)
        if is_more_general:
            return True, f"More general than failed clause (would also cover negatives): {failed_clause}"
        
        # Check specialisation constraint
        is_more_specific, failed_clause = self.subsumption_checker.is_specialisation_of_failed_specific(candidate)
        if is_more_specific:
            return True, f"More specific than failed clause (would miss even more positives): {failed_clause}"
        
        return False, ""
    
    def _parse_clause(self, clause: str) -> Optional[Tuple[str, List[Tuple[str, List[str]]]]]:
        """
        Parse a Prolog clause into head predicate and body literals.
        
        Returns:
            Tuple of (head_predicate, [(body_pred, [args]), ...])
        """
        clause = clause.strip()
        if clause.endswith('.'):
            clause = clause[:-1]
        
        # Split head and body
        if ':-' in clause:
            head, body = clause.split(':-', 1)
        else:
            head, body = clause, ''
        
        # Parse head
        head_match = re.match(r'(\w+)\(([^)]*)\)', head.strip())
        if not head_match:
            return None
        head_pred = head_match.group(1)
        
        # Parse body literals
        body_literals = []
        if body.strip():
            # Split by comma, respecting parentheses
            literals = self._split_literals(body)
            for lit in literals:
                lit_match = re.match(r'(\w+)\(([^)]*)\)', lit.strip())
                if lit_match:
                    pred = lit_match.group(1)
                    args = [a.strip() for a in lit_match.group(2).split(',')]
                    body_literals.append((pred, args))
        
        return head_pred, body_literals
    
    def _split_literals(self, body: str) -> List[str]:
        """Split body into individual literals, respecting parentheses."""
        literals = []
        current = []
        depth = 0
        
        for char in body:
            if char == '(':
                depth += 1
                current.append(char)
            elif char == ')':
                depth -= 1
                current.append(char)
            elif char == ',' and depth == 0:
                if current:
                    literals.append(''.join(current).strip())
                current = []
            else:
                current.append(char)
        
        if current:
            literals.append(''.join(current).strip())
        
        return literals
    
    def _extract_pattern(self, body_literals: List[Tuple[str, List[str]]]) -> str:
        """Extract a pattern signature from body literals."""
        preds = sorted([lit[0] for lit in body_literals])
        return ','.join(preds)
    
    def _clause_to_id(self, clause: str) -> str:
        """Generate a unique ID for a clause."""
        import hashlib
        return hashlib.md5(clause.encode()).hexdigest()[:8]
    
    def get_constraint_summary(self) -> str:
        """Get a summary of all learned constraints."""
        if not self.learned_constraints:
            return "No constraints learned yet."
        
        summary = f"Learned {len(self.learned_constraints)} constraints:\n"
        for i, c in enumerate(self.learned_constraints, 1):
            summary += f"  {i}. [{c.constraint_type}] {c.description}\n"
        
        return summary
    
    def get_constraints_for_prompt(self) -> List[Constraint]:
        """Get constraints formatted for prompt."""
        # Deduplicate and prioritize most recent constraints
        seen_types = {}
        for c in reversed(self.learned_constraints):
            key = (c.constraint_type, c.source_clause)
            if key not in seen_types:
                seen_types[key] = c
        
        return list(seen_types.values())
    
    def reset(self):
        """Reset learned constraints."""
        self.learned_constraints = []
        self.failed_patterns = set()
        self.subsumption_checker.reset()
