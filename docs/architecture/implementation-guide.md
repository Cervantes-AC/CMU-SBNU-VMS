# CMU SBNU VMS — Implementation and Production Readiness Guide

**Status:** implementation specification for `cmu_sbnu_vms`  
**Audience:** engineers and coding agents implementing this repository  
**Last reviewed:** 2026-10-07  
**Source of product patterns:** `D:\nsrc_vms` (design reference only)

This guide turns the target repository's scaffold and the reference application's feature set into an implementation plan. It describes the files to create or finish, the responsibilities and contracts those files must satisfy, the backend data model, security boundaries, release process, and the evidence required before this system is considered production ready.

For exact source-file specifications (public types, method responsibilities, dependency boundaries, and module acceptance tests) see the [`lib/ file specifications`](../lib/index.md) catalog.

For AI-assisted implementation, use [`AGENTS.md`](../../AGENTS.md) and the [`AI Coding Playbook`](../ai-coding/index.md), especially its task workflow, Git/version-control rules, security/privacy rules, verification policy, and handoff template.

## 1. Authority, boundaries, and current state

`cmu_sbnu_vms` is the project of record. The `nsrc_vms` project is a behavioral and architectural reference, not a source of credentials, backend configuration, seed data, or code to copy without review. The target README records Firebase project ID `cmu-sbnu-vms`; never point this application at the reference project's `nsrc-vms` backend. Keep the target Android application ID and package identity from this repository's Android configuration. Treat Firebase client configuration as public identifiers, but never commit private keys or service-account credentials.

The target currently has Flutter platform shells, a starter `main.dart`, generated Firebase options, a minimal dependency manifest, one starter test, and a planned `lib/` directory tree whose `TODO.md` files are markers rather than implementations. Tracked Firebase client configuration identifies `cmu-sbnu-vms`; this does not establish an approved production environment, IAM owner, rules, emulators, or permission to use real data. No feature, backend authorization, production data model, or release pipeline should be presumed complete just because a configuration file exists.

The target README and its decision/approval registers are authoritative for requirements, privacy, branding, environment ownership, and open decisions. Before any implementation that needs real volunteer data, institutional branding, public hosting, production billing/IAM, or a production release, resolve the corresponding decision and record its evidence. Use synthetic data in development and tests. Do not silently convert prototype behavior into an approved product requirement.

## 2. Product scope and role journeys

The product is a mobile-first and web-capable volunteer operations system for the Central Mindanao University School-Based NSRC Unit. Implement a coherent, secure minimum product first, then add the operationally sensitive modules behind approved requirements.

| Role | Intended work | Default access boundary |
|---|---|---|
| Member | Maintain own profile, view own events/attendance/service hours, join approved events, submit an incident, receive announcements, use approved QR duty flows | Own record and explicitly published unit data |
| Officer | Manage assigned events, record attendance, monitor duty scans, review/respond to incidents, draft operational reports | Unit operational data needed for assigned duties; no platform administration by default |
| Administrator | Approve accounts, manage roles and records, publish unit announcements, view operational analytics, audit administrative actions | Administrative access granted by an authorized owner, with elevated actions logged |
| Organization/viewer (only if approved) | View a constrained incident/operations feed and map | Read-only, least-privilege, no member PII unless expressly approved |

Roles are not proof of identity or approval. Every authenticated account has a lifecycle status. Pending, denied, blocked, suspended, and deactivated accounts must not reach ordinary application data. UI hiding is usability only; Firestore rules and trusted server operations enforce access.

### Functional modules

