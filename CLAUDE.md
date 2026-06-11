# CLAUDE.md

Project context for Claude Code working in this repo.

## What this is

A small, honest benchmark of LLM "skill transfer": a teacher model (Claude Fable 5) writes a
`SKILL.md`; cheap/student models (Haiku, Sonnet, Opus 4.8) are evaluated with and without it
on Conventional Commits, using Hugging Face's `upskill` tool.

## Files

- `skills/conventional-commit-messages/SKILL.md` — the Fable-authored skill (the artifact).
- `skills/conventional-commit-messages/tests.json` — 5 fixed test cases with literal assertions.
- `skills/code/SKILL.md` — general code-quality skill, structured as a router (Implementation /
  Refactoring / Debugging / Review) so one skill dispatches by task type. **Draft scaffold authored
  by Opus 4.8** to get a working file; the authoritative version should be regenerated with the
  teacher model (Fable 5), matching the methodology of the commit skill. Not yet benchmarked.
- `skills/code/tests.json` — 5 fixed cases with literal assertions targeting concrete, checkable
  markers (type hints, docstrings, guard clauses, specific exceptions). Broader code quality needs
  an LLM judge, which `upskill`'s `contains` grader does not provide — noted as a known limit.
- `benchmark.csv` — raw per-run results (5 runs/model).
- `raw_logs/` — full `upskill eval -v` output per model (auditable evidence).
- `run_benchmark.sh` — reproduce the sweep.

## Rules for changes

- Never edit numbers in `README.md`/`benchmark.csv` by hand. Re-run `run_benchmark.sh` and
  paste real output. No fabricated results.
- Keep claims honest: this measures a narrow convention-following task, not general capability.
- Always note the token-cost trade-off when discussing the skill's value.
