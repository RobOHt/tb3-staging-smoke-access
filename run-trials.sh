#!/usr/bin/env bash
# Local equivalent of the Terminal Bench 3 CI /run and /cheat trials for the
# Claude agent, using a Claude subscription token instead of an API key (per
# the assignment doc).
#
# Agent/model/kwargs/env mirror ci/harbor-run-defaults.yml (copied from
# terminal-bench-3/.github). /cheat appends ci/hack-trial-prompt.md (copied from
# terminal-bench-3/docs/prompts) to the instruction, the same way CI's
# scripts/ci/hosted_job_config.py sets extra_instructions.
#
# Usage: ./run-trials.sh run|cheat
set -euo pipefail
cd "$(dirname "$0")"
export PATH="$HOME/.local/bin:$PATH"

KIND="$1"
if [ "$KIND" = run ]; then
  ATTEMPTS=3; EXTRA=()
else
  ATTEMPTS=1; EXTRA=(--extra-instruction-path ci/hack-trial-prompt.md)
fi

TOKEN="$(cat ~/.tb3-claude-oauth-token)"
harbor run -p staging-smoke-access --env docker --yes \
  -o "$PWD/results/$KIND-claude" -k "$ATTEMPTS" -n "$ATTEMPTS" \
  --agent claude-code --model anthropic/claude-fable-5-1 --ak reasoning_effort=max \
  --ae CLAUDE_CODE_MAX_OUTPUT_TOKENS=128000 \
  --ae CLAUDE_FORCE_OAUTH=1 --ae CLAUDE_CODE_OAUTH_TOKEN="$TOKEN" \
  ${EXTRA[@]+"${EXTRA[@]}"}
