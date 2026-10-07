# Development Readiness Checklist

This checklist tracks what must be in place at each gate before implementation proceeds.
It is not a release approval; release gates are in `OPERATIONS_RUNBOOK.md`.

## Gate 0 — Foundation (before any feature code)

- [x] B-001: All README links resolve to existing files ← **done 2026-10-07**
- [x] B-004: `flutter --version` confirms 3.38.9 / Dart 3.10.8 baseline
- [x] B-004: `flutter pub get` succeeds with no lockfile warnings ← **done 2026-10-07**
- [x] B-005: `flutter analyze` passes with 0 errors ← **done 2026-10-07**
- [x] B-005: `flutter test` runs the starter test without errors ← **done 2026-10-07**
- [x] B-003: Documentation structure refactored & 100% verified ← **done 2026-10-07**

## Gate 1 — Secure foundation (before auth/profile)

- [ ] B-010: DATA_AND_ACCESS.md data dictionary accepted for synthetic scope
- [ ] B-011: Core errors, result type, theme, route catalog implemented
- [ ] B-012: `firebase.json` has emulator ports; deny-all rules exist
- [ ] B-013: Auth / approval gate implemented and tested against emulator
- [ ] B-014: App shell and routes implemented

## Decisions required before production

See `DECISION_REGISTER.md` for all D-01 through D-27 items.
All OPEN decisions must be resolved before any real data or public release.

