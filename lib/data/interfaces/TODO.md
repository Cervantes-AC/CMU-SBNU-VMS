# TODO: interfaces

**Status:** AuthRepository interface and barrel implemented (`lib/data/interfaces/auth_repository.dart`). The interface follows the documented convention (typed Results/Streams; no raw collection names). Additional repository interfaces (user, event, attendance, incident, announcement) remain to be defined. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `data/interfaces/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/data.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Use typed domain parameters/outcomes. No raw paths, arbitrary maps, caller supplied actor UID, or client authority.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

## Interfaces (`lib/data/interfaces/`)

Each interface uses `Future<Result<T>>` for one-shot operations and typed `Stream<T>` for live observation; if the project settles on exceptions instead, use one consistent documented convention. Methods take domain IDs and typed filters/page cursors, never raw collection names or arbitrary field maps. Every mutating method states its idempotency and actor source.

### `auth_repository.dart` â€” `AuthRepository`

Methods: `watchSession()`, `signIn(email,password)`, `sendPasswordReset(email)`, `signOut()`, `refreshSession()`, `currentUid`. Return auth identity separately from `UserProfile`; repository must not decide admin authorization. Registration exists only if approved and creates a pending profile through a safe workflow. No password storage/logging.

### `user_repository.dart` â€” `UserRepository`

Methods: `watchCurrentProfile(uid)`, `getProfile(uid)`, `updateOwnProfile(uid, ProfilePatch)`, paged authorized directory query, and admin operations `reviewAccount`/`changeRole` only when routed through trusted service. A normal profile patch cannot contain role/status/UID/created time/hours. Define separate DTO for changes.

### `event_repository.dart` â€” `EventRepository`

Methods: paginated `watchPublishedEvents(EventFilter, PageCursor?)`, `getEvent(id)`, authorized create/update/cancel, `requestToJoin`, and officer roster/review query only if approved. Operations validate legal transitions and are safe on retry.

### `attendance_repository.dart` â€” `AttendanceRepository`

Methods: member's own records, authorized event roster, mark/update attendance, submit correction request, authorized correction, aggregate service-hour summary. No caller supplies actor UID or arbitrary hours; implementation obtains current actor and trusted server validates.

### `incident_repository.dart` â€” `IncidentRepository`

Methods: submit report, reporter's own incident stream, responder-authorized paged queue/detail, transition status, append response note if approved, request SOS notification. Keep report submission available when location permission is denied. Sensitive responder APIs are separately authorized.

### `announcement_repository.dart` â€” `AnnouncementRepository`

Methods: visible audience stream/page, get published detail, authorized create/update/publish/archive. No public draft read.

### `audit_log_repository.dart` â€” `AuditLogRepository`

Methods: paged filtered audit query with allowlisted filters and export projection. Read-only. Audit entries are written from trusted backend operation, not this repository.

### `qr_duty_repository.dart` â€” `QrDutyRepository`

Methods: create/close session via trusted endpoint, obtain member-appropriate scan challenge without exposing secret, `submitScan(payload)` idempotently, own scan history, authorized event monitoring. Never accept client-supplied member identity, scan time or hours as authority.

### `interfaces.dart`

Barrel export of stable public interfaces only. Must not expose concrete Firebase adapter classes.

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