1. **Access and onboarding:** sign-in, password reset, account registration if approved, email verification, pending approval, sign-out, session expiry, disabled-account handling.
2. **Member directory and profile:** approved fields only, self-editable field allowlist, admin review for privileged fields, account state and service-hour summary.
3. **Dashboard:** role-specific summaries with loading, empty, offline, stale-data, and error states.
4. **Events:** create/update/cancel under approved staff roles; discover, request/join, and view details; prevent invalid lifecycle transitions.
5. **Attendance/service hours:** event-scoped records, duplicate prevention, correction workflow, timestamps and actor attribution, deterministic service-hour calculation.
6. **QR duty monitoring:** create event-bound check-in tokens, scan and validate, prevent replay and duplicate scans, monitor status. Tokens must be opaque, expiring, and validated by trusted logic; never encode private member data or trust client-supplied identity/hours.
7. **Incidents and emergency flows:** submit, triage, update, close, and audit incidents. Capture precise location only after clear consent and permission; allow a report without location. SOS must clearly explain who receives an alert and must not claim emergency dispatch. Retry and acknowledgement state must be visible.
8. **Announcements and emergency contacts:** authorized publishing with lifecycle and priority, searchable directory with verified ownership of phone numbers.
9. **Reports and analytics:** aggregate only data the requesting role may read; use explicit date ranges, timezone rules, and auditable exports. AI-generated narrative is optional, clearly labeled, reviewed by a human, and never authoritative for safety decisions.
10. **Administration:** user approvals, role changes, audit review, safe import/export, backup/restore, and operational configuration. Dangerous tools remain inaccessible until separately approved and protected.
11. **Profile, settings, help, landing page:** only publish content and branding with recorded institutional approval. Public landing/contact forms must not leak internal records.

## 3. Architecture and dependency direction

Use a layered feature-first Flutter architecture. Widgets render state and dispatch intent; controllers/providers coordinate a user journey; domain models and validation express rules; repositories expose typed operations; services isolate Firebase, platform APIs, files, and network calls. UI code must not issue ad hoc Firestore writes. Keep authorization in backend rules/functions even when the client also applies route guards.

```text
Flutter screens/widgets
        ↓ user intent / view state
Feature controllers (Provider/ChangeNotifier or approved equivalent)
        ↓ typed repository contracts
Repositories (mapping, cache policy, query ownership)
        ↓
Services (Firebase Auth, Firestore, Storage, FCM, location, export)
        ↓
Firebase project cmu-sbnu-vms + emulator-backed rules/functions
```

Follow the target baseline's selected state-management and routing approach; do not add a second competing framework. Keep dependencies constructor-injected so unit tests can use fakes. Model remote failures explicitly (typed result/error state); never swallow exceptions into empty success. Use server timestamps for authoritative audit/event times. Document any offline write queue, conflict policy, cache TTL, and data sensitivity before implementing it. Firestore persistence is not a substitute for an application-level offline design.

### Stable file responsibilities

| File or directory | Required responsibility |
|---|---|
| `lib/main.dart` | Initialize Flutter bindings, load environment/configuration, initialize Firebase for the selected target, initialize approved local storage and crash reporting, install global error handlers, then run the app. Fail closed or show a safe startup error if required config is absent. |
| `lib/app.dart` | Root app, dependency graph, theme, localization, router, auth/session refresh, role-aware route redirect. Must not contain feature business logic. |
| `lib/firebase_options.dart` | Generated per-platform Firebase identifiers for the target project; regenerate with FlutterFire CLI, never hand-copy the prototype options. |
| `lib/core/constants/` | Route names, collection names, enums/shared immutable policy constants; no secrets. |
| `lib/core/theme/` | Approved design tokens, light/dark themes, persisted preference if approved. |
| `lib/core/error/` | Domain/app error types, safe user messages, logging redaction. |
| `lib/core/connectivity/` | Connectivity observation; connectivity does not guarantee backend reachability. |
| `lib/core/cache/` | Cache abstraction, key/version policy, TTL, clear-on-sign-out and sensitive-data handling. |
| `lib/core/sync/` | Only if offline mutations are approved: queue, idempotency, retry/backoff, conflict handling and visible sync state. |
| `lib/core/utils/` | Pure date, validation, responsive, service-hour and logging helpers. Keep policy-sensitive calculations testable and deterministic. |
| `lib/data/models/` | Immutable typed models, parsing/serialization, validation and schema version handling. Never expose raw document maps to widgets. |
| `lib/data/interfaces/` | Repository/service contracts, including streams and explicit failure semantics. |
| `lib/data/services/` | Firebase and platform adapters: auth, Firestore, notifications, location, upload, export, etc. |
| `lib/data/repositories/` | Feature data orchestration, authorized query shapes, cache policy, mapping and invalidation. |
| `lib/features/<feature>/` | Screen, controller/provider, focused widgets, and feature-specific presentation logic. Keep unrelated features independent. |
| `lib/shared/` | Reusable widgets, navigation shell, feedback, route guard, result type and status components. Avoid a dumping ground for domain logic. |

