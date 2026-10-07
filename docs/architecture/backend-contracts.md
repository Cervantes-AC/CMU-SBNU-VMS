# Trusted Backend Contracts

**Status:** proposed contracts for implementation against the target `cmu-sbnu-vms` development/emulator environment. Do not deploy or process real data until the applicable decisions close. These contracts define the client/server boundary; implementation can use callable Functions or an equivalent authenticated server, but client code must not acquire Admin privileges.

## 1. Common request/response rules

- Authenticate with Firebase Auth. Derive `actorUid` from the verified request context; reject any payload attempting to provide actor identity, role, timestamp or trusted result.
- Require an approved user profile for all operational calls. Admin-only calls additionally require `role == admin`; scoped officer calls verify the officer is allowed to manage the referenced event/unit.
- Validate exact keys, strings/enums, document existence, status transitions, bounds and ownership on the server. Reject unknown fields.
- Use server timestamps. Use Firestore transactions for read-check-write invariants and idempotency.
- Return a small stable response object and stable error codes; never return raw documents or exception messages.
- Record append-only audit entry for privileged/consequential operations in the same transaction where practical. Audit logging failure must fail the mutation rather than silently lose auditability.
- Calls are rate-limited where abuse can cause cost or harm. Verify App Check when enabled by approved deployment policy.

Common success shape:

```json
{"ok": true, "requestId": "opaque-correlation-id", "entityId": "opaque-id"}
```

Common error codes: `unauthenticated`, `account_not_approved`, `permission_denied`, `invalid_argument`, `not_found`, `failed_precondition`, `already_exists`, `resource_exhausted`, `unavailable`, `internal`. Client maps these to safe messages. Do not expose document existence across unauthorized boundaries.

## 2. Initial callable operations

### `updateOwnProfile`

**Auth:** approved user; UID always derived from auth.  
**Request:** `{ displayName: string, optionalApprovedFields?: object, expectedRevision: integer }`. `optionalApprovedFields` must be an explicit allowlist finalized under D-09; reject unknown keys.  
**Server:** check account remains approved, validate lengths/normalization, compare revision, update private `users/{uid}` fields and the minimal `memberDirectory/{uid}` projection atomically. Never accept role/status/email/UID/timestamps/service totals.  
**Response:** `{ ok, requestId, entityId: uid, revision }`.  
**Idempotency:** same desired values may safely be submitted again; stale revision returns `failed_precondition`.

### `saveEvent`

**Auth:** approved officer/admin; officer must have the event-management scope defined by D-08.  
**Request:** create `{ action: "create", title, startsAt, endsAt, venue, description?, audience?, idempotencyKey }`; update `{ action: "update", eventId, expectedRevision, title, startsAt, endsAt, venue, description?, audience? }`; cancel `{ action: "cancel", eventId, expectedRevision, reasonCode, idempotencyKey }`. Only allowlisted content fields are client writable.  
**Server:** validate time interval, bounds, audience and legal lifecycle transition (`draft`→`published`/`cancelled`; `published`→`cancelled`); derive creator/updater, status and timestamps; use transaction/revision check; write a minimal audit record atomically for create/update/cancel. Client cannot set actor, ID, status, transition, revision or audit fields. `upcoming`/`ongoing`/`completed` are derived display states for published events.  
**Response:** `{ ok, requestId, entityId, status, revision }`.  
**Idempotency:** create uses actor-scoped key; updates use expected revision and reject stale writes.

### `requestEventParticipation`

**Auth:** approved member.  
**Request:** `{ eventId: string, idempotencyKey: string }`; UID and request time are server-derived.  
**Server:** verify event is published/joinable, enforce capacity/eligibility policy when defined, and transactionally create one request for UID+event. Derive `requestId = base64url(sha256(eventId + NUL + uid))`; do not accept a caller-selected document ID.  
**Response:** `{ ok, requestId, entityId, status }`.  
**Idempotency:** repeated request returns the existing state rather than creating duplicates.

### `reviewEventParticipation`

**Auth:** approved officer/admin authorized for the event.  
**Request:** `{ eventId: string, memberUid: string, decision: "approve" | "deny", expectedRevision: integer, reasonCode?: string, idempotencyKey: string }`.  
**Server:** locate the deterministic event+UID request ID, reject missing/stale/terminal requests, derive reviewer/time, update status/revision, and write an audit entry transactionally.  
**Response:** `{ ok, requestId, entityId, status, revision }`.

### `adminReviewAccount`

**Auth:** approved `admin`; recent authentication/step-up check if D-07 owner requires it.  
**Request:** `{ uid: string, decision: "approve" | "deny", reasonCode: string }`  
**Server:** validate target is pending; disallow changing the caller's own initial bootstrap status; update `users/{uid}.status`, `updatedAt`, increment `revision`, and write `reviewedBy`, `reviewedAt`, `reviewReasonCode`; write audit event. Do not accept a role in this request.  
**Response:** `{ ok, requestId, entityId: uid, status }` (status only returned to authorized admin).  
**Idempotency:** repeating the same terminal decision returns the existing result; contradictory repeated decision returns `failed_precondition`.

### `adminSetUserRole`

