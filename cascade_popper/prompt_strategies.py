"""
Prompting Strategies for Large Dataset Support in Cascade-Popper.

This module provides two prompting strategies:

Strategies:
1. FULL_CONTEXT - Small datasets (< 87KB): send everything to LLM
2. BATCH_SCALABLE - Large datasets (> 87KB): BBSILP batch-based learning
"""

import os
import re
from typing import List, Dict, Optional, Tuple
from dataclasses import dataclass, field
from enum import Enum, auto
from collections import defaultdict

from cascade_popper.bk_adapter import BKAdapter, TaskProfile


class StrategyType(Enum):
    """Available prompting strategies."""
    FULL_CONTEXT = auto()       # Small datasets (< 87KB) - send everything
    BATCH_SCALABLE = auto()     # Large datasets (> 87KB) - BBSILP batch-based learning


@dataclass
class StrategyConfig:
    """Configuration for a prompting strategy."""
    strategy_type: StrategyType
    name: str
    description: str
    max_bk_chars: int = 50000
    max_examples: int = 200
    include_schema: bool = True
    include_statistics: bool = True
    include_sample_facts: bool = True
    sample_facts_per_predicate: int = 5
    follow_relational_chains: bool = False
    chain_depth: int = 2
    analyze_example_patterns: bool = False


# Pre-defined strategy configurations
STRATEGY_CONFIGS = {
    StrategyType.FULL_CONTEXT: StrategyConfig(
        strategy_type=StrategyType.FULL_CONTEXT,
        name="Full Context",
        description="Send complete BK and all examples (< 87KB tasks)",
        max_bk_chars=500000,
        max_examples=10000,
        include_schema=False,
        include_statistics=False,
        include_sample_facts=False,
    ),
    StrategyType.BATCH_SCALABLE: StrategyConfig(
        strategy_type=StrategyType.BATCH_SCALABLE,
        name="Batch Scalable (BBSILP)",
        description="Split into 20+20 batches, learn in parallel, merge hypotheses (> 87KB tasks)",
        max_bk_chars=30000,  # Per batch
        max_examples=40,     # 20 pos + 20 neg per batch
        include_schema=True,
        include_statistics=True,
        include_sample_facts=True,
        sample_facts_per_predicate=5,
    ),
}


@dataclass
class StrategyResult:
    """Result of applying a prompting strategy."""
    strategy_type: StrategyType
    strategy_name: str
    bk_content: str
    examples_content: str
    metadata: Dict = field(default_factory=dict)
    
    @property
    def total_chars(self) -> int:
        return len(self.bk_content) + len(self.examples_content)


