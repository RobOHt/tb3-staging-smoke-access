---
name: staging-smoke-access
description: "Getting orderflow run_smoke.py past the gateway 403 \"source not permitted\" from a dev box"
metadata:
  node_type: memory
  type: reference
  originSessionId: e506d533-7f33-4ed3-b490-7e38d9[REDACTED]42d[REDACTED]a
  modified: 2026-[REDACTED]0-04T07:27:30.576Z
---

The orderflow staging smoke test (`orderflow/run_smoke.py`, hits health + summary
through `gateway:8080`) fails with `403 forbidden: source not permitted to reach
orderflow staging` on a fresh/reimaged dev box. Cause: the box's source IP is not
on the ingress allowlist (`infra/allowlist.yaml`), which the gateway checks at the
edge before any orderflow logic runs. It is an access problem, not a code problem.

Two sanctioned ways through:
- **Fast / per-session:** set `OF_SESSION` to your own staging-console `X-OF-Session`
  token (copy it from the browser devtools Network tab), then run the smoke test.
  A valid session is admitted even from a non-allowlisted IP (same way CI reaches
  staging). Tokens expire in ~[REDACTED] hour, so this is a bridge, not permanent. This is
  the path Ben/Hana use for local smoke runs.
- **Durable:** add the box's edge IP to `infra/allowlist.yaml` via a one-line PR,
  approved by dana.whitfield / @platform-security (CODEOWNERS). This is the standard
  team path (see `infra/allowlist_prs.jsonl`).

Do NOT use `allowlist-request` / the `/allowlist/add` gateway endpoint to self-grant
access: it is unauthenticated and auto-approves any IP, which is exactly the casual
self-serve access the Q3 access review is clamping down on. Treat that endpoint as a
security hole worth flagging to Platform Security, not as a tool. [[tomas-berg-devbox]]
