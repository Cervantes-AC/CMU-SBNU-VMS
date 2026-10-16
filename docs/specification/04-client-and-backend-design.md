# Client and Backend Design

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 19. Client Application Design

### 19.1 Suggested Flutter feature structure

**Table 15. 19.1 Suggested Flutter feature structure — Area / Responsibilities / Example components**

| Area | Responsibilities | Example components |
| --- | --- | --- |
| app/core | Bootstrap, routing, theme, localization, shared error handling, logging, configuration. | App entry, route table, design tokens, error boundary. |
| features/auth | Sign-in, registration, recovery, approval states. | Screens, form validation, auth controller. |
| features/volunteers | Profiles, approval, organization membership. | Profile editor, roster, status controls. |
| features/activities | Activity browse, detail, authoring, participation. | Activity list/detail/form, participant controller. |
| features/attendance | Attendance entry, history, corrections. | Roster, attendance session, history. |
| features/qr_attendance | QR issue, scan, validate, result. | Session issuer, scanner, duplicate/expiry states. |
| features/announcements | Compose, audience selection, publish, archive. | Feed, detail, editor. |
| features/incidents | Report form, review, status, map/list. | Location opt-in, filters, restricted detail. |
| features/sos | Alert confirmation, receipt, responder queue. | SOS entry, delivery state, authorized handler actions. |
| features/hotlines | Directory, call confirmation, verification admin. | Directory, call handoff, verification log. |
| features/reports_admin | Reports, audit, export, backup, settings, help. | Role-gated dashboards and operations. |

### 19.2 Client layering

- Presentation: screens and widgets render state and send user intents; they do not contain security decisions.

- Application/domain: use cases define activity, attendance, incident, SOS, and hotline rules independently of widgets.

- Data: repositories translate use cases to Firebase SDK operations or approved callable functions.

- Models: typed entities validate field formats and map Firestore timestamps/references explicitly.

- State management is a project decision. Recommended selection: choose and document one maintained Flutter state-management approach during technical design.

### 19.3 Client behavior requirements

- Represent loading, empty, success, partial/offline, permission-denied, validation, and retryable failure states separately.

- Check authentication and role state on navigation for usability, while relying on Firestore rules/backend checks for enforcement.

- Request location, camera, notification, and phone permissions just in time and explain the feature purpose.

- Avoid persisting SOS drafts or sensitive incident narratives in general caches unless the security design explicitly allows it.

- Use accessible controls, semantic labels, text scaling, keyboard focus, and a list alternative to map interaction.

## 20. Backend Operations and API Contracts

Use direct Firestore SDK operations for simple reads and user-owned writes when rules can fully validate them. Use trusted server-side operations for privileged work, recipient resolution, role changes, hotline approval, sensitive exports, and any workflow that must atomically validate and write multiple records.

**Table 16. 20. Backend Operations and API Contracts — Operation / Caller / authorization / Request / effect / Errors and safeguards**

| Operation | Caller / authorization | Request / effect | Errors and safeguards |
| --- | --- | --- | --- |
| createSosAlert | Signed-in user with SOS permission. Callable function candidate. | clientRequestId, details, optional location. Create alert + audit event; enqueue notice only for designated handlers. | Reject invalid fields/role; idempotent request ID; rate limits; no broad broadcast. |
| acknowledgeSosAlert | Designated responder only. | alertId, optional response note. Set acknowledgement and append event atomically. | Reject unauthorized, duplicate/conflicting state; preserve audit. |
| updateSosStatus | Assigned/authorized handler. | alertId, allowed next state, note. Update lifecycle and history. | Validate state transition and handler scope. |
| submitIncident | Authenticated reporter; direct write or callable after rules review. | category, narrative, optional location/time. Create Submitted report and audit metadata. | Validate bounds; location optional; restrict attachments. |
| reviewIncident | Authorized reviewer. | incidentId, assignment/status/note. Update record and append history. | Check role and record scope on every call. |
| verifyHotline | Designated institutional verifier. | hotlineId, verification outcome, evidence reference/date. Enable/disable call action. | Require reviewer authority; audit all changes. |
| publishAnnouncement | Authorized publisher. | content, audience, dates, priority. Publish validated record. | Validate audience scope and content bounds. |
| exportReport | Authorized analyst/admin. | filters and selected report type. Return scoped export or job reference. | Bound query size; log export; protect sensitive fields. |

### 20.1 Contract conventions

- Use stable operation names and typed request/response models; version contracts when a breaking change is approved.

- Return machine-readable error codes such as unauthenticated, permission-denied, invalid-argument, not-found, failed-precondition, resource-exhausted, unavailable, and internal. Present human-safe messages in the client.

- Include correlation/request IDs in logs; never log passwords, tokens, full incident narratives, exact location, or hotline verification secrets.

- Make alert creation idempotent using a client-generated request ID with a bounded deduplication window; do not create duplicate SOS alerts on retry.

- For multi-document state changes, use a transaction or server-side operation and append a history record; define conflict behavior explicitly.

PLATFORM NOTE  Firebase callable functions can carry Firebase Auth and App Check tokens through the client SDK. The backend must still validate authorization and payloads. Server Admin SDK operations bypass Firestore Security Rules and therefore require careful IAM and application checks.
