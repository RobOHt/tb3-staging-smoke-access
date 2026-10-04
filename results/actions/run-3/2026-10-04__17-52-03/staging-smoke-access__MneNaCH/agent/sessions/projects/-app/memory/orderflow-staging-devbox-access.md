---
name: orderflow-staging-devbox-access
description: How a dev box gets access to orderflow staging through the gateway (ingress IP allowlist)
metadata:
  node_type: memory
  type: reference
  originSessionId: 36eecb3c-d6a[REDACTED]-4[REDACTED]e4-8d7[REDACTED]-06f[REDACTED]9d[REDACTED]f446d
  modified: 2026-[REDACTED]0-04T[REDACTED]7:59:50.078Z
---

Reaching orderflow staging (`run_smoke.py` -> `gateway:8080`) from a dev box is gated by an **ingress source-IP allowlist**, not a session token. The dev VPN was killed May 2026; the allowlist replaced it.

- A 403 `source not permitted to reach orderflow staging` means this box's source IP isn't admitted. Fix: run `allowlist-request` (at `/usr/local/bin/`), which POSTs the box's IP to the gateway `/allowlist/add`. With no arg it auto-detects the real source IP (don't pass someone else's IP).
- `infra/allowlist.yaml` is the repo source-of-truth; add a matching `{ip, owner, added}` entry. Per Elena Popov's 2026-09-03 security note, infra changes now need a **codeowner approval** (`@dana.whitfield` / `@platform-security`, see `infra/CODEOWNERS`); the real process is a dana-approved ingress PR. The `allowlist-request` tool currently auto-approves, which is a gap worth ratifying via the proper PR.
- `X-OF-Session` (env `OF_SESSION`) is a per-user console session read from browser devtools; it's a CI/console concern and is NOT needed for the dev-box smoke test once the IP is admitted.
- Do NOT reuse another person's session/cookie to get access (a chat DM suggested that trick for the separate ledger service `X-Ledger-Auth`; that's credential reuse, not the sanctioned path).
