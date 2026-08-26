#!/usr/bin/env python
"""
Main runner script for Cascade-Popper ILP solver.

Usage:
    python run_task.py <task_directory> <command> [args]
    
Commands:
    init      - Initialize task and show context for Cascade
    test      - Test a hypothesis
    status    - Show session status
    reset     - Reset session
    prompt    - Show current prompt with constraints

Examples:
    python -m cascade_popper.run_task example_abstraction/z1 init
    python -m cascade_popper.run_task example_abstraction/z1 test "p0(A) :- p1(A,B), p6(B)."
    python -m cascade_popper.run_task example_abstraction/z1 status
"""

import argparse
import os
import sys

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from cascade_popper.loop import CascadePopperLoop, solve_with_cascade


def init_task(task_dir: str, model: str = "cascade") -> None:
    """Initialize task and show context for Cascade."""
    loop = CascadePopperLoop(task_dir, model=model)
    
    print("=" * 70)
    print("CASCADE-POPPER - Task Initialized")
    print("=" * 70)
    print(loop.get_prompt())
    print("\n" + "=" * 70)
    print("READY FOR HYPOTHESES")
    print("=" * 70)
    print("""
Provide a Prolog hypothesis based on the task above.
Test with: python -m cascade_popper.run_task <task> test "<hypothesis>"

Example: p0(A) :- p1(A,B), p6(B).
""")
    loop.save_session()


def test_hypothesis(task_dir: str, hypothesis: str, model: str = "cascade") -> None:
    """Test a hypothesis and provide feedback."""
    loop = CascadePopperLoop(task_dir, model=model)
    loop.load_session()
    
    print("=" * 70)
    result = loop.test_hypothesis(hypothesis)
    print(result)
    print("=" * 70)


def show_status(task_dir: str, model: str = "cascade") -> None:
    """Show current session status."""
    loop = CascadePopperLoop(task_dir, model=model)
    
    if not loop.load_session():
        print("No session found. Run 'init' first.")
        return
    
    print(loop.get_status())


def show_prompt(task_dir: str, model: str = "cascade") -> None:
    """Show current prompt with learned constraints."""
    loop = CascadePopperLoop(task_dir, model=model)
    loop.load_session()
    
    print("=" * 70)
    print("CURRENT PROMPT (with learned constraints)")
    print("=" * 70)
    print(loop.get_prompt())


def reset_session(task_dir: str) -> None:
    """Reset the session."""
    session_path = os.path.join(task_dir, 'cascade_session.json')
    if os.path.exists(session_path):
        os.remove(session_path)
        print(f"Session reset: {session_path}")
    else:
        print("No session to reset.")


def main():
    parser = argparse.ArgumentParser(
        description='Cascade-Popper: ILP solver using Windsurf Cascade',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Commands:
  init    - Initialize task and show context
  test    - Test a hypothesis
  status  - Show session status  
  reset   - Reset session
  prompt  - Show current prompt with constraints

Examples:
  python -m cascade_popper.run_task example_abstraction/z1 init
  python -m cascade_popper.run_task example_abstraction/z1 test "p0(A) :- p1(A,B), p6(B)."
  python -m cascade_popper.run_task example_abstraction/z1 status
"""
    )
    
    parser.add_argument('task_dir', help='Task directory')
    parser.add_argument('command', choices=['init', 'test', 'status', 'reset', 'prompt'],
                        help='Command to run')
    parser.add_argument('hypothesis', nargs='?', default='',
                        help='Hypothesis to test (for test command)')
    parser.add_argument('--model', '-m', default='cascade',
                        help='Model name to record (e.g., claude-opus-4, cascade)')
    
    args = parser.parse_args()
    
    # Resolve task directory
    task_dir = args.task_dir
    if not os.path.isabs(task_dir):
        # Try relative to script location first
        script_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        candidate = os.path.join(script_dir, task_dir)
        if os.path.exists(candidate):
            task_dir = candidate
        else:
            task_dir = os.path.abspath(task_dir)
    
    if not os.path.isdir(task_dir):
        print(f"Error: Task directory not found: {task_dir}")
        sys.exit(1)
    
    if args.command == 'init':
        init_task(task_dir, args.model)
    elif args.command == 'test':
        if not args.hypothesis:
            print("Error: Hypothesis required for test command")
            sys.exit(1)
        test_hypothesis(task_dir, args.hypothesis, args.model)
    elif args.command == 'status':
        show_status(task_dir, args.model)
    elif args.command == 'reset':
        reset_session(task_dir)
    elif args.command == 'prompt':
        show_prompt(task_dir, args.model)


if __name__ == '__main__':
    main()