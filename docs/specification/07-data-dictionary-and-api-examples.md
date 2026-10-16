# Data Dictionary and API Examples

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 29. Field-Level Data Dictionary

This dictionary defines the proposed minimum fields for implementation planning. Types use Firestore concepts. “Required” applies when that record is created; optional fields must be omitted or null consistently. Field limits, retention, and sensitive-data classification require owner approval before implementation.

**Table 25. 29. Field-Level Data Dictionary — Collection / field / Type / required / Validation and purpose**

| Collection / field | Type / required | Validation and purpose |
| --- | --- | --- |
| users/{uid}.uid | string / yes | Must equal authenticated UID; immutable after creation. |
| users.displayName | string / yes | Approved display name; length/character policy to confirm. |
| users.email | string / conditional | Store only if account or contact workflow requires it; avoid duplicate source of truth if Auth is authoritative. |
| users.roleRef | string/reference / yes | Assigned by privileged workflow; user cannot self-change. |
| users.organizationIds | array<string> / conditional | Approved membership IDs; limit size and govern changes. |
| users.accountStatus | enum / yes | pending, active, suspended, rejected, deactivated; confirm transitions. |
| users.createdAt, updatedAt | timestamp / yes | Server-authoritative timestamps. |
| activities/{id}.title | string / yes | Non-empty; policy-defined maximum length. |
| activities.description | string / optional | Plain text or approved rich text; sanitize/display safely. |
| activities.startAt, endAt | timestamp / yes | endAt must be after startAt; timezone display policy required. |
| activities.ownerUid, organizationId | string / yes | Authenticated owner and approved organization scope. |
| activities.status | enum / yes | draft, published, ongoing, completed, cancelled; validate transitions. |
| participation/{uid}.state | enum / yes | requested, approved, denied, withdrawn, cancelled; attendance is a separate record. |
| participation.requestedAt, decidedAt | timestamp / conditional | Server time; decision actor recorded when applicable. |
| attendance/{uid}.status | enum / yes | present, absent, excused; additional states require approval. |
| attendance.recordedBy, recordedAt | UID + timestamp / yes | Record operator and server-authoritative time. |
| attendance.source | enum / yes | manual, qr, import; allow only approved values. |
| attendance.correctionReason | string / conditional | Required for post-close correction if policy says so; access restricted. |
| qrSessions.sessionId | string / yes | Opaque ID; must not reveal authority or contain personal data. |
| qrSessions.activityId, issuedBy | string / yes | Reference activity and authorized issuer. |
| qrSessions.validFrom, expiresAt | timestamp / yes | Short validity window determined by risk review. |
| qrSessions.nonceHash | string / conditional | Store verifier material safely; do not expose reusable secret in plaintext. |
| incidents.reporterUid | UID / yes | Authenticated reporter or approved assisted-report workflow. |
| incidents.category, narrative | enum + string / yes | Approved category; bounded narrative; escape on display. |
| incidents.severity | enum / optional | Use approved definitions; avoid unsupported scoring. |
| incidents.occurredAt, reportedAt | timestamp / conditional + yes | Occurred time may be unknown; reportedAt server time. |
| incidents.location, locationShared | GeoPoint + bool / optional | Set locationShared explicitly; false means no location and no map marker. Do not store sentinel coordinates; precision/source require approval. |
| incidents.status, assignedUid, version | enum + UID + integer / conditional | Server-incremented version for optimistic concurrency; duplicateOf and retentionExpiresAt fields; transitions and assignment authorized/audited. |
| sosAlerts.clientRequestId | string / yes | Idempotency key scoped to reporter; prevents duplicate retry creates. |
| sosAlerts.lifecycleStatus, version, retentionExpiresAt | enum + integer + timestamp / yes | Server-increment version on every accepted mutation; use expectedVersion; keep deliveryState distinct; apply retention expiry. |
| sosAlerts.deliveryState | enum / yes | pending, sent, failed, unknown; never equate provider acceptance with human receipt. |
| sosAlerts.location, locationShared, details, retentionExpiresAt | GeoPoint + bool + string + timestamp / optional | Explicit boolean prevents sentinel coordinates; apply approved retention and restricted access. |
| hotlines.phoneE164 | string / yes | Institution verified number in approved normalized format. |
| hotlines.verificationState | enum / yes | draft, pendingVerification, verified, rejected, expired, disabled. |
| hotlines.verifiedBy, verifiedAt, reviewDueAt | UID + timestamps / conditional | Required before a number can be enabled; audit changes. |
| auditEvents.actorUid, action, occurredAt | UID + enum + timestamp / yes | No credentials/tokens or unnecessary narrative/location in logs. |

