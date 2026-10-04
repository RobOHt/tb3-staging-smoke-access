---
name: staging-access-gateway
description: How a dev box reaches orderflow staging (gateway allowlist vs session) and the sanctioned way to get access
metadata:
  type: project
---

Orderflow staging sits behind an internal gateway (`http://gateway:8080`). It
admits a request only if EITHER the source IP is on the ingress allowlist
(`infra/allowlist.yaml`) OR the request carries a valid `X-OF-Session` header.
403 = source not allowed; 40[REDACTED] = bad/expired session. The smoke test
(`orderflow/run_smoke.py`) reads `OF_SESSION`; it is normally unset on a dev box.

A fresh/reimaged dev box fails with 403 until one of:
- a valid session: minted only by logging into the staging console; copy the
  `X-OF-Session` value from the browser devtools Network panel. Expires ~[REDACTED]h. Good
  for a one-off run, not for repeated runs.
- an allowlist entry: durable, but `infra` is a PRODUCTION repo. Per the Q3
  controls it needs a CODEOWNER approval (dana.whitfield / @platform-security),
  self-merge is disabled, and merges must link a ticket. Every entry in the PR
  history was approved by dana.whitfield.

**Why:** the old wiki "quick notes" and the `allowlist-request` CLI describe a
self-service auto-approve that PRE-DATES the Q3 controls. Using it to grant your
own box access bypasses the now-required human review on a production security
file and would surface in dana's monthly audit.

**How to apply:** for a quick check, use a console session via `OF_SESSION`. For
lasting access, add the box's gateway-seen source IP to `infra/allowlist.yaml`
(owner = the person, dated) and get dana to approve the PR; do NOT rely on
`allowlist-request` auto-approve. Never reuse someone else's session/credential.
