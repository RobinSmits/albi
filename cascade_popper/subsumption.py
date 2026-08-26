"""
Formal θ-subsumption for Cascade-Popper.

A clause C1 θ-subsumes clause C2 if there exists a substitution θ such that:
  1. head(C1)θ = head(C2)  (heads must match)
  2. body(C1)θ ⊆ body(C2)  (body literals must be subset)

This follows the Oxford ILP / Plotkin definition for definite (Horn) clauses.

Key properties:
- If C1 subsumes C2, then C1 is MORE GENERAL than C2
- If a general clause C1 is too general (covers negatives), 
  any clause C2 subsumed by C1 is also too general → prune C2
"""

from typing import List, Dict, Tuple, Set, Optional
import re

# Import formal theta-subsumption implementation
from .theta import (
    Clause as ThetaClause,
    Atom as ThetaAtom,
    Var as ThetaVar,
    Const as ThetaConst,
    clause_subsumes as theta_clause_subsumes,
    parse_clause as theta_parse_clause
)


class Literal:
    """Represents a Prolog literal: predicate(arg1, arg2, ...)"""
    def __init__(self, predicate: str, args: List[str], negated: bool = False):
        self.predicate = predicate
        self.args = args
        self.negated = negated
    
    def __repr__(self):
        prefix = "\\+" if self.negated else ""
        return f"{prefix}{self.predicate}({','.join(self.args)})"
    
    def __eq__(self, other):
        return (self.predicate == other.predicate and 
                self.args == other.args and 
                self.negated == other.negated)
    
    def __hash__(self):
        return hash((self.predicate, tuple(self.args), self.negated))
    
    def is_variable(self, term: str) -> bool:
        """Check if a term is a variable (starts with uppercase or _)."""
        return bool(term) and (term[0].isupper() or term[0] == '_')
    
    def apply_substitution(self, theta: Dict[str, str]) -> 'Literal':
        """Apply substitution θ to this literal."""
        new_args = [theta.get(arg, arg) for arg in self.args]
        return Literal(self.predicate, new_args, self.negated)


class Clause:
    """Represents a Prolog clause: head :- body."""
    def __init__(self, head: Literal, body: List[Literal]):
        self.head = head
        self.body = body
    
    def __repr__(self):
        if self.body:
            body_str = ", ".join(str(lit) for lit in self.body)
            return f"{self.head} :- {body_str}."
        return f"{self.head}."
    
    def all_literals(self) -> List[Literal]:
        """Return head + body as a list of literals."""
        return [self.head] + self.body
    
    def get_variables(self) -> Set[str]:
        """Get all variables in the clause."""
        variables = set()
        for lit in self.all_literals():
            for arg in lit.args:
                if lit.is_variable(arg):
                    variables.add(arg)
        return variables


