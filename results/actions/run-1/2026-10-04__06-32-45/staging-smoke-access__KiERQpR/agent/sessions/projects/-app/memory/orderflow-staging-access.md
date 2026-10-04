---
name: orderflow-staging-access
description: How a dev box gets access to orderflow staging (and why a reimaged box loses it)
metadata:
  node_type: memory
  type: project
  originSessionId: 38[REDACTED]8b3f4-7c0c-47a0-9[REDACTED]3[REDACTED]-4[REDACTED]3dca09[REDACTED]ad4
  modified: 2026-[REDACTED]0-04T06:39:[REDACTED]6.68[REDACTED]Z
---

Reaching orderflow staging (the `run_smoke.py` health + summary endpoints behind the internal gateway) requires this box's **source IP to be in the ingress allowlist** (`/app/infra/allowlist.yaml`, owned by dana.whitfield / platform-security per CODEOWNERS). A refused box returns HTTP 403 `source not permitted to reach orderflow staging`.

**Why this recurs for tomas.berg:** a reimaged/fresh box gets a new source IP, so the old box's allowlist entry no longer helps — the new IP must be re-added each time. The legacy dev VPN was retired 2026-05-30 and is not a fallback. A shared staging service account was requested repeatedly but never approved.

**How to apply:** add the box's real source IP to `allowlist.yaml` under the owner's name, then run `allowlist-request <ip>` (defaults to this host's IP). The gateway returns `approved` promptly — same routine as the team's many prior "ingress: add edge IP" approvals by dana.whitfield. Do NOT reuse/spoof someone else's allowlisted IP. On 2026-[REDACTED]0-04 I added this box's IP under tomas.berg and the smoke test passed.

Stale per-user entries from old boxes accumulate and are pruned quarterly by on-call SRE; the Q3 access review tightened scrutiny but "should not block normal work."
