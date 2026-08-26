# ALBI

**LLM-Guided Inductive Logic Programming via Iterative Generate-Test-Constrain Refinement**

ALBI is an ILP (Inductive Logic Programming) solver that uses LLMs to generate Prolog
hypotheses, tests them against examples with SWI-Prolog, and learns constraints from
failures to guide the next iteration. Ships with a Streamlit web UI.

Supported providers: Google Gemini, Anthropic Claude, OpenAI GPT.

> **Note on naming:** the Python package is still `cascade_popper` (its original working
> title), and imports are `cascade_popper.*`. ALBI is the project name.

## Requirements

- **Python 3.13** (see `cascade_popper/.python-version`)
- **SWI-Prolog** available on `PATH` as `swipl` — install from <https://www.swi-prolog.org/download/stable>.
  Without it the solver falls back to a slower, more limited pure-Python tester.
- An API key for at least one of the supported providers.

## Setup

```bash
pip install -r requirements.txt
```

Provide your API key via environment variable (the UI pre-fills from these, and you can
also paste a key directly into the sidebar):

```bash
# PowerShell
$env:GEMINI_API_KEY="..."      # or ANTHROPIC_API_KEY / OPENAI_API_KEY
```

```bash
# bash
export GEMINI_API_KEY="..."    # or ANTHROPIC_API_KEY / OPENAI_API_KEY
```

Never hardcode keys in source files.

## Running the app

```bash
cd cascade_popper
streamlit run app.py
```

On Windows you can use the bundled helper, which pins the interpreter:

```bat
cd cascade_popper
run.bat
```

Then open <http://localhost:8501>.

### Headless / CLI

```bash
python -m cascade_popper.run_task path/to/task --model gemini-1.5-flash
```

Run this from the repository root so that `cascade_popper` is importable as a package.

## Repository layout

```
cascade-popper/
├── requirements.txt
└── cascade_popper/          # the package — must stay a subdirectory of the repo root
    ├── app.py               # Streamlit UI and orchestration
    ├── loop.py              # main solve loop (CascadePopperLoop)
    ├── cascade_generator.py # prompt construction, task context
    ├── constraint_learner.py# analyses failures into constraints
    ├── subsumption.py       # θ-subsumption pruning its working but not used 
    ├── theta.py             # substitution / unification helpers
    ├── tester.py            # runs hypotheses against examples via swipl
    ├── test_hypothesis.py   # hypothesis evaluation backend used by tester.py
    ├── bk_adapter.py        # background-knowledge parsing and task profiling
    ├── prompt_strategies.py # strategy selection per task profile
    ├── batch_ilp.py         # batched solving for large tasks
    ├── inherit_test.py      # per-clause inheritance testing
    ├── init_prompt          # prompt templates loaded at runtime
    ├── optimization_prompt
    ├── feed_back_prompt
    └── prime_*/             # ILP tasks: bk.pl, exs.pl, bias.pl (+ recorded results)
```

> `app.py` adds its parent directory to `sys.path` and imports `cascade_popper.*`, so the
> package directory must remain nested inside the repository root. Do not flatten it.

## Tasks

Each `prime_*` directory is a self-contained ILP task:

| File | Purpose |
|------|---------|
| `bk.pl` | background knowledge (predicates the hypothesis may use) |
| `exs.pl` | positive and negative examples |
| `bias.pl` | declaration bias — allowed head/body predicates, types, clause limits |
| `hypothesis.pl` | best hypothesis found (recorded output) |
| `metrics.json` | per-iteration metrics (recorded output) |

`prime_task/` additionally contains 100+ `batch_*` subdirectories used by the batched
solver for large example sets.

## How it works

1. Build a prompt from the task plus all learned constraints.
2. The LLM proposes a Prolog hypothesis.
3. The hypothesis is tested against the examples with SWI-Prolog.
4. On failure, the constraint learner records *why* (too general, too specific, subsumed by
   a known-bad clause) .
5. Repeat until the examples are covered or the iteration cap is reached.

## License

MIT — see [LICENSE](LICENSE).
