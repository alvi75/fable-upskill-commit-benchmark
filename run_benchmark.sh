#!/usr/bin/env bash
# Reproduce the benchmark: baseline vs Fable's skill, 5 runs per model.
# Prereqs: uv installed, ANTHROPIC_API_KEY exported, run from inside a clone of
# https://github.com/huggingface/upskill with this repo's ./skills copied in.
set -euo pipefail

SKILL=./skills/conventional-commit-messages/
TESTS=./skills/conventional-commit-messages/tests.json
MODELS=("haiku" "anthropic.claude-opus-4-8" "sonnet")

echo "model,run,baseline_pct,withskill_pct"
for M in "${MODELS[@]}"; do
  for R in 1 2 3 4 5; do
    P=$(uv run upskill eval "$SKILL" --tests "$TESTS" -m "$M" 2>&1 \
        | grep -E 'baseline|with skill' | grep -oE '[0-9]+%' | tr -d '%' | tr '\n' ' ')
    echo "$M,$R,$(echo "$P" | awk '{print $1}'),$(echo "$P" | awk '{print $2}')"
  done
done
