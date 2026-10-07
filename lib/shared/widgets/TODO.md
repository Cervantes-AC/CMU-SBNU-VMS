# TODO: widgets

**Status:** Shared contracts/widgets implemented (Result, AppFeedback, StatusBadge, EmptyState, RouteGuard, AppShell). The authenticated application shell provides adaptive navigation with role-based destination filtering. Additional shared widgets may be added as patterns emerge; contracts remain stable. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `shared/widgets/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/shared.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Presentation only. Do not query repositories, decide authorization, or disguise errors as empty states.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

## Shared contracts/widgets

### `lib/shared/result.dart`

**Exports:** sealed `Result<T>`, `Success<T>`, and `Failure<T>` (or equivalent sealed success/failure type), plus pattern-friendly accessors only if they simplify callers.

Represent successful values separately from failures. `Failure` carries a typed safe/domain error, not a raw Firebase exception or sensitive payload. Define `map`/`fold` only if their semantics are tested. Never model loading as a result; loading belongs to view state.

**Tests:** success/failure pattern handling, value mapping, error identity/category preservation.

### `lib/shared/route_guard.dart`

**Exports:** `RouteGuard` and explicit route access metadata (`RouteAccess`, `AuthRequirement`, or documented equivalent).

Apply signed-in, approved status, role, and any required step-up-auth policy to route decisions. Resolve unknown/malformed roles to denied. Return redirect decisions without doing database I/O during widget build; consume the auth/profile stream from the app layer. Keep backend rules authoritative.

**Tests:** all roles Ã— statuses Ã— route requirements, null user/profile, unknown role, expired session, and no redirect loops.

### `lib/shared/app_shell.dart`

**Exports:** authenticated navigation shell and navigation destination descriptor.

Render responsive navigation (mobile bottom/navigation rail/drawer as appropriate), current route and role-specific allowed destinations. Route visibility must use the shared route policy. Preserve state only where safe and clear user-specific shell state at sign-out. No hard-coded role authorization separate from the access matrix.

**Tests:** destination set for each role, responsive navigation, active destination and denied deep link.

### `lib/shared/app_feedback.dart`

**Exports:** shared success/error/info feedback helpers or `AppFeedback` service.

Map typed app errors to concise actionable user messages. Never expose stack traces, raw SDK messages, document IDs, secrets, or PII. Use accessible snackbar/dialog semantics and avoid duplicate feedback for one event.

**Tests:** each error category maps to expected safe copy; unknown error maps to generic retry/contact message.

### `lib/shared/status_badge.dart`

**Exports:** `StatusBadge` and, if needed, a typed status/color mapping.

Display known account/event/attendance/incident states with text plus color/icon so meaning is not conveyed by color alone. Unknown values show a neutral label. Do not embed transition policy here.

**Tests:** all supported values, unknown value, contrast/semantics labels.

### `lib/shared/empty_state.dart`

**Exports:** reusable `EmptyState` widget with title, explanation, optional action/icon.

Differentiate no records from permission errors and failed loads. Button callbacks must be optional and accessible.

**Tests:** title/body/action rendering and semantic button behavior.

### Additional shared widgets required as duplicated patterns appear

Place a shared widget in `lib/shared/widgets/` only after two or more modules need the same visual contract. Expected initial candidates: `loading_state.dart` (`LoadingState`), `error_state.dart` (`ErrorState` with retry), `confirm_dialog.dart` (`ConfirmDialog` with explicit destructive action), `form_field_error.dart`, and `responsive_content.dart`. Each widget gets a widget test for semantics, narrow layout and callbacks. Do not create these as broad generic frameworks before a real caller exists.

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

