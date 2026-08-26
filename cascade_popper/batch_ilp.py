"""
BBSILP: Batch-Based Scalable ILP Algorithm

For tasks larger than zendo2 size (~87KB init prompt):
- Split examples into batches of 20 pos + 20 neg
- Learn hypotheses from batches (parallel or sequential)
- Early termination when generalizable rule found
- Merge & refine if no single batch works
- Select minimal hypothesis (MDL principle)

Batch structure (as seen in trains1_* folders):
- Each batch folder: {task}_{batch_num}/
- Contains: exs.pl (20+20), bk.pl (filtered), bias.pl
"""

import os
import re
import random
import time
from dataclasses import dataclass, field
from typing import List, Set, Optional, Tuple, Dict, Callable
from concurrent.futures import ThreadPoolExecutor, as_completed


@dataclass
class BBSILPConfig:
    """Configuration for BBSILP algorithm."""
    batch_size_pos: int = 20
    batch_size_neg: int = 20
    max_parallel_batches: int = 3  # Limited by LLM API rate
    early_termination: bool = True
    zendo2_threshold: int = 87000  # ~87KB (zendo2 BK + exs + bias)


@dataclass
class BatchInfo:
    """Information about a batch folder."""
    batch_id: int
    folder_path: str
    pos_examples: List[str]
    neg_examples: List[str]
    bk_content: str
    bias_content: str = ""


@dataclass
class BatchResult:
    """Result from learning on a single batch."""
    batch_id: int
    hypothesis: str
    batch_pos: List[str]
    batch_neg: List[str]
    covered_pos: Set[str] = field(default_factory=set)
    covered_neg: Set[str] = field(default_factory=set)
    is_generalizable: bool = False
    learning_time: float = 0.0
    folder_path: str = ""


@dataclass
class BBSILPResult:
    """Final result from BBSILP algorithm."""
    hypothesis: str
    is_solution: bool
    method: str  # "early_termination", "merge", "selection", "partial_cover"
    batches_processed: int
    total_time: float
    batch_results: List[BatchResult] = field(default_factory=list)


