#!/usr/bin/env python
"""
Cascade Session Capture Script.

Captures all interactions during a cascade_popper solving session:
- Initial prompt sent to Cascade
- Each hypothesis tested
- Feedback/results from each test
- Constraints learned
- Final solution

Usage:
    python -m cascade_popper.capture_session <task_directory> [--output <file>]

Example:
    python -m cascade_popper.capture_session example_abstraction/z1
    python -m cascade_popper.capture_session example_abstraction/z1 --output my_session.txt
"""

import os
import sys
import argparse
import json
from datetime import datetime
from typing import List, Optional

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from cascade_popper.loop import CascadePopperLoop


class SessionCapture:
    """
    Captures and logs all cascade_popper interactions.
    
    This wraps the CascadePopperLoop to intercept and log:
    - Prompts generated for Cascade
    - Hypotheses tested
    - Test results and feedback
    - Constraints learned
    """
    
    def __init__(self, task_dir: str, output_file: str = None, model: str = "cascade"):
        self.task_dir = task_dir
        self.model = model
        self.output_file = output_file or os.path.join(task_dir, 'cascade_capture.txt')
        
        # Initialize the loop
        self.loop = CascadePopperLoop(task_dir, model=model, verbose=False)
        
        # Capture log
        self.capture_log: List[dict] = []
        self.start_time = datetime.now()
        
    def _log_entry(self, entry_type: str, content: str, metadata: dict = None):
        """Add an entry to the capture log."""
        entry = {
            'timestamp': datetime.now().isoformat(),
            'type': entry_type,
            'content': content,
            'metadata': metadata or {}
        }
        self.capture_log.append(entry)
        
    def capture_init(self) -> str:
        """Capture the initialization prompt."""
        prompt = self.loop.get_prompt()
        
        self._log_entry(
            entry_type='INIT_PROMPT',
            content=prompt,
            metadata={
                'task_dir': self.task_dir,
                'model': self.model,
                'num_positives': len(self.loop.tester.pos_examples),
                'num_negatives': len(self.loop.tester.neg_examples)
            }
        )
        
        return prompt
    
    def capture_test(self, hypothesis: str) -> str:
        """Capture a hypothesis test and its result."""
        # Log the hypothesis being tested
        self._log_entry(
            entry_type='HYPOTHESIS_INPUT',
            content=hypothesis,
            metadata={'iteration': self.loop.iteration + 1}
        )
        
        # Run the test
        result = self.loop.test_hypothesis(hypothesis)
        
        # Log the result
        self._log_entry(
            entry_type='TEST_RESULT',
            content=result,
            metadata={
                'iteration': self.loop.iteration,
                'solved': self.loop.solved,
                'best_score': self.loop.best_score
            }
        )
        
        return result
    
    def capture_status(self) -> str:
        """Capture current session status."""
        status = self.loop.get_status()
        
        self._log_entry(
            entry_type='STATUS',
            content=status,
            metadata={'iteration': self.loop.iteration}
        )
        
        return status
    
    def capture_prompt(self) -> str:
        """Capture current prompt with learned constraints."""
        prompt = self.loop.get_prompt()
        
        self._log_entry(
            entry_type='UPDATED_PROMPT',
            content=prompt,
            metadata={
                'iteration': self.loop.iteration,
                'num_constraints': len(self.loop.constraint_learner.learned_constraints)
            }
        )
        
        return prompt
    
    def save_capture(self, output_file: str = None) -> str:
        """Save the captured session to a file."""
        output_file = output_file or self.output_file
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("=" * 80 + "\n")
            f.write("CASCADE-POPPER SESSION CAPTURE\n")
            f.write("=" * 80 + "\n")
            f.write(f"Task: {self.task_dir}\n")
            f.write(f"Model: {self.model}\n")
            f.write(f"Start Time: {self.start_time.isoformat()}\n")
            f.write(f"End Time: {datetime.now().isoformat()}\n")
            f.write(f"Total Entries: {len(self.capture_log)}\n")
            f.write("=" * 80 + "\n\n")
            
            for i, entry in enumerate(self.capture_log, 1):
                f.write("-" * 80 + "\n")
                f.write(f"[{i}] {entry['type']} @ {entry['timestamp']}\n")
                if entry['metadata']:
                    f.write(f"Metadata: {json.dumps(entry['metadata'], indent=2)}\n")
                f.write("-" * 80 + "\n")
                f.write(entry['content'])
                f.write("\n\n")
            
            f.write("=" * 80 + "\n")
            f.write("END OF CAPTURE\n")
            f.write("=" * 80 + "\n")
        
        return output_file
    
    def save_capture_json(self, output_file: str = None) -> str:
        """Save the captured session as JSON for programmatic access."""
        output_file = output_file or self.output_file.replace('.txt', '.json')
        
        data = {
            'task_dir': self.task_dir,
            'model': self.model,
            'start_time': self.start_time.isoformat(),
            'end_time': datetime.now().isoformat(),
            'solved': self.loop.solved,
            'iterations': self.loop.iteration,
            'best_hypothesis': self.loop.best_hypothesis,
            'best_score': self.loop.best_score,
            'entries': self.capture_log
        }
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)
        
        return output_file
    
    def interactive_session(self):
        """
        Run an interactive session that captures all interactions.
        
        This allows you to manually input hypotheses while capturing everything.
        """
        print("=" * 70)
        print("CASCADE-POPPER SESSION CAPTURE - Interactive Mode")
        print("=" * 70)
        print(f"Task: {self.task_dir}")
        print(f"Output: {self.output_file}")
        print("=" * 70)
        print()
        
        # Capture and display initial prompt
        prompt = self.capture_init()
        print(prompt)
        print()
        
        while not self.loop.solved and self.loop.iteration < self.loop.max_iterations:
            print("-" * 70)
            print(f"Iteration {self.loop.iteration + 1}")
            print("Enter hypothesis (or 'quit' to exit, 'status' for status, 'prompt' for current prompt):")
            print("-" * 70)
            
            try:
                hypothesis = input("> ").strip()
            except (EOFError, KeyboardInterrupt):
                print("\nSession interrupted.")
                break
            
            if not hypothesis:
                continue
            
            if hypothesis.lower() == 'quit':
                break
            
            if hypothesis.lower() == 'status':
                print(self.capture_status())
                continue
            
            if hypothesis.lower() == 'prompt':
                print(self.capture_prompt())
                continue
            
            # Test the hypothesis
            result = self.capture_test(hypothesis)
            print()
            print(result)
            print()
        
        # Save captures
        txt_path = self.save_capture()
        json_path = self.save_capture_json()
        
        print("=" * 70)
        print("SESSION COMPLETE")
        print("=" * 70)
        print(f"Solved: {self.loop.solved}")
        print(f"Iterations: {self.loop.iteration}")
        print(f"Captures saved to:")
        print(f"  - {txt_path}")
        print(f"  - {json_path}")
        print("=" * 70)


