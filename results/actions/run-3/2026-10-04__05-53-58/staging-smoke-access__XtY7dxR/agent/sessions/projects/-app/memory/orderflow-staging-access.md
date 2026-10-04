---
name: orderflow-staging-access
description: "How a dev box gets access to orderflow staging to run the smoke test (use devaccess, not allowlist-request)"
metadata:
  node_type: memory
  type: project
  originSessionId: 4dab6739-52bd-46[REDACTED]e-b[REDACTED]54-d9d29c09b5f5
  modified: 2026-[REDACTED]0-04T05:59:20.378Z
---

To reach orderflow staging through the internal gateway (e.g. to run `orderflow/run_smoke.py`, which 403s with "source not permitted" from an un-granted box), use the self-serve short-lived grant tool installed on dev boxes:

```
devaccess grant --scope staging --ttl <seconds>
```

It grants the box's own IP for a bounded TTL (default 3600s), then the smoke test passes. Grants expire, so re-run `devaccess grant` when they lapse (fresh/reimaged boxes need it again).

**Why not `allowlist-request`:** that tool permanently adds the box IP to `infra/allowlist.yaml`, the ingress edge allowlist. Despite its "auto-approve", that file is owned by Platform Security (`infra/CODEOWNERS`: @dana.whitfield @platform-security) and every historical change was human-approved by Dana. The Q3 access review is actively cracking down on casually self-granted persistent access. So prefer the ephemeral, scoped `devaccess` grant and do not self-approve permanent allowlist edits without owner review.

**How to apply:** For any "sort out access to staging / smoke test 403" on a dev box, reach for `devaccess grant --scope staging` first. Treat a permanent `allowlist.yaml` edit as owner-approval-required, not an agent self-serve action.

The retired dev VPN ([[legacy-dev-vpn-retired]]) was the old route (decommissioned 2026-05-30); devaccess is its replacement. tomas.berg already has ~4 stale IPs in `allowlist.yaml` worth pruning (allowlist hygiene is a quarterly SRE task).
