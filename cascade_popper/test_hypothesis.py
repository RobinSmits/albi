import argparse
import re
from collections import defaultdict
import os
import shutil
import subprocess
import tempfile
from typing import Dict, List, Set, Tuple, Union, Optional, NamedTuple

Atom = str
Number = Union[int, float]
Term = Union[Atom, Number]


class Literal(NamedTuple):
    pred: str
    args: Tuple[Term, ...]


class Clause(NamedTuple):
    head_pred: str
    head_args: Tuple[Term, ...]
    body: Tuple[Literal, ...]


FACT_RE = re.compile(r"^([a-zA-Z_][a-zA-Z0-9_]*)\((.*)\)\.$")


def parse_args(s: str) -> List[Term]:
    parts = [p.strip() for p in s.split(',') if p.strip()]
    out: List[Term] = []
    for p in parts:
        if re.fullmatch(r"-?\d+(?:\.\d+)?", p):
            out.append(float(p) if '.' in p else int(p))
        else:
            out.append(p)
    return out


def parse_term(s: str) -> Tuple[str, Tuple[Term, ...]]:
    s = s.strip()
    m = re.match(r"^([a-zA-Z_][a-zA-Z0-9_]*)\((.*)\)$", s)
    if not m:
        raise ValueError(f"Cannot parse term: {s}")
    functor = m.group(1)
    args_s = m.group(2).strip()
    if not args_s:
        return functor, tuple()
    args: List[Term] = []
    for a in split_top_level_commas(args_s):
        if re.fullmatch(r"-?\d+(?:\.\d+)?", a):
            args.append(float(a) if '.' in a else int(a))
        else:
            args.append(a)
    return functor, tuple(args)


