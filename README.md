# Does a Fable 5 "skill" make a cheap model write commits like a frontier model?

Short answer on this task: yes, and it fixes the frontier models too.

I used Hugging Face's [`upskill`](https://github.com/huggingface/upskill) to have Claude
Fable 5 write a `SKILL.md` for Conventional Commits, then measured three models with and
without it: Haiku 4.5, Sonnet 4.6, Opus 4.8. Same 5 test cases, 5 runs each, scored on
literal keyword checks.

## Numbers

| Model | No skill (avg of 5 runs) | With skill |
|---|---|---|
| Haiku 4.5 | 76% | 100% |
| Sonnet 4.6 | 76% | 100% |
| Opus 4.8 | 88% | 100% |

Per-run data in [`benchmark.csv`](benchmark.csv), full tool output in [`raw_logs/`](raw_logs/).

## What happened

Without the skill, every model intermittently misses one case — usually writing `Fixes #482`
where the spec wants `Closes #482`, or dropping the scope or the `BREAKING CHANGE:` footer.
That's not a reasoning gap, it's not knowing the exact convention, so even Opus 4.8 trips on
it some runs. Prepend the skill and all three pass five out of five, every run.

So the skill buys consistency against a strict spec, and it pulls Haiku up to the same 100%
Opus reaches. It does not make Haiku smarter in general — this only works where the limit is
knowing a convention, not thinking harder.

## Cost

The skill is about 1.2k words and rides on every request, so token use climbs 400–700% per
call. On a cheap model that's still well under frontier pricing, but it isn't free.

## Caveats

Five cases, five runs. The baseline swings between 60% and 100% across runs because one case
sits right on the pass/fail line, so read the averages, not any single run.

## Run it yourself

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
export ANTHROPIC_API_KEY=sk-ant-...

git clone https://github.com/huggingface/upskill && cd upskill
cp -r ../fable-upskill-commit-benchmark/skills ./skills

uv run upskill eval ./skills/conventional-commit-messages/ \
  --tests ./skills/conventional-commit-messages/tests.json -m haiku -v
```

Full sweep: [`run_benchmark.sh`](run_benchmark.sh).

## Credits

Skill written by Claude Fable 5. Harness by Hugging Face (`upskill`).
