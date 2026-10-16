# Development Status

**Last updated:** 2026-10-17
**Status:** Working Flutter application with complete feature architecture. All 12 features are implemented with UI + ViewModel + Repository + data source layers. The planning specification remains proposed and requires institutional review before production data is connected.

## Implemented in the Flutter client

### Foundations (complete)
- Application theme, SBNU logo, and branding following `prototype/` palette and card styling
- `lib/app/` — bootstrap, dependency composition (Provider), GoRouter routing, theme tokens
- `lib/core/` — typed failures (`AppFailure`), privacy-safe logging (`AppLogger`), stable types (`LoadStatus`, `AppResult`, `CommandResult`, `AppTimestamp`)
- `lib/shared/presentation/` — reusable policy-free UI: buttons, input fields, cards, loading/empty/error/offline/permission states, section headings, snackbar, nav drawer, preview badges, disclosure cards
- Environment-aware Firebase initialization with explicit emulator opt-in via `--dart-define=USE_FIREBASE_EMULATORS=true`
- Visible startup failure UI when Firebase configuration is invalid

### Auth (complete UI + repository contract)
- Sign-in, registration, and password recovery pages with validated forms
- `AuthRepository` contract + `FirebaseAuthRepository` implementation backed by Firebase Auth
- `AuthViewModel` with sign-in/register/reset/sign-out state, loading/error states
- Auth state stream and `currentUser` accessor
- Routes: `/account/sign-in`, `/account/register`, `/account/recover`

### Access Control (complete UI)
- Access & operations page with proposed permission matrix (Volunteer / Officer / Admin / Server)
- Matrix is UX guidance only; real authorization is enforced at trusted backend boundaries
- Route: `/access-control` (via workspace), `/organizations`

### Organizations (complete UI + preview repository)
- Organization directory with name, status, coordinator list
- Create organization dialog
- `OrganizationsRepository` contract + preview + Firestore implementations
- Route: `/organizations`

### Volunteers (complete UI + preview repository)
- Volunteer roster with college filter
- Volunteer profile detail (full name, email, college, course, student ID, status)
- `VolunteersRepository` contract + preview + Firestore implementations
- Route: `/volunteers`

### Activities (complete UI + preview repository)
- Activity browse with published status filter
- Activity create dialog (title, description, venue)
- Join/withdraw participation
- `ActivitiesRepository` contract + preview + Firestore implementations
- Route: `/activities`

### Attendance (complete UI + preview repository)
- Attendance record list (activity, UID, status, source)
- Record attendance dialog (activity ID, volunteer UID, status)
- QR code scan button using `mobile_scanner` — scan captures token; local confirmation entry only
- `qrPayload` and `source: 'qr'` fields on `AttendanceRecord`
- `AttendanceRepository` contract + preview + Firestore implementations
- Personal attendance via collection-group query
- Route: `/attendance`

### Announcements (complete UI + preview repository)
- Announcement feed with status and priority badges
- Create/publish dialog (title, message, audience)
- Archive/delete operations
- `AnnouncementsRepository` contract + preview + Firestore implementations
- Route: `/announcements`

### Incidents (complete UI + preview repository)
- Incident submission (category, narrative, severity, optional location)
- Incident list with status/severity badges
- Incident map view (`google_maps_flutter`) showing `locationShared=true` incidents
- Map markers show only category, severity, status — reporter identity and narrative are not on markers
- Status transitions (submitted → under review → action in progress → resolved, etc.)
- Append-only history events
- `IncidentsRepository` contract + preview + Firestore implementations
- Route: `/incidents`

### SOS (complete UI + preview repository, clearly labeled)
- SOS alert creation with deliberate confirmation and emergency disclaimer
- Responder queue tab showing all alerts with lifecycle/delivery badges
- Responder actions: acknowledge, resolve
- States: submitted, acknowledged, action in progress, resolved, cancelled, false alarm, closed
- Delivery states: pending, sent, failed, unknown
- Location sharing is optional
- Clearly labeled as NOT contacting public emergency services
- `SosRepository` contract + preview + Firestore implementations
- Route: `/sos`

### Hotlines (complete UI + preview repository)
- Hotline directory with label, number, coverage, hours
- Verification states: verified, expired, rejected, disabled, pending
- One-tap calling only for verified active entries (url_launcher)
- Unverified/expired entries visibly non-callable
- Admin verify/expire actions with confirmation dialogs
- `HotlinesRepository` contract + preview + Firestore implementations
- Route: `/hotlines`

### Reporting (complete UI + preview repository)
- Scoped report summaries (active volunteers, activities, service hours, attendance rate)
- CSV export generation
- `ReportsRepository` contract + preview + Firestore implementations
- Route: `/reports`

### Audit (complete UI + preview repository)
- Append-only audit event review (actor, action, record type, outcome, timestamp)
- `AuditRepository` contract + preview + Firestore implementations
- Route: `/audit`

### Overview / Dashboard (complete)
- Dashboard with activity and service hour metrics
- Navigation drawer with all workspace sections
- Section content delegates to feature pages
- Route: `/workspace`

### Emergency & Safety (complete UI composition)
- Tabbed composition: SOS / Incidents / Hotlines
- Route: `/emergency`

### Navigation (complete)
- GoRouter with routes: `/`, `/account/sign-in`, `/account/register`, `/account/recover`, `/workspace`, `/activities`, `/volunteers`, `/attendance`, `/announcements`, `/emergency`, `/reports`, `/sos`, `/incidents`, `/hotlines`, `/audit`, `/organizations`
- Landing page with sign-in/register/CTA
- Workspace shell with navigation drawer and responsive layout

## Data connection status

### Real data via Firebase Emulator (available now)
All 10 feature repositories are wired to Firestore-backed implementations behind an explicit flag. To use real (emulator-local) data:

1. Start the emulators:
   ```
   firebase emulators:start --only firestore,auth --project cmu-sbnu-vms
   ```
2. Run the app with real-data mode:
   ```
   flutter run --dart-define=USE_FIREBASE_EMULATORS=true
   ```
3. (Optional) Run the rules tests against the emulator:
   ```
   flutter test test/firestore_rules_test.dart
   ```

Ordinary builds (no `--dart-define`) keep preview/synthetic data — no silent redirect to production Firestore.

### Production Firestore — not connected
Firestore rules have stakeholder sign-off and rules tests, but require security/privacy reviewer approval before production deployment.

- Firebase Auth sign-in — repository contract exists; provider and account lifecycle decisions pending
- QR session issuance/scan validation — requires trusted server validation
- Incident location collection / map — provider and precision decisions pending
- SOS delivery — no real routing or push; clearly labeled as preview
- Hotline directory loaded from institution-provided contacts; entries are pending verification and visibly non-callable until an admin verifies them
- Production analytics/export — synthetic data only

## Current verification

- `flutter analyze --no-pub` — no errors (only warnings/info lints)
- `flutter build web --no-pub` — succeeds
- `dart format lib/` — applied

## Next development sequence

1. Approve scope, supported platforms, role/action permissions, Firebase region, privacy classification, and data retention.
2. Add authentication/session and account approval using the approved identity lifecycle.
3. Define feature repository contracts, Firestore queries/indexes, callable operations, and least-privilege Rules; test authorization allow and deny cases.
4. Connect activities, organizations, volunteer profiles, participation, attendance, and announcements to an approved development environment.
5. Add QR only after server validation and replay/idempotency rules are in place.
6. Add incidents, map/list, verified hotlines, and SOS only after privacy review and named operational owners/coverage are approved.
7. Complete security/privacy, accessibility, backup/restore, monitoring, support, pilot, and release gates.