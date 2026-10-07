# Data Dictionary and Access Contract

**Status:** proposed development schema; not approval to collect real data. D-03 and D-22 must close before production records exist. This contract narrows the prototype's broad data set to the minimum proposed initial-release collections.

## 1. Conventions

- Firestore document IDs are opaque IDs; Auth UID is used only for `users/{uid}` and owner-scoped paths.
- Persist timestamps as Firestore server timestamps/UTC instants. Never store locale-formatted dates.
- Every stored record carries a schema version only where migration compatibility requires it; do not add redundant fields without purpose.
- Server-trusted fields are created by Admin SDK/callable logic and cannot be client-set: `role`, `status`, `createdAt`, `createdBy`, `updatedAt`, actor UID, `recordedAt`, service-hour aggregates, audit event timestamp, QR token digest/result.
- Free-text lengths and allowed enum values must be enforced in client and backend. No raw maps cross into widgets.
- Unknown fields in privileged writes are rejected. Updates use exact affected-key allowlists.

### Proposed wire enums

- `UserRole`: `member`, `officer`, `admin` (the `organization` role is deferred).
- `AccountStatus`: `pending`, `approved`, `denied`, `blocked`, `suspended`, `deactivated`. Only `approved` enters protected routes. “Disabled” is descriptive copy, not a stored status value.
- `EventStatus` (persisted): `draft`, `published`, `cancelled`. `EventDisplayStatus` is derived: a published event is `upcoming` before `startsAt`, `ongoing` from `startsAt` through `endsAt`, and `completed` after `endsAt`; a cancelled event displays `cancelled`. Proposed transitions: draft→published/cancelled; published→cancelled; cancelled is terminal. A completed display state is time-derived and does not require a scheduled status write.
- `JoinRequestStatus`: `pending`, `approved`, `denied`, `cancelled`.
- `AttendanceStatus`: `present`, `absent`, `excused`.
- `AnnouncementStatus`: `draft`, `published`, `archived`; expiration is derived from `expiresAt`. `AnnouncementPriority`: `normal`, `high`, `urgent`. Initial `AnnouncementAudience`: `unit` only.

These wire values are proposed for development consistency; D-08/D-10/D-23 owners accept them before production use.

## 2. Initial collection definitions

| Path | Required fields | Optional fields | Writer / reader |
|---|---|---|---|
| `users/{uid}` | `uid`, `displayName`, `role`, `status`, `createdAt`, `updatedAt`, `revision`, `schemaVersion` | `email` (restricted), approved profile fields, `reviewedBy`, `reviewedAt`, `reviewReasonCode` when account review occurs | Trusted provisioning/admin operation creates role/status. Owner edits allowlisted self fields and increments revision via `updateOwnProfile`. Admin reads account metadata. Members do not browse the full collection by default. |
| `memberDirectory/{uid}` | `uid`, `displayName`, `directoryStatus` | approved affiliation/unit label only | Separate minimal projection for approved event officers to identify a roster; members read only if directory policy permits. Never use `users` as a field-redacted directory because Firestore rules authorize whole documents, not individual returned fields. |
| `events/{eventId}` | `title`, `startsAt`, `endsAt`, `venue`, `status`, `createdBy`, `createdAt`, `updatedAt`, `revision` | `description`, `audience`, `capacity`, `registrationRequired` only after scope approval | Trusted `saveEvent` creates/updates/cancels. Approved users read published records for their audience. |
| `eventJoinRequests/{requestId}` | `eventId`, `uid`, `status`, `createdAt`, `revision` | `reviewedBy`, `reviewedAt`, `reviewNote` (restricted) | Trusted request/review operation; owner reads own, event officer reviews. ID is `base64url(sha256(eventId + NUL + uid))` to enforce one request per pair. |
| `attendance/{attendanceId}` | `eventId`, `uid`, `status`, `source`, `recordedAt`, `recordedBy`, `revision` | check-in/out times and correction audit reference per D-10 | Trusted operation by event officer; member reads own. ID is `base64url(sha256(eventId + NUL + uid))`. All corrections audited. No client-writable total-hours field. |
| `announcements/{announcementId}` | `title`, `body`, `audience`, `status`, `createdBy`, `createdAt`, `updatedAt`, `revision` | `priority`, `publishAt`, `expiresAt` | Trusted `publishAnnouncement` manages; approved user reads published current audience record. |
| `auditLogs/{auditId}` | `actorUid`, `action`, `entityType`, `entityId`, `occurredAt`, `requestId` | minimal safe `beforeSummary`, `afterSummary`, `reasonCode` | Trusted backend creates only; designated admin reads paginated records; never client update/delete. |