def load_examples(exs_path: str) -> Tuple[List[Tuple[str, Tuple[Term, ...]]], List[Tuple[str, Tuple[Term, ...]]]]:
    pos: List[Tuple[str, Tuple[Term, ...]]] = []
    neg: List[Tuple[str, Tuple[Term, ...]]] = []
    with open(exs_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            m = re.match(r"^pos\((.*)\)\.$", line)
            if m:
                pos.append(parse_term(m.group(1)))
                continue
            m = re.match(r"^neg\((.*)\)\.$", line)
            if m:
                neg.append(parse_term(m.group(1)))
                continue
    return pos, neg


def load_bk(bk_path: str):
    piece_map: Dict[int, List[str]] = defaultdict(list)   # state -> pieces
    contact: Dict[str, Set[str]] = defaultdict(set)       # piece -> pieces
    piece_unary: Dict[str, Set[str]] = defaultdict(set)   # pred -> pieces
    attr: Dict[str, Dict[str, Number]] = defaultdict(dict)  # pred -> piece -> number
    num_unary: Dict[str, Set[Number]] = defaultdict(set)  # small/medium/large -> numbers

    with open(bk_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('%'):
                continue
            m = FACT_RE.match(line)
            if not m:
                continue
            pred = m.group(1)
            args = parse_args(m.group(2))

            if pred == 'piece' and len(args) == 2:
                st, pc = args
                if isinstance(st, int) and isinstance(pc, str):
                    piece_map[st].append(pc)
            elif pred == 'contact' and len(args) == 2:
                a, b = args
                if isinstance(a, str) and isinstance(b, str):
                    contact[a].add(b)
            elif pred in ('blue', 'green', 'red', 'upright', 'lhs', 'rhs', 'strange') and len(args) == 1:
                (x,) = args
                if isinstance(x, str):
                    piece_unary[pred].add(x)
            elif pred in ('size', 'coord1', 'coord2') and len(args) == 2:
                a, v = args
                if isinstance(a, str) and isinstance(v, (int, float)):
                    attr[pred][a] = v
            elif pred in ('small', 'medium', 'large') and len(args) == 1:
                (v,) = args
                if isinstance(v, (int, float)):
                    num_unary[pred].add(v)

    return piece_map, contact, piece_unary, attr, num_unary


def split_top_level_commas(s: str) -> List[str]:
    parts: List[str] = []
    cur: List[str] = []
    depth = 0
    for ch in s:
        if ch == '(':
            depth += 1
            cur.append(ch)
        elif ch == ')':
            depth = max(0, depth - 1)
            cur.append(ch)
        elif ch == ',' and depth == 0:
            part = ''.join(cur).strip()
            if part:
                parts.append(part)
            cur = []
        else:
            cur.append(ch)
    last = ''.join(cur).strip()
    if last:
        parts.append(last)
    return parts


def parse_hypothesis_file(path: str) -> List[Clause]:
    """Parses a hypothesis file containing clauses like:

        zendo(A) :- piece(A,B), blue(B).
        zendo(A) :- ...

    Returns list of clauses; each clause is list of Literal.

    Limitations:
    - only supports variables/atoms/numbers, no negation, no disjunction in body
    - assumes target predicate is zendo/1
    """
    clauses: List[Clause] = []

    with open(path, 'r', encoding='utf-8') as f:
        for raw in f:
            line = raw.strip()
            if not line:
                continue
            if line.startswith('%'):
                continue
            if not line.endswith('.'):
                raise ValueError(f"Clause does not end with '.': {line}")

            line = line[:-1].strip()  # drop trailing '.'

            if ':-' in line:
                head, body = [x.strip() for x in line.split(':-', 1)]
            else:
                head, body = line, ''

            head_pred, head_args = parse_term(head)

            lits: List[Literal] = []
            if body:
                for lit_s in split_top_level_commas(body):
                    m = re.match(r"^([a-zA-Z_][a-zA-Z0-9_]*)\((.*)\)$", lit_s)
                    if not m:
                        raise ValueError(f"Cannot parse literal: {lit_s}")
                    pred = m.group(1)
                    args_raw = [a.strip() for a in m.group(2).split(',') if a.strip()]
                    args: List[Term] = []
                    for a in args_raw:
                        if re.fullmatch(r"-?\d+(?:\.\d+)?", a):
                            args.append(float(a) if '.' in a else int(a))
                        else:
                            args.append(a)
                    lits.append(Literal(pred=pred, args=tuple(args)))
            clauses.append(Clause(head_pred=head_pred, head_args=head_args, body=tuple(lits)))

    if not clauses:
        raise ValueError("No clauses parsed from hypothesis file")

    return clauses


def is_var(x: str) -> bool:
    # Prolog variable: starts with uppercase letter or underscore.
    # Supports Popper-style variables like V0, V1, ...
    return bool(re.fullmatch(r"[A-Z_][A-Za-z0-9_]*", x))


def unify_head(head_args: Tuple[Term, ...], query_args: Tuple[Term, ...]) -> Optional[Dict[str, Term]]:
    if len(head_args) != len(query_args):
        return None
    subst: Dict[str, Term] = {}
    for h, q in zip(head_args, query_args):
        if isinstance(h, str) and is_var(h):
            if h in subst:
                if subst[h] != q:
                    return None
            else:
                subst[h] = q
        else:
            if h != q:
                return None
    return subst


def eval_clause(subst0: Dict[str, Term],
                clause: Tuple[Literal, ...],
                piece_map: Dict[int, List[str]],
                contact: Dict[str, Set[str]],
                piece_unary: Dict[str, Set[str]],
                attr: Dict[str, Dict[str, Number]],
                num_unary: Dict[str, Set[Number]]) -> bool:
    def bt(i: int, subst: Dict[str, Term]) -> bool:
        if i == len(clause):
            return True

        lit = clause[i]
        pred = lit.pred
        args = lit.args

        def val(t: Term) -> Term:
            if isinstance(t, str) and is_var(t) and t in subst:
                return subst[t]
            return t

        # piece/2: piece(State, Piece)
        if pred == 'piece':
            if len(args) != 2:
                return False

            a, b = args
            av = val(a)
            if not isinstance(av, int):
                return False
            pcs = piece_map.get(av, [])

            bv = val(b)
            if isinstance(b, str) and is_var(b) and b not in subst:
                for p in pcs:
                    subst2 = dict(subst)
                    subst2[b] = p
                    if bt(i + 1, subst2):
                        return True
                return False
            return isinstance(bv, str) and (bv in pcs) and bt(i + 1, subst)

        # contact/2: contact(Piece, Piece)
        if pred == 'contact':
            if len(args) != 2:
                return False
            x, y = args
            xv = val(x)
            if isinstance(x, str) and is_var(x) and x not in subst:
                return False
            if not isinstance(xv, str):
                return False

            ys = contact.get(xv, set())
            yv = val(y)
            if isinstance(y, str) and is_var(y) and y not in subst:
                for yy in ys:
                    subst2 = dict(subst)
                    subst2[y] = yy
                    if bt(i + 1, subst2):
                        return True
                return False
            return isinstance(yv, str) and (yv in ys) and bt(i + 1, subst)

        # unary piece preds
        if pred in ('blue', 'green', 'red', 'upright', 'lhs', 'rhs', 'strange'):
            if len(args) != 1:
                return False
            (x,) = args
            xv = val(x)
            if isinstance(x, str) and is_var(x) and x not in subst:
                return False
            return isinstance(xv, str) and (xv in piece_unary.get(pred, set())) and bt(i + 1, subst)

        # attributes: size/2, coord1/2, coord2/2
        if pred in ('size', 'coord1', 'coord2'):
            if len(args) != 2:
                return False
            x, v = args
            xv = val(x)
            if isinstance(x, str) and is_var(x) and x not in subst:
                return False
            if not isinstance(xv, str):
                return False
            if xv not in attr.get(pred, {}):
                return False
            actual = attr[pred][xv]

            vv = val(v)
            if isinstance(v, str) and is_var(v) and v not in subst:
                subst2 = dict(subst)
                subst2[v] = actual
                return bt(i + 1, subst2)
            return (vv == actual) and bt(i + 1, subst)

        # numeric category predicates: small/1, medium/1, large/1
        if pred in ('small', 'medium', 'large'):
            if len(args) != 1:
                return False
            (v,) = args
            vv = val(v)
            if isinstance(v, str) and is_var(v) and v not in subst:
                return False
            return isinstance(vv, (int, float)) and (vv in num_unary.get(pred, set())) and bt(i + 1, subst)

        raise ValueError(f"Unknown predicate in hypothesis: {pred}")

    return bt(0, dict(subst0))


def _prolog_quote_path(path: str) -> str:
    # Prolog single-quoted atom. Use forward slashes for SWI-Prolog on Windows.
    p = os.path.abspath(path).replace('\\', '/')
    p = p.replace("'", "''")
    return f"'{p}'"


def run_swi_prolog(bk_path: str, exs_path: str, hyp_path: str) -> Tuple[int, str]:
    swipl = shutil.which('swipl')
    if not swipl:
        raise RuntimeError('swipl not found on PATH')

    bk_q = _prolog_quote_path(bk_path)
    exs_q = _prolog_quote_path(exs_path)
    hyp_q = _prolog_quote_path(hyp_path)

    # This script assumes exs.pl defines pos/1 and neg/1 with callable goals.
    # We consult BK and hypothesis first, then examples.
    script = f""":- initialization(main).
main :-
  consult({bk_q}),
  consult({hyp_q}),
  consult({exs_q}),
  findall(E,(pos(E), \\+ call(E)),Missed),
  findall(E,(neg(E), call(E)),HitNeg),
  length(Missed,MP),
  length(HitNeg,HN),
  format('positives_missed_count=~w~n',[MP]),
  format('negatives_covered_count=~w~n',[HN]),
  write('missed_pos='), write_canonical(Missed), nl,
  write('hit_neg='), write_canonical(HitNeg), nl,
  (MP=:=0, HN=:=0 -> halt(0) ; halt(1)).
"""

    with tempfile.NamedTemporaryFile('w', suffix='.pl', delete=False, encoding='utf-8') as tf:
        tf.write(script)
        script_path = tf.name

    try:
        cmd = [swipl, '-q', '-f', script_path]
        proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
        return proc.returncode, proc.stdout
    finally:
        try:
            os.remove(script_path)
        except OSError:
            pass


def entails(query: Tuple[str, Tuple[Term, ...]],
            program: List[Clause],
            piece_map: Dict[int, List[str]],
            contact: Dict[str, Set[str]],
            piece_unary: Dict[str, Set[str]],
            attr: Dict[str, Dict[str, Number]],
            num_unary: Dict[str, Set[Number]]) -> bool:
    q_pred, q_args = query
    for clause in program:
        if clause.head_pred != q_pred:
            continue
        subst0 = unify_head(clause.head_args, q_args)
        if subst0 is None:
            continue
        if eval_clause(subst0, clause.body, piece_map, contact, piece_unary, attr, num_unary):
            return True
    return False


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--task_dir', default=None, help='Task directory containing bk.pl and exs.pl')
    ap.add_argument('--bk', default='bk.pl')
    ap.add_argument('--exs', default='exs.pl')
    ap.add_argument('--hyp', required=True, help='Path to hypothesis .pl file')
    ap.add_argument('--engine', default='auto', choices=['auto', 'swi', 'python'])
    args = ap.parse_args()

    if args.task_dir:
        bk_path = args.task_dir.rstrip('\\/') + '\\bk.pl'
        exs_path = args.task_dir.rstrip('\\/') + '\\exs.pl'
    else:
        bk_path = args.bk
        exs_path = args.exs

    if args.engine in ('auto', 'swi'):
        if shutil.which('swipl'):
            rc, out = run_swi_prolog(bk_path, exs_path, args.hyp)
            print('=== Hypothesis Test (SWI-Prolog) ===')
            print(out.rstrip())
            print('PASS' if rc == 0 else 'FAIL')
            return 0 if rc == 0 else 1
        if args.engine == 'swi':
            raise SystemExit('swipl not found on PATH')

    pos, neg = load_examples(exs_path)
    piece_map, contact, piece_unary, attr, num_unary = load_bk(bk_path)
    program = parse_hypothesis_file(args.hyp)

    covered_pos = set()
    covered_neg = set()

    pos_set = set(pos)
    neg_set = set(neg)
    covered_pos: Set[Tuple[str, Tuple[Term, ...]]] = set()
    covered_neg: Set[Tuple[str, Tuple[Term, ...]]] = set()

    for ex in pos + neg:
        if entails(ex, program, piece_map, contact, piece_unary, attr, num_unary):
            if ex in pos_set:
                covered_pos.add(ex)
            else:
                covered_neg.add(ex)

    missed_pos = sorted(pos_set - covered_pos)
    hit_neg = sorted(covered_neg)

    print('=== Hypothesis Test ===')
    print(f'positives_total: {len(pos_set)}')
    print(f'positives_covered: {len(covered_pos)}')
    print(f'positives_missed: {len(missed_pos)}')
    if missed_pos:
        print('missed_pos:', missed_pos)

    print(f'negatives_total: {len(neg_set)}')
    print(f'negatives_covered (ERROR): {len(hit_neg)}')
    if hit_neg:
        print('hit_neg:', hit_neg)

    ok = (not missed_pos) and (not hit_neg)
    print('PASS' if ok else 'FAIL')
    return 0 if ok else 1


if __name__ == '__main__':
    raise SystemExit(main())
