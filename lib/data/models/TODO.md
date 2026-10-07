# TODO: models

**Status:** Planning scaffold. This file is an implementation plan, not proof of implementation or approval for a deferred capability. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `data/models/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/data.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Immutable domain values; parse malformed/unknown data safely and omit privileged/unapproved fields.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

## Models (`lib/data/models/`)

Every model is immutable, has a validating factory/parser and a serializer, and documents required/optional fields plus schema-version behavior. Use Firestore `Timestamp` internally at the service boundary and UTC `DateTime` in domain models. Do not serialize privileged fields from client input.

### `user.dart` â€” `UserProfile`, `UserRole`, `AccountStatus`

Fields: `uid`, restricted `email` as needed, `displayName`, role, account status, created/updated timestamps, `revision`, approved non-sensitive profile fields, optional photo URL only if approved, schema version. User, role and status wire values are defined in [data-and-access.md](../../../docs/architecture/data-and-access.md). Keep `totalServiceHours` out of a client-writable profile; prefer a server-computed summary or query. Include `canAccessApp` derived from approved status, not serialized as authority. Provide `fromMap`, `toMap`/Firestore serialization, `copyWith`, and field allowlist helpers. Tests cover unknown enum values, role/status parsing, malformed required fields, and serialization of only approved fields.

### `event.dart` â€” `Event`, `EventStatus`, `EventAudience`

Fields: ID, title, description, start/end time, venue, persisted lifecycle status, created/updated actor/times, `revision`, optional audience/capacity/registration flags if requirements approve them. Proposed persisted and derived display statuses are in [data-and-access.md](../../../docs/architecture/data-and-access.md). Methods: validating factory, `displayStatusAt(now)`, `isJoinableAt(now)`, legal transition check (pure policy helper), serialization. Do not embed unbounded attendee lists or join requests in event documents. Tests cover intervals, capacity and lifecycle invariants.

### `attendance.dart` â€” `AttendanceRecord`, `AttendanceStatus`, `AttendanceSource`

Fields: ID, event ID, member UID, state, recorded time/by, source, optional approved check-in/out facts, revision/correction reference. Distinguish a correction from a duplicate. Service-hour result should be calculated, not set by a member. Tests cover status mapping and impossible combinations.

### `incident.dart` â€” `Incident`, `IncidentCategory`, `IncidentSeverity`, `IncidentStatus`, `ConsentLocation`

Fields: ID, reporter UID, category/severity, user description, lifecycle status, created/updated time, assigned responder identifiers if approved, response note with access controls, optional latitude/longitude plus capture time and explicit consent metadata. Do not store location when consent is absent. Never put sensitive narrative into `toString()`. Tests cover location absent/consented, coordinates bounds, valid transitions and field redaction.

### `announcement.dart` â€” `Announcement`, `AnnouncementPriority`, `AnnouncementStatus`

Fields: ID, title/body, priority, audience, publication/expiry schedule, status, author and server timestamps, `revision`. Proposed wire values are in [data-and-access.md](../../../docs/architecture/data-and-access.md). Provide `isVisibleAt(now, viewerAudience)` as pure logic, with timezone-independent timestamp comparisons. Tests cover draft visibility, expiry and audience.

### `audit_log.dart` â€” `AuditLogEntry`, `AuditAction`, `AuditEntityType`

Fields: ID, actor UID, action, entity type/ID, server occurrence time, safe minimal before/after summary, request/correlation ID. Audit model is read-only in the client: no create/update/delete API exposed to features. Sanitize values and exclude secrets/free-text narratives. Tests ensure immutable shape and redaction.

### `qr_duty_record.dart` â€” `QrDutySession`, `QrDutyScan`, `QrDutyAction`, `QrScanResult`

Represent session metadata separately from scan evidence. Client model never contains the signing secret/token digest. Session has event ID, start/expiry, state and issuer; scan has UID, event/session IDs, action and server timestamp/result. Scan result uses explicit accepted/rejected reason codes safe to show the member. Tests cover expiry, state, action sequence and replay result mapping.

### `models.dart`

Barrel export only the public model types above. No business logic. Tests/build lint ensure imports do not create cycles and adding a model requires a deliberate barrel update.

## Implementation checklist

- [ ] Confirm backlog stage and dependencies. If a prerequisite contract is missing, scope that work explicitly before building dependent UI.
- [ ] Create the named files and only justified local helpers. Preserve specified public APIs, file responsibilities, route names, domain invariants, and view-state behavior.
- [ ] Inject dependencies. Keep presentation, orchestration, domain policy, persistence, and SDK/platform adapters separated; avoid hidden global clients.
- [ ] Handle validation, persisted-data parsing, bounded pagination, retries/idempotency, and relevant loading, empty, stale/offline, failure, permission-denied, and conflict states.
- [ ] Enforce record and role scope in backend/rules as well as UI affordances. Derive actor identity and privileged values on the trusted side.
- [ ] Redact personal/sensitive data from logs, errors, analytics labels, cache, exports, URLs, and serialized payloads. Clear user-scoped state at sign-out/revocation where applicable.
- [ ] Update related data, route, backend, environment, operations, and backlog documentation when contracts or dependencies change. Record unresolved decisions.

## Acceptance and handoff

- [ ] All required files meet their specified responsibilities; no undeclared privileged behavior was added.
- [ ] Routes and repositories use the intended access policy; backend denial remains authoritative.
- [ ] Canonical boundary, retry, concurrency/idempotency, failure, and unauthorized-access scenarios are accounted for.
- [ ] Handoff states changed files, actual verification performed, unverified acceptance cases, configuration/migration needs, open decisions, and limitations.

**Verification rule:** Scenarios here and in canonical specifications describe future required evidence. They do not authorize adding or running tests. Follow [`AGENTS.md`](../../../AGENTS.md) and [testing/review guidance](../../../docs/ai-coding/testing-and-review.md).

