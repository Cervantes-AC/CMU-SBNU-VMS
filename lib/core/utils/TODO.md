# TODO: utils

**Status:** Planning scaffold. This file is an implementation plan, not proof of implementation or approval for a deferred capability. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `core/utils/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/core.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Keep helpers deterministic and side-effect free. Client validation never replaces server checks; timezone rules must be explicit.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

### `lib/core/utils/validators.dart`

Expose pure validators for required text, length, email format, phone display/input, safe free text, and approved identifiers. Client validation improves UX but duplicates authoritative backend checks. Return structured validation errors and do not normalize away meaningful user content. Test boundary lengths, whitespace, Unicode, malformed input and markup/control characters.

### `lib/core/utils/date_helpers.dart`

Expose parsers/formatters and explicit conversion helpers. Keep storage UTC; require a timezone argument for unit-local date-range boundaries. Define inclusive/exclusive interval behavior. Test daylight-saving transitions where relevant, midnight boundaries, invalid input and UTC/local conversions.

### `lib/core/utils/service_hours_calculator.dart`

Pure deterministic calculation from approved attendance/duty facts to hours; define rounding, minimum/maximum duration, timezone, overnight event and correction behavior in a documented policy. Never accept a user-maintained total as source of truth. Test negative/zero, overlaps, duplicate records, rounding and boundary timestamps.

### `lib/core/utils/responsive.dart`

Expose app breakpoints and layout helpers, not device identity. Use `LayoutBuilder` constraints; support compact phone, tablet and wide web layouts. Tests cover just-below/at/above each breakpoint and large text scaling.

### `lib/core/utils/logger.dart`

Expose structured log levels and a redaction boundary. Never log user-entered text, email, phone, location, auth tokens, FCM tokens, document payloads or exception causes containing data. Include operation name and safe correlation ID. Tests prove configured sensitive keys/values are redacted.
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


