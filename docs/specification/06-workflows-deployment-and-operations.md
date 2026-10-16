# Workflows Deployment and Operations

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 23. SOS and Incident State Machines

### 23.1 SOS lifecycle versus delivery state

**Table 20. 23.1 SOS lifecycle versus delivery state — Lifecycle transition / Who may initiate / Required checks / event**

| Lifecycle transition | Who may initiate | Required checks / event |
| --- | --- | --- |
| create → submitted | Permitted reporter | Validate role, payload, idempotency key; record actor/time. |
| submitted → acknowledged | Designated responder | Responder belongs to active authorized roster; set acknowledgedAt. |
| acknowledged → actionInProgress | Assigned responder | Record assignment and response event. |
| actionInProgress → resolved | Assigned handler or approved supervisor | Resolution note and timestamp; retain audit event. |
| submitted/acknowledged → cancelled | Reporter or responder under approved policy | Require reason where policy needs; preserve history. |
| submitted → cancelled | Reporter within approved 10-second cancel window | Use expectedVersion; record cancellation event; cannot retract notices already delivered. |
| submitted/acknowledged → falseAlarm | Authorized responder or incident reviewer | Record reason and review; retain alert and delivery history; never delete. |
| resolved → closed | Authorized supervisor/reviewer | Close only after required resolution review; increment version and append event. |

Keep delivery state separate from incident lifecycle. A function may enqueue per-handler notices and record send attempts, but provider acceptance is not proof a person saw or acted on the alert. Retries must not duplicate the alert or create false acknowledgement.

### 23.2 Incident lifecycle

**Table 21. 23.2 Incident lifecycle — Transition / Role / Validation**

| Transition | Role | Validation |
| --- | --- | --- |
| new → submitted | Reporter | Required category/narrative; optional location; size and type checks. |
| submitted → underReview | Authorized reviewer | Reviewer scope; record assigned queue. |
| underReview → actionInProgress | Assigned handler | Require owner and event history. |
| actionInProgress → resolved | Assigned handler/reviewer | Resolution details per policy; record time. |
| resolved → reopened | Authorized reviewer | Only if reopened is approved; capture reason. |
| underReview → rejected | Authorized reviewer | Require reason; record history and notify reporter where approved. |
| underReview/actionInProgress → duplicate | Authorized reviewer | Require valid duplicateOf reference and prevent self-reference. |
| resolved → closed | Authorized reviewer/supervisor | Require closure review; preserve history. |

## 24. Environments, Deployment, and Release

**Table 22. 24. Environments, Deployment, and Release — Environment / Purpose / Data / access controls**

| Environment | Purpose | Data / access controls |
| --- | --- | --- |
| Local development | Feature work and emulator testing. | Synthetic data; no production credentials. |
| Staging / test | Integration, rules, UAT, responder simulation. | Separate Firebase project; restricted testers; resettable test data. |
| Production | Institution-approved live operation. | Separate project/config; named admins; reviewed rules; monitoring and rollback. |

### 24.1 Release pipeline proposal

- Keep Flutter dependencies and lockfiles in version control; review upgrades before release.

- Separate non-secret configuration (project identifiers, feature flags) from secrets and platform signing material.

- Use Firebase Local Emulator Suite for Auth/Firestore/Functions workflows and Firestore Rules tests where suitable.

- Deploy Firestore rules, indexes, and functions from reviewed source control; require a second reviewer for production security changes.

- Release mobile builds through institution-approved app distribution; web hosting only if web is in approved scope.

- Tag releases and record build version, commit, environment, rules version, and deployment approver.

- Rollback plan must cover client release, function version, rules changes, and data migrations; destructive migration rollback needs a tested backup/recovery procedure.

### 24.2 Configuration decisions

For confirmation — Firebase project IDs, region, authentication providers, supported platforms, app identifiers, signing ownership, billing plan, push credentials, map provider/API key restrictions, domains, and who can deploy each environment. Never put private server keys or service-account credentials in the Flutter client.

## 25. Observability, Backup, and Recovery

**Table 23. 25. Observability, Backup, and Recovery — Concern / Planning requirement / Decision required**

| Concern | Planning requirement | Decision required |
| --- | --- | --- |
| Application health | Capture crash/availability errors with privacy-safe metadata; record app version and environment. | Choose monitoring product and data retention. |
| Function operations | Track invocation errors, latency, retries, queue backlog, and permission failures. | Set alert owners and thresholds. |
| SOS operations | Measure created, routed, provider-accepted, failed/unknown, acknowledged, and resolved counts without exposing unnecessary content. | Define operational metrics and review cadence. |
| Audit | Record actor, action, target, outcome, and timestamp for privileged or emergency transitions. | Approve who may read/export and retention. |
| Backup | Define Firestore backup/export scope, frequency, encryption/access, retention, and restore test. | Set recovery point and recovery time objectives. |
| Recovery | Document account compromise, bad rules deploy, function outage, accidental deletion, and hotline error playbooks. | Name owners, escalation, and communications. |
| Data export | Protect generated files and expire them after approved time. | Confirm approved delivery channel and expiry. |

