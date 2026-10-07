# TODO: auth

**Status:** Planning scaffold. This file is an implementation plan, not proof of implementation or approval for a deferred capability. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `features/auth/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/features.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Public registration is off unless approved. Never offer role selection, disclose account existence, or allow pending/blocked accounts through guards.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

### `lib/features/auth/`

**Files:** `auth_screen.dart` (`AuthScreen`), `auth_controller.dart` (`AuthController`, immutable `AuthViewState`), optional `widgets/sign_in_form.dart`, `widgets/registration_form.dart`, `widgets/password_reset_form.dart` when registration/reset complexity needs separation.

**Controller API:** `signIn(email,password)`, `sendPasswordReset(email)`, optional approved `submitRegistration(RegistrationDraft)`, `clearMessage()`. State includes submitting, validation errors, safe failure category, and success/verification/pending status. Never retain password after request.

**Screen contract:** sign-in, reset, and registration only if institution-approved; clear explanation of pending approval; no self-service role selection. Must handle keyboard, autofill, text scaling, retry and disabled accounts. It delegates auth to `AuthRepository` and profile gating to app session state.

**Tests:** valid/invalid input, duplicate submission, password reset generic response, pending-account routing, auth failure, no role choice, password not retained.

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


