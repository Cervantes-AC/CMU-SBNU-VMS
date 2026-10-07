# Development Readiness Checklist

This checklist records verified repository state at the development gates. It is not release approval. Update a checkbox only when its full acceptance evidence exists; partial progress stays unchecked and is described in the notes. Production gates are in [the operations runbook](operations-runbook.md).

## Gate 0 — repository baseline

- [x] **B-001 (documentation map):** README and docs relative links resolve. Verified 2026-10-07.
- [x] **Local Flutter toolchain:** Flutter 3.38.9 / Dart 3.10.8 observed on the review machine 2026-10-07. This does not complete B-004's CI runner requirement.
- [x] **Flutter dependency/analyzer baseline:** `flutter pub get` and `flutter analyze` succeed on the starter repository (2026-10-07).
- [x] **Starter test baseline:** `flutter test` passes the counter starter test (2026-10-07). This is not feature or security coverage.
- [x] **B-003 (local emulator config):** Auth and Firestore emulator ports, demo project instructions, empty index catalog, and deny-all Firestore rules are checked in. Startup must be verified on the contributor machine before relying on it.
- [ ] **B-002 (product scope):** Product owner has accepted or amended the proposed P0/P1 scope. Until then, implement only foundation work that is safe under the documented synthetic-data defaults.
- [ ] **B-004 (toolchain/CI):** CI host, runner image, and pinned Flutter/Dart/Node versions are configured and verified. The local Flutter version alone is insufficient.
- [ ] **B-005 (application bootstrap):** Replace counter `main.dart` and counter test with safe bootstrap/root-app smoke coverage; wire explicit emulator-only Firebase initialization before any Firebase client is used.
- [ ] **B-006 (trusted backend):** Implement only owner-approved backend operations with validation, authorization, idempotency, audit, and emulator evidence.

## Gate 1 — secure application foundation

- [ ] **B-010:** Data dictionary and role matrix are accepted for the intended synthetic/development scope. Open production data decisions remain open.
- [ ] **B-011:** Core errors, result types, logging redaction, theme, and route catalog match `docs/lib/core.md` and `docs/lib/shared.md`.
- [ ] **B-012 (runtime verification incomplete):** Emulator configuration, Firestore rules path, empty indexes file, and default deny-all rule exist. Firebase CLI recognized the demo project, but the Firestore emulator binary download timed out, so startup and denied read/write behavior were not verified. Retry on a network that can reach Firebase's emulator download host before marking B-012 complete. No collection access is approved by this baseline.
- [ ] **B-013:** Auth/session/profile approval gate fails closed and has authorized emulator security coverage.
- [ ] **B-014:** App shell and approved routes exist and match the route/access contract.
- [ ] **B-015:** Auth, route-guard, and rules tests cover anonymous, pending, approved roles, cross-user access, and denied operations.

## Production and real-data gate

Do not use real volunteer data, deploy, or publish while required decisions remain open. Resolve the relevant entries in [the decision register](../overview/decision-register.md), including data/privacy and retention (D-03), cloud ownership and environments (D-05/D-06), identity and role provisioning (D-07/D-08), and production data permission (D-22). See [the implementation backlog](implementation-backlog.md) and [operations runbook](operations-runbook.md) for evidence requirements.

## Verification record

The commands above were run on 2026-10-07: `flutter pub get` succeeded, `flutter analyze` reported no issues, and `flutter test` passed one counter test. Markdown links were checked. Firebase emulator startup/rules behavior, CI, application bootstrap, feature behavior, and production readiness are not verified by those Flutter commands.
