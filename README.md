# CMU SBNU VMS — School-Based NSRC Units Application

Flutter application for the **Central Mindanao University School-Based National Service Reserve Corps
Unit (CMU SBNU)**. The product goal is a role-aware volunteer operations tool: volunteer records, events,
attendance, incident reporting, and unit communication, with least-privilege access and auditable
actions.

## Project status (2026-10-07)

**This repository is in early frontend development. The app opens at a local landing page with a path to member sign-in and password reset. The landing page, sign-in/password-reset flows and session routing use go_router with Provider state; auth state is coordinated against Firebase Auth when configured. Debug builds include a local synthetic admin dashboard preview with fixture credentials. Authentication repository, emulator wiring (opt-in), and many production feature screens are still being connected. Public branding/release approval remains open.**

| | State |
|---|---|
| Application code | `lib/main.dart` initializes Firebase, configures opt-in local emulators, and runs `NSRCApp` with go_router + Provider. Sign-in and password-reset flows are wired to an `AuthRepository` and fail-closed guard. Minimal role dashboards exist and route by approved `UserRole`. Debug builds still include the local synthetic admin dashboard preview. |
| Dependencies | `firebase_core`, `firebase_auth`, `cloud_firestore`, `go_router`, `provider`, `shared_preferences`, `connectivity_plus`, `intl`, `crypto` are declared and locked; `flutter pub get` succeeds |
| Analyzer | **Passes** — `flutter analyze --no-pub` returns 0 issues |
| Tests | The existing root smoke test still expects preview-specific landing copy; it has not been updated or run for the current landing/auth flow |
| Firebase | Target client identifiers exist; Firebase initializes against `cmu-sbnu-vms` (validated at startup). Local Auth/Firestore emulators may be enabled with `USE_FIREBASE_EMULATORS=true` (default `localhost`); deny-all Firestore rules are configured. Feature rules/Functions/backend code are not fully implemented |
| Backend identity | `cmu-sbnu-vms` — **Decided 2026-09-23** (D-04); the `nsrc-vms` prototype is not this app's backend. The production project, billing/IAM/region owner, and permission to store unit data are still open (D-22) |
| Documentation | Consolidated descriptive-name docs under `docs/`; see [`docs/index.md`](docs/index.md) for the full map |
| Local development | `flutter run -d chrome` initializes Firebase (or shows a safe startup error), loads the landing page, and routes via go_router. Use `flutter run --dart-define=USE_FIREBASE_EMULATORS=true` to connect to local emulators (Auth 9099, Firestore 8080) |
| Real data | **None may be used** until the decisions in the open-decisions register are closed |

This repository **is** the project of record. The earlier prototype (Dart package `cmu_nsrc_app`, Firebase
project `nsrc-vms`) is kept as design input and described in [`docs/overview/about.md`](docs/overview/about.md): its code does
not run in this repository, and no data, seed file, or credential comes from it (see
[`docs/overview/decision-register.md`](docs/overview/decision-register.md) D-04, D-09). How its modules are ported here — identity
map, port order, per-module acceptance — is planned in [`docs/architecture/implementation-guide.md`](docs/architecture/implementation-guide.md)
and [`docs/lib/features.md`](docs/lib/features.md).

## Requirements

