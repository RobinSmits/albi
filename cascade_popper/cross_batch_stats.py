"""
Cross-Batch Coverage Statistics Collector

Collects coverage statistics for each batch hypothesis against all other batches.
Generates a prompt for LLM-guided hypothesis combination.

Usage:
    python cross_batch_stats.py --task_dir <path_to_task> [--partial_cover <hypothesis>]
"""

import os
import re
import sys
import json
import argparse
import subprocess
from pathlib import Path
from dataclasses import dataclass
from typing import List, Dict, Tuple, Optional

@dataclass
class BatchInfo:
    batch_id: str
    folder_path: str
    pos_examples: List[str]
    neg_examples: List[str]
    hypothesis: Optional[str]

@dataclass
class CoverageResult:
    pos_covered: int
    neg_covered: int
    total_pos: int
    total_neg: int

def find_batch_folders(task_dir: str) -> List[str]:
    """Find all batch folders (e.g., trains4_1, trains4_2, ...)"""
    task_name = os.path.basename(task_dir)
    parent_dir = os.path.dirname(task_dir)
    
    batch_folders = []
    for item in os.listdir(parent_dir):
        item_path = os.path.join(parent_dir, item)
        if os.path.isdir(item_path) and item.startswith(task_name + "_"):
            # Check if it has required files
            if os.path.exists(os.path.join(item_path, "bk.pl")) and \
               os.path.exists(os.path.join(item_path, "exs.pl")):
                batch_folders.append(item_path)
    
    return sorted(batch_folders)

