# Experiments

Recorded ALBI runs across three LLM providers and two background-knowledge conditions.

## Layout

```
experiments/<provider>/<condition>/<task>/
```

- **provider** — `Claude`, `GMINI` (Gemini), `GPT`
- **condition** — `semantic` (original, meaningful predicate names) or
  `anomized` (anonymised predicate names, to test whether the LLM is exploiting
  natural-language semantics rather than performing induction)

## Files per task

| File | Description |
|------|-------------|
| `bias.pl` | declaration bias — allowed head/body predicates, types, clause limits |
| `bk.pl` | background knowledge available to the hypothesis |
| `exs.pl` | positive and negative examples |
| `hypothesis.pl` | best hypothesis found by the run |
| `metrics.json` | per-iteration metrics (coverage, timings, iteration count) |
| `mapping.json` | anonymised → original predicate name map (`anomized` condition only) |

## Coverage

| Provider | Condition | Tasks | hypothesis.pl | metrics.json | mapping.json |
|----------|-----------|-------|---------------|--------------|--------------|
| Claude | anomized  | 31 | 31 | 31 | 29 |
| Claude | semantic  | 30 | 30 | 30 | –  |
| GMINI  | anomized  | 31 | 30 | 30 | 30 |
| GMINI  | semantic  | 30 | 30 | 30 | –  |
| GPT    | anomized  | 31 | 31 | 31 | 29 |
| GPT    | semantic  | 30 | 30 | 30 | –  |

183 task directories, 1007 files.

Known gaps:

- `GMINI/anomized/iggp-coins-next-cell` has inputs but no recorded result.
- Two `anomized` tasks per provider lack a `mapping.json` (29 of 31 for Claude and GPT).
- `GMINI/*/full/` holds a few loose result JSONs that are not structured as task
  directories; they are kept as-is.

Task families: `iggp-*` (General Game Playing), `synthesis-*` (list/program synthesis),
`zendo1-3`, `kinship-*`, `robots-*`, `1d_flip`, `1d_pcopy_1c`, `andersen`.
