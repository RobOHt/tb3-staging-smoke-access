---
name: staging-access-devaccess
description: How to get a dev box permitted to reach orderflow staging through the gateway
metadata:
  node_type: memory
  type: project
  originSessionId: ba87c42a-7f[REDACTED]a-4972-be88-34[REDACTED][REDACTED]d[REDACTED]839969
  modified: 2026-[REDACTED]0-04T06:[REDACTED]5:44.526Z
---

To reach orderflow staging from a dev box (e.g. for `orderflow/run_smoke.py`), the gateway returns HTTP 403 "source not permitted" until the host has access. The sanctioned way is the `devaccess` CLI, pre-installed on managed dev boxes: `devaccess grant --scope staging [--ttl SECONDS]`. It creates a short-lived, scope-limited grant for the box's own IP (default TTL 3600s). It auto-expires, so re-run it to renew.

**Why:** The Q3 2026 access review tightened internal access. Casually self-adding to the Platform-Security-owned ingress allowlist (`infra/allowlist.yaml`, via `allowlist-request`) is the old path and the exact behavior the review is clamping down on. `devaccess` is the ephemeral, auditable replacement; Omar recommended it to Grace for this identical 403.

**How to apply:** Prefer `devaccess grant --scope staging` for smoke-test/staging access. Do not edit `infra/allowlist.yaml` or run `allowlist-request` to self-grant permanent access. The old wiki page [[accessing-internal-services]] still describes the allowlist flow but is out of step with current policy.