def load_examples(exs_path: str) -> Tuple[List[str], List[str]]:
    """Load positive and negative examples from exs.pl"""
    pos_examples = []
    neg_examples = []
    
    with open(exs_path, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('pos('):
                match = re.match(r'pos\((.+)\)\.', line)
                if match:
                    pos_examples.append(match.group(1))
            elif line.startswith('neg('):
                match = re.match(r'neg\((.+)\)\.', line)
                if match:
                    neg_examples.append(match.group(1))
    
    return pos_examples, neg_examples

def load_hypothesis(batch_folder: str) -> Optional[str]:
    """Load hypothesis from solution.pl or hypothesis.pl"""
    for filename in ['solution.pl', 'hypothesis.pl']:
        filepath = os.path.join(batch_folder, filename)
        if os.path.exists(filepath):
            with open(filepath, 'r') as f:
                content = f.read().strip()
                # Extract actual clauses (skip comments)
                clauses = []
                for line in content.split('\n'):
                    line = line.strip()
                    if line and not line.startswith('%') and ':-' in line:
                        clauses.append(line)
                if clauses:
                    return '\n'.join(clauses)
    return None

def test_hypothesis_on_batch(hypothesis: str, batch_folder: str) -> CoverageResult:
    """Test a hypothesis against a batch's BK and examples using SWI-Prolog"""
    bk_path = os.path.join(batch_folder, "bk.pl")
    exs_path = os.path.join(batch_folder, "exs.pl")
    
    pos_examples, neg_examples = load_examples(exs_path)
    
    # Create temporary file with hypothesis
    temp_hyp = os.path.join(batch_folder, "_temp_hyp.pl")
    with open(temp_hyp, 'w') as f:
        f.write(hypothesis)
    
    try:
        # Build Prolog query to test coverage
        prolog_code = f'''
:- consult('{bk_path.replace(os.sep, "/")}').
:- consult('{temp_hyp.replace(os.sep, "/")}').

test_coverage :-
    findall(E, (member(E, {pos_examples}), call(f(E))), CoveredPos),
    findall(E, (member(E, {neg_examples}), call(f(E))), CoveredNeg),
    length(CoveredPos, PosCount),
    length(CoveredNeg, NegCount),
    format('POS_COVERED=~w~n', [PosCount]),
    format('NEG_COVERED=~w~n', [NegCount]),
    halt.

:- test_coverage.
'''
        
        # Run SWI-Prolog
        result = subprocess.run(
            ['swipl', '-g', 'true', '-t', 'halt'],
            input=prolog_code.encode('utf-8'),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=30
        )
        
        output = result.stdout.decode('utf-8', errors='ignore') + result.stderr.decode('utf-8', errors='ignore')
        
        pos_covered = 0
        neg_covered = 0
        
        for line in output.split('\n'):
            if 'POS_COVERED=' in line:
                pos_covered = int(line.split('=')[1])
            elif 'NEG_COVERED=' in line:
                neg_covered = int(line.split('=')[1])
        
        return CoverageResult(pos_covered, neg_covered, len(pos_examples), len(neg_examples))
    
    except Exception as e:
        print(f"Error testing hypothesis: {e}")
        return CoverageResult(0, 0, len(pos_examples), len(neg_examples))
    
    finally:
        if os.path.exists(temp_hyp):
            os.remove(temp_hyp)

def test_hypothesis_simple(hypothesis: str, batch_folder: str) -> CoverageResult:
    """Simpler test using test_hypothesis.py if available"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    test_script = os.path.join(script_dir, "test_hypothesis.py")
    
    if not os.path.exists(test_script):
        return test_hypothesis_on_batch(hypothesis, batch_folder)
    
    # Create temp hypothesis file
    temp_hyp = os.path.join(batch_folder, "_temp_hyp.pl")
    with open(temp_hyp, 'w') as f:
        f.write(hypothesis)
    
    try:
        result = subprocess.run(
            [sys.executable, test_script, 
             '--task_dir', batch_folder, 
             '--hyp', temp_hyp],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=60
        )
        result.stdout = result.stdout.decode('utf-8', errors='ignore')
        result.stderr = result.stderr.decode('utf-8', errors='ignore')
        
        output = result.stdout
        
        # Parse output
        pos_examples, neg_examples = load_examples(os.path.join(batch_folder, "exs.pl"))
        total_pos = len(pos_examples)
        total_neg = len(neg_examples)
        
        # Look for missed_pos count
        pos_missed = 0
        neg_covered = 0
        
        for line in output.split('\n'):
            if 'positives_missed_count=' in line:
                pos_missed = int(line.split('=')[1])
            elif 'negatives_covered_count=' in line:
                neg_covered = int(line.split('=')[1])
        
        pos_covered = total_pos - pos_missed
        
        return CoverageResult(pos_covered, neg_covered, total_pos, total_neg)
    
    except Exception as e:
        print(f"Error: {e}")
        return CoverageResult(0, 0, 0, 0)
    
    finally:
        if os.path.exists(temp_hyp):
            os.remove(temp_hyp)

def collect_batch_info(batch_folders: List[str]) -> List[BatchInfo]:
    """Collect information about all batches"""
    batches = []
    
    for folder in batch_folders:
        batch_id = os.path.basename(folder).split('_')[-1]
        pos_ex, neg_ex = load_examples(os.path.join(folder, "exs.pl"))
        hypothesis = load_hypothesis(folder)
        
        batches.append(BatchInfo(
            batch_id=batch_id,
            folder_path=folder,
            pos_examples=pos_ex,
            neg_examples=neg_ex,
            hypothesis=hypothesis
        ))
    
    return batches

def build_coverage_matrix(batches: List[BatchInfo]) -> Dict:
    """Build cross-batch coverage matrix"""
    matrix = {}
    
    for source_batch in batches:
        if not source_batch.hypothesis:
            continue
        
        clause_key = f"B{source_batch.batch_id}"
        matrix[clause_key] = {
            'clause': source_batch.hypothesis,
            'source_batch': source_batch.batch_id,
            'coverage': {}
        }
        
        print(f"\nTesting clause from Batch {source_batch.batch_id}...")
        
        for target_batch in batches:
            print(f"  vs Batch {target_batch.batch_id}...", end=" ")
            
            result = test_hypothesis_simple(
                source_batch.hypothesis, 
                target_batch.folder_path
            )
            
            matrix[clause_key]['coverage'][f"B{target_batch.batch_id}"] = {
                'pos': result.pos_covered,
                'neg': result.neg_covered,
                'total_pos': result.total_pos,
                'total_neg': result.total_neg
            }
            
            print(f"{result.pos_covered}/{result.total_pos} pos, {result.neg_covered}/{result.total_neg} neg")
    
    return matrix

def generate_llm_prompt(matrix: Dict, partial_cover: Optional[str] = None, 
                        partial_cover_stats: Optional[str] = None) -> str:
    """Generate LLM prompt with coverage statistics"""
    
    prompt = """# Hypothesis Combination Task

You are given coverage statistics for hypotheses learned on different batches.
Your task is to combine them into a complete hypothesis that covers all positives with 0 negatives.

"""
    
    if partial_cover:
        prompt += f"""## Partial Cover (already works on full dataset):
```prolog
{partial_cover}
```
"""
        if partial_cover_stats:
            prompt += f"**Full dataset coverage**: {partial_cover_stats}\n\n"
    
    prompt += """## Cross-Batch Coverage Matrix:

Each row shows how a clause (learned on one batch) performs on ALL batches.
Format: `pos_covered/neg_covered` | ✅ = own batch

| Clause ID | Clause | """
    
    # Get batch IDs for header
    if matrix:
        first_clause = list(matrix.values())[0]
        batch_ids = sorted(first_clause['coverage'].keys())
        prompt += " | ".join(batch_ids) + " |\n"
        prompt += "|" + "---|" * (len(batch_ids) + 2) + "\n"
        
        for clause_key, data in matrix.items():
            clause_short = data['clause'][:60] + "..." if len(data['clause']) > 60 else data['clause']
            clause_short = clause_short.replace('|', '\\|').replace('\n', ' ')
            
            row = f"| **{clause_key}** | `{clause_short}` |"
            
            for bid in batch_ids:
                cov = data['coverage'].get(bid, {'pos': 0, 'neg': 0, 'total_pos': 0, 'total_neg': 0})
                marker = "[x] " if bid == f"B{data['source_batch']}" else ""
                row += f" {marker}{cov['pos']}/{cov['neg']} |"
            
            prompt += row + "\n"
    
    prompt += """

## Full Clauses:

"""
    for clause_key, data in matrix.items():
        prompt += f"**{clause_key}** (from Batch {data['source_batch']}):\n```prolog\n{data['clause']}\n```\n\n"
    
    prompt += """## Task:
1. Analyze which clauses **generalize well** (high pos coverage across batches, 0 neg)
2. Identify clauses that **complement each other** (cover different positives)
3. Propose a **combined hypothesis** that:
   - Keeps any partial cover clause
   - Adds clauses that cover remaining positives with 0 negatives
   - Is minimal (fewest clauses needed)

Output your combined hypothesis in Prolog format:
```prolog
% Combined hypothesis
f(A) :- <clause1>.
f(A) :- <clause2>.
...
```
"""
    
    return prompt

def main():
    parser = argparse.ArgumentParser(description='Cross-Batch Coverage Statistics')
    parser.add_argument('--task_dir', required=True, help='Path to main task directory')
    parser.add_argument('--partial_cover', help='Partial cover hypothesis (Prolog clause)')
    parser.add_argument('--partial_stats', help='Partial cover stats (e.g., "312/500 pos, 0/500 neg")')
    parser.add_argument('--output', help='Output file for prompt', default='combination_prompt.md')
    parser.add_argument('--max_batches', type=int, default=0, help='Max batches to test (0=all)')
    parser.add_argument('--quick', action='store_true', help='Quick mode: test only batches with solutions')
    
    args = parser.parse_args()
    
    print(f"=== Cross-Batch Coverage Statistics ===")
    print(f"Task directory: {args.task_dir}")
    
    # Find batch folders
    batch_folders = find_batch_folders(args.task_dir)
    
    # Limit batches if requested
    if args.max_batches > 0:
        batch_folders = batch_folders[:args.max_batches]
        print(f"\nLimited to {args.max_batches} batches (use --max_batches 0 for all)")
    
    print(f"\nFound {len(batch_folders)} batch folders:")
    for bf in batch_folders:
        print(f"  - {os.path.basename(bf)}")
    
    if not batch_folders:
        print("ERROR: No batch folders found!")
        return
    
    # Collect batch info
    batches = collect_batch_info(batch_folders)
    
    batches_with_hyp = [b for b in batches if b.hypothesis]
    print(f"\nBatches with hypotheses: {len(batches_with_hyp)}/{len(batches)}")
    
    if not batches_with_hyp:
        print("ERROR: No batches have solutions!")
        return
    
    # Build coverage matrix
    print("\n=== Building Coverage Matrix ===")
    matrix = build_coverage_matrix(batches)
    
    # Generate prompt
    print("\n=== Generating LLM Prompt ===")
    prompt = generate_llm_prompt(matrix, args.partial_cover, args.partial_stats)
    
    # Save prompt
    output_path = os.path.join(args.task_dir, args.output)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(prompt)
    
    print(f"\nPrompt saved to: {output_path}")
    print("\n" + "="*50)
    print("PROMPT PREVIEW:")
    print("="*50)
    preview = prompt[:2000] + "..." if len(prompt) > 2000 else prompt
    print(preview.encode('ascii', 'replace').decode('ascii'))
    
    # Also save matrix as JSON
    json_path = os.path.join(args.task_dir, "coverage_matrix.json")
    with open(json_path, 'w') as f:
        json.dump(matrix, f, indent=2)
    print(f"\nMatrix saved to: {json_path}")

if __name__ == "__main__":
    main()