## 4. Recommended implementation file map

Create files as the corresponding vertical slice is approved. The names below are a recommended target structure; adapt only through a documented decision, and do not create empty placeholder files just to match this list.

```text
lib/
  main.dart
  app.dart
  firebase_options.dart                 # generated for target environments
  core/
    constants/{app_constants,route_names,firestore_paths}.dart
    error/{app_exception,error_mapper}.dart
    theme/{app_theme,theme_provider}.dart
    cache/{cache_service,cache_keys}.dart
    connectivity/connectivity_service.dart
    sync/sync_service.dart               # only if offline writes are approved
    utils/{validators,date_helpers,service_hours_calculator,logger,responsive}.dart
  data/
    models/{user,event,attendance,incident,announcement,audit_log,qr_duty_record}.dart
    interfaces/{auth_repository,user_repository,event_repository,attendance_repository,
      incident_repository,announcement_repository,audit_log_repository,qr_duty_repository}.dart
    services/{auth_service,firestore_service,notification_service,location_service}.dart
    repositories/{auth_repository_impl,user_repository_impl,event_repository_impl,
      attendance_repository_impl,incident_repository_impl,announcement_repository_impl,
      audit_log_repository_impl,qr_duty_repository_impl}.dart
  features/
    auth/{auth_screen,auth_controller}.dart
    landing/{landing_page}.dart
    dashboard/{dashboard_router,member_dashboard,officer_dashboard,admin_dashboard}.dart
    profile/{profile_screen,profile_controller}.dart
    events/{events_screen,event_detail_screen,event_form}.dart
    attendance/{attendance_screen,member_attendance_screen,attendance_controller}.dart
    qr_duty_monitoring/{qr_duty_scanner_screen,qr_code_generator_screen,duty_monitoring_screen}.dart
    incidents/{incidents_screen,incident_form,incident_detail_screen,sos_controller}.dart
    announcements/{announcements_screen,announcement_form}.dart
    analytics/{analytics_screen}.dart
    reports/{reports_screen,report_exporter}.dart
    user_management/{user_management_screen,user_management_controller}.dart
    audit_logs/{audit_logs_screen}.dart
    settings/{settings_screen}.dart
    emergency_hotlines/{emergency_hotlines_screen}.dart
    user_guide/{user_guide_screen}.dart
    import_export/{import_export_screen,import_validator}.dart
    backup/{backup_management_screen}.dart
    database_management/{database_management_screen}.dart
  shared/{app_shell,route_guard,result,app_feedback,status_badge,empty_state}.dart
functions/
  package.json, package-lock.json, tsconfig.json
  src/index.ts
firestore.rules
firestore.indexes.json
storage.rules                            # only if Firebase Storage is selected
firebase.json
test/{unit,widget,integration,security}/
```

The target already includes several of these directories with `TODO.md` markers. Replace markers with implemented files as work proceeds; retain a concise TODO only for genuinely deferred work. Add module-specific widget subdirectories and `parts/` only when they improve maintainability. Avoid monolithic screens, generic database browsers, user impersonation, arbitrary query tools, and destructive restore features in the initial release unless there is an approved requirement and a reviewed threat model.

