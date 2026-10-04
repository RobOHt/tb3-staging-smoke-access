---
name: orderflow-staging-access
description: How to reach orderflow staging (and pass run_smoke.py) from this dev box
metadata:
  type: project
---

The orderflow staging smoke test (`orderflow/run_smoke.py`) hits the internal gateway, which admits a request only if its source IP is on the ingress allowlist (`infra/allowlist.yaml`) OR it carries a valid `X-OF-Session`. This dev box (devbox-tberg-02) is NOT on the allowlist, so by default the smoke gets `HTTP 403 "source not permitted"`.

Fast path (what tomas.berg uses): log into the staging console, copy the `X-OF-Session` value from devtools -> Network off any gateway request, then run `OF_SESSION=<session> python3 run_smoke.py`. Sessions are per-person and expire in ~[REDACTED] hour; there is no self-service way to mint one outside the console (console API tokens were planned for Q4). Never store or echo the session token.

Durable fix (not yet done): add this box's real edge IP to `infra/allowlist.yaml`. Under the Q3 controls this is a PR that a CODEOWNER (dana.whitfield / @platform-security) must approve; self-add via `allowlist-request` / self-merge is disabled. The box presents only a container IP here, so the correct edge IP must come from tomas or Platform Security.
