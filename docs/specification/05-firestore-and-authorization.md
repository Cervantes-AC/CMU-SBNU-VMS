# Firestore and Authorization

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 21. Firestore Schema and Query Plan

The following is a proposed schema, not a deployed database. Prefer stable document IDs, explicit createdAt/updatedAt timestamps, and bounded documents. Store growing histories in subcollections or separate collections rather than unbounded arrays. Denormalize only fields needed for approved query and authorization patterns.

**Table 17. 21. Firestore Schema and Query Plan — Collection / path / Core fields (illustrative) / Read/write boundary**

| Collection / path | Core fields (illustrative) | Read/write boundary |
| --- | --- | --- |
| users/{uid} | uid, displayName, email (if needed), roleRef, organizationIds, accountStatus, createdAt, updatedAt. | User reads permitted profile; self-edit allowlist; privileged role/status writes only. |
| organizations/{orgId} | name, parentOrgId, status, coordinatorUids, createdAt, updatedAt. | Members read their assigned organization; admin changes controlled. |
| activities/{activityId} | title, description, startAt, endAt, venueLabel, optional geo, ownerUid, organizationId, status, capacity, timestamps. | Public/approved discovery policy to confirm; assigned staff write. |
| activities/{id}/participation/{uid} | uid, state (requested, approved, denied, withdrawn, cancelled), requestedAt, decisionBy, decisionAt. | Participant reads own request; scoped coordinator decides. |
| activities/{id}/attendance/{uid} | uid, attendanceStatus, recordedBy, recordedAt, source, correctionReason. | Participant reads own; assigned coordinator writes; correction logged. |
| qrSessions/{sessionId} | activityId, issuedBy, validFrom, expiresAt, sessionStatus, tokenHash/keyVersion, server-managed nonce or signed token reference, createdAt. | Server issues and validates short-lived signed tokens; never expose signing secret or reusable bearer token in readable Firestore data. |
| announcements/{announcementId} | title, body, audienceRule, priority, publishAt, expiresAt, authorUid, status. | Approved users read matched audience; authorized publishers write. |
| incidents/{incidentId} | reporterUid, organizationId, category, narrative, severity, occurredAt, reportedAt, optional location, status, assignedUid, server-incremented version, locationShared, duplicateOf, retentionExpiresAt. | Reporter and scoped reviewers only; protect attachments separately. |
| incidents/{id}/history/{eventId} | fromStatus, toStatus, actorUid, eventAt, noteRef, actionType. | Create via authorized operation; no client update/delete. |
| sosAlerts/{alertId} | reporterUid, clientRequestId, createdAt, details, optional location, locationShared, lifecycleStatus, deliveryState, assignedHandlerUid, acknowledgedAt, server-incremented version, retentionExpiresAt. | Reporter limited view; designated handlers access details. |
| sosAlerts/{id}/events/{eventId} | eventType, actorUid/systemActor, eventAt, minimal details. | Append-only intent; server-authorized creation; restricted read. |
| alertDeliveries/{deliveryId} | alertId, handlerUid, channel, state, attemptAt, providerMessageId (if safe). | Server-only; minimize retention and identifiers. |
| hotlines/{hotlineId} | label, phoneE164, coverage, hours, verificationState, verifiedBy, verifiedAt, reviewDueAt, active. | Read only approved entries; designated verifier updates. |
| auditEvents/{eventId} | actorUid, action, recordType, recordId, occurredAt, outcome, minimal changed fields. | Authorized audit readers; append-only via trusted path. |
| reportJobs/{jobId} | requestedBy, type, filters, status, createdAt, expiresAt, outputRef. | Requester/admin scoped; expire outputs by policy. |

### 21.1 Enumerations and validation

**Table 18. 21.1 Enumerations and validation — Domain / Proposed values / validation**