## 5. Data contracts and Firestore schema

The canonical development schema, proposed wire enums, and access matrix are in [`data-and-access.md`](data-and-access.md); this table is an architectural overview only. Confirm each field's purpose, retention, visibility, consent and owner before production use. Store timestamps as Firestore `Timestamp`, not locale-formatted strings. Use stable document IDs; keep immutable audit entries separate from mutable current-state documents. Use subcollections or normalized records for unbounded attendance/scan history instead of growing arrays.

| Collection | Document ID | Core fields (illustrative) | Access intent |
|---|---|---|---|
| `users/{uid}` | Firebase Auth UID | `uid`, `displayName`, `role`, `status`, `createdAt`, `updatedAt`, `revision`, `schemaVersion`; restricted email/profile fields | Owner updates only allowlisted fields via `updateOwnProfile`; approved staff use separate minimal directory projection; only trusted admin workflow changes role/status |
| `memberDirectory/{uid}` | Firebase Auth UID | minimal `uid`, `displayName`, `directoryStatus`, approved unit label | Separate restricted roster projection; no private email/contact fields |
| `events/{eventId}` | random ID | `title`, `startsAt`, `endsAt`, `venue`, `status`, actor/time metadata, `revision`; optional approved fields | Trusted `saveEvent` operation; approved users read published events; exact fields/enums in canonical schema |
| `eventJoinRequests/{requestId}` | `base64url(sha256(eventId + NUL + uid))` | `eventId`, `uid`, `status`, `createdAt`, `revision`, review metadata | Trusted request/review operations enforce one request per pair |
| `attendance/{attendanceId}` | `base64url(sha256(eventId + NUL + uid))` | `eventId`, `uid`, `status`, `source`, server actor/time, `revision` | Trusted operation; member reads own; corrections audited; hours cannot be self-awarded |
| `incidents/{incidentId}` | random ID | `reporterUid`, `category`, `severity`, `description`, `status`, `createdAt`, `updatedAt`, optional consented location, response metadata | Reporter and approved responders only; redact sensitive details from broad feeds |
| `announcements/{id}` | random ID | `title`, `body`, `priority`, `audience`, `publishAt`, `expiresAt`, `status`, `createdBy`, `revision` | Trusted operation; published audience reads; authorized staff manage |
| `qrDutySessions/{sessionId}` | random ID | `eventId`, `createdBy`, `startsAt`, `expiresAt`, `status`, server-controlled token digest | Members never read token digest; trusted endpoint validates scans and replay limits |
| `qrDutyScans/{scanId}` | unique session+uid+action key | `sessionId`, `eventId`, `uid`, `action`, `serverTime`, `result` | Created only through trusted validation; member reads own, officers read authorized event records |
| `auditLogs/{id}` | generated server-side | `actorUid`, `action`, `entityType`, `entityId`, `occurredAt`, minimal `before/after` summary, `requestId` | Append via trusted code only; authorized audit readers; never expose secrets or excessive PII |
| `userDevices/{uid}/tokens/{tokenId}` | generated | FCM token, platform, updatedAt | Owner/token service only; remove stale tokens |
| `contactInquiries/{id}` | generated | limited contact fields, message, submittedAt, triage status | Public create with strict validation/rate limit; staff-only read; retention policy required |

Do not add `backupRecords`, arbitrary database-admin writes, public tactical feeds, medical details, birth dates, home addresses, or continuous location tracking by default. Any extra collection must include an owner, purpose, fields, retention, query/index plan, rules, and tests in the data dictionary/change review.

### Model requirements

Each model implements validated `fromFirestore`/`fromJson` and serialization at the data boundary. Parsing must tolerate documented optional/migrated fields but reject malformed security-sensitive values. Define enums with explicit wire values and unknown-value behavior. Do not trust client-provided `uid`, `role`, `status`, `createdAt`, `recordedBy`, service-hour totals, or audit actor where the server can derive them. Add model tests for round-trip, missing fields, malformed types, old schema versions, and timezone boundaries.

