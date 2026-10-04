---
name: staging-smoke-access
description: How to get a dev box access to orderflow staging for run_smoke.py (use devaccess, not the allowlist)
metadata:
  type: project
---

On a managed dev box, get access to orderflow staging for the pre-PR smoke test (`orderflow/run_smoke.py`, which hits the gateway) by running `devaccess grant --scope staging` (optional `--ttl SECONDS`, default 3600). It creates a short-lived, scope-limited grant for the box's own source IP; the gateway then reports `auth_method: devaccess_grant`. Re-run it when the grant expires. A fresh/reimaged box starts with no access and gets a 403 "source not permitted to reach orderflow staging".

**Why:** `devaccess` is the self-serve path the platform team pre-installs for exactly this (confirmed by Omar Said in Slack). The permanent `infra/allowlist.yaml` (via `allowlist-request`) is Platform-Security-owned (CODEOWNERS @dana.whitfield @platform-security) and the Q3 access review is actively discouraging casual/standing additions. Both `devaccess` and `allowlist-request` trust a caller-set `X-Client-IP` and accept an arbitrary IP arg — never pass someone else's IP or forge that header to impersonate an allowed source.

**How to apply:** Default to `devaccess grant --scope staging` for transient staging needs. Only pursue a permanent allowlist entry if durable access is genuinely needed, and route it through Dana Whitfield / Platform Security for approval rather than self-adding. The legacy dev VPN was decommissioned 2026-05-30. See [[orderflow-summary-ord-229[REDACTED]]].
