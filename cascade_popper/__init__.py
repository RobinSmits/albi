"""
Cascade-Popper: ILP solver using Windsurf Cascade for interactive hypothesis generation.

This module implements an interactive ILP (Inductive Logic Programming) loop
with constraint learning and θ-subsumption pruning.
"""

from .cascade_generator import CascadeHypothesisGenerator, TaskContext, Constraint, ModeDeclaration
from .constraint_learner import ConstraintLearner, TestResult
from .tester import HypothesisTester
from .subsumption import SubsumptionChecker
from .loop import CascadePopperLoop, solve_with_cascade

__all__ = [
    'CascadeHypothesisGenerator',
    'TaskContext',
    'Constraint', 
    'ModeDeclaration',
    'ConstraintLearner',
    'TestResult',
    'HypothesisTester',
    'SubsumptionChecker',
    'CascadePopperLoop',
    'solve_with_cascade'
]
