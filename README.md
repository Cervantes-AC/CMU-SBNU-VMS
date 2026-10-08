# CMU SBNU Volunteer Management System

`cmu_sbnu_vms` is a Flutter application project for the Central Mindanao University School-Based National Service Reserve Corps Unit (CMU SBNU). Its planned purpose is to give volunteers and authorized unit officers a role-aware place to coordinate approved activities while protecting member information and recording privileged actions.

Use only approved project configuration and synthetic data during local development. Never commit credentials or service-account keys to the Flutter client.

## Current state

The application is at a clean restart point. `lib/main.dart` launches `NSRCApp` from `lib/app.dart`, which currently displays a simple CMU SBNU VMS screen. Most feature source files are not currently present in `lib/`; the planned ownership map is in [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md). The declared Flutter dependencies include Firebase, routing, state management, local preferences, connectivity, QR scanning, and utility packages, but the current starter screen does not yet connect those services.

Product requirements and module plans below describe the intended direction. They do not mean that a feature is implemented, institutionally approved, or ready for real data. Some product and operating decisions remain open. Use synthetic data and local development only until the relevant owner approvals and backend protections are in place.

## What the system is intended to do

### Product goals

- Give members access to approved announcements and events, their own profile, attendance history, and service summary.
- Help authorized officers coordinate events and record attendance with traceable corrections.
- Give administrators a controlled workflow for account review and access management.
- Keep access role-aware, auditable, privacy-conscious, and suitable for Android-first use. Responsive web support may be retained as scope is confirmed.

### Roles and access model

The planned application roles are:

| Role | Intended access |
|---|---|
| `member` | Read and update allowlisted fields on their own profile; view published events and announcements; view their own attendance and service summary; request event participation where enabled. |
| `officer` | Member access plus authorized event coordination, attendance recording and correction, and approved incident response work. |
| `admin` | Officer access plus controlled account approval, role/status management, announcement publishing, and permitted aggregate or audit views. |
| `organization` | Deferred. This role requires an owner-defined identity process, purpose, and field-level access policy before implementation. |

The planned approval gate treats missing, malformed, pending, denied, blocked, suspended, or deactivated accounts as unapproved for protected application data. Role assignment and account approval must be enforced by trusted backend operations. A hidden button or client-side route guard is not a security boundary.

### Planned feature scope

The order below is a product roadmap, not a claim of implementation:

1. **Foundation and identity:** application startup, sign-in, password reset, session handling, approval gate, sign-out, access-denied and pending states.
2. **Member operations:** own-profile view/edit, role-aware app navigation, events, announcements, attendance, and service summary.
3. **Oversight:** audited privileged actions, controlled account management, and approved aggregate reporting.
4. **Separately gated capabilities:** incident reporting, QR duty monitoring, notifications/SOS, analytics, exports, backup/restore, public landing/contact, PDF generation, and administrative data tools.

Incident handling, QR monitoring, public content/branding, export and restore, and arbitrary database/query tools require additional policy and threat-model decisions. Initial product scope excludes background location tracking, public incident maps, client-held privileged keys, user impersonation, arbitrary database access, unrestricted personal-data export, and replacing emergency services.

## Architecture

The proposed source layout is feature-first; the current app is still a starter screen. See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the practical folder guide.

- **`main.dart`** is the application entry point. As the app grows, it should coordinate environment validation and safe initialization without owning feature behavior.
- **`app.dart`** is the composition root for shared dependencies, theme, application providers, and the single router.
- **`core/`** is for small cross-feature foundations such as configuration, errors, and theme.
- **`features/<feature>/`** owns a feature's presentation and data code; add a domain layer only when its logic needs one.
- **`shared/`** is for code genuinely reused across unrelated features.

Screens should render state and forward user intent. View models or controllers coordinate UI state; repositories own data access; services wrap SDKs. Keep Firebase details behind feature data boundaries. Client route guards are not a security boundary; enforce data authorization in backend rules or trusted functions.

## Data, privacy, and security principles

- Use only the target identity and configuration belonging to this repository. The approved target Firebase project identifier is `cmu-sbnu-vms`; never fall back to the prototype project `nsrc-vms`.
- Do not access production data or deploy to a cloud environment unless a task explicitly authorizes it. Use synthetic fixtures and Firebase emulators for development once emulator configuration is available.
- Do not add credentials, service-account keys, tokens, real volunteer records, or personal incident information to source control.
- Collect only approved fields. A member cannot set their own role, account approval, actor identity, audit time, attendance total, or other privileged values.
- Store timestamps as UTC/server timestamps and make unit-local date rules explicit.
- Clear user-scoped in-memory state and caches when signing out or when access is revoked.
- Keep incident narratives, contact details, locations, credentials, and raw backend payloads out of logs, URLs, analytics labels, and public views.
- Prefer bounded, typed, purpose-specific repository operations. No generic client API for arbitrary Firestore collection reads or writes.
- Record privileged mutations through trusted backend operations and an append-only audit mechanism when that feature is implemented.

