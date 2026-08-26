"""
Streamlit Web UI for Cascade-Popper ILP Agent.
Run with: streamlit run app.py
"""

import streamlit as st
import time
import os
import sys
import re
import json
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    filename='app.log',
    filemode='a',
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
# Also log to console
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
logging.getLogger('').addHandler(console_handler)

def log_message(msg):
    logging.info(msg)
    # Optional: could also add to session state if we want immediate UI updates without file read
    # if "logs" not in st.session_state: st.session_state.logs = []
    # st.session_state.logs.append(f"{datetime.now().strftime('%H:%M:%S')} - {msg}")

# Add parent directory to path so we can import cascade_popper as a package
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from cascade_popper.loop import CascadePopperLoop
from cascade_popper.cascade_generator import Constraint
from cascade_popper.bk_adapter import BKAdapter
from cascade_popper.prompt_strategies import PromptStrategySelector, StrategyType
from cascade_popper.batch_ilp import BatchILPProcessor, BBSILPConfig, is_task_large
from cascade_popper.inherit_test import prepare_clauses_from_hypotheses, test_inherited_clauses

# Import Gemini API
try:
    from google import genai
    from google.genai import types
    GENAI_AVAILABLE = True
except ImportError:
    GENAI_AVAILABLE = False

# Import Anthropic (Claude) API
try:
    import anthropic
    ANTHROPIC_AVAILABLE = True
except ImportError:
    ANTHROPIC_AVAILABLE = False

# Import OpenAI (GPT) API
try:
    from openai import OpenAI
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False

# --- Page Config ---
st.set_page_config(page_title="Cascade-Popper Agent", layout="wide")
st.title("Cascade-Popper: ILP Agent")

# --- Sidebar: Configuration ---
with st.sidebar:
    st.header("Settings")
    
    # LLM Provider Selection
    llm_provider = st.radio("LLM Provider", ["Gemini", "Claude", "GPT"], horizontal=True)
    
    # API Key Handling (provider-specific)
    if llm_provider == "Gemini":
        api_key = st.text_input("Gemini API Key", type="password", 
                                value=os.environ.get("GEMINI_API_KEY", ""))
        if api_key:
            os.environ["GEMINI_API_KEY"] = api_key
    elif llm_provider == "Claude":
        api_key = st.text_input("Claude API Key", type="password",
                                value=os.environ.get("ANTHROPIC_API_KEY", ""))
        if api_key:
            os.environ["ANTHROPIC_API_KEY"] = api_key
    else:
        api_key = st.text_input("OpenAI API Key", type="password",
                                value=os.environ.get("OPENAI_API_KEY", ""))
        if api_key:
            os.environ["OPENAI_API_KEY"] = api_key
    
    # Task Directory Browser
    st.subheader("📁 Tasks Directory")
    default_base_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Use text input directly - no session state caching that prevents updates
    base_tasks_dir = st.text_input("Base Tasks Directory", value=default_base_dir, 
                                    help="Directory containing task folders (each with bias.pl, bk.pl, exs.pl)")
    
    # Tip for changing directory
    st.caption("💡 Edit path above to point at any directory of task folders")
    
    # Get list of available tasks (cached to avoid slow directory scanning)
    @st.cache_data(ttl=60)
    def get_available_tasks(dir_path):
        tasks = []
        if os.path.exists(dir_path):
            for item in sorted(os.listdir(dir_path)):
                item_path = os.path.join(dir_path, item)
                if os.path.isdir(item_path) and (os.path.exists(os.path.join(item_path, "bias.pl")) or os.path.exists(os.path.join(item_path, "exs.pl"))):
                    tasks.append(item)
        return tasks
    
    available_tasks = get_available_tasks(base_tasks_dir)
    if not available_tasks and not os.path.exists(base_tasks_dir):
        st.warning(f"⚠️ Directory not found: {base_tasks_dir}")
    
    st.subheader("Task Selection")
    if available_tasks:
        # Use a unique key based on base_tasks_dir to reset selectbox when directory changes
        selectbox_key = f"task_select_{hash(base_tasks_dir)}"
        
        # Get previously selected task if it exists in new directory
        prev_selected = st.session_state.get("selected_task_name", None)
        default_idx = 0
        
        if prev_selected and prev_selected in available_tasks:
            default_idx = available_tasks.index(prev_selected)
        else:
            # Try to find a default task
            for default_task in ["zendo1", "trains1", "imdb1"]:
                if default_task in available_tasks:
                    default_idx = available_tasks.index(default_task)
                    break
        
        selected_task = st.selectbox("Select Task", available_tasks, index=default_idx, key=selectbox_key)
        st.session_state.selected_task_name = selected_task
        task_dir = os.path.join(base_tasks_dir, selected_task)
        print(f"DEBUG: Task selected: {selected_task}, task_dir: {task_dir}")
    else:
        st.info("No tasks found. Make sure directory contains folders with bias.pl or exs.pl")
        task_dir = st.text_input("Task Directory (manual)", value=base_tasks_dir)
    if llm_provider == "Gemini":
        model_name = st.selectbox("Model", ["gemini-3.1-pro-preview", "gemini-2.5-pro", "gemini-3-pro-preview", "gemini-2.5-flash", "gemini-2.0-flash"])
    elif llm_provider == "Claude":
        model_name = st.selectbox("Model", ["claude-opus-4-6", "claude-sonnet-4-6", "claude-sonnet-4-20250514", "claude-opus-4-20250116"])
    else:
        model_name = st.selectbox("Model", ["gpt-5.4", "gpt-5.4-pro", "gpt-5.4-mini", "gpt-5.4-nano"])
    max_iters = st.number_input("Max Iterations", value=10, min_value=1, max_value=50)
    
    st.divider()
    st.subheader("🌊 Cascade Mode")
    use_cascade_mode = st.checkbox("Use Windsurf Cascade (no API)", value=False,
                                    help="Use file-based interaction with Windsurf Cascade instead of Gemini API")
    if use_cascade_mode:
        st.info("📁 Prompts → `cascade_prompt.txt`\n📥 Responses → `cascade_response.txt`")
    
    st.divider()
    st.subheader("Custom Instructions")
    user_hint = st.text_area("Add hints/instructions for LLM", 
                              placeholder="e.g., Try using the 'blue' predicate...",
                              help="These instructions will be added to every prompt sent to the LLM")
    
    st.divider()
    keep_searching = st.checkbox("Keep searching after solution", value=False,
                                  help="Continue finding more solutions even after one is found")
    
    st.divider()
    st.subheader("🚫 NAF Control")
    naf_threshold = st.number_input("NAF threshold (iterations)", value=5, min_value=0, max_value=20,
                                     help="Enable negation as failure after this many failed iterations (0 = allow immediately)")
    if "naf_state" in st.session_state:
        st.session_state.naf_state["naf_threshold"] = naf_threshold
        # If threshold is 0, enable NAF immediately
        if naf_threshold == 0:
            st.session_state.naf_state["allow_naf"] = True
        naf_status = st.session_state.naf_state
        if naf_status.get("allow_naf", False):
            st.success(f"🔓 NAF enabled")
        else:
            failed = naf_status.get("iterations_without_naf", 0)
            st.info(f"🔒 NAF disabled ({failed}/{naf_threshold} failed)")
        deferred = len(naf_status.get("deferred_naf_clauses", []))
        if deferred > 0:
            st.caption(f"📋 {deferred} NAF clauses deferred")
    
    start_btn = st.button("Start Agent", type="primary")
    reset_btn = st.button("Reset")
    optimize_btn = st.button("🔍 Optimize Solution", help="Run optimization on the current solution to find a simpler version")

    st.divider()
    st.subheader("📸 Debug Export")
    if st.button("Export Debug for Cascade"):
        debug_export = {
            "timestamp": datetime.now().isoformat(),
            "task_dir": task_dir,
            "model": model_name,
            "metrics": st.session_state.metrics,
            "debug_log": st.session_state.debug_log,
            "preserved_good_clauses": st.session_state.get("preserved_good_clauses", []),
            "conversation_history_length": len(st.session_state.conversation_history),
        }
        debug_file = os.path.join(task_dir, "debug_for_cascade.json")
        with open(debug_file, "w", encoding="utf-8") as f:
            json.dump(debug_export, f, indent=2, default=str)
        st.success(f"📁 Saved to: {debug_file}")
        st.info("Share this file with Cascade for analysis!")
    
    st.divider()
    st.subheader("Console Log")
    if os.path.exists("app.log"):
        with open("app.log", "r") as f:
            log_content = f.read()
            # Show last 2000 chars
            st.code(log_content[-2000:], language="text")
        if st.button("Clear Log"):
            with open("app.log", "w") as f:
                f.write("")
            st.rerun()

# --- State Management ---
if "messages" not in st.session_state:
    st.session_state.messages = []
if "best_hyp" not in st.session_state:
    st.session_state.best_hyp = None
if "solved" not in st.session_state:
    st.session_state.solved = False
if "all_solutions" not in st.session_state:
    st.session_state.all_solutions = []
if "conversation_history" not in st.session_state:
    st.session_state.conversation_history = []  # For automatic context like Windsurf
if "metrics" not in st.session_state:
    st.session_state.metrics = {
        "task_dir": "",
        "model": "",
        "start_time": None,
        "end_time": None,
        "total_time_seconds": 0,
        "total_iterations": 0,
        "total_prolog_tests": 0,
        "total_subsumption_checks": 0,
        "solved": False,
        "solution": None,
        "iterations": []
    }
if "debug_log" not in st.session_state:
    st.session_state.debug_log = []  # Detailed debug info for Cascade analysis
if "optimization_progress" not in st.session_state:
    st.session_state.optimization_progress = None  # Store optimization analysis for persistent display
if "partial_cover_state" not in st.session_state:
    st.session_state.partial_cover_state = {
        "restart_with_filtered_data": False,
        "partial_cover_round": 0,
        "preserved_good_clauses": [],
        "preserved_good_clauses_strs": [],
        "covered_positives_global": set(),
        "remaining_positives": set(),
        "working_bk_content_for_prompt": "",
        "working_exs_content_for_prompt": ""
    }
if "naf_state" not in st.session_state:
    st.session_state.naf_state = {
        "allow_naf": False,  # Start with NAF disabled
        "iterations_without_naf": 0,  # Track failed iterations
        "naf_threshold": 5,  # Enable NAF after this many failed iterations
        "deferred_naf_clauses": []  # Store NAF clauses for later use
    }
if "current_task_dir" not in st.session_state:
    st.session_state.current_task_dir = ""

# Reset state when task changes (DISABLED - causing UI freeze issues)
# TODO: Fix task change detection without causing infinite reruns
task_just_changed = False
if task_just_changed:
    st.session_state.last_loaded_task = new_task_name
    st.session_state.current_task_dir = task_dir
    st.session_state.messages = []
    st.session_state.best_hyp = None
    st.session_state.solved = False
    st.session_state.all_solutions = []
    # Reset NAF state for new task
    st.session_state.naf_state = {
        "allow_naf": False,
        "iterations_without_naf": 0,
        "naf_threshold": 5,
        "deferred_naf_clauses": []
    }
    # Reset partial cover state for new task
    st.session_state.partial_cover_state = {
        "restart_with_filtered_data": False,
        "partial_cover_round": 0,
        "preserved_good_clauses": [],
        "preserved_good_clauses_strs": [],
        "covered_positives_global": set(),
        "remaining_positives": set(),
        "working_bk_content_for_prompt": "",
        "working_exs_content_for_prompt": ""
    }
    st.session_state.conversation_history = []
    st.session_state.debug_log = []
    st.session_state.optimization_progress = None
    st.session_state.metrics = {
        "task_dir": "",
        "model": "",
        "start_time": None,
        "end_time": None,
        "total_time_seconds": 0,
        "total_iterations": 0,
        "total_prolog_tests": 0,
        "total_subsumption_checks": 0,
        "solved": False,
        "solution": None,
        "iterations": []
    }
    log_message(f"Task changed to: {st.session_state.get('selected_task_name', '')} - state reset")

if reset_btn:
    st.session_state.messages = []
    st.session_state.best_hyp = None
    st.session_state.solved = False
    st.session_state.all_solutions = []
    st.session_state.conversation_history = []  # Reset conversation history
    st.session_state.debug_log = []  # Reset debug log
    st.session_state.metrics = {
        "task_dir": "",
        "model": "",
        "start_time": None,
        "end_time": None,
        "total_time_seconds": 0,
        "total_iterations": 0,
        "total_prolog_tests": 0,
        "total_subsumption_checks": 0,
        "solved": False,
        "solution": None,
        "iterations": []
    }
    st.rerun()

# Handle optimize button - set flag to trigger optimization
if optimize_btn:
    # First check session state, then check hypothesis.pl file
    if st.session_state.best_hyp:
        st.session_state.run_optimization = True
        log_message("Manual optimization triggered by user (from session)")
    else:
        # Try to load from hypothesis.pl in task directory
        hypothesis_file = os.path.join(task_dir, "hypothesis.pl")
        if os.path.exists(hypothesis_file):
            try:
                with open(hypothesis_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                    # Extract all non-comment lines as the hypothesis
                    hyp_lines = [line.strip() for line in content.split('\n') 
                                if line.strip() and not line.strip().startswith('%')]
                    if hyp_lines:
                        loaded_hyp = '\n'.join(hyp_lines)
                        st.session_state.best_hyp = loaded_hyp
                        st.session_state.run_optimization = True
                        log_message(f"Manual optimization triggered - loaded {len(hyp_lines)} clauses from hypothesis.pl")
                    else:
                        st.warning("hypothesis.pl exists but contains no valid clauses.")
            except Exception as e:
                st.error(f"Error loading hypothesis.pl: {e}")
        else:
            st.warning("No solution to optimize. Run the agent first or ensure hypothesis.pl exists in the task directory.")

# Initialize optimization flag
if "run_optimization" not in st.session_state:
    st.session_state.run_optimization = False

# --- Main Layout ---
col1, col2 = st.columns([2, 1])

# --- RIGHT COLUMN: Status & File Viewer ---
with col2:
    st.subheader("Current Status")
    # Single placeholder for all status content (can be cleared/updated)
    realtime_status = st.empty()
    
    # Only show file-based status if NOT currently running (session state check)
    if "is_running" not in st.session_state:
        st.session_state.is_running = False
    
    if not st.session_state.is_running:
        # Load metrics from JSON file if exists (persists across refreshes)
        metrics_file = os.path.join(task_dir, "metrics.json")
        loaded_metrics = None
        if os.path.exists(metrics_file):
            try:
                with open(metrics_file, 'r', encoding='utf-8') as f:
                    loaded_metrics = json.load(f)
            except:
                pass
        
        # Load solution from hypothesis.pl if exists
        hypothesis_file = os.path.join(task_dir, "hypothesis.pl")
        loaded_solution = None
        if os.path.exists(hypothesis_file):
            try:
                with open(hypothesis_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                    # Extract the actual hypothesis (skip comment lines)
                    for line in content.split('\n'):
                        line = line.strip()
                        if line and not line.startswith('%'):
                            loaded_solution = line
                            break
            except:
                pass
        
        # Display file-based status in the placeholder
        with realtime_status.container():
            if loaded_metrics and loaded_metrics.get("solved") and loaded_solution:
                st.success("SOLVED! (from previous run)")
                st.code(loaded_solution, language="prolog")
                with st.expander("📊 Metrics Summary", expanded=True):
                    st.write(f"**Iterations:** {loaded_metrics.get('total_iterations', 0)}")
                    st.write(f"**Prolog Tests:** {loaded_metrics.get('total_prolog_tests', 0)}")
                    st.write(f"**Subsumption Checks:** {loaded_metrics.get('total_subsumption_checks', 0)}")
                    st.write(f"**Total Time:** {loaded_metrics.get('total_time_seconds', 0):.2f}s")
            elif loaded_solution:
                st.info("Previous solution found:")
                st.code(loaded_solution, language="prolog")
            else:
                st.info("Click 'Start Agent' to begin learning.")

    # --- PERSISTENT OPTIMIZATION PROGRESS DISPLAY ---
    if st.session_state.optimization_progress:
        opt_prog = st.session_state.optimization_progress
        st.subheader("🔧 Optimization Progress")
        
        # Show status indicator
        status = opt_prog.get("status", "unknown")
        if status == "success":
            st.success(f"✨ Optimization Successful!")
            st.write(f"**Reduced from {opt_prog.get('original_literals', '?')} to {opt_prog.get('new_literals', '?')} literals**")
            if opt_prog.get("optimized_hypothesis"):
                st.code(opt_prog["optimized_hypothesis"], language="prolog")
        elif status == "failed":
            st.warning(f"⚠️ Optimization Failed: {opt_prog.get('reason', 'unknown')}")
            if opt_prog.get("coverage"):
                st.write(f"Coverage: pos={opt_prog['coverage'].get('pos', '?')}, neg={opt_prog['coverage'].get('neg', '?')}")
        elif status == "analyzing":
            st.info("🔄 Optimization in progress...")
        
        # Show LLM analysis in expander
        if opt_prog.get("analysis"):
            with st.expander("🧠 LLM Optimization Analysis", expanded=True):
                st.markdown(opt_prog["analysis"])
        
        # Show timing
        if opt_prog.get("llm_time"):
            st.caption(f"LLM time: {opt_prog['llm_time']}s | {opt_prog.get('timestamp', '')}")
        
        # Clear button
        if st.button("Clear Optimization Progress", key="clear_opt_progress"):
            st.session_state.optimization_progress = None
            st.rerun()

    st.subheader("Task Context")
    # Cache file reading to avoid slow repeated reads
    @st.cache_data(ttl=120)
    def read_task_file(file_path, max_len=5000):
        try:
            if os.path.exists(file_path):
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    if len(content) > max_len:
                        return content[:max_len] + f"\n... (truncated, {len(content)} chars total)"
                    return content
        except:
            pass
        return None
    
    # Show task files in collapsed expanders (cached reads)
    bias_content = read_task_file(os.path.join(task_dir, "bias.pl"))
    if bias_content:
        with st.expander("Language Bias (bias.pl)", expanded=False):
            st.code(bias_content, language="prolog")
    
    exs_content_preview = read_task_file(os.path.join(task_dir, "exs.pl"), max_len=3000)
    if exs_content_preview:
        with st.expander("Examples (exs.pl)", expanded=False):
            st.code(exs_content_preview, language="prolog")
    
    bk_content_preview = read_task_file(os.path.join(task_dir, "bk.pl"), max_len=2000)
    if bk_content_preview:
        with st.expander("Background Knowledge (bk.pl)", expanded=False):
            st.code(bk_content_preview, language="prolog")

# --- LEFT COLUMN: The Chat Interface ---
with col1:
    st.subheader("Agent Log")
    
    # Display History
    for msg in st.session_state.messages:
        with st.chat_message(msg["role"]):
            if "code" in msg:
                st.code(msg["code"], language="prolog")
            st.write(msg["content"])

    # --- Helper Functions ---
    
    def is_recursive_hypothesis(hypothesis: str) -> bool:
        """Check if a hypothesis is recursive (head predicate appears in body)."""
        import re
        for line in hypothesis.split('\n'):
            line = line.strip()
            if not line or not ':-' in line:
                continue
            # Extract head predicate
            head_match = re.match(r'(\w+)\s*\(', line)
            if not head_match:
                continue
            head_pred = head_match.group(1)
            # Check if head predicate appears in body
            body = line.split(':-')[1] if ':-' in line else ''
            # Look for head_pred( in body
            if re.search(rf'\b{head_pred}\s*\(', body):
                return True
        return False
    
    def extract_evidence(example_str: str, bk_text: str) -> str:
        """
        Universal evidence extractor with 1-hop relationship expansion.
        
        Strategy:
        1. Extract direct facts for the example ID (e.g., zendo(35) -> piece(35, p1)).
        2. Identify secondary entities (e.g., p1).
        3. Extract facts where secondary entities are the SUBJECT (1st argument) (e.g., blue(p1)).
        
        This provides context like "Object p1 belongs to example 35, AND p1 is blue" 
        without flooding context with "other red things".
        """
        import re
        
        # Extract arguments from example. e.g., "zendo(35)" -> "35", "f(a,b)" -> "a,b"
        match = re.search(r'\((.+)\)', str(example_str))
        if not match:
            return f"Input data: {example_str}"
        
        args_str = match.group(1)
        # Split by comma but respect nested structures
        args = []
        depth = 0
        current = ""
        for char in args_str:
            if char in '([':
                depth += 1
                current += char
            elif char in ')]':
                depth -= 1
                current += char
            elif char == ',' and depth == 0:
                args.append(current.strip())
                current = ""
            else:
                current += char
        if current.strip():
            args.append(current.strip())
        
        # Clean args (strip whitespace)
        search_terms = [arg.strip() for arg in args]
        
        # ENHANCEMENT: Unwrap nested predicates like f(t325) -> use t325 as search term
        # This handles trains1 format where examples are f(tXXX)
        unwrapped_terms = []
        for term in search_terms:
            # Check if term looks like a train ID (tXXX format)
            if re.match(r'^t\d+$', term):
                unwrapped_terms.append(term)
            # Check if term is a wrapped predicate like f(t325)
            elif '(' in term:
                inner_match = re.search(r'\(([^)]+)\)', term)
                if inner_match:
                    inner_arg = inner_match.group(1).strip()
                    if re.match(r'^t\d+$', inner_arg):
                        unwrapped_terms.append(inner_arg)
                    else:
                        unwrapped_terms.append(term)
                else:
                    unwrapped_terms.append(term)
            else:
                unwrapped_terms.append(term)
        
        if unwrapped_terms:
            search_terms = unwrapped_terms
        
        # Search BK for relevant lines
        extracted_lines = []
        secondary_entities = set()
        bk_lines = bk_text.split('\n')
        
        # PASS 1: Direct matches (Example ID is present)
        for line in bk_lines:
            line_stripped = line.strip()
            if not line_stripped or line_stripped.startswith('%'):
                continue
            
            is_match = False
            for term in search_terms:
                if '[' in term or '(' in term: continue
                
                # Normalize line for matching (remove spaces around commas/parens)
                line_normalized = line_stripped.replace(' ', '')
                
                # Check if term exists in line as a distinct token
                if (f"({term})" in line_normalized or f"({term}," in line_normalized or 
                    f",{term})" in line_normalized or f",{term}," in line_normalized or
                    f"_{term}" in line_normalized or f"{term}_" in line_normalized or
                    f"p{term}_" in line_normalized):
                    is_match = True
                    break
            
            if is_match:
                extracted_lines.append(line_stripped)
                
                # Extract potential secondary entities (arguments in this fact)
                # Matches "pred(arg1, arg2, ...)"
                m = re.search(r'\((.+)\)', line_stripped)
                if m:
                    # Naive split by comma (good enough for atomic args)
                    args_in_line = [a.strip() for a in m.group(1).split(',')]
                    for arg in args_in_line:
                        # Candidate if it's alphanumeric, not the search term, and looks like an ID/atom
                        # We exclude numbers to avoid expanding on values like '4' or '10'
                        if (arg not in search_terms and 
                            re.match(r'^[a-z0-9_]+$', arg) and 
                            not arg.isnumeric()): 
                            secondary_entities.add(arg)
        
        # PASS 2: 1-Hop Expansion (Facts about secondary entities)
        # ONLY include facts where the secondary entity is the SUBJECT (1st Argument)
        # This prevents exploding context (e.g., "red" -> all red things)
        if secondary_entities and len(extracted_lines) < 50:
            sorted_secondary = sorted(list(secondary_entities))
            
            for line in bk_lines:
                line_stripped = line.strip()
                if not line_stripped or line_stripped.startswith('%'):
                    continue
                
                if line_stripped in extracted_lines:
                    continue
                
                for term in sorted_secondary:
                    # Check if term is the FIRST argument: pred(term, ...) or pred(term)
                    # Regex: start of args, term, then comma or end paren
                    if re.search(rf'\(\s*{re.escape(term)}\s*[,)]', line_stripped):
                        extracted_lines.append(line_stripped)
                        break
        
        if not extracted_lines:
            # Fallback: For functional ILP (e.g. lists), the evidence is the example itself
            return f"Input data: {example_str}"
        
        # Limit to 50 lines to save context
        return '\n'.join(extracted_lines[:50])
    
    def get_feedback_prompt(previous_code: str, result, bk_text: str, feedback_templates: dict,
                            partial_cover_clauses: list = None, partial_cover_stats: dict = None,
                            full_positives_count: int = None, total_negatives_count: int = None) -> str:
        """
        Generates a universal feedback prompt based on test failure type.
        Uses lazy loading - only sends the evidence relevant to the failure.
        Includes coverage metrics to help LLM understand severity.
        
        Args:
            partial_cover_clauses: List of locked clauses that achieved partial cover (some pos, 0 neg)
            partial_cover_stats: Dict with 'covered_pos', 'total_pos', 'remaining_pos' counts
            full_positives_count: Total number of positives in full dataset (for dual statistics)
        """
        # Calculate coverage metrics
        covered_pos = len(result.covered_pos) if hasattr(result, 'covered_pos') else 0
        missed_pos = len(result.missed_pos) if hasattr(result, 'missed_pos') else 0
        total_pos = covered_pos + missed_pos
        coverage_pct = round((covered_pos / total_pos * 100) if total_pos > 0 else 0)
        
        covered_neg = len(result.covered_neg) if hasattr(result, 'covered_neg') else 0
        total_neg = total_negatives_count if total_negatives_count else covered_neg
        rejected_neg = 0  # Will be calculated as total - covered if we have total
        
        # Calculate FULL coverage (including locked clauses from partial cover)
        full_total_pos = full_positives_count if full_positives_count else total_pos
        locked_covered = 0
        if partial_cover_stats:
            locked_covered = partial_cover_stats.get('covered_pos', 0)
        full_covered_pos = locked_covered + covered_pos
        full_coverage_pct = round((full_covered_pos / full_total_pos * 100) if full_total_pos > 0 else 0)
        
        # When in partial cover mode, show FULL coverage stats (locked + current, avoiding double-count)
        if partial_cover_stats and locked_covered > 0:
            # Avoid double-counting: cap at full_total_pos
            covered_pos = min(full_covered_pos, full_total_pos)
            total_pos = full_total_pos
            coverage_pct = round((covered_pos / total_pos * 100) if total_pos > 0 else 0)
        
        # Build partial cover context if available
        partial_cover_context = ""
        if partial_cover_clauses and len(partial_cover_clauses) > 0:
            stats = partial_cover_stats or {}
            pc_covered = stats.get('covered_pos', 0)
            pc_total = stats.get('total_pos', total_pos)
            pc_remaining = stats.get('remaining_pos', missed_pos)
            
            # Build per-clause details with stats
            clause_lines = []
            for pc in partial_cover_clauses:
                if isinstance(pc, dict):
                    clause_lines.append(f"{pc['clause']}  % covers {pc['covered_count']} positives")
                else:
                    clause_lines.append(pc)  # Fallback for string format
            
            partial_cover_context = f"""
## PARTIAL COVER PROGRESS (Locked Clauses)
The following clause(s) have been LOCKED because they cover some positives with ZERO negatives:
```prolog
{chr(10).join(clause_lines)}
```

**Your task:** Find clause(s) to cover the REMAINING {pc_remaining} positives (do NOT duplicate the locked clauses).

"""
        
        # Determine failure type
        has_covered_neg = hasattr(result, 'covered_neg') and result.covered_neg
        has_missed_pos = hasattr(result, 'missed_pos') and result.missed_pos
        
        # CASE 1: TOO GENERAL (False Positive) - covered negatives
        if has_covered_neg:
            neg_list = list(result.covered_neg)
            failed_example = neg_list[0]
            evidence = extract_evidence(str(failed_example), bk_text)
            
            if feedback_templates.get("too_general"):
                return feedback_templates["too_general"].format(
                    previous_code=previous_code,
                    failed_negative_example=failed_example,
                    example_facts=evidence,
                    covered_pos=covered_pos,
                    total_pos=total_pos,
                    coverage_pct=coverage_pct,
                    covered_neg=covered_neg,
                    total_neg=total_neg if total_neg > 0 else covered_neg,
                    partial_cover_context=partial_cover_context
                )
            else:
                return f"""SYSTEM FEEDBACK: HYPOTHESIS TOO GENERAL (False Positive)
{partial_cover_context}
%%% BIAS HINTS %%%
% See constraints above

STATUS REPORT:
- Hypothesis Coverage: {covered_pos}/{total_pos} positives ({coverage_pct}%)
- Negatives Wrongly Covered: {covered_neg} (MUST be 0)
- Goal: 100% positive coverage, 0% negative coverage

FAILED CODE:
```prolog
{previous_code}
```

WRONGLY COVERED NEGATIVE EXAMPLE: {failed_example}

RELEVANT FACTS / CONTEXT (Evidence):
{evidence}

INSTRUCTION:
Analyze the Evidence. Find a property that distinguishes this Negative from Positives.
Add a constraint (literal) from the Background Knowledge to exclude this case.

BEAM SEARCH: Generate 3 DIFFERENT hypothesis candidates, separated by "---CANDIDATE---":
- Candidate 1: Minimal fix (add one constraint)
- Candidate 2: More specific fix (add multiple constraints)
- Candidate 3: Alternative approach using different predicates

Output in ```prolog block with ---CANDIDATE--- separators.
"""
        
        # CASE 2: TOO SPECIFIC (False Negative) - missed positives
        if has_missed_pos:
            pos_list = list(result.missed_pos)
            failed_example = pos_list[0]
            evidence = extract_evidence(str(failed_example), bk_text)
            
            if feedback_templates.get("too_specific"):
                return feedback_templates["too_specific"].format(
                    previous_code=previous_code,
                    failed_positive_example=failed_example,
                    example_facts=evidence,
                    covered_pos=covered_pos,
                    total_pos=total_pos,
                    coverage_pct=coverage_pct,
                    rejected_neg=total_neg - covered_neg if total_neg > covered_neg else total_neg,
                    total_neg=total_neg if total_neg > 0 else "N/A",
                    partial_cover_context=partial_cover_context
                )
            else:
                return f"""SYSTEM FEEDBACK: HYPOTHESIS TOO SPECIFIC (False Negative)
{partial_cover_context}
%%% BIAS HINTS %%%
% See constraints above

STATUS REPORT:
- Hypothesis Coverage: {covered_pos}/{total_pos} positives ({coverage_pct}%)
- Goal: 100% positive coverage

FAILED CODE:
```prolog
{previous_code}
```

MISSED POSITIVE EXAMPLE: {failed_example}

RELEVANT FACTS / CONTEXT (Evidence):
{evidence}

INSTRUCTION:
Compare your code against the Evidence provided.
Identify which condition in your rule fails for this specific example.
Generalize the rule or add a disjunctive clause to accommodate this case.

BEAM SEARCH: Generate 3 DIFFERENT hypothesis candidates, separated by "---CANDIDATE---":
- Candidate 1: Generalize existing rule (weaken constraints)
- Candidate 2: Add disjunctive clause for this case
- Candidate 3: Alternative approach using different predicates

Output in ```prolog block with ---CANDIDATE--- separators.
"""
        
        # Fallback
        return f"""Your hypothesis needs revision.
{partial_cover_context}
%%% BIAS HINTS %%%
% See constraints above

STATUS REPORT:
- Hypothesis Coverage: {covered_pos}/{total_pos} positives ({coverage_pct}%)

FAILED CODE:
```prolog
{previous_code}
```

BEAM SEARCH: Generate 3 DIFFERENT hypothesis candidates, separated by "---CANDIDATE---":
- Candidate 1: Simple fix
- Candidate 2: More specific approach
- Candidate 3: Alternative approach

Output in ```prolog block with ---CANDIDATE--- separators.
"""
    
    def extract_predicates_from_hypothesis(hypothesis: str) -> set:
        """Extract BODY predicate names used in a hypothesis (excludes head predicate)."""
        import re
        predicates = set()
        head_predicates = set()
        
        # First, find all head predicates (before :-)
        for line in hypothesis.split('\n'):
            line = line.strip()
            if ':-' in line:
                head_match = re.match(r'(\w+)\s*\(', line)
                if head_match:
                    head_predicates.add(head_match.group(1))
        
        # Now extract body predicates (after :-)
        for line in hypothesis.split('\n'):
            line = line.strip()
            if ':-' in line:
                body = line.split(':-', 1)[1] if ':-' in line else line
                for match in re.finditer(r'\b(\w+)\s*\(', body):
                    pred = match.group(1)
                    # Skip Prolog built-ins and head predicates
                    if pred not in ['pos', 'neg', 'not'] and pred not in head_predicates:
                        predicates.add(pred)
        return predicates
    
    def validate_hypothesis_against_bias(hypothesis: str, bias_content: str) -> tuple:
        """
        Validate that all predicates used in hypothesis body are declared in bias.
        
        Returns:
            (is_valid: bool, invalid_predicates: list, valid_predicates: set)
        """
        import re
        
        # Parse body_pred declarations from bias
        allowed_predicates = set()
        for match in re.findall(r'body_pred\((\w+),\s*(\d+)\)', bias_content):
            pred_name = match[0]
            allowed_predicates.add(pred_name)
        
        # Also add head_pred as valid (for recursive rules)
        for match in re.findall(r'head_pred\((\w+),\s*(\d+)\)', bias_content):
            pred_name = match[0]
            allowed_predicates.add(pred_name)
        
        # Extract predicates used in hypothesis body
        used_predicates = set()
        head_predicates = set()
        
        # Find head predicates first
        for line in hypothesis.split('\n'):
            line = line.strip()
            if ':-' in line:
                head_match = re.match(r'(\w+)\s*\(', line)
                if head_match:
                    head_predicates.add(head_match.group(1))
        
        # Extract body predicates
        for line in hypothesis.split('\n'):
            line = line.strip()
            if ':-' in line:
                body = line.split(':-', 1)[1]
                for match in re.finditer(r'\b(\w+)\s*\(', body):
                    pred = match.group(1)
                    # Skip Prolog built-ins
                    builtins = {'not', 'is', 'abs', 'mod', 'div', 'max', 'min', 
                               'length', 'append', 'member', 'findall', 'bagof', 'setof'}
                    if pred not in builtins and pred not in head_predicates:
                        used_predicates.add(pred)
        
        # Find invalid predicates (used but not declared in bias)
        invalid_predicates = used_predicates - allowed_predicates
        
        return len(invalid_predicates) == 0, list(invalid_predicates), allowed_predicates
    
    def filter_valid_clauses(clauses: list, bias_content: str, log_fn=None) -> list:
        """
        Filter out clauses that use predicates not in the bias.
        Returns only valid clauses.
        """
        valid_clauses = []
        for clause in clauses:
            is_valid, invalid_preds, _ = validate_hypothesis_against_bias(clause, bias_content)
            if is_valid:
                valid_clauses.append(clause)
            elif log_fn:
                log_fn(f"⚠️ Rejected clause with undefined predicates {invalid_preds}: {clause[:80]}...")
        return valid_clauses
    
    def contains_naf(clause: str) -> bool:
        """Check if a clause contains negation as failure (\+ or not())."""
        import re
        # Match \+ pred(...) or not(pred(...))
        if re.search(r'\\\+\s*\w+\s*\(', clause):
            return True
        if re.search(r'\bnot\s*\(\s*\w+\s*\(', clause):
            return True
        return False
    
    def filter_naf_clauses(clauses: list, allow_naf: bool = False, log_fn=None) -> tuple:
        """
        Separate clauses into non-NAF and NAF groups.
        Prefer simpler solutions without negation first.
        
        Args:
            clauses: List of Prolog clauses
            allow_naf: If False, prefer non-NAF clauses. If True, return all.
            log_fn: Optional logging function
            
        Returns:
            (preferred_clauses, deferred_naf_clauses)
        """
        non_naf = []
        naf = []
        
        for clause in clauses:
            if contains_naf(clause):
                naf.append(clause)
                if log_fn and not allow_naf:
                    log_fn(f"⏳ Deferred NAF clause (trying simpler solutions first): {clause[:60]}...")
            else:
                non_naf.append(clause)
        
        if allow_naf:
            return clauses, []  # Return all clauses if NAF is allowed
        else:
            return non_naf, naf  # Prefer non-NAF, keep NAF for fallback
    
    def extract_negated_literals(clause: str) -> list:
        """Extract negated literals from a clause (\+ or not())."""
        import re
        negated = []
        # Match \+ pred(...) or not(pred(...))
        for match in re.finditer(r'\\\+\s*(\w+\([^)]+\))', clause):
            negated.append(match.group(1))
        for match in re.finditer(r'not\s*\(\s*(\w+\([^)]+\))\s*\)', clause):
            negated.append(match.group(1))
        return negated
    
    def extract_facts_for_example(bk_content: str, example_id: str, predicates: set = None) -> str:
        """Extract all facts from BK related to a specific example ID.
        If predicates is provided, only extract facts for those predicates."""
        facts = []
        import re
        match = re.search(r'\((\d+)\)', example_id)
        if not match:
            return ""
        example_num = match.group(1)
        
        # Find all facts that reference this example number
        for line in bk_content.split('\n'):
            line = line.strip()
            if line and not line.startswith('%'):
                if re.search(rf'\b{example_num}\b', line):
                    # If predicates filter provided, check if this fact uses one of them
                    if predicates:
                        pred_match = re.match(r'(\w+)\s*\(', line)
                        if pred_match and pred_match.group(1) in predicates:
                            facts.append(line)
                    else:
                        facts.append(line)
        
        return '\n'.join(facts)
    
    def extract_all_facts_for_example(bk_content: str, example_id: str) -> dict:
        """Extract ALL facts from BK for an example, organized by predicate."""
        import re
        facts_by_pred = {}
        match = re.search(r'\((\d+)\)', example_id)
        if not match:
            return facts_by_pred
        example_num = match.group(1)
        
        for line in bk_content.split('\n'):
            line = line.strip()
            if line and not line.startswith('%'):
                if re.search(rf'\b{example_num}\b', line):
                    pred_match = re.match(r'(\w+)\s*\(', line)
                    if pred_match:
                        pred = pred_match.group(1)
                        if pred not in facts_by_pred:
                            facts_by_pred[pred] = []
                        facts_by_pred[pred].append(line)
        
        return facts_by_pred
    
    def find_missing_predicates(hypothesis_preds: set, example_facts: dict) -> list:
        """Find predicates used in hypothesis but missing from example facts (CWA)."""
        missing = []
        for pred in hypothesis_preds:
            if pred not in example_facts:
                missing.append(pred)
        return missing
    
    def generate_candidate_refinements(hypothesis_preds: set, neg_facts: dict, pos_facts_list: list) -> list:
        """Generate candidate refinement literals that are false in negative but true in positives."""
        candidates = []
        
        # Find predicates present in positives but absent in the negative
        neg_preds = set(neg_facts.keys())
        for pos_facts in pos_facts_list[:5]:  # Check first 5 positives
            pos_preds = set(pos_facts.keys())
            for pred in pos_preds - neg_preds:
                if pred in hypothesis_preds or pred in ['piece']:
                    continue
                candidates.append({
                    'literal': f"{pred}(P)",
                    'rationale': f"{pred} present in positives but absent in this negative"
                })
        
        # Find predicates absent in negative (CWA candidates)
        common_attrs = ['blue', 'green', 'red', 'yellow', 'purple', 'upright', 'strange', 
                        'lhs', 'rhs', 'small', 'medium', 'large', 'contact']
        for attr in common_attrs:
            if attr not in neg_preds and attr in hypothesis_preds:
                continue  # Already in hypothesis
            if attr not in neg_preds:
                candidates.append({
                    'literal': f"{attr}(P)",
                    'rationale': f"No {attr}/1 facts for this negative - adding would block it"
                })
        
        # Deduplicate and limit
        seen = set()
        unique = []
        for c in candidates:
            if c['literal'] not in seen:
                seen.add(c['literal'])
                unique.append(c)
        
        return unique[:5]
    
    def compute_predicate_discrimination(bk_text: str, positives: list, negatives: list) -> dict:
        """
        ENHANCEMENT: Analyze which predicates discriminate positives from negatives.
        Counts how many EXAMPLES (not facts) contain each predicate.
        Returns dict with predicate stats: {pred: {'pos_examples': N, 'neg_examples': M, 'discrimination': score}}
        Higher discrimination score = predicate appears in higher proportion of positives.
        """
        import re
        from collections import defaultdict
        
        # Extract train IDs from examples
        def extract_id(example):
            m = re.search(r't\d+', str(example))
            return m.group(0) if m else None
        
        pos_ids = set(extract_id(p) for p in positives if extract_id(p))
        neg_ids = set(extract_id(n) for n in negatives if extract_id(n))
        
        # For each example, track which predicates it has
        pos_example_preds = defaultdict(set)  # example_id -> set of predicates
        neg_example_preds = defaultdict(set)
        
        for line in bk_text.split('\n'):
            line = line.strip()
            if not line or line.startswith('%'):
                continue
            
            # Extract predicate name
            pred_match = re.match(r'(\w+)\s*\(', line)
            if not pred_match:
                continue
            pred = pred_match.group(1)
            
            # Check which example this fact belongs to
            for pos_id in pos_ids:
                if pos_id in line:
                    pos_example_preds[pos_id].add(pred)
                    break
            for neg_id in neg_ids:
                if neg_id in line:
                    neg_example_preds[neg_id].add(pred)
                    break
        
        # Count how many examples have each predicate
        pred_pos_count = defaultdict(int)  # pred -> number of positive examples with this pred
        pred_neg_count = defaultdict(int)
        
        for ex_id, preds in pos_example_preds.items():
            for pred in preds:
                pred_pos_count[pred] += 1
        
        for ex_id, preds in neg_example_preds.items():
            for pred in preds:
                pred_neg_count[pred] += 1
        
        # Compute discrimination scores
        all_preds = set(pred_pos_count.keys()) | set(pred_neg_count.keys())
        results = {}
        
        num_pos = len(pos_ids)
        num_neg = len(neg_ids)
        
        for pred in all_preds:
            pos_count = pred_pos_count.get(pred, 0)
            neg_count = pred_neg_count.get(pred, 0)
            
            # Rate = proportion of examples that have this predicate
            pos_rate = pos_count / max(num_pos, 1)
            neg_rate = neg_count / max(num_neg, 1)
            
            # Discrimination: positive means more common in positives
            discrimination = pos_rate - neg_rate
            
            results[pred] = {
                'pos_examples': pos_count,
                'neg_examples': neg_count,
                'pos_rate': round(pos_rate, 3),
                'neg_rate': round(neg_rate, 3),
                'discrimination': round(discrimination, 3)
            }
        
        return results
    
    def get_discriminative_predicates(bk_text: str, positives: list, negatives: list, top_n: int = 10) -> str:
        """Get top N predicates that best discriminate positives from negatives."""
        stats = compute_predicate_discrimination(bk_text, positives, negatives)
        
        # Sort by discrimination score (positive = favors positives)
        sorted_preds = sorted(stats.items(), key=lambda x: x[1]['discrimination'], reverse=True)
        
        hints = []
        # Show top predicates that favor positives
        for pred, info in sorted_preds[:top_n]:
            if info['discrimination'] > 0.05:
                pct_pos = int(info['pos_rate'] * 100)
                pct_neg = int(info['neg_rate'] * 100)
                hints.append(f"% {pred}: {pct_pos}% of positives, {pct_neg}% of negatives (USE THIS)")
            elif info['discrimination'] < -0.05:
                pct_pos = int(info['pos_rate'] * 100)
                pct_neg = int(info['neg_rate'] * 100)
                hints.append(f"% {pred}: {pct_pos}% of positives, {pct_neg}% of negatives (avoid)")
        
        return '\n'.join(hints) if hints else ""
    
    def filter_task_for_remaining_examples(bk_content: str, exs_content: str, 
                                            remaining_positives: set, all_negatives: set) -> tuple:
        """
        Filter background knowledge and examples to only include facts relevant to 
        remaining uncovered positive examples. Used for divide-and-conquer approach.
        
        Returns: (filtered_bk, filtered_exs)
        """
        import re
        
        # Extract example IDs from remaining positives
        # Look for alphanumeric IDs like '1', 't1', 'ex_5' inside parentheses
        remaining_ids = set()
        for pos in remaining_positives:
            match = re.search(r'\((\w+)\)', pos)
            if match:
                remaining_ids.add(match.group(1))
        
        # Also include negative example IDs
        neg_ids = set()
        for neg in all_negatives:
            match = re.search(r'\((\w+)\)', neg)
            if match:
                neg_ids.add(match.group(1))
        
        all_relevant_ids = remaining_ids | neg_ids
        
        # Filter BK
        filtered_bk_lines = []
        bk_lines = bk_content.split('\n')
        
        # SAFETY CHECK: If no IDs found, assume functional task and KEEP FULL BK
        # Also if the BK is small (<20 lines), just keep it all to be safe
        if not all_relevant_ids or len(bk_lines) < 20:
             filtered_bk = bk_content
        else:
            for line in bk_lines:
                line_stripped = line.strip()
                # Always keep comments, directives, AND RULES (lines with :-)
                if not line_stripped or line_stripped.startswith('%') or line_stripped.startswith(':-') or ':-' in line_stripped:
                    filtered_bk_lines.append(line)
                    continue
                
                # Check if this fact references any relevant example ID
                should_include = False
                for ex_id in all_relevant_ids:
                    # Match exact word to avoid partial matches (e.g. id '1' matching '100')
                    if re.search(rf'\b{ex_id}\b', line_stripped):
                        should_include = True
                        break
                
                if should_include:
                    filtered_bk_lines.append(line)
            
            filtered_bk = '\n'.join(filtered_bk_lines)
        
        # Filter examples to only remaining positives and all negatives
        filtered_exs_lines = []
        for line in exs_content.split('\n'):
            line_stripped = line.strip()
            if not line_stripped or line_stripped.startswith('%'):
                filtered_exs_lines.append(line)
                continue
            
            # Check if this is a remaining positive
            if line_stripped.startswith('pos('):
                # Use robust matching: check if any remaining positive string is contained in the line
                # (This avoids complex regex matching issues)
                is_remaining = False
                for rem_pos in remaining_positives:
                    if rem_pos in line_stripped:
                        is_remaining = True
                        break
                
                if is_remaining:
                    filtered_exs_lines.append(line)
            # Keep all negatives
            elif line_stripped.startswith('neg('):
                filtered_exs_lines.append(line)
        
        filtered_exs = '\n'.join(filtered_exs_lines)
        
        return filtered_bk, filtered_exs
    
    def extract_bk_facts_for_examples(bk_content: str, example_ids: list) -> str:
        """
        Extract all facts from BK related to a list of example IDs.
        
        Returns: A string of extracted facts
        """
        facts = []
        import re
        
        for example_id in example_ids:
            # Find all facts that reference this example number
            for line in bk_content.split('\n'):
                line = line.strip()
                if line and not line.startswith('%'):
                    # Check if this fact references the example number
                    # Look for patterns like piece(116, ...) or any predicate with the ID
                    if re.search(rf'\b{example_id}\b', line):
                        facts.append(line)
        
        return '\n'.join(facts)
    
    def parse_beam_candidates(text: str) -> list:
        """Parse multiple hypothesis candidates from beam search output.
        Returns list of candidate strings, each containing one or more clauses."""
        # Split by candidate marker
        if "---CANDIDATE---" in text:
            candidates = text.split("---CANDIDATE---")
            return [c.strip() for c in candidates if c.strip()]
        else:
            # Single candidate (backwards compatible)
            return [text.strip()] if text.strip() else []
    
    def parse_prolog_clauses(text: str) -> list:
        """Extract Prolog clauses from LLM response with syntax fixing."""
        clauses = []
        # Strip code blocks
        text = text.replace("```prolog", "").replace("```", "").strip()
        
        # FIX MALFORMED SYNTAX: Join lines that are split incorrectly
        # Pattern: "pred(X) :-" followed by newline, or lines ending with "," or ",." 
        lines = text.split('\n')
        fixed_lines = []
        current_clause = ""
        
        for line in lines:
            line = line.strip()
            if not line or line.startswith('%') or line.startswith('#'):
                continue
            
            # Remove trailing periods that shouldn't be there (like ",." -> ",")
            if line == '.' or line == ',.':
                if current_clause:
                    current_clause = current_clause.rstrip(',') + '.'
                continue
            
            # Fix lines that are just commas or periods
            if line in [',', '.', ':-', ':-.']:
                if current_clause:
                    if line == ':-' or line == ':-.':
                        current_clause += ' :-'
                    elif line == ',':
                        current_clause += ','
                continue
            
            # Remove leading/trailing commas and periods that are misplaced
            line = re.sub(r'^[,\.]+', '', line).strip()
            line = re.sub(r'\.,', ',', line)  # Fix ".," -> ","
            line = re.sub(r',\.', '.', line)  # Fix ",." -> "."
            
            if not line:
                continue
            
            # Check if this starts a new clause (has head predicate)
            if re.match(r'^\w+\s*\([^)]*\)\s*:-', line) or (re.match(r'^\w+\s*\([^)]*\)', line) and not current_clause):
                # Save previous clause if exists
                if current_clause:
                    if not current_clause.endswith('.'):
                        current_clause += '.'
                    fixed_lines.append(current_clause)
                current_clause = line
            elif current_clause:
                # Continue building current clause
                if current_clause.endswith(':-') or current_clause.endswith(','):
                    current_clause += ' ' + line
                else:
                    current_clause += ', ' + line
            else:
                current_clause = line
        
        # Don't forget the last clause
        if current_clause:
            if not current_clause.endswith('.'):
                current_clause += '.'
            fixed_lines.append(current_clause)
        
        # Final cleanup: ensure each clause is valid
        for line in fixed_lines:
            line = line.strip()
            # Remove duplicate commas/periods
            line = re.sub(r',\s*,', ',', line)
            line = re.sub(r'\.\s*\.', '.', line)
            line = re.sub(r',\s*\.', '.', line)
            
            if line and re.match(r'\w+\s*\([^)]*\)', line):
                if not line.endswith('.'):
                    line += '.'
                clauses.append(line)
        
        return clauses

    def group_clauses_by_head(clauses_text):
        """
        DIVIDE: Split clauses and group by head predicate for D&C optimization.
        Returns dict: {head_predicate: [list of clauses]}
        """
        groups = {}
        clauses = clauses_text.strip().split('\n')
        for clause in clauses:
            clause = clause.strip()
            if not clause or clause.startswith('%'):
                continue
            # Extract head predicate (before :- or the whole clause if fact)
            if ':-' in clause:
                head = clause.split(':-')[0].strip()
            else:
                head = clause.rstrip('.').strip()
            # Get predicate name (before first parenthesis)
            if '(' in head:
                pred_name = head.split('(')[0].strip()
            else:
                pred_name = head
            if pred_name not in groups:
                groups[pred_name] = []
            groups[pred_name].append(clause)
        return groups

    def optimize_clause_group(group_clauses, bk_content, optimization_template, model_name, api_key, tester, pos_examples="", neg_examples="", max_iters=2, group_name="", prompt_container=None, coverage_stats="", bias_content=""):
        """
        CONQUER: Optimize a single group of clauses using LGG.
        Returns (optimized_clauses, iteration_details) where iteration_details contains prompts and coverage.
        """
        if len(group_clauses) <= 1:
            return group_clauses, []
        
        fragmented = '\n'.join(group_clauses)
        best_result = group_clauses
        best_literals = sum(c.count(',') + 1 for c in group_clauses)
        iteration_details = []
        
        for i in range(max_iters):
            st.write(f"**🔄 `{group_name}` - Iteration {i+1}/{max_iters}**")
            
            opt_prompt = optimization_template.format(
                fragmented_rules=fragmented,
                background_knowledge=bk_content,
                positive_examples=pos_examples,
                negative_examples=neg_examples,
                coverage_stats=coverage_stats,
                bias_hints=bias_content
            )
            
            # Show the full prompt sent to LLM
            with st.expander(f"📤 Prompt sent to LLM (iter {i+1}, {len(opt_prompt)} chars)", expanded=False):
                st.code(opt_prompt, language="markdown")
            
            try:
                if use_cascade_mode:
                    opt_response = call_cascade_with_display(opt_prompt, task_dir)
                else:
                    opt_response = call_llm_with_display(
                        opt_prompt, model_name, api_key,
                        conversation_history=None, cache_name=None
                    )
                
                # Show LLM response
                with st.expander(f"📥 LLM Response (iter {i+1})", expanded=False):
                    st.markdown(opt_response)
                
                opt_clauses = parse_prolog_clauses(opt_response)
                
                # BIAS VALIDATION: Filter out clauses using predicates not in bias
                if bias_content:
                    opt_clauses = filter_valid_clauses(opt_clauses, bias_content, log_message)
                
                if opt_clauses:
                    opt_hyp = '\n'.join(opt_clauses)
                    new_literals = sum(c.count(',') + 1 for c in opt_clauses)
                    
                    # Test coverage of optimized clauses
                    try:
                        test_result = tester.test_hypothesis(opt_hyp)
                        coverage_info = {
                            "is_complete": test_result.is_complete,
                            "covered_pos": len(test_result.covered_pos),
                            "covered_neg": len(test_result.covered_neg),
                            "missed_pos": len(test_result.missed_pos) if hasattr(test_result, 'missed_pos') else 0
                        }
                        
                        # Show coverage
                        if test_result.is_complete:
                            st.success(f"📊 **Coverage**: ✅ PASS | pos={coverage_info['covered_pos']}, neg={coverage_info['covered_neg']}")
                        else:
                            st.warning(f"📊 **Coverage**: ❌ FAIL | pos={coverage_info['covered_pos']}, neg={coverage_info['covered_neg']}, missed={coverage_info['missed_pos']}")
                    except Exception as e:
                        coverage_info = {"error": str(e)}
                        st.error(f"📊 **Coverage test error**: {e}")
                    
                    # Store iteration details
                    iteration_details.append({
                        "iteration": i + 1,
                        "prompt": opt_prompt,
                        "response": opt_response,
                        "clauses": opt_clauses,
                        "literals": new_literals,
                        "coverage": coverage_info
                    })
                    
                    # Show literal comparison - only accept if coverage is maintained
                    if new_literals < best_literals and coverage_info.get("is_complete", False):
                        st.success(f"✨ Improved: {best_literals} → {new_literals} literals (coverage maintained)")
                        best_result = opt_clauses
                        best_literals = new_literals
                        fragmented = '\n'.join(opt_clauses)
                    elif new_literals < best_literals:
                        st.warning(f"⚠️ Fewer literals ({new_literals}) but coverage failed - rejecting")
                    else:
                        st.info(f"ℹ️ No improvement ({new_literals} >= {best_literals} literals)")
                else:
                    st.warning(f"⚠️ No valid clauses parsed from response")
                    iteration_details.append({
                        "iteration": i + 1,
                        "prompt": opt_prompt,
                        "response": opt_response,
                        "clauses": [],
                        "error": "No valid clauses parsed"
                    })
                    
            except Exception as e:
                log_message(f"Group optimization error: {e}")
                st.error(f"❌ Iteration {i+1} error: {e}")
                iteration_details.append({
                    "iteration": i + 1,
                    "prompt": opt_prompt,
                    "error": str(e)
                })
                break
        
        return best_result, iteration_details

    def divide_and_conquer_optimize(hypothesis, bk_content, optimization_template, model_name, api_key, tester, pos_examples="", neg_examples="", bias_content=""):
        """
        DIVIDE AND CONQUER Optimization:
        1. DIVIDE: Group clauses by head predicate
        2. CONQUER: Optimize each group separately
        3. MERGE: Combine and verify the result
        """
        log_message("Starting D&C Optimization...")
        
        # ===== EXPONENTIAL SAMPLING (same as LLM-Guided Hypothesis Combination) =====
        import numpy as np
        import random
        
        sample_size = 10
        
        # Parse examples from strings
        pos_list = [l.strip() for l in pos_examples.split('\n') if l.strip()]
        neg_list = [l.strip() for l in neg_examples.split('\n') if l.strip()]
        
        # Sample positives with exponential distribution (favor earlier ones)
        if len(pos_list) > sample_size:
            weights = np.exp(-np.arange(len(pos_list)) / (len(pos_list) / 3))
            weights = weights / weights.sum()
            indices = np.random.choice(len(pos_list), size=sample_size, replace=False, p=weights)
            sampled_pos = [pos_list[i] for i in sorted(indices)]
        else:
            sampled_pos = pos_list
        
        # Sample negatives randomly
        if len(neg_list) > sample_size:
            sampled_neg = random.sample(neg_list, sample_size)
        else:
            sampled_neg = neg_list
        
        log_message(f"D&C: Sampled {len(sampled_pos)} pos, {len(sampled_neg)} neg (exponential distribution)")
        
        # Helper functions for BK filtering (same as LLM-Combination)
        def get_example_id(ex_str):
            import re
            match = re.search(r'f\((\w+)\)', str(ex_str))
            return match.group(1) if match else str(ex_str)
        
        def extract_full_grounding(bk, ex_id):
            facts = []
            for line in bk.split('\n'):
                line = line.strip()
                if line and not line.startswith('%') and ex_id in line:
                    facts.append(line)
            return '\n'.join(facts)
        
        # Filter BK to only include facts for sampled examples
        sampled_bk_lines = set()
        for ex in sampled_pos + sampled_neg:
            ex_id = get_example_id(ex)
            ex_facts = extract_full_grounding(bk_content, ex_id)
            if ex_facts:
                for line in ex_facts.split('\n'):
                    if line.strip():
                        sampled_bk_lines.add(line.strip())
        
        sampled_bk = '\n'.join(sorted(sampled_bk_lines))
        
        # Use sampled examples and filtered BK
        pos_examples = '\n'.join(sampled_pos)
        neg_examples = '\n'.join(sampled_neg)
        bk_content = sampled_bk
        
        log_message(f"D&C: Filtered BK to {len(sampled_bk_lines)} facts for sampled examples")
        
        # ===== PHASE 1: DIVIDE =====
        st.markdown("---")
        st.subheader("📊 Phase 1: DIVIDE")
        
        groups = group_clauses_by_head(hypothesis)
        total_clauses = sum(len(c) for c in groups.values())
        
        st.write(f"**Found {len(groups)} predicate group(s) with {total_clauses} total clauses:**")
        
        # Show groups overview
        cols = st.columns(min(len(groups), 4))
        for idx, (pred_name, clauses) in enumerate(groups.items()):
            with cols[idx % len(cols)]:
                lits = sum(c.count(',') + 1 for c in clauses)
                st.metric(f"`{pred_name}`", f"{len(clauses)} clauses", f"{lits} literals")
        
        log_message(f"D&C DIVIDE: {len(groups)} groups: {list(groups.keys())}")
        
        # ===== PHASE 2: CONQUER =====
        st.markdown("---")
        st.subheader("⚔️ Phase 2: CONQUER")
        
        optimized_groups = {}
        all_group_analyses = []
        groups_to_optimize = [(k, v) for k, v in groups.items() if len(v) > 1]
        
        if not groups_to_optimize:
            st.info("ℹ️ All groups have single clauses - nothing to optimize")
            optimized_groups = groups
        else:
            st.write(f"**Optimizing {len(groups_to_optimize)} group(s) with multiple clauses...**")
            
            # Progress bar for overall optimization
            progress_bar = st.progress(0)
            status_text = st.empty()
            
            for group_idx, (pred_name, clauses) in enumerate(groups.items()):
                progress = (group_idx) / len(groups)
                progress_bar.progress(progress)
                
                if len(clauses) == 1:
                    status_text.write(f"⏭️ Skipping `{pred_name}` (single clause)")
                    optimized_groups[pred_name] = clauses
                    continue
                
                original_lits = sum(c.count(',') + 1 for c in clauses)
                status_text.write(f"🔧 **Optimizing `{pred_name}`** ({len(clauses)} clauses, {original_lits} literals)...")
                
                # Show original clauses
                with st.expander(f"📋 `{pred_name}` - Original ({len(clauses)} clauses, {original_lits} literals)", expanded=False):
                    for i, c in enumerate(clauses, 1):
                        st.code(f"% Clause {i}\n{c}", language="prolog")
                
                st.markdown(f"#### 🎯 Optimizing `{pred_name}`")
                
                # Build coverage stats for optimization
                group_hyp = '\n'.join(clauses)
                try:
                    group_result = tester.test_hypothesis(group_hyp)
                    cov_pos = len(group_result.covered_pos)
                    cov_neg = len(group_result.covered_neg)
                    miss_pos = len(group_result.missed_pos) if hasattr(group_result, 'missed_pos') else 0
                    total_pos = cov_pos + miss_pos
                    coverage_stats = f"""| Metric | Value |
|--------|-------|
| Covered Positives | {cov_pos}/{total_pos} |
| Covered Negatives | {cov_neg} (must be 0) |
| Missed Positives | {miss_pos} |"""
                except:
                    coverage_stats = "% Coverage stats unavailable"
                
                # Optimize this group (now includes tester for coverage testing)
                optimized, iteration_details = optimize_clause_group(
                    clauses, bk_content, optimization_template, 
                    model_name, api_key, tester,
                    pos_examples=pos_examples, neg_examples=neg_examples,
                    max_iters=2, group_name=pred_name,
                    coverage_stats=coverage_stats,
                    bias_content=bias_content
                )
                optimized_groups[pred_name] = optimized
                
                new_lits = sum(c.count(',') + 1 for c in optimized)
                
                # Show final result summary
                st.markdown("---")
                if new_lits < original_lits:
                    reduction = original_lits - new_lits
                    pct = round(100 * reduction / original_lits, 1)
                    st.success(f"✨ **`{pred_name}` FINAL**: {original_lits} → {new_lits} literals (-{reduction}, -{pct}%)")
                else:
                    st.info(f"ℹ️ **`{pred_name}` FINAL**: No improvement ({new_lits} literals)")
                
                # Show optimized clauses
                with st.expander(f"📋 `{pred_name}` - Final Optimized ({len(optimized)} clauses, {new_lits} literals)", expanded=True):
                    st.code('\n'.join(optimized), language="prolog")
                
                all_group_analyses.append({
                    "predicate": pred_name,
                    "original_clauses": len(clauses),
                    "optimized_clauses": len(optimized),
                    "original_literals": original_lits,
                    "optimized_literals": new_lits,
                    "improvement": original_lits - new_lits,
                    "iteration_details": iteration_details
                })
            
            progress_bar.progress(1.0)
            status_text.success("✅ All groups processed!")
        
        # ===== PHASE 3: MERGE =====
        st.markdown("---")
        st.subheader("🔗 Phase 3: MERGE")
        
        merged_clauses = []
        for pred_name in optimized_groups:
            merged_clauses.extend(optimized_groups[pred_name])
        
        merged_hypothesis = '\n'.join(merged_clauses)
        total_original_lits = sum(a["original_literals"] for a in all_group_analyses) if all_group_analyses else sum(c.count(',') + 1 for c in hypothesis.split('\n') if c.strip())
        total_new_lits = sum(c.count(',') + 1 for c in merged_clauses)
        
        st.write(f"**Merged {len(merged_clauses)} clauses** ({total_new_lits} literals)")
        
        with st.expander("📋 Merged Hypothesis", expanded=True):
            st.code(merged_hypothesis, language="prolog")
        
        # Verify merged result
        st.write("**🧪 Verifying merged hypothesis...**")
        verify_placeholder = st.empty()
        verify_placeholder.info("Testing coverage...")
        
        try:
            merged_result = tester.test_hypothesis(merged_hypothesis)
            
            if merged_result.is_complete:
                verify_placeholder.empty()
                st.success(f"✅ **MERGE SUCCESS!** Hypothesis passes all tests.")
                
                # Summary metrics
                if all_group_analyses:
                    total_improvement = sum(a["improvement"] for a in all_group_analyses)
                    if total_improvement > 0:
                        st.balloons()
                        st.metric("Total Improvement", f"-{total_improvement} literals", delta=f"-{round(100*total_improvement/total_original_lits, 1)}%")
                
                return merged_hypothesis, True, all_group_analyses
            else:
                verify_placeholder.empty()
                st.warning(f"⚠️ **MERGE FAILED** - Coverage: pos={len(merged_result.covered_pos)}, neg={len(merged_result.covered_neg)}")
                st.info("Keeping original hypothesis")
                return hypothesis, False, all_group_analyses
        except Exception as e:
            verify_placeholder.empty()
            st.error(f"❌ Merge test error: {e}")
            return hypothesis, False, all_group_analyses

    # System instruction for ILP solver (keeps user prompts clean for feedback)
    SYSTEM_INSTRUCTION = """You are a precise Inductive Logic Programming (ILP) solver.
Your goal is to generate a Prolog hypothesis that covers ALL Positive Examples and ZERO Negative Examples.
You must STRICTLY adhere to the predicates defined in the Language Bias.

RULES:
1. Use ONLY predicates from the bias.pl file
2. Every clause must end with a period (.)
3. Prefer simpler hypotheses with fewer literals
4. When feedback indicates failure, you MUST reason about WHY before generating new code
5. Output your hypothesis inside a ```prolog code block"""

    def create_context_cache(api_key: str, model: str, task_data: str, system_prompt: str):
        """Create a Gemini context cache with task data. Returns (cache, cached_model) tuple.
        Uses google.genai SDK (new API).
        """
        try:
            client = genai.Client(api_key=api_key)
            
            # Create the cache using client.caches.create
            cache = client.caches.create(
                model=model,
                config=types.CreateCachedContentConfig(
                    display_name='ilp_task_data',
                    system_instruction=system_prompt,
                    contents=[{"role": "user", "parts": [{"text": task_data}]}],
                    ttl="86400s",  # 24 hour TTL
                )
            )
            
            log_message(f"Context cache created: {cache.name}")
            return cache
        except Exception as e:
            log_message(f"Cache creation failed: {e} - falling back to standard API")
            return None
    
    def delete_context_cache(api_key: str, cache):
        """Delete a context cache."""
        try:
            if cache:
                client = genai.Client(api_key=api_key)
                client.caches.delete(name=cache.name)
                log_message(f"Context cache deleted: {cache.name}")
        except Exception as e:
            log_message(f"Cache deletion failed: {e}")

    def call_cascade_with_display(prompt: str, task_dir: str):
        """File-based interaction with Windsurf Cascade instead of API.
        
        Writes prompt to cascade_prompt.txt and waits for response in cascade_response.txt.
        Truncates prompt if too large for Cascade context window.
        """
        # Cascade has limited context - truncate if needed (~30K chars = ~7500 tokens)
        MAX_CASCADE_PROMPT_CHARS = 50000
        if len(prompt) > MAX_CASCADE_PROMPT_CHARS:
            log_message(f"CASCADE MODE: Prompt too large ({len(prompt)} chars), truncating to {MAX_CASCADE_PROMPT_CHARS}")
            # Keep header and truncate BK/examples section
            prompt = prompt[:MAX_CASCADE_PROMPT_CHARS] + "\n\n% ... (truncated for Cascade context limit)"
        
        prompt_file = os.path.join(task_dir, "cascade_prompt.txt")
        response_file = os.path.join(task_dir, "cascade_response.txt")
        
        # Clear any old response file
        if os.path.exists(response_file):
            os.remove(response_file)
        
        # Write prompt to file
        with open(prompt_file, 'w', encoding='utf-8') as f:
            f.write(prompt)
        
        log_message(f"CASCADE MODE: Prompt saved to {prompt_file}")
        
        # Display waiting message
        status_placeholder = st.empty()
        status_placeholder.warning(f"⏳ **Waiting for Cascade response...**\n\n📁 Prompt: `{prompt_file}`\n📥 Save response to: `{response_file}`")
        
        # Poll for response file with NON-EMPTY content (check every 2 seconds)
        poll_count = 0
        max_polls = 150  # 5 minutes max wait
        response = ""
        
        while poll_count < max_polls:
            time.sleep(2)
            poll_count += 1
            
            if poll_count % 5 == 0:
                status_placeholder.warning(f"⏳ **Waiting for Cascade response...** ({poll_count * 2}s)\n\n📁 Prompt: `{prompt_file}`\n📥 Save response to: `{response_file}`")
            
            # Check if file exists AND has content
            if os.path.exists(response_file):
                try:
                    with open(response_file, 'r', encoding='utf-8') as f:
                        response = f.read().strip()
                    
                    # Only accept non-empty responses with actual Prolog content
                    if response and (':-' in response or 'f(' in response or 'prolog' in response.lower()):
                        time.sleep(0.5)  # Small delay to ensure file is fully written
                        # Re-read to get final content
                        with open(response_file, 'r', encoding='utf-8') as f:
                            response = f.read()
                        break
                except Exception:
                    pass  # File might be being written, continue polling
        
        if not response:
            log_message("CASCADE MODE: Timeout or empty response")
        
        # Clean up response file for next iteration
        if os.path.exists(response_file):
            os.remove(response_file)
        
        status_placeholder.empty()
        log_message(f"CASCADE MODE: Response received ({len(response)} chars)")
        
        return response

    def call_gemini_with_display(prompt: str, model: str, api_key: str, conversation_history: list = None, cache_name: str = None, max_retries: int = 4):
        """Call Gemini API with streaming display and conversation history - clears when done.
        
        Includes exponential backoff retry logic for transient errors (503, 429, etc.)
        """
        client = genai.Client(api_key=api_key)
        thinking_text = ""
        response_text = ""
        
        # Placeholder for streaming content - will be cleared when done
        stream_placeholder = st.empty()
        
        # Build contents with conversation history for automatic context (like Windsurf)
        if conversation_history:
            contents = conversation_history + [{"role": "user", "parts": [{"text": prompt}]}]
        else:
            contents = prompt
        
        # Build config - use cached_content if available
        # Only use thinking_config for models that support it
        supports_thinking = "thinking" in model.lower()
        
        if cache_name:
            if supports_thinking:
                config = types.GenerateContentConfig(
                    temperature=0.0,
                    thinking_config=types.ThinkingConfig(thinking_level="high"),
                    cached_content=cache_name
                )
            else:
                config = types.GenerateContentConfig(
                    temperature=0.0,
                    cached_content=cache_name
                )
        else:
            if supports_thinking:
                config = types.GenerateContentConfig(
                    temperature=0.0,
                    thinking_config=types.ThinkingConfig(thinking_level="high"),
                    system_instruction=SYSTEM_INSTRUCTION
                )
            else:
                config = types.GenerateContentConfig(
                    temperature=0.0,
                    system_instruction=SYSTEM_INSTRUCTION
                )
        
        # Retry loop with exponential backoff
        last_error = None
        for attempt in range(max_retries):
            try:
                thinking_text = ""
                response_text = ""
                
                stream = client.models.generate_content_stream(
                    model=model,
                    contents=contents,
                    config=config
                )
                
                for chunk in stream:
                    if hasattr(chunk, 'candidates') and chunk.candidates:
                        for candidate in chunk.candidates:
                            if hasattr(candidate, 'content') and candidate.content:
                                for part in candidate.content.parts:
                                    if hasattr(part, 'thought') and part.thought:
                                        if hasattr(part, 'text') and part.text:
                                            thinking_text += part.text
                                            visible = thinking_text[-600:] if len(thinking_text) > 600 else thinking_text
                                            stream_placeholder.markdown(f"🧠 *Thinking...*\n\n> {visible}▌")
                                    elif hasattr(part, 'text') and part.text:
                                        response_text += part.text
                                        visible = response_text[-600:] if len(response_text) > 600 else response_text
                                        stream_placeholder.markdown(f"📝 *Analyzing...*\n\n{visible}▌")
                    elif hasattr(chunk, 'text') and chunk.text:
                        response_text += chunk.text
                        visible = response_text[-600:] if len(response_text) > 600 else response_text
                        stream_placeholder.markdown(f"📝 *Analyzing...*\n\n{visible}▌")
                
                # CLEAR the streaming display when done
                stream_placeholder.empty()
                return response_text
                
            except Exception as e:
                last_error = e
                error_str = str(e).lower()
                
                # Check if this is a retryable error (503, 429, overloaded, unavailable, deadline)
                is_retryable = any(x in error_str for x in ['503', '429', 'overload', 'unavailable', 'deadline', 'resource_exhausted'])
                
                if is_retryable and attempt < max_retries - 1:
                    wait_time = (2 ** attempt) + 1  # 2s, 3s, 5s, 9s
                    stream_placeholder.warning(f"⏳ API overloaded. Retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                    time.sleep(wait_time)
                    continue
                else:
                    stream_placeholder.empty()
                    break
        
        # All retries failed
        st.error(f"API Error after {max_retries} attempts: {last_error}")
        return response_text

    def call_claude_with_display(prompt: str, model: str, api_key: str, conversation_history: list = None, system_prompt: str = None, max_retries: int = 4):
        """Call Claude API with streaming display and conversation history.
        
        Uses prompt caching (cache_control ephemeral) on the system prompt
        to reduce cost and latency across iterations.
        Includes exponential backoff retry logic for transient errors.
        """
        client = anthropic.Anthropic(api_key=api_key)
        response_text = ""
        
        # Placeholder for streaming content - will be cleared when done
        stream_placeholder = st.empty()
        
        # Build system message with caching
        sys_prompt = system_prompt or SYSTEM_INSTRUCTION
        system_messages = [
            {
                "type": "text",
                "text": sys_prompt,
                "cache_control": {"type": "ephemeral"}
            }
        ]
        
        # Build messages with conversation history
        messages = []
        if conversation_history:
            for msg in conversation_history:
                role = msg.get("role", "user")
                # Convert Gemini format to Claude format
                if role == "model":
                    role = "assistant"
                text = ""
                if "parts" in msg:
                    text = "".join(p.get("text", "") for p in msg["parts"])
                elif "content" in msg:
                    text = msg["content"]
                if text:
                    messages.append({"role": role, "content": text})
        
        messages.append({"role": "user", "content": prompt})
        
        # Retry loop with exponential backoff
        last_error = None
        for attempt in range(max_retries):
            try:
                response_text = ""
                thinking_text = ""
                
                # Check if model supports extended thinking
                supports_thinking = "opus" in model.lower() or "sonnet-4" in model.lower() or "3-7" in model.lower()
                
                # Build API call kwargs - highest thinking level (like Gemini thinking_level="high")
                # max_tokens cap is 128000 for Claude; reserve 16384 for output, rest for thinking
                thinking_budget = 128000 - 16384
                api_kwargs = {
                    "model": model,
                    "max_tokens": 16384,
                    "system": system_messages,
                    "messages": messages,
                }
                
                if supports_thinking:
                    api_kwargs["temperature"] = 1  # Claude requires temp=1 for extended thinking
                    api_kwargs["thinking"] = {
                        "type": "enabled",
                        "budget_tokens": thinking_budget
                    }
                    # max_tokens must be greater than budget_tokens
                    api_kwargs["max_tokens"] = thinking_budget + 16384
                else:
                    api_kwargs["temperature"] = 0.0
                
                with client.messages.stream(**api_kwargs) as stream:
                    for event in stream:
                        if hasattr(event, 'type'):
                            if event.type == 'content_block_delta':
                                delta = event.delta
                                if hasattr(delta, 'type'):
                                    if delta.type == 'thinking_delta':
                                        thinking_text += delta.thinking
                                        visible = thinking_text[-600:] if len(thinking_text) > 600 else thinking_text
                                        stream_placeholder.markdown(f"🧠 *Thinking...*\n\n> {visible}▌")
                                    elif delta.type == 'text_delta':
                                        response_text += delta.text
                                        visible = response_text[-600:] if len(response_text) > 600 else response_text
                                        stream_placeholder.markdown(f"📝 *Analyzing...*\n\n{visible}▌")
                
                # CLEAR the streaming display when done
                stream_placeholder.empty()
                return response_text
                
            except Exception as e:
                last_error = e
                error_str = str(e).lower()
                
                # Check if this is a retryable error (529, 429, overloaded, unavailable)
                is_retryable = any(x in error_str for x in ['529', '429', 'overload', 'unavailable', 'rate_limit'])
                
                if is_retryable and attempt < max_retries - 1:
                    wait_time = (2 ** attempt) + 1  # 2s, 3s, 5s, 9s
                    stream_placeholder.warning(f"⏳ API overloaded. Retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                    time.sleep(wait_time)
                    continue
                else:
                    stream_placeholder.empty()
                    break
        
        # All retries failed
        st.error(f"API Error after {max_retries} attempts: {last_error}")
        return response_text

    def call_gpt_with_display(prompt: str, model: str, api_key: str, conversation_history: list = None, max_retries: int = 4):
        """Call OpenAI GPT API with streaming display and conversation history.
        
        Uses reasoning effort=high, temperature=0.
        Falls back to gpt-5.4-pro-long-context on rate limit errors.
        Includes exponential backoff retry logic for transient errors.
        """
        client = OpenAI(api_key=api_key)
        response_text = ""
        
        # Placeholder for streaming content - will be cleared when done
        stream_placeholder = st.empty()
        
        # Build messages with conversation history
        messages = [{"role": "system", "content": SYSTEM_INSTRUCTION}]
        if conversation_history:
            for msg in conversation_history:
                role = msg.get("role", "user")
                # Convert Gemini format to OpenAI format
                if role == "model":
                    role = "assistant"
                text = ""
                if "parts" in msg:
                    text = "".join(p.get("text", "") for p in msg["parts"])
                elif "content" in msg:
                    text = msg["content"]
                if text:
                    messages.append({"role": role, "content": text})
        
        messages.append({"role": "user", "content": prompt})
        
        # Track current model for rate limit fallback
        current_model = model
        last_error = None
        for attempt in range(max_retries):
            try:
                response_text = ""
                
                stream = client.chat.completions.create(
                    model=current_model,
                    temperature=0.0,
                    top_p=1.0,
                    max_completion_tokens=48384,
                    reasoning_effort="high",
                    messages=messages,
                    store=True,
                    stream=True
                )
                
                for chunk in stream:
                    if chunk.choices and chunk.choices[0].delta.content:
                        response_text += chunk.choices[0].delta.content
                        visible = response_text[-600:] if len(response_text) > 600 else response_text
                        stream_placeholder.markdown(f"📝 *Analyzing...*\n\n{visible}▌")
                
                # CLEAR the streaming display when done
                stream_placeholder.empty()
                return response_text
                
            except Exception as e:
                last_error = e
                error_str = str(e).lower()
                
                # On rate limit, fall back to long-context model
                is_rate_limit = any(x in error_str for x in ['429', 'rate_limit', 'rate limit'])
                if is_rate_limit and current_model == "gpt-5.4":
                    current_model = "gpt-5.4-mini"
                    log_message(f"Rate limit hit - falling back to {current_model}")
                    stream_placeholder.warning(f"⏳ Rate limit hit. Switching to {current_model}...")
                    time.sleep(2)
                    continue
                
                # Check if this is a retryable error
                is_retryable = any(x in error_str for x in ['429', '503', '529', 'overload', 'unavailable', 'rate_limit'])
                
                if is_retryable and attempt < max_retries - 1:
                    wait_time = (2 ** attempt) + 1  # 2s, 3s, 5s, 9s
                    stream_placeholder.warning(f"⏳ API error. Retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                    time.sleep(wait_time)
                    continue
                else:
                    stream_placeholder.empty()
                    break
        
        # All retries failed
        st.error(f"API Error after {max_retries} attempts: {last_error}")
        return response_text

    def call_gpt_pro_with_display(prompt: str, model: str, api_key: str, conversation_history: list = None, max_retries: int = 4):
        """Call OpenAI GPT Pro API using the Responses API with streaming.
        
        gpt-5.4-pro is only available via the Responses API (not Chat Completions).
        Uses reasoning effort=high. Pro requests may take several minutes.
        Includes exponential backoff retry logic for transient errors.
        """
        client = OpenAI(api_key=api_key)
        response_text = ""
        
        # Placeholder for streaming content - will be cleared when done
        stream_placeholder = st.empty()
        stream_placeholder.info("🧠 GPT Pro is thinking... (this may take several minutes)")
        
        # Build input messages with conversation history
        input_messages = [{"role": "system", "content": SYSTEM_INSTRUCTION}]
        if conversation_history:
            for msg in conversation_history:
                role = msg.get("role", "user")
                # Convert Gemini format to OpenAI format
                if role == "model":
                    role = "assistant"
                text = ""
                if "parts" in msg:
                    text = "".join(p.get("text", "") for p in msg["parts"])
                elif "content" in msg:
                    text = msg["content"]
                if text:
                    input_messages.append({"role": role, "content": text})
        
        input_messages.append({"role": "user", "content": prompt})
        
        last_error = None
        for attempt in range(max_retries):
            try:
                response_text = ""
                
                stream = client.responses.create(
                    model=model,
                    reasoning={"effort": "high"},
                    max_output_tokens=48384,
                    input=input_messages,
                    store=True,
                    stream=True
                )
                
                for event in stream:
                    # Handle streaming events from Responses API
                    if hasattr(event, 'type'):
                        if event.type == 'response.output_text.delta':
                            response_text += event.delta
                            visible = response_text[-600:] if len(response_text) > 600 else response_text
                            stream_placeholder.markdown(f"📝 *Analyzing...*\n\n{visible}▌")
                
                # CLEAR the streaming display when done
                stream_placeholder.empty()
                return response_text
                
            except Exception as e:
                last_error = e
                error_str = str(e).lower()
                
                # Check if this is a retryable error
                is_retryable = any(x in error_str for x in ['429', '503', '529', 'overload', 'unavailable', 'rate_limit', 'rate limit', 'timeout'])
                
                if is_retryable and attempt < max_retries - 1:
                    wait_time = (2 ** attempt) + 1  # 2s, 3s, 5s, 9s
                    stream_placeholder.warning(f"⏳ API error. Retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                    time.sleep(wait_time)
                    continue
                else:
                    stream_placeholder.empty()
                    break
        
        # All retries failed
        st.error(f"API Error after {max_retries} attempts: {last_error}")
        return response_text

    def call_llm_with_display(prompt: str, model: str, api_key: str, conversation_history: list = None, cache_name: str = None, max_retries: int = 4):
        """Route LLM call to the correct provider based on selected model."""
        if llm_provider == "Claude":
            return call_claude_with_display(prompt, model, api_key, conversation_history=conversation_history, max_retries=max_retries)
        elif llm_provider == "GPT":
            # Route pro models to Responses API, others to Chat Completions
            if "pro" in model.lower():
                return call_gpt_pro_with_display(prompt, model, api_key, conversation_history=conversation_history, max_retries=max_retries)
            return call_gpt_with_display(prompt, model, api_key, conversation_history=conversation_history, max_retries=max_retries)
        else:
            return call_gemini_with_display(prompt, model, api_key, conversation_history=conversation_history, cache_name=cache_name, max_retries=max_retries)

    # --- MANUAL OPTIMIZATION LOGIC ---
    if st.session_state.run_optimization and st.session_state.best_hyp:
        st.session_state.run_optimization = False  # Reset flag
        log_message("Starting manual optimization...")
        
        current_solution = st.session_state.best_hyp
        
        # Initialize loop for testing
        try:
            loop = CascadePopperLoop(task_dir, model=model_name)
        except Exception as e:
            st.error(f"Error initializing: {e}")
            st.stop()
        
        # Load task files
        bk_path = os.path.join(task_dir, "bk.pl")
        exs_path = os.path.join(task_dir, "exs.pl")
        with open(bk_path, 'r', encoding='utf-8') as f:
            bk_content = f.read()
        with open(exs_path, 'r', encoding='utf-8') as f:
            exs_content = f.read()
        
        def count_literals(hyp):
            total = 0
            for clause in hyp.split('\n'):
                if ':-' in clause:
                    body = clause.split(':-')[1]
                    total += body.count(',') + 1
                else:
                    total += 1
            return total
        
        best_solution = current_solution
        best_literals = count_literals(current_solution)
        
        # Test current solution
        current_result = loop.tester.test_hypothesis(current_solution)
        best_f1 = 1.0 if current_result.is_complete else 0.0
        
        st.info(f"🔍 Starting optimization (current: {best_literals} literals)...")
        
        # Load the optimization prompt template
        optimization_template = ""
        opt_prompt_path = os.path.join(os.path.dirname(__file__), "optimization_prompt")
        try:
            with open(opt_prompt_path, 'r', encoding='utf-8') as f:
                optimization_template = f.read().strip()
            log_message(f"Loaded optimization template from {opt_prompt_path}")
        except Exception as e:
            st.warning(f"Could not load optimization_prompt: {e}")

        if optimization_template:
            # Use DIVIDE AND CONQUER optimization
            log_message("Using D&C optimization for manual optimization")
            st.subheader("🔀 Divide & Conquer Optimization")
            
            original_solution = best_solution
            original_literals = best_literals
            
            # Parse examples from exs_content
            pos_ex_list = []
            neg_ex_list = []
            for line in exs_content.split('\n'):
                line = line.strip()
                if line.startswith('pos(') and line.endswith(').'):
                    pos_ex_list.append(line)
                elif line.startswith('neg(') and line.endswith(').'):
                    neg_ex_list.append(line)
            pos_examples_str = '\n'.join(pos_ex_list)
            neg_examples_str = '\n'.join(neg_ex_list)
            
            # Run D&C optimization with examples
            opt_start_time = time.time()
            optimized_hyp, success, group_analyses = divide_and_conquer_optimize(
                best_solution, bk_content, optimization_template,
                model_name, api_key, loop.tester,
                pos_examples=pos_examples_str, neg_examples=neg_examples_str,
                bias_content=bias_content
            )
            opt_time = round(time.time() - opt_start_time, 3)
            
            if success:
                new_literals = count_literals(optimized_hyp)
                if new_literals < best_literals:
                    st.success(f"✨ D&C Optimization improved: {best_literals} → {new_literals} literals")
                    best_solution = optimized_hyp
                    best_literals = new_literals
                    
                    # Save result
                    st.session_state.best_hyp = best_solution
                    st.session_state.metrics["solution"] = best_solution
                    st.session_state.metrics["num_literals"] = best_literals
                    loop.save_hypothesis(best_solution)
                    
                    log_message(f"D&C Optimization: Improved to {new_literals} literals")
                else:
                    st.info(f"ℹ️ D&C produced valid result but no size improvement ({new_literals} literals)")
            else:
                st.warning("⚠️ D&C optimization failed verification - keeping original")
            
            # Store final optimization progress in session state
            st.session_state.optimization_progress = {
                "status": "success" if best_literals < original_literals else "no_improvement",
                "mode": "divide_and_conquer",
                "original_literals": original_literals,
                "new_literals": best_literals,
                "original_hypothesis": original_solution,
                "optimized_hypothesis": best_solution,
                "group_analyses": group_analyses,
                "optimization_time": opt_time,
                "timestamp": datetime.now().isoformat()
            }
            
            # DEBUG LOG: Manual Optimization Complete
            st.session_state.debug_log.append({
                "type": "manual_optimization_complete",
                "mode": "divide_and_conquer",
                "timestamp": datetime.now().isoformat(),
                "original_literals": original_literals,
                "final_literals": best_literals,
                "improvement": original_literals - best_literals,
                "groups_optimized": len(group_analyses)
            })

        else:
            st.error("Optimization prompt template not found.")
        
        # Save optimization results to metrics.json
        metrics_file = os.path.join(task_dir, "metrics.json")
        optimization_metrics = {
            "optimized": True,
            "original_solution": current_solution,
            "original_literals": count_literals(current_solution),
            "optimized_solution": best_solution,
            "optimized_literals": best_literals,
            "optimization_iterations": 3,
            "model": model_name,
            "timestamp": datetime.now().isoformat()
        }
        
        # Load existing metrics if available and merge
        existing_metrics = {}
        if os.path.exists(metrics_file):
            try:
                with open(metrics_file, 'r', encoding='utf-8') as f:
                    existing_metrics = json.load(f)
            except:
                pass
        
        existing_metrics["optimization"] = optimization_metrics
        existing_metrics["solution"] = best_solution
        existing_metrics["num_literals"] = best_literals
        
        with open(metrics_file, 'w', encoding='utf-8') as f:
            json.dump(existing_metrics, f, indent=2)
        
        log_message(f"Optimization results saved to metrics.json")
        
        # Also save best solution to hypothesis.pl
        hypothesis_file = os.path.join(task_dir, "hypothesis.pl")
        with open(hypothesis_file, 'w', encoding='utf-8') as f:
            f.write(f"% Optimized by Cascade\n")
            f.write(f"% Original literals: {count_literals(current_solution)}\n")
            f.write(f"% Optimized literals: {best_literals}\n")
            f.write(f"% Model: {model_name}\n")
            f.write(best_solution)
        
        st.success(f"✅ Optimization complete! Best solution: {best_literals} literals")
        st.code(best_solution, language="prolog")
        
        # Show a button to refresh instead of auto-rerun so user can see results
        st.info("💡 Optimization results are saved. Check the right panel for the full analysis.")
        if st.button("🔄 Refresh Page", key="refresh_after_opt"):
            st.rerun()

    # --- THE RUNNING LOGIC ---
    if start_btn and not st.session_state.solved:
        log_message(f"Starting new run for task: {task_dir} with model: {model_name}")
        
        # Clear status at start and mark as running
        realtime_status.empty()
        st.session_state.is_running = True
        st.session_state.best_hyp = None
        st.session_state.all_solutions = []
        st.session_state.conversation_history = []  # Clear conversation for new run
        
        if not use_cascade_mode:
            if not api_key:
                log_message("Error: Missing API Key")
                st.error(f"Please enter a {llm_provider} API Key in the sidebar.")
                st.stop()
                
            if llm_provider == "Gemini" and not GENAI_AVAILABLE:
                log_message("Error: google-genai package not installed")
                st.error("google-genai package not installed. Run: pip install google-genai")
                st.stop()
            elif llm_provider == "Claude" and not ANTHROPIC_AVAILABLE:
                log_message("Error: anthropic package not installed")
                st.error("anthropic package not installed. Run: pip install anthropic")
                st.stop()
        else:
            log_message("CASCADE MODE: Skipping API key check")

        # Reset partial cover state for new run
        st.session_state.partial_cover_state = {
            "restart_with_filtered_data": False,
            "partial_cover_round": 0,
            "preserved_good_clauses": [],
            "preserved_good_clauses_strs": [],
            "covered_positives_global": set(),
            "remaining_positives": set(),
            "working_bk_content_for_prompt": "",
            "working_exs_content_for_prompt": ""
        }

        # Initialize Logic Components
        try:
            with st.spinner("Initializing..."):
                loop = CascadePopperLoop(task_dir, model=model_name)
        except Exception as e:
            log_message(f"Error initializing loop: {e}")
            st.error(f"Error initializing: {e}")
            st.stop()

        # Track failures for prompt building
        failed_hypotheses = []
        learned_constraints = []
        last_feedback = ""  # Detailed feedback from last test
        
        # Track good clauses across iterations (clauses with pos > 0 and neg = 0)
        # Each entry: {'clause': str, 'covered_count': int, 'covered_examples': set}
        # Use session state to persist across Streamlit reruns
        pcs = st.session_state.partial_cover_state
        preserved_good_clauses = pcs["preserved_good_clauses"]
        preserved_good_clauses_strs = pcs["preserved_good_clauses_strs"]
        
        # DIVIDE-AND-CONQUER: Track remaining uncovered examples
        # When a good clause is found, remove its covered examples and continue
        covered_positives_global = pcs["covered_positives_global"]
        all_positives = set()  # Will be populated from exs.pl
        all_negatives = set()  # Will be populated from exs.pl
        
        # Track best partial solution using MDL cost (Popper approach)
        # MDL cost = size(H) + fp(H) + fn(H)
        best_partial_hyp = None
        best_partial_cost = float('inf')
        best_partial_stats = {"tp": 0, "fp": 0, "fn": 0, "size": 0, "f1": 0}
        
        # Initialize metrics tracking
        run_start_time = time.time()
        st.session_state.metrics = {
            "task_dir": task_dir,
            "model": model_name,
            "strategy": None,  # Set later after strategy selection
            "start_time": datetime.now().isoformat(),
            "end_time": None,
            "total_time_seconds": 0,
            "pos_count": 0,  # Set later after loading
            "neg_count": 0,  # Set later after loading
            "bk_size_bytes": 0,  # Set later after loading
            "total_iterations": 0,
            "total_prolog_tests": 0,
            "total_subsumption_checks": 0,
            "solved": False,
            "solution": None,
            "iterations": []
        }
        
        # Read the ILP system prompt file (for feedback iterations)
        ilp_system_prompt = ""
        prompt_file_path = os.path.join(os.path.dirname(__file__), "prompt")
        try:
            with open(prompt_file_path, 'r', encoding='utf-8') as f:
                ilp_system_prompt = f.read().strip()
            log_message(f"Loaded ILP system prompt from {prompt_file_path}")
        except Exception as e:
            log_message(f"Warning: Could not load ILP system prompt: {e}")
        
        # Read the initial prompt file (for first iteration - one-shot)
        init_prompt_template = ""
        init_prompt_path = os.path.join(os.path.dirname(__file__), "init_prompt")
        try:
            with open(init_prompt_path, 'r', encoding='utf-8') as f:
                init_prompt_template = f.read().strip()
            log_message(f"Loaded init_prompt template from {init_prompt_path}")
        except Exception as e:
            log_message(f"Warning: Could not load init_prompt: {e}")
            
        # Read the optimization prompt template
        optimization_template = ""
        opt_prompt_path = os.path.join(os.path.dirname(__file__), "optimization_prompt")
        try:
            with open(opt_prompt_path, 'r', encoding='utf-8') as f:
                optimization_template = f.read().strip()
            log_message(f"Loaded optimization template from {opt_prompt_path}")
        except Exception as e:
            log_message(f"Warning: Could not load optimization_prompt: {e}")
        
        # Read the feedback prompt templates (for failure iterations)
        feedback_templates = {"too_specific": "", "too_general": "", "syntax_error": "", "cycle_detected": ""}
        feedback_prompt_path = os.path.join(os.path.dirname(__file__), "feed_back_prompt")
        try:
            with open(feedback_prompt_path, 'r', encoding='utf-8') as f:
                content = f.read()
            # Parse templates by markers
            if "### TOO_SPECIFIC ###" in content:
                parts = content.split("### TOO_SPECIFIC ###")[1]
                if "### TOO_GENERAL ###" in parts:
                    feedback_templates["too_specific"] = parts.split("### TOO_GENERAL ###")[0].strip()
                    parts = parts.split("### TOO_GENERAL ###")[1]
                if "### SYNTAX_ERROR ###" in parts:
                    feedback_templates["too_general"] = parts.split("### SYNTAX_ERROR ###")[0].strip()
                    parts = parts.split("### SYNTAX_ERROR ###")[1]
                if "### CYCLE_DETECTED ###" in parts:
                    feedback_templates["syntax_error"] = parts.split("### CYCLE_DETECTED ###")[0].strip()
                    feedback_templates["cycle_detected"] = parts.split("### CYCLE_DETECTED ###")[1].strip()
                else:
                    feedback_templates["syntax_error"] = parts.strip()
            log_message(f"Loaded feedback templates from {feedback_prompt_path}")
        except Exception as e:
            log_message(f"Warning: Could not load feed_back_prompt: {e}")
        
        # Read the 3 task files
        bk_content = exs_content = bias_content = ""
        try:
            with open(os.path.join(task_dir, "bk.pl"), 'r', encoding='utf-8') as f:
                bk_content = f.read()
            with open(os.path.join(task_dir, "exs.pl"), 'r', encoding='utf-8') as f:
                exs_content = f.read()
            with open(os.path.join(task_dir, "bias.pl"), 'r', encoding='utf-8') as f:
                bias_content = f.read()
        except Exception as e:
            st.error(f"Error reading task files: {e}")
            st.stop()
        
        # DIVIDE-AND-CONQUER: Parse examples from exs.pl
        import re
        # IMPROVED REGEX: Handle nested parentheses by capturing everything between pos( and ).
        pos_pattern = re.compile(r'pos\s*\(\s*(.+?)\s*\)\.')
        neg_pattern = re.compile(r'neg\s*\(\s*(.+?)\s*\)\.')
        # Normalize: remove all whitespace for consistent set operations with tester results
        all_positives = {re.sub(r'\s+', '', ex) for ex in pos_pattern.findall(exs_content)}
        all_negatives = {re.sub(r'\s+', '', ex) for ex in neg_pattern.findall(exs_content)}
        remaining_positives = all_positives.copy()
        remaining_negatives = all_negatives.copy()
        log_message(f"Parsed {len(all_positives)} positives, {len(all_negatives)} negatives from exs.pl")
        
        # Update metrics with actual counts
        st.session_state.metrics["pos_count"] = len(all_positives)
        st.session_state.metrics["neg_count"] = len(all_negatives)
        st.session_state.metrics["bk_size_bytes"] = len(bk_content) if bk_content else 0
        
        # LARGE DATASET SUPPORT: Initialize strategy selector for auto-optimization
        strategy_selector = PromptStrategySelector(task_dir)
        
        # Load examples for strategy selection
        # IMPORTANT: Ensure we have examples to pass to the strategy, otherwise stats won't be generated
        loaded_pos_examples = []
        loaded_neg_examples = []
        if os.path.exists(os.path.join(task_dir, "exs.pl")):
            with open(os.path.join(task_dir, "exs.pl"), 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if line.startswith('pos('):
                        loaded_pos_examples.append(line)
                    elif line.startswith('neg('):
                        loaded_neg_examples.append(line)
        
        # Apply strategy with loaded examples
        strategy_result = strategy_selector.apply_strategy(loaded_pos_examples, loaded_neg_examples)
        
        # Log selected strategy
        log_message(f"Selected Prompting Strategy: {strategy_result.strategy_name}")
        st.info(f"🧠 Strategy: **{strategy_result.strategy_name}**")
        
        # Display selected strategy to user
        strategy_names = {
            StrategyType.FULL_CONTEXT: ("Full Context", "Complete BK and examples (< 87KB)"),
            StrategyType.BATCH_SCALABLE: ("Batch Scalable (BBSILP)", "10+10 batches, parallel learning (> 87KB)"),
        }
        selected_strategy = strategy_selector._selected_strategy
        strategy_name, strategy_desc = strategy_names.get(selected_strategy, ("Unknown", ""))
        
        # Update metrics with selected strategy
        st.session_state.metrics["strategy"] = strategy_name
        
        log_message(f"STRATEGY SELECTED: {strategy_name} - {strategy_desc}")
        log_message(f"Task profile: {strategy_selector.adapter.profile}")
        
        # Show strategy info to user
        if selected_strategy != StrategyType.FULL_CONTEXT:
            st.info(f"🎯 **Strategy: {strategy_name}** - {strategy_desc}\n\n"
                   f"BK: {strategy_selector.adapter.profile.bk_size_bytes//1024}KB, "
                   f"Examples: {strategy_selector.adapter.profile.total_examples}")
        
        # Apply strategy to get optimized content
        # CRITICAL FIX: Reconstruct full strings from atoms because strategy needs 'pos(...)' prefix
        # for discriminative statistics to work (identifying pos vs neg)
        full_pos_list = [f"pos({x})." for x in all_positives]
        full_neg_list = [f"neg({x})." for x in all_negatives]
        
        strategy_result = strategy_selector.apply_strategy(
            positive_examples=full_pos_list,
            negative_examples=full_neg_list
        )
        bk_content_for_prompt = strategy_result.bk_content
        exs_content_for_prompt = strategy_result.examples_content
        
        # Log compression stats
        if strategy_result.metadata.get("compression") != "none":
            original_size = strategy_selector.adapter.profile.bk_size_bytes + len(exs_content)
            new_size = strategy_result.total_chars
            compression = (1 - new_size / original_size) * 100 if original_size > 0 else 0
            log_message(f"Compression: {compression:.1f}% ({original_size//1024}KB -> {new_size//1024}KB)")
        
        # ═══════════════════════════════════════════════════════════════════════
        # BBSILP: Batch-Based Scalable ILP for Large Tasks
        # ═══════════════════════════════════════════════════════════════════════
        # Check if task is large (> zendo2 size ~87KB) OR has existing batch folders
        use_bbsilp = False
        bbsilp_processor = BatchILPProcessor(BBSILPConfig(batch_size_pos=10, batch_size_neg=10))
        
        # Calculate task size
        task_size = len(bk_content) + len(exs_content) + len(bias_content)
        
        # Check for existing batch folders FIRST (user intent to use BBSILP)
        existing_batches = bbsilp_processor.find_existing_batches(task_dir)
        
        if existing_batches or bbsilp_processor.is_large_task(task_size):
            use_bbsilp = True
            if existing_batches:
                log_message(f"BBSILP: Found {len(existing_batches)} existing batch folders")
            else:
                log_message(f"BBSILP: Large task detected ({task_size//1024}KB > 87KB threshold)")
            
            if existing_batches:
                st.warning(f"🔄 **BBSILP Mode**: Found {len(existing_batches)} batch folders for parallel learning.")
            else:
                log_message(f"BBSILP: No existing batches, will create automatically")
                st.warning(f"🔄 **BBSILP Mode**: Task size ({task_size//1024}KB) exceeds threshold. "
                          f"Will create 10+10 batch folders automatically.")
        
        # Store BBSILP state in session
        st.session_state.use_bbsilp = use_bbsilp
        st.session_state.bbsilp_processor = bbsilp_processor if use_bbsilp else None
        
        # PARTIAL COVER APPROACH: Working task data (will be filtered when partial covers found)
        working_bk_content = bk_content  # Full BK for Prolog testing (never summarized)
        working_exs_content = exs_content  # Full examples for Prolog testing
        
        # Use session state for partial cover variables to persist across Streamlit reruns
        partial_cover_round = pcs["partial_cover_round"]
        restart_with_filtered_data = pcs["restart_with_filtered_data"]
        remaining_positives = pcs["remaining_positives"]
        
        # Working prompt content - use session state if available (for continuation), else use fresh
        if pcs["working_bk_content_for_prompt"]:
            working_bk_content_for_prompt = pcs["working_bk_content_for_prompt"]
        else:
            working_bk_content_for_prompt = bk_content_for_prompt
        if pcs["working_exs_content_for_prompt"]:
            working_exs_content_for_prompt = pcs["working_exs_content_for_prompt"]
        else:
            working_exs_content_for_prompt = exs_content_for_prompt
        
        # Create context cache for task data (reduces tokens sent each iteration)
        # Use summarized BK and sampled examples for large datasets to stay within context limits
        task_cache_data = f"""## TASK DATA (CACHED)

### exs.pl (Examples)
```prolog
{exs_content_for_prompt}
```

### bk.pl (Background Knowledge)
```prolog
{bk_content_for_prompt}
```
"""
        cache_system_prompt = f"""{ilp_system_prompt}

{SYSTEM_INSTRUCTION}""" if ilp_system_prompt else SYSTEM_INSTRUCTION
        
        # Disabled explicit caching for Full Context - using implicit caching instead
        context_cache = None
        st.info("Using standard API (implicit caching only)")

        # Initialize result for first iteration (used in feedback prompts)
        result = None
        
        # ═══════════════════════════════════════════════════════════════════════
        # BBSILP EXECUTION: Run batch-based learning if enabled
        # ═══════════════════════════════════════════════════════════════════════
        if use_bbsilp and st.session_state.get('bbsilp_processor'):
            st.markdown("## 🔄 BBSILP: Batch-Based Scalable ILP")
            log_message("BBSILP: Starting batch-based learning...")
            
            # ═══ CONSOLIDATED METRICS FOR ALL BATCHES ═══
            bbsilp_start_time = time.time()
            bbsilp_all_metrics = {
                "task_dir": task_dir,
                "task_name": os.path.basename(task_dir),
                "model": model_name,
                "started_at": datetime.now().isoformat(),
                "total_positives": len(all_positives),
                "total_negatives": len(all_negatives),
                "bk_size_bytes": len(bk_content),
                "batches": [],
                "summary": {
                    "total_batches": 0,
                    "solved_batches": 0,
                    "failed_batches": 0,
                    "total_iterations": 0,
                    "early_termination": False,
                    "final_status": "in_progress"
                }
            }
            
            existing_batches = bbsilp_processor.find_existing_batches(task_dir)
            
            # If no existing batches, create them automatically
            if not existing_batches:
                st.info("📦 Creating batch folders automatically...")
                log_message("BBSILP: Creating batch folders automatically...")
                
                existing_batches = bbsilp_processor.create_batch_folders(
                    task_dir=task_dir,
                    pos_examples=list(all_positives),
                    neg_examples=list(all_negatives),
                    bk_content=bk_content,
                    bias_content=bias_content,
                    log_fn=log_message
                )
                st.success(f"✅ Created {len(existing_batches)} batch folders with metrics.json")
            
            # Show batch info
            with st.expander(f"📦 Batch Information ({len(existing_batches)} batches)", expanded=True):
                # ═══ SIZE COMPARISON: Full Context vs Batch Context ═══
                full_exs_size = sum(len(ex) for ex in all_positives) + sum(len(ex) for ex in all_negatives)
                full_context_size = len(bk_content) + full_exs_size + len(bias_content)
                
                st.markdown("### 📊 Context Size Comparison")
                st.markdown(f"**FULL CONTEXT (without batching):**")
                st.markdown(f"- BK: `{len(bk_content):,}` chars ({len(bk_content)//1024} KB)")
                st.markdown(f"- Examples: `{full_exs_size:,}` chars ({len(all_positives)} pos + {len(all_negatives)} neg)")
                st.markdown(f"- Bias: `{len(bias_content):,}` chars")
                st.markdown(f"- **TOTAL: `{full_context_size:,}` chars ({full_context_size//1024} KB)**")
                
                st.markdown("---")
                st.markdown(f"**BATCH CONTEXT (per batch):**")
                
                total_batch_sizes = 0
                for batch in existing_batches[:5]:  # Show first 5
                    batch_exs_size = sum(len(ex) for ex in batch.pos_examples) + sum(len(ex) for ex in batch.neg_examples)
                    batch_context_size = len(batch.bk_content) + batch_exs_size + len(batch.bias_content or "")
                    total_batch_sizes += batch_context_size
                    
                    existing_hyp = bbsilp_processor.get_existing_hypothesis(batch.folder_path)
                    status = "✅ Solved" if existing_hyp else "⏳ Pending"
                    reduction = ((full_context_size - batch_context_size) / full_context_size * 100) if full_context_size > 0 else 0
                    
                    st.markdown(f"**Batch {batch.batch_id}**: {len(batch.pos_examples)} pos, {len(batch.neg_examples)} neg - {status}")
                    st.markdown(f"  - BK: `{len(batch.bk_content):,}` chars | Total: `{batch_context_size:,}` chars ({batch_context_size//1024} KB) | **{reduction:.1f}% smaller**")
                
                if len(existing_batches) > 5:
                    st.write(f"... and {len(existing_batches) - 5} more batches")
                
                # Average batch size
                avg_batch_size = sum(len(b.bk_content) + sum(len(ex) for ex in b.pos_examples) + sum(len(ex) for ex in b.neg_examples) for b in existing_batches) // len(existing_batches)
                avg_reduction = ((full_context_size - avg_batch_size) / full_context_size * 100) if full_context_size > 0 else 0
                
                st.markdown("---")
                st.markdown(f"**SUMMARY:**")
                st.markdown(f"- Full context: **{full_context_size:,}** chars ({full_context_size//1024} KB)")
                st.markdown(f"- Avg batch context: **{avg_batch_size:,}** chars ({avg_batch_size//1024} KB)")
                st.markdown(f"- **Average reduction: {avg_reduction:.1f}%**")
                
                log_message(f"BBSILP SIZE: Full={full_context_size//1024}KB, AvgBatch={avg_batch_size//1024}KB, Reduction={avg_reduction:.1f}%")
            
            # Collect hypotheses from solved batches with coverage info
            batch_hypotheses = []  # List of dicts: {batch_id, hypothesis, batch_pos, batch_neg, batch_coverage}
            for batch in existing_batches:
                hyp = bbsilp_processor.get_existing_hypothesis(batch.folder_path)
                if hyp:
                    # Read metrics to get batch coverage
                    metrics_path = os.path.join(batch.folder_path, "metrics.json")
                    batch_cov = {"pos": len(batch.pos_examples), "neg": 0}  # Default
                    if os.path.exists(metrics_path):
                        try:
                            with open(metrics_path, 'r', encoding='utf-8') as f:
                                metrics = json.load(f)
                                if metrics.get("iterations"):
                                    last_iter = metrics["iterations"][-1]
                                    if "batch_coverage" in last_iter:
                                        batch_cov = {
                                            "pos": last_iter["batch_coverage"].get("covered_pos", len(batch.pos_examples)),
                                            "neg": last_iter["batch_coverage"].get("covered_neg", 0)
                                        }
                        except:
                            pass
                    batch_hypotheses.append({
                        "batch_id": batch.batch_id,
                        "hypothesis": hyp,
                        "batch_pos_count": len(batch.pos_examples),
                        "batch_neg_count": len(batch.neg_examples),
                        "batch_coverage": batch_cov
                    })
                    log_message(f"BBSILP: Batch {batch.batch_id} has hypothesis: {hyp.split(chr(10))[0][:50]}...")
            
            # Store clause coverage for reuse in LLM combination
            all_clause_coverage = []
            
            # Load existing all_batch_clauses.pl as fallback (from previous runs)
            all_batch_clauses_file = os.path.join(task_dir, "all_batch_clauses.pl")
            if os.path.exists(all_batch_clauses_file):
                try:
                    with open(all_batch_clauses_file, 'r', encoding='utf-8') as f:
                        for line in f:
                            line = line.strip()
                            if line and not line.startswith('%') and ':-' in line:
                                # Extract clause (before %% comment)
                                clause = line.split('%%')[0].strip()
                                if clause:
                                    clause_result = loop.tester.test_hypothesis(clause)
                                    all_clause_coverage.append({
                                        'batch_id': 'previous',
                                        'clause': clause,
                                        'full_pos': len(clause_result.covered_pos),
                                        'full_neg': len(clause_result.covered_neg),
                                        'covered_pos_set': {re.sub(r'\s+', '', ex) for ex in clause_result.covered_pos}
                                    })
                    log_message(f"BBSILP: Loaded {len(all_clause_coverage)} clauses from all_batch_clauses.pl")
                    st.info(f"📂 Loaded {len(all_clause_coverage)} clauses from previous run")
                except Exception as e:
                    log_message(f"BBSILP: Error loading all_batch_clauses.pl: {e}")
            
            if batch_hypotheses:
                st.success(f"📊 Found {len(batch_hypotheses)} solved batches with hypotheses")
                
                # ═══ FIX: Add existing solved batches to consolidated metrics ═══
                for batch in existing_batches:
                    hyp = bbsilp_processor.get_existing_hypothesis(batch.folder_path)
                    if hyp:
                        # Read batch metrics.json
                        batch_metrics_path = os.path.join(batch.folder_path, "metrics.json")
                        batch_metrics_data = {
                            "batch_id": batch.batch_id,
                            "folder_path": batch.folder_path,
                            "pos_count": len(batch.pos_examples),
                            "neg_count": len(batch.neg_examples),
                            "bk_size_bytes": len(batch.bk_content),
                            "solved": True,
                            "hypothesis": hyp.split('\n')[0][:100] + "..." if len(hyp) > 100 else hyp
                        }
                        if os.path.exists(batch_metrics_path):
                            try:
                                with open(batch_metrics_path, 'r', encoding='utf-8') as f:
                                    stored_metrics = json.load(f)
                                    batch_metrics_data.update({
                                        "learning_time_seconds": stored_metrics.get("learning_time_seconds", 0),
                                        "total_iterations": len(stored_metrics.get("iterations", [])),
                                        "is_generalizable": stored_metrics.get("is_generalizable", False)
                                    })
                            except:
                                pass
                        bbsilp_all_metrics["batches"].append(batch_metrics_data)
                
                bbsilp_all_metrics["summary"]["total_batches"] = len(bbsilp_all_metrics["batches"])
                bbsilp_all_metrics["summary"]["solved_batches"] = len([b for b in bbsilp_all_metrics["batches"] if b.get("solved")])
                log_message(f"BBSILP: Added {len(bbsilp_all_metrics['batches'])} existing solved batches to metrics")
                
                # Test each hypothesis on full dataset for early termination
                st.markdown("### Testing Batch Hypotheses on Full Dataset")
                
                best_hypothesis = None
                best_coverage = (0, float('inf'))  # (pos_covered, neg_covered)
                early_termination_found = False
                
                for bh in batch_hypotheses:
                    if early_termination_found:
                        break
                    batch_id = bh["batch_id"]
                    hyp = bh["hypothesis"]
                    with st.spinner(f"Testing batch {batch_id} hypothesis..."):
                        test_result = loop.tester.test_hypothesis(hyp)
                        pos_covered = len(test_result.covered_pos)
                        neg_covered = len(test_result.covered_neg)
                        
                        st.session_state.metrics["total_prolog_tests"] += 1
                        
                        # Store coverage for each clause (for LLM combination later)
                        # NAF FILTERING: Skip NAF clauses if NAF not yet enabled
                        allow_naf = st.session_state.naf_state.get("allow_naf", False)
                        for clause in hyp.split('\n'):
                            clause = clause.strip()
                            if clause and not clause.startswith('%') and ':-' in clause:
                                # Check if clause contains NAF
                                if not allow_naf and contains_naf(clause):
                                    st.session_state.naf_state["deferred_naf_clauses"].append(clause)
                                    log_message(f"⏳ BBSILP: Deferred NAF clause: {clause[:60]}...")
                                    continue
                                clause_result = loop.tester.test_hypothesis(clause)
                                all_clause_coverage.append({
                                    'batch_id': batch_id,
                                    'clause': clause,
                                    'full_pos': len(clause_result.covered_pos),
                                    'full_neg': len(clause_result.covered_neg),
                                    'covered_pos_set': {re.sub(r'\s+', '', ex) for ex in clause_result.covered_pos}
                                })
                        
                        # Check for early termination (covers all pos, zero neg)
                        if len(test_result.missed_pos) == 0 and neg_covered == 0:
                            st.success(f"🎉 **EARLY TERMINATION**: Batch {batch_id} hypothesis generalizes!")
                            st.code(hyp, language="prolog")
                            log_message(f"BBSILP: EARLY TERMINATION - Batch {batch_id} generalizes to full dataset")
                            
                            # Save solution
                            st.session_state.solved = True
                            st.session_state.best_hyp = hyp
                            loop.save_hypothesis(hyp)
                            
                            # Save consolidated metrics on early termination
                            bbsilp_all_metrics["summary"]["early_termination"] = True
                            bbsilp_all_metrics["summary"]["final_status"] = "solved"
                            bbsilp_all_metrics["summary"]["elapsed_time_seconds"] = round(time.time() - bbsilp_start_time, 2)
                            bbsilp_all_metrics["final_hypothesis"] = hyp
                            bbsilp_all_metrics["completed_at"] = datetime.now().isoformat()
                            bbsilp_metrics_path = os.path.join(task_dir, "bbsilp_metrics.json")
                            with open(bbsilp_metrics_path, 'w', encoding='utf-8') as f:
                                json.dump(bbsilp_all_metrics, f, indent=2)
                            
                            # Also create metrics.json for consistency
                            metrics_json = {
                                "task_dir": task_dir,
                                "model": model_name,
                                "strategy": "BATCH_SCALABLE",
                                "mode": "early_termination",
                                "solved": True,
                                "solution": hyp,
                                "total_positives": len(all_positives),
                                "total_negatives": len(all_negatives),
                                "end_time": datetime.now().isoformat()
                            }
                            metrics_path = os.path.join(task_dir, "metrics.json")
                            with open(metrics_path, 'w', encoding='utf-8') as f:
                                json.dump(metrics_json, f, indent=2)
                            
                            st.success(f"📊 Metrics saved to `bbsilp_metrics.json` and `metrics.json`")
                            
                            # Skip to end - set flag and break
                            early_termination_found = True
                            st.balloons()
                            break
                        
                        # Track best partial cover
                        if neg_covered == 0 and pos_covered > best_coverage[0]:
                            best_coverage = (pos_covered, neg_covered)
                            best_hypothesis = hyp
                        
                        st.write(f"Batch {batch_id}: {pos_covered}/{len(all_positives)} pos, {neg_covered} neg")
                
                # If early termination found, stop here
                if early_termination_found:
                    st.stop()
                
                # If no early termination, track best partial cover
                if best_hypothesis and best_coverage[1] == 0 and best_coverage[0] > 0:
                    st.info(f"🔗 Best partial cover: {best_coverage[0]}/{len(all_positives)} positives")
                    st.code(best_hypothesis, language="prolog")
                    
                    preserved_good_clauses.append({
                        'clause': best_hypothesis.strip(),
                        'covered_count': best_coverage[0]
                    })
                    log_message(f"BBSILP: Using best batch hypothesis as partial cover")
            
            # ═══ BBSILP: Run ILP for each unsolved batch, test on full dataset ═══
            unsolved_batches = [b for b in existing_batches if not bbsilp_processor.get_existing_hypothesis(b.folder_path)]
            
            if unsolved_batches:
                st.info(f"🔄 Running ILP for {len(unsolved_batches)} unsolved batches...")
                
                # Smart UI: For large tasks (50+ batches), use single container to avoid memory issues
                large_task_mode = len(unsolved_batches) >= 50
                if large_task_mode:
                    st.warning(f"⚡ Large task mode: {len(unsolved_batches)} batches - UI optimized for memory")
                    batch_ui_container = st.empty()  # Single container that gets overwritten
                    progress_bar = st.progress(0, text="Starting batch processing...")
                
                for batch_idx, batch in enumerate(unsolved_batches):
                    # Large task mode: overwrite container instead of appending
                    if large_task_mode:
                        progress_bar.progress((batch_idx + 1) / len(unsolved_batches), 
                                            text=f"Batch {batch.batch_id} ({batch_idx + 1}/{len(unsolved_batches)})")
                        batch_ui_container.empty()
                        batch_display = batch_ui_container.container()
                    else:
                        st.markdown(f"---")
                        batch_display = st.container()
                    
                    with batch_display:
                        st.markdown(f"## 📦 Batch {batch.batch_id} ILP Learning")
                        col1, col2, col3 = st.columns(3)
                        with col1:
                            st.metric("Positive Examples", len(batch.pos_examples))
                        with col2:
                            st.metric("Negative Examples", len(batch.neg_examples))
                        with col3:
                            st.metric("BK Size", f"{len(batch.bk_content)//1024}KB")
                    
                    # ═══ SWITCH CONTEXT TO BATCH ═══
                    batch_task_dir = batch.folder_path
                    batch_loop = CascadePopperLoop(batch_task_dir, model=model_name)
                    
                    # Reset conversation for this batch
                    st.session_state.conversation_history = []
                    failed_hypotheses = []
                    
                    # ═══ BATCH PARTIAL COVER TRACKING ═══
                    batch_good_clauses = []  # Clauses with 0 neg but partial pos coverage
                    batch_covered_pos = set()  # Positives covered by good clauses (inner goals)
                    # Extract inner goals from pos(X). format OR use directly if already unwrapped
                    batch_pos_set = set()
                    for ex in batch.pos_examples:
                        ex_stripped = ex.strip()
                        # Try pos(X). format first
                        match = re.match(r'pos\((.+)\)\.$', ex_stripped.replace(' ', ''))
                        if match:
                            batch_pos_set.add(match.group(1))
                        else:
                            # Try without period
                            match = re.match(r'pos\((.+)\)\.?$', ex_stripped.replace(' ', ''))
                            if match:
                                batch_pos_set.add(match.group(1))
                            else:
                                # Already unwrapped inner goal (e.g., "f(train1)")
                                if ex_stripped:
                                    batch_pos_set.add(ex_stripped)
                    log_message(f"BBSILP Batch: Extracted {len(batch_pos_set)} inner goals from {len(batch.pos_examples)} pos examples")
                    
                    # ═══ FILTER EXAMPLES USING PREVIOUS BATCH SOLUTIONS (Native Prolog) ═══
                    # Deduplicate all previous clauses and test in ONE Prolog call
                    original_batch_pos_count = len(batch_pos_set)
                    inherited_clauses = []  # Clauses from previous batches that help this batch
                    if batch_hypotheses:
                        # Prepare unique clauses from all previous batches
                        unique_clauses = prepare_clauses_from_hypotheses(batch_hypotheses)
                        log_message(f"BBSILP: Inherit test - {len(unique_clauses)} unique clauses from {len(batch_hypotheses)} previous batches (1 Prolog call)")
                        
                        if unique_clauses:
                            # Test all clauses in a single native Prolog call
                            bk_path = os.path.join(batch.folder_path, "bk.pl")
                            inherit_results = test_inherited_clauses(
                                bk_path, batch_pos_set, batch_loop.tester.neg_examples, unique_clauses
                            )
                            
                            # Process results: inherit safe clauses (neg=0, pos>0)
                            for r in inherit_results:
                                if r['num_neg'] == 0 and r['num_pos'] > 0:
                                    new_covered = r['covered_pos'] - batch_covered_pos
                                    if len(new_covered) > 0:
                                        inherited_clauses.append({
                                            'clause': r['clause'],
                                            'covered': new_covered,
                                            'count': len(new_covered),
                                            'from_batch': r['from_batch']
                                        })
                                        batch_covered_pos.update(new_covered)
                        
                        if inherited_clauses:
                            # Track remaining positives (don't modify tester - it must test against full exs.pl)
                            remaining_pos = batch_pos_set - batch_covered_pos
                            if remaining_pos:
                                # Keep batch.pos_examples for prompt context, but DON'T modify tester.pos_examples
                                # The tester consults exs.pl directly, so modifying pos_examples causes mismatch
                                batch.pos_examples = [f"pos({p})." for p in remaining_pos]
                                # Store remaining_pos for completion check (tester still tests full batch)
                                batch_remaining_pos = remaining_pos.copy()
                                log_message(f"BBSILP: Inherited {len(inherited_clauses)} clauses from previous batches, covering {len(batch_covered_pos)}/{original_batch_pos_count} positives")
                                log_message(f"BBSILP: Remaining {len(remaining_pos)} positives to cover: {remaining_pos}")
                                st.info(f"🔄 Inherited {len(inherited_clauses)} clause(s) from previous batches covering {len(batch_covered_pos)}/{original_batch_pos_count} positives")
                            else:
                                # All positives already covered by previous batches!
                                log_message(f"BBSILP: All {original_batch_pos_count} positives already covered by previous batch solutions!")
                                st.success(f"✅ Batch {batch.batch_id} already solved by previous batch solutions!")
                    
                    # ═══ BATCH METRICS TRACKING ═══
                    batch_start_time = time.time()
                    batch_metrics = {
                        "batch_id": batch.batch_id,
                        "parent_task": os.path.basename(task_dir),
                        "status": "learning",
                        "pos_count": len(batch.pos_examples),
                        "neg_count": len(batch.neg_examples),
                        "bk_size_bytes": len(batch.bk_content),
                        "solved": False,
                        "hypothesis": None,
                        "iterations": [],
                        "total_iterations": 0,
                        "is_generalizable": False,
                        "full_dataset_coverage": None,
                        "learning_time_seconds": 0
                    }
                    
                    # ═══ CHECK IF ALREADY SOLVED BY INHERITED CLAUSES ═══
                    batch_solved = False
                    if len(batch_covered_pos) >= len(batch_pos_set) and inherited_clauses:
                        # All positives covered by previous batch solutions
                        combined_hyp = "\n".join([ic['clause'] for ic in inherited_clauses])
                        batch_metrics["solved"] = True
                        batch_metrics["status"] = "solved_inherited"
                        batch_metrics["hypothesis"] = combined_hyp
                        batch_metrics["inherited_clauses"] = [
                            {"clause": ic['clause'], "from_batch": ic['from_batch'], "covered_count": ic['count']}
                            for ic in inherited_clauses
                        ]
                        # Save hypothesis file
                        hyp_path = os.path.join(batch.folder_path, "hypothesis.pl")
                        with open(hyp_path, 'w', encoding='utf-8') as f:
                            f.write(f"% BBSILP Batch {batch.batch_id} (inherited from previous batches)\n{combined_hyp}")
                        # Save metrics
                        batch_metrics["learning_time_seconds"] = 0
                        metrics_path = os.path.join(batch.folder_path, "metrics.json")
                        with open(metrics_path, 'w', encoding='utf-8') as f:
                            json.dump(batch_metrics, f, indent=2)
                        # Add to batch_hypotheses
                        batch_hypotheses.append({
                            "batch_id": batch.batch_id,
                            "hypothesis": combined_hyp,
                            "batch_pos_count": original_batch_pos_count,
                            "batch_neg_count": len(batch.neg_examples),
                            "batch_coverage": {"pos": original_batch_pos_count, "neg": 0}
                        })
                        batch_solved = True
                        log_message(f"BBSILP: Batch {batch.batch_id} solved by inherited clauses, skipping learning and full dataset test")
                        
                        # ═══ FIX: Add inherited clauses to all_clause_coverage for LLM combination ═══
                        # NAF FILTERING: Skip NAF clauses if NAF not yet enabled
                        allow_naf = st.session_state.naf_state.get("allow_naf", False)
                        for ic in inherited_clauses:
                            clause = ic['clause'].strip()
                            if clause and ':-' in clause:
                                # Check if clause contains NAF
                                if not allow_naf and contains_naf(clause):
                                    st.session_state.naf_state["deferred_naf_clauses"].append(clause)
                                    log_message(f"⏳ BBSILP: Deferred NAF clause: {clause[:60]}...")
                                    continue
                                # Check if already in all_clause_coverage (avoid duplicates)
                                existing = [c for c in all_clause_coverage if c['clause'] == clause]
                                if not existing:
                                    clause_result = loop.tester.test_hypothesis(clause)
                                    all_clause_coverage.append({
                                        'batch_id': ic['from_batch'],
                                        'clause': clause,
                                        'full_pos': len(clause_result.covered_pos),
                                        'full_neg': len(clause_result.covered_neg),
                                        'covered_pos_set': {re.sub(r'\s+', '', ex) for ex in clause_result.covered_pos}
                                    })
                    
                    # ═══ RUN STANDARD ILP LOOP FOR THIS BATCH ═══
                    for batch_iter in range(int(max_iters)):
                        if batch_solved:
                            break
                        log_message(f"BBSILP Batch {batch.batch_id} - Iteration {batch_iter + 1}")
                        
                        # UI: Show iteration in chat message style
                        with st.chat_message("assistant"):
                            st.write(f"**Batch {batch.batch_id} - Iteration {batch_iter + 1}/{max_iters}** - Generating hypothesis...")
                            
                            # Build prompt with batch's filtered BK
                            # Rebuild initial prompt if: first iteration OR after partial cover (failed_hypotheses reset)
                            if batch_iter == 0 or not failed_hypotheses:
                                batch_pos_str = "\n".join(batch.pos_examples)
                                batch_neg_str = "\n".join(batch.neg_examples)
                                bias_hints_content = batch.bias_content if batch.bias_content else bias_content
                                
                                # Build partial cover task header if we have locked clauses
                                batch_task_header = ""
                                
                                # Extract valid predicates from bias (body_pred declarations)
                                valid_preds = set()
                                head_preds = set()
                                for line in bias_hints_content.split('\n'):
                                    line = line.strip()
                                    if line.startswith('body_pred('):
                                        # Extract predicate name from body_pred(name, arity)
                                        match = re.match(r'body_pred\((\w+),', line)
                                        if match:
                                            valid_preds.add(match.group(1))
                                    elif line.startswith('head_pred('):
                                        match = re.match(r'head_pred\((\w+),', line)
                                        if match:
                                            head_preds.add(match.group(1))
                                
                                def check_clause_uses_valid_preds(clause, valid_preds, head_preds):
                                    """Check if clause only uses valid predicates from bias."""
                                    # Extract all predicate names from clause
                                    pred_pattern = r'\b([a-z_][a-z0-9_]*)\s*\('
                                    used_preds = set(re.findall(pred_pattern, clause))
                                    # Remove head predicates (allowed in head)
                                    body_preds_used = used_preds - head_preds
                                    # Check if all body predicates are valid
                                    invalid_preds = body_preds_used - valid_preds
                                    return len(invalid_preds) == 0, invalid_preds
                                
                                # Add ALL previous batch solutions context (from batch_hypotheses)
                                # Test each previous solution against THIS batch's examples
                                if batch_hypotheses:
                                    prev_clauses_info = []
                                    valid_solutions_count = 0
                                    invalid_solutions_count = 0
                                    for bh in batch_hypotheses:
                                        bid = bh["batch_id"]
                                        hyp = bh["hypothesis"]
                                        # Test entire hypothesis against CURRENT batch for summary
                                        try:
                                            curr_batch_result = batch_loop.tester.test_hypothesis(hyp)
                                            curr_pos = len(curr_batch_result.covered_pos)
                                            curr_neg = len(curr_batch_result.covered_neg)
                                            curr_total_pos = len(batch.pos_examples)
                                            curr_total_neg = len(batch.neg_examples)
                                            coverage_str = f"on THIS batch: {curr_pos}/{curr_total_pos} pos, {curr_neg}/{curr_total_neg} neg"
                                            if curr_pos == curr_total_pos and curr_neg == 0:
                                                coverage_str += " ✓ WORKS!"
                                        except:
                                            coverage_str = "could not test"
                                        
                                        # Test each clause individually for per-clause coverage
                                        # Build set of inherited clause strings for marking
                                        inherited_clause_set = {ic['clause'] for ic in inherited_clauses} if inherited_clauses else set()
                                        hyp_clauses = [c.strip() for c in hyp.split('\n') if c.strip() and c.strip().endswith('.')]
                                        clause_lines = []
                                        batch_has_invalid = False
                                        for clause in hyp_clauses:
                                            # Check if clause uses valid predicates
                                            is_valid, invalid_preds = check_clause_uses_valid_preds(clause, valid_preds, head_preds)
                                            if not is_valid:
                                                batch_has_invalid = True
                                                invalid_solutions_count += 1
                                                clause_lines.append(f"{clause}  % ⚠️ INVALID: uses {', '.join(invalid_preds)} (not in bias)")
                                                continue
                                            
                                            valid_solutions_count += 1
                                            # Check if this clause was inherited (already filtered positives)
                                            is_inherited = clause in inherited_clause_set
                                            inherited_info = next((ic for ic in inherited_clauses if ic['clause'] == clause), None) if inherited_clauses else None
                                            try:
                                                clause_result = batch_loop.tester.test_hypothesis(clause)
                                                c_pos = len(clause_result.covered_pos)
                                                c_neg = len(clause_result.covered_neg)
                                                if is_inherited and inherited_info:
                                                    # Show that this clause was already used to filter examples
                                                    clause_lines.append(f"{clause}  % ✓ INHERITED: covered {inherited_info['count']} pos (already filtered out)")
                                                else:
                                                    clause_lines.append(f"{clause}  % {c_pos} pos, {c_neg} neg")
                                            except:
                                                clause_lines.append(f"{clause}  % could not test")
                                        
                                        prev_clauses_info.append(f"% Batch {bid} ({coverage_str}):\n" + "\n".join(clause_lines))
                                    
                                    # Build warning about valid predicates
                                    valid_pred_warning = ""
                                    if invalid_solutions_count > 0:
                                        valid_pred_list = ', '.join(sorted(valid_preds))
                                        valid_pred_warning = f"""
**⚠️ WARNING: {invalid_solutions_count} previous solutions use INVALID predicates (marked above).**
**VALID body predicates:** {valid_pred_list}
**Do NOT use any other predicates - they will fail validation.**

"""
                                    
                                    # Find predicates used in valid solutions vs all valid predicates
                                    used_preds_in_solutions = set()
                                    for bh in batch_hypotheses:
                                        for pred in re.findall(r'\b([a-z_][a-z0-9_]*)\s*\(', bh["hypothesis"]):
                                            if pred in valid_preds:
                                                used_preds_in_solutions.add(pred)
                                    unused_valid_preds = valid_preds - used_preds_in_solutions
                                    
                                    unused_hint = ""
                                    if unused_valid_preds:
                                        unused_hint = f"""
**💡 HINT: These valid predicates are UNUSED in prior solutions - consider them:**
{', '.join(sorted(unused_valid_preds))}

"""
                                    
                                    batch_task_header = f"""# ILP Task - BATCH {batch.batch_id} (with prior solutions)

## PREVIOUS BATCH SOLUTIONS (tested against THIS batch's {len(batch.pos_examples)} pos, {len(batch.neg_examples)} neg)
The following hypothesis(es) were found in {len(batch_hypotheses)} previous batch(es):
```prolog
{chr(10).join(prev_clauses_info)}
```
{valid_pred_warning}{unused_hint}**YOUR TASK:** Find a clause that works for THIS batch's examples.
- The clause should cover ALL {len(batch.pos_examples)} positive examples below with 0 negatives
- Check if a prior solution already works (marked with ✓ WORKS!)
- Otherwise, find a new or modified clause
- **ONLY use predicates declared in body_pred (bias constraints)**

"""
                                    log_message(f"BBSILP: Added {len(batch_hypotheses)} previous batch solutions to prompt ({valid_solutions_count} valid, {invalid_solutions_count} invalid)")
                                
                                # Add inherited clause context if we have inherited clauses
                                if inherited_clauses:
                                    inherited_details = []
                                    for ic in inherited_clauses:
                                        inherited_details.append(f"{ic['clause']}  % covers {ic['count']} positives (from batch {ic['from_batch']})")
                                    
                                    batch_task_header += f"""## INHERITED CLAUSES (already covering {len(batch_covered_pos)}/{original_batch_pos_count} positives)
The following clause(s) from previous batches already cover some positives with 0 negatives:
```prolog
{chr(10).join(inherited_details)}
```

**NOTE:** You only need to find a clause for the remaining {original_batch_pos_count - len(batch_covered_pos)} uncovered positives shown below.
The inherited clauses will be combined with your solution.

"""
                                    log_message(f"BBSILP: Added {len(inherited_clauses)} inherited clauses to prompt context")
                                
                                log_message(f"BBSILP: Checking for partial cover header - batch_good_clauses count: {len(batch_good_clauses)}")
                                if batch_good_clauses:
                                    clause_details = []
                                    for gc in batch_good_clauses:
                                        clause_details.append(f"{gc['clause']}  % covers {gc['count']} positives")
                                    
                                    # Append partial cover section to existing header (which may have previous batch solutions)
                                    batch_task_header += f"""# ILP Task - BATCH PARTIAL COVER ROUND {len(batch_good_clauses)}

## LOCKED CLAUSES (this batch)
We have found {len(batch_good_clauses)} partial solution clause(s) that cover {len(batch_covered_pos)}/{len(batch_pos_set)} positives with 0 negatives.
```prolog
{chr(10).join(clause_details)}
```

**YOUR TASK:** Find ONE clause for the remaining {len(batch_pos_set) - len(batch_covered_pos)} uncovered positives.
- Must cover SOME of the remaining positives
- Must cover ZERO negatives

"""
                                    log_message(f"BBSILP: Built partial cover header for {len(batch_good_clauses)} locked clauses")
                                    st.success(f"📋 Partial Cover Round {len(batch_good_clauses)} - {len(batch_covered_pos)}/{len(batch_pos_set)} covered")
                                
                                base_prompt = init_prompt_template.replace("{background_knowledge}", batch.bk_content)
                                base_prompt = base_prompt.replace("{bias_hints}", bias_hints_content)
                                base_prompt = base_prompt.replace("{bias}", bias_hints_content)  # Fallback for old templates
                                base_prompt = base_prompt.replace("{positive_examples}", batch_pos_str)
                                base_prompt = base_prompt.replace("{negative_examples}", batch_neg_str)
                                
                                # Prepend task header if we have partial covers
                                if batch_task_header:
                                    base_prompt = batch_task_header + base_prompt
                            else:
                                # Feedback based on last result
                                last_hyp, last_result = failed_hypotheses[-1]
                                base_prompt = get_feedback_prompt(
                                    previous_code=last_hyp,
                                    result=last_result,
                                    bk_text=batch.bk_content,
                                    feedback_templates=feedback_templates,
                                    total_negatives_count=len(batch.neg_examples)
                                )
                            
                            # UI: Show prompt in expander (skip in large task mode to save memory)
                            if not large_task_mode:
                                with st.expander(f"📤 Prompt sent to LLM ({len(base_prompt)} chars)", expanded=False):
                                    st.code(base_prompt, language="markdown")
                            
                            try:
                                # Call LLM with spinner
                                llm_start = time.time()
                                full_response = call_llm_with_display(
                                    base_prompt, model_name, api_key,
                                    conversation_history=st.session_state.conversation_history
                                )
                                llm_time = round(time.time() - llm_start, 2)
                                
                                if not full_response:
                                    st.warning("No response from LLM")
                                    continue
                                
                                # Update conversation history
                                st.session_state.conversation_history.append({"role": "user", "parts": [{"text": base_prompt}]})
                                st.session_state.conversation_history.append({"role": "model", "parts": [{"text": full_response}]})
                                
                                # Extract hypothesis candidates
                                beam_candidates = parse_beam_candidates(full_response)
                                if not beam_candidates:
                                    st.warning("No hypothesis extracted from response")
                                    continue
                                
                                # UI: Show beam search results
                                st.write(f"⏱️ LLM time: {llm_time}s | Found {len(beam_candidates)} candidate(s)")
                                
                                # Evaluate each clause SEPARATELY (like main loop)
                                best_candidate = None
                                best_score = -float('inf')
                                candidate_results = []
                                clause_idx = 0
                                
                                # Calculate remaining positives for partial cover mode
                                remaining_batch_pos_for_scoring = batch_pos_set - batch_covered_pos
                                
                                for cidx, cand_text in enumerate(beam_candidates):
                                    cand_clauses = parse_prolog_clauses(cand_text)
                                    if not cand_clauses:
                                        continue
                                    
                                    # BIAS VALIDATION: Disabled - accept all predicates from BK
                                    # if bias_content:
                                    #     cand_clauses = filter_valid_clauses(cand_clauses, bias_content, log_message)
                                    #     if not cand_clauses:
                                    #         continue
                                    
                                    # NAF FILTERING: Skip NAF clauses if NAF not yet enabled
                                    allow_naf = st.session_state.naf_state.get("allow_naf", False)
                                    if not allow_naf:
                                        filtered_cand_clauses = []
                                        for c in cand_clauses:
                                            if contains_naf(c):
                                                st.session_state.naf_state["deferred_naf_clauses"].append(c)
                                                log_message(f"⏳ BBSILP: Deferred NAF clause: {c[:60]}...")
                                            else:
                                                filtered_cand_clauses.append(c)
                                        cand_clauses = filtered_cand_clauses
                                        if not cand_clauses:
                                            continue
                                    
                                    # Test each clause separately
                                    for clause in cand_clauses[:4]:
                                        clause_idx += 1
                                        
                                        # Test single clause on batch
                                        cand_result = batch_loop.tester.test_hypothesis(clause)
                                        cand_neg = len(cand_result.covered_neg)
                                        
                                        # In partial cover mode, only count coverage of REMAINING positives
                                        if batch_good_clauses and len(remaining_batch_pos_for_scoring) < len(batch_pos_set):
                                            # Normalize to match batch_pos_set format (no whitespace)
                                            normalized_cand_pos = {re.sub(r'\s+', '', ex) for ex in cand_result.covered_pos}
                                            cand_pos = len(normalized_cand_pos & remaining_batch_pos_for_scoring)
                                            total_target_pos = len(remaining_batch_pos_for_scoring)
                                        else:
                                            cand_pos = len(cand_result.covered_pos)
                                            total_target_pos = len(batch_pos_set)
                                        
                                        # ENHANCED SCORING: F1-based with strong negative penalty (same as main loop)
                                        if cand_neg == 0:
                                            # Perfect precision - reward based on recall
                                            if cand_pos > 0:
                                                recall = cand_pos / max(total_target_pos, 1)
                                                score = 100 + int(recall * 100)  # 100-200 range
                                            else:
                                                score = 0  # Covers nothing
                                        else:
                                            # Has false positives - penalize heavily
                                            precision = cand_pos / max(cand_pos + cand_neg, 1)
                                            recall = cand_pos / max(total_target_pos, 1)
                                            if precision + recall > 0:
                                                f1 = 2 * precision * recall / (precision + recall)
                                            else:
                                                f1 = 0
                                            score = int(f1 * 50) - cand_neg  # -inf to 50 range
                                        
                                        candidate_results.append({
                                            "idx": clause_idx, "hyp": clause,
                                            "pos": cand_pos, "neg": cand_neg,
                                            "score": score, "result": cand_result,
                                            "total_target_pos": total_target_pos
                                        })
                                        
                                        if score > best_score:
                                            best_score = score
                                            best_candidate = candidate_results[-1]
                                
                                # UI: Show beam results if multiple (skip in large task mode)
                                if len(candidate_results) > 1 and not large_task_mode:
                                    with st.expander(f"🔍 Beam Search: {len(candidate_results)} clauses evaluated", expanded=False):
                                        for cr in sorted(candidate_results, key=lambda x: -x['score']):
                                            marker = "✅" if cr == best_candidate else "  "
                                            st.write(f"{marker} Clause {cr['idx']}: {cr['pos']} pos, {cr['neg']} neg (score: {cr['score']})")
                                            st.code(cr['hyp'], language="prolog")
                                
                                if not best_candidate:
                                    st.warning("No valid candidates")
                                    continue
                                
                                hypothesis = best_candidate["hyp"]
                                result = best_candidate["result"]
                                
                                # UI: Show hypothesis (compact in large task mode)
                                if not large_task_mode:
                                    st.markdown("**Generated Hypothesis:**")
                                    st.code(hypothesis, language="prolog")
                                
                                # UI: Show coverage metrics
                                pos_covered = len(result.covered_pos)
                                neg_covered = len(result.covered_neg)
                                missed = len(result.missed_pos)
                                
                                # ═══ SAVE ITERATION TO METRICS ═══
                                iter_data = {
                                    "iteration": batch_iter + 1,
                                    "hypothesis": hypothesis,
                                    "batch_coverage": {
                                        "covered_pos": pos_covered,
                                        "covered_neg": neg_covered,
                                        "missed_pos": missed,
                                        "is_complete": result.is_complete
                                    },
                                    "llm_time_seconds": llm_time,
                                    "candidates_evaluated": len(candidate_results)
                                }
                                batch_metrics["iterations"].append(iter_data)
                                batch_metrics["total_iterations"] = batch_iter + 1
                                
                                col1, col2, col3 = st.columns(3)
                                with col1:
                                    # When inherited clauses exist, show coverage against remaining positives
                                    if inherited_clauses:
                                        remaining_target = original_batch_pos_count - len(batch_covered_pos)
                                        # Count how many of the remaining positives this hypothesis covers
                                        remaining_pos_set = batch_pos_set - batch_covered_pos
                                        new_covered = len(result.covered_pos & remaining_pos_set)
                                        st.metric("Positives Covered", f"{new_covered}/{remaining_target}", help=f"Inherited: {len(batch_covered_pos)}/{original_batch_pos_count}")
                                    else:
                                        st.metric("Positives Covered", f"{pos_covered}/{original_batch_pos_count}")
                                with col2:
                                    st.metric("Negatives Covered", neg_covered, delta=f"-{neg_covered}" if neg_covered > 0 else "0 ✓", delta_color="inverse")
                                with col3:
                                    st.metric("Missed Positives", missed)
                                
                                # Check if solved for batch
                                # When inherited clauses exist, combine them with new hypothesis to check completion
                                check_complete = result.is_complete
                                if not check_complete and inherited_clauses and neg_covered == 0:
                                    # Combine inherited clauses with new hypothesis and test
                                    inherited_hyp = "\n".join([ic['clause'] for ic in inherited_clauses])
                                    combined_for_check = f"{inherited_hyp}\n{hypothesis}"
                                    combined_result = batch_loop.tester.test_hypothesis(combined_for_check)
                                    check_complete = combined_result.is_complete
                                    if check_complete:
                                        log_message(f"BBSILP: Combined inherited+new hypothesis covers all {original_batch_pos_count} positives")
                                
                                if check_complete:
                                    st.success(f"✅ **Batch {batch.batch_id} SOLVED!**")
                                    
                                    # If we have inherited clauses, include them in final hypothesis
                                    if inherited_clauses:
                                        inherited_hyp = "\n".join([ic['clause'] for ic in inherited_clauses])
                                        all_clauses = [inherited_hyp, hypothesis]
                                        if batch_good_clauses:
                                            all_clauses = [gc['clause'] for gc in batch_good_clauses] + all_clauses
                                        combined_hypothesis = "\n".join(all_clauses)
                                        log_message(f"BBSILP: Combined {len(inherited_clauses)} inherited + new hypothesis")
                                        batch_metrics["inherited_clauses"] = [
                                            {"clause": ic['clause'], "from_batch": ic['from_batch'], "covered_count": ic['count']}
                                            for ic in inherited_clauses
                                        ]
                                        batch_metrics["status"] = "solved_with_inheritance"
                                    # If we have partial cover clauses (but no inheritance), combine them
                                    elif batch_good_clauses:
                                        all_clauses = [gc['clause'] for gc in batch_good_clauses] + [hypothesis]
                                        combined_hypothesis = "\n".join(all_clauses)
                                        log_message(f"BBSILP: Combined {len(batch_good_clauses)} partial cover clauses + final clause into full hypothesis")
                                        batch_metrics["partial_cover_clauses"] = len(batch_good_clauses)
                                        batch_metrics["combined_clauses"] = [
                                            {"clause": gc['clause'], "covered_count": gc['count']} 
                                            for gc in batch_good_clauses
                                        ] + [{"clause": hypothesis, "covered_count": pos_covered}]
                                        batch_metrics["status"] = "solved_combined"
                                    else:
                                        combined_hypothesis = hypothesis
                                        batch_metrics["status"] = "solved"
                                    
                                    # Save to batch folder
                                    hyp_path = os.path.join(batch.folder_path, "hypothesis.pl")
                                    with open(hyp_path, 'w', encoding='utf-8') as f:
                                        f.write(f"% BBSILP Batch {batch.batch_id}\n{combined_hypothesis}")
                                    
                                    # Update batch metrics
                                    batch_metrics["solved"] = True
                                    batch_metrics["hypothesis"] = combined_hypothesis
                                    
                                    # Add to batch_hypotheses so subsequent batches can see this solution
                                    batch_hypotheses.append({
                                        "batch_id": batch.batch_id,
                                        "hypothesis": combined_hypothesis,
                                        "batch_pos_count": len(batch_pos_set),
                                        "batch_neg_count": len(batch.neg_examples),
                                        "batch_coverage": {"pos": len(batch_pos_set), "neg": 0}
                                    })
                                    log_message(f"BBSILP: Added batch {batch.batch_id} solution to batch_hypotheses (now {len(batch_hypotheses)} total)")
                                    
                                    # ═══ FIX: Add clauses to all_clause_coverage for LLM combination ═══
                                    # NAF FILTERING: Skip NAF clauses if NAF not yet enabled
                                    allow_naf = st.session_state.naf_state.get("allow_naf", False)
                                    for clause in combined_hypothesis.split('\n'):
                                        clause = clause.strip()
                                        if clause and not clause.startswith('%') and ':-' in clause:
                                            # Check if clause contains NAF
                                            if not allow_naf and contains_naf(clause):
                                                st.session_state.naf_state["deferred_naf_clauses"].append(clause)
                                                log_message(f"⏳ BBSILP: Deferred NAF clause: {clause[:60]}...")
                                                continue
                                            clause_result = loop.tester.test_hypothesis(clause)
                                            all_clause_coverage.append({
                                                'batch_id': batch.batch_id,
                                                'clause': clause,
                                                'full_pos': len(clause_result.covered_pos),
                                                'full_neg': len(clause_result.covered_neg),
                                                'covered_pos_set': {re.sub(r'\s+', '', ex) for ex in clause_result.covered_pos}
                                            })
                                    log_message(f"BBSILP: Added {len([c for c in combined_hypothesis.split(chr(10)) if c.strip() and ':-' in c])} clauses to all_clause_coverage")
                                    
                                    # NO batch-level optimization - optimization only when full dataset solution found
                                    
                                    # ═══ TEST ON FULL DATASET FOR EARLY TERMINATION ═══
                                    st.markdown("### 🌍 Testing on Full Dataset")
                                    full_result = loop.tester.test_hypothesis(combined_hypothesis)
                                    full_pos = len(full_result.covered_pos)
                                    full_neg = len(full_result.covered_neg)
                                    full_missed = len(full_result.missed_pos)
                                    
                                    batch_metrics["full_dataset_coverage"] = {
                                        "covered_pos": full_pos,
                                        "total_pos": len(all_positives),
                                        "covered_neg": full_neg,
                                        "missed_pos": full_missed
                                    }
                                    
                                    col1, col2, col3 = st.columns(3)
                                    with col1:
                                        st.metric("Full Positives", f"{full_pos}/{len(all_positives)}")
                                    with col2:
                                        st.metric("Full Negatives", full_neg)
                                    with col3:
                                        st.metric("Full Missed", full_missed)
                                    
                                    # ═══ EARLY TERMINATION IF GENERALIZES ═══
                                    if full_missed == 0 and full_neg == 0:
                                        st.success(f"🎉 **GENERALIZES!** Batch {batch.batch_id} solution works on full dataset!")
                                        st.balloons()
                                        batch_metrics["is_generalizable"] = True
                                        batch_metrics["status"] = "generalizable"
                                        
                                        # ═══ D&C OPTIMIZATION (sampled examples - 10 pos, 10 neg) ═══
                                        st.markdown("### 🔧 Divide & Conquer Optimization (sampled)")
                                        original_lits = sum(1 for c in combined_hypothesis.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                                        
                                        try:
                                            opt_start = time.time()
                                            
                                            # Sample 10 pos, 10 neg with exponential distribution
                                            import numpy as np
                                            sample_size = 10
                                            
                                            pos_list = list(all_positives)
                                            if len(pos_list) > sample_size:
                                                weights = np.exp(-np.arange(len(pos_list)) / (len(pos_list) / 3))
                                                weights = weights / weights.sum()
                                                sampled_pos_idx = np.random.choice(len(pos_list), size=sample_size, replace=False, p=weights)
                                                sampled_pos = [pos_list[i] for i in sampled_pos_idx]
                                            else:
                                                sampled_pos = pos_list
                                            
                                            neg_list = list(all_negatives)
                                            if len(neg_list) > sample_size:
                                                weights = np.exp(-np.arange(len(neg_list)) / (len(neg_list) / 3))
                                                weights = weights / weights.sum()
                                                sampled_neg_idx = np.random.choice(len(neg_list), size=sample_size, replace=False, p=weights)
                                                sampled_neg = [neg_list[i] for i in sampled_neg_idx]
                                            else:
                                                sampled_neg = neg_list
                                            
                                            pos_str = "\n".join([f"pos({p})." for p in sampled_pos])
                                            neg_str = "\n".join([f"neg({n})." for n in sampled_neg])
                                            log_message(f"D&C Optimization: Sampled {len(sampled_pos)} pos, {len(sampled_neg)} neg")
                                            
                                            optimized_hyp, opt_success, _ = divide_and_conquer_optimize(
                                                combined_hypothesis, bk_content, optimization_template,
                                                model_name, api_key, loop.tester,
                                                pos_examples=pos_str, neg_examples=neg_str,
                                                bias_content=bias_content
                                            )
                                            opt_time = round(time.time() - opt_start, 2)
                                            
                                            if opt_success and optimized_hyp:
                                                new_lits = sum(1 for c in optimized_hyp.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                                                if new_lits < original_lits:
                                                    st.success(f"✅ D&C Optimization: {original_lits} → {new_lits} literals ({opt_time}s)")
                                                    combined_hypothesis = optimized_hyp
                                                    batch_metrics["optimization"] = {
                                                        "applied": True,
                                                        "original_literals": original_lits,
                                                        "optimized_literals": new_lits,
                                                        "time_seconds": opt_time
                                                    }
                                                else:
                                                    st.info(f"D&C: No improvement ({opt_time}s)")
                                            else:
                                                st.info(f"D&C: Optimization skipped ({opt_time}s)")
                                        except Exception as e:
                                            st.warning(f"D&C optimization error: {e}")
                                            log_message(f"BBSILP D&C error: {e}")
                                        
                                        batch_metrics["learning_time_seconds"] = round(time.time() - batch_start_time, 2)
                                        batch_metrics["hypothesis"] = combined_hypothesis
                                        
                                        # Save metrics.json
                                        metrics_path = os.path.join(batch.folder_path, "metrics.json")
                                        with open(metrics_path, 'w', encoding='utf-8') as f:
                                            json.dump(batch_metrics, f, indent=2)
                                        
                                        # Save hypothesis
                                        hyp_path = os.path.join(batch.folder_path, "hypothesis.pl")
                                        with open(hyp_path, 'w', encoding='utf-8') as f:
                                            f.write(f"% BBSILP Batch {batch.batch_id} (generalizable, optimized)\n{combined_hypothesis}")
                                        
                                        st.session_state.solved = True
                                        st.session_state.best_hyp = combined_hypothesis
                                        loop.save_hypothesis(combined_hypothesis)
                                        
                                        # Save consolidated metrics on early termination
                                        bbsilp_all_metrics["batches"].append(batch_metrics.copy())
                                        bbsilp_all_metrics["summary"]["total_batches"] = len(bbsilp_all_metrics["batches"])
                                        bbsilp_all_metrics["summary"]["solved_batches"] += 1
                                        bbsilp_all_metrics["summary"]["early_termination"] = True
                                        bbsilp_all_metrics["summary"]["final_status"] = "solved"
                                        bbsilp_all_metrics["summary"]["elapsed_time_seconds"] = round(time.time() - bbsilp_start_time, 2)
                                        bbsilp_all_metrics["final_hypothesis"] = combined_hypothesis
                                        bbsilp_all_metrics["completed_at"] = datetime.now().isoformat()
                                        bbsilp_metrics_path = os.path.join(task_dir, "bbsilp_metrics.json")
                                        with open(bbsilp_metrics_path, 'w', encoding='utf-8') as f:
                                            json.dump(bbsilp_all_metrics, f, indent=2)
                                        st.success(f"📊 Metrics saved to `bbsilp_metrics.json`")
                                        
                                        st.stop()
                                    
                                    # Add to preserved_good_clauses for later combination (avoid duplicates)
                                    if full_neg == 0 and full_pos > 0:
                                        existing_clauses = set()
                                        for pc in preserved_good_clauses:
                                            for c in pc['clause'].split('\n'):
                                                c = c.strip()
                                                if c and ':-' in c:
                                                    existing_clauses.add(c)
                                        
                                        new_clauses = []
                                        for c in combined_hypothesis.strip().split('\n'):
                                            c = c.strip()
                                            if c and ':-' in c and c not in existing_clauses:
                                                new_clauses.append(c)
                                                existing_clauses.add(c)
                                        
                                        if new_clauses:
                                            preserved_good_clauses.append({
                                                'clause': '\n'.join(new_clauses),
                                                'covered_count': full_pos
                                            })
                                            log_message(f"BBSILP: Added {len(new_clauses)} clause(s) to preserved_good_clauses")
                                            st.info(f"Partial cover: {full_pos}/{len(all_positives)} positives (+{len(new_clauses)} new clauses)")
                                    
                                    # Save metrics for this batch
                                    batch_metrics["learning_time_seconds"] = round(time.time() - batch_start_time, 2)
                                    batch_metrics["hypothesis"] = combined_hypothesis
                                    metrics_path = os.path.join(batch.folder_path, "metrics.json")
                                    with open(metrics_path, 'w', encoding='utf-8') as f:
                                        json.dump(batch_metrics, f, indent=2)
                                    
                                    # Save optimized hypothesis
                                    hyp_path = os.path.join(batch.folder_path, "hypothesis.pl")
                                    with open(hyp_path, 'w', encoding='utf-8') as f:
                                        f.write(f"% BBSILP Batch {batch.batch_id} (batch-optimized)\n{combined_hypothesis}")
                                    
                                    batch_solved = True
                                    break  # Continue to next batch
                                else:
                                    # ═══ CHECK FOR PARTIAL COVER (0 neg, some pos) ═══
                                    # Parse clauses from hypothesis
                                    hyp_clauses = [c.strip() for c in hypothesis.split('\n') if c.strip() and c.strip().endswith('.')]
                                    
                                    # Check for recursive hypothesis - skip partial cover for recursive rules
                                    is_recursive = is_recursive_hypothesis(hypothesis)
                                    if is_recursive:
                                        log_message(f"BBSILP: Recursive hypothesis detected - skipping partial cover logic")
                                    
                                    # SINGLE CLAUSE PARTIAL COVER CHECK (same as main loop)
                                    # Only trigger for single clauses with 0 negatives, non-recursive
                                    if len(hyp_clauses) == 1 and neg_covered == 0 and pos_covered > 0 and not is_recursive:
                                        single_clause = hyp_clauses[0]
                                        
                                        # Check if clause is already locked (duplicate check)
                                        batch_locked_strs = [gc['clause'] for gc in batch_good_clauses]
                                        if single_clause in batch_locked_strs:
                                            log_message(f"BBSILP: Clause already locked, skipping: {single_clause[:50]}...")
                                        else:
                                            # This is a good clause - covers some positives with zero negatives
                                            # Normalize covered_pos to match batch_pos_set format (no whitespace)
                                            normalized_covered = {re.sub(r'\s+', '', ex) for ex in result.covered_pos}
                                            new_covered = normalized_covered - batch_covered_pos
                                            if len(new_covered) > 0:
                                                batch_good_clauses.append({
                                                    'clause': single_clause,
                                                    'covered': new_covered,
                                                    'count': len(new_covered)
                                                })
                                                batch_covered_pos.update(new_covered)
                                                st.success(f"🎯 Partial cover: +{len(new_covered)} new positives (total: {len(batch_covered_pos)}/{len(batch_pos_set)})")
                                                log_message(f"BBSILP Batch {batch.batch_id}: Partial cover +{len(new_covered)}, total {len(batch_covered_pos)}")
                                                
                                                # Record partial cover clause in iterations
                                                partial_iter_data = {
                                                    "iteration": batch_iter + 1,
                                                    "type": "partial_cover",
                                                    "clause": single_clause,
                                                    "new_positives_covered": len(new_covered),
                                                    "total_positives_covered": len(batch_covered_pos),
                                                    "total_positives": len(batch_pos_set),
                                                    "locked_clauses_count": len(batch_good_clauses)
                                                }
                                                batch_metrics["iterations"].append(partial_iter_data)
                                                
                                                # ═══ UPDATE EXAMPLES FOR REMAINING POSITIVES ═══
                                                remaining_batch_pos = batch_pos_set - batch_covered_pos
                                                if remaining_batch_pos:
                                                    # Update batch examples for prompt context only
                                                    # DON'T modify tester.pos_examples - it tests against exs.pl directly
                                                    batch.pos_examples = [f"pos({p})." for p in remaining_batch_pos]
                                                    log_message(f"BBSILP: Remaining {len(remaining_batch_pos)} positives to cover")
                                                    
                                                    locked_clauses_str = "\n".join([gc['clause'] for gc in batch_good_clauses])
                                                    st.info(f"🔄 Restarting with {len(remaining_batch_pos)} remaining positives")
                                                    st.code(f"% Locked clauses:\n{locked_clauses_str}", language="prolog")
                                                    # Reset failed hypotheses AND conversation history for fresh partial cover prompt
                                                    failed_hypotheses = []
                                                    st.session_state.conversation_history = []
                                                    log_message(f"BBSILP: Reset conversation history for partial cover round")
                                                    
                                                    # Continue to next iteration with partial cover prompt
                                                    continue
                                                
                                                # Check if all batch positives are now covered
                                                if len(batch_covered_pos) >= len(batch_pos_set):
                                                    st.success(f"✅ All batch positives covered by {len(batch_good_clauses)} clause(s)!")
                                                    # Build combined hypothesis from inherited + new clauses
                                                    all_clauses_for_test = [gc['clause'] for gc in batch_good_clauses]
                                                    if inherited_clauses:
                                                        all_clauses_for_test = [ic['clause'] for ic in inherited_clauses] + all_clauses_for_test
                                                        log_message(f"BBSILP: Including {len(inherited_clauses)} inherited clauses in combined hypothesis")
                                                    combined_batch_hyp = "\n".join(all_clauses_for_test)
                                                    log_message(f"BBSILP: All {len(batch_pos_set)} positives covered - batch solved with {len(all_clauses_for_test)} clauses")
                                                    
                                                    # No redundant test needed - batch_covered_pos tracking confirms all covered
                                                    if True:  # All positives covered by tracking
                                                        hypothesis = combined_batch_hyp
                                                        batch_metrics["partial_cover_clauses"] = len(batch_good_clauses)
                                                        # Save the actual combined clauses for metrics
                                                        batch_metrics["combined_clauses"] = [
                                                            {"clause": gc['clause'], "covered_count": gc['count']} 
                                                            for gc in batch_good_clauses
                                                        ]
                                                        
                                                        # Save and test on full dataset (reuse existing code path)
                                                        hyp_path = os.path.join(batch.folder_path, "hypothesis.pl")
                                                        with open(hyp_path, 'w', encoding='utf-8') as f:
                                                            f.write(f"% BBSILP Batch {batch.batch_id} (partial cover combined)\n{hypothesis}")
                                                        
                                                        batch_metrics["solved"] = True
                                                        batch_metrics["hypothesis"] = hypothesis
                                                        batch_metrics["status"] = "solved_partial_cover"
                                                        
                                                        # Add to batch_hypotheses so subsequent batches can see this solution
                                                        batch_hypotheses.append({
                                                            "batch_id": batch.batch_id,
                                                            "hypothesis": hypothesis,
                                                            "batch_pos_count": len(batch_pos_set),
                                                            "batch_neg_count": len(batch.neg_examples),
                                                            "batch_coverage": {"pos": len(batch_covered_pos), "neg": 0}
                                                        })
                                                        log_message(f"BBSILP: Added batch {batch.batch_id} partial cover solution to batch_hypotheses (now {len(batch_hypotheses)} total)")
                                                        
                                                        # ═══ TEST ON FULL DATASET FOR EARLY TERMINATION ═══
                                                        st.markdown("### 🌍 Testing on Full Dataset")
                                                        full_result = loop.tester.test_hypothesis(hypothesis)
                                                        full_pos = len(full_result.covered_pos)
                                                        full_neg = len(full_result.covered_neg)
                                                        full_missed = len(full_result.missed_pos)
                                                        
                                                        col1, col2, col3 = st.columns(3)
                                                        with col1:
                                                            st.metric("Full Positives", f"{full_pos}/{len(all_positives)}")
                                                        with col2:
                                                            st.metric("Full Negatives", full_neg)
                                                        with col3:
                                                            st.metric("Full Missed", full_missed)
                                                        
                                                        # ═══ EARLY TERMINATION IF GENERALIZES ═══
                                                        if full_missed == 0 and full_neg == 0:
                                                            st.success(f"🎉 **GENERALIZES!** Partial cover solution works on full dataset!")
                                                            st.balloons()
                                                            batch_metrics["is_generalizable"] = True
                                                            batch_metrics["status"] = "generalizable"
                                                            
                                                            # ═══ D&C OPTIMIZATION (sampled - 10 pos, 10 neg) ═══
                                                            st.markdown("### 🔧 Divide & Conquer Optimization (sampled)")
                                                            original_lits = sum(1 for c in hypothesis.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                                                            
                                                            try:
                                                                opt_start = time.time()
                                                                
                                                                # Sample 10 pos, 10 neg with exponential distribution
                                                                import numpy as np
                                                                sample_size = 10
                                                                
                                                                pos_list = list(all_positives)
                                                                if len(pos_list) > sample_size:
                                                                    weights = np.exp(-np.arange(len(pos_list)) / (len(pos_list) / 3))
                                                                    weights = weights / weights.sum()
                                                                    sampled_pos_idx = np.random.choice(len(pos_list), size=sample_size, replace=False, p=weights)
                                                                    sampled_pos = [pos_list[i] for i in sampled_pos_idx]
                                                                else:
                                                                    sampled_pos = pos_list
                                                                
                                                                neg_list = list(all_negatives)
                                                                if len(neg_list) > sample_size:
                                                                    weights = np.exp(-np.arange(len(neg_list)) / (len(neg_list) / 3))
                                                                    weights = weights / weights.sum()
                                                                    sampled_neg_idx = np.random.choice(len(neg_list), size=sample_size, replace=False, p=weights)
                                                                    sampled_neg = [neg_list[i] for i in sampled_neg_idx]
                                                                else:
                                                                    sampled_neg = neg_list
                                                                
                                                                pos_str = "\n".join([f"pos({p})." for p in sampled_pos])
                                                                neg_str = "\n".join([f"neg({n})." for n in sampled_neg])
                                                                log_message(f"D&C Optimization: Sampled {len(sampled_pos)} pos, {len(sampled_neg)} neg")
                                                                
                                                                optimized_hyp, opt_success, _ = divide_and_conquer_optimize(
                                                                    hypothesis, bk_content, optimization_template,
                                                                    model_name, api_key, loop.tester,
                                                                    pos_examples=pos_str, neg_examples=neg_str,
                                                                    bias_content=bias_content
                                                                )
                                                                opt_time = round(time.time() - opt_start, 2)
                                                                
                                                                if opt_success and optimized_hyp:
                                                                    new_lits = sum(1 for c in optimized_hyp.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                                                                    if new_lits < original_lits:
                                                                        st.success(f"✅ D&C: {original_lits} → {new_lits} literals ({opt_time}s)")
                                                                        hypothesis = optimized_hyp
                                                                    else:
                                                                        st.info(f"D&C: No improvement ({opt_time}s)")
                                                                else:
                                                                    st.info(f"D&C: Optimization skipped ({opt_time}s)")
                                                            except Exception as e:
                                                                log_message(f"D&C error: {e}")
                                                            
                                                            batch_metrics["learning_time_seconds"] = round(time.time() - batch_start_time, 2)
                                                            batch_metrics["hypothesis"] = hypothesis
                                                            
                                                            metrics_path = os.path.join(batch.folder_path, "metrics.json")
                                                            with open(metrics_path, 'w', encoding='utf-8') as f:
                                                                json.dump(batch_metrics, f, indent=2)
                                                            
                                                            st.session_state.solved = True
                                                            st.session_state.best_hyp = hypothesis
                                                            loop.save_hypothesis(hypothesis)
                                                            
                                                            bbsilp_all_metrics["batches"].append(batch_metrics.copy())
                                                            bbsilp_all_metrics["summary"]["total_batches"] = len(bbsilp_all_metrics["batches"])
                                                            bbsilp_all_metrics["summary"]["solved_batches"] += 1
                                                            bbsilp_all_metrics["summary"]["early_termination"] = True
                                                            bbsilp_all_metrics["summary"]["final_status"] = "solved"
                                                            bbsilp_all_metrics["summary"]["elapsed_time_seconds"] = round(time.time() - bbsilp_start_time, 2)
                                                            bbsilp_all_metrics["final_hypothesis"] = hypothesis
                                                            bbsilp_all_metrics["completed_at"] = datetime.now().isoformat()
                                                            bbsilp_metrics_path = os.path.join(task_dir, "bbsilp_metrics.json")
                                                            with open(bbsilp_metrics_path, 'w', encoding='utf-8') as f:
                                                                json.dump(bbsilp_all_metrics, f, indent=2)
                                                            st.success(f"📊 Metrics saved")
                                                            
                                                            st.stop()
                                                        
                                                        # Add to preserved_good_clauses for later combination (avoid duplicates)
                                                        if full_neg == 0 and full_pos > 0:
                                                            existing = set()
                                                            for pc in preserved_good_clauses:
                                                                for c in pc['clause'].split('\n'):
                                                                    c = c.strip()
                                                                    if c and ':-' in c:
                                                                        existing.add(c)
                                                            new_c = [c.strip() for c in hypothesis.strip().split('\n') 
                                                                     if c.strip() and ':-' in c.strip() and c.strip() not in existing]
                                                            if new_c:
                                                                preserved_good_clauses.append({
                                                                    'clause': '\n'.join(new_c),
                                                                    'covered_count': full_pos
                                                                })
                                                                log_message(f"BBSILP: Added {len(new_c)} new clause(s) to preserved_good_clauses")
                                                                st.info(f"Partial cover: {full_pos}/{len(all_positives)} positives")
                                                        
                                                        batch_solved = True
                                                        break  # Continue to next batch
                                                continue  # Keep looking for more clauses
                                    
                                    # UI: Show feedback reason (skip details in large task mode)
                                    if not large_task_mode:
                                        if result.is_too_general:
                                            st.error(f"❌ Too General - covers {neg_covered} negatives")
                                            with st.expander("Covered Negatives (sample)", expanded=False):
                                                for neg in list(result.covered_neg)[:5]:
                                                    st.code(neg)
                                        elif result.is_too_specific and neg_covered > 0:
                                            st.warning(f"⚠️ Too Specific - misses {missed} positives")
                                            with st.expander("Missed Positives (sample)", expanded=False):
                                                for pos in list(result.missed_pos)[:5]:
                                                    st.code(pos)
                                    
                                    failed_hypotheses.append((hypothesis, result))
                                    
                            except Exception as e:
                                st.error(f"Error: {e}")
                                log_message(f"BBSILP Batch {batch.batch_id} error: {e}")
                    
                    if not batch_solved:
                        st.warning(f"⚠️ Batch {batch.batch_id} not solved after {max_iters} iterations")
                        batch_metrics["status"] = "failed"
                        
                        # ═══ SAVE PARTIAL COVERS FROM UNSOLVED BATCH ═══
                        # Even if batch didn't fully solve, save any good clauses found
                        if batch_good_clauses:
                            combined_partial = "\n".join([gc['clause'] for gc in batch_good_clauses])
                            
                            # Test partial clauses on full dataset
                            partial_result = loop.tester.test_hypothesis(combined_partial)
                            partial_pos = len(partial_result.covered_pos)
                            partial_neg = len(partial_result.covered_neg)
                            
                            if partial_neg == 0 and partial_pos > 0:
                                st.info(f"💾 Saving {len(batch_good_clauses)} partial clause(s) from failed batch (covers {partial_pos}/{len(all_positives)} on full dataset)")
                                
                                # Add to preserved_good_clauses (avoid duplicates)
                                existing = set()
                                for pc in preserved_good_clauses:
                                    for c in pc['clause'].split('\n'):
                                        c = c.strip()
                                        if c and ':-' in c:
                                            existing.add(c)
                                
                                new_clauses = [gc['clause'] for gc in batch_good_clauses if gc['clause'] not in existing]
                                if new_clauses:
                                    preserved_good_clauses.append({
                                        'clause': '\n'.join(new_clauses),
                                        'covered_count': partial_pos
                                    })
                                    log_message(f"BBSILP: Saved {len(new_clauses)} partial clause(s) from batch {batch.batch_id}")
                    
                    # Save metrics.json for this batch (final state)
                    batch_metrics["learning_time_seconds"] = round(time.time() - batch_start_time, 2)
                    metrics_path = os.path.join(batch.folder_path, "metrics.json")
                    with open(metrics_path, 'w', encoding='utf-8') as f:
                        json.dump(batch_metrics, f, indent=2)
                    log_message(f"BBSILP: Saved metrics for batch {batch.batch_id}")
                    
                    # ═══ ADD TO CONSOLIDATED METRICS ═══
                    bbsilp_all_metrics["batches"].append(batch_metrics.copy())
                    bbsilp_all_metrics["summary"]["total_batches"] = len(bbsilp_all_metrics["batches"])
                    bbsilp_all_metrics["summary"]["total_iterations"] += batch_metrics.get("total_iterations", 0)
                    if batch_metrics.get("solved"):
                        bbsilp_all_metrics["summary"]["solved_batches"] += 1
                    else:
                        bbsilp_all_metrics["summary"]["failed_batches"] += 1
                    
                    # Save consolidated metrics after each batch (incremental)
                    bbsilp_all_metrics["summary"]["elapsed_time_seconds"] = round(time.time() - bbsilp_start_time, 2)
                    bbsilp_metrics_path = os.path.join(task_dir, "bbsilp_metrics.json")
                    with open(bbsilp_metrics_path, 'w', encoding='utf-8') as f:
                        json.dump(bbsilp_all_metrics, f, indent=2)
                    
                    # Continue to next batch...
                
                # Cleanup large task mode UI elements after all batches processed
                if large_task_mode:
                    progress_bar.progress(1.0, text=f"✅ All {len(unsolved_batches)} batches processed")
                    batch_ui_container.empty()  # Clear the container
            
            st.markdown("---")
            
            # ═══ COMBINE PARTIAL SOLUTIONS & D&C OPTIMIZE ═══
            # FIX: Also enter this block when batch_hypotheses exist but no generalizable hypothesis found
            # This handles the case where all batches solved but none generalized to full dataset
            if preserved_good_clauses or (batch_hypotheses and not st.session_state.get('solved')):
                st.markdown("### 🔗 Combining Partial Solutions")
                
                # Combine all partial clauses - REMOVE DUPLICATES
                seen_clauses = set()
                unique_clauses = []
                
                # First add preserved_good_clauses if any
                if preserved_good_clauses:
                    st.info(f"Found {len(preserved_good_clauses)} partial solution(s) from batches")
                    for pc in preserved_good_clauses:
                        for clause in pc['clause'].split('\n'):
                            clause = clause.strip()
                            if clause and ':-' in clause and clause not in seen_clauses:
                                seen_clauses.add(clause)
                                unique_clauses.append(clause)
                
                # FIX: If no preserved_good_clauses but have batch_hypotheses, use those
                if not preserved_good_clauses and batch_hypotheses:
                    st.info(f"No generalizable hypothesis found - combining {len(batch_hypotheses)} batch hypotheses for LLM-guided combination")
                    log_message(f"BBSILP: No generalizable hypothesis - entering LLM-guided combination with {len(batch_hypotheses)} batch hypotheses")
                    for bh in batch_hypotheses:
                        for clause in bh['hypothesis'].split('\n'):
                            clause = clause.strip()
                            if clause and ':-' in clause and not clause.startswith('%') and clause not in seen_clauses:
                                seen_clauses.add(clause)
                                unique_clauses.append(clause)
                                
                                # FIX: Also add to all_clause_coverage if not already there
                                # NAF FILTERING: Skip NAF clauses if NAF not yet enabled
                                allow_naf = st.session_state.naf_state.get("allow_naf", False)
                                if not allow_naf and contains_naf(clause):
                                    st.session_state.naf_state["deferred_naf_clauses"].append(clause)
                                    log_message(f"⏳ BBSILP: Deferred NAF clause: {clause[:60]}...")
                                    continue
                                existing = [c for c in all_clause_coverage if c['clause'] == clause]
                                if not existing:
                                    clause_result = loop.tester.test_hypothesis(clause)
                                    all_clause_coverage.append({
                                        'batch_id': bh['batch_id'],
                                        'clause': clause,
                                        'full_pos': len(clause_result.covered_pos),
                                        'full_neg': len(clause_result.covered_neg),
                                        'covered_pos_set': {re.sub(r'\s+', '', ex) for ex in clause_result.covered_pos}
                                    })
                    log_message(f"BBSILP: all_clause_coverage now has {len(all_clause_coverage)} clauses for LLM combination")
                
                combined_hypothesis = "\n".join(unique_clauses)
                
                # Debug: Log combined hypothesis details
                log_message(f"BBSILP: Combined hypothesis has {len(unique_clauses)} unique clauses")
                if not unique_clauses:
                    log_message(f"BBSILP WARNING: unique_clauses is EMPTY! preserved_good_clauses={len(preserved_good_clauses) if preserved_good_clauses else 0}, batch_hypotheses={len(batch_hypotheses) if batch_hypotheses else 0}")
                    st.warning("⚠️ No clauses found to combine - check batch results")
                
                # Calculate total_covered based on source
                if preserved_good_clauses:
                    total_covered = sum(pc['covered_count'] for pc in preserved_good_clauses)
                    st.write(f"Combined covers ~{total_covered} positives (may overlap)")
                else:
                    st.write(f"Combined {len(unique_clauses)} unique clauses from batch hypotheses")
                st.code(combined_hypothesis, language="prolog")
                
                # Test combined on full dataset
                combined_result = loop.tester.test_hypothesis(combined_hypothesis)
                combined_pos = len(combined_result.covered_pos)
                combined_neg = len(combined_result.covered_neg)
                combined_missed = len(combined_result.missed_pos)
                
                # Debug: Log test results
                log_message(f"BBSILP: Combined test result - pos={combined_pos}/{len(all_positives)}, neg={combined_neg}, missed={combined_missed}")
                
                col1, col2, col3 = st.columns(3)
                with col1:
                    st.metric("Combined Positives", f"{combined_pos}/{len(all_positives)}")
                with col2:
                    st.metric("Combined Negatives", combined_neg)
                with col3:
                    st.metric("Combined Missed", combined_missed)
                
                # If combined solution is complete, run D&C optimization
                if combined_missed == 0 and combined_neg == 0:
                    st.success("✅ Combined partial covers solve the full dataset!")
                    st.balloons()
                    
                    # ═══ D&C OPTIMIZATION (sampled - 10 pos, 10 neg) ═══
                    st.markdown("### 🔧 Divide & Conquer Optimization (sampled)")
                    original_lits = sum(1 for c in combined_hypothesis.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                    
                    try:
                        opt_start = time.time()
                        
                        # Sample 10 pos, 10 neg with exponential distribution
                        import numpy as np
                        sample_size = 10
                        
                        pos_list = list(all_positives)
                        if len(pos_list) > sample_size:
                            weights = np.exp(-np.arange(len(pos_list)) / (len(pos_list) / 3))
                            weights = weights / weights.sum()
                            sampled_pos_idx = np.random.choice(len(pos_list), size=sample_size, replace=False, p=weights)
                            sampled_pos = [pos_list[i] for i in sampled_pos_idx]
                        else:
                            sampled_pos = pos_list
                        
                        neg_list = list(all_negatives)
                        if len(neg_list) > sample_size:
                            weights = np.exp(-np.arange(len(neg_list)) / (len(neg_list) / 3))
                            weights = weights / weights.sum()
                            sampled_neg_idx = np.random.choice(len(neg_list), size=sample_size, replace=False, p=weights)
                            sampled_neg = [neg_list[i] for i in sampled_neg_idx]
                        else:
                            sampled_neg = neg_list
                        
                        pos_str = "\n".join([f"pos({p})." for p in sampled_pos])
                        neg_str = "\n".join([f"neg({n})." for n in sampled_neg])
                        log_message(f"D&C Optimization: Sampled {len(sampled_pos)} pos, {len(sampled_neg)} neg")
                        
                        optimized_hyp, success, group_analyses = divide_and_conquer_optimize(
                            combined_hypothesis, bk_content, optimization_template,
                            model_name, api_key, loop.tester,
                            pos_examples=pos_str, neg_examples=neg_str,
                            bias_content=bias_content
                        )
                        opt_time = round(time.time() - opt_start, 2)
                        
                        if success and optimized_hyp:
                            new_lits = sum(1 for c in optimized_hyp.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                            if new_lits < original_lits:
                                st.success(f"✅ D&C Optimization: {original_lits} → {new_lits} literals ({opt_time}s)")
                                combined_hypothesis = optimized_hyp
                            else:
                                st.info(f"D&C: No improvement ({opt_time}s)")
                        else:
                            st.info(f"D&C: Optimization failed ({opt_time}s)")
                    except Exception as e:
                        st.warning(f"D&C optimization error: {e}")
                        log_message(f"BBSILP D&C error: {e}")
                    
                    # Save final solution
                    st.session_state.solved = True
                    st.session_state.best_hyp = combined_hypothesis
                    loop.save_hypothesis(combined_hypothesis)
                    
                    # Note: For BBSILP tasks, we save to bbsilp_metrics.json only (not metrics.json)
                    # Save BBSILP consolidated metrics
                    bbsilp_all_metrics["summary"]["final_status"] = "solved"
                    bbsilp_all_metrics["summary"]["elapsed_time_seconds"] = round(time.time() - bbsilp_start_time, 2)
                    bbsilp_all_metrics["final_hypothesis"] = combined_hypothesis
                    bbsilp_all_metrics["completed_at"] = datetime.now().isoformat()
                    bbsilp_metrics_path = os.path.join(task_dir, "bbsilp_metrics.json")
                    with open(bbsilp_metrics_path, 'w', encoding='utf-8') as f:
                        json.dump(bbsilp_all_metrics, f, indent=2)
                    st.success(f"📊 Metrics saved")
                    
                    st.stop()  # Early termination - combined partial covers solved it!
                else:
                    st.warning(f"Combined solution incomplete: {combined_missed} missed, {combined_neg} neg")
                    
                    # ═══ LLM-GUIDED HYPOTHESIS COMBINATION ═══
                    st.markdown("### 🤖 LLM-Guided Hypothesis Combination")
                    st.info("Finding clauses that cover remaining examples...")
                    
                    # Initialize variables
                    remaining_pos = list(combined_result.missed_pos)
                    remaining_pos_set = set(remaining_pos)
                    max_combination_iters = 20
                    combination_solved = False
                    combination_iterations = []  # Track iteration metrics for saving
                    
                    # Debug: Log what we're working with
                    log_message(f"COMBINATION: Starting with {len(remaining_pos)} remaining pos, {combined_neg} neg, {len(all_clause_coverage)} clauses in coverage")
                    
                    # FIX: Handle case where all positives covered but need to reduce negatives
                    needs_refinement = len(remaining_pos) == 0 and combined_neg > 0
                    if needs_refinement:
                        st.warning(f"All positives covered but {combined_neg} negatives - calling LLM to refine hypothesis")
                        log_message(f"COMBINATION: All pos covered but {combined_neg} neg - entering LLM refinement mode")
                        # Set remaining_pos to all positives so we can call refinement LLM
                        remaining_pos = list(all_positives)
                        remaining_pos_set = set(remaining_pos)
                    
                    for combination_iter in range(max_combination_iters):
                        if (len(remaining_pos) == 0 or combination_solved) and not needs_refinement:
                            break
                        # After first refinement iteration, check if negatives reduced
                        if needs_refinement and combination_iter > 0:
                            # Re-test hypothesis
                            retest = loop.tester.test_hypothesis(combined_hypothesis)
                            if len(retest.covered_neg) == 0:
                                st.success("✅ Refinement successful - 0 negatives!")
                                combination_solved = True
                                break
                            combined_neg = len(retest.covered_neg)
                            if combination_iter >= 20:  # Same limit as LLM-guided combination
                                st.warning(f"Refinement stopped after {combination_iter} iterations, {combined_neg} neg remaining")
                                break
                        
                        st.markdown(f"#### 🔄 Iteration {combination_iter + 1}/{max_combination_iters}")
                        log_message(f"COMBINATION iter {combination_iter+1}: {len(remaining_pos)} positives still uncovered, needs_refinement={needs_refinement}")
                        
                        try:
                            # ═══ REFINEMENT MODE: Specialize hypothesis to reduce negatives ═══
                            if needs_refinement:
                                st.info(f"🔧 Refinement Mode: Specializing to exclude {combined_neg} negatives")
                                
                                # Sample violated negatives for the prompt (increased from 10 to 20)
                                import random
                                violated_neg = list(combined_result.covered_neg) if combined_result.covered_neg else []
                                sample_violated = random.sample(violated_neg, min(20, len(violated_neg))) if violated_neg else []
                                
                                # Sample positives that must still be covered (ALL positives)
                                sample_pos = list(all_positives)  # Show all positives
                                
                                # Read BK for grounding
                                bk_content = ""
                                bk_file = os.path.join(task_dir, "bk.pl")
                                if os.path.exists(bk_file):
                                    with open(bk_file, 'r') as bf:
                                        bk_content = bf.read()
                                
                                # Extract grounding for examples
                                def get_grounding_for_examples(bk, examples):
                                    facts = []
                                    for ex in examples:
                                        ex_str = str(ex)
                                        # Extract ID from example
                                        import re
                                        match = re.search(r'\((\d+)', ex_str)
                                        if match:
                                            ex_id = match.group(1)
                                            for line in bk.split('\n'):
                                                if ex_id in line and line.strip() and not line.strip().startswith('%'):
                                                    facts.append(line.strip())
                                    return '\n'.join(list(set(facts))[:100])  # Limit to 100 facts
                                
                                pos_grounding = get_grounding_for_examples(bk_content, sample_pos)
                                neg_grounding = get_grounding_for_examples(bk_content, sample_violated)
                                
                                # Read bias (FULL - no truncation)
                                bias_content = ""
                                bias_file = os.path.join(task_dir, "bias.pl")
                                if os.path.exists(bias_file):
                                    with open(bias_file, 'r') as bf:
                                        bias_lines = [l.strip() for l in bf if l.strip() and not l.startswith('%')]
                                        bias_content = '\n'.join(bias_lines)  # Full bias language
                                
                                # Extract static type declarations from BK (constants, types, relations)
                                # Separate into categories: type predicates (1-arg), relations (2-arg), and state predicates
                                type_preds = []  # 1-arg predicates like p5(c30), p6(c31)
                                relation_preds = []  # 2-arg like p15(1,2), p4(c29,c24)
                                other_static = []  # Other static facts
                                
                                for line in bk_content.split('\n'):
                                    line = line.strip()
                                    if line and not line.startswith('%') and line.endswith('.'):
                                        # Match static facts with constants only
                                        if re.match(r'^[a-z_][a-z_0-9]*\([a-z0-9_,\s]+\)\.$', line):
                                            args = line.split('(')[1].rstrip(').').split(',')
                                            first_arg = args[0].strip()
                                            # Skip state-specific facts (first arg is example ID > 100)
                                            if first_arg.isdigit() and int(first_arg) > 100:
                                                continue
                                            # Skip p2, p3 facts (these are state-specific, not type declarations)
                                            pred_name = line.split('(')[0]
                                            if pred_name in ['p2', 'p3']:
                                                continue
                                            
                                            # Categorize by arity
                                            if len(args) == 1:
                                                type_preds.append(line)
                                            elif len(args) == 2:
                                                relation_preds.append(line)
                                            else:
                                                other_static.append(line)
                                
                                # Prioritize: type predicates first, then relations, then others
                                type_preds = sorted(list(set(type_preds)))
                                relation_preds = sorted(list(set(relation_preds)))
                                other_static = sorted(list(set(other_static)))[:20]  # Limit other
                                
                                static_types = type_preds + relation_preds + other_static
                                static_types_str = '\n'.join(static_types) if static_types else "None found"
                                
                                # Build feedback section from previous failed attempts with per-clause coverage
                                feedback_section = ""
                                if hasattr(st.session_state, 'refinement_failed_hypotheses') and st.session_state.refinement_failed_hypotheses:
                                    # Deduplicate failed hypotheses before displaying
                                    def normalize_hyp_for_dedup(h):
                                        clauses = sorted([c.strip() for c in h.strip().split('\n') if c.strip() and ':-' in c])
                                        return '\n'.join(clauses)
                                    
                                    seen_normalized = set()
                                    unique_failed = []
                                    for item in st.session_state.refinement_failed_hypotheses:
                                        norm = normalize_hyp_for_dedup(item[0])
                                        if norm not in seen_normalized:
                                            seen_normalized.add(norm)
                                            unique_failed.append(item)
                                    
                                    # Update session state with deduplicated list
                                    st.session_state.refinement_failed_hypotheses = unique_failed
                                    
                                    feedback_section = "## ❌ PREVIOUS FAILED ATTEMPTS - DO NOT REPEAT:\n"
                                    for i, (failed_hyp, failed_neg_count, failed_neg_samples) in enumerate(unique_failed[-3:], 1):
                                        # Get per-clause coverage for this failed hypothesis
                                        failed_clauses = [c.strip() for c in failed_hyp.split('\n') if c.strip() and ':-' in c]
                                        clause_coverage_lines = []
                                        for fc in failed_clauses:
                                            try:
                                                fc_result = loop.tester.test_hypothesis(fc)
                                                fc_pos = len(fc_result.covered_pos) if fc_result.covered_pos else 0
                                                fc_neg = len(fc_result.covered_neg) if fc_result.covered_neg else 0
                                                clause_coverage_lines.append(f"{fc}  % {fc_pos} pos, {fc_neg} neg")
                                            except:
                                                clause_coverage_lines.append(f"{fc}  % could not test")
                                        
                                        feedback_section += f"""
### Failed Attempt {i} (still covered {failed_neg_count} negatives):
```prolog
{chr(10).join(clause_coverage_lines)}
```
**Why it failed:** Still too general - covered negatives like: {', '.join([str(n) for n in failed_neg_samples[:3]])}

"""
                                
                                # Find highest-scoring clause from hypothesis for example
                                best_clause_section = ""
                                hypothesis_clauses = [c.strip() for c in combined_hypothesis.split('\n') if c.strip() and ':-' in c]
                                total_pos_count = len(all_positives)
                                if hypothesis_clauses and all_clause_coverage:
                                    # Find clause coverage info for each hypothesis clause
                                    clause_scores = []
                                    for hc in hypothesis_clauses:
                                        for cc in all_clause_coverage:
                                            if cc['clause'].strip() == hc:
                                                cand_pos = cc['full_pos']
                                                cand_neg = cc['full_neg']
                                                # ENHANCED SCORING: F1-based with strong negative penalty (same as feedback prompt)
                                                if cand_neg == 0:
                                                    # Perfect precision - reward based on recall
                                                    if cand_pos > 0:
                                                        recall = cand_pos / max(total_pos_count, 1)
                                                        score = 100 + int(recall * 100)  # 100-200 range
                                                    else:
                                                        score = 0  # Covers nothing
                                                else:
                                                    # Has false positives - penalize heavily
                                                    precision = cand_pos / max(cand_pos + cand_neg, 1)
                                                    recall = cand_pos / max(total_pos_count, 1)
                                                    if precision + recall > 0:
                                                        f1 = 2 * precision * recall / (precision + recall)
                                                    else:
                                                        f1 = 0
                                                    score = int(f1 * 50) - cand_neg  # -inf to 50 range
                                                clause_scores.append({
                                                    'clause': hc,
                                                    'full_pos': cand_pos,
                                                    'full_neg': cand_neg,
                                                    'score': score
                                                })
                                                break
                                    
                                    if clause_scores:
                                        # Sort by score descending
                                        clause_scores.sort(key=lambda x: x['score'], reverse=True)
                                        best = clause_scores[0]
                                        
                                        # Test the best clause to get missed positives and covered negatives
                                        best_clause_result = loop.tester.test_hypothesis(best['clause'])
                                        best_missed_pos = list(best_clause_result.missed_pos) if best_clause_result.missed_pos else []
                                        best_covered_neg = list(best_clause_result.covered_neg) if best_clause_result.covered_neg else []
                                        
                                        # Sample missed positives using exponential distribution (prioritize early ones)
                                        import numpy as np
                                        sampled_missed_pos = []
                                        if best_missed_pos:
                                            n_missed = len(best_missed_pos)
                                            n_sample = min(10, n_missed)
                                            if n_sample > 0:
                                                # Exponential weights: higher probability for earlier indices
                                                weights = np.exp(-np.arange(n_missed) / max(1, n_missed / 3))
                                                weights /= weights.sum()
                                                indices = np.random.choice(n_missed, size=n_sample, replace=False, p=weights)
                                                sampled_missed_pos = [best_missed_pos[i] for i in sorted(indices)]
                                        
                                        # Sample covered negatives using uniform distribution
                                        sampled_covered_neg = []
                                        if best_covered_neg:
                                            n_neg = len(best_covered_neg)
                                            n_sample = min(10, n_neg)
                                            if n_sample > 0:
                                                indices = random.sample(range(n_neg), n_sample)
                                                sampled_covered_neg = [best_covered_neg[i] for i in indices]
                                        
                                        # Build the best clause section with examples
                                        missed_pos_str = ', '.join([str(p) for p in sampled_missed_pos]) if sampled_missed_pos else "None"
                                        covered_neg_str = ', '.join([str(n) for n in sampled_covered_neg]) if sampled_covered_neg else "None"
                                        
                                        best_clause_section = f"""
## 🌍 Best Clause Example (highest score):
```prolog
{best['clause']}
```
**Coverage:** {best['full_pos']}/{len(all_positives)} positives, {best['full_neg']} negatives | **Score:** {best['score']}

**Missed Positives ({len(best_missed_pos)} total, showing {len(sampled_missed_pos)}):** {missed_pos_str}

**Covered Negatives ({len(best_covered_neg)} total, showing {len(sampled_covered_neg)}):** {covered_neg_str}

"""
                                
                                # Build clause scores section with per-rule coverage details and grounding
                                clause_scores_section = ""
                                if clause_scores:
                                    clause_scores_lines = []
                                    for cs in clause_scores:
                                        # Test each clause to get its specific covered pos/neg
                                        clause_result = loop.tester.test_hypothesis(cs['clause'])
                                        clause_covered_pos = list(clause_result.covered_pos) if clause_result.covered_pos else []
                                        clause_covered_neg = list(clause_result.covered_neg) if clause_result.covered_neg else []
                                        
                                        # Sample up to 3 positives and 3 negatives for this clause
                                        sample_clause_pos = random.sample(clause_covered_pos, min(3, len(clause_covered_pos))) if clause_covered_pos else []
                                        sample_clause_neg = random.sample(clause_covered_neg, min(3, len(clause_covered_neg))) if clause_covered_neg else []
                                        
                                        pos_str = ', '.join([str(p) for p in sample_clause_pos]) if sample_clause_pos else "None"
                                        neg_str = ', '.join([str(n) for n in sample_clause_neg]) if sample_clause_neg else "None"
                                        
                                        # Get grounding for this clause's samples
                                        clause_pos_grounding = get_grounding_for_examples(bk_content, sample_clause_pos) if sample_clause_pos else "None"
                                        clause_neg_grounding = get_grounding_for_examples(bk_content, sample_clause_neg) if sample_clause_neg else "None"
                                        
                                        clause_scores_lines.append(f"""### Clause: `{cs['clause']}`
- **Coverage:** {cs['full_pos']} pos, {cs['full_neg']} neg | **Score:** {cs['score']}
- **Entailed Positives ({len(clause_covered_pos)}):** {pos_str}
- **Entailed Negatives ({len(clause_covered_neg)}):** {neg_str}

**BK facts for entailed positives:**
```prolog
{clause_pos_grounding}
```

**BK facts for entailed negatives:**
```prolog
{clause_neg_grounding}
```
""")
                                    clause_scores_section = f"""
## 📊 Per-Clause Coverage (Combined Solution):
{chr(10).join(clause_scores_lines)}
"""
                                
                                # Detect same-prefix pairs (positives and negatives that share args except last)
                                same_prefix_hint = ""
                                try:
                                    def parse_example(ex_str):
                                        # Parse p1(a, b, c) into args
                                        match = re.search(r'\(([^)]+)\)', str(ex_str))
                                        if match:
                                            return [a.strip() for a in match.group(1).split(',')]
                                        return []
                                    
                                    pos_args = [parse_example(p) for p in all_positives]
                                    neg_args = [parse_example(n) for n in violated_neg[:50]]  # Check first 50
                                    
                                    # Find pairs where all args match except last
                                    same_prefix_pairs = []
                                    for pa in pos_args:
                                        for na in neg_args:
                                            if len(pa) == len(na) and len(pa) >= 2:
                                                if pa[:-1] == na[:-1] and pa[-1] != na[-1]:
                                                    same_prefix_pairs.append((pa, na))
                                    
                                    if same_prefix_pairs:
                                        pa, na = same_prefix_pairs[0]
                                        same_prefix_hint = f"""
**🔍 PATTERN DETECTED: Same-prefix examples differ only in last argument!**
- Positive: `({', '.join(pa)})` - last arg = `{pa[-1]}`
- Negative: `({', '.join(na)})` - last arg = `{na[-1]}`
→ **You MUST constrain the last head variable using a 1-arg type predicate that matches `{pa[-1]}`**
→ Look in Static Types for a predicate like `pX({pa[-1]}).` and add `pX(C)` to the body.

"""
                                except:
                                    pass
                                
                                # Build refinement prompt
                                refinement_prompt = f"""# HYPOTHESIS REFINEMENT: Reduce Negative Coverage (Iteration {combination_iter + 1})
{feedback_section}{best_clause_section}{clause_scores_section}{same_prefix_hint}
## Current Hypothesis (TOO GENERAL - covers {combined_neg} negatives):
```prolog
{combined_hypothesis}
```

## Problem:
The hypothesis covers ALL {len(all_positives)} positive examples ✓
But it ALSO covers {combined_neg} negative examples ✗

## Violated Negatives ({len(violated_neg)} total, showing {len(sample_violated)}):
{', '.join([str(n) for n in sample_violated])}

### BK facts for violated negatives:
```prolog
{neg_grounding}
```

## Positive Examples (must KEEP covering these):
{', '.join([str(p) for p in sample_pos])}

### BK facts for positives:
```prolog
{pos_grounding}
```

## Bias Constraints:
```prolog
{bias_content}
```

**⚠️ CRITICAL: You are STRICTLY LIMITED to predicates defined above (head_pred and body_pred declarations). Any predicate NOT listed in body_pred is INVALID.**

## Static Types (from BK):
```prolog
{static_types_str}
```

## 🎯 GOAL: Cover {len(all_positives)}/{len(all_positives)} positives, 0/{combined_neg} negatives

## Task: SPECIALIZE the hypothesis
Find what distinguishes positives from negatives. Add constraints to exclude negatives while keeping positives.

### Analysis Steps:
1. Compare BK facts: What predicates exist for POSITIVES but NOT for NEGATIVES?
2. Find the discriminating literal that separates the two sets
3. Add that literal to make the clause more specific

**Hint: Look for structural differences:**
- Do positives have bidirectional relationships that negatives lack?
- Are there specific value patterns or constants unique to positives?
- Are there connectivity patterns (chains of predicates) that distinguish positive from negative examples?

**⚠️ COMMON MISTAKES TO AVOID:**
- **Using `_` (anonymous variable) in head:** This ignores that argument position! If you use `p1(A, B, _)`, the clause will match ANY value for the 3rd argument, covering BOTH wanted and unwanted examples. Always bind head variables (e.g., `p1(A, B, C)`) and constrain them with type predicates.
- **Missing type constraints:** If positives and negatives share the same first arguments but differ in the last argument, you MUST constrain the last argument using a 1-arg type predicate from the bias.
- **Look at 1-arg predicates in Static Types:** These are type constraints that can discriminate between different values (e.g., if examples differ by a constant value, find the 1-arg predicate that matches the positive's value).

### CRITICAL REMINDERS:
- **ONLY use predicates from Bias Constraints** (body_pred declarations) - nothing else!
- **ALWAYS bind ALL head variables** (A, B, C) - never use `_` in the head unless you truly want to ignore that argument
- Each clause must be on a SINGLE LINE
- Variables must be connected to head variables
- All variables in the body must be linked to head variables (A, B, C) or safely grounded - avoid disconnected sub-graphs
- The hypothesis MUST still cover all {len(all_positives)} positive examples

### Generate 3 specialized versions:
Each must cover the positives but NOT the negatives.

---CANDIDATE---
```prolog
<specialized_hypothesis_1>
```

---CANDIDATE---
```prolog
<specialized_hypothesis_2>
```

---CANDIDATE---
```prolog
<specialized_hypothesis_3>
```
"""
                                
                                st.markdown("### 📤 Calling LLM for Hypothesis Refinement...")
                                with st.expander("📋 View Refinement Prompt", expanded=False):
                                    st.code(refinement_prompt, language="markdown")
                                
                                # Call LLM
                                llm_start = time.time()
                                refinement_response = call_llm_with_display(
                                    refinement_prompt, model_name, api_key,
                                    conversation_history=None, cache_name=None
                                )
                                llm_time = round(time.time() - llm_start, 2)
                                log_message(f"REFINEMENT: LLM response in {llm_time}s")
                                
                                with st.expander("📥 View LLM Response", expanded=False):
                                    st.code(refinement_response, language="prolog")
                                
                                # Parse candidates
                                beam_candidates = parse_beam_candidates(refinement_response)
                                if not beam_candidates:
                                    combined_clauses = parse_prolog_clauses(refinement_response)
                                    if combined_clauses:
                                        beam_candidates = ['\n'.join(combined_clauses)]
                                
                                # Evaluate candidates
                                st.markdown(f"**Evaluating {len(beam_candidates)} candidates:**")
                                best_candidate = None
                                best_score = -float('inf')
                                total_pos = len(all_positives)
                                for idx, cand in enumerate(beam_candidates):
                                    # CRITICAL: Strip markdown code block markers that break Prolog
                                    cand_clean = cand
                                    cand_clean = re.sub(r'```\s*prolog\s*\n?', '', cand_clean)
                                    cand_clean = re.sub(r'```\s*\n?', '', cand_clean)
                                    cand_clean = cand_clean.strip()
                                    
                                    cand_result = loop.tester.test_hypothesis(cand_clean)
                                    pos_covered = len(cand_result.covered_pos)
                                    neg_covered = len(cand_result.covered_neg)
                                    
                                    # CRITICAL: Only consider candidates that cover ALL positives
                                    covers_all_pos = pos_covered == total_pos
                                    
                                    # Score: only valid if covers all positives, then minimize negatives
                                    if covers_all_pos:
                                        score = 1000 - neg_covered  # High base score, penalize negatives
                                    else:
                                        score = -1000 + pos_covered  # Invalid - doesn't cover all positives
                                    
                                    # Show candidate details
                                    status_icon = "✅" if covers_all_pos else "❌"
                                    with st.expander(f"📋 Candidate {idx+1}: {pos_covered}/{total_pos} pos, {neg_covered} neg {status_icon}", expanded=False):
                                        st.code(cand, language="prolog")
                                        if not covers_all_pos:
                                            st.error(f"✗ INVALID: Only covers {pos_covered}/{total_pos} positives - REJECTED")
                                        elif neg_covered < combined_neg:
                                            st.success(f"✓ Valid & reduces negatives: {combined_neg} → {neg_covered}")
                                        elif neg_covered == 0:
                                            st.success(f"✓ PERFECT: Covers all positives with 0 negatives!")
                                        else:
                                            st.warning(f"= Valid but no improvement: {neg_covered} negatives")
                                    
                                    # Only update best if this candidate covers all positives
                                    if covers_all_pos and score > best_score:
                                        best_score = score
                                        best_candidate = cand
                                        best_pos = pos_covered
                                        best_neg = neg_covered
                                
                                # Initialize failed hypotheses tracking
                                if not hasattr(st.session_state, 'refinement_failed_hypotheses'):
                                    st.session_state.refinement_failed_hypotheses = []
                                
                                if best_candidate and best_neg < combined_neg:
                                    old_neg = combined_neg
                                    combined_hypothesis = best_candidate
                                    combined_neg = best_neg
                                    combined_result = loop.tester.test_hypothesis(combined_hypothesis)
                                    st.success(f"✅ Improved: {best_pos} pos, {best_neg} neg (was {old_neg})")
                                    if best_neg == 0:
                                        combination_solved = True
                                        # Clear failed hypotheses on success
                                        st.session_state.refinement_failed_hypotheses = []
                                else:
                                    st.warning("No improvement found in this iteration")
                                    # Track this failed hypothesis for feedback (avoid duplicates)
                                    # Normalize hypotheses for comparison (sort clauses, strip whitespace)
                                    def normalize_hyp(h):
                                        clauses = sorted([c.strip() for c in h.strip().split('\n') if c.strip() and ':-' in c])
                                        return '\n'.join(clauses)
                                    
                                    norm_combined = normalize_hyp(combined_hypothesis)
                                    existing_normalized = [normalize_hyp(h[0]) for h in st.session_state.refinement_failed_hypotheses]
                                    
                                    if norm_combined not in existing_normalized:
                                        st.session_state.refinement_failed_hypotheses.append(
                                            (combined_hypothesis, combined_neg, sample_violated[:5])
                                        )
                                        # Keep only last 5 failed attempts
                                        if len(st.session_state.refinement_failed_hypotheses) > 5:
                                            st.session_state.refinement_failed_hypotheses = st.session_state.refinement_failed_hypotheses[-5:]
                                
                                continue  # Skip the normal combination logic
                            
                            # Use pre-computed coverage data
                            for ci in all_clause_coverage:
                                ci['covers_remaining'] = len(ci['covered_pos_set'] & remaining_pos_set)
                                ci['score'] = ci['covers_remaining'] - ci['full_neg']
                            
                            # Get clauses already in partial cover
                            partial_cover_clauses = set(c.strip() for c in combined_hypothesis.split('\n') if c.strip() and ':-' in c)
                            
                            # Auto-add safe clauses (0 neg, cover remaining)
                            safe_to_add = [c for c in all_clause_coverage 
                                           if c['full_neg'] == 0 and c['covers_remaining'] > 0 
                                           and c['clause'] not in partial_cover_clauses]
                            
                            if safe_to_add:
                                safe_to_add.sort(key=lambda x: -x['covers_remaining'])
                                for safe_clause in safe_to_add:
                                    combined_hypothesis += '\n' + safe_clause['clause']
                                    partial_cover_clauses.add(safe_clause['clause'])
                                    remaining_pos_set -= safe_clause['covered_pos_set']
                                    combined_pos += safe_clause['covers_remaining']
                                    st.info(f"Auto-added safe clause: +{safe_clause['covers_remaining']} pos")
                                
                                remaining_pos = list(remaining_pos_set)
                                for ci in all_clause_coverage:
                                    ci['covers_remaining'] = len(ci['covered_pos_set'] & remaining_pos_set)
                                    ci['score'] = ci['covers_remaining'] - ci['full_neg']
                            
                            # If done after safe clauses
                            if len(remaining_pos) == 0:
                                st.success("✅ All examples covered with safe clauses!")
                                
                                # Deduplicate clauses
                                seen_clauses = []
                                seen_set = set()
                                for c in combined_hypothesis.split('\n'):
                                    c = c.strip()
                                    if c and not c.startswith('%'):
                                        if c not in seen_set:
                                            seen_set.add(c)
                                            seen_clauses.append(c)
                                    elif c:
                                        seen_clauses.append(c)
                                combined_hypothesis = "\n".join(seen_clauses)
                                log_message(f"BBSILP: Deduplicated to {len([c for c in seen_clauses if c and not c.startswith('%')])} unique clauses")
                                
                                # ═══ D&C OPTIMIZATION (sampled examples - 10 pos, 10 neg) ═══
                                # Test on sampled examples using exponential distribution
                                if optimization_template:
                                    st.markdown("### 🔧 Divide & Conquer Optimization (sampled)")
                                    original_lits = sum(1 for c in combined_hypothesis.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                                    
                                    try:
                                        opt_start = time.time()
                                        
                                        import numpy as np
                                        sample_size = 10
                                        
                                        pos_list = list(all_positives)
                                        if len(pos_list) > sample_size:
                                            weights = np.exp(-np.arange(len(pos_list)) / (len(pos_list) / 3))
                                            weights = weights / weights.sum()
                                            sampled_pos_idx = np.random.choice(len(pos_list), size=sample_size, replace=False, p=weights)
                                            sampled_pos = [pos_list[i] for i in sampled_pos_idx]
                                        else:
                                            sampled_pos = pos_list
                                        
                                        neg_list = list(all_negatives)
                                        if len(neg_list) > sample_size:
                                            weights = np.exp(-np.arange(len(neg_list)) / (len(neg_list) / 3))
                                            weights = weights / weights.sum()
                                            sampled_neg_idx = np.random.choice(len(neg_list), size=sample_size, replace=False, p=weights)
                                            sampled_neg = [neg_list[i] for i in sampled_neg_idx]
                                        else:
                                            sampled_neg = neg_list
                                        
                                        pos_str = "\n".join([f"pos({p})." for p in sampled_pos])
                                        neg_str = "\n".join([f"neg({n})." for n in sampled_neg])
                                        log_message(f"D&C Optimization: Sampled {len(sampled_pos)} pos, {len(sampled_neg)} neg")
                                        
                                        optimized_hyp, opt_success, _ = divide_and_conquer_optimize(
                                            combined_hypothesis, bk_content, optimization_template,
                                            model_name, api_key, loop.tester,
                                            pos_examples=pos_str, neg_examples=neg_str,
                                            bias_content=bias_content
                                        )
                                        opt_time = round(time.time() - opt_start, 2)
                                        
                                        if opt_success and optimized_hyp:
                                            new_lits = sum(1 for c in optimized_hyp.split('\n') if c.strip() and not c.strip().startswith('%') for _ in c.split(','))
                                            if new_lits < original_lits:
                                                st.success(f"✅ D&C Optimization: {original_lits} → {new_lits} literals ({opt_time}s)")
                                                combined_hypothesis = optimized_hyp
                                            else:
                                                st.info(f"D&C: No improvement ({opt_time}s)")
                                        else:
                                            st.info(f"D&C: Optimization skipped ({opt_time}s)")
                                    except Exception as e:
                                        st.warning(f"D&C optimization error: {e}")
                                        log_message(f"BBSILP D&C error: {e}")
                                
                                st.session_state.solved = True
                                st.session_state.best_hyp = combined_hypothesis
                                loop.save_hypothesis(combined_hypothesis)
                                st.code(combined_hypothesis, language="prolog")
                                st.balloons()
                                combination_solved = True
                            else:
                                # Remove duplicates, sort by score
                                seen_clauses = set()
                                unique_scored = []
                                for c in all_clause_coverage:
                                    if (c['clause'] not in seen_clauses 
                                        and c['clause'] not in partial_cover_clauses
                                        and c['covers_remaining'] > 0):
                                        seen_clauses.add(c['clause'])
                                        unique_scored.append(c)
                                unique_scored.sort(key=lambda x: -x['score'])
                                
                                st.write(f"**{len(unique_scored)} candidate clauses** for {len(remaining_pos)} remaining examples")
                                
                                # Handle case when no candidates found
                                if len(unique_scored) == 0:
                                    st.warning("No candidate clauses cover remaining examples. Need LLM to generate new clauses.")
                                
                                # Get witness examples - 10 random positives and 10 random negatives
                                import random
                                import numpy as np
                                
                                # Sample 10 positive examples using exponential distribution (favor earlier ones)
                                pos_list = list(remaining_pos)
                                if len(pos_list) > 10:
                                    weights = np.exp(-np.arange(len(pos_list)) / (len(pos_list) / 3))
                                    weights = weights / weights.sum()
                                    indices = np.random.choice(len(pos_list), size=min(10, len(pos_list)), replace=False, p=weights)
                                    witness_pos = [pos_list[i] for i in sorted(indices)]
                                else:
                                    witness_pos = pos_list
                                
                                # Sample 10 negative examples from those ENTAILED by current partial covers
                                # This helps LLM avoid the same mistakes
                                # Use combined_result from earlier test (avoid expensive re-test)
                                entailed_neg = list(combined_result.covered_neg) if combined_result.covered_neg else []
                                
                                if entailed_neg:
                                    # Prefer negatives that current rules wrongly cover
                                    if len(entailed_neg) > 10:
                                        witness_neg = random.sample(entailed_neg, 10)
                                    else:
                                        witness_neg = entailed_neg
                                    log_message(f"LLM-Combination: Using {len(witness_neg)} entailed negatives as witnesses")
                                else:
                                    # Fallback to random negatives if no entailed ones
                                    neg_list = list(loop.tester.neg_examples)
                                    if len(neg_list) > 10:
                                        witness_neg = random.sample(neg_list, 10)
                                    else:
                                        witness_neg = neg_list
                                all_neg_examples = [str(n) for n in witness_neg]
                                
                                # Read BK file for grounding
                                bk_content = ""
                                bk_file = os.path.join(task_dir, "bk.pl")
                                if os.path.exists(bk_file):
                                    with open(bk_file, 'r') as bf:
                                        bk_content = bf.read()
                                
                                # Extract ALL grounding facts for an example
                                def get_example_id(ex_str):
                                    import re
                                    # Match any predicate format: p0(id), p1(id,arg2,arg3), etc.
                                    # Extract first argument regardless of number of args
                                    match = re.search(r'\w+\((\w+)', str(ex_str))
                                    return match.group(1) if match else str(ex_str)
                                
                                def extract_full_grounding(bk, ex_id):
                                    """Extract all BK facts containing the example ID"""
                                    facts = []
                                    for line in bk.split('\n'):
                                        line = line.strip()
                                        if line and not line.startswith('%') and ex_id in line:
                                            facts.append(line)
                                    return '\n'.join(facts)
                                
                                def filter_bk_for_grounding(bk, examples, bias_content=""):
                                    """Use same filtering logic as batch_ilp.filter_bk_for_examples"""
                                    import re
                                    # Extract constants from examples
                                    constants = set()
                                    for ex in examples:
                                        inner_matches = re.findall(r'\(([^()]+)\)', str(ex))
                                        for inner in inner_matches:
                                            # Multi-char alphanumeric
                                            alpha_matches = re.findall(r'\b([a-z][a-z0-9_]{1,})\b', inner)
                                            constants.update(alpha_matches)
                                            # State IDs (first arg or large numbers)
                                            args = [a.strip() for a in inner.split(',')]
                                            for i, arg in enumerate(args):
                                                if arg.isdigit():
                                                    if i == 0 or int(arg) > 10:
                                                        constants.add(arg)
                                    
                                    # Parse BK lines
                                    bk_lines = bk.split('\n')
                                    fact_lines = []
                                    for line in bk_lines:
                                        line_stripped = line.strip()
                                        if line_stripped and not line_stripped.startswith('%') and not line_stripped.startswith(':-'):
                                            args_match = re.search(r'\(([^()]+)\)', line)
                                            line_constants = set()
                                            if args_match:
                                                args_str = args_match.group(1)
                                                line_constants.update(re.findall(r'\b([a-z][a-z0-9_]{1,})\b', args_str))
                                                args = [a.strip() for a in args_str.split(',')]
                                                for i, arg in enumerate(args):
                                                    if arg.isdigit():
                                                        if i == 0 or int(arg) > 10:
                                                            line_constants.add(arg)
                                            fact_lines.append((line, line_constants))
                                    
                                    # Match facts by constants (recursive expansion)
                                    alpha_constants = {c for c in constants if not c.isdigit()}
                                    num_constants = {c for c in constants if c.isdigit()}
                                    included = set()
                                    prev_size = -1
                                    for _ in range(5):
                                        if len(alpha_constants) == prev_size:
                                            break
                                        prev_size = len(alpha_constants)
                                        for idx, (line, line_constants) in enumerate(fact_lines):
                                            if idx in included:
                                                continue
                                            line_alphas = {c for c in line_constants if not c.isdigit()}
                                            line_nums = {c for c in line_constants if c.isdigit()}
                                            if (alpha_constants & line_alphas) or (num_constants & line_nums):
                                                included.add(idx)
                                                alpha_constants.update(line_alphas)
                                    
                                    return '\n'.join(fact_lines[idx][0] for idx in sorted(included))
                                
                                # Extract grounding for positive examples using proper filtering
                                pos_grounding = filter_bk_for_grounding(bk_content, witness_pos)
                                
                                # Extract grounding for negative examples
                                neg_grounding = filter_bk_for_grounding(bk_content, all_neg_examples)
                                
                                # Read bias file
                                bias_content = ""
                                bias_file = os.path.join(task_dir, "bias.pl")
                                if os.path.exists(bias_file):
                                    with open(bias_file, 'r') as bf:
                                        bias_lines = [l.strip() for l in bf if l.strip() and not l.startswith('%')]
                                        bias_content = '\n'.join(bias_lines[:20])
                                
                                # Deduplicate combined_hypothesis
                                seen_hyp_clauses = set()
                                dedup_clauses = []
                                for c in combined_hypothesis.split('\n'):
                                    c = c.strip()
                                    if c and ':-' in c and c not in seen_hyp_clauses:
                                        seen_hyp_clauses.add(c)
                                        dedup_clauses.append(c)
                                combined_hypothesis = '\n'.join(dedup_clauses)
                                
                                # Build feedback section if previous candidate failed
                                failure_feedback = ""
                                if hasattr(st.session_state, 'failed_hypothesis') and st.session_state.failed_hypothesis:
                                    failed_hyp = st.session_state.failed_hypothesis
                                    failed_negs = getattr(st.session_state, 'failed_neg_witnesses', [])
                                    failure_feedback = f"""
## ❌ PREVIOUS ATTEMPT FAILED - DO NOT REPEAT THIS MISTAKE:
The following hypothesis was tried but INCORRECTLY covers these negative examples:
```prolog
{failed_hyp}
```

**Violated Negatives (must NOT be covered):**
{', '.join([str(n) for n in failed_negs[:5]])}

**Why it failed:** The clause(s) are too general and match the negative examples above.
**Fix:** Add more constraints to make the clause more specific, or use negation (\\+).

"""
                                    # Get grounding for violated negatives
                                    for neg_ex in failed_negs[:3]:
                                        neg_id = get_example_id(str(neg_ex))
                                        neg_facts = extract_full_grounding(bk_content, neg_id)
                                        if neg_facts:
                                            failure_feedback += f"% VIOLATED {neg_ex} - study this to avoid:\n{neg_facts}\n\n"
                                
                                # Build all batch solutions summary (deduplicated, with full coverage)
                                batch_solutions_summary = ""
                                seen_clauses_for_summary = set()
                                for ci in sorted(all_clause_coverage, key=lambda x: (-x['full_pos'], x['full_neg'])):
                                    if ci['clause'] not in seen_clauses_for_summary:
                                        seen_clauses_for_summary.add(ci['clause'])
                                        status = "[IN PARTIAL]" if ci['clause'] in partial_cover_clauses else ""
                                        batch_solutions_summary += f"{ci['clause']}  %% batch={ci['batch_id']}, {ci['full_pos']}/{len(all_positives)} pos, {ci['full_neg']} neg {status}\n"
                                
                                # Build LLM prompt
                                combination_prompt = f"""# Feedback: Find Rule for Remaining {len(remaining_pos)} Examples
{failure_feedback}
## Current Partial Cover (KEEP):
```prolog
{combined_hypothesis}
```
Covers: {combined_pos}/{len(all_positives)} positives, 0 negatives

## All Discovered Clauses from Batches (with full dataset coverage):
```prolog
{batch_solutions_summary}```

## Bias Constraints (allowed predicates):
```prolog
{bias_content}
```

## Positive Examples to Cover (with full BK grounding):
{', '.join([str(p) for p in witness_pos])}

```prolog
{pos_grounding}
```

## Negative Examples (must NOT cover, with full BK grounding):
{', '.join(all_neg_examples)}

```prolog
{neg_grounding}
```

## Best Candidate Clause (score = remaining_covered - negatives_hit):
"""
                                if unique_scored:
                                    for ci in unique_scored[:1]:
                                        sign = '+' if ci['score'] >= 0 else ''
                                        safe = ' [SAFE]' if ci['full_neg'] == 0 else ''
                                        combination_prompt += f"{ci['clause']}  %% {ci['covers_remaining']}/{len(remaining_pos)} remaining, {ci['full_neg']} neg, score={sign}{ci['score']}{safe}\n"
                                    best_remaining = unique_scored[0]['covers_remaining']
                                    best_neg = unique_scored[0]['full_neg']
                                else:
                                    combination_prompt += "(No existing candidates - need to discover new clause)\n"
                                    best_remaining = 0
                                    best_neg = 0
                                
                                # Get concrete example IDs for Chain-of-Thought
                                cot_neg_example = all_neg_examples[0] if all_neg_examples else "negX"
                                cot_pos_example1 = witness_pos[0] if len(witness_pos) > 0 else "posX"
                                cot_pos_example2 = witness_pos[1] if len(witness_pos) > 1 else "posY"
                                
                                combination_prompt += f"""
## Task: Logic Theory Refinement
The goal is to refine the "Best Candidate" so it covers the remaining {len(remaining_pos)} positives while maintaining 0 negative coverage.

### Logical Analysis Steps (Chain of Thought):
1. **Trace:** Manually trace the Best Candidate against Negative `{cot_neg_example}`. At which literal does the match fail? If it doesn't fail, that is the literal you must specialize.
2. **Shared Features:** Look at Positives `{cot_pos_example1}` and `{cot_pos_example2}`. List all predicates shared by their B and C variables.
3. **Discriminators:** Find a predicate `pX` that exists in all Positives but is missing in the Violated Negatives.

### Constraints:
- Every variable must be linked back to 'A'.
- Do not use predicates outside the Bias Constraints.
- Use `\\+` only if a simple positive literal cannot distinguish the sets.

### Why the Best Candidate Fails:
- It covers {best_neg} negatives because it's TOO GENERAL (missing a distinguishing constraint)
- OR it misses positives because it's TOO SPECIFIC (has an unnecessary constraint)

BEAM SEARCH: Generate 5 DIFFERENT REPAIRS, separated by "---CANDIDATE---":
- Candidate 1: ADD CONSTRAINT - Add 1-2 literals to exclude the negatives (find what's TRUE for positives but FALSE for negatives)
- Candidate 2: REMOVE CONSTRAINT - Remove a literal to cover more positives (if it won't hit negatives)
- Candidate 3: REPLACE PREDICATE - Swap a predicate for a more/less specific one from BK
- Candidate 4: ADD NEGATION - Use \\+ to explicitly exclude negative patterns you observed
- Candidate 5: ALTERNATIVE STRUCTURE - Different clause structure covering the same positives

Output COMPLETE hypothesis (partial cover + new clause) for each candidate:
```prolog
{combined_hypothesis}
f(A) :- <more_specific_clause>.
```
---CANDIDATE---
```prolog
{combined_hypothesis}
f(A) :- <more_general_clause>.
```
---CANDIDATE---
```prolog
{combined_hypothesis}
f(A) :- <specialized_clause>.
```
---CANDIDATE---
```prolog
{combined_hypothesis}
f(A) :- <generalized_clause>.
```
---CANDIDATE---
```prolog
{combined_hypothesis}
f(A) :- <alternative_clause>.
```
"""
                                
                                st.markdown("### 📤 Finding Smallest Rule for Remaining Examples...")
                                
                                # Show the prompt being sent to LLM
                                with st.expander("📋 View LLM Prompt", expanded=False):
                                    st.code(combination_prompt, language="markdown")
                                
                                # Call LLM
                                llm_start = time.time()
                                combination_response = call_llm_with_display(
                                    combination_prompt, model_name, api_key,
                                    conversation_history=None, cache_name=None
                                )
                                llm_time = round(time.time() - llm_start, 2)
                                log_message(f"COMBINATION: LLM response in {llm_time}s")
                                
                                # Show raw LLM response
                                with st.expander("📥 View LLM Response (Raw)", expanded=False):
                                    st.code(combination_response, language="prolog")
                                
                                # BEAM SEARCH: Parse multiple candidates from response
                                beam_candidates = parse_beam_candidates(combination_response)
                                
                                if not beam_candidates:
                                    # Fallback to single parse
                                    combined_clauses = parse_prolog_clauses(combination_response)
                                    if combined_clauses:
                                        beam_candidates = ['\n'.join(combined_clauses)]
                                
                                if beam_candidates:
                                    st.write(f"🔍 **Beam Search:** {len(beam_candidates)} candidates generated")
                                    
                                    # Evaluate each candidate
                                    candidate_results = []
                                    for cidx, cand_text in enumerate(beam_candidates):
                                        cand_clauses = parse_prolog_clauses(cand_text)
                                        if not cand_clauses:
                                            continue
                                        
                                        cand_hyp = '\n'.join(cand_clauses)
                                        try:
                                            cand_result = loop.tester.test_hypothesis(cand_hyp)
                                            cand_pos = len(cand_result.covered_pos)
                                            cand_neg = len(cand_result.covered_neg)
                                            cand_missed = len(cand_result.missed_pos)
                                            # Store covered negatives for feedback
                                            covered_negs = list(cand_result.covered_neg)[:5]  # Keep up to 5 witnesses
                                            score = cand_pos - (cand_neg * 10) if cand_neg > 0 else cand_pos + 1000
                                            
                                            candidate_results.append({
                                                'idx': cidx + 1,
                                                'hypothesis': cand_hyp,
                                                'pos': cand_pos,
                                                'neg': cand_neg,
                                                'missed': cand_missed,
                                                'score': score,
                                                'covered_negs': covered_negs  # Store for feedback
                                            })
                                            log_message(f"BEAM candidate {cidx+1}: pos={cand_pos}, neg={cand_neg}, missed={cand_missed}, score={score}")
                                        except Exception as e:
                                            log_message(f"BEAM candidate {cidx+1} failed: {e}")
                                    
                                    # Show beam results
                                    if candidate_results:
                                        with st.expander(f"🔍 Beam Search: {len(candidate_results)} candidates evaluated", expanded=True):
                                            for cr in sorted(candidate_results, key=lambda x: -x['score']):
                                                marker = "✅ BEST" if cr['score'] == max(c['score'] for c in candidate_results) else ""
                                                st.write(f"Candidate {cr['idx']}: {cr['pos']}/{len(all_positives)} pos, {cr['neg']} neg, {cr['missed']} missed {marker}")
                                        
                                        # Select best candidate
                                        best = max(candidate_results, key=lambda x: x['score'])
                                        new_combined = best['hypothesis']
                                        new_pos = best['pos']
                                        new_neg = best['neg']
                                        new_missed = best['missed']
                                        
                                        st.markdown("### Best Candidate:")
                                        st.code(new_combined, language="prolog")
                                        
                                        col1, col2, col3 = st.columns(3)
                                        with col1:
                                            st.metric("Positives", f"{new_pos}/{len(all_positives)}")
                                        with col2:
                                            st.metric("Negatives", new_neg)
                                        with col3:
                                            st.metric("Missed", new_missed)
                                        
                                        if new_missed == 0 and new_neg == 0:
                                            st.success("✅ LLM-guided combination found complete solution!")
                                            # Deduplicate clauses before saving
                                            seen_final = set()
                                            dedup_final = []
                                            for c in new_combined.split('\n'):
                                                c = c.strip()
                                                if c and ':-' in c and c not in seen_final:
                                                    seen_final.add(c)
                                                    dedup_final.append(c)
                                            new_combined = '\n'.join(dedup_final)
                                            st.session_state.solved = True
                                            st.session_state.best_hyp = new_combined
                                            loop.save_hypothesis(new_combined)
                                            st.balloons()
                                            combination_solved = True
                                        elif new_neg == 0 and new_pos > combined_pos:
                                            st.info(f"✅ Improved: {combined_pos} → {new_pos} positives (0 neg)")
                                            combined_hypothesis = new_combined
                                            combined_pos = new_pos
                                            combined_neg = new_neg
                                            combined_missed = new_missed
                                            remaining_pos = list(loop.tester.test_hypothesis(new_combined).missed_pos)
                                            remaining_pos_set = set(remaining_pos)
                                            # Clear any previous failure feedback
                                            if 'failed_hypothesis' in st.session_state:
                                                del st.session_state.failed_hypothesis
                                        elif new_neg > 0:
                                            st.warning(f"❌ Candidate hits {new_neg} negatives - need refinement")
                                            # Store failed hypothesis and negative witnesses for next iteration feedback
                                            neg_witnesses = best.get('covered_negs', [])
                                            st.session_state.failed_hypothesis = new_combined
                                            st.session_state.failed_neg_witnesses = neg_witnesses
                                            # Show the violated negatives
                                            if neg_witnesses:
                                                st.error(f"**Violated negatives:** {', '.join([str(n) for n in neg_witnesses[:5]])}")
                                                # Get grounding for violated negatives
                                                violated_grounding = ""
                                                for neg_ex in neg_witnesses[:3]:
                                                    neg_id = get_example_id(str(neg_ex))
                                                    neg_facts = extract_full_grounding(bk_content, neg_id)
                                                    if neg_facts:
                                                        violated_grounding += f"% VIOLATED {neg_ex}:\n{neg_facts}\n\n"
                                                if violated_grounding:
                                                    with st.expander("🚫 Violated Negative Examples (BK)", expanded=False):
                                                        st.code(violated_grounding, language="prolog")
                                        # Save iteration metrics
                                        combination_iterations.append({
                                            "iteration": combination_iter + 1,
                                            "remaining_pos_before": len(remaining_pos),
                                            "llm_time_seconds": llm_time,
                                            "candidates_evaluated": len(candidate_results),
                                            "best_candidate": {
                                                "hypothesis": best['hypothesis'],
                                                "covered_pos": best['pos'],
                                                "covered_neg": best['neg'],
                                                "missed_pos": best['missed'],
                                                "score": best['score']
                                            },
                                            "solved": combination_solved
                                        })
                                    else:
                                        st.warning("No valid candidates from beam search")
                                else:
                                    st.warning("LLM did not return valid Prolog clauses")
                                    
                        except Exception as e:
                            st.error(f"Combination error: {e}")
                            log_message(f"COMBINATION error: {e}")
            else:
                st.warning("No generalizable hypothesis found from batches.")
            
            # ═══ REFINEMENT FOR TOO-GENERAL HYPOTHESIS ═══
            # If we have batch hypotheses that cover all positives but some negatives,
            # use feedback loop with sampled examples to refine
            if batch_hypotheses and not st.session_state.get('solved'):
                # Combine all unique clauses from batch hypotheses
                all_clauses = set()
                for bh in batch_hypotheses:
                    for clause in bh['hypothesis'].split('\n'):
                        clause = clause.strip()
                        if clause and ':-' in clause and not clause.startswith('%'):
                            all_clauses.add(clause)
                
                if all_clauses:
                    combined_all = '\n'.join(all_clauses)
                    final_result = loop.tester.test_hypothesis(combined_all)
                    final_pos = len(final_result.covered_pos)
                    final_neg = len(final_result.covered_neg)
                    final_missed = len(final_result.missed_pos)
                    
                    # Check if hypothesis covers ALL positives but SOME negatives (too general)
                    # DISABLED: Skip refinement step - let combination phase handle it
                    if False and final_pos == len(all_positives) and final_neg > 0 and final_missed == 0:
                        st.markdown("### 🔧 Refining Too-General Hypothesis")
                        st.warning(f"Hypothesis covers all {final_pos} positives but {final_neg} negatives - needs refinement")
                        log_message(f"BBSILP: Too-general hypothesis detected: {final_pos} pos, {final_neg} neg, {final_missed} missed")
                        
                        # Sample negatives (violated) and positives for feedback
                        import numpy as np
                        sample_size = 10
                        max_refinement_iters = 10
                        
                        current_hypothesis = combined_all
                        
                        for refine_iter in range(max_refinement_iters):
                            st.markdown(f"#### Refinement Iteration {refine_iter + 1}/{max_refinement_iters}")
                            
                            # Test current hypothesis
                            refine_result = loop.tester.test_hypothesis(current_hypothesis)
                            refine_neg = len(refine_result.covered_neg)
                            refine_pos = len(refine_result.covered_pos)
                            refine_missed = len(refine_result.missed_pos)
                            
                            if refine_neg == 0 and refine_missed == 0:
                                st.success(f"✅ Refinement successful! Covers {refine_pos} positives, 0 negatives")
                                st.session_state.solved = True
                                st.session_state.best_hyp = current_hypothesis
                                loop.save_hypothesis(current_hypothesis)
                                st.balloons()
                                break
                            
                            if refine_neg == 0:
                                st.info(f"No negatives covered, but {refine_missed} positives missed")
                                break
                            
                            # Sample from covered negatives (violated)
                            neg_list = list(refine_result.covered_neg)
                            if len(neg_list) > sample_size:
                                weights = np.exp(-np.arange(len(neg_list)) / (len(neg_list) / 3))
                                weights = weights / weights.sum()
                                sampled_neg_idx = np.random.choice(len(neg_list), size=sample_size, replace=False, p=weights)
                                sampled_neg = [neg_list[i] for i in sampled_neg_idx]
                            else:
                                sampled_neg = neg_list
                            
                            # Sample from covered positives
                            pos_list = list(refine_result.covered_pos)
                            if len(pos_list) > sample_size:
                                weights = np.exp(-np.arange(len(pos_list)) / (len(pos_list) / 3))
                                weights = weights / weights.sum()
                                sampled_pos_idx = np.random.choice(len(pos_list), size=sample_size, replace=False, p=weights)
                                sampled_pos = [pos_list[i] for i in sampled_pos_idx]
                            else:
                                sampled_pos = pos_list
                            
                            st.write(f"Sampled {len(sampled_pos)} positives, {len(sampled_neg)} violated negatives")
                            
                            # Helper to extract example ID
                            def get_example_id(ex_str):
                                match = re.search(r'\w+\((\w+)\)', str(ex_str))
                                return match.group(1) if match else str(ex_str)
                            
                            # Filter BK for sampled examples
                            sampled_ids = set()
                            for ex in sampled_pos + sampled_neg:
                                ex_id = get_example_id(str(ex))
                                if ex_id:
                                    sampled_ids.add(ex_id)
                            
                            filtered_bk_lines = []
                            for line in bk_content.split('\n'):
                                line_stripped = line.strip()
                                if not line_stripped or line_stripped.startswith('%'):
                                    continue
                                for ex_id in sampled_ids:
                                    if re.search(rf'\b{re.escape(ex_id)}\b', line_stripped):
                                        filtered_bk_lines.append(line_stripped)
                                        break
                            filtered_bk = '\n'.join(filtered_bk_lines[:500])  # Limit BK size
                            
                            # Build TOO_GENERAL feedback
                            neg_witnesses_str = '\n'.join([f"neg({n})." for n in sampled_neg])
                            pos_examples_str = '\n'.join([f"pos({p})." for p in sampled_pos])
                            
                            feedback_prompt = f"""SYSTEM FEEDBACK: HYPOTHESIS TOO GENERAL (Covers Negatives)

## CURRENT HYPOTHESIS (covers {refine_neg} negatives - MUST FIX)
```prolog
{current_hypothesis}
```

## VIOLATED NEGATIVE EXAMPLES (hypothesis wrongly covers these)
```prolog
{neg_witnesses_str}
```

## POSITIVE EXAMPLES (must still cover these)
```prolog
{pos_examples_str}
```

## BACKGROUND KNOWLEDGE (filtered for relevant examples)
```prolog
{filtered_bk}
```

## TASK
The hypothesis above is TOO GENERAL - it covers negative examples.
You must ADD CONSTRAINTS or REFINE the clauses to EXCLUDE the negatives while still covering positives.

Generate a refined hypothesis that:
1. Covers ALL positive examples
2. Covers ZERO negative examples
3. Uses only predicates from the background knowledge

Output your refined hypothesis in a ```prolog code block."""

                            # Call LLM
                            try:
                                llm_start = time.time()
                                response_text = call_llm_with_display(
                                    feedback_prompt,
                                    model_name,
                                    api_key,
                                    conversation_history=None,
                                    cache_name=None
                                )
                                llm_time = round(time.time() - llm_start, 2)
                                
                                # Parse prolog code block
                                import re
                                code_match = re.search(r'```(?:prolog)?\s*(.*?)```', response_text, re.DOTALL)
                                if code_match:
                                    new_hypothesis = code_match.group(1).strip()
                                    
                                    # Clean and validate
                                    valid_clauses = []
                                    for line in new_hypothesis.split('\n'):
                                        line = line.strip()
                                        if line and ':-' in line and not line.startswith('%'):
                                            valid_clauses.append(line)
                                    
                                    if valid_clauses:
                                        new_hypothesis = '\n'.join(valid_clauses)
                                        st.code(new_hypothesis, language="prolog")
                                        
                                        # Test new hypothesis
                                        new_result = loop.tester.test_hypothesis(new_hypothesis)
                                        new_pos = len(new_result.covered_pos)
                                        new_neg = len(new_result.covered_neg)
                                        new_missed = len(new_result.missed_pos)
                                        
                                        col1, col2, col3 = st.columns(3)
                                        with col1:
                                            st.metric("Positives", f"{new_pos}/{len(all_positives)}")
                                        with col2:
                                            st.metric("Negatives", new_neg)
                                        with col3:
                                            st.metric("Missed", new_missed)
                                        
                                        # Update current hypothesis if improved
                                        if new_neg < refine_neg or (new_neg == refine_neg and new_pos > refine_pos):
                                            current_hypothesis = new_hypothesis
                                            st.info(f"Improved: {refine_neg} → {new_neg} negatives ({llm_time}s)")
                                        else:
                                            st.warning(f"No improvement ({llm_time}s)")
                                    else:
                                        st.warning("LLM returned no valid clauses")
                                else:
                                    st.warning("LLM response missing code block")
                                    
                            except Exception as e:
                                st.error(f"Refinement error: {e}")
                                log_message(f"BBSILP refinement error: {e}")
                                break
            
            # ═══ SAVE FINAL CONSOLIDATED METRICS ═══
            bbsilp_all_metrics["summary"]["elapsed_time_seconds"] = round(time.time() - bbsilp_start_time, 2)
            bbsilp_all_metrics["summary"]["final_status"] = "solved" if st.session_state.get('solved') else "partial"
            bbsilp_all_metrics["completed_at"] = datetime.now().isoformat()
            if st.session_state.get('best_hyp'):
                bbsilp_all_metrics["final_hypothesis"] = st.session_state.best_hyp
            # Save LLM-Guided Hypothesis Combination iterations if any
            if 'combination_iterations' in dir() and combination_iterations:
                bbsilp_all_metrics["combination_iterations"] = combination_iterations
                bbsilp_all_metrics["summary"]["combination_total_iterations"] = len(combination_iterations)
                bbsilp_all_metrics["summary"]["combination_total_llm_time"] = round(sum(ci.get("llm_time_seconds", 0) for ci in combination_iterations), 2)
            bbsilp_metrics_path = os.path.join(task_dir, "bbsilp_metrics.json")
            with open(bbsilp_metrics_path, 'w', encoding='utf-8') as f:
                json.dump(bbsilp_all_metrics, f, indent=2)
            log_message(f"BBSILP: Saved final consolidated metrics to {bbsilp_metrics_path}")
            st.success(f"📊 Metrics saved to `bbsilp_metrics.json`")
            
            st.stop()
        
        # Run the Loop (FULL_CONTEXT mode only)
        for i in range(int(max_iters)):
            log_message(f"Starting iteration {i+1}/{max_iters}")
            
            # Initialize iteration metrics
            iter_metrics = {
                "iteration": i + 1,
                "hypothesis": None,
                "llm_time_seconds": 0,
                "prolog_test_time_seconds": 0,
                "subsumption_check_time_seconds": 0,
                "subsumption_pruned": False,
                "prolog_test_run": False,
                "candidates_evaluated": 0,
                "result": None,
                "covered_pos": 0,
                "covered_neg": 0,
                "missed_pos": 0,
                "is_complete": False
            }
            iter_start_time = time.time()
            
            # Update real-time status at start of each iteration
            with realtime_status.container():
                st.info(f"🔄 Iteration {i+1} in progress...")
                m = st.session_state.metrics
                st.write(f"**Prolog Tests:** {m['total_prolog_tests']} | **Subsumption:** {m['total_subsumption_checks']}")
            
            # 1. Build prompt and call Gemini
            with st.chat_message("assistant"):
                st.write(f"**Iteration {i+1}** - Generating hypothesis...")
                
                # First iteration OR restart with filtered data: send files for analysis
                if i == 0 or restart_with_filtered_data:
                    task_header = ""
                    # Reset flag after using it - UPDATE SESSION STATE
                    if restart_with_filtered_data:
                        restart_with_filtered_data = False
                        pcs["restart_with_filtered_data"] = False
                        partial_cover_round = pcs["partial_cover_round"]  # Use updated value from session
                        # Clear conversation history for fresh start with filtered task
                        st.session_state.conversation_history = []
                        # Clear failed hypotheses for new sub-task
                        failed_hypotheses = []
                        log_message(f"PARTIAL COVER RESTART: Round {partial_cover_round}, {len(remaining_positives)} positives remaining")
                        
                        # Build detailed clause info with per-clause stats
                        clause_details = []
                        for pc in preserved_good_clauses:
                            clause_details.append(f"{pc['clause']}  % covers {pc['covered_count']} positives")
                        
                        task_header = f"""# ILP Task - PARTIAL COVER ROUND {partial_cover_round}

## CONTEXT
We have found {len(preserved_good_clauses)} partial solution clause(s) that cover {len(covered_positives_global)}/{len(all_positives)} positives with 0 negatives.

**LOCKED CLAUSES (already found):**
```prolog
{chr(10).join(clause_details)}
```

**YOUR TASK:** Find ONE clause for the remaining {len(remaining_positives)} uncovered positives.
- Must cover SOME of the remaining positives
- Must cover ZERO negatives
"""
                    else:
                        # First iteration - clear conversation history for fresh start
                        st.session_state.conversation_history = []
                        failed_hypotheses = []
                        log_message("FRESH START: Cleared conversation history, sending full task data")
                    
                    # First iteration: use init_prompt template (one-shot)
                    if init_prompt_template:
                        # Parse examples into positive and negative (use sampled for LLM)
                        pos_examples = []
                        neg_examples = []
                        for line in working_exs_content_for_prompt.split('\n'):
                            line = line.strip()
                            if line.startswith('pos(') and line.endswith(').'):
                                pos_examples.append(line)
                            elif line.startswith('neg(') and line.endswith(').'):
                                neg_examples.append(line)
                        
                        # Use actual bias content from bias.pl
                        bias_hints_content = bias_content if bias_content else "% See constraints above"
                        contrast_pair = ""
                        if len(all_positives) > 50 and len(all_negatives) > 50:
                            try:
                                
                                # LARGE DATASET: Add contrast pair (full facts for 1 pos + 1 neg)
                                sample_pos = list(all_positives)[0]
                                sample_neg = list(all_negatives)[0]
                                pos_evidence = extract_evidence(sample_pos, working_bk_content)
                                neg_evidence = extract_evidence(sample_neg, working_bk_content)
                                
                                if pos_evidence and neg_evidence and len(pos_evidence) > 50:
                                    # Load problem description from file if available (for trains tasks)
                                    problem_hint = ""
                                    if 'has_car' in working_bk_content and 'has_load' in working_bk_content:
                                        # Try to load from trains_problem_description.txt
                                        desc_file = os.path.join(os.path.dirname(__file__), "trains_problem_description.txt")
                                        if os.path.exists(desc_file):
                                            try:
                                                with open(desc_file, 'r', encoding='utf-8') as f:
                                                    problem_hint = "% " + f.read().replace('\n', '\n% ')
                                                log_message(f"Loaded problem description from {desc_file}")
                                            except Exception as e:
                                                log_message(f"Could not load problem description: {e}")
                                    contrast_pair = f"""
% ============ CONTRAST PAIR (study this to find the pattern) ============
{problem_hint}
% POSITIVE EXAMPLE: {sample_pos}
{pos_evidence[:2000]}

% NEGATIVE EXAMPLE: {sample_neg}
{neg_evidence[:2000]}
% ========================================================================
"""
                                    log_message(f"Added contrast pair for large dataset")
                            except Exception as e:
                                log_message(f"Warning: Could not compute discriminative predicates: {e}")
                        
                        # Include contrast pair in BK section for large datasets
                        bk_with_contrast = working_bk_content_for_prompt
                        if contrast_pair:
                            bk_with_contrast = working_bk_content_for_prompt + "\n" + contrast_pair
                        
                        base_prompt = init_prompt_template.format(
                            positive_examples='\n'.join(pos_examples) if pos_examples else working_exs_content_for_prompt,
                            negative_examples='\n'.join(neg_examples) if neg_examples else "% No negative examples",
                            background_knowledge=bk_with_contrast,
                            bias_hints=bias_hints_content
                        )
                    elif context_cache:
                        # Fallback: cache available
                        base_prompt = f"""You are an ILP solver. Task data is in your context (cached).

%%% BIAS HINTS %%%
% See constraints above

Generate a Prolog hypothesis that covers ALL positives and ZERO negatives.

**CRITICAL SYNTAX:**
- Each clause on ONE LINE: `head(X) :- body1(X), body2(X).`
- End every clause with a period.

```prolog
your_hypothesis_here.
```
"""
                    else:
                        # Fallback: no cache, no template
                        base_prompt = f"""You are an ILP solver.

### Positive Examples
```prolog
{working_exs_content_for_prompt}
```

### Background Knowledge
```prolog
{working_bk_content_for_prompt}
```

%%% BIAS HINTS %%%
% See constraints above

Generate a Prolog hypothesis that covers ALL positives and ZERO negatives.

**CRITICAL SYNTAX:**
- Each clause on ONE LINE: `head(X) :- body1(X), body2(X).`
- End every clause with a period.

```prolog
your_hypothesis_here.
```
"""
                    
                    # Prepend task header if it exists (for Partial Cover rounds)
                    if task_header:
                        log_message(f"PREPENDING TASK HEADER to Prompt: {len(task_header)} chars")
                        base_prompt = task_header + "\n\n" + base_prompt
                else:
                    # Subsequent iterations: use universal feedback prompt
                    last_hyp = failed_hypotheses[-1][0] if failed_hypotheses else "N/A"
                    
                    # Build partial cover stats for feedback
                    partial_cover_stats = None
                    if preserved_good_clauses and len(preserved_good_clauses) > 0:
                        partial_cover_stats = {
                            'covered_pos': len(covered_positives_global),
                            'total_pos': len(all_positives),
                            'remaining_pos': len(remaining_positives) if isinstance(remaining_positives, set) else len(all_positives) - len(covered_positives_global)
                        }
                    
                    # Use universal get_feedback_prompt function (lazy loading of evidence)
                    # Guard: If result is None (e.g., empty response on previous iteration), use init prompt instead
                    if result is None:
                        log_message("No previous result available - using init prompt for this iteration")
                        base_prompt = f"""Previous iteration returned no valid hypothesis. Please try again.

%%% BIAS HINTS %%%
% See constraints above

Generate a Prolog hypothesis that covers ALL positives and ZERO negatives.

**CRITICAL SYNTAX:**
- Each clause on ONE LINE: `head(X) :- body1(X), body2(X).`
- End every clause with a period.

```prolog
your_hypothesis_here.
```
"""
                    else:
                        base_prompt = get_feedback_prompt(
                            previous_code=last_hyp,
                            result=result,
                            bk_text=working_bk_content,
                            feedback_templates=feedback_templates,
                            partial_cover_clauses=preserved_good_clauses if preserved_good_clauses else None,
                            partial_cover_stats=partial_cover_stats,
                            full_positives_count=len(all_positives),
                            total_negatives_count=len(all_negatives)
                        )
                
                # Add user hints
                if user_hint:
                    base_prompt += f"\n\nUSER HINTS:\n{user_hint}\n"
                
                # Show the full prompt sent to LLM
                with st.expander(f"📤 Prompt sent to LLM ({len(base_prompt)} chars)", expanded=False):
                    st.code(base_prompt, language="markdown")
                
                # Call LLM - either Cascade (file-based) or LLM API
                try:
                    llm_start_time = time.time()
                    if use_cascade_mode:
                        full_response = call_cascade_with_display(base_prompt, task_dir)
                    else:
                        full_response = call_llm_with_display(
                            base_prompt, 
                            model_name, 
                            api_key,
                            conversation_history=st.session_state.conversation_history,
                            cache_name=None  # Cache handled via cached_model
                        )
                    iter_metrics["llm_time_seconds"] = round(time.time() - llm_start_time, 3)
                    
                    # Add this exchange to conversation history (automatic context like Windsurf)
                    st.session_state.conversation_history.append({
                        "role": "user",
                        "parts": [{"text": base_prompt}]
                    })
                    st.session_state.conversation_history.append({
                        "role": "model",
                        "parts": [{"text": full_response}]
                    })
                    
                    # DEBUG LOG: Capture prompt and response for Cascade analysis
                    st.session_state.debug_log.append({
                        "iteration": i + 1,
                        "type": "llm_call",
                        "prompt_sent": base_prompt,
                        "response_received": full_response,
                        "llm_time": iter_metrics["llm_time_seconds"]
                    })
                        
                except Exception as e:
                    st.error(f"LLM API error: {e}")
                    break
                
                # BEAM SEARCH: Parse multiple candidates from response
                beam_candidates = parse_beam_candidates(full_response)
                
                if not beam_candidates:
                    st.session_state.messages.append({
                        "role": "assistant", 
                        "content": f"Iteration {i+1}: No code generated"
                    })
                    
                    # Save iteration metrics even when no candidates parsed
                    iter_metrics["result"] = "no_code_generated"
                    iter_metrics["llm_time_seconds"] = round(time.time() - iter_start_time, 3)
                    st.session_state.metrics["iterations"].append(iter_metrics)
                    st.session_state.metrics["total_iterations"] = i + 1
                    continue
                
                # Evaluate each beam candidate and pick the best
                best_candidate = None
                best_score = -float('inf')
                candidate_results = []
                
                log_message(f"BEAM SEARCH: Evaluating {len(beam_candidates)} candidates")
                
                for cidx, candidate_text in enumerate(beam_candidates):
                    # Parse clauses from this candidate
                    candidate_clauses = parse_prolog_clauses(candidate_text)
                    if not candidate_clauses:
                        continue
                    
                    # BIAS VALIDATION: Disabled - accept all predicates from BK
                    # if bias_content:
                    #     original_count = len(candidate_clauses)
                    #     candidate_clauses = filter_valid_clauses(candidate_clauses, bias_content, log_message)
                    #     if len(candidate_clauses) < original_count:
                    #         log_message(f"BIAS VALIDATION: Filtered {original_count - len(candidate_clauses)} invalid clauses from candidate {cidx+1}")
                    if False:
                            log_message(f"BEAM candidate {cidx+1} skipped (all clauses had undefined predicates)")
                            continue
                    
                    # NAF PREFERENCE: Try non-NAF solutions first unless NAF is enabled
                    allow_naf = st.session_state.naf_state.get("allow_naf", False)
                    non_naf_clauses, naf_clauses = filter_naf_clauses(candidate_clauses, allow_naf, log_message)
                    
                    if naf_clauses and not allow_naf:
                        # Store deferred NAF clauses for potential later use
                        st.session_state.naf_state["deferred_naf_clauses"].extend(naf_clauses)
                    
                    if non_naf_clauses:
                        candidate_clauses = non_naf_clauses
                    elif allow_naf:
                        candidate_clauses = candidate_clauses  # Use all including NAF
                    else:
                        # No non-NAF clauses and NAF not allowed yet
                        log_message(f"BEAM candidate {cidx+1} skipped (only NAF clauses, NAF not yet enabled)")
                        continue
                    
                    # Limit clauses per candidate
                    max_clauses = 4
                    if len(candidate_clauses) > max_clauses:
                        candidate_clauses = candidate_clauses[:max_clauses]
                    
                    candidate_hyp = "\n".join(candidate_clauses)
                    hyp_oneline = candidate_hyp.replace('\n', ' ').strip()
                    
                    # Skip if cycle detected
                    is_cycle = False
                    for failed_hyp, _ in failed_hypotheses:
                        if hyp_oneline == failed_hyp.replace('\n', ' ').strip():
                            is_cycle = True
                            break
                    
                    if is_cycle:
                        log_message(f"BEAM candidate {cidx+1} skipped (cycle)")
                        continue
                    
                    # Quick test this candidate
                    try:
                        cand_result = loop.tester.test_hypothesis(candidate_hyp)
                        st.session_state.metrics["total_prolog_tests"] += 1
                        
                        # In partial cover mode, only count coverage of REMAINING positives
                        if preserved_good_clauses and isinstance(remaining_positives, set) and len(remaining_positives) < len(all_positives):
                            # Normalize to match all_positives format (no whitespace)
                            normalized_cand_pos = {re.sub(r'\s+', '', ex) for ex in cand_result.covered_pos}
                            pos_covered = len(normalized_cand_pos & remaining_positives)
                            total_target_pos = len(remaining_positives)
                        else:
                            pos_covered = len(cand_result.covered_pos)
                            total_target_pos = len(all_positives) if all_positives else pos_covered
                        
                        neg_covered = len(cand_result.covered_neg)
                        
                        # ENHANCED SCORING: F1-based with strong negative penalty
                        # Priority 1: Zero negatives is critical
                        # Priority 2: Maximize positive coverage
                        if neg_covered == 0:
                            # Perfect precision - reward based on recall
                            if pos_covered > 0:
                                recall = pos_covered / max(total_target_pos, 1)
                                # High score for partial covers with 0 negatives
                                score = 100 + int(recall * 100)  # 100-200 range
                            else:
                                score = 0  # Covers nothing
                        else:
                            # Has false positives - penalize heavily
                            precision = pos_covered / max(pos_covered + neg_covered, 1)
                            recall = pos_covered / max(total_target_pos, 1)
                            if precision + recall > 0:
                                f1 = 2 * precision * recall / (precision + recall)
                            else:
                                f1 = 0
                            # Negative score for imperfect precision, scaled by F1
                            score = int(f1 * 50) - neg_covered  # -inf to 50 range
                        
                        candidate_results.append({
                            "idx": cidx + 1,
                            "hypothesis": candidate_hyp,
                            "pos": pos_covered,
                            "neg": neg_covered,
                            "score": score,
                            "result": cand_result,
                            "total_target_pos": total_target_pos
                        })
                        
                        log_message(f"BEAM candidate {cidx+1}: pos={pos_covered}, neg={neg_covered}, score={score}")
                        
                        if score > best_score:
                            best_score = score
                            best_candidate = candidate_results[-1]
                    except Exception as e:
                        log_message(f"BEAM candidate {cidx+1} failed: {e}")
                        continue
                
                # Show beam search results
                if len(candidate_results) > 1:
                    with st.expander(f"🔍 Beam Search: {len(candidate_results)} candidates evaluated", expanded=False):
                        for cr in candidate_results:
                            marker = "✅ BEST" if cr == best_candidate else ""
                            cand_res = cr.get("result")
                            if cand_res:
                                if cr['neg'] > 0 and len(cand_res.missed_pos) > 0:
                                    status = "❌ TOO GENERAL & TOO SPECIFIC"
                                elif cr['neg'] > 0:
                                    status = "🔴 TOO GENERAL"
                                elif len(cand_res.missed_pos) > 0:
                                    status = "🟡 TOO SPECIFIC"
                                else:
                                    status = "✅ COMPLETE"
                            else:
                                status = "⚪ NO RESULT"
                            st.write(f"**Candidate {cr['idx']}** {marker}: pos={cr['pos']}/{cr['total_target_pos']}, neg={cr['neg']}, score={cr['score']} - {status}")
                            st.code(cr['hypothesis'], language="prolog")
                
                # Use best candidate
                if not best_candidate:
                    st.session_state.messages.append({
                        "role": "assistant", 
                        "content": f"Iteration {i+1}: All candidates failed"
                    })
                    
                    # Save iteration metrics even for failed iterations
                    iter_metrics["result"] = "no_candidates"
                    iter_metrics["llm_time_seconds"] = round(time.time() - iter_start_time, 3)
                    st.session_state.metrics["iterations"].append(iter_metrics)
                    st.session_state.metrics["total_iterations"] = i + 1
                    
                    # NAF ESCALATION: Track failed iterations without NAF
                    if not st.session_state.naf_state.get("allow_naf", False):
                        st.session_state.naf_state["iterations_without_naf"] += 1
                        threshold = st.session_state.naf_state.get("naf_threshold", 5)
                        failed_count = st.session_state.naf_state["iterations_without_naf"]
                        
                        # Check if we should enable NAF now
                        if failed_count >= threshold:
                            st.session_state.naf_state["allow_naf"] = True
                            deferred = st.session_state.naf_state.get("deferred_naf_clauses", [])
                            log_message(f"🔓 NAF ENABLED: {failed_count} iterations failed without NAF. Now allowing negation as failure.")
                            if deferred:
                                log_message(f"📋 {len(deferred)} deferred NAF clauses now available for use")
                            st.info(f"🔓 NAF enabled after {failed_count} failed iterations - now trying negation as failure")
                        else:
                            log_message(f"NAF: {failed_count}/{threshold} failed iterations (NAF still disabled)")
                    
                    continue
                
                hypotheses = best_candidate['hypothesis'].split('\n')
                hypothesis = best_candidate['hypothesis']
                result = best_candidate['result']
                hyp_oneline = hypothesis.replace('\n', ' ').strip()
                
                # Track candidates evaluated
                iter_metrics["candidates_evaluated"] = len(candidate_results)
                
                # Show selected hypothesis
                st.code(hypothesis, language="prolog")
                log_message(f"BEAM SEARCH: Selected best hypothesis: {hyp_oneline}")
                
                # Update real-time status with generated hypothesis
                with realtime_status.container():
                    st.info(f"🔄 Iteration {i+1} - Testing...")
                    st.code(hypothesis, language="prolog")
                    m = st.session_state.metrics
                    st.write(f"**Prolog Tests:** {m['total_prolog_tests']} | **Subsumption:** {m['total_subsumption_checks']}")
                
                # Save to history
                st.session_state.messages.append({
                    "role": "assistant", 
                    "content": f"Iteration {i+1}: Generated hypothesis", 
                    "code": hypothesis
                })

            # 2. Testing UI (result already from beam search)
            with st.chat_message("user", avatar="🔬"):
                # Subsumption Check with timing
                subsumption_start = time.time()
                should_prune, reason = loop.constraint_learner.check_subsumption_pruning(hypothesis)
                iter_metrics["subsumption_check_time_seconds"] = round(time.time() - subsumption_start, 3)
                st.session_state.metrics["total_subsumption_checks"] += 1
                iter_metrics["hypothesis"] = hypothesis
                
                if should_prune:
                    msg = f"⚠️ Subsumption warning: {reason}"
                    log_message(f"Hypothesis subsumption warning: {reason}")
                    st.warning(msg)
                    iter_metrics["subsumption_pruned"] = True

                # Result already obtained from beam search evaluation
                iter_metrics["prolog_test_run"] = True
                
                # Show coverage results - adjust for partial cover mode
                total_pos = len(result.covered_pos) + len(result.missed_pos)
                total_neg = len(all_negatives) if all_negatives else len(result.covered_neg)
                
                # In divide-and-conquer mode, filter covered_pos to only count REMAINING positives
                if preserved_good_clauses and isinstance(remaining_positives, set) and len(remaining_positives) < len(all_positives):
                    # Filter: only count positives that are in remaining_positives (not already covered)
                    # Normalize to match all_positives format (no whitespace)
                    normalized_covered = {re.sub(r'\s+', '', ex) for ex in result.covered_pos}
                    covered_remaining = normalized_covered & remaining_positives
                    target_pos = len(remaining_positives)
                    st.write(f"**Coverage (remaining {target_pos} positives):** {len(covered_remaining)}/{target_pos} | Negatives: {len(result.covered_neg)}/{total_neg}")
                else:
                    st.write(f"**Total Coverage:** Positives: {len(result.covered_pos)}/{total_pos} | Negatives: {len(result.covered_neg)}/{total_neg}")
                
                # Per-clause coverage analysis for disjunctive hypotheses
                clauses = [c.strip() for c in hypothesis.split('\n') if c.strip() and c.strip().endswith('.')]
                per_clause_feedback = ""
                clause_stats = []  # Track stats for each clause
                
                # Show divide-and-conquer progress
                if preserved_good_clauses:
                    st.success(f"🎯 **Divide & Conquer Progress:** {len(covered_positives_global)}/{len(all_positives)} positives covered by {len(preserved_good_clauses)} locked clause(s)")
                
                # SINGLE CLAUSE PARTIAL COVER CHECK
                # If single clause covers some positives and zero negatives, it's a partial cover
                # BUT skip if hypothesis is recursive - recursive rules need to work together
                is_recursive = is_recursive_hypothesis(hypothesis)
                if is_recursive:
                    log_message(f"RECURSIVE HYPOTHESIS DETECTED - skipping per-clause partial cover, checking whole-theory lock")
                
                # RECURSIVE HYPOTHESIS PARTIAL COVER: Lock entire theory as a unit
                if is_recursive and len(result.covered_pos) > 0 and len(result.covered_neg) == 0 and not result.is_complete:
                    full_hyp_str = '\n'.join(clauses)
                    normalized_covered = {re.sub(r'\s+', '', ex) for ex in result.covered_pos}
                    if preserved_good_clauses and isinstance(remaining_positives, set):
                        new_covered = normalized_covered & remaining_positives
                    else:
                        new_covered = normalized_covered
                    
                    if len(new_covered) > 0 and full_hyp_str not in preserved_good_clauses_strs:
                        preserved_good_clauses.append({
                            'clause': full_hyp_str,
                            'covered_count': len(new_covered),
                            'covered_examples': new_covered
                        })
                        preserved_good_clauses_strs.append(full_hyp_str)
                        covered_positives_global.update(new_covered)
                        log_message(f"RECURSIVE PARTIAL COVER: Locked entire theory ({len(clauses)} clauses) covering {len(new_covered)} positives, 0 negatives")
                        
                        truly_remaining = len(all_positives) - len(covered_positives_global)
                        remaining_positives = all_positives - covered_positives_global
                        
                        if truly_remaining > 0:
                            st.success(f"🎯 RECURSIVE PARTIAL COVER! Locked {len(clauses)}-clause recursive theory covering {len(covered_positives_global)}/{len(all_positives)} positives.")
                            st.info(f"🔄 Restarting task with {truly_remaining} remaining uncovered positives...")
                            
                            _, working_exs_content = filter_task_for_remaining_examples(
                                bk_content, exs_content, remaining_positives, all_negatives
                            )
                            working_bk_content = bk_content
                            remaining_pos_formatted = [f"pos({x})." for x in remaining_positives]
                            all_neg_formatted = [f"neg({x})." for x in all_negatives]
                            updated_result = strategy_selector.apply_strategy(
                                positive_examples=remaining_pos_formatted,
                                negative_examples=all_neg_formatted
                            )
                            working_bk_content_for_prompt = updated_result.bk_content
                            working_exs_content_for_prompt = updated_result.examples_content
                            
                            restart_with_filtered_data = True
                            pcs["restart_with_filtered_data"] = True
                            pcs["partial_cover_round"] = partial_cover_round + 1
                            pcs["remaining_positives"] = remaining_positives
                            pcs["working_bk_content_for_prompt"] = working_bk_content_for_prompt
                            pcs["working_exs_content_for_prompt"] = working_exs_content_for_prompt
                            
                            with realtime_status.container():
                                st.success(f"🎯 Recursive Partial Cover Round {partial_cover_round + 1}")
                                st.write(f"**Locked clauses:** {len(preserved_good_clauses)} (recursive theory)")
                                st.write(f"**Covered:** {len(covered_positives_global)}/{len(all_positives)} positives")
                                st.write(f"**Remaining:** {truly_remaining} positives")
                                st.code('\n'.join(preserved_good_clauses_strs), language="prolog")
                            
                            iter_metrics["result"] = "recursive_partial_cover"
                            iter_metrics["covered_pos"] = len(result.covered_pos)
                            iter_metrics["covered_neg"] = len(result.covered_neg)
                            iter_metrics["missed_pos"] = len(result.missed_pos)
                            iter_metrics["llm_time_seconds"] = round(time.time() - iter_start_time, 3)
                            st.session_state.metrics["iterations"].append(iter_metrics)
                            st.session_state.metrics["total_iterations"] = i + 1
                            
                            time.sleep(1)
                            continue
                
                # SINGLE CLAUSE PARTIAL COVER CHECK
                if len(clauses) == 1 and len(result.covered_neg) == 0 and not is_recursive:
                    single_clause = clauses[0]
                    new_clause_added = False
                    
                    # In partial cover mode, only count NEW positives (not already covered)
                    # Normalize covered_pos to match all_positives format (no whitespace)
                    normalized_covered = {re.sub(r'\s+', '', ex) for ex in result.covered_pos}
                    if preserved_good_clauses and isinstance(remaining_positives, set):
                        new_covered = normalized_covered & remaining_positives
                    else:
                        new_covered = normalized_covered
                    
                    # Add clause if it covers NEW positives and isn't already locked
                    if len(new_covered) > 0 and single_clause not in preserved_good_clauses_strs:
                        preserved_good_clauses.append({
                            'clause': single_clause,
                            'covered_count': len(new_covered),
                            'covered_examples': new_covered
                        })
                        preserved_good_clauses_strs.append(single_clause)
                        covered_positives_global.update(new_covered)
                        new_clause_added = True
                        log_message(f"SINGLE CLAUSE PARTIAL COVER: '{single_clause}' covers {len(new_covered)} NEW positives, 0 negatives")
                    
                    # Always recalculate remaining even if clause was already locked
                    truly_remaining = len(all_positives) - len(covered_positives_global)
                    remaining_positives = all_positives - covered_positives_global
                    
                    log_message(f"PARTIAL COVER STATUS: {len(covered_positives_global)}/{len(all_positives)} covered, {truly_remaining} remaining")
                    
                    if truly_remaining > 0 and new_clause_added:
                        st.success(f"🎯 PARTIAL COVER FOUND! Locked {len(preserved_good_clauses)} clause(s) covering {len(covered_positives_global)}/{len(all_positives)} positives.")
                        st.info(f"🔄 Restarting task with {truly_remaining} remaining uncovered positives...")
                        
                        # Filter examples only - keep FULL background knowledge
                        _, working_exs_content = filter_task_for_remaining_examples(
                            bk_content, exs_content, remaining_positives, all_negatives
                        )
                        working_bk_content = bk_content  # Full BK for Prolog testing
                        # Re-apply strategy for remaining examples - convert to full format for pattern analysis
                        remaining_pos_formatted = [f"pos({x})." for x in remaining_positives]
                        all_neg_formatted = [f"neg({x})." for x in all_negatives]
                        updated_result = strategy_selector.apply_strategy(
                            positive_examples=remaining_pos_formatted,
                            negative_examples=all_neg_formatted
                        )
                        working_bk_content_for_prompt = updated_result.bk_content
                        working_exs_content_for_prompt = updated_result.examples_content
                        
                        # Set flag to restart with filtered data - UPDATE SESSION STATE
                        restart_with_filtered_data = True
                        pcs["restart_with_filtered_data"] = True
                        pcs["partial_cover_round"] = partial_cover_round + 1
                        pcs["remaining_positives"] = remaining_positives
                        pcs["working_bk_content_for_prompt"] = working_bk_content_for_prompt
                        pcs["working_exs_content_for_prompt"] = working_exs_content_for_prompt
                        
                        # Update status
                        with realtime_status.container():
                            st.success(f"🎯 Partial Cover Round {partial_cover_round + 1}")
                            st.write(f"**Locked clauses:** {len(preserved_good_clauses)}")
                            st.write(f"**Covered:** {len(covered_positives_global)}/{len(all_positives)} positives")
                            st.write(f"**Remaining:** {truly_remaining} positives")
                            st.code('\n'.join(preserved_good_clauses_strs), language="prolog")
                        
                        # Save iteration metrics before continuing to next partial cover round
                        iter_metrics["result"] = "partial_cover"
                        iter_metrics["covered_pos"] = len(result.covered_pos)
                        iter_metrics["covered_neg"] = len(result.covered_neg)
                        iter_metrics["missed_pos"] = len(result.missed_pos)
                        iter_metrics["llm_time_seconds"] = round(time.time() - iter_start_time, 3)
                        st.session_state.metrics["iterations"].append(iter_metrics)
                        st.session_state.metrics["total_iterations"] = i + 1
                        
                        time.sleep(1)
                        continue
                    elif truly_remaining == 0 and len(preserved_good_clauses) > 0:
                        # ALL POSITIVES COVERED - this is a complete solution!
                        combined_hypothesis = '\n'.join(preserved_good_clauses_strs)
                        log_message(f"DIVIDE-AND-CONQUER COMPLETE (single): {len(preserved_good_clauses)} clauses cover all {len(all_positives)} positives")
                        
                        # Mark as solved
                        st.session_state.solved = True
                        st.session_state.best_hyp = combined_hypothesis
                        st.session_state.metrics["solved"] = True
                        st.session_state.metrics["solution"] = combined_hypothesis
                        loop.save_hypothesis(combined_hypothesis)
                        
                        # Save combined solution to metrics.json
                        def count_literals(hyp):
                            total = 0
                            for c in hyp.split('\n'):
                                if ':-' in c:
                                    total += c.split(':-')[1].count(',') + 1
                                elif c.strip():
                                    total += 1
                            return total
                        
                        metrics_file = os.path.join(task_dir, "metrics.json")
                        combined_metrics = dict(st.session_state.metrics)
                        combined_metrics.update({
                            "solved": True,
                            "solution": combined_hypothesis,
                            "num_clauses": len(preserved_good_clauses),
                            "num_literals": count_literals(combined_hypothesis),
                            "total_positives": len(all_positives),
                            "end_time": datetime.now().isoformat()
                        })
                        with open(metrics_file, 'w', encoding='utf-8') as f:
                            json.dump(combined_metrics, f, indent=2)
                        log_message(f"Combined solution saved to metrics.json")
                        
                        # Test combined solution
                        combined_result = loop.tester.test_hypothesis(combined_hypothesis)
                        st.session_state.metrics["total_prolog_tests"] += 1
                        
                        log_message(f"SINGLE D&C COMPLETE - is_complete={combined_result.is_complete}, covered_pos={len(combined_result.covered_pos)}, covered_neg={len(combined_result.covered_neg)}, missed_pos={len(combined_result.missed_pos)}")
                        
                        # --- OPTIMIZATION STEP (D&C Mode) ---
                        if optimization_template:
                            st.info("🚀 Running D&C Optimization Step...")
                            log_message("Starting D&C Optimization Step...")
                            
                            original_combined = combined_hypothesis
                            original_lits = count_literals(combined_hypothesis)
                            
                            # Parse examples for optimization prompt
                            pos_ex_list = []
                            neg_ex_list = []
                            for line in exs_content.split('\n'):
                                line = line.strip()
                                if line.startswith('pos(') and line.endswith(').'):
                                    pos_ex_list.append(line)
                                elif line.startswith('neg(') and line.endswith(').'):
                                    neg_ex_list.append(line)
                            pos_examples_str = '\n'.join(pos_ex_list)
                            neg_examples_str = '\n'.join(neg_ex_list)
                            
                            # Run D&C optimization with examples
                            opt_start_time = time.time()
                            optimized_hyp, success, group_analyses = divide_and_conquer_optimize(
                                combined_hypothesis, bk_content, optimization_template,
                                model_name, api_key, loop.tester,
                                pos_examples=pos_examples_str, neg_examples=neg_examples_str,
                                bias_content=bias_content
                            )
                            opt_time = round(time.time() - opt_start_time, 3)
                            
                            best_opt_hyp = combined_hypothesis
                            best_opt_lits = original_lits
                            
                            if success:
                                new_lits = count_literals(optimized_hyp)
                                if new_lits < original_lits:
                                    st.success(f"✨ D&C Optimization: {original_lits} → {new_lits} literals")
                                    best_opt_hyp = optimized_hyp
                                    best_opt_lits = new_lits
                                    
                                    combined_hypothesis = best_opt_hyp
                                    combined_result = loop.tester.test_hypothesis(combined_hypothesis)
                                    loop.save_hypothesis(combined_hypothesis)
                                    st.session_state.best_hyp = combined_hypothesis
                                    st.session_state.metrics["solution"] = combined_hypothesis
                                    
                                    # Persist to metrics.json with full D&C details + iteration history
                                    try:
                                        metrics_file = os.path.join(task_dir, "metrics.json")
                                        # Start with session_state metrics to preserve iteration history
                                        m_data = dict(st.session_state.metrics)
                                        m_data["solution"] = combined_hypothesis
                                        m_data["num_literals"] = new_lits
                                        m_data["solved"] = True
                                        m_data["end_time"] = datetime.now().isoformat()
                                        m_data["optimization"] = {
                                            "optimized": True,
                                            "mode": "divide_and_conquer",
                                            "original_solution": original_combined,
                                            "original_literals": original_lits,
                                            "optimized_solution": combined_hypothesis,
                                            "optimized_literals": new_lits,
                                            "improvement": original_lits - new_lits,
                                            "improvement_pct": round(100 * (original_lits - new_lits) / original_lits, 1) if original_lits > 0 else 0,
                                            "optimization_time_seconds": opt_time,
                                            "group_analyses": group_analyses,
                                            "timestamp": datetime.now().isoformat()
                                        }
                                        with open(metrics_file, 'w', encoding='utf-8') as f:
                                            json.dump(m_data, f, indent=2)
                                        log_message(f"Metrics saved with D&C optimization details and iteration history")
                                    except Exception as e:
                                        log_message(f"Error updating metrics.json: {e}")
                                    
                                    log_message(f"D&C OPTIMIZATION SUCCESS: {original_lits} → {best_opt_lits} literals")
                                else:
                                    st.info(f"ℹ️ D&C produced valid result but no size improvement ({new_lits} literals)")
                            else:
                                st.warning("⚠️ D&C optimization failed verification - keeping original")
                            
                            # Store final optimization progress
                            st.session_state.optimization_progress = {
                                "status": "success" if best_opt_lits < original_lits else "no_improvement",
                                "mode": "divide_and_conquer",
                                "original_literals": original_lits,
                                "new_literals": best_opt_lits,
                                "original_hypothesis": original_combined,
                                "optimized_hypothesis": best_opt_hyp,
                                "group_analyses": group_analyses,
                                "optimization_time": opt_time,
                                "timestamp": datetime.now().isoformat()
                            }

                        # Update hypothesis and result for final display
                        hypothesis = combined_hypothesis
                        result = combined_result
                        break
                
                if len(clauses) > 1:
                    # Determine target positives for display
                    if preserved_good_clauses and isinstance(remaining_positives, set) and len(remaining_positives) < len(all_positives):
                        display_total_pos = len(remaining_positives)
                    else:
                        display_total_pos = len(all_positives) if all_positives else total_pos
                    
                    with st.expander("📊 Per-Clause Coverage", expanded=False):
                        for idx, clause in enumerate(clauses, 1):
                            try:
                                clause_result = loop.tester.test_hypothesis(clause)
                                c_tp = len(clause_result.covered_pos)
                                c_fp = len(clause_result.covered_neg)
                                c_fn = len(clause_result.missed_pos)
                                c_prec = c_tp / (c_tp + c_fp) if (c_tp + c_fp) > 0 else 0
                                c_rec = c_tp / (c_tp + c_fn) if (c_tp + c_fn) > 0 else 0
                                c_f1 = 2 * (c_prec * c_rec) / (c_prec + c_rec) if (c_prec + c_rec) > 0 else 0
                                
                                clause_stats.append({
                                    "idx": idx, "clause": clause, 
                                    "tp": c_tp, "fp": c_fp, "fn": c_fn, "f1": c_f1,
                                    "covered_pos_set": set(clause_result.covered_pos),  # Store actual set for union
                                    "covered_neg_set": set(clause_result.covered_neg)
                                })
                                
                                st.write(f"**Clause {idx}:** `{clause}`")
                                st.write(f"   ↳ Pos: {c_tp}/{display_total_pos} | Neg: {c_fp} | F1: {c_f1:.2f}")
                            except Exception as e:
                                st.write(f"**Clause {idx}:** `{clause}` - (test error)")
                                clause_stats.append({"idx": idx, "clause": clause, "tp": 0, "fp": 0, "fn": 0, "f1": 0, "covered_pos_set": set(), "covered_neg_set": set()})
                    
                    # Build targeted refinement feedback
                    if clause_stats:
                        # Find best F1 score
                        best_f1 = max(cs["f1"] for cs in clause_stats)
                        
                        per_clause_feedback = "\n### Per-Clause Analysis:\n"
                        for cs in clause_stats:
                            # GOOD = covers positives AND zero negatives
                            is_good = cs["tp"] > 0 and cs["fp"] == 0
                            status = "✅ KEEP" if is_good else "🔧 REFINE"
                            per_clause_feedback += f"- **Clause {cs['idx']}** [{status}]: `{cs['clause']}`\n"
                            per_clause_feedback += f"  - Pos: {cs['tp']}, Neg: {cs['fp']}, F1: {cs['f1']:.2f}\n"
                            
                            # Specific problem for each clause
                            if cs["fp"] > 0:
                                per_clause_feedback += f"  - **Problem**: Covers {cs['fp']} negatives → Add conditions to exclude them\n"
                            if cs["tp"] == 0:
                                per_clause_feedback += f"  - **Problem**: Covers 0 positives → Remove or rewrite this clause\n"
                        
                        # Identify good clauses (covers some positives, NO negatives) and bad clauses
                        good_clauses = [cs for cs in clause_stats if cs["tp"] > 0 and cs["fp"] == 0]
                        bad_clauses = [cs for cs in clause_stats if cs["fp"] > 0]
                        useless_clauses = [cs for cs in clause_stats if cs["tp"] == 0 and cs["fp"] == 0]
                        
                        # Calculate remaining uncovered positives using SET UNION (avoid overlap)
                        all_covered_by_good = set()
                        for gc in good_clauses:
                            all_covered_by_good.update(gc.get("covered_pos_set", set()))
                        covered_by_good = len(all_covered_by_good)
                        total_positives = total_pos
                        remaining_positives = total_positives - covered_by_good
                        
                        per_clause_feedback += "\n### REFINEMENT INSTRUCTIONS:\n"
                        
                        # Sort good clauses by coverage (highest first)
                        good_clauses_sorted = sorted(good_clauses, key=lambda x: x["tp"], reverse=True)
                        
                        # Skip partial cover logic for recursive hypotheses
                        if good_clauses_sorted and not is_recursive:
                            # Check if we found NEW good clauses in this iteration
                            new_good_clauses_found = False
                            for gc in good_clauses_sorted:
                                if gc['clause'] not in preserved_good_clauses_strs:
                                    # In partial cover mode, only count NEW positives (not already covered)
                                    # Normalize covered_pos_set to match all_positives format (no whitespace)
                                    clause_covered = {re.sub(r'\s+', '', ex) for ex in gc.get("covered_pos_set", set())}
                                    if preserved_good_clauses and isinstance(remaining_positives, set):
                                        new_covered = clause_covered & remaining_positives
                                    else:
                                        new_covered = clause_covered
                                    
                                    if len(new_covered) > 0:
                                        preserved_good_clauses.append({
                                            'clause': gc['clause'],
                                            'covered_count': len(new_covered),
                                            'covered_examples': new_covered
                                        })
                                        preserved_good_clauses_strs.append(gc['clause'])
                                        # DIVIDE-AND-CONQUER: Update global covered positives with NEW ones only
                                        covered_positives_global.update(new_covered)
                                        new_good_clauses_found = True
                                        log_message(f"MULTI-CLAUSE PARTIAL COVER: '{gc['clause']}' covers {len(new_covered)} NEW positives, 0 negatives")
                            
                            # Calculate truly remaining positives (not covered by ANY good clause so far)
                            truly_remaining = len(all_positives) - len(covered_positives_global)
                            remaining_positives = all_positives - covered_positives_global
                            
                            log_message(f"MULTI-CLAUSE PARTIAL STATUS: {len(covered_positives_global)}/{len(all_positives)} covered, {truly_remaining} remaining, new_found={new_good_clauses_found}")
                            
                            # Keep ALL good clauses (pos > 0, neg = 0) - show with per-clause stats
                            per_clause_feedback += f"**✅ LOCKED GOOD CLAUSES (cover {len(covered_positives_global)}/{len(all_positives)} total positives, 0 negatives):**\n```prolog\n"
                            for pc in preserved_good_clauses:
                                per_clause_feedback += f"{pc['clause']}  % covers {pc['covered_count']} positives\n"
                            per_clause_feedback += "```\n"
                            
                            if truly_remaining > 0:
                                # PARTIAL COVER APPROACH: If new good clause found, filter task and restart
                                if new_good_clauses_found:
                                    st.success(f"🎯 PARTIAL COVER FOUND! Locked {len(preserved_good_clauses)} clause(s) covering {len(covered_positives_global)}/{len(all_positives)} positives.")
                                    st.info(f"🔄 Restarting task with {truly_remaining} remaining uncovered positives...")
                                    
                                    # Filter examples only - keep FULL background knowledge
                                    _, working_exs_content = filter_task_for_remaining_examples(
                                        bk_content, exs_content, remaining_positives, all_negatives
                                    )
                                    working_bk_content = bk_content  # Full BK for Prolog testing
                                    # Re-apply strategy for remaining examples - convert to full format for pattern analysis
                                    remaining_pos_formatted = [f"pos({x})." for x in remaining_positives]
                                    all_neg_formatted = [f"neg({x})." for x in all_negatives]
                                    updated_result = strategy_selector.apply_strategy(
                                        positive_examples=remaining_pos_formatted,
                                        negative_examples=all_neg_formatted
                                    )
                                    working_bk_content_for_prompt = updated_result.bk_content
                                    working_exs_content_for_prompt = updated_result.examples_content
                                    
                                    # Set flag to restart with filtered data - UPDATE SESSION STATE
                                    restart_with_filtered_data = True
                                    pcs["restart_with_filtered_data"] = True
                                    pcs["partial_cover_round"] = partial_cover_round + 1
                                    pcs["remaining_positives"] = remaining_positives
                                    pcs["working_bk_content_for_prompt"] = working_bk_content_for_prompt
                                    pcs["working_exs_content_for_prompt"] = working_exs_content_for_prompt
                                    
                                    # Update status
                                    with realtime_status.container():
                                        st.success(f"🎯 Partial Cover Round {partial_cover_round + 1}")
                                        st.write(f"**Locked clauses:** {len(preserved_good_clauses)}")
                                        st.write(f"**Covered:** {len(covered_positives_global)}/{len(all_positives)} positives")
                                        st.write(f"**Remaining:** {truly_remaining} positives")
                                        st.code('\n'.join(preserved_good_clauses_strs), language="prolog")
                                    
                                    # Save iteration metrics before continuing to next partial cover round
                                    iter_metrics["result"] = "partial_cover"
                                    iter_metrics["covered_pos"] = len(result.covered_pos)
                                    iter_metrics["covered_neg"] = len(result.covered_neg)
                                    iter_metrics["missed_pos"] = len(result.missed_pos)
                                    iter_metrics["llm_time_seconds"] = round(time.time() - iter_start_time, 3)
                                    st.session_state.metrics["iterations"].append(iter_metrics)
                                    st.session_state.metrics["total_iterations"] = i + 1
                                    
                                    # Skip to next iteration with fresh task
                                    time.sleep(1)
                                    continue
                                
                                # Calculate uncovered positives to show LLM
                                uncovered_pos = all_positives - covered_positives_global
                                uncovered_list = list(uncovered_pos)[:10]  # Show first 10
                                
                                per_clause_feedback += f"\n**🔍 NEW TASK: Find a clause for the remaining {truly_remaining} uncovered positives.**\n"
                                per_clause_feedback += f"\n**Uncovered positives (sample):** {', '.join(uncovered_list)}"
                                if len(uncovered_pos) > 10:
                                    per_clause_feedback += f" ... and {len(uncovered_pos) - 10} more"
                                per_clause_feedback += f"\n\n⚠️ **DIVIDE-AND-CONQUER APPROACH:**\n"
                                per_clause_feedback += f"1. The good clauses above are LOCKED - do not modify them\n"
                                per_clause_feedback += f"2. Focus ONLY on finding ONE new clause for the uncovered positives above\n"
                                per_clause_feedback += f"3. New clause must cover 0 negatives\n"
                                per_clause_feedback += f"4. Output: all locked clauses + ONE new clause\n"
                            else:
                                # All positives covered by partial solutions!
                                # Combine all locked clauses and trigger optimization
                                per_clause_feedback += f"\n**✅ ALL {len(all_positives)} POSITIVES COVERED BY PARTIAL SOLUTIONS!**\n"
                                per_clause_feedback += f"Proceeding to optimization phase...\n"
                                
                                # TRIGGER SOLUTION: Combine preserved clauses as final hypothesis
                                combined_hypothesis = '\n'.join(preserved_good_clauses_strs)
                                log_message(f"DIVIDE-AND-CONQUER COMPLETE: {len(preserved_good_clauses)} clauses cover all {len(all_positives)} positives")
                                
                                # Mark as solved and go to optimization
                                st.session_state.solved = True
                                st.session_state.best_hyp = combined_hypothesis
                                st.session_state.metrics["solved"] = True
                                st.session_state.metrics["solution"] = combined_hypothesis
                                loop.save_hypothesis(combined_hypothesis)
                                
                                # Helper function to count literals
                                def count_literals(hyp):
                                    total = 0
                                    for clause in hyp.split('\n'):
                                        if ':-' in clause:
                                            body = clause.split(':-')[1]
                                            total += body.count('),') + 1
                                        elif clause.strip() and not clause.strip().startswith('%'):
                                            total += 1
                                    return total
                                
                                # Save combined solution to metrics.json
                                metrics_file = os.path.join(task_dir, "metrics.json")
                                combined_metrics = dict(st.session_state.metrics)
                                combined_metrics.update({
                                    "solved": True,
                                    "solution": combined_hypothesis,
                                    "num_clauses": len(preserved_good_clauses),
                                    "num_literals": count_literals(combined_hypothesis),
                                    "total_positives": len(all_positives),
                                    "end_time": datetime.now().isoformat()
                                })
                                with open(metrics_file, 'w', encoding='utf-8') as f:
                                    json.dump(combined_metrics, f, indent=2)
                                log_message(f"Combined solution saved to metrics.json")
                                
                                # Calculate stats for the combined solution
                                combined_result = loop.tester.test_hypothesis(combined_hypothesis)
                                st.session_state.metrics["total_prolog_tests"] += 1
                                
                                tp = len(combined_result.covered_pos)
                                fp = len(combined_result.covered_neg)
                                fn = len(combined_result.missed_pos)
                                precision = tp / (tp + fp) if (tp + fp) > 0 else 0
                                recall = tp / (tp + fn) if (tp + fn) > 0 else 0
                                f1_score = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0
                                
                                st.session_state.metrics["f1_score"] = round(f1_score, 4)
                                st.session_state.metrics["num_literals"] = count_literals(combined_hypothesis)
                                
                                with realtime_status.container():
                                    st.success(f"🎉 DIVIDE-AND-CONQUER SOLUTION FOUND!")
                                    st.code(combined_hypothesis, language="prolog")
                                    st.write(f"**Clauses:** {len(preserved_good_clauses)} | **Positives:** {tp}/{len(all_positives)} | **Negatives:** {fp}")
                                
                                # Jump to optimization phase
                                hypothesis = combined_hypothesis
                                result = combined_result
                                log_message(f"D&C COMPLETE - combined_result.is_complete={combined_result.is_complete}, covered_pos={len(combined_result.covered_pos)}, covered_neg={len(combined_result.covered_neg)}, missed_pos={len(combined_result.missed_pos)}")
                                # Fall through to is_complete block below
                        else:
                            # No good clauses - find the one with highest coverage even if it has negatives
                            all_sorted = sorted(clause_stats, key=lambda x: x["tp"], reverse=True)
                            if all_sorted and all_sorted[0]["tp"] > 0:
                                best = all_sorted[0]
                                per_clause_feedback += f"**🔧 BEST CANDIDATE (covers {best['tp']} pos, {best['fp']} neg):**\n```prolog\n"
                                per_clause_feedback += f"{best['clause']}\n"
                                per_clause_feedback += "```\n"
                                per_clause_feedback += f"\n**TASK: Add conditions to this clause to exclude the {best['fp']} negatives.**\n"
                                per_clause_feedback += f"Output only ONE refined clause.\n"
                
                # Update iteration metrics with coverage info
                iter_metrics["covered_pos"] = len(result.covered_pos)
                iter_metrics["covered_neg"] = len(result.covered_neg)
                iter_metrics["missed_pos"] = len(result.missed_pos)
                iter_metrics["is_complete"] = result.is_complete
                
                # DEBUG LOG: Capture test results and clause analysis for Cascade
                clause_stats_serializable = [{k: v for k, v in cs.items() if k not in ["covered_pos_set", "covered_neg_set"]} for cs in clause_stats] if clause_stats else []
                st.session_state.debug_log.append({
                    "iteration": i + 1,
                    "type": "test_result",
                    "hypothesis": hypothesis,
                    "total_coverage": {"pos": len(result.covered_pos), "neg": len(result.covered_neg), "missed": len(result.missed_pos)},
                    "is_complete": result.is_complete,
                    "is_too_general": result.is_too_general,
                    "is_too_specific": result.is_too_specific,
                    "clause_stats": clause_stats_serializable,
                    "per_clause_feedback": per_clause_feedback,
                    "good_clauses_count": len(good_clauses) if 'good_clauses' in dir() else 0,
                })
                
                # Calculate MDL cost and track best partial solution (Popper approach)
                def count_literals(hyp):
                    total = 0
                    for clause in hyp.split('\n'):
                        if ':-' in clause:
                            body = clause.split(':-')[1]
                            total += body.count(',') + 1
                        else:
                            total += 1
                    return total
                
                num_literals = count_literals(hypothesis)
                tp = len(result.covered_pos)
                fp = len(result.covered_neg)
                fn = len(result.missed_pos)
                mdl_cost = num_literals + fp + fn  # MDL: size + false_positives + false_negatives
                
                # Update best partial if this is better
                if mdl_cost < best_partial_cost:
                    best_partial_cost = mdl_cost
                    best_partial_hyp = hypothesis
                    precision = tp / (tp + fp) if (tp + fp) > 0 else 0
                    recall = tp / (tp + fn) if (tp + fn) > 0 else 0
                    f1 = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0
                    best_partial_stats = {"tp": tp, "fp": fp, "fn": fn, "size": num_literals, "f1": f1, "cost": mdl_cost}
                    log_message(f"New best partial: cost={mdl_cost}, F1={f1:.2f}, size={num_literals}")
                
                log_message(f"CHECKING is_complete: {result.is_complete}, covered_pos={len(result.covered_pos)}, covered_neg={len(result.covered_neg)}, missed_pos={len(result.missed_pos)}")
                
                # PARTIAL COVER FIX: In partial cover mode, check if COMBINED coverage completes the solution
                # A clause that covers remaining positives with 0 negatives should complete, not be "too specific"
                if preserved_good_clauses and len(result.covered_neg) == 0 and len(covered_positives_global) == len(all_positives):
                    # Combine locked clauses into final solution
                    combined_hypothesis = '\n'.join(preserved_good_clauses_strs)
                    log_message(f"PARTIAL COVER COMPLETE: {len(preserved_good_clauses)} clauses cover all {len(all_positives)} positives with 0 negatives")
                    
                    # Test combined solution
                    combined_result = loop.tester.test_hypothesis(combined_hypothesis)
                    st.session_state.metrics["total_prolog_tests"] += 1
                    
                    if combined_result.is_complete:
                        st.balloons()
                        st.success(f"✅ COMPLETE SOLUTION FOUND via Divide & Conquer!")
                        st.session_state.best_hyp = combined_hypothesis
                        st.session_state.solved = True
                        st.session_state.all_solutions.append(combined_hypothesis)
                        st.session_state.metrics["solved"] = True
                        st.session_state.metrics["solution"] = combined_hypothesis
                        loop.save_hypothesis(combined_hypothesis)
                        
                        with realtime_status.container():
                            st.success(f"✅ SOLVED with {len(preserved_good_clauses)} clauses!")
                            st.code(combined_hypothesis, language="prolog")
                        
                        # Save iteration metrics for the final D&C solution
                        iter_metrics["result"] = "solution_found_dc"
                        iter_metrics["hypothesis"] = combined_hypothesis
                        iter_metrics["covered_pos"] = len(combined_result.covered_pos)
                        iter_metrics["covered_neg"] = len(combined_result.covered_neg)
                        iter_metrics["missed_pos"] = len(combined_result.missed_pos)
                        iter_metrics["is_complete"] = True
                        iter_metrics["llm_time_seconds"] = round(time.time() - iter_start_time, 3)
                        st.session_state.metrics["iterations"].append(iter_metrics)
                        st.session_state.metrics["total_iterations"] = i + 1
                        
                        # Proceed to optimization if available
                        if optimization_template:
                            log_message("Starting optimization of combined solution...")
                        break
                    else:
                        log_message(f"Combined solution test failed: pos={len(combined_result.covered_pos)}, neg={len(combined_result.covered_neg)}")
                
                if result.is_complete:
                    # Calculate F1 score
                    tp = len(result.covered_pos)
                    fp = len(result.covered_neg)
                    fn = len(result.missed_pos)
                    precision = tp / (tp + fp) if (tp + fp) > 0 else 0
                    recall = tp / (tp + fn) if (tp + fn) > 0 else 0
                    f1_score = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0
                    
                    # Count literals in hypothesis
                    def count_literals(hyp):
                        # Count body literals (predicates after :-)
                        total = 0
                        for clause in hyp.split('\n'):
                            if ':-' in clause:
                                body = clause.split(':-')[1]
                                # Count commas + 1 for body literals
                                total += body.count(',') + 1
                            else:
                                total += 1  # Fact
                        return total
                    
                    num_literals = count_literals(hypothesis)
                    
                    st.balloons()
                    solution_num = len(st.session_state.all_solutions) + 1
                    success_msg = f"SOLUTION #{solution_num} FOUND! (F1: {f1_score:.2f}, Literals: {num_literals})"
                    st.success(success_msg)
                    st.session_state.best_hyp = hypothesis
                    st.session_state.solved = True
                    st.session_state.all_solutions.append(hypothesis)
                    st.session_state.messages.append({"role": "user", "content": success_msg, "code": hypothesis})
                    log_message(f"Solution found in iteration {i+1} with F1: {f1_score:.2f}, Literals: {num_literals}")
                    
                    # Update metrics for solution
                    iter_metrics["result"] = "solution"
                    iter_metrics["f1_score"] = round(f1_score, 4)
                    iter_metrics["num_literals"] = num_literals
                    st.session_state.metrics["solved"] = True
                    st.session_state.metrics["solution"] = hypothesis
                    st.session_state.metrics["f1_score"] = round(f1_score, 4)
                    st.session_state.metrics["num_literals"] = num_literals
                    st.session_state.metrics["iterations"].append(iter_metrics)
                    st.session_state.metrics["total_iterations"] = i + 1
                    
                    # Update real-time status immediately
                    with realtime_status.container():
                        st.success(f"✅ SOLVED in iteration {i+1}!")
                        st.code(hypothesis, language="prolog")
                        st.write(f"**F1 Score:** {f1_score:.2f} | **Literals:** {num_literals}")
                        m = st.session_state.metrics
                        st.write(f"**Iterations:** {m['total_iterations']} | **Prolog Tests:** {m['total_prolog_tests']} | **Time:** {round(time.time() - run_start_time, 2)}s")
                    
                    # Save solution
                    loop.save_hypothesis(hypothesis)
                    
                    # Save solution to metrics.json with full iteration history
                    metrics_file = os.path.join(task_dir, "metrics.json")
                    # Use session_state metrics as base to preserve all iteration data
                    solution_metrics = dict(st.session_state.metrics)
                    solution_metrics.update({
                        "solved": True,
                        "solution": hypothesis,
                        "num_clauses": len(hypothesis.strip().split('\n')),
                        "num_literals": num_literals,
                        "f1_score": round(f1_score, 4),
                        "total_positives": len(result.covered_pos) + len(result.missed_pos),
                        "covered_positives": len(result.covered_pos),
                        "covered_negatives": len(result.covered_neg),
                        "total_iterations": i + 1,
                        "end_time": datetime.now().isoformat()
                    })
                    with open(metrics_file, 'w', encoding='utf-8') as f:
                        json.dump(solution_metrics, f, indent=2)
                    log_message(f"Solution saved to metrics.json")
                    
                    # === OPTIMIZATION PHASE: Try 3 more iterations to find simpler solution ===
                    # Check if solution was built from partial covers
                    is_partial_solution = len(preserved_good_clauses) > 1
                    
                    if is_partial_solution:
                        st.info(f"🔍 Optimization phase: Combining {len(preserved_good_clauses)} partial solutions (3 iterations)...")
                        log_message(f"Starting optimization phase for {len(preserved_good_clauses)} partial solutions")
                    else:
                        st.info("🔍 Optimization phase: Searching for simpler solution (3 iterations)...")
                        log_message("Starting optimization phase (3 iterations)")
                    
                    best_solution = hypothesis
                    best_literals = num_literals
                    best_f1 = f1_score
                    
                    for opt_iter in range(3):
                        log_message(f"Optimization iteration {opt_iter+1}/3")
                        with realtime_status.container():
                            st.info(f"🔍 Optimization {opt_iter+1}/3 - Looking for simpler solution (current: {best_literals} literals)")
                            st.code(best_solution, language="prolog")
                        
                        # Build optimization prompt using ILP-focused approach
                        # Calculate coverage stats for prompt
                        total_pos = len(all_positives)
                        total_neg = len(all_negatives)
                        covered_pos = len(result.covered_pos) if hasattr(result, 'covered_pos') else 0
                        covered_neg = len(result.covered_neg) if hasattr(result, 'covered_neg') else 0
                        missed_pos = len(result.missed_pos) if hasattr(result, 'missed_pos') else 0
                        
                        # Partial cover stats (if applicable)
                        partial_covered = len(covered_positives_global) if covered_positives_global else 0
                        remaining_pos = remaining_positives if isinstance(remaining_positives, int) else (len(remaining_positives) if remaining_positives else total_pos)
                        
                        opt_prompt = f"""You are an expert in Symbolic AI, Prolog, and Inductive Logic Programming (ILP).
Your task is hypothesis optimization using Occam's Razor: find the simplest and most general logic program that explains the data while preserving correctness.

## Generated Hypotheses ({best_literals} literals, F1: {best_f1:.2f}):
```prolog
{best_solution}
```

## Coverage Statistics:
| Metric | Value |
|--------|-------|
| **Total Positives** | {total_pos} |
| **Total Negatives** | {total_neg} |
| **Covered Positives** | {covered_pos} |
| **Covered Negatives** | {covered_neg} (must be 0) |
| **Missed Positives** | {missed_pos} |
| **Partial Cover Progress** | {partial_covered}/{total_pos} ({round(partial_covered/total_pos*100) if total_pos > 0 else 0}%) |

## Language Bias (Constraints):
```prolog
{bias_content}
```

## Background Knowledge:
```prolog
{bk_content}
```

## Examples:
```prolog
{exs_content}
```

## Optimization Objectives:

**Structural Preservation**:
- **RECURSION**: If the bias contains "enable_recursion" and the input hypothesis uses recursive clauses (head predicate appears in the body), the output MUST preserve recursion. Do NOT collapse recursive rules into non-recursive alternatives.
- **PREDICATE CONSTRAINTS**: Only use predicates declared in head_pred and body_pred in the bias. The head predicate may appear in the body if recursion is enabled.

**Generalization**: Replace specific constants with variables when not essential. Prefer abstract predicates.

**Pruning**: Remove literals that do not affect rule coverage or correctness. If one literal logically subsumes another, keep only the stronger one.

**Rule Unification**: Identify multiple rules that describe the same underlying concept. Merge them by extracting their common structure into a single generalized rule.

**Relational Focus**: Prefer relationships between entities (e.g., shared coordinates, alignment) over isolated object attributes, unless attributes are essential.

**Variable Linking**: Introduce shared variables where predicates refer to the same latent concept (e.g., coord1(A,X), coord1(B,X) indicating alignment).

**Minimality**: Aim for the smallest hypothesis: fewest rules and fewest literals per rule.

## Output Requirements:
1. Provide the optimized Prolog rules in a ```prolog code block
2. Each clause must be on ONE LINE with proper syntax
3. The optimized hypothesis MUST still cover ALL positives and ZERO negatives

Current: {best_literals} literals. Can you find a solution with fewer?
If you cannot find a simpler valid solution, respond with "NO SIMPLER SOLUTION".

```prolog
your_optimized_hypothesis_here.
```
"""
                        # Show the optimization prompt
                        with st.expander(f"📋 View Optimization Prompt {opt_iter+1}", expanded=False):
                            st.code(opt_prompt, language="markdown")
                        
                        try:
                            with st.chat_message("assistant"):
                                st.write(f"**Optimization {opt_iter+1}/3** - Searching for simpler solution...")
                                if use_cascade_mode:
                                    opt_response = call_cascade_with_display(opt_prompt, task_dir)
                                else:
                                    opt_response = call_llm_with_display(opt_prompt, model_name, api_key)
                            
                            if "NO SIMPLER SOLUTION" in opt_response.upper():
                                st.info(f"Optimization {opt_iter+1}: No simpler solution found")
                                continue
                            
                            opt_hypotheses = parse_prolog_clauses(opt_response)
                            if not opt_hypotheses:
                                continue
                            
                            # BIAS VALIDATION: Filter out clauses using predicates not in bias
                            if bias_content:
                                opt_hypotheses = filter_valid_clauses(opt_hypotheses, bias_content, log_message)
                                if not opt_hypotheses:
                                    log_message(f"Optimization {opt_iter+1}: All clauses had undefined predicates")
                                    continue
                            
                            opt_hypothesis = "\n".join(opt_hypotheses)
                            opt_literals = count_literals(opt_hypothesis)
                            
                            # Test the optimized hypothesis
                            opt_result = loop.tester.test_hypothesis(opt_hypothesis)
                            st.session_state.metrics["total_prolog_tests"] += 1
                            
                            if opt_result.is_complete and opt_literals < best_literals:
                                # Calculate F1 for new solution
                                opt_tp = len(opt_result.covered_pos)
                                opt_fp = len(opt_result.covered_neg)
                                opt_fn = len(opt_result.missed_pos)
                                opt_precision = opt_tp / (opt_tp + opt_fp) if (opt_tp + opt_fp) > 0 else 0
                                opt_recall = opt_tp / (opt_tp + opt_fn) if (opt_tp + opt_fn) > 0 else 0
                                opt_f1 = 2 * (opt_precision * opt_recall) / (opt_precision + opt_recall) if (opt_precision + opt_recall) > 0 else 0
                                
                                log_message(f"Optimization {opt_iter+1}: Found simpler solution! {opt_literals} literals (was {best_literals})")
                                st.success(f"✨ Found simpler solution! {opt_literals} literals (was {best_literals})")
                                best_solution = opt_hypothesis
                                best_literals = opt_literals
                                best_f1 = opt_f1
                                st.session_state.best_hyp = best_solution
                                st.session_state.metrics["solution"] = best_solution
                                st.session_state.metrics["num_literals"] = best_literals
                                st.session_state.metrics["f1_score"] = round(best_f1, 4)
                                loop.save_hypothesis(best_solution)
                            elif opt_result.is_complete:
                                log_message(f"Optimization {opt_iter+1}: Found valid solution but not simpler ({opt_literals} >= {best_literals} literals)")
                                st.info(f"Optimization {opt_iter+1}: Found valid solution but not simpler ({opt_literals} >= {best_literals} literals)")
                            else:
                                log_message(f"Optimization {opt_iter+1}: Proposed solution failed tests")
                                st.warning(f"Optimization {opt_iter+1}: Proposed solution failed tests")
                        except Exception as e:
                            log_message(f"Optimization {opt_iter+1} error: {e}")
                            st.warning(f"Optimization {opt_iter+1} error: {e}")
                        
                        time.sleep(1)
                    
                    # Final result
                    with realtime_status.container():
                        log_message(f"Optimal solution found: F1: {best_f1:.2f}, Literals: {best_literals}")
                        st.success(f"✅ OPTIMAL SOLUTION (F1: {best_f1:.2f}, Literals: {best_literals})")
                        st.code(best_solution, language="prolog")
                        m = st.session_state.metrics
                        st.write(f"**Iterations:** {m['total_iterations']} | **Prolog Tests:** {m['total_prolog_tests']} | **Time:** {round(time.time() - run_start_time, 2)}s")
                    
                    if keep_searching:
                        st.info("Continuing search for alternative solutions...")
                        failed_hypotheses.append((best_solution, "This solution WORKS but try a DIFFERENT approach"))
                        st.session_state.solved = False
                        
                        # Save iteration metrics before continuing search
                        iter_metrics["result"] = "solution_found_continue"
                        iter_metrics["llm_time_seconds"] = round(time.time() - iter_start_time, 3)
                        st.session_state.metrics["iterations"].append(iter_metrics)
                        st.session_state.metrics["total_iterations"] = i + 1
                        
                        time.sleep(1)
                        continue
                    else:
                        break
                else:
                    # Failure Logic
                    constraints = loop.constraint_learner.analyze_failure(result)
                    
                    # Calculate stats - use remaining positives if we have partial covers
                    total_pos = len(result.covered_pos) + len(result.missed_pos)
                    
                    # In partial cover mode, filter covered_pos and missed_pos to only count REMAINING positives
                    if preserved_good_clauses and isinstance(remaining_positives, set) and len(remaining_positives) > 0:
                        # We're in divide-and-conquer mode - show remaining positives
                        current_target_pos = len(remaining_positives)
                        # Normalize to match all_positives format (no whitespace)
                        normalized_covered = {re.sub(r'\s+', '', ex) for ex in result.covered_pos}
                        normalized_missed = {re.sub(r'\s+', '', ex) for ex in result.missed_pos}
                        # Filter: only count positives that are in remaining_positives
                        feedback_covered_pos = len(normalized_covered & remaining_positives)
                        # Filter missed_pos to only remaining positives
                        feedback_missed_pos = len(normalized_missed & remaining_positives)
                    elif total_pos > 0:
                        current_target_pos = total_pos
                        feedback_covered_pos = len(result.covered_pos)
                        feedback_missed_pos = len(result.missed_pos)
                    else:
                        # Fallback to all_positives if we have no other info
                        current_target_pos = len(all_positives) if all_positives else 1
                        feedback_covered_pos = len(result.covered_pos)
                        feedback_missed_pos = len(result.missed_pos)
                    total_neg = len(all_negatives) if all_negatives else len(result.covered_neg)
                    
                    # Build detailed feedback using promptfeedback template
                    # Determine failure type
                    if result.is_too_general:
                        failure_type = "TOO GENERAL"
                        fail_msg = f"Too General (Covered {len(result.covered_neg)} negatives)"
                    elif result.is_too_specific:
                        failure_type = "TOO SPECIFIC"
                        fail_msg = f"Too Specific (Missed {feedback_missed_pos} positives)"
                    else:
                        failure_type = "INCONSISTENT"
                        fail_msg = f"Failed - pos: {feedback_covered_pos}, neg: {len(result.covered_neg)}"
                    
                    last_feedback = f"""# Iteration {i+1} — Hypothesis FAILED

## Hypothesis
```prolog
{hypothesis}
```

## Outcome Summary
- Positives covered: {feedback_covered_pos}/{current_target_pos}
- Negatives covered (errors): {len(result.covered_neg)}/{total_neg} (target: 0)
- Failure type: {failure_type}
"""
                    
                    if result.is_too_general:
                        # Extract predicates used in hypothesis
                        hyp_predicates = extract_predicates_from_hypothesis(hypothesis)
                        clauses = parse_prolog_clauses(hypothesis)
                        
                        # Key Counterexamples
                        last_feedback += "\n## SECTION A: False Positives (Hypothesis is Too General)\n"
                        last_feedback += "\n### Key Counterexamples\nThe hypothesis incorrectly covers these negative examples:\n"
                        for neg in list(result.covered_neg)[:5]:
                            last_feedback += f"- `{neg}`\n"
                        if len(result.covered_neg) > 5:
                            last_feedback += f"- ... and {len(result.covered_neg) - 5} more\n"
                        
                        # Detailed analysis for first counterexample
                        first_neg = list(result.covered_neg)[0] if result.covered_neg else None
                        if first_neg:
                            # Get ALL facts for this example organized by predicate
                            neg_facts_dict = extract_all_facts_for_example(bk_content, first_neg)
                            
                            # Find which clause(s) cover this negative
                            last_feedback += f"\n### Clause Coverage for `{first_neg}`\n"
                            for idx, clause in enumerate(clauses):
                                last_feedback += f"- **Clause {idx+1}:** `{clause}`\n"
                            
                            # Show negated literals and CWA explanation
                            negated_lits = extract_negated_literals(hypothesis)
                            if negated_lits:
                                last_feedback += f"\n### Negated Literals (Closed World Assumption)\n"
                                for neg_lit in negated_lits:
                                    # Extract predicate from negated literal
                                    import re
                                    pred_match = re.match(r'(\w+)\s*\(', neg_lit)
                                    if pred_match:
                                        pred = pred_match.group(1)
                                        if pred in neg_facts_dict:
                                            last_feedback += f"- `\\+ {neg_lit}` **FAILED** (facts exist: {neg_facts_dict[pred][:2]})\n"
                                        else:
                                            last_feedback += f"- `\\+ {neg_lit}` **SUCCEEDED** under CWA (no {pred}/1 facts for this example)\n"
                            
                            # Show ALL relevant facts for predicates used in hypothesis
                            last_feedback += f"\n### Relevant Facts for `{first_neg}` (by predicate)\n"
                            last_feedback += "```prolog\n"
                            for pred in sorted(hyp_predicates):
                                if pred in neg_facts_dict:
                                    for fact in neg_facts_dict[pred][:5]:
                                        last_feedback += f"{fact}\n"
                                else:
                                    last_feedback += f"% No {pred}/1 or {pred}/2 facts for this example\n"
                            last_feedback += "```\n"
                            
                            # Find predicates missing from this negative (CWA candidates)
                            missing_preds = find_missing_predicates(hyp_predicates, neg_facts_dict)
                            if missing_preds:
                                last_feedback += f"\n**Predicates ABSENT in this negative (CWA):** {', '.join(missing_preds)}\n"
                            
                            # Generate specific candidate refinements
                            pos_facts_list = [extract_all_facts_for_example(bk_content, p) for p in list(result.covered_pos)[:3]]
                            candidates = generate_candidate_refinements(hyp_predicates, neg_facts_dict, pos_facts_list)
                            
                            if candidates:
                                last_feedback += "\n### Candidate Refinements (evidence-based)\n"
                                last_feedback += "Add ONE of these literals to block this negative:\n"
                                for idx, c in enumerate(candidates, 1):
                                    last_feedback += f"{idx}. `{c['literal']}` — {c['rationale']}\n"
                        
                        last_feedback += "\n---\n"
                        last_feedback += """## Next Attempt Request
Provide a refined hypothesis that:
- Adds ONE discriminating literal to exclude the counterexample
- Each clause on ONE LINE with proper Prolog syntax
- Ensure all variables are connected to the head variable
"""
                        st.error(fail_msg)
                        with st.expander("Wrongly covered negatives"):
                            for neg in list(result.covered_neg)[:5]:
                                st.code(neg, language="prolog")
                            if len(result.covered_neg) > 5:
                                st.write(f"... and {len(result.covered_neg) - 5} more")
                                
                    elif result.is_too_specific:
                        # Extract predicates used in hypothesis
                        hyp_predicates = extract_predicates_from_hypothesis(hypothesis)
                        clauses = parse_prolog_clauses(hypothesis)
                        
                        # Key missed examples
                        last_feedback += "\n## SECTION B: Missed Positives (Hypothesis is Too Specific)\n"
                        last_feedback += "\n### Key Missed Positives\nThe hypothesis failed to cover these valid examples:\n"
                        for pos in list(result.missed_pos)[:5]:
                            last_feedback += f"- `{pos}`\n"
                        if len(result.missed_pos) > 5:
                            last_feedback += f"- ... and {len(result.missed_pos) - 5} more\n"
                        
                        # Detailed analysis for first missed positive
                        first_missed = list(result.missed_pos)[0] if result.missed_pos else None
                        if first_missed:
                            # Get ALL facts for this example organized by predicate
                            missed_facts_dict = extract_all_facts_for_example(bk_content, first_missed)
                            
                            last_feedback += f"\n### Trace of Failure for `{first_missed}`\n"
                            last_feedback += "Your hypothesis FAILED because at least one condition was NOT satisfied.\n\n"
                            
                            # Show each clause
                            last_feedback += "**Clauses to check:**\n"
                            for idx, clause in enumerate(clauses):
                                last_feedback += f"- Clause {idx+1}: `{clause}`\n"
                            
                            # Show ALL relevant facts for predicates used in hypothesis
                            last_feedback += f"\n### Relevant Facts for `{first_missed}` (by predicate)\n"
                            last_feedback += "```prolog\n"
                            for pred in sorted(hyp_predicates):
                                if pred in missed_facts_dict:
                                    for fact in missed_facts_dict[pred][:5]:
                                        last_feedback += f"{fact}\n"
                                else:
                                    last_feedback += f"% No {pred}/1 or {pred}/2 facts for this example\n"
                            last_feedback += "```\n"
                            
                            # Find predicates missing from this positive (might explain failure)
                            missing_preds = find_missing_predicates(hyp_predicates, missed_facts_dict)
                            if missing_preds:
                                last_feedback += f"\n**Predicates ABSENT in this positive:** {', '.join(missing_preds)}\n"
                                last_feedback += "If your hypothesis requires any of these, it will FAIL for this example.\n"
                        
                        last_feedback += "\n### Refinement Options\n"
                        last_feedback += "1. **Generalize:** Remove a literal that is NOT satisfied by the missed positive\n"
                        last_feedback += "2. **Branch (Disjunction):** Add a NEW separate clause that covers this pattern\n"
                        
                        last_feedback += "\n---\n"
                        last_feedback += """## Next Attempt Request
Provide a refined hypothesis that:
- Either generalizes the current clause (remove failing literal), OR
- Adds a NEW clause to cover the alternative pattern
- Each clause on ONE LINE with proper Prolog syntax
- Ensure all variables are connected to the head variable
"""
                        st.warning(fail_msg)
                        with st.expander("Missed positives"):
                            for pos in list(result.missed_pos)[:5]:
                                st.code(pos, language="prolog")
                            if len(result.missed_pos) > 5:
                                st.write(f"... and {len(result.missed_pos) - 5} more")
                    else:
                        last_feedback += f"\n## Problem: Mixed failure (both too general and too specific)\n"
                        st.warning(fail_msg)
                    
                    # Add per-clause coverage to feedback (for disjunctive hypotheses)
                    if per_clause_feedback:
                        last_feedback += "\n" + per_clause_feedback
                    
                    last_feedback += "\n---\n**Provide your refined hypothesis in a ```prolog code block.**"
                    
                    st.session_state.messages.append({"role": "user", "content": fail_msg})
                    
                    # Update best hypothesis if it covers something
                    if len(result.covered_pos) > 0:
                        st.session_state.best_hyp = hypothesis
                    
                    # Track failure for next iteration
                    failed_hypotheses.append((hypothesis, fail_msg))
                    learned_constraints.extend(constraints)
                    
                    # Update iteration metrics for failure
                    if result.is_too_general:
                        iter_metrics["result"] = "too_general"
                        status_icon = "🔴"
                        status_text = "Too General"
                        log_message(f"Iteration {i+1} failed: Too General (Covered {len(result.covered_neg)} negatives)")
                    elif result.is_too_specific:
                        iter_metrics["result"] = "too_specific"
                        status_icon = "🟡"
                        status_text = "Too Specific"
                        log_message(f"Iteration {i+1} failed: Too Specific (Missed {len(result.missed_pos)} positives)")
                    else:
                        iter_metrics["result"] = "failed"
                        status_icon = "⚪"
                        status_text = "Failed"
                        log_message(f"Iteration {i+1} failed: Mixed failure")
                    
                    st.session_state.metrics["iterations"].append(iter_metrics)
                    st.session_state.metrics["total_iterations"] = i + 1
                    
                    # Save metrics after each iteration (in case agent is stopped)
                    try:
                        metrics_file = os.path.join(task_dir, "metrics.json")
                        with open(metrics_file, 'w', encoding='utf-8') as f:
                            json.dump(st.session_state.metrics, f, indent=2)
                    except:
                        pass
                    
                    # Update real-time status for failure
                    with realtime_status.container():
                        st.error(f"{status_icon} Iteration {i+1} - {status_text}")
                        st.code(hypothesis, language="prolog")
                        st.write(f"**Pos:** {iter_metrics['covered_pos']}/{iter_metrics['covered_pos'] + iter_metrics['missed_pos']} | **Neg:** {iter_metrics['covered_neg']}")
                        m = st.session_state.metrics
                        st.write(f"**Prolog Tests:** {m['total_prolog_tests']} | **Subsumption:** {m['total_subsumption_checks']}")

            # Rate limit
            time.sleep(1)
        
        # Finalize and save metrics
        st.session_state.metrics["end_time"] = datetime.now().isoformat()
        st.session_state.metrics["total_time_seconds"] = round(time.time() - run_start_time, 3)
        
        # Save metrics to JSON file
        metrics_file = os.path.join(task_dir, "metrics.json")
        try:
            with open(metrics_file, 'w', encoding='utf-8') as f:
                json.dump(st.session_state.metrics, f, indent=2)
            st.success(f"📊 Metrics saved to: {metrics_file}")
            log_message(f"Run completed. Metrics saved to {metrics_file}")
        except Exception as e:
            st.error(f"Failed to save metrics: {e}")
            log_message(f"Error saving metrics: {e}")
        
        # Mark as not running anymore
        st.session_state.is_running = False
        
        # Clean up context cache if it was created
        if context_cache:
            delete_context_cache(api_key, context_cache)
            
        if not st.session_state.solved:
            st.warning("Max iterations reached without complete solution.")
            log_message("Run finished: Max iterations reached without solution.")
            
            # Show best partial solution (MDL approach like Popper)
            if best_partial_hyp:
                st.info("📊 **Best Partial Solution (MDL):**")
                st.code(best_partial_hyp, language="prolog")
                stats = best_partial_stats
                st.write(f"**MDL Cost:** {stats['cost']} (size={stats['size']} + fp={stats['fp']} + fn={stats['fn']})")
                st.write(f"**F1 Score:** {stats['f1']:.2f} | **TP:** {stats['tp']} | **FP:** {stats['fp']} | **FN:** {stats['fn']}")
                log_message(f"Best partial solution: cost={stats['cost']}, F1={stats['f1']:.2f}")
                
                # Save best partial to metrics
                st.session_state.metrics["best_partial"] = {
                    "hypothesis": best_partial_hyp,
                    "mdl_cost": stats['cost'],
                    "f1_score": stats['f1'],
                    "tp": stats['tp'],
                    "fp": stats['fp'],
                    "fn": stats['fn'],
                    "size": stats['size']
                }
                
                # Update metrics file with best partial
                try:
                    with open(metrics_file, 'w', encoding='utf-8') as f:
                        json.dump(st.session_state.metrics, f, indent=2)
                except:
                    pass
