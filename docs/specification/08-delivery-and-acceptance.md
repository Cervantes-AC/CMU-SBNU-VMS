# Delivery and Acceptance

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 31. Delivery Backlog and Definition of Done

This backlog is a planning sequence, not a schedule. Size and staffing are unconfirmed. Deliver vertical slices so each feature has client behavior, trusted data handling, permissions, error states, tests, and operational notes.

**Table 27. 31. Delivery Backlog and Definition of Done — Phase / epic / Implementation work products / Exit checks**

| Phase / epic | Implementation work products | Exit checks |
| --- | --- | --- |
| A. Foundations | Separate Firebase projects/configs; Flutter shell; auth/session; environment setup; logging policy; CI workflow; design tokens. | No production secrets in client; environment separation demonstrated; sign-in lifecycle agreed. |
| B. Identity and organization | User profile, account review, role assignment, organization model, audit hooks, initial Security Rules. | Role matrix tests pass; self-privilege escalation denied. |
| C. Activities and participation | Activity CRUD, schedule/status lifecycle, roster, join requests, organization scope, indexes. | Lifecycle, authorization, pagination, boundary tests pass. |
| D. Attendance and QR | Attendance record/correction, QR session issuance/scan/validation, duplicate/replay handling. | Clock/time-window, replay, wrong-activity, offline, correction scenarios pass. |
| E. Announcements and reporting | Audience-scoped announcements, analytics definitions, report reads/exports. | Audience tests pass; totals reconciled against known data; exports scoped and logged. |
| F. Incident workflow and map | Optional-location report, status/assignment/history, map/list UI, privacy-limited detail. | No-location flow works; map access restricted; location permission-denial tested. |
| G. Hotline directory | Administrative entry, verification review, expiry/disable, user directory, call confirmation. | Unverified/expired entries cannot initiate call; changes audited. |
| H. SOS alert path | Deliberate activation, idempotent create, designated handler resolution, delivery tracking, ack/state updates, failure UX. | Responder simulation passes; no general broadcast; unknown delivery stays unknown. |
| I. Operations and launch | Monitoring, backup/restore, support and escalation, access review, privacy notice, pilot/release runbooks. | Named owners sign operational/privacy/security gates; restore and rollback rehearsed. |

### 31.1 Definition of Done for each feature

- Requirement ID linked to approved acceptance criteria and screen/data design.

- Client states cover loading, empty, success, invalid input, denied access, offline, and retryable/non-retryable errors.

- Backend authorization and Firestore Rules are reviewed; privileged Admin SDK paths have separate IAM and authorization checks.

- Unit/widget/integration/rules tests cover expected allow and deny cases and important failure paths.

- Logs/metrics exclude secrets and minimize incident/location data; support and retention behavior are documented.

- Accessibility and supported-platform checks completed; user-facing copy reviewed by the business owner.

- Deployment, rollback/migration, and support notes updated; product owner accepts evidence for the requirement.

### 31.2 Release gate evidence

**Table 28. 31.2 Release gate evidence — Gate / Required evidence**

| Gate | Required evidence |
| --- | --- |
| Design approval | Signed scope, role matrix, schema, response workflows, privacy classification, architecture decisions. |
| Feature complete | Reviewed code, tests, rules, migration/index updates, and user-facing states. |
| Security/privacy approval | Access tests, privacy notice, retention plan, location/notification review, open findings disposition. |
| Operational readiness | Verified hotlines, responder coverage and simulation, support owner, backup restore, monitoring and rollback. |
| Pilot approval | Named approver, limited cohort, feedback path, incident/rollback criteria, review date. |
| Production approval | All required gates accepted; no unresolved critical security/privacy/operations findings. |

## 32. Problem Framing, Outcomes, and Release Boundaries