The following remain **deferred collections** until corresponding decisions close: `incidents`, `qrDutySessions`, `qrDutyScans`, `userDevices`, `contactInquiries`, `backupRecords`, uploads/storage paths, analytics aggregates. Do not create empty rules that imply they are enabled. Each must receive its own fields/access/retention/query contract before implementation.

## 3. Field policy

Initially exclude birth date, home address, government/student ID, medical details, precise location, emergency contact, photos, free-form incident text, and personal phone/email from broad directories unless D-03 establishes necessity and restrictions. Public and member directory projection is separate from a private user profile. Never expose `email`, internal notes or account status to other members by default.

Suggested validation bounds for synthetic development fixtures (owner may adjust before approval): display name 1–100 characters; event title 1–160; venue 1–200; event description 0–2,000; announcement title 1–160; announcement body 1–4,000; reason code 1–500. Reject HTML/script markup where rich text is not explicitly supported. Bound list/page size at 50 and file upload at 0 until D-14 closes.

## 4. Access matrix (proposed)

Legend: **R** read, **C** create, **U** update, **D** delete; `own` is the authenticated owner; `scoped` is an officer assigned/authorized for that unit/event; **—** denied. Admin means trusted admin workflow, not direct client mutation.

| Collection/action | Anonymous | Pending/disabled | Member | Officer | Admin |
|---|---:|---:|---:|---:|---:|
| `users/{uid}` own approved projection | — | — | R own | R own | R |
| Self profile allowlist update | — | — | U own fields | U own fields | U own fields |
| Directory/private fields | — | — | — (unless separate approved projection) | R minimum scoped fields | R approved fields |
| Role/status/provision fields | — | — | — | — | C/U only through trusted endpoint |
| Published `events` | — | — | R | R, C/U scoped | R/C/U |
| Event join request | — | — | C/R own | R scoped/review U | R/U |
| Attendance | — | — | R own | R/C/U scoped | R/C/U trusted |
| Published announcements | — | — | R by audience | R | R |
| Announcement management | — | — | — | C/U if granted | C/U |
| `auditLogs` | — | — | — | — | R; backend-only create; no U/D |
| All unmatched paths | — | — | — | — | — |

The Firestore rule file must implement deny-by-default and corresponding ownership/role/status/field checks. This table is not complete for deferred collections and must be expanded before enabling them. An administrator is not exempt from audit or data-minimization requirements.

## 5. Queries and indexes

Initial query contract:

- `users/{uid}` direct document lookup; no full user listing for members.
- Events: `status == published` plus audience/time filters, ordered by `startsAt`, cursor pagination, page size ≤ 50. Staff queries have explicit status/date filters.
- Join requests: `uid == current UID` or `eventId == authorized event`, ordered by `createdAt`, bounded.
- Attendance: own `uid`/event filter or single event roster, ordered consistently by `recordedAt`; no unbounded member history.
- Announcements: `status == published`, audience-compatible query, publish/expiry bounds, order by `publishAt` descending, page size ≤ 50.
- Audit: admin-only action/date filters, order by server `occurredAt` descending, cursor pagination.

Before backend implementation, generate `firestore.indexes.json` from these exact compound query shapes and validate each against Firebase Emulator Suite. Do not guess indexes from screen design. Record actual indexes in this file when queries are approved.

## 6. Retention, deletion, export and migrations

Retention durations, member access/correction requests, account deletion/deactivation behavior, export authority and institutional record requirements are OPEN under D-03/D-20. Until decided, synthetic records only. Do not invent automatic deletion periods. Schema changes must document old/new fields, read/write compatibility, backfill, index deployment, rollback and data validation before applying to non-synthetic data.

