"""
Native Prolog Inherit Test for BBSILP.

Tests all previous batch clauses against current batch examples in a SINGLE
Prolog subprocess call. Each clause is tagged with an ID so we can track
which batch it came from and what it covers.

Usage (standalone):
    python inherit_test.py <bk_path> <exs_path> <clauses_json>

Usage (as module):
    from inherit_test import test_inherited_clauses
    results = test_inherited_clauses(bk_path, pos_examples, neg_examples, clauses)
"""

import os
import re
import sys
import json
import shutil
import tempfile
import subprocess
from typing import List, Dict, Set, Tuple


def test_inherited_clauses(
    bk_path: str,
    pos_examples: Set[str],
    neg_examples: Set[str],
    clauses: List[Dict],
    timeout: int = 60
) -> List[Dict]:
    """
    Test all inherited clauses against batch examples in ONE Prolog call.

    Args:
        bk_path: Path to background knowledge file (bk.pl)
        pos_examples: Set of positive example inner goals (e.g. {"f(a)", "f(b)"})
        neg_examples: Set of negative example inner goals
        clauses: List of dicts with keys:
            - 'clause': the Prolog clause string
            - 'from_batch': batch ID this clause came from
            - 'clause_id': unique ID for this clause (e.g. "b1_c0")

    Returns:
        List of dicts, one per clause:
            - 'clause_id': the clause ID
            - 'clause': the clause string
            - 'from_batch': source batch ID
            - 'covered_pos': set of covered positive examples
            - 'covered_neg': set of covered negative examples
            - 'num_pos': number of positives covered
            - 'num_neg': number of negatives covered
    """
    if not clauses:
        return []

    if not shutil.which('swipl'):
        raise RuntimeError("SWI-Prolog (swipl) not found on PATH")

    # Write each clause to its own temp file so we can consult/unload per clause
    clause_files = []
    try:
        for c in clauses:
            clause_text = c['clause'].strip()
            if not clause_text.endswith('.'):
                clause_text += '.'
            with tempfile.NamedTemporaryFile(mode='w', suffix='.pl', delete=False, encoding='utf-8') as f:
                f.write(clause_text + '\n')
                clause_files.append(f.name)

        # Build the Prolog script
        script = _build_test_script(bk_path, pos_examples, neg_examples, clauses, clause_files)

        # Write script to temp file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.pl', delete=False, encoding='utf-8') as f:
            f.write(script)
            script_path = f.name

        try:
            cmd = ['swipl', '-q', '-f', script_path]
            proc = subprocess.run(
                cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                universal_newlines=True, timeout=timeout
            )
            output = proc.stdout
            return _parse_results(output, clauses)

        except subprocess.TimeoutExpired:
            print(f"inherit_test: Prolog timed out after {timeout}s")
            return _empty_results(clauses)
        except Exception as e:
            print(f"inherit_test: Error: {e}")
            return _empty_results(clauses)
        finally:
            try:
                os.remove(script_path)
            except:
                pass

    finally:
        for cf in clause_files:
            try:
                os.remove(cf)
            except:
                pass


def _build_test_script(
    bk_path: str,
    pos_examples: Set[str],
    neg_examples: Set[str],
    clauses: List[Dict],
    clause_files: List[str]
) -> str:
    """
    Build a Prolog script that:
    1. Loads BK once
    2. For each clause: consult its file, test all examples, unload it
    3. Outputs per-clause coverage tagged with clause_id
    """
    bk_escaped = bk_path.replace('\\', '/')

    lines = []
    lines.append(":- initialization(main).")
    lines.append("")
    lines.append("main :-")
    lines.append(f"  consult('{bk_escaped}'),")

    for i, (clause_info, clause_file) in enumerate(zip(clauses, clause_files)):
        clause_id = clause_info['clause_id']
        cf_escaped = clause_file.replace('\\', '/')
        lines.append(f"  test_clause('{clause_id}', '{cf_escaped}'),")

    lines.append("  halt.")
    lines.append("")

    # test_clause/2: consult, test examples, unload
    lines.append("test_clause(ClauseId, FilePath) :-")
    lines.append("  catch(")
    lines.append("    (consult(FilePath),")
    lines.append("     test_examples(ClauseId),")
    lines.append("     unload_file(FilePath)),")
    lines.append("    _Error,")
    lines.append("    true")
    lines.append("  ).")
    lines.append("")

    # test_examples/1: test all pos and neg
    pos_list = sorted(pos_examples)
    neg_list = sorted(neg_examples)

    lines.append("test_examples(ClauseId) :-")

    if not pos_list and not neg_list:
        lines.append("  true.")
    else:
        for ex in pos_list:
            safe_ex = _escape_prolog_atom(ex)
            lines.append(f"  (catch(call({ex}), _, fail) -> format('INHERIT_POS:~w:~w~n', [ClauseId, '{safe_ex}']) ; true),")

        for ex in neg_list:
            safe_ex = _escape_prolog_atom(ex)
            lines.append(f"  (catch(call({ex}), _, fail) -> format('INHERIT_NEG:~w:~w~n', [ClauseId, '{safe_ex}']) ; true),")

        lines.append("  true.")

    lines.append("")

    return "\n".join(lines)


