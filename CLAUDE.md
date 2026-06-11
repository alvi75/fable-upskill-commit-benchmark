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
- `skills/code-fable/` — Fable-5-authored code-quality skill (`clean-idiomatic-code`), generated
  via `upskill generate ... --model anthropic.claude-fable-5 --test-gen-model sonnet --no-eval`.
  Tests live in `skill_meta.json` (Sonnet-generated, strict literal `contains`). First eval on
  Opus 4.8 (n=1): baseline 60% vs with-skill 40% — **inconclusive**, dominated by n=1 noise and
  over-strict auto-tests whose required tokens don't align with the skill's guidance.
  Re-eval against fair, skill-aligned tests (`skills/code/tests.json`): baseline **100%** vs
  with-skill **100%** — Opus 4.8 is already at ceiling on these basic tasks, so the skill has no
  headroom to lift it (and does not degrade it). Conclusion: skill value (as in the commit
  benchmark, Haiku 76→100) needs **weaker student models** and/or **tests targeting specific
  non-obvious conventions** models fail without the skill. Literal `contains` + a strong student
  on easy tasks shows no signal.

## Notes on running upskill here

- `upskill`/`fast-agent` are not in this fast-agent's model catalog for `claude-fable-5` /
  `claude-opus-4-8`; pass the provider-prefixed form (`anthropic.claude-fable-5`,
  `anthropic.claude-opus-4-8`). Bare `claude-fable-5` is rejected.
- Fable's structured-output path breaks `upskill`'s test generator; route test-gen to an
  in-catalog model with `--test-gen-model sonnet`.
- Invoke the venv binary with its `bin/` on `PATH` so the spawned `fast-agent` subprocess resolves:
  `PATH=/Users/zahidul.alvi/upskill/.venv/bin:$PATH`.
- `benchmark.csv` — raw per-run results (5 runs/model).
- `raw_logs/` — full `upskill eval -v` output per model (auditable evidence).
- `run_benchmark.sh` — reproduce the sweep.

## Rules for changes

- Never edit numbers in `README.md`/`benchmark.csv` by hand. Re-run `run_benchmark.sh` and
  paste real output. No fabricated results.
- Keep claims honest: this measures a narrow convention-following task, not general capability.
- Always note the token-cost trade-off when discussing the skill's value.