Problem statement (working hypothesis): the project proposes one institution-governed mobile system for volunteer records, activity coordination, attendance evidence, announcements, reporting, and emergency coordination. The current planning materials do not establish measured baseline performance or confirm the exact current workflow; validate these with CMU–SBNU and NSRC stakeholders before treating them as facts.

**Table 29. 32. Problem Framing, Outcomes, and Release Boundaries — Outcome measure / Definition / evidence / Proposed target and owner**

| Outcome measure | Definition / evidence | Proposed target and owner |
| --- | --- | --- |
| Volunteer record completeness | Required profile fields complete ÷ active profiles; profile audit sample. | Set baseline during discovery; target and required fields approved by data owner. |
| Attendance reconciliation time | Elapsed time from activity close to approved roster reconciliation. | Measure baseline on comparable activities; set pilot target with coordinators. |
| QR duplicate prevention | Duplicate scan attempts that do not create a second attendance record. | 100% of automated duplicate test cases rejected or idempotently accepted. |
| Emergency alert state integrity | Server-accepted SOS alerts visible to authorized handlers with accurate delivery state. | All acceptance tests pass; no client-only “sent” state. |
| Hotline verification coverage | Visible callable numbers with institution-verifier and verification date. | 100%; unverified numbers cannot be called from the app. |
| Security rule coverage | Positive and negative authorization cases in automated rules tests. | All critical paths tested before pilot; owner: security lead. |
| Usability and reliability | Task completion and crash-free sessions measured in pilot. | Baseline first; targets approved before pilot exit. |

Measurement rule  Do not invent a baseline or claim improvement until a pilot has collected comparable evidence. Name a metric owner, source, review cadence, and target in the pilot plan.

**Table 30. 32. Problem Framing, Outcomes, and Release Boundaries — Release boundary / Recommended initial position / Decision**

| Release boundary | Recommended initial position | Decision |
| --- | --- | --- |
| R1 in scope | Flutter mobile app; Firebase Authentication, Firestore, callable Cloud Functions, push notifications; volunteer, activity, attendance, organizational structure, announcements, reports, permissions, QR attendance, SOS, incident reporting/map, verified hotlines. | Confirm sponsor and technical owners. |
| R1 out of scope | SMS dispatch, public API, web administration portal, advanced predictive analytics, automated emergency-service dispatch, continuous background tracking. | Recommended default; sponsor may revise explicitly. |
| External integrations | Maps/geocoding and push delivery depend on provider configuration, platform permission, connectivity, and approved data-transfer review. | Select providers and approve terms before implementation. |

## 33. Detailed Operational Workflows and Safety Rules

Security boundary: a visible QR code is only a short-lived presentation of a signed, activity-bound token; it is not a reusable credential. Keep signing material server-side, validate token expiry/activity/nonce and participant eligibility on the server, and make successful writes idempotent. Proposed 60-second rotation is a pilot setting, not an approved requirement.

### QR attendance proposal

- Coordinator opens a scheduled activity and starts check-in; the server creates a session identifier and short-lived signed token. Proposed starting token rotation is 60 seconds (confirm after pilot usability and threat review). Tokens must be bound to the activity and validity window; do not encode profile data or reusable credentials.

- Volunteer scans while signed in. A callable server function validates token signature, expiry, activity state, participant approval, and user eligibility, then writes attendance idempotently using a stable key. Server time is authoritative; client time is informational only.

- Repeated scans return the existing attendance result and do not create duplicate records. The app clearly distinguishes accepted, duplicate/already recorded, expired token, ineligible, and network failure.

- Coordinator manual correction requires a reason, actor, timestamp, and audit event. Optional geofence is deferred; collect no location for ordinary attendance unless separately justified and approved.

Operational status semantics: an “acknowledged” alert means an authorized handler explicitly accepted responsibility; provider “sent” means only that a delivery provider accepted the request. A cancellation or false-alarm classification never erases delivery attempts or prior actions.

### SOS alert creation and authorized handling

