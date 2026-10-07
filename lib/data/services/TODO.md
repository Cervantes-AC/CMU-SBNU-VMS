# TODO: services

**Status:** AuthService (`lib/data/services/auth_service.dart`) and FirestoreService (`lib/data/services/firestore_service.dart`) implemented as dependency-injected adapters. Error translation to typed app errors lives at the repository boundary. Additional data services remain to be added. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `data/services/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/data.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Wrap one approved SDK/platform capability per adapter. Secrets remain server-side; permission-denied behavior is explicit.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

## Services (`lib/data/services/`)

### `auth_service.dart` â€” `AuthService` Firebase adapter

Wrap Firebase Auth authentication state, sign-in, reset, sign-out, token refresh and optional approved registration. Translate SDK failures to typed app errors; never log credentials. Keep profile/role lookup in user repository or a narrowly coordinated session repository. Provide dependency injection for `FirebaseAuth`. Test with auth fakes and verify no password persistence.

### `firestore_service.dart` â€” `FirestoreService` low-level adapter

Own injected `FirebaseFirestore`, emulator connection configuration, typed collection/path helpers and conversion of snapshots/timestamps. Expose narrow methods or collection references to repositories; do not create a generic public â€œread/write any collectionâ€ API. Configure persistence deliberately for each supported platform and emulator. Tests use fake Firestore for mapping and emulator tests for security/query behavior.

### `notification_service.dart` â€” `NotificationService`

Initialize FCM/local notification channels, request permission at a contextual moment, acquire/refresh device token, register/remove token under authenticated UID through authorized backend, handle foreground/background/opened notification routes safely. Do not include incident narratives/PII in push payloads; payload should reference an ID and reload authorized detail. Show failure and permission-denied state. Tests cover token rotation, sign-out cleanup, denied permission, unknown payload and duplicate message handling.

### `location_service.dart` â€” `LocationService`

Expose capability/permission state and one-shot location capture only. Request permission only after user intent with a plain-language explanation; handle denied/permanently denied/timeouts/platform unsupported; allow submission without location. No background tracking. Return typed coordinate plus capture time/accuracy; repository includes it only with consent. Tests use an injected geolocation adapter and cover no permission and timeout.

### Optional future adapters

Only add `reporting_service.dart`, `pdf_export_service.dart`, `backup_service.dart`, `import_export_service.dart`, `mfa_service.dart`, or `ai_report_service.dart` after their matching feature and approval exist. Keep each integration in its own file, use streamed/bounded processing, validate outputs, handle cancellation, audit sensitive operations, and add service unit tests. Provider API keys must never be shipped in Flutter source or `--dart-define` in a downloadable client.

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