class SubsumptionChecker:
    """
    Checks θ-subsumption between clauses.
    
    Used for:
    1. Anti-subsumption: Reject new hypotheses subsumed by failed general clauses
    2. Redundancy elimination: Don't generate clauses that subsume existing ones
    """
    
    def __init__(self):
        self.failed_general_clauses: List[Clause] = []  # Too general (cover negatives)
        self.failed_specific_clauses: List[Clause] = []  # Too specific (miss positives)
    
    def parse_clause(self, clause_str: str) -> Optional[Clause]:
        """Parse a Prolog clause string into a Clause object."""
        clause_str = clause_str.strip()
        if clause_str.endswith('.'):
            clause_str = clause_str[:-1]
        
        # Split head and body
        if ':-' in clause_str:
            head_str, body_str = clause_str.split(':-', 1)
        else:
            head_str, body_str = clause_str, ''
        
        head = self._parse_literal(head_str.strip())
        if not head:
            return None
        
        body = []
        if body_str.strip():
            for lit_str in self._split_body(body_str):
                lit = self._parse_literal(lit_str.strip())
                if lit:
                    body.append(lit)
        
        return Clause(head, body)
    
    def _parse_literal(self, lit_str: str) -> Optional[Literal]:
        """Parse a literal string."""
        lit_str = lit_str.strip()
        negated = False
        
        if lit_str.startswith('\\+'):
            negated = True
            lit_str = lit_str[2:].strip()
        
        match = re.match(r'(\w+)\(([^)]*)\)', lit_str)
        if not match:
            return None
        
        predicate = match.group(1)
        args_str = match.group(2)
        args = [a.strip() for a in args_str.split(',')] if args_str else []
        
        return Literal(predicate, args, negated)
    
    def _split_body(self, body: str) -> List[str]:
        """Split body into literals, respecting parentheses."""
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
    
    def subsumes(self, c1: Clause, c2: Clause) -> bool:
        """
        Check if c1 θ-subsumes c2 using the formal theta.py implementation.
        
        Theta-subsumption for definite (Horn) clauses:
          c1 subsumes c2 iff ∃θ: head(c1)θ = head(c2) AND body(c1)θ ⊆ body(c2)
        
        This means c1 is MORE GENERAL than c2.
        """
        # Quick checks
        if len(c1.all_literals()) > len(c2.all_literals()):
            return False  # c1 has more literals, can't subsume
        
        if c1.head.predicate != c2.head.predicate:
            return False  # Different head predicates
        
        if len(c1.head.args) != len(c2.head.args):
            return False  # Different arities
        
        # Convert to theta.py format and use formal subsumption
        try:
            theta_c1 = self._to_theta_clause(c1)
            theta_c2 = self._to_theta_clause(c2)
            return theta_clause_subsumes(theta_c1, theta_c2)
        except Exception:
            # Fallback to legacy implementation if conversion fails
            return self._find_substitution(c1, c2) is not None
    
    def _to_theta_clause(self, clause: Clause) -> ThetaClause:
        """Convert local Clause to theta.py ThetaClause."""
        def to_theta_term(arg: str):
            """Convert argument string to theta.py Term."""
            if arg and (arg[0].isupper() or arg[0] == '_'):
                return ThetaVar(arg)
            return ThetaConst(arg)
        
        def to_theta_atom(lit: Literal) -> ThetaAtom:
            """Convert Literal to ThetaAtom."""
            args = tuple(to_theta_term(a) for a in lit.args)
            return ThetaAtom(lit.predicate, args)
        
        head = to_theta_atom(clause.head)
        body = tuple(to_theta_atom(lit) for lit in clause.body)
        return ThetaClause(head, body)
    
    def _find_substitution(self, c1: Clause, c2: Clause) -> Optional[Dict[str, str]]:
        """
        Legacy: Find substitution θ such that c1θ ⊆ c2.
        Uses backtracking search. Kept as fallback.
        """
        # Must map head to head first
        initial_theta = self._unify_literal(c1.head, c2.head, {})
        if initial_theta is None:
            return None
        
        # Now try to match each body literal of c1 to some body literal in c2
        return self._match_body(c1.body, c2.body, initial_theta)
    
    def _match_body(self, c1_body: List[Literal], c2_body: List[Literal], 
                    theta: Dict[str, str]) -> Optional[Dict[str, str]]:
        """Legacy: Match all c1 body literals to c2 body literals."""
        if not c1_body:
            return theta  # All matched
        
        lit1 = c1_body[0]
        remaining = c1_body[1:]
        
        # Try matching lit1 to each literal in c2_body
        for lit2 in c2_body:
            new_theta = self._unify_literal(lit1, lit2, theta.copy())
            if new_theta is not None:
                result = self._match_body(remaining, c2_body, new_theta)
                if result is not None:
                    return result
        
        return None
    
    def _unify_literal(self, lit1: Literal, lit2: Literal, 
                       theta: Dict[str, str]) -> Optional[Dict[str, str]]:
        """
        Legacy: Try to unify lit1 with lit2 under substitution theta.
        Only variables in lit1 can be substituted (one-way matching).
        """
        if lit1.predicate != lit2.predicate:
            return None
        if lit1.negated != lit2.negated:
            return None
        if len(lit1.args) != len(lit2.args):
            return None
        
        for arg1, arg2 in zip(lit1.args, lit2.args):
            if lit1.is_variable(arg1):
                # arg1 is a variable
                if arg1 in theta:
                    # Already bound - check consistency
                    if theta[arg1] != arg2:
                        return None
                else:
                    # Bind variable
                    theta[arg1] = arg2
            else:
                # arg1 is a constant - must match exactly
                if arg1 != arg2:
                    return None
        
        return theta
    
    def add_failed_general(self, clause_str: str):
        """Add a clause that was too general (covered negatives)."""
        clause = self.parse_clause(clause_str)
        if clause:
            self.failed_general_clauses.append(clause)
    
    def add_failed_specific(self, clause_str: str):
        """Add a clause that was too specific (missed positives)."""
        clause = self.parse_clause(clause_str)
        if clause:
            self.failed_specific_clauses.append(clause)
    
    def is_subsumed_by_failed_general(self, candidate_str: str) -> Tuple[bool, Optional[str]]:
        """
        Check if candidate should be pruned due to a failed general clause.
        
        Per Popper (Cropper & Morel 2021):
        - If H is too general (covers negatives), prune all H' where H' subsumes H
        - H' subsumes H means H' is MORE GENERAL than H
        - If H already covers negatives, any more general H' would also cover them
        
        So we check: does candidate subsume any failed_general?
        If yes, candidate is more general than a failed hypothesis -> prune it.
        
        Returns: (should_prune, failed_clause_str)
        """
        candidate = self.parse_clause(candidate_str)
        if not candidate:
            return False, None
        
        for failed in self.failed_general_clauses:
            if self.subsumes(candidate, failed):  # candidate is MORE GENERAL than failed
                return True, str(failed)
        
        return False, None
    
    def is_specialisation_of_failed_specific(self, candidate_str: str) -> Tuple[bool, Optional[str]]:
        """
        Check if candidate should be pruned due to a failed specific clause.
        
        Per Popper (Cropper & Morel 2021):
        - If H is too specific (misses positives), prune all H' where H subsumes H'
        - H subsumes H' means H is MORE GENERAL, H' is MORE SPECIFIC
        - If H already misses positives, any more specific H' would miss even more
        
        So we check: does any failed_specific subsume candidate?
        If yes, candidate is more specific than a failed hypothesis -> prune it.
        
        Returns: (should_prune, failed_clause_str)
        """
        candidate = self.parse_clause(candidate_str)
        if not candidate:
            return False, None
        
        for failed in self.failed_specific_clauses:
            if self.subsumes(failed, candidate):  # failed is MORE GENERAL, candidate is MORE SPECIFIC
                return True, str(failed)
        
        return False, None
    
    def reset(self):
        """Clear all stored clauses."""
        self.failed_general_clauses = []
        self.failed_specific_clauses = []