### 29.1 Common record conventions

- Use server timestamps for authoritative create/update/audit events; never trust a client-provided timestamp for authorization or ordering.

- Use stable IDs and explicit references; avoid putting sensitive information in document IDs.

- Use bounded strings, enums, and allowlisted fields; reject unknown privileged fields instead of silently accepting them.

- Keep state history separate from mutable current-state fields when a full audit trail is required.

- Document ownership and deletion behavior for every collection and subcollection; deleting a parent must not silently orphan sensitive child records.

## 30. Request and Response Examples

The examples below define a candidate callable API shape for review. Use JSON-compatible values; final SDK wrappers and error envelopes are implementation decisions. Authorization, validation, and state transitions must be enforced server-side even if the client performs matching validation.

### 30.1 Create SOS alert

Request (illustrative):

{

"clientRequestId": "client-generated-opaque-id",

"category": "urgent-assistance",

"message": "Short user-entered details",

"location": { "latitude": 0.0, "longitude": 0.0 },

"locationShared": true

}

Response (illustrative): { "alertId": "opaque-id", "lifecycleStatus": "submitted", "deliveryState": "pending", "version": 1, "createdAt": "server timestamp" }

If location is declined or unavailable, omit the location object and set locationShared false. Do not use coordinates (0,0) as a missing-value sentinel in production.

### 30.2 Acknowledge or update alert

Request (illustrative): { "alertId": "opaque-id", "expectedVersion": 3, "note": "Responder update" }

Response: { "alertId": "opaque-id", "lifecycleStatus": "acknowledged", "version": 4, "acknowledgedAt": "server timestamp", "eventId": "opaque-id" }

- Require designated responder membership, permitted transition, expected version/state, bounded note, and atomic current-state plus history write.

### 30.5 Error contract

**Table 26. 30.5 Error contract — Code / Meaning / Client behavior**

| Code | Meaning | Client behavior |
| --- | --- | --- |
| unauthenticated | No valid signed-in identity. | Route to sign-in; preserve no sensitive unsent data. |
| permission-denied | Role, assignment, or organization scope does not allow action. | Show safe message; do not retry automatically. |
| invalid-argument | Malformed or out-of-policy request. | Show field-level guidance. |
| not-found | Record is absent or intentionally hidden from caller. | Show unavailable state without leaking existence. |
| failed-precondition | Transition, status, verification, or environment condition blocks action. | Refresh current state and explain required next step. |
| resource-exhausted | Approved rate or quota limit reached. | Back off; provide safe fallback guidance. |
| unavailable | Network/backend temporarily unavailable. | Show unknown delivery state; offer controlled retry using same idempotency key. |
| internal | Unexpected service failure. | Show safe error and correlation ID; never disclose stack trace. |

### 30.6 Submit incident (illustrative)

Request: { "clientRequestId": "opaque-id", "category": "safety", "narrative": "Bounded user report", "occurredAt": null, "locationShared": false }

Response: { "incidentId": "opaque-id", "status": "submitted", "version": 1, "reportedAt": "server timestamp" }. If locationShared is true, require a valid location payload and record the approved precision/source; otherwise omit location entirely.

### 30.7 Review incident (illustrative)

Request: { "incidentId": "opaque-id", "expectedVersion": 1, "nextStatus": "underReview", "note": "Triage note" }

Response: { "incidentId": "opaque-id", "status": "underReview", "version": 2, "eventId": "opaque-id" }. Require current reviewer designation, organization scope, valid transition, and transactional state plus history write. A stale expectedVersion returns a conflict and makes no partial mutation.

### 30.8 Idempotency and concurrency

- The server stores the request ID with the created alert and returns the original alert for a replay by the same reporter.

- A repeated request ID with a different payload is rejected and audited without overwriting the original alert.

- State updates use expected current state/version or transaction validation to prevent conflicting responder updates.

- Notification retries are tracked per delivery attempt and do not re-create alert records or imply acknowledgement.
