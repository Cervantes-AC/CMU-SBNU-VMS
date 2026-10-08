# AI Coding Agent Guide

## 1. Project overview

- **Name:** CMU SBNU Volunteer Management System (`cmu_sbnu_vms`).
- Flutter project intended to help CMU School-Based NSRC Unit volunteers and authorized officers coordinate approved unit work.
- Goal: role-aware volunteer operations with least-privilege access and privacy safeguards. The current UI is a starter screen; planned features are not necessarily implemented or approved.
- This repository is the project of record. `docs/nsrc_vms/` is prototype reference material only. Never copy its credentials, data, or backend configuration.

## 2. Tech stack and versions

- Flutter 3.38.9 stable; Dart 3.10.8 (`pubspec.yaml` requires `^3.10.8`).
- Firebase Authentication and Cloud Firestore packages are declared. Client options target `cmu-sbnu-vms`; Firebase is not initialized by the current starter app.
- `pubspec.yaml` also declares `go_router`, `provider`, `shared_preferences`, `connectivity_plus`, `mobile_scanner`, `intl`, and `crypto`.
- No Node backend or npm test suite is configured; this repository currently uses Flutter tooling.
- Android is the first intended platform. Other Flutter host folders do not imply release support.
- Hosting/deployment target: none approved. Work locally; use emulators only when their configuration exists. Do not deploy without explicit authorization.

## 3. Folder structure

- `lib/main.dart`, `lib/app.dart`: current entry point and starter root widget.
- `lib/firebase_options.dart`: generated Firebase client options; do not hand-edit or copy from the prototype.
- `lib/core/`, `lib/data/`, `lib/shared/`, `lib/features/`: planned source layers; consult `docs/ARCHITECTURE.md` before adding files.
- `assets/images/`: configured image assets; institutional branding use still needs approval.
- `test/`: Flutter tests. The current widget test expects old landing-page copy.
- `docs/nsrc_vms/`: prototype source snapshot, not runnable target application code.
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`: Flutter platform hosts.
- `firestore.rules`: deny-all client policy. `firestore.indexes.json` currently has no indexes.
- `firebase.json` and detailed `docs/lib/` specifications are absent. Use `docs/ARCHITECTURE.md` for the source map.

## 4. Setup commands

Run from the repository root:

```powershell
flutter doctor -v
flutter pub get
flutter devices
flutter run
flutter test
flutter analyze
dart format <changed-files>
flutter build apk
```

- `flutter run -d chrome` requires a configured Chrome target.
- There is no Firebase emulator config in the current checkout. Do not assume an emulator is running or connect to cloud services.
- Use Flutter tooling for this app. Add backend tooling only when a task requires it and the user approves the dependency.

## 5. Coding conventions

- Dart naming: `snake_case.dart` files, `UpperCamelCase` types, and `lowerCamelCase` members.
- Use `package:cmu_sbnu_vms/...` imports across directories.
- Keep UI in widgets, orchestration in controllers, data mapping in repositories, and SDK access behind services.
- Inject dependencies. Screens must not query Firebase directly. Keep models immutable and errors typed.
- Handle loading, empty, failure, and offline states for data-backed screens.
- Never log credentials, personal data, incident details, or raw backend payloads.
- Format changed Dart files with `dart format`; keep diffs focused.

## 6. Rules for the AI

- Make small, focused changes, one task at a time. Explain a plan before large changes.
- Do not delete files or add dependencies without asking the user.
- Never hardcode secrets. `.env` patterns and `service-account.json` are ignored; never commit secrets or credential files.
- Use synthetic fixtures. Never access production data unless explicitly authorized.
- Backend rules/functions enforce authorization; hidden buttons and client route guards are not security.
- Inspect `git status` and relevant diffs before editing. Preserve unrelated changes. Do not stage or commit unless asked.
- Do not push, merge, publish, deploy, or contact people unless explicitly authorized.
- Do not add or run tests unless the user explicitly asks to test or verify implementation. When verification is authorized, run relevant checks and report exact commands and outcomes.
- Treat open product/data decisions as unresolved. Ask only when a missing decision blocks safe implementation.

## 7. Current status

- `lib/main.dart` launches `NSRCApp` from `lib/app.dart`; the UI is a simple starter screen.
- Most feature source is absent. `docs/ARCHITECTURE.md` describes the proposed feature-first layout.
- Firebase client options and Android configuration identify `cmu-sbnu-vms`; the app does not initialize Firebase. `firestore.rules` deny all client reads/writes.
- The widget smoke test is stale relative to the current starter screen.
- Real-data use, production operations, branding/public release, and sensitive features need owner decisions.
- Suggested next work: update the root app smoke test when verification is authorized, then implement the foundation and approved identity workflows in small slices.

## 8. Out of scope

- No prototype backend/configuration, production data, or cloud deployment without explicit authorization.
- Do not build user impersonation, arbitrary database queries/writes, unrestricted personal-data export, client-side restore, public incident maps, background location tracking, or client-held privileged keys.
- Do not implement incident response, QR duty, SOS/notifications, public branding, export/restore, or admin data tools before their policy and security decisions are approved.
- Do not claim production readiness because the app builds or runs locally.