### Query/index requirements

For every list screen, document the exact query, ordering, pagination cursor, expected maximum, and role visibility. Add only the composite indexes needed in `firestore.indexes.json`; test query shapes against the emulator. Paginate unbounded records; never download whole collections for charts/export. Avoid client-side filtering as an authorization boundary.

## 6. Authentication, authorization, and audit

1. Auth service handles sign-in/out, password reset, token/session refresh and auth state streams. Translate provider errors into safe messages without leaking account existence where policy requires concealment.
2. After authentication, load the user's profile and require `status == approved` before entering protected routes. Missing, disabled, deleted, or malformed profiles fail closed.
3. Role and status changes are privileged operations. Prefer custom claims only when a trusted backend owns claim assignment and the client refreshes tokens correctly; otherwise derive access from protected profile documents in rules. Never let a client set its own role, approval state, or admin claim.
4. Routes check auth, approved status, role, and any MFA/step-up requirement. Backend rules repeat the checks for every collection and field update.
5. Deny by default with a final recursive Firestore rule. Use field allowlists and `diff().affectedKeys()` for updates; validate types, bounds, references, allowed enum values, and immutable fields. Account for Firestore rule document-access-call limits.
6. Audit approvals, role/status changes, attendance corrections, incident status changes, exports, restores, and other privileged mutations. Create audit records server-side where feasible; they are append-only, minimal, timestamped by server, and unavailable to ordinary clients.
7. Test unauthorized and cross-user access explicitly. A passing UI test is not evidence that rules are secure.

Security review must include account enumeration, privilege escalation, IDOR/cross-unit reads, rule bypass through alternate paths, replayed QR tokens, forged hours, malicious imports, oversized documents, notification token abuse, public form spam, and accidental PII in logs/exports.

## 7. Backend and environment files

The target's `firebase.json` and Firebase CLI configuration must be reviewed against the selected target project before adding deployment targets. Add:

- `firestore.rules`: deny-by-default, role/status-aware rules, strict field validation and invariants.
- `firestore.indexes.json`: checked-in indexes used by production queries.
- `firebase.json`: explicit emulator ports and rules/index paths; Hosting only if web deployment is approved; Functions/Storage only if selected.
- `.firebaserc`: named aliases for isolated `dev`, `staging`, and `prod` projects after ownership is approved. Never use implicit default project selection in release instructions.
- `.env.example` or documented `--dart-define` keys: names and safe placeholders only. Validate required keys at startup. Client configuration is not secret; privileged API keys belong in a trusted backend/secret manager.
- `functions/package.json`, lockfile, `tsconfig.json`, `src/index.ts`: Node LTS runtime selected by Firebase support, TypeScript strict mode, lint/build scripts, unit tests, and callable/trigger handlers. Functions must authenticate, authorize, validate inputs, be idempotent where retried, and return minimal data.
- `storage.rules` only if Storage is approved: validate MIME/type/size, ownership, path, and role; avoid broad public read/write.
- `firebase-emulator.json` is not a Firebase convention; configure emulators in `firebase.json` and include documented fixture setup instead.

No function may accept an asserted actor UID or role as authority. For important workflows such as QR scans, account approval, service-hour updates, notification fan-out, and audit writes, trusted code derives identity from verified auth and validates the resource state transactionally. Use App Check if approved and supported, rate limits, input size caps, and operational alerts.

### Environments

Maintain separate Firebase projects for development, staging, and production; confirm billing, region, IAM ownership, retention, backups, and recovery contact before use. Test data stays synthetic. Production data must never be copied into local fixtures. Document which person/team owns each project, who can deploy, how access is revoked, and how secrets are rotated. Build artifacts should record the environment and commit SHA; production builds must fail if configured with a non-production or ambiguous project.

