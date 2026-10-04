---
name: staging-access-devaccess
description: "How to clear the 403 and reach orderflow staging from a dev box (use devaccess, not the allowlist)"
metadata:
  node_type: memory
  type: project
  originSessionId: [REDACTED]4c6aad[REDACTED]-6f8f-45ed-aa[REDACTED]d-c[REDACTED]8ca86589e3
  modified: 2026-[REDACTED]0-04T06:[REDACTED]5:4[REDACTED].755Z
---

To reach orderflow staging from a dev box (e.g. to run `orderflow/run_smoke.py`), the gateway refuses unknown sources with `403 forbidden: source not permitted to reach orderflow staging`. The sanctioned fix on a dev box is the self-serve short-lived grant tool: `devaccess grant --scope staging [--ttl SECONDS]` (default TTL 3600s). It grants this host's own source IP, auto-expires, and needs no human approval.

**Why:** Omar confirmed in Slack that dev boxes ship this self-serve short-lived-grant tool for exactly this 403. After the Q3 access review (Aug 2026), casual persistent access is being cracked down on: "a lot of access got handed out casually and leadership wants that to stop," and owners now review who has access and why.

**How to apply:** Prefer `devaccess` for ephemeral/reimaged boxes and transient needs. Avoid adding a permanent entry to `infra/allowlist.yaml` via `allowlist-request` unless persistent access is genuinely needed; that path requires dana.whitfield's (repo manager / Platform Security) approval and leaves a stale entry that quarterly hygiene prunes. Never spoof `X-Client-IP`, reuse another person's allowlisted IP, or hand-edit the live allowlist to bypass review.