class BatchILPProcessor:
    """Implements the BBSILP algorithm for large ILP tasks."""
    
    def __init__(self, config: BBSILPConfig = None):
        self.config = config or BBSILPConfig()
    
    def is_large_task(self, init_prompt_size: int) -> bool:
        """Check if task exceeds zendo2 size threshold."""
        return init_prompt_size > self.config.zendo2_threshold
    
    def calculate_prompt_size(self, bk_content: str, exs_content: str, 
                               bias_content: str = "", template: str = "") -> int:
        """Calculate the formatted init_prompt size."""
        return len(bk_content) + len(exs_content) + len(bias_content) + len(template)
    
    # === BATCH DETECTION ===
    def find_existing_batches(self, task_dir: str) -> List[BatchInfo]:
        """Find pre-existing batch folders for a task (e.g., task/batch_1, task/batch_2, ...)."""
        batches = []
        
        # Look for folders matching pattern: batch_{num} INSIDE task_dir
        batch_pattern = re.compile(r'^batch_(\d+)$')
        
        if not os.path.exists(task_dir):
            return batches
        
        for folder in sorted(os.listdir(task_dir)):
            match = batch_pattern.match(folder)
            if match:
                batch_num = int(match.group(1))
                batch_path = os.path.join(task_dir, folder)
                
                if os.path.isdir(batch_path):
                    batch_info = self._load_batch_info(batch_num, batch_path)
                    if batch_info:
                        batches.append(batch_info)
        
        return sorted(batches, key=lambda b: b.batch_id)
    
    def _load_batch_info(self, batch_id: int, folder_path: str) -> Optional[BatchInfo]:
        """Load batch information from a folder."""
        exs_path = os.path.join(folder_path, "exs.pl")
        bk_path = os.path.join(folder_path, "bk.pl")
        bias_path = os.path.join(folder_path, "bias.pl")
        
        if not os.path.exists(exs_path) or not os.path.exists(bk_path):
            return None
        
        # Parse examples
        pos_examples = []
        neg_examples = []
        with open(exs_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('pos('):
                    pos_examples.append(line)
                elif line.startswith('neg('):
                    neg_examples.append(line)
        
        # Load BK
        with open(bk_path, 'r', encoding='utf-8') as f:
            bk_content = f.read()
        
        # Load bias if exists
        bias_content = ""
        if os.path.exists(bias_path):
            with open(bias_path, 'r', encoding='utf-8') as f:
                bias_content = f.read()
        
        return BatchInfo(
            batch_id=batch_id,
            folder_path=folder_path,
            pos_examples=pos_examples,
            neg_examples=neg_examples,
            bk_content=bk_content,
            bias_content=bias_content
        )
    
    def get_existing_hypothesis(self, batch_folder: str) -> Optional[str]:
        """Check if a batch already has a solved hypothesis."""
        hyp_path = os.path.join(batch_folder, "hypothesis.pl")
        if os.path.exists(hyp_path):
            with open(hyp_path, 'r', encoding='utf-8') as f:
                content = f.read()
                # Extract actual hypothesis (skip comments)
                lines = [l.strip() for l in content.split('\n') 
                        if l.strip() and not l.strip().startswith('%')]
                if lines:
                    return '\n'.join(lines)
        return None
    
    # === STEP 1: SPLIT ===
    def split_into_batches(self, pos_examples: List[str], 
                           neg_examples: List[str]) -> List[Tuple[List[str], List[str]]]:
        """Partition examples into batches of k pos + k neg each."""
        batches = []
        k_pos = self.config.batch_size_pos
        k_neg = self.config.batch_size_neg
        
        # Shuffle for diversity across batches
        pos_shuffled = pos_examples.copy()
        neg_shuffled = neg_examples.copy()
        random.shuffle(pos_shuffled)
        random.shuffle(neg_shuffled)
        
        # Calculate number of batches
        n_pos_batches = max(1, (len(pos_shuffled) + k_pos - 1) // k_pos)
        n_neg_batches = max(1, (len(neg_shuffled) + k_neg - 1) // k_neg)
        n_batches = max(n_pos_batches, n_neg_batches)
        
        for i in range(n_batches):
            batch_pos = pos_shuffled[i*k_pos : (i+1)*k_pos]
            batch_neg = neg_shuffled[i*k_neg : (i+1)*k_neg]
            
            # Ensure non-empty batches by cycling if needed
            if not batch_pos and pos_shuffled:
                start_idx = (i * k_pos) % len(pos_shuffled)
                batch_pos = pos_shuffled[start_idx : start_idx + k_pos]
            if not batch_neg and neg_shuffled:
                start_idx = (i * k_neg) % len(neg_shuffled)
                batch_neg = neg_shuffled[start_idx : start_idx + k_neg]
                
            if batch_pos or batch_neg:
                batches.append((batch_pos, batch_neg))
        
        return batches
    
    def filter_bk_for_examples(self, bk_content: str, 
                                examples: List[str],
                                bias_content: str = "") -> str:
        """
        Filter BK to only include facts relevant to given examples.
        
        Algorithm:
        1. Identify Seed Constants - extract ALL constants from examples
        2. First-Order Retrieval - find BK facts containing those constants
        3. Recursive Search - if new constants found, retrieve their facts too
        4. Global Rules - include all facts for body_pred predicates from bias
        """
        # === STEP 1: Extract body predicates from bias (Global Rules) ===
        body_preds = set()
        if bias_content:
            for match in re.finditer(r'body_pred\((\w+)\s*,\s*\d+\)', bias_content):
                body_preds.add(match.group(1))
        
        # === STEP 2: Extract constants from examples ===
        # For examples like pos(legal_move(28,robot,2,2)) or pos(p1(28,c81,2,2)) or pos(p0(0))
        # Extract: state IDs (first numeric arg), entity names (robot, c81)
        constants = set()
        for ex in examples:
            # Find innermost arguments
            inner_matches = re.findall(r'\(([^()]+)\)', ex)
            for inner in inner_matches:
                # Alphanumeric constants: robot, c81, t10, b, s, w (include single chars for consistency)
                alpha_matches = re.findall(r'\b([a-z][a-z0-9_]*)\b', inner)
                constants.update(alpha_matches)
                # Parse arguments to identify state IDs
                args = [a.strip() for a in inner.split(',')]
                for i, arg in enumerate(args):
                    if arg.isdigit():
                        # First arg is likely state ID - always include
                        # Later args > 10 are also state IDs, small ones are coords
                        if i == 0 or int(arg) > 10:
                            constants.add(arg)
        
        # === STEP 3: Parse BK lines ===
        bk_lines = bk_content.split('\n')
        fact_lines = []  # (line, pred_name, all_constants)
        header_lines = []
        
        for line in bk_lines:
            line_stripped = line.strip()
            if not line_stripped or line_stripped.startswith('%') or line_stripped.startswith(':-'):
                header_lines.append(line)
            else:
                # Extract predicate name
                pred_match = re.match(r'(\w+)\(', line_stripped)
                pred_name = pred_match.group(1) if pred_match else ""
                # Extract constants from arguments only (not predicate name)
                args_match = re.search(r'\(([^()]+)\)', line)
                line_constants = set()
                if args_match:
                    args_str = args_match.group(1)
                    # Alphanumeric constants (include single chars for consistency with abstracted tasks)
                    line_constants.update(re.findall(r'\b([a-z][a-z0-9_]*)\b', args_str))
                    # Parse arguments - first arg always included, later args > 10
                    args = [a.strip() for a in args_str.split(',')]
                    for i, arg in enumerate(args):
                        if arg.isdigit():
                            if i == 0 or int(arg) > 10:
                                line_constants.add(arg)
                fact_lines.append((line, pred_name, line_constants))
        
        # === STEP 4: Identify Global vs State-Specific predicates ===
        # Count facts per predicate - count ALL predicates, not just body_preds
        # This ensures static predicates like score_100, role, controls are included
        pred_counts = {}
        for idx, (line, pred_name, line_constants) in enumerate(fact_lines):
            pred_counts[pred_name] = pred_counts.get(pred_name, 0) + 1
        
        # Global/static predicates have few facts (e.g., succ, role, score_100)
        # Threshold: predicates with <= 20 facts are "global" and should always be included
        # This includes: score_100(100), role(black), controls(black,x), succ(1,2), etc.
        global_preds = {p for p, count in pred_counts.items() if count <= 20}
        
        # Include ALL facts for global predicates (but don't expand from their constants)
        included_lines = set()
        for idx, (line, pred_name, line_constants) in enumerate(fact_lines):
            if pred_name in global_preds:
                included_lines.add(idx)
                # Don't add constants from global preds - they're type values not identifiers
        
        # === STEP 5: Recursive Search - expand by constant matching ===
        # Only expand through alphanumeric identifiers, not numeric values
        # Also filter out "global" constants that appear in too many facts (>10% of BK)
        alpha_constants = {c for c in constants if not c.isdigit()}
        num_constants = {c for c in constants if c.isdigit()}
        
        # Count how many facts each alpha constant appears in
        total_facts = len(fact_lines)
        const_counts = {}
        for idx, (line, pred_name, line_constants) in enumerate(fact_lines):
            for c in line_constants:
                if not c.isdigit():
                    const_counts[c] = const_counts.get(c, 0) + 1
        
        # Filter out constants that appear in >10% of facts (global entities like agents)
        threshold = max(total_facts * 0.1, 100)
        global_consts = {c for c, count in const_counts.items() if count > threshold}
        alpha_constants = alpha_constants - global_consts
        
        prev_alpha_size = -1
        max_iterations = 10
        
        # Check if task uses numeric IDs at all
        has_numeric_ids = bool(num_constants)
        
        for _ in range(max_iterations):
            if len(alpha_constants) == prev_alpha_size:
                break
            prev_alpha_size = len(alpha_constants)
            
            for idx, (line, pred_name, line_constants) in enumerate(fact_lines):
                if idx in included_lines:
                    continue
                # Match on alphanumeric OR numeric constants
                line_alphas = {c for c in line_constants if not c.isdigit()}
                line_nums = {c for c in line_constants if c.isdigit()}
                
                # Include if: matches numeric state ID, OR matches alpha AND has a state ID
                # This prevents including global rules (no state ID) via alpha match
                if num_constants & line_nums:
                    # Direct state ID match - always include
                    included_lines.add(idx)
                    alpha_constants.update(line_alphas - global_consts)
                elif (alpha_constants & line_alphas):
                    # Alpha match - require state ID only if task uses numeric IDs
                    if not has_numeric_ids or line_nums:
                        included_lines.add(idx)
                        alpha_constants.update(line_alphas - global_consts)
        
        # === STEP 6: Build filtered BK ===
        filtered_lines = header_lines[:]
        for idx in sorted(included_lines):
            filtered_lines.append(fact_lines[idx][0])
        
        return '\n'.join(filtered_lines)
    
    # === BATCH FOLDER CREATION ===
    def create_batch_folders(self, task_dir: str,
                              pos_examples: List[str],
                              neg_examples: List[str],
                              bk_content: str,
                              bias_content: str = "",
                              log_fn: Callable = print) -> List[BatchInfo]:
        """
        Automatically create batch folders for a large task.
        
        Creates folders INSIDE task_dir like: batch_1, batch_2, etc.
        Each folder contains: exs.pl, bk.pl (filtered), bias.pl, metrics.json
        """
        import json
        from datetime import datetime
        
        batches = self.split_into_batches(pos_examples, neg_examples)
        created_batches = []
        
        task_name = os.path.basename(task_dir)
        
        log_fn(f"BBSILP: Creating {len(batches)} batch folders inside {task_dir}...")
        
        for i, (batch_pos, batch_neg) in enumerate(batches):
            batch_num = i + 1
            batch_folder = os.path.join(task_dir, f"batch_{batch_num}")
            
            # Create folder
            os.makedirs(batch_folder, exist_ok=True)
            
            # Filter BK for this batch's entities
            all_batch_examples = batch_pos + batch_neg
            filtered_bk = self.filter_bk_for_examples(bk_content, all_batch_examples, bias_content)
            
            # Write exs.pl
            exs_path = os.path.join(batch_folder, "exs.pl")
            with open(exs_path, 'w', encoding='utf-8') as f:
                for ex in batch_pos:
                    # Ensure proper format
                    if not ex.startswith('pos('):
                        f.write(f"pos({ex}).\n")
                    elif not ex.endswith('.'):
                        f.write(f"{ex}.\n")
                    else:
                        f.write(f"{ex}\n")
                f.write("\n")
                for ex in batch_neg:
                    if not ex.startswith('neg('):
                        f.write(f"neg({ex}).\n")
                    elif not ex.endswith('.'):
                        f.write(f"{ex}.\n")
                    else:
                        f.write(f"{ex}\n")
            
            # Write bk.pl (filtered)
            bk_path = os.path.join(batch_folder, "bk.pl")
            with open(bk_path, 'w', encoding='utf-8') as f:
                f.write(filtered_bk)
            
            # Write bias.pl (same as parent)
            if bias_content:
                bias_path = os.path.join(batch_folder, "bias.pl")
                with open(bias_path, 'w', encoding='utf-8') as f:
                    f.write(bias_content)
            
            # Write metrics.json
            metrics_path = os.path.join(batch_folder, "metrics.json")
            metrics_data = {
                "batch_id": batch_num,
                "parent_task": task_name,
                "created_at": datetime.now().isoformat(),
                "status": "pending",
                "pos_count": len(batch_pos),
                "neg_count": len(batch_neg),
                "bk_size_bytes": len(filtered_bk),
                "bk_size_kb": len(filtered_bk) // 1024,
                "solved": False,
                "hypothesis": None,
                "iterations": 0,
                "covered_pos": 0,
                "covered_neg": 0,
                "is_generalizable": False,
                "learning_time_seconds": 0
            }
            with open(metrics_path, 'w', encoding='utf-8') as f:
                json.dump(metrics_data, f, indent=2)
            
            log_fn(f"BBSILP: Created batch {batch_num}: {len(batch_pos)} pos, {len(batch_neg)} neg, {len(filtered_bk)//1024}KB BK")
            
            # Create BatchInfo
            created_batches.append(BatchInfo(
                batch_id=batch_num,
                folder_path=batch_folder,
                pos_examples=batch_pos,
                neg_examples=batch_neg,
                bk_content=filtered_bk,
                bias_content=bias_content
            ))
        
        log_fn(f"BBSILP: Created {len(created_batches)} batch folders with metrics.json")
        return created_batches
    
    def update_batch_metrics(self, batch_folder: str, 
                              hypothesis: str = None,
                              covered_pos: int = 0,
                              covered_neg: int = 0,
                              is_generalizable: bool = False,
                              learning_time: float = 0,
                              iterations: int = 0):
        """Update the metrics.json file for a batch after learning."""
        import json
        from datetime import datetime
        
        metrics_path = os.path.join(batch_folder, "metrics.json")
        
        # Load existing metrics
        if os.path.exists(metrics_path):
            with open(metrics_path, 'r', encoding='utf-8') as f:
                metrics = json.load(f)
        else:
            metrics = {}
        
        # Update metrics
        metrics["status"] = "solved" if hypothesis else "failed"
        metrics["solved"] = bool(hypothesis)
        metrics["hypothesis"] = hypothesis
        metrics["iterations"] = iterations
        metrics["covered_pos"] = covered_pos
        metrics["covered_neg"] = covered_neg
        metrics["is_generalizable"] = is_generalizable
        metrics["learning_time_seconds"] = round(learning_time, 3)
        metrics["completed_at"] = datetime.now().isoformat()
        
        # Write updated metrics
        with open(metrics_path, 'w', encoding='utf-8') as f:
            json.dump(metrics, f, indent=2)
    
    # === STEP 2: PARALLEL LEARN ===
    def learn_from_batch(self, batch_info: BatchInfo,
                         llm_call_fn: Callable,
                         log_fn: Callable = print) -> BatchResult:
        """Learn hypothesis from a single batch using LLM."""
        start_time = time.time()
        
        # Check if already solved
        existing_hyp = self.get_existing_hypothesis(batch_info.folder_path)
        if existing_hyp:
            log_fn(f"BBSILP: Batch {batch_info.batch_id} already has hypothesis")
            return BatchResult(
                batch_id=batch_info.batch_id,
                hypothesis=existing_hyp,
                batch_pos=batch_info.pos_examples,
                batch_neg=batch_info.neg_examples,
                learning_time=0.0,
                folder_path=batch_info.folder_path
            )
        
        # Call LLM with batch examples
        log_fn(f"BBSILP: Learning from batch {batch_info.batch_id} ({len(batch_info.pos_examples)} pos, {len(batch_info.neg_examples)} neg)")
        
        hypothesis = llm_call_fn(
            batch_info.pos_examples,
            batch_info.neg_examples,
            batch_info.bk_content,
            batch_info.bias_content
        )
        
        learning_time = time.time() - start_time
        
        # Update metrics.json if batch has a folder
        if batch_info.folder_path:
            self.update_batch_metrics(
                batch_folder=batch_info.folder_path,
                hypothesis=hypothesis,
                learning_time=learning_time,
                iterations=1
            )
            
            # Save hypothesis.pl if found
            if hypothesis:
                hyp_path = os.path.join(batch_info.folder_path, "hypothesis.pl")
                with open(hyp_path, 'w', encoding='utf-8') as f:
                    f.write(f"% Solved by BBSILP\n")
                    f.write(f"% Time: {learning_time:.3f}s\n")
                    f.write(hypothesis)
        
        return BatchResult(
            batch_id=batch_info.batch_id,
            hypothesis=hypothesis,
            batch_pos=batch_info.pos_examples,
            batch_neg=batch_info.neg_examples,
            learning_time=learning_time,
            folder_path=batch_info.folder_path
        )
    
    def parallel_learn(self, batches: List[BatchInfo],
                       llm_call_fn: Callable,
                       log_fn: Callable = print) -> List[BatchResult]:
        """Learn hypotheses from all batches (parallel where possible)."""
        results = []
        
        # Use ThreadPoolExecutor for parallel LLM calls
        with ThreadPoolExecutor(max_workers=self.config.max_parallel_batches) as executor:
            futures = {
                executor.submit(self.learn_from_batch, batch, llm_call_fn, log_fn): batch.batch_id
                for batch in batches
            }
            
            for future in as_completed(futures):
                batch_id = futures[future]
                try:
                    result = future.result()
                    results.append(result)
                    log_fn(f"BBSILP: Batch {batch_id} completed")
                except Exception as e:
                    log_fn(f"BBSILP: Batch {batch_id} failed: {e}")
        
        return sorted(results, key=lambda r: r.batch_id)
    
    # === STEP 3: EARLY TERMINATION ===
    def test_generalizability(self, hypothesis: str,
                              all_pos: Set[str],
                              all_neg: Set[str],
                              tester) -> Tuple[bool, Set[str], Set[str]]:
        """Test if hypothesis generalizes to full dataset."""
        result = tester.test_hypothesis(hypothesis)
        
        covers_all_pos = len(result.missed_pos) == 0
        covers_zero_neg = len(result.covered_neg) == 0
        
        is_generalizable = covers_all_pos and covers_zero_neg
        return is_generalizable, result.covered_pos, result.covered_neg
    
    def check_early_termination(self, batch_results: List[BatchResult],
                                 all_pos: Set[str],
                                 all_neg: Set[str],
                                 tester,
                                 log_fn: Callable = print) -> Optional[BatchResult]:
        """Check if any batch hypothesis generalizes to full dataset."""
        if not self.config.early_termination:
            return None
            
        for result in batch_results:
            if not result.hypothesis:
                continue
                
            log_fn(f"BBSILP: Testing batch {result.batch_id} hypothesis on full dataset...")
            is_gen, covered_pos, covered_neg = self.test_generalizability(
                result.hypothesis, all_pos, all_neg, tester
            )
            
            result.covered_pos = covered_pos
            result.covered_neg = covered_neg
            result.is_generalizable = is_gen
            
            if is_gen:
                log_fn(f"BBSILP: Batch {result.batch_id} hypothesis GENERALIZES!")
                return result
            else:
                log_fn(f"BBSILP: Batch {result.batch_id} covers {len(covered_pos)}/{len(all_pos)} pos, {len(covered_neg)} neg")
        
        return None
    
    # === STEP 4: MERGE & REFINE ===
    def merge_hypotheses(self, batch_results: List[BatchResult],
                         bk_content: str,
                         llm_merge_fn: Callable,
                         log_fn: Callable = print) -> str:
        """Merge multiple batch hypotheses to find common pattern."""
        valid_hypotheses = [r for r in batch_results if r.hypothesis]
        
        if not valid_hypotheses:
            return ""
        
        if len(valid_hypotheses) == 1:
            return valid_hypotheses[0].hypothesis
        
        log_fn(f"BBSILP: Merging {len(valid_hypotheses)} hypotheses...")
        
        # Build merge prompt
        hyp_list = "\n\n".join([
            f"% Batch {r.batch_id} (covered {len(r.covered_pos)} pos, {len(r.covered_neg)} neg):\n{r.hypothesis}"
            for r in valid_hypotheses
        ])
        
        merge_prompt = f"""Analyze these hypotheses learned from different data batches.
Find the COMMON PATTERN that generalizes across all:

{hyp_list}

Generate a UNIFIED hypothesis that:
1. Captures the common logical pattern
2. Is more general (covers cases from all batches)
3. Maintains zero negative coverage

Output ONLY valid Prolog code in a ```prolog block."""
        
        return llm_merge_fn(merge_prompt, bk_content)
    
    # === STEP 5: SELECTION (MDL) ===
    def count_literals(self, hyp: str) -> int:
        """Count literals in a hypothesis for MDL selection."""
        total = 0
        for clause in hyp.strip().split('\n'):
            clause = clause.strip()
            if not clause or clause.startswith('%'):
                continue
            if ':-' in clause:
                body = clause.split(':-')[1]
                total += body.count(',') + 1
            elif clause.endswith('.'):
                total += 1
        return total
    
    def select_minimal(self, candidates: List[str]) -> str:
        """Select hypothesis with Minimum Description Length."""
        valid = [c for c in candidates if c and c.strip()]
        if not valid:
            return ""
        
        return min(valid, key=self.count_literals)
    
    # === MAIN RUN ===
    def run(self, task_dir: str,
            pos_examples: List[str],
            neg_examples: List[str],
            bk_content: str,
            llm_call_fn: Callable,
            llm_merge_fn: Callable,
            tester,
            log_fn: Callable = print) -> BBSILPResult:
        """Execute the full BBSILP algorithm."""
        start_time = time.time()
        all_pos = set(pos_examples)
        all_neg = set(neg_examples)
        
        log_fn(f"BBSILP: Starting with {len(pos_examples)} pos, {len(neg_examples)} neg")
        
        # Check for existing batch folders
        existing_batches = self.find_existing_batches(task_dir)
        
        if existing_batches:
            log_fn(f"BBSILP: Found {len(existing_batches)} existing batch folders")
            batches = existing_batches
        else:
            # STEP 1: Automatically create batch folders with metrics.json
            log_fn(f"BBSILP: No existing batches, creating {self.config.batch_size_pos}+{self.config.batch_size_neg} batch folders...")
            
            # Load bias content from parent task
            bias_content = ""
            bias_path = os.path.join(task_dir, "bias.pl")
            if os.path.exists(bias_path):
                with open(bias_path, 'r', encoding='utf-8') as f:
                    bias_content = f.read()
            
            # Create batch folders with exs.pl, bk.pl (filtered), bias.pl, metrics.json
            batches = self.create_batch_folders(
                task_dir=task_dir,
                pos_examples=pos_examples,
                neg_examples=neg_examples,
                bk_content=bk_content,
                bias_content=bias_content,
                log_fn=log_fn
            )
            
            log_fn(f"BBSILP: Created {len(batches)} batch folders with metrics.json")
        
        # STEP 2: Learn from batches
        batch_results = self.parallel_learn(batches, llm_call_fn, log_fn)
        log_fn(f"BBSILP: Learned {len(batch_results)} hypotheses")
        
        # STEP 3: Early termination check
        generalizable = self.check_early_termination(batch_results, all_pos, all_neg, tester, log_fn)
        if generalizable:
            log_fn(f"BBSILP: EARLY TERMINATION - Batch {generalizable.batch_id} generalizes!")
            return BBSILPResult(
                hypothesis=generalizable.hypothesis,
                is_solution=True,
                method="early_termination",
                batches_processed=len(batch_results),
                total_time=time.time() - start_time,
                batch_results=batch_results
            )
        
        # STEP 4: Merge & refine
        log_fn("BBSILP: No single hypothesis generalizes, attempting merge...")
        merged = self.merge_hypotheses(batch_results, bk_content, llm_merge_fn, log_fn)
        
        if merged:
            is_gen, covered_pos, covered_neg = self.test_generalizability(merged, all_pos, all_neg, tester)
            if is_gen:
                log_fn("BBSILP: Merged hypothesis is a SOLUTION!")
                return BBSILPResult(
                    hypothesis=merged,
                    is_solution=True,
                    method="merge",
                    batches_processed=len(batch_results),
                    total_time=time.time() - start_time,
                    batch_results=batch_results
                )
            else:
                log_fn(f"BBSILP: Merged hypothesis covers {len(covered_pos)}/{len(all_pos)} pos, {len(covered_neg)} neg")
        
        # STEP 5: Select best candidate (MDL)
        log_fn("BBSILP: Selecting best candidate by Minimum Description Length...")
        candidates = [r.hypothesis for r in batch_results if r.hypothesis]
        if merged:
            candidates.append(merged)
        
        best = self.select_minimal(candidates)
        
        # Check if best is a partial cover (covers some pos, zero neg)
        if best:
            is_gen, covered_pos, covered_neg = self.test_generalizability(best, all_pos, all_neg, tester)
            if len(covered_neg) == 0 and len(covered_pos) > 0:
                log_fn(f"BBSILP: Best candidate is partial cover ({len(covered_pos)}/{len(all_pos)} pos)")
                return BBSILPResult(
                    hypothesis=best,
                    is_solution=False,
                    method="partial_cover",
                    batches_processed=len(batch_results),
                    total_time=time.time() - start_time,
                    batch_results=batch_results
                )
        
        return BBSILPResult(
            hypothesis=best,
            is_solution=False,
            method="selection",
            batches_processed=len(batch_results),
            total_time=time.time() - start_time,
            batch_results=batch_results
        )


def is_task_large(task_dir: str, config: BBSILPConfig = None) -> bool:
    """Convenience function to check if a task needs BBSILP."""
    config = config or BBSILPConfig()
    
    bk_path = os.path.join(task_dir, "bk.pl")
    exs_path = os.path.join(task_dir, "exs.pl")
    bias_path = os.path.join(task_dir, "bias.pl")
    
    total_size = 0
    for path in [bk_path, exs_path, bias_path]:
        if os.path.exists(path):
            total_size += os.path.getsize(path)
    
    return total_size > config.zendo2_threshold
