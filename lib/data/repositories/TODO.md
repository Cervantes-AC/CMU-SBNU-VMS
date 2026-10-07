# TODO: repositories

**Status:** Planning scaffold. This file is an implementation plan, not proof of implementation or approval for a deferred capability. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `data/repositories/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/data.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Implement declared contracts with injectable adapters, bounded queries, idempotency, error propagation, and no SDK leakage to UI.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

## Repositories (`lib/data/repositories/`)

Create concrete `*_repository.dart` implementations corresponding to each interface. A repository owns: exact authorized query shapes, pagination, model mapping, typed error conversion, cache keys/TTL, cache invalidation after successful writes, and conversion of backend conflict states. It does not own widget state or bypass rules. Inject service/cache/current-session dependencies.

Each repository must have tests for success mapping, absent documents, malformed documents, permission denial, offline cached reads, stale cache labeling, write failure (cache must not falsely claim server success), pagination order/cursor, duplicate/retry idempotency and user-scope isolation. Emulator-backed rules tests separately verify the same read/write matrix against actual rules. Repository list contracts include page size and cursor and never fetch all records.

Required concrete files:

- `auth_repository.dart`: coordinates `AuthService` and current profile loading; clears user cache on sign-out and prevents stale profile from remaining active after UID changes.
- `user_repository.dart`: profile mapping, allowlisted patch, authorized page query, review-account and role-change delegation to trusted callable endpoint.
- `event_repository.dart`: published/member and staff query variants, bounded pagination, safe create/update payloads, join request idempotency.
- `attendance_repository.dart`: event/member scoped reads and trusted attendance write/correction; invalidates affected event and member summaries.
- `incident_repository.dart`: private submission and response queries; handles permission-denied without fallback to broad queries; sends minimal notification request.
- `announcement_repository.dart`: audience and publication-window query; invalidates visible feed after publication.
- `audit_log_repository.dart`: authorized bounded read/query and safe CSV projection; never writes.
- `qr_duty_repository.dart`: callable endpoint integration for session and scans; read-only authorized monitor/history streams.
- `repositories.dart`: optional barrel export only if import hygiene benefits; never add logic.

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

