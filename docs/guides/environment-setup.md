# Developer and Emulator Setup

This procedure is for local development with synthetic data. It does not provision or deploy the production Firebase project.

## 1. Toolchain

- Flutter stable **3.38.9** and Dart **3.10.8**, per the current target `pubspec.yaml`/README baseline.
- Git and IDE with Flutter/Dart support.
- Android Studio/Android SDK for Android. Android host targets Java 17 in `android/app/build.gradle.kts`.
- Node.js LTS and Firebase CLI only for Functions/emulator/rules work.
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

Current known bootstrap issue: `lib/firebase_options.dart` imports `firebase_core`, while the current `pubspec.yaml` does not declare Firebase packages; `lib/main.dart` is still the counter starter. Do not present these commands as currently passing. First implementation task adds and locks the approved dependencies, replaces starter app/test, and wires emulator/dev config. Keep lockfile changes committed with dependency changes.

## 3. Firebase local emulator

The target `firebase.json` currently contains FlutterFire platform mapping but no Auth/Firestore/Functions/Storage emulator configuration. The backend foundation task should add `firestore.rules`, `firestore.indexes.json`, and emulator configuration with these conventional explicit ports unless a documented collision requires changing them: Auth `9099`, Firestore `8080`, Functions `5001`, Storage `9199`, Emulator UI `4000`; enable single-project mode. Use a Firebase **demo project ID** for local-only rules/functions tests where supported; do not accidentally connect emulator tests to `cmu-sbnu-vms` cloud services.

After reviewed emulator config exists, documented command should be:

```powershell
firebase emulators:start --project demo-cmu-sbnu-vms
```

The app must have an explicit development/emulator mode that connects every enabled Firebase SDK (Auth, Firestore, Functions, Storage) to localhost before any service initializes. Web uses the browser-accessible host; Android emulator uses its emulator host address; physical devices use the development machine's reachable LAN address. Never ship emulator host selection in a release build.

Rules tests and function tests use synthetic fixtures, seeded through test setup (not a checked-in service-account key). Emulator UI/export data remains local and disposable. Document any seed schema and reset command alongside emulator config.

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
| `permission-denied` in emulator | Expected deny-by-default until matching rules/test account exist; inspect rule coverage rather than relaxing rules globally |
| Web can't reach emulator | Wrong browser host/port or CORS; use configured browser host and keep release config separate |
| Project ID unexpectedly differs | Stop; inspect FlutterFire options, Gradle config, `.firebaserc`, environment define; do not continue against unknown backend |
| Tool versions differ | Align with pinned target baseline/CI; change versions only with reviewed toolchain decision |

## 6. Environment matrix (must be completed before cloud deployment)

| Environment | Firebase project ID | Data | Access/deploy identity | Status |
|---|---|---|---|---|
| Local | `demo-cmu-sbnu-vms` proposed emulator ID | Synthetic | Developer local process | Emulator config not yet present |
| Dev cloud | OPEN (D-05/D-06) | Synthetic only | Named dev IAM group | Not provisioned/verified in target docs |
| Staging | OPEN (D-05/D-06) | Synthetic | Restricted release group | Not provisioned/verified |
| Production | `cmu-sbnu-vms` app identity only; production project/ownership not confirmed | No data until D-03/D-05/D-22 close | Owner-appointed deployer | **Blocked; no deploy** |

