"""
Hypothesis Tester for Cascade-Popper.
Tests generated hypotheses against examples using SWI-Prolog or Python fallback.
"""

import os
import sys
import tempfile
import subprocess
import re
from typing import List, Set, Tuple, Optional

# Add parent directory to path for importing test_hypothesis
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from .constraint_learner import TestResult


class HypothesisTester:
    """
    Tests Prolog hypotheses against positive and negative examples.
    
    Uses either:
    1. SWI-Prolog (if available) for accurate Prolog evaluation
    2. Python-based interpreter from test_hypothesis.py as fallback
    """
    
    def __init__(self, task_dir: str):
        self.task_dir = task_dir
        self.bk_path = os.path.join(task_dir, "bk.pl")
        self.exs_path = os.path.join(task_dir, "exs.pl")
        
        # Load examples
        self.pos_examples, self.neg_examples = self._load_examples()
        
        # Check for SWI-Prolog
        self.has_swipl = self._check_swipl()
        
    def _check_swipl(self) -> bool:
        """Check if SWI-Prolog is available."""
        import shutil
        return shutil.which('swipl') is not None
    
    def _load_examples(self) -> Tuple[Set[str], Set[str]]:
        """Load positive and negative examples from exs.pl."""
        pos = set()
        neg = set()
        
        if not os.path.exists(self.exs_path):
            return pos, neg
        
        with open(self.exs_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                # Normalize whitespace
                line = re.sub(r'\s+', '', line)
                if line.startswith('pos('):
                    # Extract the inner goal
                    match = re.match(r'pos\((.+)\)\.$', line)
                    if match:
                        pos.add(match.group(1))
                elif line.startswith('neg('):
                    match = re.match(r'neg\((.+)\)\.$', line)
                    if match:
                        neg.add(match.group(1))
        
        return pos, neg
    
    def test_hypothesis(self, hypothesis: str) -> TestResult:
        """
        Test a hypothesis against all examples.
        
        Args:
            hypothesis: Prolog clause(s) to test
            
        Returns:
            TestResult with coverage information
        """
        # Write hypothesis to temp file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.pl', 
                                         delete=False, encoding='utf-8') as f:
            f.write(hypothesis)
            hyp_path = f.name
        
        try:
            if self.has_swipl:
                return self._test_with_swipl(hypothesis, hyp_path)
            else:
                return self._test_with_python(hypothesis, hyp_path)
        finally:
            try:
                os.remove(hyp_path)
            except:
                pass
    
    def _test_with_swipl(self, hypothesis: str, hyp_path: str) -> TestResult:
        """Test using SWI-Prolog."""
        covered_pos = set()
        covered_neg = set()
        
        # Create Prolog script to test each example
        script = self._create_test_script(hyp_path, hypothesis)
        
        with tempfile.NamedTemporaryFile(mode='w', suffix='.pl',
                                         delete=False, encoding='utf-8') as f:
            f.write(script)
            script_path = f.name
        
        try:
            cmd = ['swipl', '-q', '-f', script_path]
            proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, 
                                  universal_newlines=True, timeout=60)
            output = proc.stdout
            
            # Parse output
            for line in output.split('\n'):
                line = line.strip()
                if line.startswith('pos_covered:'):
                    goal = line.split(':', 1)[1].strip()
                    # Normalize whitespace for matching
                    goal = re.sub(r'\s+', '', goal)
                    if goal:
                        covered_pos.add(goal)
                elif line.startswith('neg_covered:'):
                    goal = line.split(':', 1)[1].strip()
                    goal = re.sub(r'\s+', '', goal)
                    if goal:
                        covered_neg.add(goal)
                        
        except subprocess.TimeoutExpired:
            print(f"SWI-Prolog test timed out (60s) - partial results: {len(covered_pos)} pos, {len(covered_neg)} neg")
        except Exception as e:
            print(f"SWI-Prolog test failed: {e}")
        finally:
            try:
                os.remove(script_path)
            except:
                pass
        
        missed_pos = self.pos_examples - covered_pos
        
        return TestResult(
            hypothesis=hypothesis,
            covered_pos=covered_pos,
            missed_pos=missed_pos,
            covered_neg=covered_neg,
            is_consistent=len(covered_neg) == 0 and len(missed_pos) == 0
        )
    
    def _detect_recursive_predicates(self, hypothesis: str) -> set:
        """Detect predicates that appear both as head and in body (recursive)."""
        head_preds = set()
        body_preds = set()
        for line in hypothesis.split('\n'):
            line = line.strip()
            if not line or ':-' not in line:
                continue
            head_part, body_part = line.split(':-', 1)
            head_match = re.match(r'(\w+)\s*\(', head_part.strip())
            if head_match:
                pred_name = head_match.group(1)
                head_preds.add(pred_name)
                # Count arity from head arguments
                args = head_part.strip()[len(pred_name):].strip()
                arity = args.count(',') + 1 if args else 0
                head_preds.add((pred_name, arity))
            # Find all predicates in body
            for m in re.finditer(r'(\w+)\s*\(', body_part):
                body_preds.add(m.group(1))
        # Recursive = head pred that also appears in body
        recursive = set()
        for item in head_preds:
            if isinstance(item, tuple):
                pred_name, arity = item
                if pred_name in body_preds:
                    recursive.add((pred_name, arity))
        return recursive

    def _create_test_script(self, hyp_path: str, hypothesis: str = "") -> str:
        """Create Prolog script for testing hypothesis."""
        bk_path_escaped = self.bk_path.replace('\\', '/')
        hyp_path_escaped = hyp_path.replace('\\', '/')
        exs_path_escaped = self.exs_path.replace('\\', '/')
        
        # Detect recursive predicates and generate tabling directives
        tabling_directives = ""
        if hypothesis:
            recursive_preds = self._detect_recursive_predicates(hypothesis)
            if recursive_preds:
                tabling_directives = ":- use_module(library(tabling)).\n"
                for pred_name, arity in recursive_preds:
                    tabling_directives += f":- table {pred_name}/{arity}.\n"
        
        # Use the same approach as test_hypothesis.py for reliable testing
        # Use write_canonical for consistent output format
        script = f"""{tabling_directives}:- initialization(main).
main :-
  consult('{bk_path_escaped}'),
  consult('{hyp_path_escaped}'),
  consult('{exs_path_escaped}'),
  forall((pos(E), call(E)), (write('pos_covered:'), write_canonical(E), nl)),
  forall((neg(E), call(E)), (write('neg_covered:'), write_canonical(E), nl)),
  halt.
"""
        return script
    
    def _test_with_python(self, hypothesis: str, hyp_path: str) -> TestResult:
        """Test using Python-based interpreter from test_hypothesis.py."""
        try:
            # Import test_hypothesis functions
            import importlib.util
            spec = importlib.util.spec_from_file_location(
                "test_hypothesis",
                os.path.join(os.path.dirname(os.path.dirname(__file__)), "test_hypothesis.py")
            )
            test_mod = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(test_mod)
            
            # Load BK and examples
            pos_list, neg_list = test_mod.load_examples(self.exs_path)
            bk_data = test_mod.load_bk(self.bk_path)
            piece_map, contact, piece_unary, attr, num_unary = bk_data
            
            # Parse hypothesis
            program = test_mod.parse_hypothesis_file(hyp_path)
            
            covered_pos = set()
            covered_neg = set()
            
            # Test each example
            for ex in pos_list:
                if test_mod.entails(ex, program, piece_map, contact, piece_unary, attr, num_unary):
                    covered_pos.add(f"{ex[0]}({','.join(str(a) for a in ex[1])})")
            
            for ex in neg_list:
                if test_mod.entails(ex, program, piece_map, contact, piece_unary, attr, num_unary):
                    covered_neg.add(f"{ex[0]}({','.join(str(a) for a in ex[1])})")
            
            missed_pos = self.pos_examples - covered_pos
            
            return TestResult(
                hypothesis=hypothesis,
                covered_pos=covered_pos,
                missed_pos=missed_pos,
                covered_neg=covered_neg,
                is_consistent=len(covered_neg) == 0 and len(missed_pos) == 0
            )
            
        except Exception as e:
            print(f"Python test failed: {e}")
            # Return empty result on failure
            return TestResult(
                hypothesis=hypothesis,
                covered_pos=set(),
                missed_pos=self.pos_examples.copy(),
                covered_neg=set(),
                is_consistent=False
            )
    
    def quick_test(self, hypothesis: str, sample_size: int = 5) -> Tuple[int, int, int, int]:
        """
        Quick test on a sample of examples.
        
        Returns:
            Tuple of (pos_covered, pos_total_sampled, neg_covered, neg_total_sampled)
        """
        result = self.test_hypothesis(hypothesis)
        
        return (
            len(result.covered_pos),
            len(self.pos_examples),
            len(result.covered_neg),
            len(self.neg_examples)
        )
    
    def get_statistics(self, result: TestResult) -> dict:
        """Get detailed statistics from a test result."""
        total_pos = len(self.pos_examples)
        total_neg = len(self.neg_examples)
        
        tp = len(result.covered_pos)
        fn = len(result.missed_pos)
        fp = len(result.covered_neg)
        tn = total_neg - fp
        
        precision = tp / (tp + fp) if (tp + fp) > 0 else 0
        recall = tp / (tp + fn) if (tp + fn) > 0 else 0
        f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0
        
        return {
            'total_positives': total_pos,
            'total_negatives': total_neg,
            'true_positives': tp,
            'false_negatives': fn,
            'false_positives': fp,
            'true_negatives': tn,
            'precision': precision,
            'recall': recall,
            'f1_score': f1,
            'is_solution': result.is_complete
        }
