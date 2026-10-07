# TODO: attendance

**Status:** Member attendance screen, Event attendance screen, MemberAttendanceController, OfficerAttendanceController, AttendanceRepository interface/impl, Attendance model implemented. Controllers handle loading, QR check-in, manual recording, corrections, and summary. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `features/attendance/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/features.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Requires approved attendance/correction policy, timezone, source of truth, retention, and trusted backend writes. Derive hours from trusted facts.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

### `lib/features/attendance/`

**Files:** `attendance_screen.dart` (authorized event roster), `member_attendance_screen.dart` (own history), `attendance_controller.dart`, `widgets/attendance_member_row.dart`, `widgets/attendance_status_picker.dart`, `widgets/attendance_summary.dart` only where reusable.

Officer flow selects event, loads paginated/appropriate roster, records allowed status, sees save/conflict state, and submits correction with reason if policy allows. Member flow is read-only. Hours are calculated from validated attendance/duty facts; no direct edit field for total hours. Protect against a second tap/retry duplicating a record.

**Tests:** member cannot mark attendance, officer scope check, duplicate prevention, corrected record audit, hour boundaries, event selection, offline/failed write state.

## Implementation checklist

- [ ] Confirm backlog stage and dependencies. If a prerequisite contract is missing, scope that work explicitly before building dependent UI.
- [ ] Create the named files and only justified local helpers. Preserve specified public APIs, file responsibilities, route names, domain invariants, and view-state behavior.
- [ ] Inject dependencies. Keep presentation, orchestration, domain policy, persistence, and SDK/platform adapters separated; avoid hidden global clients.
- [ ] Handle validation, persisted-data parsing, bounded pagination, retries/idempotency, and relevant loading, empty, stale/offline, failure, permission-denied, and conflict states.
- [ ] Enforce record and role scope in backend/rules as well as UI affordances. Derive actor identity and privileged values on the trusted side.
- [ ] Redact personal/sensitive data from logs, errors, analytics labels, cache, exports, URLs, and serialized payloads. Clear user-scoped state at sign-out/revocation where applicable.
- [ ] Update related data, route, backend, environment, operations, and backlog documentation when contracts or dependencies change. Record unresolved decisions.

## Acceptance and handoff

- [ ] All required files meet their specified responsibilities; no undeclared privileged behavior was added.
- [ ] Routes and repositories use the intended access policy; backend denial remains authoritative.
- [ ] Canonical boundary, retry, concurrency/idempotency, failure, and unauthorized-access scenarios are accounted for.
- [ ] Handoff states changed files, actual verification performed, unverified acceptance cases, configuration/migration needs, open decisions, and limitations.

**Verification rule:** Scenarios here and in canonical specifications describe future required evidence. They do not authorize adding or running tests. Follow [`AGENTS.md`](../../../AGENTS.md) and [testing/review guidance](../../../docs/ai-coding/testing-and-review.md).


