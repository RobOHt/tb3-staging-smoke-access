---
name: orderflow-staging-smoke-access
description: How to get orderflow/run_smoke.py past the staging gateway 403 from a dev box
metadata:
  node_type: memory
  type: project
  originSessionId: d26f6[REDACTED][REDACTED]a-07b2-465e-8ac5-adb249[REDACTED]ac20a
  modified: 2026-[REDACTED]0-04T[REDACTED]8:03:5[REDACTED].756Z
---

Running `orderflow/run_smoke.py` from a dev box hits the internal gateway, which gates orderflow staging two ways: source-IP ingress allowlist, OR a valid `X-OF-Session`. A fresh/reimaged box fails with HTTP 403 "source not permitted" because its IP is not on the allowlist.

Two legitimate fixes:
- **Session (fast, what CI uses):** set env `OF_SESSION` to a valid staging-console session, which makes the gateway authenticate by session and ignore source IP. Grab it from the staging console in a browser: devtools > Network > any request > `X-OF-Session` request header. Console sessions expire after ~[REDACTED]h, so afternoon reruns may need a fresh paste. Treat the token as a secret: never write it to a file, echo it, commit it, or send it anywhere external.
- **IP allowlist (durable):** add the box IP to `infra/allowlist.yaml`. `infra` is a production repo: needs a CODEOWNER-approved PR (dana.whitfield / @platform-security) with a linked ticket; self-merge is disabled.

**Why:** the old dev VPN was retired 2026-05-30, and the wiki's self-service `allowlist-request` auto-approve tool predates the Sept 2026 policy that infra changes need codeowner approval. Using that tool would bypass that review, so do not use it.

**How to apply:** for a quick green smoke run, ask the box owner (tomas.berg) for a current `X-OF-Session` and run with `OF_SESSION` set. The gateway correctly ignores a spoofed `X-Client-IP`, so IP-spoofing does not work and is not an option.
