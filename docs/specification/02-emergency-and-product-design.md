# Emergency Workflows and Product Design

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 6. Emergency Workflows

### 6.1 SOS creation and authorized handling

- User opens SOS and sees who receives the alert and what information is shared.

- User deliberately confirms. Location is optional and requested only if approved; declining/unavailable location does not prevent alert unless institution decides otherwise.

- System records an alert ID, creator, time, minimum details, optional location, and initial status. Show submitted, delivery pending, delivered where known, or failed/unknown.

- Route minimum notice to designated handlers only. Do not expose full incident details on lock screens unless approved.

- Authorized handler acknowledges, assigns, records updates, and closes under the approved procedure.

- Reporter receives status updates where supported. State that the app does not call public emergency services and cannot guarantee response.

### 6.2 Incident report and status workflow

Unified incident states: submitted → underReview → actionInProgress → resolved → reopened → actionInProgress. Closed, rejected, and duplicate are terminal states; duplicate records require duplicateOf linkage, rejected records require a reason, and closed records require an authorized reviewer. Confirm whether reopening after closure is allowed.

- Reporter enters category and narrative; occurrence time, severity, attachments follow approved form; location is optional.

- Location may be shared at report time or entered manually if allowed; no continuous tracking is assumed.

- Authorized reviewers triage, assign, update status, and add notes; every change records actor and time.

- Map shows only records the viewer may access; a list view remains available for accessibility and map failure.

### 6.3 Hotline verification and calling

- Designated maintainer enters contact details for institutional verification.

- Verifier confirms number, label, coverage, availability, and verification date.

- Only approved current entries enable calling; show selected contact and number and require confirmation before call handoff.

- Track review date; disable expired or withdrawn entries until reverified.

OPERATING GATE  Do not enable production SOS until primary/backup handlers, coverage, escalation, training, and offline/failure procedures are approved.

## 7. Proposed Architecture

Confirmed direction: Flutter/Dart client, Firebase backend, Cloud Firestore primary database. Other Firebase products and external services are candidates only.

**Table 06. 7. Proposed Architecture — Layer / Planning responsibility / Decision to confirm**

| Layer | Planning responsibility | Decision to confirm |
| --- | --- | --- |
| Flutter/Dart | Role-aware screens for volunteers, activities, attendance, announcements, reports, incidents, SOS, hotlines. | Platforms, accessibility, offline behavior. |
| Firebase Authentication | Identity/session lifecycle if approved. | Provider, review, MFA, recovery. |
| Cloud Firestore | Primary records for approved users, activities, attendance, incidents, alerts, reference data. | Region, schema, indexing, retention, cache, billing. |
| Server-side functions | Candidate for privileged validation, SOS routing, scheduled maintenance. | Need, runtime, cost, monitoring, owner. |
| Push notifications | Candidate channel for designated handlers. | Delivery limits, retries, fallback, payload. |
| Map and call handoff | Map provider and device calling are dependencies. | Provider terms; verification workflow; devices. |

### 7.1 Design principles

- Authorize sensitive actions on trusted server-side boundaries and Firestore rules.

- Route emergency notices to a managed responder roster, never implicitly to all accounts.

- Keep delivery state explicit; never imply guaranteed delivery.

- Limit location to approved workflows and role visibility.

- Keep hotline access usable without requiring map/location permission.

## 8. Data Model

Entities below are candidate Firestore collections or logical records. Confirm schema, access patterns, indexes, and retention before implementation.

Model alignment: this table names logical entities. Canonical document paths are in Section 21; participation and attendance are subcollections under activities, while alert delivery and report job records use their own restricted collections.

**Table 07. 8. Data Model — Entity / Candidate information / Important control**

| Entity | Candidate information | Important control |
| --- | --- | --- |
| users | User ID, approved profile, account state, unit links, role reference. | Minimize personal data; protect role changes. |
| organizations | Unit ID, name, parent, active state, coordinator. | Restrict management and group visibility. |
| activities | ID, owner, title, schedule, venue, description, capacity, status. | Limit edits; retain status history as needed. |
| participation | Activity/user link, request/approval state, timestamps. | User sees own; coordinator sees assigned scope. |
| attendance | Activity/user, status, actor, time, optional correction reason. | Prevent unauthorized duplicates; audit corrections. |
| qrSessions | Activity/session, issuer, validity, validation policy. | Reusable QR alone is not proof; approve anti-reuse design. |
| announcements | Author, audience, content, priority, publish/expiry. | Restrict targeting and publication. |
| incidents | Reporter, category, narrative, optional severity/time/location, status, handler. | Optional location; restrict detail/files. |
| sosAlerts | Alert ID, reporter, time, minimal detail, optional location, status, handler, delivery state. | Only authorized responders see details. |
| alertEvents | Alert ID, action, actor, time, minimal event detail. | Controlled retention; audit. |
| hotlines | Label, number, coverage, availability, verifier/date, next review. | Unverified/expired cannot call. |
| auditEvents | Actor, action, record reference, time, outcome, minimal change context. | No secrets; restricted and retained by policy. |
| alertDeliveries | Alert ID, handler, channel, attempt/state, provider reference where safe. | Server-managed; minimize identifiers and retention. |
| reportJobs | Requester, type/filters, status, expiry, output reference. | Scoped access; output expires by policy. |

### 8.1 Location and attachments

- Store only location needed for a user-initiated report or alert; do not collect continuous location by default.

- If attachments are approved, restrict access and define file type, size, deletion, and retention.

- For confirmation — exact-coordinate need, viewer roles, precision, and map display behavior.

## 9. Screen Inventory

**Table 08. 9. Screen Inventory — Screen / area / Users / Key actions and states**

| Screen / area | Users | Key actions and states |
| --- | --- | --- |
| Sign-in, registration, recovery | All | Authenticate; show pending/disabled states. |
| Role-aware dashboard | Approved roles | Assigned activities, attendance, announcements; emergency cards only if authorized. |
| Volunteer profile/unit | Volunteer, coordinator, admin | View/edit permitted fields and unit links. |
| Activity list/detail/editor | Volunteer, coordinator | Browse, request, manage activity and roster. |
| Attendance editor/history | Coordinator, admin, volunteer | Mark/correct; volunteer views own record. |
| QR issue/scan/result | Coordinator, volunteer | Create/scan; valid, expired, duplicate, failed. |
| Announcements | All; authorized publishers | Read, target, publish, archive. |
| Reports/analytics | Authorized coordinators/admins | Filter approved summaries. |
| Incident form/detail | Volunteer, reviewer | Submit; optional location; status updates. |
| Incident map/list | Authorized reviewer | Filter and open limited-detail records. |
| SOS entry/confirmation/receipt | Permitted users | Explain recipients; deliberate action; truthful status. |
| Responder inbox/detail | Designated handlers | Acknowledge, assign, update, resolve. |
| Hotline directory/call confirm | Approved users | Verified contacts; confirm before calling. |
| Hotline maintenance/verification | Designated maintainers | Enter, verify, review, disable, audit. |
| Public landing/contact; admin, audit, backup, import/export, help | Public visitors and authorized roles | Approved supporting administration. |

For confirmation —  Navigation, screen visibility, languages, accessibility standard, and launch-critical screens.