The project does not yet have a complete production backend, reviewed feature rules/functions, or approval to use real member data. A working screen or successful local build alone does not establish production readiness.

## Technology

- **Client:** Flutter and Dart. The repository's declared SDK constraint is Dart `^3.10.8`; the documented baseline is Flutter 3.38.9 stable with Dart 3.10.8.
- **Backend direction:** Firebase Authentication and Cloud Firestore, with Firebase Emulator Suite for local backend development.
- **Application structure dependencies declared in `pubspec.yaml`:** `go_router`, `provider`, `shared_preferences`, `connectivity_plus`, `mobile_scanner`, `intl`, and `crypto`, alongside Firebase packages and Flutter.
- **Platforms:** Flutter host directories are present for Android, iOS, web, Linux, macOS, and Windows. Android is the intended first platform; support and release readiness for other platforms are not implied by their directories.

## Getting started

### Prerequisites

- Flutter 3.38.9 stable and Dart 3.10.8 (or versions compatible with the SDK constraint in `pubspec.yaml`)
- Git and a Flutter-enabled editor
- Android SDK tooling for Android runs/builds
- Node.js and Firebase CLI only when working on Firebase emulator/backend configuration

Check the local toolchain with:

```powershell
flutter doctor -v
flutter --version
```

### Install dependencies and run the starter app

From the repository root:

```powershell
flutter pub get
flutter run
```

Select a device with `flutter devices`, then pass its ID, for example `flutter run -d chrome` for a configured Chrome target. The current root widget is a local starter screen and does not require Firebase initialization.

### Firebase development

Firebase work is not fully wired into the current starter app. Before adding it, confirm the generated options and every emulator/configuration file point only to `cmu-sbnu-vms` or an explicitly named local demo emulator project. Emulator setup must use an explicit demo project ID and deny-by-default Firestore rules until reviewed rules and security tests exist. Do not run a Firebase deploy command as a substitute for local testing.

The Firebase client configuration file, if regenerated, must be generated for approved target app registrations. Do not copy options or credentials from unapproved projects. Never put service-account keys in the Flutter client.

## Repository layout

```text
lib/                  Flutter app source
  main.dart           Entry point
  app.dart            Root application widget
  firebase_options.dart Generated Firebase client options
  core/ data/ shared/ Empty planned layers; add files when needed
  features/           Empty planned feature folders; add files as approved
assets/images/        Local image assets configured by pubspec.yaml
android/ ios/ web/    Flutter platform hosts (other host folders may also exist)
test/                 Flutter tests; current widget smoke test expects prior landing-page copy
firestore.rules       Current Firestore rules source file
firestore.indexes.json Firestore index configuration source file
```

## Development workflow

- Inspect `git status` and the relevant diff before editing. Preserve unrelated local changes.
- Read the module's architecture and product policy before adding a feature. Build one complete, reviewable slice at a time.
- Prefer injected dependencies and typed contracts. Do not add empty source files just to populate the tree.
- Update this README or the architecture map when project status or source organization materially changes.
- Do not use real personal data during development.
- Do not stage, commit, push, merge, publish, or deploy unless the task explicitly authorizes that action.
- Do not claim a command or review ran if it did not. Test and analyzer commands are listed for developers but were not run as part of writing this README.

For branch, staging, commit, and safe recovery practices, see the [Git version control guide](docs/git-version-control.md).

For the staged roadmap and phase readiness criteria, see the [development plan](docs/Development/README.md).

## Project decisions and readiness

The project identity is distinct from the earlier prototype. The target identifier `cmu-sbnu-vms` is the approved identity for this repository; production hosting/billing/IAM/region ownership and permission to store unit data must be resolved before production use. Product requirements remain a working baseline where approval is explicitly marked as proposed. Branding/public release, real-data field inventory, incident/privacy/retention policy, attendance-hour policy, QR anti-replay design, notifications, and backup/export decisions each require their owners' approval before the dependent feature is used.

Use this README for the project overview, [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for source organization, and [`docs/Development/README.md`](docs/Development/README.md) for the staged development plan.
