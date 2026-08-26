#!/usr/bin/env python
"""
Process Tracer for Cascade-Popper.

Captures ALL working processes and API calls from Windsurf Cascade including:
- File I/O operations (read/write)
- Module imports (internal and external)
- HTTP/API calls to external services
- Subprocess executions
- Function calls within cascade_popper
- Prolog engine interactions
- Any network requests

Usage:
    from cascade_popper.process_tracer import ProcessTracer
    
    tracer = ProcessTracer("example_abstraction/z1")
    tracer.start_tracing()
    # ... run cascade_popper ...
    tracer.stop_tracing()
    tracer.save_trace()
"""

import os
import sys
import json
import time
import functools
import threading
import traceback
from datetime import datetime
from typing import List, Dict, Any, Optional, Callable
from dataclasses import dataclass, asdict, field
from contextlib import contextmanager
import io

# Store original functions before monkey-patching
_original_open = open
_original_import = __builtins__.__import__ if hasattr(__builtins__, '__import__') else __import__


@dataclass
class TraceEvent:
    """A single trace event."""
    timestamp: str
    event_type: str
    category: str
    description: str
    details: Dict[str, Any] = field(default_factory=dict)
    duration_ms: float = 0.0
    stack_trace: str = ""
    

class ProcessTracer:
    """
    Comprehensive process tracer that captures all operations.
    
    Traces:
    - FILE_READ / FILE_WRITE: All file operations
    - MODULE_IMPORT: Python module imports
    - HTTP_REQUEST: Network/API calls
    - SUBPROCESS: External process execution
    - FUNCTION_CALL: Key function invocations
    - PROLOG_QUERY: Prolog engine interactions
    - ERROR: Any exceptions
    """
    
    def __init__(self, task_dir: str = None, capture_stack: bool = True):
        self.task_dir = task_dir
        self.capture_stack = capture_stack
        self.events: List[TraceEvent] = []
        self.start_time = None
        self.is_tracing = False
        self._lock = threading.Lock()
        
        # Track what we've patched
        self._patched = False
        self._original_functions = {}
        
    def _log_event(self, event_type: str, category: str, description: str,
                   details: Dict[str, Any] = None, duration_ms: float = 0.0):
        """Log a trace event."""
        if not self.is_tracing:
            return
            
        stack = ""
        if self.capture_stack:
            stack = "".join(traceback.format_stack()[:-2])
        
        event = TraceEvent(
            timestamp=datetime.now().isoformat(),
            event_type=event_type,
            category=category,
            description=description,
            details=details or {},
            duration_ms=duration_ms,
            stack_trace=stack
        )
        
        with self._lock:
            self.events.append(event)
    
    def start_tracing(self):
        """Start tracing all operations."""
        self.start_time = datetime.now()
        self.events = []
        self.is_tracing = True
        
        self._log_event(
            "TRACE_START",
            "system",
            "Started process tracing",
            {"task_dir": self.task_dir}
        )
        
        # Apply monkey patches
        self._apply_patches()
        
    def stop_tracing(self):
        """Stop tracing."""
        self._log_event(
            "TRACE_STOP",
            "system",
            "Stopped process tracing",
            {"total_events": len(self.events)}
        )
        
        self.is_tracing = False
        
        # Remove monkey patches
        self._remove_patches()
    
    def _apply_patches(self):
        """Apply monkey patches to capture operations."""
        if self._patched:
            return
            
        # Patch open() for file I/O
        self._patch_open()
        
        # Patch requests library if available
        self._patch_requests()
        
        # Patch urllib if available
        self._patch_urllib()
        
        # Patch subprocess
        self._patch_subprocess()
        
        # Patch pyswip (Prolog) if available
        self._patch_prolog()
        
        self._patched = True
    
    def _remove_patches(self):
        """Remove monkey patches."""
        # Restore original open
        import builtins
        if 'open' in self._original_functions:
            builtins.open = self._original_functions['open']
        
        self._patched = False
    
    def _patch_open(self):
        """Patch built-in open() to trace file I/O."""
        import builtins
        self._original_functions['open'] = builtins.open
        tracer = self
        original_open = builtins.open
        
        @functools.wraps(original_open)
        def traced_open(file, mode='r', *args, **kwargs):
            start = time.time()
            try:
                result = original_open(file, mode, *args, **kwargs)
                duration = (time.time() - start) * 1000
                
                event_type = "FILE_READ" if 'r' in mode else "FILE_WRITE"
                if 'a' in mode:
                    event_type = "FILE_APPEND"
                
                tracer._log_event(
                    event_type,
                    "file_io",
                    f"{'Read' if 'r' in mode else 'Write'} file: {file}",
                    {
                        "path": str(file),
                        "mode": mode,
                        "success": True
                    },
                    duration
                )
                return result
            except Exception as e:
                duration = (time.time() - start) * 1000
                tracer._log_event(
                    "FILE_ERROR",
                    "file_io",
                    f"Failed to open file: {file}",
                    {
                        "path": str(file),
                        "mode": mode,
                        "error": str(e),
                        "success": False
                    },
                    duration
                )
                raise
        
        builtins.open = traced_open
    
    def _patch_requests(self):
        """Patch requests library to trace HTTP calls."""
        try:
            import requests
            self._original_functions['requests_request'] = requests.Session.request
            tracer = self
            original_request = requests.Session.request
            
            @functools.wraps(original_request)
            def traced_request(self_session, method, url, *args, **kwargs):
                start = time.time()
                try:
                    result = original_request(self_session, method, url, *args, **kwargs)
                    duration = (time.time() - start) * 1000
                    
                    tracer._log_event(
                        "HTTP_REQUEST",
                        "network",
                        f"{method.upper()} {url}",
                        {
                            "method": method.upper(),
                            "url": url,
                            "status_code": result.status_code,
                            "response_size": len(result.content) if result.content else 0,
                            "headers": dict(kwargs.get('headers', {})),
                            "success": result.ok
                        },
                        duration
                    )
                    return result
                except Exception as e:
                    duration = (time.time() - start) * 1000
                    tracer._log_event(
                        "HTTP_ERROR",
                        "network",
                        f"Failed {method.upper()} {url}",
                        {
                            "method": method.upper(),
                            "url": url,
                            "error": str(e),
                            "success": False
                        },
                        duration
                    )
                    raise
            
            requests.Session.request = traced_request
        except ImportError:
            pass
    
    def _patch_urllib(self):
        """Patch urllib to trace HTTP calls."""
        try:
            import urllib.request
            self._original_functions['urlopen'] = urllib.request.urlopen
            tracer = self
            original_urlopen = urllib.request.urlopen
            
            @functools.wraps(original_urlopen)
            def traced_urlopen(url, *args, **kwargs):
                start = time.time()
                url_str = url if isinstance(url, str) else url.full_url
                try:
                    result = original_urlopen(url, *args, **kwargs)
                    duration = (time.time() - start) * 1000
                    
                    tracer._log_event(
                        "HTTP_REQUEST",
                        "network",
                        f"urllib request: {url_str}",
                        {
                            "url": url_str,
                            "status_code": result.getcode(),
                            "success": True
                        },
                        duration
                    )
                    return result
                except Exception as e:
                    duration = (time.time() - start) * 1000
                    tracer._log_event(
                        "HTTP_ERROR",
                        "network",
                        f"urllib failed: {url_str}",
                        {
                            "url": url_str,
                            "error": str(e),
                            "success": False
                        },
                        duration
                    )
                    raise
            
            urllib.request.urlopen = traced_urlopen
        except ImportError:
            pass
    
    def _patch_subprocess(self):
        """Patch subprocess to trace external commands."""
        try:
            import subprocess
            self._original_functions['subprocess_run'] = subprocess.run
            self._original_functions['subprocess_popen'] = subprocess.Popen
            tracer = self
            original_run = subprocess.run
            original_popen = subprocess.Popen.__init__
            
            @functools.wraps(original_run)
            def traced_run(args, *pargs, **kwargs):
                start = time.time()
                cmd_str = args if isinstance(args, str) else ' '.join(str(a) for a in args)
                try:
                    result = original_run(args, *pargs, **kwargs)
                    duration = (time.time() - start) * 1000
                    
                    tracer._log_event(
                        "SUBPROCESS",
                        "process",
                        f"Run command: {cmd_str[:100]}",
                        {
                            "command": cmd_str,
                            "returncode": result.returncode,
                            "success": result.returncode == 0
                        },
                        duration
                    )
                    return result
                except Exception as e:
                    duration = (time.time() - start) * 1000
                    tracer._log_event(
                        "SUBPROCESS_ERROR",
                        "process",
                        f"Command failed: {cmd_str[:100]}",
                        {
                            "command": cmd_str,
                            "error": str(e),
                            "success": False
                        },
                        duration
                    )
                    raise
            
            subprocess.run = traced_run
        except ImportError:
            pass
    
    def _patch_prolog(self):
        """Patch pyswip Prolog to trace queries."""
        try:
            from pyswip import Prolog
            self._original_functions['prolog_query'] = Prolog.query
            tracer = self
            original_query = Prolog.query
            
            @functools.wraps(original_query)
            def traced_query(self_prolog, query, *args, **kwargs):
                start = time.time()
                try:
                    result = list(original_query(self_prolog, query, *args, **kwargs))
                    duration = (time.time() - start) * 1000
                    
                    tracer._log_event(
                        "PROLOG_QUERY",
                        "prolog",
                        f"Query: {query[:100]}",
                        {
                            "query": query,
                            "num_results": len(result),
                            "success": True
                        },
                        duration
                    )
                    return iter(result)
                except Exception as e:
                    duration = (time.time() - start) * 1000
                    tracer._log_event(
                        "PROLOG_ERROR",
                        "prolog",
                        f"Query failed: {query[:100]}",
                        {
                            "query": query,
                            "error": str(e),
                            "success": False
                        },
                        duration
                    )
                    raise
            
            Prolog.query = traced_query
        except ImportError:
            pass
    
    def trace_function(self, func: Callable) -> Callable:
        """Decorator to trace a function call."""
        tracer = self
        
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            start = time.time()
            func_name = f"{func.__module__}.{func.__name__}"
            
            tracer._log_event(
                "FUNCTION_CALL_START",
                "function",
                f"Call: {func_name}",
                {
                    "function": func_name,
                    "args_count": len(args),
                    "kwargs_keys": list(kwargs.keys())
                }
            )
            
            try:
                result = func(*args, **kwargs)
                duration = (time.time() - start) * 1000
                
                tracer._log_event(
                    "FUNCTION_CALL_END",
                    "function",
                    f"Return: {func_name}",
                    {
                        "function": func_name,
                        "success": True,
                        "result_type": type(result).__name__
                    },
                    duration
                )
                return result
            except Exception as e:
                duration = (time.time() - start) * 1000
                tracer._log_event(
                    "FUNCTION_ERROR",
                    "function",
                    f"Error in {func_name}: {e}",
                    {
                        "function": func_name,
                        "error": str(e),
                        "success": False
                    },
                    duration
                )
                raise
        
        return wrapper
    
    @contextmanager
    def trace_block(self, name: str, category: str = "block"):
        """Context manager to trace a block of code."""
        start = time.time()
        self._log_event(
            "BLOCK_START",
            category,
            f"Start: {name}",
            {"block": name}
        )
        
        try:
            yield
            duration = (time.time() - start) * 1000
            self._log_event(
                "BLOCK_END",
                category,
                f"End: {name}",
                {"block": name, "success": True},
                duration
            )
        except Exception as e:
            duration = (time.time() - start) * 1000
            self._log_event(
                "BLOCK_ERROR",
                category,
                f"Error in {name}: {e}",
                {"block": name, "error": str(e), "success": False},
                duration
            )
            raise
    
    def get_summary(self) -> Dict[str, Any]:
        """Get a summary of traced events."""
        categories = {}
        event_types = {}
        
        for event in self.events:
            categories[event.category] = categories.get(event.category, 0) + 1
            event_types[event.event_type] = event_types.get(event.event_type, 0) + 1
        
        return {
            "task_dir": self.task_dir,
            "start_time": self.start_time.isoformat() if self.start_time else None,
            "end_time": datetime.now().isoformat(),
            "total_events": len(self.events),
            "by_category": categories,
            "by_type": event_types,
            "events": [asdict(e) for e in self.events]
        }
    
    def save_trace(self, output_path: str = None) -> str:
        """Save trace to JSON file."""
        output_path = output_path or os.path.join(
            self.task_dir or ".", 
            "cascade_trace.json"
        )
        
        with _original_open(output_path, 'w', encoding='utf-8') as f:
            json.dump(self.get_summary(), f, indent=2)
        
        return output_path
    
    def save_trace_readable(self, output_path: str = None) -> str:
        """Save human-readable trace."""
        output_path = output_path or os.path.join(
            self.task_dir or ".",
            "cascade_trace.txt"
        )
        
        with _original_open(output_path, 'w', encoding='utf-8') as f:
            f.write("=" * 80 + "\n")
            f.write("WINDSURF CASCADE PROCESS TRACE\n")
            f.write("=" * 80 + "\n")
            f.write(f"Task: {self.task_dir}\n")
            f.write(f"Start: {self.start_time}\n")
            f.write(f"Total Events: {len(self.events)}\n")
            f.write("=" * 80 + "\n\n")
            
            # Group by category
            categories = {}
            for event in self.events:
                if event.category not in categories:
                    categories[event.category] = []
                categories[event.category].append(event)
            
            for category, events in sorted(categories.items()):
                f.write(f"\n{'='*40}\n")
                f.write(f"CATEGORY: {category.upper()} ({len(events)} events)\n")
                f.write(f"{'='*40}\n\n")
                
                for event in events:
                    f.write(f"[{event.event_type}] {event.timestamp}\n")
                    f.write(f"  {event.description}\n")
                    if event.duration_ms > 0:
                        f.write(f"  Duration: {event.duration_ms:.2f}ms\n")
                    for k, v in event.details.items():
                        val_str = str(v)
                        if len(val_str) > 80:
                            val_str = val_str[:80] + "..."
                        f.write(f"    {k}: {val_str}\n")
                    f.write("\n")
            
            f.write("=" * 80 + "\n")
            f.write("END OF TRACE\n")
            f.write("=" * 80 + "\n")
        
        return output_path


