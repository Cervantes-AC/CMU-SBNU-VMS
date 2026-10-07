# Developer and Emulator Setup

This procedure is for local development with synthetic data. It does not provision or deploy the production Firebase project.

## 1. Toolchain

- Flutter stable **3.38.9** and Dart **3.10.8**, per the current target `pubspec.yaml`/README baseline.
- Git and IDE with Flutter/Dart support.
- Android Studio/Android SDK for Android. Android host targets Java 17 in `android/app/build.gradle.kts`.
- Node.js and Firebase CLI for emulator/rules work. The Functions toolchain is not needed until a Functions source package exists.
- A supported Java runtime for the Firebase emulators that require it; check the current [Firebase Emulator Suite requirements](https://firebase.google.com/docs/emulator-suite/install_and_configure).
- iOS builds require macOS/Xcode. Do not treat Linux/macOS/Windows desktop targets as product-supported just because Flutter host folders exist.

At setup, verify `flutter --version`, `dart --version`, `flutter doctor -v`. If the pinned baseline is unavailable, stop and update the toolchain decision/CI image rather than silently upgrading dependencies.

## 2. Flutter client

From repository root (PowerShell):

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Current state: `firebase_core` is declared and locked. `lib/main.dart` starts `NSRCApp`, which displays a static, unbranded landing preview. The app does not initialize Firebase or connect to either emulator. The counter test was replaced with a landing-root smoke test but has not been run since that change. Emulator-only SDK initialization, auth routing, and the rest of B-005 remain incomplete. Keep lockfile changes committed with dependency changes.

## 3. Firebase local emulator

`firebase.json` now configures the Auth emulator on `9099`, Firestore on `8080`, and Emulator UI on `4000`, with single-project mode. Firestore uses `firestore.rules` and `firestore.indexes.json`; the current rule deliberately denies all client reads and writes. There is no Functions or Storage emulator configured because no corresponding backend/client implementation exists yet. Add those emulators only with the approved feature/backend work. Use the Firebase **demo project ID** for local work; never use `cmu-sbnu-vms` as the emulator project ID.

From the repository root, start the configured local emulators with:

```powershell
firebase emulators:start --project demo-cmu-sbnu-vms
```

The UI is available at `http://127.0.0.1:4000`. The Firebase CLI requires Node.js; emulator runtime requirements vary by emulator, so use the current official requirements linked above. Stop the emulator with Ctrl+C. The Flutter app is **not yet wired** to these emulators. Before any Auth/Firestore client is initialized, B-005 must add an explicit development-only emulator mode and connect each enabled SDK to localhost. Use the browser-accessible host for web and the Android emulator host address for Android emulator builds. Do not add a production fallback when emulator configuration is missing. Never ship emulator host selection in a release build.

Rules tests use synthetic fixtures, seeded through test setup (not a checked-in service-account key). No rules test harness exists yet; the current deny-all rule is a safe baseline, not proof of the future access matrix. Emulator UI/data remains local and disposable. Document any seed schema and reset command alongside the test harness.

## 4. Firebase environment files and secrets

- `lib/firebase_options.dart` is generated for target app registrations using FlutterFire CLI. Verify each `projectId` and app ID against the environment table before use.
- The tracked Android native file `android/app/google-services.json` is currently present and identifies project `cmu-sbnu-vms` and package `com.cmu.sbnu.vms.cmu_sbnu_vms`. Verify this mapping before each environment-specific build. It is client configuration, not a service-account key; never replace it with the prototype file.
- `.firebaserc` should define explicit aliases only after D-05/D-06 are approved. Deploy instructions always pass `--project <explicit-alias-or-id>`.
- Local secret/config files are ignored and populated from an approved secret manager or a local template. Commit only `.env.example` with placeholder names/values, never credentials.
- Public Firebase web API identifiers are not server secrets; Admin SDK/service-account keys and provider API keys are secrets and stay server-side.

## 5. Common setup failures

| Symptom | Likely cause / response |
|---|---|
| Missing `FirebaseOptions` dependency | Firebase Core/dependency wiring not implemented; resolve in foundation task, do not patch generated options by hand |
| Android Google Services plugin cannot find config | Native config absent/wrong app ID; obtain approved target config, don't copy prototype config |
| `permission-denied` in emulator | Expected under the current deny-all baseline; add only reviewed, tested rules rather than relaxing rules globally |
| Web can't reach emulator | Wrong browser host/port or CORS; use configured browser host and keep release config separate |
| Project ID unexpectedly differs | Stop; inspect FlutterFire options, Gradle config, `.firebaserc`, environment define; do not continue against unknown backend |
| Tool versions differ | Align with pinned target baseline/CI; change versions only with reviewed toolchain decision |

## 6. Environment matrix (must be completed before cloud deployment)

| Environment | Firebase project ID | Data | Access/deploy identity | Status |
|---|---|---|---|---|
| Local | `demo-cmu-sbnu-vms` emulator-only ID | Synthetic | Developer local process | Auth/Firestore emulator config and deny-all Firestore rules present; app SDK wiring and rules tests remain pending |
| Dev cloud | OPEN (D-05/D-06) | Synthetic only | Named dev IAM group | Not provisioned/verified in target docs |
| Staging | OPEN (D-05/D-06) | Synthetic | Restricted release group | Not provisioned/verified |
| Production | `cmu-sbnu-vms` app identity only; production project/ownership not confirmed | No data until D-03/D-05/D-22 close | Owner-appointed deployer | **Blocked; no deploy** |