- Flutter **3.38.9** stable with Dart **3.10.8** (matches `pubspec.yaml`'s `sdk: ^3.10.8`)
- Git, an editor with the Dart/Flutter plugins, and Android SDK tooling for Android builds
- For rules and backend work: Node.js and the Firebase CLI

Verify with `flutter doctor -v`.

## Quick start

```powershell
flutter --version                 # confirm 3.38.9 / Dart 3.10.8
flutter pub get                   # install dependencies
flutter analyze --no-pub          # 0 issues as of 2026-10-07
flutter test                      # existing smoke test still expects previous landing-preview copy
flutter run -d chrome             # initializes Firebase and routes via go_router; use --dart-define=USE_FIREBASE_EMULATORS=true to connect to local emulators
```

For local Auth/Firestore emulator configuration, run in a separate terminal:

```powershell
firebase emulators:start --project demo-cmu-sbnu-vms
```

Then run the Flutter app with emulators enabled:

```powershell
flutter run --dart-define=USE_FIREBASE_EMULATORS=true
```

In a debug build, the sign-in screen includes a local-only admin preview account:
`admin@gmail.com` / `root@123`. The credentials are checked by the
Flutter app, do not exist in Firebase Auth, and open only a synthetic dashboard
preview. They are unavailable in profile and release builds.

Full setup, troubleshooting, and the environment-file steps are in
[`docs/guides/environment-setup.md`](docs/guides/environment-setup.md). Backend work needs either the Firebase
Emulator Suite or a `dev` project; see [`docs/overview/decision-register.md`](docs/overview/decision-register.md)
(D-04 is **Decided**: `cmu-sbnu-vms` is the project of record, and the prototype project `nsrc-vms` must never
be used as a backend).

## Developer Onboarding & Reading Guide

Follow the reading order matching your role to get started:

- 🛠️ **Developer Starting Feature Implementation:**
  1. **[`README.md`](README.md)** — Project status, baseline versions, and quick start commands.
  2. **[`docs/index.md`](docs/index.md)** — Central documentation map.
  3. **[`docs/architecture/implementation-guide.md`](docs/architecture/implementation-guide.md)** — Core architecture, error contracts & state management rules.
  4. **[`docs/lib/index.md`](docs/lib/index.md)** — File-by-file class contracts & implementation order for `lib/`.

- 💻 **Machine & Environment Setup:**
  - **[`docs/guides/environment-setup.md`](docs/guides/environment-setup.md)** — Local Flutter, Android SDK & Firebase Emulator Suite setup.

- 🤖 **AI Coding Assistant:**
  - **[`AGENTS.md`](AGENTS.md)** ➔ **[`docs/ai-coding/index.md`](docs/ai-coding/index.md)** — Mandatory AI safety rules, workflow & task templates.

## Repository layout

```text
lib/                Application source (landing, auth with session routing, minimal role dashboards)
test/               Widget tests (not yet updated for the current landing/auth flow)
docs/               Planning and architecture docs — see docs/index.md for the full map
  docs/overview/    Product scope, decision records, and prototype context
  docs/architecture/ Implementation guides, schema/data access, backend & UI contracts
  docs/guides/      Setup, backlog, checklists, operations & CI specs
  docs/lib/         File-by-file source contracts for lib/
  docs/ai-coding/   AI agent operating playbook
android/ ios/ web/ linux/ macos/ windows/   Flutter platform hosts
firebase.json       Firebase platform configuration
assets/images/      CMU and SBNU logo assets; use remains subject to D-18 approval
```

## Documentation: start here

The target-specific, file-by-file build plan and production-readiness criteria are in
[`docs/architecture/implementation-guide.md`](docs/architecture/implementation-guide.md). The source contract for every planned
`lib/` module and file is indexed in [`docs/lib/index.md`](docs/lib/index.md). Use these alongside
the approved requirements and decision records below. AI agents should start with
[`AGENTS.md`](AGENTS.md) and follow the [AI Coding Playbook](docs/ai-coding/index.md), including its
workflow, Git, security, review and handoff procedures. [`docs/overview/about.md`](docs/overview/about.md) describes the earlier
`nsrc_vms` prototype and is reference material only.

| If you are… | Read, in order |
|---|---|
| A developer about to write code | [`docs/index.md`](docs/index.md) → [`docs/architecture/implementation-guide.md`](docs/architecture/implementation-guide.md) → [`docs/guides/implementation-backlog.md`](docs/guides/implementation-backlog.md) → [`docs/guides/development-checklist.md`](docs/guides/development-checklist.md) |
| Setting up a machine | [`docs/guides/environment-setup.md`](docs/guides/environment-setup.md) |
| A product owner or sponsor | [`docs/overview/product-requirements.md`](docs/overview/product-requirements.md) → [`docs/overview/decision-register.md`](docs/overview/decision-register.md) |
| Reviewing safety, privacy, or risk | [`docs/guides/operations-runbook.md`](docs/guides/operations-runbook.md) → [`docs/overview/decision-register.md`](docs/overview/decision-register.md) |
| Trying to understand the target product | [`docs/overview/product-requirements.md`](docs/overview/product-requirements.md) → [`docs/overview/about.md`](docs/overview/about.md) (prototype reference) |
| Porting a prototype module | [`docs/overview/about.md`](docs/overview/about.md) → [`docs/lib/features.md`](docs/lib/features.md) → [`docs/architecture/implementation-guide.md`](docs/architecture/implementation-guide.md) |

## Contributing

1. Pick an unblocked task from [`docs/guides/implementation-backlog.md`](docs/guides/implementation-backlog.md) — or, later, an
   approved feature package from [`docs/ai-coding/task-template.md`](docs/ai-coding/task-template.md), or a
   staged port from [`docs/overview/about.md`](docs/overview/about.md)
   whose prerequisites are closed.
2. Branch from the integration branch (`T-xx-short-purpose`), keep the change small, and follow the
   conventions in [`docs/architecture/implementation-guide.md`](docs/architecture/implementation-guide.md) §3.
3. Before requesting review, run the authorized format/analyzer/test checks and report exact results. AI-assisted changes must also follow the test authorization rule in [`AGENTS.md`](AGENTS.md).
4. Meet the checklists in [`docs/guides/development-checklist.md`](docs/guides/development-checklist.md)
   and update docs/data contracts and (if a decision changed) the decision register.

**Never** commit credentials, service-account keys, or real volunteer data, and never point a build at the
prototype project `nsrc-vms` — this repository's Firebase project is `cmu-sbnu-vms` (D-04). See
[`docs/guides/environment-setup.md`](docs/guides/environment-setup.md).

## Ownership and licensing

No license file is present, and no institutional approval is recorded in this repository. Treat the code
and documentation as internal until the sponsor and repository owner confirm distribution terms
(D-01, D-18).
