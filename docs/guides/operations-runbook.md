# Operations and Release Runbook

This is the minimum operator contract. Production is blocked until D-02, D-05, D-06, D-17, D-20 and D-24 name owners and environments. No deployment, access to real records or claims of operational support are authorized by this page alone.

## 1. Ownership fields to fill before production

| Responsibility | Named owner/team | Contact/escalation | Status |
|---|---|---|---|
| Product and release approval | OPEN D-02 | OPEN | Missing |
| Firebase billing/project owner | OPEN D-05 | OPEN | Missing |
| IAM/security administrator | OPEN D-05 | OPEN | Missing |
| Privacy/data owner | OPEN D-03/D-22 | OPEN | Missing |
| On-call/support responder | OPEN D-02 | OPEN | Missing |
| Backup/restore operator | OPEN D-20 | OPEN | Missing |

## 2. Deployment sequence

1. Confirm approved release scope, exact commit/build SHA, version, supported platform and approvers.
2. Confirm no open decision blocks the changed fields/service/platform. Confirm target project IDs from approved environment matrix.
3. CI must pass on the exact commit; no production secret is available to general PR jobs.
4. Deploy rules/indexes/functions to staging before a client depending on them. Inspect the resolved Firebase project ID immediately before command execution.
5. Run staging smoke tests for sign-in, approval gate, role access, primary records, denied access and error monitoring.
6. Verify backup state/rollback steps. Get explicit production deployment authorization and use named least-privileged operator.
7. Deploy exact reviewed artifacts. Record operator/time/environment/SHA/result; verify health and alerts.
8. If health or authorization checks fail, stop rollout and execute the approved rollback. Never weaken rules as an emergency workaround.

No command in a local README should contain a bare `firebase deploy` without an explicit approved target.

## 3. Monitoring and incident response

Required before live users: dashboards/alerts for auth failures and abuse, function errors/latency, notification delivery failures if enabled, rule denials, quota/billing anomalies, backup failures and client crash rates (only approved telemetry). Each alert must have an owner, severity, response expectation and escalation route. Logs redact personal/incident data.

Security/privacy incident procedure: contain affected credential/access, preserve minimal evidence without exporting personal payloads, notify designated owner through approved channel, assess affected records and legal/institutional notification obligations with the data/privacy authority, rotate credentials/revoke sessions as appropriate, document timeline and remedial actions. Do not let an AI agent message users/regulators or perform production containment without explicit authorization.

## 4. Backup and recovery

Do not rely on client export as backup. Before production, record:

- chosen managed backup/export mechanism and encrypted destination;
- included/excluded collections, retention and access-control owners;
- Recovery Point Objective (RPO), Recovery Time Objective (RTO), and recovery contact;
- restore procedure into an isolated project, validation checklist and rollback;
- date/result/evidence for a successful restore drill.

No restore should write into production until the data owner authorizes the exact restore and rollback plan. Do not download backups to developer workstations by default.

## 5. Rollback

- Client: retain prior signed artifact and release metadata; rollback through approved store/hosting channel.
- Backend rules: rollback only to a reviewed secure rules revision; never revert to permissive or deny-all production without impact review.
- Functions: deploy previous compatible version or disable affected trigger/callable per tested runbook; preserve idempotency and queued-event behavior.
- Data/schema: prefer backward-compatible expand/migrate/contract. A data restore is a separate approved recovery action, not a routine code rollback.

## 6. Support boundaries

Until owners and a support agreement are filled, describe builds as development/staging only. Do not claim real-time emergency monitoring, guaranteed notification delivery, data recovery objectives, or response SLAs.