| Domain | Proposed values / validation |
| --- | --- |
| Account | pending, active, suspended, rejected, deactivated; approve exact states and allowed transitions. |
| Activity | draft, published, ongoing, completed, cancelled; define date and transition validation. |
| Attendance | present, absent, excused; For confirmation — late/partial and correction semantics. |
| Incident lifecycle | submitted, underReview, actionInProgress, resolved, reopened, closed, rejected, duplicate; define permitted transitions and duplicate linkage. |
| SOS lifecycle | submitted, acknowledged, actionInProgress, resolved, cancelled, falseAlarm, closed; delivery state is separate; cancellation/falseAlarm/closure requires policy and audit. |
| Delivery state | pending, sent, failed, unknown; sent means provider accepted request, not human receipt. |
| Hotline verification | draft, pendingVerification, verified, rejected, expired, disabled. |
| QR session | scheduled, active, expired, revoked; enforce server time and one-use/anti-replay policy. |

### 21.2 Query and index plan

- Volunteer roster by organization and account status; paginate and avoid unbounded reads.

- Activities by status, start time, and organization; decide whether public and authenticated discovery differ.

- Attendance by activity and date; personal attendance by user and date.

- Incidents by status, category, organization, and reportedAt; map queries must be bounded and location access controlled.

- SOS queue by recipient/assignment and lifecycle status; notifications must not rely on an unbounded global query.

- Hotline directory by active and verification state; client queries only approved current entries.

- Create composite indexes after query patterns are approved; track required indexes in version control and test in staging.

Attendance history storage/query alignment: attendance documents remain at activities/{activityId}/attendance/{uid}, and each document carries uid, organizationId, and recordedAt. Personal history uses a collection-group query on attendance where uid equals the signed-in user, ordered by recordedAt descending; add a composite index with query scope COLLECTION_GROUP for uid ASC + recordedAt DESC. Keep the document ID equal to uid where practical, but authorize using a validated uid field.

Illustrative Firestore Rules v2 pattern (must be tested against the deployed rule version and exact query): rules_version = '2'; service cloud.firestore { match /databases/{database}/documents { function signedIn() { return request.auth != null; } match /{path=**}/attendance/{attendanceId} { allow get, list: if signedIn() && resource.data.uid == request.auth.uid; } } }. This recursive rule applies to every collection named attendance, so all such documents must use the same uid ownership invariant. Coordinator queries need their own scoped constraints and rule tests.

## 22. Authorization and Security Rules Matrix

Start Firestore Rules from deny-by-default and add access paths only for approved product behavior. Firestore rules authorize requests; they do not filter a broad query into an authorized subset. Design each query and rule together. The trusted Admin SDK used by server functions bypasses Firestore Rules, so function code and IAM require separate authorization tests.

**Table 19. 22. Authorization and Security Rules Matrix — Data area / Volunteer/member / Officer/coordinator / Admin**

| Data area | Volunteer/member | Officer/coordinator | Admin | Server function |
| --- | --- | --- | --- | --- |
| Own user profile | Read own; update allowlist | Read assigned scope if approved | Manage approved account fields | Privileged account transitions only |
| Organization | Read assigned | Read/manage assigned scope | Manage approved hierarchy | Validate privileged changes |
| Activities/participation | Read eligible; own request | Manage assigned activities | System administration | Optional invariant checks |
| Attendance | Read own | Record/correct assigned activity | Admin correction if approved | Optional validation/audit |
| Announcements | Read matched audience | Publish only approved audiences | Manage publisher settings | Optional scheduled publish |
| Incidents | Create; read own limited details | Read assigned; update if reviewer | Full review only if policy | Route/validate privileged transitions |
| SOS alerts | Create if permitted; limited own state | Only if designated responder | Admin only if assigned policy grants | Create/route/ack/status with explicit checks |
| Hotlines | Read verified active | Read verified active | Edit only if designated | Verification state changes if approved |
| Audit/export | No broad audit access | Scoped review if approved | Authorized review/export | Create restricted audit records |

### 22.1 Rule and identity requirements

- Keep authorization roles in trusted claims or protected profile fields; users cannot elevate their own role, status, organization assignment, or responder designation.

- Validate document keys, allowed fields, types, required fields, ownership, organization scope, and legal status transitions.

- Avoid broad recursive allow rules and never deploy test rules that allow all reads/writes.

- Test allowed and denied reads/writes for each role, including missing profile, suspended account, changed assignment, and malicious field injection.

- Review rules for query compatibility and document-level exposure; validate attachment/storage rules separately if files are enabled.

- Protect privileged function service accounts with least-privilege IAM; do not treat successful authentication as sufficient authorization.