- Activation requires a deliberate hold or slide-to-confirm gesture. After submission, show a 10-second cancellation window; cancellation stops subsequent escalation where possible and is recorded, but cannot retract push notifications already delivered.

- The client calls a protected server function. Only a server-accepted response may display “Alert sent”; if offline or the function fails, display “Not sent,” offer retry when connected, and prominently show institution-verified hotlines. Never queue a false “sent” alert offline.

- The SOS record and delivery attempts are separate. Authorized responders can acknowledge, assign, add a safe status update, resolve, or close according to their active designation. All transitions are server-validated and audited. Push is best effort and does not bypass device settings or guarantee receipt.

- Rate limits and duplicate suppression must be tuned through abuse and false-alarm testing. A false/accidental alert is retained as a controlled outcome with an authorized review note; do not silently delete it.

- Escalation timing is a proposal for a supervised pilot: if the primary handler has not acknowledged by 2 minutes, notify the backup; at 5 minutes, notify the supervisor. These are not emergency-response guarantees or service-level commitments. Confirm staffing, on-call coverage, and safe operating procedure before enabling.

- Use only institution-verified hotline numbers as fallback. SMS or automated phone-tree escalation is outside R1 unless separately approved, funded, and tested.

### Incident report and mapping

**Table 31. Incident report and mapping — Element / Recommended definition / Confirmation needed**

| Element | Recommended definition | Confirmation needed |
| --- | --- | --- |
| Categories | Medical/health, safety/security, facility/environment, transport, lost person/property, other; allow “other” with controlled text. | NSRC/institution safety owner approves taxonomy. |
| Severity | Low: no immediate threat; Medium: prompt support; High: urgent risk needing rapid responder action; Critical: immediate threat to life/safety. | Approve operational definitions and escalation authority. |
| Location | Optional device location only after explicit permission; manual location/description alternative. Save locationShared=false when absent; do not use fake coordinates. | Approve precision, map provider, and retention. |
| Lifecycle | submitted → underReview → actionInProgress → resolved → reopened → actionInProgress; closed, rejected, duplicate are terminal. Duplicate requires duplicateOf; rejection requires reason; resolution/closure requires authorized actor and audit. | Approve transitions and who may reopen/close. |
| Map view | Show only authorized incidents with status/severity filters and approximate location where exact coordinates are unnecessary. Do not expose reporter identity or narrative in map markers. | Approve coordinate precision, visibility, and clustering. |

Concurrency  For incidents and SOS alerts, every successful server-side lifecycle mutation increments integer version. Callers provide expectedVersion; mismatches return a conflict and require refresh. This prevents stale clients overwriting newer safety actions.

### Emergency hotline list

Each entry should include display name, purpose, number, service hours, geographic scope, language/accessibility notes, verification state, verifier UID, verifiedAt, expiry/review date, and source. Only a second authorized hotline verifier may mark an entry verified. Expired or unverified entries remain non-callable with an explicit status. One-tap calling uses the platform dialer and requires a final device confirmation; the app does not silently place calls.

### Reports, exports, and notifications

Reports are generated from authorized server-side queries with recorded requester, scope, generation time, status, expiry, and safe output reference. Exports must exclude sensitive fields by default, be access-logged, and expire under the approved retention schedule. Notification payloads should contain minimal content and direct the user to sign in to view protected details.

## 34. Privacy, Security, Operations, and Delivery Readiness

### Privacy governance and retention

The institution must identify its personal information controller (PIC), appoint/confirm a Data Protection Officer (DPO), document purposes and lawful basis, and complete a privacy impact assessment before real personal or emergency records are collected. This is a planning control, not legal advice; institutional privacy counsel/DPO must determine applicability and approve notices, consent, registration, and cross-border transfers.

**Table 32. Privacy governance and retention — Information class / Examples in this system / Controls / planning action**