class PromptStrategySelector:
    """
    Automatically selects and applies the best prompting strategy
    based on dataset characteristics.
    """
    
    def __init__(self, task_dir: str):
        self.task_dir = task_dir
        self.adapter = BKAdapter(task_dir)
        self.profile = self.adapter.profile
        self._selected_strategy: Optional[StrategyType] = None
        
    def select_strategy(self, task_size_bytes: int = 0) -> StrategyType:
        """
        Automatically select strategy based on task size.
        
        Decision:
        - Task size < 87KB -> FULL_CONTEXT (send everything)
        - Task size >= 87KB -> BATCH_SCALABLE (BBSILP batching)
        """
        # 87KB threshold (zendo2 size)
        LARGE_TASK_THRESHOLD = 87 * 1024
        
        # Calculate task size if not provided - use actual file sizes
        if task_size_bytes == 0:
            exs_path = os.path.join(self.task_dir, "exs.pl")
            bias_path = os.path.join(self.task_dir, "bias.pl")
            exs_size = os.path.getsize(exs_path) if os.path.exists(exs_path) else 0
            bias_size = os.path.getsize(bias_path) if os.path.exists(bias_path) else 0
            task_size_bytes = self.profile.bk_size_bytes + exs_size + bias_size
        
        if task_size_bytes >= LARGE_TASK_THRESHOLD:
            self._selected_strategy = StrategyType.BATCH_SCALABLE
        else:
            self._selected_strategy = StrategyType.FULL_CONTEXT
        
        return self._selected_strategy
    
    def get_strategy_config(self) -> StrategyConfig:
        """Get configuration for the selected strategy."""
        if self._selected_strategy is None:
            self.select_strategy()
        return STRATEGY_CONFIGS[self._selected_strategy]
    
    def apply_strategy(self, 
                       positive_examples: List[str] = None,
                       negative_examples: List[str] = None) -> StrategyResult:
        """Apply the selected strategy to generate optimized prompt content."""
        if self._selected_strategy is None:
            self.select_strategy()
        
        config = self.get_strategy_config()
        
        if self._selected_strategy == StrategyType.BATCH_SCALABLE:
            # For BATCH_SCALABLE, return full context (batching handled by BBSILP)
            return self._apply_full_context(config, positive_examples, negative_examples)
        else:
            # FULL_CONTEXT: send everything
            return self._apply_full_context(config, positive_examples, negative_examples)
    
    def _apply_full_context(self, config: StrategyConfig, positive_examples: List[str] = None, negative_examples: List[str] = None) -> StrategyResult:
        """Strategy: Send complete BK and all examples."""
        bk_content = self.adapter.get_full_bk()
        
        # Add Grounded Examples if examples are provided
        examples_list = (positive_examples or []) + (negative_examples or [])
        if examples_list:
            grounded = self.adapter._build_grounded_examples(examples_list)
            if grounded:
                bk_content += "\n\n" + grounded
                
        # Use passed examples if provided (for partial cover filtering), else get from file
        if positive_examples or negative_examples:
            examples_lines = []
            if positive_examples:
                examples_lines.extend(positive_examples)
            if negative_examples:
                examples_lines.extend(negative_examples)
            examples_content = '\n'.join(examples_lines)
        else:
            examples_content = self.adapter.get_full_examples()
        
        return StrategyResult(
            strategy_type=StrategyType.FULL_CONTEXT,
            strategy_name=config.name,
            bk_content=bk_content,
            examples_content=examples_content,
            metadata={"compression": "none"}
        )
    
    def _build_strategy_header(self, config: StrategyConfig) -> str:
        p = self.profile
        return f"""% ============================================
% BACKGROUND KNOWLEDGE ({config.name} Strategy)
% ============================================
% Original: {p.bk_size_bytes:,} bytes, {p.bk_line_count:,} lines
% Predicates: {p.predicate_count}
% Examples: {p.pos_count} positive, {p.neg_count} negative
% ============================================"""
    
    def _build_schema_section(self) -> str:
        pred_info = self.adapter._get_predicate_info()
        lines = ["% PREDICATE SCHEMA", "% " + "-" * 40]
        sorted_preds = sorted(pred_info.values(), key=lambda x: x.count, reverse=True)
        for info in sorted_preds[:30]:
            lines.append(f"% {info.signature}: {info.count} facts")
        if len(sorted_preds) > 30:
            lines.append(f"% ... and {len(sorted_preds) - 30} more predicates")
        return "\n".join(lines)
    
    def _build_statistics_section(self) -> str:
        pred_info = self.adapter._get_predicate_info()
        total_facts = sum(p.count for p in pred_info.values())
        lines = ["% STATISTICS", "% " + "-" * 40]
        lines.append(f"% Total facts: {total_facts:,}")
        lines.append(f"% Unique predicates: {len(pred_info)}")
        return "\n".join(lines)
    
    def _build_sampled_facts_section(self, samples_per_pred: int) -> str:
        pred_info = self.adapter._get_predicate_info()
        lines = [f"% SAMPLE FACTS ({samples_per_pred} per predicate)", "% " + "-" * 40]
        for key in sorted(pred_info.keys()):
            info = pred_info[key]
            lines.append(f"% --- {info.signature} ---")
            for fact in info.sample_facts[:samples_per_pred]:
                lines.append(fact)
        return "\n".join(lines)
    
    def _build_relevant_facts_section(self, examples: List[str], max_facts: int = 100) -> str:
        if not examples:
            return ""
        entities = set()
        for ex in examples:
            entities.update(re.findall(r'\b([a-z][a-z0-9_]*)\b', ex))
        
        relevant_facts = []
        with open(self.adapter.bk_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith(('%', ':-')):
                    continue
                for entity in entities:
                    if entity in line:
                        relevant_facts.append(line)
                        break
                if len(relevant_facts) >= max_facts:
                    break
        
        if not relevant_facts:
            return ""
        lines = [f"% EXAMPLE-RELEVANT FACTS ({len(relevant_facts)} facts)", "% " + "-" * 40]
        lines.extend(relevant_facts)
        return "\n".join(lines)
    
    def _build_example_analysis_header(self, pos: List[str] = None, neg: List[str] = None) -> str:
        pos_count = len(pos) if pos else 0
        neg_count = len(neg) if neg else 0
        total = pos_count + neg_count
        ratio = pos_count / total * 100 if total > 0 else 0
        return f"""% ============================================
% EXAMPLES ANALYSIS
% ============================================
% Total: {total:,} examples
% Positive: {pos_count:,} ({ratio:.1f}%)
% Negative: {neg_count:,}
% ============================================"""
    
    def _build_pattern_analysis(self, pos: List[str] = None, neg: List[str] = None) -> str:
        lines = ["% PATTERN ANALYSIS", "% " + "-" * 40]
        if pos:
            pos_entities = set()
            for ex in pos[:100]:
                pos_entities.update(re.findall(r'\b([a-z]+)\d+', ex))
            lines.append(f"% Positive entity prefixes: {', '.join(sorted(pos_entities)[:10])}")
        if neg:
            neg_entities = set()
            for ex in neg[:100]:
                neg_entities.update(re.findall(r'\b([a-z]+)\d+', ex))
            lines.append(f"% Negative entity prefixes: {', '.join(sorted(neg_entities)[:10])}")
        return "\n".join(lines)
    
    def _sample_examples(self, examples: List[str], max_count: int) -> List[str]:
        if not examples or len(examples) <= max_count:
            return examples or []
        half = max_count // 2
        return examples[:half] + examples[-half:]
    
    def _build_sampled_examples_section(self, sampled_pos: List[str], total_pos: int,
                                        sampled_neg: List[str], total_neg: int) -> str:
        lines = ["% --- POSITIVE EXAMPLES ---"]
        for ex in sampled_pos:
            if not ex.startswith('pos('):
                lines.append(f"pos({ex}).")
            else:
                lines.append(ex if ex.endswith('.') else ex + '.')
        if len(sampled_pos) < total_pos:
            lines.append(f"% ... and {total_pos - len(sampled_pos)} more positive examples")
        
        lines.append("")
        lines.append("% --- NEGATIVE EXAMPLES ---")
        for ex in sampled_neg:
            if not ex.startswith('neg('):
                lines.append(f"neg({ex}).")
            else:
                lines.append(ex if ex.endswith('.') else ex + '.')
        if len(sampled_neg) < total_neg:
            lines.append(f"% ... and {total_neg - len(sampled_neg)} more negative examples")
        return "\n".join(lines)
    
    def _extract_relational_chains(self, examples: List[str], max_depth: int = 2, max_facts: int = 500) -> str:
        entities = set()
        for ex in examples[:30]:
            entities.update(re.findall(r'\b([a-z][a-z0-9_]*)\b', ex))
        
        all_facts = set()
        current_entities = entities.copy()
        facts_by_depth = defaultdict(list)
        
        for depth in range(max_depth):
            new_entities = set()
            with open(self.adapter.bk_path, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith(('%', ':-')):
                        continue
                    for entity in current_entities:
                        if entity in line and line not in all_facts:
                            all_facts.add(line)
                            facts_by_depth[depth].append(line)
                            new_entities.update(re.findall(r'\b([a-z][a-z0-9_]*)\b', line))
                            break
                    if len(all_facts) >= max_facts:
                        break
            if len(all_facts) >= max_facts:
                break
            current_entities = new_entities - entities
            entities.update(new_entities)
        
        lines = [f"% RELATIONAL CHAIN FACTS (depth={max_depth}, {len(all_facts)} facts)", "% " + "-" * 40]
        for depth in range(max_depth):
            if facts_by_depth[depth]:
                lines.append(f"% --- Depth {depth} ({len(facts_by_depth[depth])} facts) ---")
                for fact in facts_by_depth[depth][:100]:
                    lines.append(fact)
                if len(facts_by_depth[depth]) > 100:
                    lines.append(f"% ... and {len(facts_by_depth[depth]) - 100} more")
        return "\n".join(lines)


def select_strategy_for_task(task_dir: str) -> Tuple[StrategyType, StrategyConfig]:
    """Convenience function to select strategy for a task."""
    selector = PromptStrategySelector(task_dir)
    strategy = selector.select_strategy()
    config = selector.get_strategy_config()
    return strategy, config


def apply_strategy_for_task(task_dir: str, positive_examples: List[str] = None,
                            negative_examples: List[str] = None) -> StrategyResult:
    """Convenience function to apply best strategy for a task."""
    selector = PromptStrategySelector(task_dir)
    selector.select_strategy()
    return selector.apply_strategy(positive_examples, negative_examples)