def _escape_prolog_atom(s: str) -> str:
    """Escape a string for use inside Prolog single quotes."""
    return s.replace('\\', '\\\\').replace("'", "\\'")


def _empty_results(clauses: List[Dict]) -> List[Dict]:
    """Return empty results for all clauses."""
    return [{
        'clause_id': c['clause_id'],
        'clause': c['clause'],
        'from_batch': c['from_batch'],
        'covered_pos': set(),
        'covered_neg': set(),
        'num_pos': 0,
        'num_neg': 0
    } for c in clauses]


def _parse_results(output: str, clauses: List[Dict]) -> List[Dict]:
    """
    Parse Prolog output lines like:
        INHERIT_POS:b1_c0:f(a)
        INHERIT_NEG:b1_c0:f(x)
    """
    results = {}
    for c in clauses:
        results[c['clause_id']] = {
            'clause_id': c['clause_id'],
            'clause': c['clause'],
            'from_batch': c['from_batch'],
            'covered_pos': set(),
            'covered_neg': set(),
            'num_pos': 0,
            'num_neg': 0
        }

    for line in output.split('\n'):
        line = line.strip()
        if line.startswith('INHERIT_POS:'):
            parts = line.split(':', 2)
            if len(parts) == 3:
                clause_id = parts[1]
                example = re.sub(r'\s+', '', parts[2])
                if clause_id in results:
                    results[clause_id]['covered_pos'].add(example)
        elif line.startswith('INHERIT_NEG:'):
            parts = line.split(':', 2)
            if len(parts) == 3:
                clause_id = parts[1]
                example = re.sub(r'\s+', '', parts[2])
                if clause_id in results:
                    results[clause_id]['covered_neg'].add(example)

    for r in results.values():
        r['num_pos'] = len(r['covered_pos'])
        r['num_neg'] = len(r['covered_neg'])

    return list(results.values())


def prepare_clauses_from_hypotheses(batch_hypotheses: List[Dict]) -> List[Dict]:
    """
    Helper: Convert batch_hypotheses list into the clauses format needed by
    test_inherited_clauses. Deduplicates clauses — only keeps unique clauses,
    tracking the first batch they came from.

    Args:
        batch_hypotheses: List of dicts with 'batch_id' and 'hypothesis' keys

    Returns:
        List of unique clause dicts with 'clause', 'from_batch', 'clause_id'
    """
    clauses = []
    seen = set()
    uid = 0
    for bh in batch_hypotheses:
        batch_id = bh['batch_id']
        hyp = bh['hypothesis']
        hyp_clauses = [c.strip() for c in hyp.split('\n')
                       if c.strip() and c.strip().endswith('.') and not c.strip().startswith('%')]
        for clause in hyp_clauses:
            # Normalize whitespace for dedup comparison
            normalized = re.sub(r'\s+', ' ', clause).strip()
            if normalized not in seen:
                seen.add(normalized)
                clauses.append({
                    'clause': clause,
                    'from_batch': batch_id,
                    'clause_id': f"u{uid}"
                })
                uid += 1
    return clauses


# ═══ STANDALONE CLI ═══
if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Usage: python inherit_test.py <bk_path> <exs_path> <clauses_json>")
        print()
        print("  bk_path:      Path to bk.pl")
        print("  exs_path:     Path to exs.pl")
        print("  clauses_json: JSON file with list of {clause, from_batch, clause_id}")
        print()
        print("Example clauses_json:")
        print('  [{"clause": "f(A) :- head(A,1).", "from_batch": 1, "clause_id": "b1_c0"}]')
        sys.exit(1)

    bk_path = sys.argv[1]
    exs_path = sys.argv[2]
    clauses_json_path = sys.argv[3]

    # Load examples
    pos = set()
    neg = set()
    with open(exs_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = re.sub(r'\s+', '', line.strip())
            if line.startswith('pos('):
                match = re.match(r'pos\((.+)\)\.$', line)
                if match:
                    pos.add(match.group(1))
            elif line.startswith('neg('):
                match = re.match(r'neg\((.+)\)\.$', line)
                if match:
                    neg.add(match.group(1))

    # Load clauses
    with open(clauses_json_path, 'r', encoding='utf-8') as f:
        clauses = json.load(f)

    print(f"BK: {bk_path}")
    print(f"Examples: {len(pos)} pos, {len(neg)} neg")
    print(f"Clauses to test: {len(clauses)}")
    print()

    results = test_inherited_clauses(bk_path, pos, neg, clauses)

    for r in results:
        status = "SAFE" if r['num_neg'] == 0 and r['num_pos'] > 0 else ("UNSAFE" if r['num_neg'] > 0 else "NO COVERAGE")
        print(f"  [{r['clause_id']}] batch={r['from_batch']} | {r['num_pos']} pos, {r['num_neg']} neg | {status}")
        print(f"    {r['clause']}")

    # Summary
    safe = [r for r in results if r['num_neg'] == 0 and r['num_pos'] > 0]
    all_covered = set()
    for r in safe:
        all_covered.update(r['covered_pos'])
    print(f"\nSummary: {len(safe)}/{len(results)} safe clauses, covering {len(all_covered)}/{len(pos)} positives")