| Information class | Examples in this system | Controls / planning action |
| --- | --- | --- |
| Public operational | Approved hotline name and number; published announcement. | Institution verifies accuracy, review date, and publication authority. |
| Personal information | Volunteer identity, contact, organization, attendance, account identifiers. | Purpose limitation, least privilege, notice, retention, access/correction process. |
| Sensitive personal information | Age, education, health/medical details, and other statutory sensitive categories where present. | Treat as restricted; collect only if necessary; DPO approval, enhanced access controls, minimization. |
| High-risk operational content | SOS details, incident narratives, precise location, reporter identity, responder notes. | Restrict by active designation; minimize push payloads; map uses approximate coordinates where feasible; audit access. |

- For volunteers under 18, establish age handling, guardian involvement/consent where required, safeguarding escalation, and limits on location/communications before pilot.

- Firebase is a proposed service provider/processor. Confirm contractual terms, service configuration, data location, international access/transfer implications, subprocessors, deletion behavior, and institution-approved region before provisioning. Firestore location cannot be changed after creation; do not create production data before the decision.

- Publish an accessible privacy notice covering data collected, purposes, lawful basis, recipients, retention, rights/contact channel, location use, SOS limitations, and emergency-service boundaries.

- Create a breach response playbook: contain, preserve evidence, assess risk, notify DPO/PIC, document decisions, and notify the NPC/data subjects within the applicable statutory timeframe (including 72 hours only where the breach meets notification criteria and the DPO confirms applicability). Assess NPC registration obligations with the DPO; do not presume registration is either required or exempt.

- Configure retentionExpiresAt for incidents, SOS alerts, attendance, audit data, and reports. Approve exact periods and legal-hold exceptions before launch. Candidate operational defaults for discussion: delivery-attempt logs up to 90 days and exported report artifacts up to 7 days; apply automated deletion and verify backups/derived exports separately.

### Security design and threat review

**Table 33. Security design and threat review — Control / Planning requirement**

| Control | Planning requirement |
| --- | --- |
| Authentication and authorization | Firebase Authentication identifies users; Firestore rules and callable functions enforce least privilege. Sensitive writes and lifecycle transitions occur server-side. |
| Active status and designations | Use coarse custom claims only as a token hint. Claims can be stale until refresh; sensitive actions also check current active status and scoped designation in protected server-side records. Suspend access promptly and revoke refresh tokens where required. |
| App Check | Adopt Flutter-compatible App Check providers per platform; monitor first, then enforce after valid clients are confirmed. App Check supplements authentication/rules and is not authorization. |
| Audit and separation | Audit role/designation changes, SOS/incident access and transitions, hotline verification, exports, and manual attendance corrections. Require a second approver for privileged designation grants and hotline verification. |
| Abuse and threat model | Review account takeover, insider misuse, forged/replayed QR, SOS spam, location exposure, insecure exports, notification leakage, and denial of service. Define rate limits and incident response. |
| Build pipeline | Dependency and secret scanning, lint/static analysis, rules tests, callable-function tests, staging separation, protected secrets, backup/restore rehearsal, and independent security review before pilot. |

### Cost, support, training, migration, and communications

**Table 34. Cost, support, training, migration, and communications — Readiness area / Required planning artifact**

| Readiness area | Required planning artifact |
| --- | --- |
| Cost model | Low/expected/high worksheet using projected registered users and monthly active users, reads/writes, retained bytes, function invocations, map/geocoding usage, push volume, storage/egress, logging, backup, app-store accounts, staff hours, and optional future SMS. Recheck against selected Firebase plan and observed pilot usage; no price estimate until volumes/region are known. |
| Support model | Name service owner, support hours, severity definitions, incident escalation, responder on-call coverage, account recovery process, hotline maintenance owner, and backup contacts. |
| Training | Role-specific quick guides and practice for volunteers, coordinators, responders, hotline verifiers, publishers, analysts, and administrators. Include SOS limitations and offline behavior. |
| Migration | Inventory source data and authority; map/clean fields; resolve duplicates; secure test import; reconcile counts and sampled records; obtain owner sign-off; retain rollback snapshot; document deletion of temporary files. |
| Communications | Announce pilot scope, eligibility, privacy notice, support channel, training dates, emergency limitations, hotline verification date, known issues, and how to report incidents. |

