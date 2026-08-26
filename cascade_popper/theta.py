# Python 3.6+ compatible
from dataclasses import dataclass
from typing import Dict, List, Optional, Sequence, Tuple, Iterable, Union, TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Type
import re

# ----------------------------
# Term / Atom / Clause objects
# ----------------------------

@dataclass(frozen=True)
class Var:
    """Logic variable (e.g., A, X)."""
    name: str

@dataclass(frozen=True)
class Const:
    """Constant symbol (e.g., a, bob, 3)."""
    name: str

@dataclass(frozen=True)
class Func:
    """Function symbol with arguments (e.g., f(X), cons(H,T))."""
    name: str
    args: Tuple["Term", ...]

Term = Union[Var, Const, Func]

@dataclass(frozen=True)
class Atom:
    pred: str
    args: Tuple

    @property
    def arity(self) -> int:
        return len(self.args)

@dataclass(frozen=True)
class Clause:
    """
    Definite clause: head :- body1, body2, ...
    For theta-subsumption of definite clauses:
      C1 subsumes C2 iff ∃θ: head(C1)θ = head(C2) AND body(C1)θ ⊆ body(C2)
    """
    head: Atom
    body: Tuple[Atom, ...] = ()

    def literals(self) -> Tuple[Atom, ...]:
        # Combined literals (for general use, not for subsumption)
        return (self.head,) + self.body


# ----------------------------
# Substitutions (only for vars in C1)
# ----------------------------

Subst = Dict["Var", "Term"]

def is_var(t: "Term") -> bool:
    return isinstance(t, Var)

def apply_subst_term(t: "Term", subst: Subst) -> "Term":
    # Apply substitution repeatedly (Var -> Term) until fixed point.
    while isinstance(t, Var) and t in subst:
        t = subst[t]
    if isinstance(t, Func):
        return Func(t.name, tuple(apply_subst_term(a, subst) for a in t.args))
    return t

def apply_subst_atom(a: Atom, subst: Subst) -> Atom:
    return Atom(a.pred, tuple(apply_subst_term(t, subst) for t in a.args))

def occurs_check(v, t, subst):
    """Optional occurs-check to avoid v = f(v). Safe to keep enabled."""
    t = apply_subst_term(t, subst)
    if t == v:
        return True
    if isinstance(t, Func):
        return any(occurs_check(v, arg, subst) for arg in t.args)
    return False

def bind_var(v, t, subst, do_occurs_check=True):
    """Return extended subst if consistent, else None."""
    t = apply_subst_term(t, subst)
    # If binding v to itself, it's a no-op - just succeed
    if v == t:
        return subst
    if v in subst:
        # Already bound: must be consistent
        return unify_terms(subst[v], t, subst, do_occurs_check=do_occurs_check)
    if do_occurs_check and occurs_check(v, t, subst):
        return None
    new_subst = dict(subst)
    new_subst[v] = t
    return new_subst

def unify_terms(t1, t2, subst, do_occurs_check=True):
    """
    Unify t1 and t2 by binding ONLY variables that appear in (the evolving) t1 side,
    i.e. we construct θ for C1 variables. Variables inside t2 are treated as symbols
    (allowed as binding targets) but never assigned.
    """
    t1 = apply_subst_term(t1, subst)
    t2 = t2  # do NOT apply subst to t2 (θ is for C1 only)

    if isinstance(t1, Var):
        return bind_var(t1, t2, subst, do_occurs_check=do_occurs_check)

    if isinstance(t1, Const):
        return subst if (isinstance(t2, Const) and t1.name == t2.name) else None

    if isinstance(t1, Func):
        if not (isinstance(t2, Func) and t1.name == t2.name and len(t1.args) == len(t2.args)):
            return None
        cur = subst
        for a1, a2 in zip(t1.args, t2.args):
            cur = unify_terms(a1, a2, cur, do_occurs_check=do_occurs_check)
            if cur is None:
                return None
        return cur

    return None

def unify_atoms(a1: Atom, a2: Atom, subst: Subst, do_occurs_check: bool = True) -> Optional[Subst]:
    """Unify atom a1 (from C1) with atom a2 (from C2) by binding vars in a1 only."""
    if a1.pred != a2.pred or a1.arity != a2.arity:
        return None
    cur = subst
    for t1, t2 in zip(a1.args, a2.args):
        cur = unify_terms(t1, t2, cur, do_occurs_check=do_occurs_check)
        if cur is None:
            return None
    return cur