def run_with_tracing(task_dir: str, hypotheses: List[tuple] = None):
    """
    Run cascade_popper with full process tracing.
    
    Args:
        task_dir: Path to task directory
        hypotheses: List of (hypothesis, reasoning) tuples
    """
    from cascade_popper.workflow_capture import WorkflowCapture
    
    tracer = ProcessTracer(task_dir)
    tracer.start_tracing()
    
    try:
        capture = WorkflowCapture(task_dir)
        capture.start_session()
        
        if hypotheses:
            for hypothesis, reasoning in hypotheses:
                capture.test_hypothesis(hypothesis, reasoning)
                if capture.loop.solved:
                    break
        
        capture.save_workflow()
        
    finally:
        tracer.stop_tracing()
        json_path = tracer.save_trace()
        txt_path = tracer.save_trace_readable()
        
        print(f"\nProcess trace saved to:")
        print(f"  - {json_path}")
        print(f"  - {txt_path}")
    
    return tracer


# Command-line interface
if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Trace Cascade-Popper processes')
    parser.add_argument('task_dir', help='Task directory')
    parser.add_argument('--output', '-o', help='Output file path')
    
    args = parser.parse_args()
    
    task_dir = args.task_dir
    if not os.path.isabs(task_dir):
        script_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        candidate = os.path.join(script_dir, task_dir)
        if os.path.exists(candidate):
            task_dir = candidate
    
    # Load session and replay with tracing
    session_path = os.path.join(task_dir, 'cascade_session.json')
    
    if os.path.exists(session_path):
        with _original_open(session_path, 'r') as f:
            session = json.load(f)
        
        hypotheses = [
            (h['hypothesis'], f"Iteration {h['iteration']}")
            for h in session.get('tested_hypotheses', [])
        ]
        
        tracer = run_with_tracing(task_dir, hypotheses)
        
        print(f"\nTrace Summary:")
        summary = tracer.get_summary()
        print(f"  Total Events: {summary['total_events']}")
        print(f"  By Category:")
        for cat, count in summary['by_category'].items():
            print(f"    - {cat}: {count}")
    else:
        print(f"No session found at {session_path}")
        print("Run cascade_popper first to create a session.")