### Delivery milestones and exit gates

**Table 35. Delivery milestones and exit gates — Stage / Exit evidence / Decision owner**

| Stage | Exit evidence | Decision owner |
| --- | --- | --- |
| Discovery and governance | Approved problem statement and baselines, stakeholder map, PIC/DPO and safety owners, PIA initiated, scope and R1 boundaries signed off. | Sponsor + institution |
| Solution design | Architecture, data paths, region, threat model, workflows, prototype usability, rules/index plan, retention and incident SOP approved. | Technical lead + DPO + safety lead |
| Build and integration | Feature-complete staging build; schema/rules/functions, QR, SOS, incident map, hotline directory, reports, audit and observability integrated. | Product/technical owner |
| Verification | Acceptance and negative security tests pass; restore rehearsal, accessibility/usability review, cost review, training materials, hotline numbers verified. | QA + security + operations |
| Controlled pilot | Named cohort, monitoring/support staffed, rollback plan, baseline and outcome measures captured, incidents reviewed. | Sponsor + pilot lead |
| Release decision | Pilot exit metrics reviewed; unresolved risks accepted or closed; data protection and safety approvals recorded; go/no-go documented. | Authorized steering group |

## 35. Acceptance Criteria and Verification Scenarios

The cases below define planning-stage release evidence. They are examples to be expanded into executable test cases and traced to the approved requirement IDs before implementation.

**Table 36. 35. Acceptance Criteria and Verification Scenarios — ID / Given / When / Then**

| ID | Given | When | Then |
| --- | --- | --- | --- |
| AC-01 | An approved volunteer is assigned to an open activity and a valid signed QR token exists. | The volunteer scans once, then scans the same token again. | The server records one attendance event; the repeat is reported as already recorded and no duplicate is created. |
| AC-02 | A QR token is expired, forged, for another activity, or the volunteer is not approved. | The client submits the scan. | The server rejects the request, records no attendance, and returns a safe reason without exposing another user’s data. |
| AC-03 | A coordinator corrects an attendance record. | The coordinator submits a change with a reason. | The change is scoped, authorized, timestamped, and audited with before/after values. |
| AC-04 | A signed-in user has no active responder designation. | The user attempts to read or update an SOS alert. | Rules/function deny the operation; the denial is covered by an authorization test. |
| AC-05 | The device has no network connection. | The user submits SOS. | The UI shows “Not sent,” creates no server alert, and offers verified hotline fallback; it never presents a false success state. |
| AC-06 | An active verified hotline entry exists. | The user taps its call action. | The platform dialer opens with the verified number and requires user confirmation; no call is silently placed. |
| AC-07 | A hotline entry is unverified or past its review expiry. | The user opens the hotline list. | The number is visibly unverified/expired and cannot use the one-tap call action. |
| AC-08 | An incident has locationShared=false. | An authorized analyst opens the map. | No marker is plotted for the incident; no sentinel coordinates appear. |
| AC-09 | Two responders load the same incident version. | Both try to update status; the second submits a stale expectedVersion. | The server accepts one mutation, increments version, and returns a conflict for the stale update without overwriting the first. |
| AC-10 | An incident is marked duplicate. | An authorized reviewer saves the transition. | The server requires a valid duplicateOf reference, records actor/time, and prevents an invalid self-reference. |
| AC-11 | A report is requested by a user outside its organization scope. | The request is submitted. | The server rejects it; no output file is created or exposed. |
| AC-12 | A volunteer is suspended while holding a previously issued token. | The volunteer attempts a protected operation. | The server checks current status/designation and denies the operation despite stale client claims. |