# ----------------------------
# θ-subsumption: C1 subsumes C2?
# ----------------------------

def clause_subsumes(c1: Clause, c2: Clause, do_occurs_check: bool = True) -> bool:
    """
    Theta-subsumption for definite (Horn) clauses.
    True iff ∃θ such that:
      1. head(C1)θ = head(C2)  (heads must match exactly)
      2. body(C1)θ ⊆ body(C2)  (body literals must be subset)
    
    This is the correct semantics per Oxford ILP / Plotkin's definition.
    """
    # Step 1: Match heads - head(C1)θ must equal head(C2)
    head_subst = unify_atoms(c1.head, c2.head, {}, do_occurs_check=do_occurs_check)
    if head_subst is None:
        return False
    
    # Step 2: Check body(C1)θ ⊆ body(C2)
    # If C1 has no body, subsumption holds (empty set is subset of any set)
    if not c1.body:
        return True
    
    # Index C2 body literals by predicate/arity for faster candidate lookup
    index: Dict[Tuple[str, int], List[Atom]] = {}
    for lit in c2.body:
        index.setdefault((lit.pred, lit.arity), []).append(lit)
    
    c1_body = list(c1.body)
    
    # Heuristic: match the most "selective" literals first (fewest candidates)
    def cand_count(lit: Atom) -> int:
        return len(index.get((lit.pred, lit.arity), []))
    c1_body.sort(key=cand_count)
    
    def backtrack(i: int, subst: Subst) -> bool:
        if i == len(c1_body):
            return True
        lit1 = apply_subst_atom(c1_body[i], subst)
        candidates = index.get((lit1.pred, lit1.arity), [])
        if not candidates:
            return False
        for lit2 in candidates:
            new_subst = unify_atoms(lit1, lit2, subst, do_occurs_check=do_occurs_check)
            if new_subst is not None and backtrack(i + 1, new_subst):
                return True
        return False
    
    return backtrack(0, head_subst)

def theory_subsumes(t1: Sequence[Clause], t2: Sequence[Clause]) -> bool:
    """
    Midelfart-style theory subsumption: T1 ⪯ T2 iff
    ∀C2 in T2, ∃C1 in T1 s.t. C1 subsumes C2.
    """
    for c2 in t2:
        if not any(clause_subsumes(c1, c2) for c1 in t1):
            return False
    return True


# ----------------------------
# Tiny Prolog-ish parser (optional helper)
# Supports:
#   f(A,B).
#   last(A,B):- head(A,B), odd(B).
# Variables: start with uppercase or underscore.
# Constants: start with lowercase/digit (treated as Const).
# No lists, no infix, no quoted atoms.
# ----------------------------

_token_re = re.compile(r"\s*([A-Za-z_][A-Za-z0-9_]*|:-|[(),.])\s*")

def tokenize(s: str) -> List[str]:
    pos = 0
    out = []
    while pos < len(s):
        m = _token_re.match(s, pos)
        if not m:
            raise ValueError(f"Cannot tokenize near: {s[pos:pos+30]!r}")
        out.append(m.group(1))
        pos = m.end()
    return out

class Parser:
    def __init__(self, tokens: List[str]):
        self.toks = tokens
        self.i = 0

    def peek(self) -> str:
        return self.toks[self.i] if self.i < len(self.toks) else ""

    def eat(self, t: str) -> None:
        if self.peek() != t:
            raise ValueError(f"Expected {t!r}, got {self.peek()!r}")
        self.i += 1

    def name(self) -> str:
        tok = self.peek()
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", tok):
            raise ValueError(f"Expected name, got {tok!r}")
        self.i += 1
        return tok

    def term(self) -> Term:
        n = self.name()
        if n[0].isupper() or n[0] == "_":
            return Var(n)
        # function or constant?
        if self.peek() == "(":
            self.eat("(")
            args = []
            if self.peek() != ")":
                args.append(self.term())
                while self.peek() == ",":
                    self.eat(",")
                    args.append(self.term())
            self.eat(")")
            return Func(n, tuple(args))
        return Const(n)

    def atom(self) -> Atom:
        pred = self.name()
        self.eat("(")
        args: List[Term] = []
        if self.peek() != ")":
            args.append(self.term())
            while self.peek() == ",":
                self.eat(",")
                args.append(self.term())
        self.eat(")")
        return Atom(pred, tuple(args))

    def clause(self) -> Clause:
        head = self.atom()
        if self.peek() == ".":
            self.eat(".")
            return Clause(head, ())
        self.eat(":-")
        body = [self.atom()]
        while self.peek() == ",":
            self.eat(",")
            body.append(self.atom())
        self.eat(".")
        return Clause(head, tuple(body))