## 8. Implementation sequence and completion gates

Work in vertical slices. Every slice includes UI, model/contract, repository/service, rules/backend change, loading/error/empty/offline behavior, defined verification coverage, and docs/traceability update where applicable. Test coverage is an acceptance/CI requirement; AI agents must follow the authorization rule in root `AGENTS.md` before adding or running tests.

### Phase 0 — unblock and govern

- Confirm authoritative requirements, open decisions, ownership and data/privacy approvals; retain synthetic-only operation until approval is recorded.
- Pin the Flutter/Dart toolchain stated by the target baseline and record the supported platforms. Fix the current analyzer/dependency mismatch by adding Firebase Core only as part of approved Firebase bootstrap work, not by copying generated configuration blindly.
- Establish formatter/analyzer/test/build commands in CI; remove starter counter behavior and starter-only assertions once an app shell is implemented.
- Confirm target Firebase dev project and emulator setup. Create no production records or deployable production rules until the project owner/security owner review.

### Phase 1 — foundation

- Implement startup/error handling, app root, dependency injection, theme, route table, safe auth-state routing, typed errors/results, logging redaction and shared UI states.
- Define data dictionary, access matrix, role/status enums, model contracts and repository interfaces before feature writes.
- Add emulator config, deny-all initial rules, indexes baseline, rules test harness and CI. Establish test fakes and repository unit tests.

### Phase 2 — secure core journeys

- Implement auth, approval gate, profile, role-aware shell/dashboard, member directory as approved, events and announcements.
- Implement account approval/role change in trusted flow and append-only audit.
- Add data-minimizing analytics only after permissions and query limits are explicit.

### Phase 3 — operations

- Implement attendance and corrections, QR duty sessions/scans, incidents and responder workflow, emergency notifications/hotlines.
- Use server-validated/idempotent operations for consequential writes; add location only with consent and a manual-location-free path.
- Add reports/exports with explicit access checks, column allowlists, watermark/environment context where suitable, and audit events.

### Phase 4 — administration and optional features

- Add import/export with dry-run preview, strict schema validation, transaction/batch limits, duplicate handling and rollback plan.
- Add backup/restore only after a restore drill, encryption/access model, retention, audit, and owner approval. A backup is not a substitute for Firebase managed backup/export configuration.
- Add AI narrative only if approved: keep provider keys server-side, minimize payload, obtain required consent, display source metrics, mark generated text, and require officer review.
- Add public landing page, maps, Cloudinary, broad database browser, query console, impersonation or other prototype-only conveniences only if a product requirement and threat model authorize them.

### Phase 5 — release readiness

- Complete the security, privacy, accessibility, performance, backup/restore, incident-response and release checks in §11–13.
- Stage a release against staging, exercise rollback, obtain product owner/security/data owner approval, then promote the exact reviewed artifact.

## 9. Feature acceptance criteria

Every feature must satisfy applicable shared criteria: role/status authorization on server and UI; responsive layouts for supported viewport sizes; keyboard/screen-reader semantics where supported; validation and safe error messages; loading/empty/offline/stale states; pagination for growing lists; audit for privileged changes; no sensitive values in logs; defined coverage for success, invalid input, permission denial and retry; and a user-facing explanation of data use. Test creation/execution remains subject to root `AGENTS.md` authorization.

