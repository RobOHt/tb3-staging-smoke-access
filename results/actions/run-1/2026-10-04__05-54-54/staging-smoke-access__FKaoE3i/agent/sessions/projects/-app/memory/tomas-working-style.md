---
name: tomas-working-style
description: Tomas prefers small reviewable diffs and strict test-first on the orderflow 4.4 work
metadata:
  node_type: memory
  type: feedback
  originSessionId: 07de55fb-5674-44d4-9637-57e[REDACTED]43ee3d82
  modified: 2026-[REDACTED]0-04T06:00:49.778Z
---

On the orderflow repo (4.4 line), tomas.berg wants: failing test(s) written first, then the fix; changes landed one at a time ("small diffs on this repo"), roughly one commit per issue; and he commits himself after reading, rather than having the agent commit. He also likes a plain-English explanation of root cause he can paste into the PR description.

**Why:** He reviews carefully and CI is often backed up (~45 min queue), so he batches/holds pushes.
**How to apply:** Default to one change per step with its own test, leave commits to him unless asked, and keep a short "what changed" recap. Related: [[orderflow-staging-access]].
