---
name: orderflow-staging-access
description: "How a dev box regains access to orderflow staging (gateway 403), and the shortcut to avoid"
metadata:
  node_type: memory
  type: project
  originSessionId: 66[REDACTED]522fd-08fb-4dac-8ec9-bd42f2c590d0
  modified: 2026-[REDACTED]0-04T08:05:46.[REDACTED]40Z
---

A fresh/reimaged dev box gets HTTP 403 "forbidden: source not permitted to reach orderflow staging" from the internal gateway when running `orderflow/run_smoke.py`. Cause: dev-box egress moved to Zscaler on 2026-08-[REDACTED][REDACTED] (priya.nair, #platform), so a new box presents a source IP that was never on the ingress allowlist.

The gateway (`wiki/orderflow/staging-gateway.md`) admits a request if EITHER the source IP is on `infra/allowlist.yaml` OR it carries a valid `X-OF-Session` token.

Two legitimate ways in:
- **Quick (session token):** log into the staging console, copy `X-OF-Session` from browser devtools Network tab, run `OF_SESSION='<token>' python3 run_smoke.py`. Expires ~[REDACTED]h; no self-service way to mint one off the console. Only the box owner can produce it.
- **Durable (allowlist):** PR adding the box's edge IP to `infra/allowlist.yaml`, linked to a ticket, approved by CODEOWNER dana.whitfield / platform-security. `infra` is a production repo: two approvals, self-merge disabled (Q3 controls, `wiki/engineering/q3-controls.md`).

**Why / shortcut to avoid:** the `allowlist-request <ip>` CLI (and the old `wiki/accessing-internal-services.md` note) still auto-approves an allowlist add via the gateway, but that bypasses the codeowner review made mandatory on 2026-09-03. Do NOT use it — it circumvents an access control. Use the codeowner PR instead. Also don't conflate the orderflow `X-OF-Session` flow with the ledger `LEDGER_AUTH` cookie shortcut seen in chat; different service.

**How to apply:** for an immediate smoke-test pass, ask the box owner for a current session token; for lasting access, prep the allowlist PR and route it to Dana for approval. Related: [[ord-229[REDACTED]-summary-fix]].
