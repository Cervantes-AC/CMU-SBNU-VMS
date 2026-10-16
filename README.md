# CMU–SBNU Volunteer Management System

A Flutter/Dart project for a proposed volunteer management system for Central Mindanao University's School-Based National Service Reserve Corps Unit (CMU–SBNU). The planned system is intended to help authorized users coordinate volunteer profiles and organizations, activities, participation, attendance, announcements, and operational reports. The reviewed planning baseline also proposes QR-assisted attendance, incident reporting and map/list views, an SOS workflow for designated handlers, and an institution-verified hotline directory.

**Project status:** active interface development. The Flutter app now includes a public landing page and a responsive local preview workspace with sample screens for overview, activities, volunteers and organizations, attendance, announcements, emergency and safety, reports, and access/operations. Preview interactions are in-memory only and use synthetic data. Authentication, persistence, Firestore reads/writes, QR validation, hotline calling, map data, SOS routing, and production reports are not connected. See the [development status](docs/development-status.md) for implemented scope and gates still pending.

The specification in [`docs/CMU_SBNU_Volunteer_Management_System_Documentation.docx`](docs/CMU_SBNU_Volunteer_Management_System_Documentation.docx) remains a proposed requirements and design baseline. It does not establish institutional approval or production readiness. Roles, first-release scope, data handling, Firebase choices, and emergency procedures require owner review. See the [implementation plan](docs/implementation-plan.md), [architecture](docs/architecture.md), [branding](docs/branding.md), and [Git workflow](docs/git-version-control.md).

## Proposed technology

- Flutter and Dart for the client application.
- Firebase Authentication and Cloud Firestore are included as current Flutter dependencies.
- The planning baseline proposes trusted server-side operations for privileged workflows. Confirm products, environment setup, rules, integrations, supported platforms, and costs before implementation.

The presence of a dependency or configuration file does not mean the corresponding service is deployed or production-ready. The current Firestore rules deny all client reads and writes until a reviewed least-privilege policy is added.

## Getting started

Install Flutter with a Dart SDK compatible with the constraint in `pubspec.yaml`, then from the repository root run:

```sh
flutter pub get
flutter run
```

The selected development project is `cmu-sbnu-vms`, and the Flutter client options are in `lib/firebase_options.dart`. Firebase Core initializes from those options, but the current app performs no Auth or Firestore reads/writes. Use synthetic data only. To prototype Auth and Firestore locally, start the emulators and run the app with the explicit emulator flag:

```sh
firebase emulators:start --only auth,firestore
flutter run --dart-define=USE_FIREBASE_EMULATORS=true
```

For an Android emulator, set `--dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2` as well. Do not add service-account credentials, production secrets, or real volunteer/incident data to the client or source control. Never ship server credentials in a Flutter app.

## Repository map

- `lib/` — Flutter entry point, app composition, and planned feature-first source layout. See [`lib/README.md`](lib/README.md).
- `assets/images/` — CMU, ODRRM, and SBNU logo assets.
- `docs/` — project planning source, implementation plan, branding notes, and Git workflow.
- `test/` — Flutter test sources.
- `firestore.rules` and `firestore.indexes.json` — Firestore rules/index configuration; review and test rules before enabling data access.
- `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/` — Flutter platform projects.

## Development commands

```sh
flutter pub get       # Resolve Dart/Flutter dependencies
flutter run           # Run on a configured device or emulator
flutter analyze       # Run static analysis
flutter test          # Run the Flutter test suite
```

## Safety and privacy notes

The proposed SOS feature is an in-app alert workflow. It does not contact public emergency services and cannot guarantee delivery or response. Production SOS requires approved responder coverage, escalation and fallback procedures, training, and a simulation. Location should be optional and limited to approved user-initiated workflows; continuous background tracking is outside the proposal. Restrict incident details, minimize notification content, and obtain institutional privacy/security review before using real personal or emergency data.

## Project documentation

- [Implementation plan](docs/implementation-plan.md)
- [Development status](docs/development-status.md)
- [Architecture decision](docs/architecture.md) — feature-first MVVM structure and Firebase trust boundaries.
- [Specification Markdown index](docs/specification/README.md) — topic-by-topic breakdown of the supplied planning baseline.
- [Original planning baseline](docs/CMU_SBNU_Volunteer_Management_System_Documentation.docx)
- [Branding notes](docs/branding.md)
- [Git version control guide](docs/git-version-control.md)