### 25.1 Operational readiness checklist

- Support contact and escalation owner are published to authorized users.

- Responder roster, coverage schedule, backup contact, and periodic roster review are in place.

- Hotline list has named verifier, verification date, and review due date.

- Monitoring alerts route to a staffed owner; test alert and escalation path.

- Backup restoration is demonstrated in a non-production environment.

- Access is reviewed at role change and on a scheduled basis.

- Incident and SOS playbooks explain false alerts, harassment/abuse, handoff, service outage, and record closure.

## 26. Repository and CI/CD Plan

A possible repository layout is illustrative. Confirm whether the client and server functions should share a repository or be maintained separately.

- app/ — Flutter application, feature modules, shared UI and data layer.

- functions/ — approved trusted backend operations, validation, notification routing, and scheduled tasks.

- firestore.rules — Firestore authorization and validation rules.

- firestore.indexes.json — approved composite indexes.

- storage.rules — only if file storage is approved.

- test/ — unit, widget, integration, rules, and end-to-end tests.

- docs/ — requirements, data dictionary, runbooks, privacy, and release notes.

- firebase.json — environment-aware Firebase CLI configuration; avoid embedding secrets.

### 26.1 Quality gates

- Formatting, static analysis, and unit tests pass for changed client/server code.

- Firestore Rules tests include expected allows and denials for every role and key collection.

- Functions tests cover authorization, validation, idempotency, state transitions, retry/failure, and duplicate requests.

- Widget tests cover loading/error/empty/denied states and emergency confirmation; integration tests exercise Firebase emulators.

- Dependency and secret scans run in the build pipeline; critical findings block release under an approved policy.

- Manual acceptance includes accessibility checks, supported-device checks, hotline call handoff (without placing test calls to real numbers), and responder tabletop exercise.

## 27. Full-Stack Traceability and Open Decisions

**Table 24. 27. Full-Stack Traceability and Open Decisions — Requirement group / Client / Backend/data / Verification**

| Requirement group | Client | Backend/data | Verification |
| --- | --- | --- | --- |
| Volunteer/auth | Registration, sign-in, profile, role dashboard. | Auth identity, users/orgs, rules, approval operations. | Auth/role tests; profile privacy review. |
| Activities/attendance/QR | Browse, participate, roster, mark/scan. | Activities, participation, attendance, QR sessions, validators. | Lifecycle, role, replay, duplicate tests. |
| Announcements/reports | Feed, publish, dashboard/report screens. | Announcements, query/index plan, scoped report reads/jobs. | Audience and calculation reconciliation. |
| Incidents/map | Form, optional location, list/map, status view. | Incident records/history, restricted location, reviewer operations. | Rules, optional-location, map privacy tests. |
| SOS | Confirmation, submission/delivery state, responder inbox. | Create/route/ack/status functions, alert/event/delivery records. | Idempotency, authorization, failure, responder simulation. |
| Hotlines | Directory, call confirmation, restricted admin screens. | Verified hotline record, verification audit. | Unverified/expired gate and device handoff. |
| Operations | Settings/help/support and admin tools. | Audit, monitoring, backup/export, environment config. | Restore test, access review, release sign-off. |

### 27.1 Technical decisions still open

- Flutter state management, routing approach, model/code generation, dependency policy, and supported client platforms.

- Firebase products to enable, authentication method, project/region, billing, storage, notification, and hosting choices.

- Cloud Functions language/runtime, callable versus event-driven operations, function regions, and whether each privileged workflow needs a function.

- Final Firestore paths, role storage, organization scoping, query/index plan, attachment design, and retention/deletion policy.

- Map provider, location format/precision, offline behavior, hotline owner and verified numbers, and production emergency workflow.

- Monitoring provider, backup/restore objectives, on-call owner, CI/CD provider, signing, deployment approvals, and support model.

- Service-level and non-functional targets: maximum user/activity volume, expected report size, availability/recovery, response times, localization, accessibility standard, budget.

IMPLEMENTATION GATE  Start implementation only after scope and role approval; start SOS/hotline production work only after the operational owner, privacy/security review, verified contacts, and responder procedures are approved.

## 28. Official Technical References

Firebase for Flutter setup: https://firebase.google.com/docs/flutter/setup

Cloud Firestore Security Rules: https://firebase.google.com/docs/firestore/security/get-started

Callable Cloud Functions: https://firebase.google.com/docs/functions/callable

Firebase Cloud Messaging for Flutter: https://firebase.google.com/docs/cloud-messaging/flutter/get-started

Firebase security checklist: https://firebase.google.com/support/guides/security-checklist

These references inform candidate architecture only. Confirm current product behavior, supported platforms, and billing requirements during technical design.