def main():
    parser = argparse.ArgumentParser(
        description='Capture Cascade-Popper session interactions',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python -m cascade_popper.capture_session example_abstraction/z1
  python -m cascade_popper.capture_session example_abstraction/z1 --output my_session.txt
  python -m cascade_popper.capture_session example_abstraction/z1 --interactive
"""
    )
    
    parser.add_argument('task_dir', help='Task directory')
    parser.add_argument('--output', '-o', help='Output file path')
    parser.add_argument('--model', '-m', default='cascade', help='Model name')
    parser.add_argument('--interactive', '-i', action='store_true',
                        help='Run in interactive mode')
    
    args = parser.parse_args()
    
    # Resolve task directory
    task_dir = args.task_dir
    if not os.path.isabs(task_dir):
        script_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        candidate = os.path.join(script_dir, task_dir)
        if os.path.exists(candidate):
            task_dir = candidate
        else:
            task_dir = os.path.abspath(task_dir)
    
    if not os.path.isdir(task_dir):
        print(f"Error: Task directory not found: {task_dir}")
        sys.exit(1)
    
    # Create capture session
    capture = SessionCapture(task_dir, args.output, args.model)
    
    if args.interactive:
        capture.interactive_session()
    else:
        # Non-interactive: just capture the initial prompt
        print("=" * 70)
        print("CASCADE-POPPER SESSION CAPTURE")
        print("=" * 70)
        print(f"Task: {task_dir}")
        print()
        
        prompt = capture.capture_init()
        print(prompt)
        
        txt_path = capture.save_capture()
        json_path = capture.save_capture_json()
        
        print()
        print("=" * 70)
        print(f"Initial prompt captured to:")
        print(f"  - {txt_path}")
        print(f"  - {json_path}")
        print()
        print("To capture hypothesis tests, use:")
        print(f"  python -m cascade_popper.capture_session {args.task_dir} --interactive")
        print("=" * 70)


if __name__ == '__main__':
    main()
