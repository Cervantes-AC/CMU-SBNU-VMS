# Data Layer File Specifications

Data contracts and proposed Firestore shapes are described in [the implementation guide](../architecture/implementation-guide.md#5-data-contracts-and-firestore-schema). Obtain approval for the data dictionary before production collection. Names below define client APIs; repositories must be injectable and must not expose Firebase SDK types to features unless unavoidable at a service boundary.

## Models (`lib/data/models/`)

Every model is immutable, has a validating factory/parser and a serializer, and documents required/optional fields plus schema-version behavior. Use Firestore `Timestamp` internally at the service boundary and UTC `DateTime` in domain models. Do not serialize privileged fields from client input.

### `user.dart` — `UserProfile`, `UserRole`, `AccountStatus`

Fields: `uid`, restricted `email` as needed, `displayName`, role, account status, created/updated timestamps, `revision`, approved non-sensitive profile fields, optional photo URL only if approved, schema version. User, role and status wire values are defined in [data-and-access.md](../architecture/data-and-access.md). Keep `totalServiceHours` out of a client-writable profile; prefer a server-computed summary or query. Include `canAccessApp` derived from approved status, not serialized as authority. Provide `fromMap`, `toMap`/Firestore serialization, `copyWith`, and field allowlist helpers. Tests cover unknown enum values, role/status parsing, malformed required fields, and serialization of only approved fields.

### `event.dart` — `Event`, `EventStatus`, `EventAudience`

Fields: ID, title, description, start/end time, venue, persisted lifecycle status, created/updated actor/times, `revision`, optional audience/capacity/registration flags if requirements approve them. Proposed persisted and derived display statuses are in [data-and-access.md](../architecture/data-and-access.md). Methods: validating factory, `displayStatusAt(now)`, `isJoinableAt(now)`, legal transition check (pure policy helper), serialization. Do not embed unbounded attendee lists or join requests in event documents. Tests cover intervals, capacity and lifecycle invariants.

### `attendance.dart` — `AttendanceRecord`, `AttendanceStatus`, `AttendanceSource`

Fields: ID, event ID, member UID, state, recorded time/by, source, optional approved check-in/out facts, revision/correction reference. Distinguish a correction from a duplicate. Service-hour result should be calculated, not set by a member. Tests cover status mapping and impossible combinations.

### `incident.dart` — `Incident`, `IncidentCategory`, `IncidentSeverity`, `IncidentStatus`, `ConsentLocation`

Fields: ID, reporter UID, category/severity, user description, lifecycle status, created/updated time, assigned responder identifiers if approved, response note with access controls, optional latitude/longitude plus capture time and explicit consent metadata. Do not store location when consent is absent. Never put sensitive narrative into `toString()`. Tests cover location absent/consented, coordinates bounds, valid transitions and field redaction.

### `announcement.dart` — `Announcement`, `AnnouncementPriority`, `AnnouncementStatus`

Fields: ID, title/body, priority, audience, publication/expiry schedule, status, author and server timestamps, `revision`. Proposed wire values are in [data-and-access.md](../architecture/data-and-access.md). Provide `isVisibleAt(now, viewerAudience)` as pure logic, with timezone-independent timestamp comparisons. Tests cover draft visibility, expiry and audience.

### `audit_log.dart` — `AuditLogEntry`, `AuditAction`, `AuditEntityType`

Fields: ID, actor UID, action, entity type/ID, server occurrence time, safe minimal before/after summary, request/correlation ID. Audit model is read-only in the client: no create/update/delete API exposed to features. Sanitize values and exclude secrets/free-text narratives. Tests ensure immutable shape and redaction.

### `qr_duty_record.dart` — `QrDutySession`, `QrDutyScan`, `QrDutyAction`, `QrScanResult`

Represent session metadata separately from scan evidence. Client model never contains the signing secret/token digest. Session has event ID, start/expiry, state and issuer; scan has UID, event/session IDs, action and server timestamp/result. Scan result uses explicit accepted/rejected reason codes safe to show the member. Tests cover expiry, state, action sequence and replay result mapping.

### `models.dart`

Barrel export only the public model types above. No business logic. Tests/build lint ensure imports do not create cycles and adding a model requires a deliberate barrel update.

## Interfaces (`lib/data/interfaces/`)

Each interface uses `Future<Result<T>>` for one-shot operations and typed `Stream<T>` for live observation; if the project settles on exceptions instead, use one consistent documented convention. Methods take domain IDs and typed filters/page cursors, never raw collection names or arbitrary field maps. Every mutating method states its idempotency and actor source.

### `auth_repository.dart` — `AuthRepository`

Methods: `watchSession()`, `signIn(email,password)`, `sendPasswordReset(email)`, `signOut()`, `refreshSession()`, `currentUid`. Return auth identity separately from `UserProfile`; repository must not decide admin authorization. Registration exists only if approved and creates a pending profile through a safe workflow. No password storage/logging.

### `user_repository.dart` — `UserRepository`

Methods: `watchCurrentProfile(uid)`, `getProfile(uid)`, `updateOwnProfile(uid, ProfilePatch)`, paged authorized directory query, and admin operations `reviewAccount`/`changeRole` only when routed through trusted service. A normal profile patch cannot contain role/status/UID/created time/hours. Define separate DTO for changes.

### `event_repository.dart` — `EventRepository`

Methods: paginated `watchPublishedEvents(EventFilter, PageCursor?)`, `getEvent(id)`, authorized create/update/cancel, `requestToJoin`, and officer roster/review query only if approved. Operations validate legal transitions and are safe on retry.

### `attendance_repository.dart` — `AttendanceRepository`

Methods: member's own records, authorized event roster, mark/update attendance, submit correction request, authorized correction, aggregate service-hour summary. No caller supplies actor UID or arbitrary hours; implementation obtains current actor and trusted server validates.

### `incident_repository.dart` — `IncidentRepository`

Methods: submit report, reporter's own incident stream, responder-authorized paged queue/detail, transition status, append response note if approved, request SOS notification. Keep report submission available when location permission is denied. Sensitive responder APIs are separately authorized.

### `announcement_repository.dart` — `AnnouncementRepository`

Methods: visible audience stream/page, get published detail, authorized create/update/publish/archive. No public draft read.

### `audit_log_repository.dart` — `AuditLogRepository`

Methods: paged filtered audit query with allowlisted filters and export projection. Read-only. Audit entries are written from trusted backend operation, not this repository.

### `qr_duty_repository.dart` — `QrDutyRepository`

Methods: create/close session via trusted endpoint, obtain member-appropriate scan challenge without exposing secret, `submitScan(payload)` idempotently, own scan history, authorized event monitoring. Never accept client-supplied member identity, scan time or hours as authority.

### `interfaces.dart`

Barrel export of stable public interfaces only. Must not expose concrete Firebase adapter classes.

## Services (`lib/data/services/`)

### `auth_service.dart` — `AuthService` Firebase adapter

Wrap Firebase Auth authentication state, sign-in, reset, sign-out, token refresh and optional approved registration. Translate SDK failures to typed app errors; never log credentials. Keep profile/role lookup in user repository or a narrowly coordinated session repository. Provide dependency injection for `FirebaseAuth`. Test with auth fakes and verify no password persistence.

### `firestore_service.dart` — `FirestoreService` low-level adapter

Own injected `FirebaseFirestore`, emulator connection configuration, typed collection/path helpers and conversion of snapshots/timestamps. Expose narrow methods or collection references to repositories; do not create a generic public “read/write any collection” API. Configure persistence deliberately for each supported platform and emulator. Tests use fake Firestore for mapping and emulator tests for security/query behavior.

### `notification_service.dart` — `NotificationService`

Initialize FCM/local notification channels, request permission at a contextual moment, acquire/refresh device token, register/remove token under authenticated UID through authorized backend, handle foreground/background/opened notification routes safely. Do not include incident narratives/PII in push payloads; payload should reference an ID and reload authorized detail. Show failure and permission-denied state. Tests cover token rotation, sign-out cleanup, denied permission, unknown payload and duplicate message handling.

### `location_service.dart` — `LocationService`

Expose capability/permission state and one-shot location capture only. Request permission only after user intent with a plain-language explanation; handle denied/permanently denied/timeouts/platform unsupported; allow submission without location. No background tracking. Return typed coordinate plus capture time/accuracy; repository includes it only with consent. Tests use an injected geolocation adapter and cover no permission and timeout.

### Optional future adapters

Only add `reporting_service.dart`, `pdf_export_service.dart`, `backup_service.dart`, `import_export_service.dart`, `mfa_service.dart`, or `ai_report_service.dart` after their matching feature and approval exist. Keep each integration in its own file, use streamed/bounded processing, validate outputs, handle cancellation, audit sensitive operations, and add service unit tests. Provider API keys must never be shipped in Flutter source or `--dart-define` in a downloadable client.

## Repositories (`lib/data/repositories/`)

Create concrete `*_repository.dart` implementations corresponding to each interface. A repository owns: exact authorized query shapes, pagination, model mapping, typed error conversion, cache keys/TTL, cache invalidation after successful writes, and conversion of backend conflict states. It does not own widget state or bypass rules. Inject service/cache/current-session dependencies.

Each repository must have tests for success mapping, absent documents, malformed documents, permission denial, offline cached reads, stale cache labeling, write failure (cache must not falsely claim server success), pagination order/cursor, duplicate/retry idempotency and user-scope isolation. Emulator-backed rules tests separately verify the same read/write matrix against actual rules. Repository list contracts include page size and cursor and never fetch all records.

Required concrete files:

- `auth_repository.dart`: coordinates `AuthService` and current profile loading; clears user cache on sign-out and prevents stale profile from remaining active after UID changes.
- `user_repository.dart`: profile mapping, allowlisted patch, authorized page query, review-account and role-change delegation to trusted callable endpoint.
- `event_repository.dart`: published/member and staff query variants, bounded pagination, safe create/update payloads, join request idempotency.
- `attendance_repository.dart`: event/member scoped reads and trusted attendance write/correction; invalidates affected event and member summaries.
- `incident_repository.dart`: private submission and response queries; handles permission-denied without fallback to broad queries; sends minimal notification request.
- `announcement_repository.dart`: audience and publication-window query; invalidates visible feed after publication.
- `audit_log_repository.dart`: authorized bounded read/query and safe CSV projection; never writes.
- `qr_duty_repository.dart`: callable endpoint integration for session and scans; read-only authorized monitor/history streams.
- `repositories.dart`: optional barrel export only if import hygiene benefits; never add logic.

