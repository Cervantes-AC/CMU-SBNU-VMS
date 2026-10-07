# TODO: dashboard

**Status:** A debug-only administrator dashboard preview is implemented with synthetic display values. Minimal production role dashboards (member/officer/admin) are now implemented as guarded post-sign-in destinations using the shared dashboard scaffold; they show role-aware greetings and sign-out but no live data connections. This file is an implementation plan for remaining data-connection work. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `features/dashboard/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/features.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Show only role-authorized records and approved aggregates. Never load whole collections or expose incident narrative.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

### `lib/features/dashboard/`

**Files:** `dashboard_router.dart` (`DashboardRouter` chooses by approved `UserRole`), `member_dashboard.dart`, `officer_dashboard.dart`, `admin_dashboard.dart`, optional `organization_dashboard.dart` only after this persona is approved, `dashboard_controller.dart` for cross-repository loading, `widgets/dashboard_summary_card.dart`, `widgets/dashboard_quick_action.dart` only when reused.

**Contract:** show only metrics/actions whose source repositories authorize the viewer. Member: own upcoming items/hours/announcements; officer: authorized event queue/attendance/incidents; admin: aggregate account and operations status. No dashboard may fetch an entire collection or expose sensitive incident text in a card. Each card has a destination gated by shared route metadata.

**Tests:** role-specific content, pending user denied, unavailable data/error, empty state, no cross-role leakage, responsive mobile/wide layouts.

## Current local demo

- `demo_admin_dashboard_screen.dart` and its focused `widgets/` render a responsive visual preview inspired by the NSRC admin dashboard.
- The app exposes this route only when `kDebugMode` is true. `DemoAdminCredentials` are local fixture strings checked by the app shell; they are not a Firebase Auth user and do not grant a `UserRole.admin` session.
- Dashboard figures and queue entries are synthetic presentation samples. They do not come from Firestore or represent unit statistics. Do not add operational actions or real records to this preview.
- Production dashboard implementation remains blocked on auth/session wiring, approved role and data contracts, and bounded authorized repository queries. Follow B-026 in the implementation backlog.

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