**Auth:** approved admin and any step-up condition.  
**Request:** `{ uid: string, role: "member" | "officer" | "admin", reasonCode: string, idempotencyKey: string }`. `admin` assignment requires an owner-controlled bootstrap/second-approver policy under D-07/D-08; do not implement public self-escalation.  
**Server:** check target exists/approved; apply approved role matrix; update profile, increment `revision`, and update any claims only if claims are the selected architecture; write audit event. Keep profile/claims synchronized and define token refresh behavior.  
**Response:** `{ ok, requestId, entityId: uid, role }`.  
**Idempotency:** key scoped to actor/action/target, replay returns original outcome.

### `recordAttendance`

**Auth:** approved officer/admin authorized for `eventId`.  
**Request:** `{ eventId: string, memberUid: string, status: "present" | "absent" | "excused", idempotencyKey: string }`. No client time, hours, actor, correction, or raw profile payload.  
**Server:** verify event published/attendance window and roster policy; derive `attendanceId = base64url(sha256(eventId + NUL + memberUid))`; create one attendance record transactionally with `source: "officer"`; derive actor and server time; write audit event. If a record already exists, return the prior result only for the same idempotency key/body; otherwise return `already_exists` and require `correctAttendance`. Never overwrite a prior result through this operation.  
**Response:** `{ ok, requestId, entityId: attendanceId, status }`.  
**Idempotency:** same key and body returns the same outcome; same key/different body rejects.

### `correctAttendance`

**Auth:** approved officer/admin with correction authority defined by D-10/D-25.  
**Request:** `{ attendanceId: string, expectedRevision: integer, newStatus: enum, reason: string, idempotencyKey: string }`.  
**Server:** compare revision; reject stale edit; update current record and append an immutable `auditLogs` entry containing minimal previous/new status, reason code, server actor/time, and resulting revision in one transaction. Enforce reason bounds.  
**Response:** `{ ok, requestId, entityId: attendanceId, revision: integer }`.

### `publishAnnouncement`

**Auth:** approved officer/admin only if authoring permissions are accepted under D-08.  
**Request:** create `{ action: "saveDraft" | "publish", title, body, audience: "unit", priority: "normal" | "high" | "urgent", publishAt?, expiresAt?, idempotencyKey }`; update `{ action: "saveDraft" | "publish" | "archive", announcementId, expectedRevision, title?, body?, audience?, priority?, publishAt?, expiresAt? }`.  
**Server:** validate exact action fields, audience/priority, size, schedule and legal status transition; derive author/timestamps/revision; write audit on publish/archive. Draft visibility is denied by rules.  
**Response:** `{ ok, requestId, entityId, status, revision }`.

## 3. Deferred operations (contract before code)

Do not implement these until matching decisions close. This section defines required contract shape so feature planning starts without reopening architecture from scratch:

- `createQrDutySession`: officer, authorized event, explicit validity window; server-generated random secret whose digest is stored; QR payload carries opaque session ID + signed/opaque token only; response includes renderable token and expiry. Secret is never readable from Firestore.
- `submitQrDutyScan`: verified member, opaque token/action/idempotency key; server checks signature/digest, expiry, event state, member eligibility, action order and replay; server timestamp; minimal scan response.
- `submitIncident`: reporter derived from auth, approved category/description, explicit location-consent flag and coordinates only when consented; responder-only reads; rate limit and audit. Full exact payload remains blocked by D-11.
- `registerDeviceToken` / `removeDeviceToken`: authenticated UID derived from context; validate token length/platform; store only under owner path; remove on sign-out; payload content contains no incident details.
- `createReportExport`: authorize report type, date range, field allowlist and max rows; use short-lived download URL only if approved; audit before returning export. Blocked by data/export approvals.
- `restoreData`: not a client callable. Separate privileged operator workflow with dual approval, staging rehearsal, backup ID and rollback. Client app must not get general restore authority.

## 4. Firestore rules vs trusted code

Use Firestore rules for protected reads, field allowlists, owner-only profile patches, safe event/announcement state bounds and deny-by-default. Use trusted functions for role/status grants, audit writes, attendance corrections/hour facts, QR validation, token fan-out, broad export and any operation needing Admin SDK privilege. Rules remain deny-by-default for collections/functions not yet implemented. Admin SDK bypasses rules, so every function repeats its own authentication/authorization/validation checks.

## 5. Backend source layout and deployment

When Functions are selected, planned source layout:

```text
functions/
  package.json                 # pinned runtime/dependencies and lint/build/test scripts
  package-lock.json
  tsconfig.json                # strict TypeScript
  src/index.ts                 # exports only; no workflow implementation
  src/shared/{auth,validation,audit,errors,idempotency}.ts
  src/accounts/{review_account,set_role,update_profile}.ts
  src/events/{save_event,request_participation,review_participation}.ts
  src/attendance/{record_attendance,correct_attendance}.ts
  src/announcements/publish_announcement.ts
  test/{authorization,unit,integration}/
```

Exact source function names must match deployed export names and this document. Node runtime is a deliberate versioned environment decision; pin the runtime supported by the selected Firebase Functions generation in package/CI and record it under D-27 before deploy. Deploy rules/indexes/functions to staging first; never deploy by relying on CLI default project.

