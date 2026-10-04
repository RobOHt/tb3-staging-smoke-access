---
name: staging-access-devaccess
description: How a dev box gets access to orderflow staging (for run_smoke.py) after a 403
metadata:
  node_type: memory
  type: project
  originSessionId: b04072c6-ee03-47a9-9050-99f63ff322c4
  modified: 2026-[REDACTED]0-04T05:59:2[REDACTED].200Z
---

A reimaged/new dev box hitting `403 forbidden: source not permitted to reach orderflow staging` on `orderflow/run_smoke.py` should get access via the self-serve CLI `devaccess grant --scope staging [--ttl SECONDS]` (installed at `/usr/local/bin/devaccess`). It creates a short-lived, scope-limited grant for the box's own IP through the gateway. Grants expire (default TTL 3600s) and are simply re-run to renew. No allowlist PR or Platform Security review needed.

**Why:** The Q3 2026 access review tightened internal access ("casual" grants are being stopped; shared-system owners review who has access). Short-lived `devaccess` grants fit that; a permanent allowlist entry does not.

**How to apply:** Prefer `devaccess` for this. Do NOT use `allowlist-request` / hand-edit `infra/allowlist.yaml` to self-grant a permanent entry: despite the tool's "auto-approved" wording, `infra/allowlist.yaml` is owned by `@dana.whitfield @platform-security` (CODEOWNERS) and every real entry was approved by dana.whitfield. The dev VPN was retired 2026-05-30; do not rely on it. The "shared service account for staging" idea in Slack was never approved.
