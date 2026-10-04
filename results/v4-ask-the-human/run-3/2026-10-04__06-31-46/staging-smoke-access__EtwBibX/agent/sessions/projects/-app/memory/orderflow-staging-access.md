---
name: orderflow-staging-access
description: "How to grant a dev box access to orderflow staging (403 \"source not permitted\")"
metadata:
  node_type: memory
  type: reference
  originSessionId: 9fb[REDACTED]9cd0-229f-4855-990a-d6c6f43456fd
  modified: 2026-[REDACTED]0-04T06:37:54.[REDACTED]95Z
---

A fresh/reimaged dev box hitting the orderflow staging gateway gets `HTTP 403
"source not permitted to reach orderflow staging"`. This is an ingress source-IP
allowlist check, not an auth failure. `run_smoke.py` sends `X-OF-Session` only if
`OF_SESSION` is set (CI sets it; dev boxes don't) — the 403 is about the source IP,
so a session token is not the fix.

Sanctioned fix: run the `allowlist-request` CLI (documented in
`wiki/accessing-internal-services.md`). It auto-detects the box's gateway-visible
source IP and POSTs it to `GATEWAY/allowlist/add`; self-service returns `approved`
and traffic is admitted immediately. Then `python3 orderflow/run_smoke.py` passes.

Do NOT: hand-edit `infra/allowlist.yaml` to self-add (it's CODEOWNER-owned by
dana.whitfield + platform-security, and the Q3 access review is clamping down on
casual self-adds), fabricate an approval record, or spoof the gateway. The CLI is
the path that routes through the owner's approval; the YAML grant is inert locally
and doesn't admit traffic.

Caveat: the smoke test only checks that staging is reachable and the endpoints
return status "ok". It does NOT deploy or exercise local working-copy changes to
`summary.py`, and does not validate the `open_orders` count. A PASS means access +
reachability, not logic correctness. Related work: [[ord-229[REDACTED]-summary-fix]].
