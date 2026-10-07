# Implementation Backlog and Exit Criteria

This backlog replaces references to a missing sprint plan. Work is ordered by dependency and risk. IDs are stable enough for branches/tasks; split items into PR-sized work but retain parent ID.

## Gate 0 — close decisions and repair foundation

| ID | Task | Acceptance / output | Blocks |
|---|---|---|---|
| B-001 | Reconcile target documentation and decision register | Root README links only existing target docs; D-01…D-27 owners/status and required evidence recorded | All work |
| B-002 | Approve proposed P0/P1 product scope | Product owner records accepted requirements or edits `PRODUCT_REQUIREMENTS.md` | Feature scope |
| B-003 | Confirm local/dev Firebase ownership/config | Emulator project/config and explicit dev identity documented; no prod access | Backend |
| B-004 | Pin toolchain and CI runner | Flutter/Dart/Node versions match README, pubspec and CI | All builds |
| B-005 | Add dependency baseline and replace starter bootstrap/test | Firebase deps intentionally selected; `main.dart` bootstraps safe app; counter removed; smoke test targets root app | P0 UI |
| B-006 | Implement the approved trusted backend contracts | Functions/rules implement only approved operations in `BACKEND_CONTRACTS.md`; authorization, validation, idempotency and audit tests pass | Any privileged write |

## Gate 1 — secure app foundation (P0)

| ID | Task | Acceptance / output |
|---|---|---|
| B-010 | Define approved data dictionary and role matrix | DATA_AND_ACCESS approved for synthetic/development scope; field owners and denied cases stated |
| B-011 | Implement core errors, result, logging, theme, route catalog | Contracts match `docs/lib/core.md` and `shared.md`; no raw exception/PII logs |
| B-012 | Configure emulator and deny-all rules/index skeleton | `firebase.json`, rules and indexes checked in; emulator-only instructions work; default all denied |
| B-013 | Implement auth/session/profile approval gate | Missing/pending/disabled fails closed; role/status cannot be client-set |
| B-014 | Implement app shell and approved routes | Route table and role nav match UI_AND_ROUTES; unknown/deep links safe |
| B-015 | Add auth, route-guard and rules tests | Anonymous/pending/member/officer/admin and cross-user cases cover all existing operations |

## Gate 2 — core volunteer operations (P1)

| ID | Task | Acceptance / output |
|---|---|---|
| B-020 | Profile self-view/edit | Minimal allowlist, cache isolation, negative role-field test |
| B-021 | Event browse/manage | Query/index plan, publication, valid transitions, page cursors, permissions tested |
| B-022 | Announcement view/manage | Audience/draft/publish/expiry rules, page limits and role tests |
| B-023 | Attendance record workflow | D-10 approved; idempotent writes, authorized roster, audited corrections |
| B-024 | Service summary calculation | Pure calculator matches policy examples; no client-set total |
| B-025 | Audit read/write | Trusted append, admin read only, redacted minimal fields, tests |
| B-026 | Role dashboards | Only approved bounded metrics, explicit empty/stale/error states |

## Gate 3 — optional sensitive/administrative capabilities

Only create a child backlog item after its decision closes.

| ID | Candidate | Prerequisite |
|---|---|---|
| B-030 | Incident report/response | D-03, D-11, data contract, responder roster/process |
| B-031 | QR check-in/duty monitoring | D-10, D-12, server validation/function and replay model |
| B-032 | Push notifications/SOS | D-13, verified recipients, permission UX and failure runbook |
| B-033 | Analytics/report/PDF | Approved metrics/fields/timezone/export authorization |
| B-034 | Import/export | D-03 and field allowlist, dry-run, batch rollback and audit |
| B-035 | Backup/restore | D-20, RPO/RTO, tested restore and separate privilege |
| B-036 | Public landing/contact/brand | D-01, D-17, D-18, privacy notice and abuse protection |
| B-037 | AI accomplishment writing | D-15, data minimization, provider server key, human review |
| B-038 | Admin query/database browser | approved narrow use case and reviewed threat model; arbitrary query remains excluded |

## Definition of backlog completion

An item is done only when acceptance criteria are linked to evidence; source/file spec and relevant data/access docs match behavior; automated tests/checks required for that item pass in CI/emulator; security-negative cases exist; no secret/personal data is introduced; and the owner approval gate is recorded where required. “Code written” is not a completion state.

