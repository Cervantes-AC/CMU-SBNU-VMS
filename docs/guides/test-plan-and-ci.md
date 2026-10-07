# Test Plan and Continuous Integration Contract

**Current state:** Flutter has one passing counter starter test; no CI workflow, Firebase rules/functions test harness, or feature test suite exists. The Auth/Firestore emulators are configured with a deny-all Firestore baseline, but emulator behavior has not yet been validated by a rules test. This page defines what to add and what CI must prove.

## 1. Local verification

When the user explicitly asks for tests or implementation verification, run the narrowest suitable check first. Full PR baseline:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

When backend changes:

```powershell
npm ci --prefix functions
npm --prefix functions run lint
npm --prefix functions run build
npm --prefix functions test
firebase emulators:exec --project demo-cmu-sbnu-vms "npm --prefix functions run test:rules"
```

The Functions scripts above are **required future scripts**, not claims that they exist today. Keep runnable command names synchronized with actual `package.json` scripts when backend is implemented. Platform smoke build is limited to approved target(s), for example `flutter build apk --debug` in CI; release signing belongs to secured release jobs.

## 2. Required CI workflow files

Add `.github/workflows/ci.yml` when GitHub is the approved Git host (D-24). Until then, treat the following as host-neutral CI requirements and implement in the chosen platform.

Pull request workflow:

1. Checkout exact commit; install pinned Flutter/Dart and Node versions; restore cache keyed by lockfiles.
2. `flutter pub get` and verify lockfile unchanged.
3. Format check and `flutter analyze`.
4. `flutter test --coverage` with deterministic synthetic fakes.
5. For `functions/` changes: `npm ci`, lint, typecheck/build, unit tests.
6. For Firestore/Storage rules, indexes or functions: start Firebase emulators using a demo project ID; run both allow and deny rules tests and function integration tests.
7. Build approved non-release target(s) to catch platform compilation/config errors.
8. Upload non-sensitive reports/logs; fail the job on any required check failure.

Security of CI:

- Fork/untrusted PR jobs get no production secrets, signing credentials or privileged Firebase IAM.
- Pin third-party actions by immutable version/commit where platform permits; grant minimum workflow permissions.
- Do not deploy from pull request workflow. Deployment is separate, environment-protected and manually approved.
- Dependency/security scanning can run without access to production data; record and triage findings.

## 3. Test suite structure

```text
test/
  unit/{models,validators,calculators,controllers,repositories}/
  widget/{auth,route_guard,navigation,events,attendance,shared}/
  integration/{auth_gate,event_flow,attendance_flow}/
  security/{firestore_rules,storage_rules,authorization_matrix}/
functions/test/{unit,authorization,integration}/
```

## 4. Minimum test matrix

- Models: valid/invalid fields, unknown enum, serialization round trip, schema compatibility.
- Auth: signed out, pending, approved, missing profile, denied/blocked/deactivated, role change, sign-out cache clearing.
- Access: anonymous and every role against every collection operation; owner vs different UID; unknown paths denied; privileged fields immutable.
- Events: publication/audience, start/end boundaries, state transitions, duplicate join, pagination and permission denial.
- Attendance: duplicate retry, correction audit, allowed statuses, invalid time/hour calculations, member self-award denied.
- UI: responsive widths, loading/empty/error/offline states, keyboard/focus, semantics, cancellation.
- Backend: verified actor, malformed request, unauthorized actor, idempotency, transaction race, retry behavior and secret/PII redaction.
- Deferred modules receive tests only after decision gate; test design accompanies feature planning.

## 5. Production verification evidence

Before release: all CI jobs green on exact commit; rules/indexes/functions emulator tests pass; release build uses explicit environment; staging smoke for each supported platform; privacy and accessibility reviews complete; dependency findings triaged; restore/rollback evidence exists; exact artifact SHA, project ID and approvals recorded. CI green alone is not production approval.