def parse_clause(s: str) -> Clause:
    return Parser(tokenize(s)).clause()


# ----------------------------
# Test cases (based on Oxford ILP / Plotkin definitions)
# ----------------------------
if __name__ == "__main__":
    print("=" * 60)
    print("Theta-Subsumption Tests (Oxford ILP / Plotkin semantics)")
    print("=" * 60)
    
    # Test 1: Basic subsumption - more general subsumes more specific
    # C1 has fewer body literals, so C1θ ⊆ C2
    c1 = parse_clause("f(A,B):-head(A,B).")
    c2 = parse_clause("f(X,Y):-head(X,Y),odd(Y).")
    result = clause_subsumes(c1, c2)
    print(f"\nTest 1: f(A,B):-head(A,B) subsumes f(X,Y):-head(X,Y),odd(Y)?")
    print(f"  Result: {result} (expected: True)")
    assert result == True, "Test 1 failed!"
    
    # Test 2: Reverse should NOT hold (more specific cannot subsume more general)
    result = clause_subsumes(c2, c1)
    print(f"\nTest 2: f(X,Y):-head(X,Y),odd(Y) subsumes f(A,B):-head(A,B)?")
    print(f"  Result: {result} (expected: False)")
    assert result == False, "Test 2 failed!"
    
    # Test 3: Oxford ILP example - mem/2
    # C1: mem(A,[B|C]) :- mem(A,C).
    # C2: mem(0,[1,0]) :- nat(0), nat(1), mem(0,[0]).
    # C1 subsumes C2 with θ = {A/0, B/1, C/[0]}
    # Note: This requires list parsing which our simple parser doesn't support,
    # so we test with simpler atoms
    c1 = parse_clause("mem(A,B):-mem(A,C).")
    c2 = parse_clause("mem(zero,list):-nat(zero),nat(one),mem(zero,tail).")
    result = clause_subsumes(c1, c2)
    print(f"\nTest 3: mem(A,B):-mem(A,C) subsumes mem(zero,list):-nat(zero),nat(one),mem(zero,tail)?")
    print(f"  Result: {result} (expected: True)")
    assert result == True, "Test 3 failed!"
    
    # Test 4: Head mismatch - should NOT subsume (different predicates)
    c1 = parse_clause("p(X):-q(X).")
    c2 = parse_clause("r(a):-q(a).")
    result = clause_subsumes(c1, c2)
    print(f"\nTest 4: p(X):-q(X) subsumes r(a):-q(a)?")
    print(f"  Result: {result} (expected: False - heads don't match)")
    assert result == False, "Test 4 failed!"
    
    # Test 5: Fact subsumes clause with same head
    c1 = parse_clause("p(X).")
    c2 = parse_clause("p(a):-q(a),r(a).")
    result = clause_subsumes(c1, c2)
    print(f"\nTest 5: p(X). subsumes p(a):-q(a),r(a)?")
    print(f"  Result: {result} (expected: True - empty body is subset of any body)")
    assert result == True, "Test 5 failed!"
    
    # Test 6: Same clause subsumes itself (reflexivity)
    c1 = parse_clause("p(X,Y):-q(X),r(Y).")
    result = clause_subsumes(c1, c1)
    print(f"\nTest 6: p(X,Y):-q(X),r(Y) subsumes itself?")
    print(f"  Result: {result} (expected: True - reflexivity)")
    assert result == True, "Test 6 failed!"
    
    # Test 7: Body literal not present in C2 - should NOT subsume
    c1 = parse_clause("p(X):-q(X),r(X).")
    c2 = parse_clause("p(a):-q(a).")
    result = clause_subsumes(c1, c2)
    print(f"\nTest 7: p(X):-q(X),r(X) subsumes p(a):-q(a)?")
    print(f"  Result: {result} (expected: False - r(X) has no match)")
    assert result == False, "Test 7 failed!"
    
    print("\n" + "=" * 60)
    print("All tests passed!")
    print("=" * 60)