| Feature | Minimum acceptance evidence |
|---|---|
| Auth/profile | Pending user cannot read operational data; user cannot change role/status; reset and sign-out work; malformed/missing profile fails closed |
| Events | Unauthorized create/update rejected by rules; date/status validation; member joins cannot duplicate; canceled/completed states behave correctly |
| Attendance | Only authorized event staff can record; member cannot alter own attendance/hours; uniqueness/idempotency enforced; corrections audited; total hours recompute deterministically |
| QR duty | Expired, malformed, replayed, cross-event and duplicate scans rejected; offline behavior explicit; code contains no PII; scan writes are server-time attributed |
| Incidents/SOS | Non-consenting user can submit without location; access restricted to reporter/responders; edits/status transitions audited; SOS delivery/acknowledgement and failure states are clear |
| Announcements | Draft/unpublished content hidden from ordinary audiences; publication and expiry enforced; audience authorization verified |
| Reports/export | Only authorized rows/fields included; timezone/date boundary tests; CSV formula injection mitigated; export event logged |
| Admin | Role/status changes require trusted authorization and audit; administrator cannot view secrets; destructive action has confirmation and recovery path |
| Offline | Cached sensitive data policy documented; sign-out clears user-scoped cache; queued mutation is idempotent and conflict behavior visible |

## 10. Test and CI plan

The existing `test/widget_test.dart` is a starter smoke test, not production coverage. Organize tests around behavior and risk:

```text
test/
  unit/{models,validators,service_hours,controllers,repositories}/
  widget/{auth,route_guard,events,attendance,incidents,shared}/
  integration/{auth_flow,event_attendance,incident_flow}/
  security/{firestore_rules,storage_rules,authorization_matrix}/
functions/test/{unit,authorization}/
```

Required checks on every pull request: `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test`, backend lint/build/test when `functions/` changes, and Firebase Emulator Suite rule/function tests when backend configuration changes. Add platform build smoke checks for the supported release targets. CI must use least-privilege credentials; ordinary PR builds should use emulators and synthetic fixtures, never production credentials. Pin action/tool versions and retain test output as build evidence.

Rule tests must exercise unauthenticated access, each role/status, owner vs other user, missing profile, role escalation, invalid fields, immutable fields, and every collection operation. Property-based tests are useful for invariants but supplement explicit example tests. Avoid tests that merely assert a widget class exists.

## 11. Privacy, safety, and operations

- Maintain an approved data inventory: field, purpose, sensitivity, source, readers, retention, deletion behavior and export handling.
- Minimize personal and incident data; define retention and deletion workflows before collecting it. Do not collect precise location by default or persist it beyond the approved need.
- Encrypt transport (Firebase HTTPS) and protect local data according to platform capabilities and sensitivity. Clear account-scoped cache/tokens on sign-out and account disablement.
- Redact tokens, email, phone, incident narratives, location and document payloads from logs, crash reports and analytics. Crash reporting itself requires owner approval and a reviewed privacy configuration.
- Establish monitoring for auth abuse, function errors, delivery failures, quota/billing anomalies, failed backups and security-rule denials. Define on-call owner, severity levels, response times, escalation path and incident communication process.
- Backups require defined RPO/RTO, retention, access, encryption and scheduled restore drills. Document recovery steps and the last successful drill.
- Define operational emergency/SOS semantics with the unit. The application does not replace official emergency services; show direct local contact guidance when network/backend delivery fails.
- Maintain dependency updates, vulnerability triage, supported Flutter/Node versions, key rotation, account offboarding and release ownership.

## 12. Build, deployment, and rollback

### Local development

1. Install the Flutter/Dart versions in the target README and run `flutter doctor -v`.
2. Run `flutter pub get`; use the Firebase Emulator Suite for Auth, Firestore, Functions and Storage where selected.
3. Load only approved local config from an ignored environment file or generated local options. Never paste production secrets in source, chat, screenshots or tests.
4. Run format, analyze, tests and the relevant emulator suite before committing.

### Web

If web is an approved release target: build with explicit environment configuration, deploy to the named staging alias first, enforce HTTPS and security headers/CSP appropriate to the exact integrations, configure SPA fallback, prevent source-map leakage if policy requires, and verify camera/location permissions and QR scanning in supported browsers. Serve no sensitive app data publicly. Review hosting cache behavior for `index.html`, service workers and versioned assets.

### Android

