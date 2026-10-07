# TODO: constants

**Status:** Core constants implemented (app_constants, route_names, firestore_paths). Constants barrel and imports follow relative paths. No credentials or mutable state. Some policy values remain subject to confirmation (unit timezone/limits as documented). This module continues to evolve with no security-impacting changes. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `core/constants/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/core.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Only stable keys and approved values; no credentials, mutable feature state, or unresolved policy constants.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

### `lib/core/constants/app_constants.dart`

Expose immutable product-independent limits and configuration keys only: supported page size, text/input limits, environment key names, cache schema version, unit timezone identifier after it is confirmed, and app metadata. Do not store API keys, passwords, real phone numbers, role policies, or mutable feature state here. Constants requiring product approval must be annotated with the decision/source.

### `lib/core/constants/route_names.dart`

Expose typed or constant route path/name definitions for public routes and feature routes. Keep route authorization metadata in one shared route table used by the router and `RouteGuard`; no screen should invent route strings. Tests ensure no duplicate path/name and every protected route has access metadata.

### `lib/core/constants/firestore_paths.dart`

Expose typed path builders for only approved collections and nested paths (for example `users/{uid}` and device-token paths). Validate path segments and never accept a raw user-provided collection name. Names must match `firestore.rules`, indexes and the data dictionary. Tests verify expected paths and reject invalid IDs.

## Error handling
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