Set the approved application ID, app signing, permissions, notification channels and privacy disclosures. Release builds must use managed upload/release signing, never debug signing. Verify minimum/target SDK policy, Firebase config package match, app links if used, and a clean install/update path. Keep signing material outside the repository.

### iOS (if approved)

Provision the target bundle ID, signing team, `GoogleService-Info.plist`, usage descriptions, notification/APNs setup, privacy manifest requirements, and App Store disclosures. Validate release/archive on a clean macOS runner.

### Backend promotion

Deploy rules/indexes/functions to a dedicated staging project, run emulator and staging smoke tests, review diff and IAM, then deploy to the explicitly named production project with an authorized operator. Rules and functions deploy before a client requiring them. Maintain rollback instructions for client and backend separately; rules rollback must not reopen unauthorized access. Use gradual rollout/feature flags for risky workflows. Record artifact SHA, project ID, operator, approval, deployment time, migration version and rollback result.

## 13. Definition of done for production

Production ready means all of the following have verifiable evidence, not just completed implementation tickets:

- Product owner has approved scope, acceptance criteria and supported platform list.
- Data/institutional/privacy decisions are closed; consent, retention, deletion and incident response are documented.
- Production Firebase project ownership, billing, region, IAM, recovery contacts and deploy authority are recorded; target project identity is checked in the artifact.
- Firestore/Storage rules deny by default and pass emulator authorization tests; indexes and migrations are versioned; no prototype project credentials/data are present.
- Core journeys work for each role, including denied/pending accounts, network loss, backend errors and accessibility review.
- Unit/widget/integration/security suites pass; analyzer and release builds pass on clean CI; no known critical/high dependency or security findings are unresolved without documented acceptance.
- QR, attendance, hours, SOS, export, account approval, notification, and restore paths have abuse/failure tests appropriate to their risk.
- Monitoring, alert routing, support ownership, backup/recovery drills, key rotation, rollback, and incident runbooks are exercised.
- Android/web/iOS store/hosting privacy declarations and branding approvals are complete for the platforms actually released.
- Release approval references the exact commit/build and environment; a tested rollback artifact is available.

## 14. Coding-agent operating instructions

For any AI coding agent implementing this repository:

1. Read the target `README.md`, this guide, current approval/decision records, the relevant `TODO.md`, and the prototype-port notes before changing code. If an authority document is missing or references an unresolved decision, do not infer approval; work on independent synthetic-data scaffolding and report the blocker for that dependent production action.
2. Work one vertical slice at a time. Inspect the target code and current package versions first; do not overwrite target files wholesale with prototype files.
3. Preserve the target Firebase project, target package/application IDs, and target-specific product decisions. Never import prototype secrets, database exports, seed data, or production identifiers.
4. Before adding a dependency or cloud service, state why it is needed, verify platform support, update lockfiles, and document configuration/privacy impact.
5. Pair each data write with model validation, repository contract, backend rule or trusted function, negative authorization tests, and audit/retention decisions.
6. Do not implement impersonation, arbitrary database mutation/query, bulk export, restore, public incident map, continuous location, or client-held privileged API keys without explicit approved requirements and a reviewed threat model.
7. Do not claim production readiness from a successful compile. Report exact checks run, their results, unverified decisions, deployment environment, and remaining release gates.
8. Keep docs, data dictionary, access matrix and requirement traceability synchronized with behavior. Mark a checklist item complete only when evidence exists.

## 15. Relationship to reference documentation

`docs/About.md` and files under `D:\nsrc_vms\docs` describe the prototype, including its earlier package names, dependencies, roles, and Firebase project. Read them for feature behavior and useful implementation patterns, then translate those patterns into the target contracts above. Treat prototype quirks, missing modules, security-rule weaknesses, third-party API integrations, and any claim of offline-first behavior as items to independently verify. This guide intentionally does not make the prototype backend or its real data part of the target system.

