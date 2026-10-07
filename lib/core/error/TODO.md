# TODO: Core error handling

**Status:** Planning scaffold. This file is an implementation plan, not evidence that these files or behaviors exist. Follow the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

Implement the shared error boundary for `lib/core/error/`. The canonical file contracts are in [Core Infrastructure File Specifications](../../../docs/lib/core.md#error-handling). Follow the [implementation backlog](../../../docs/guides/implementation-backlog.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [security/privacy guidance](../../../docs/ai-coding/security-and-privacy.md). If an API must change, update the canonical spec before relying on it.

## Required files and responsibilities

### `app_exception.dart`

- [ ] Define a sealed `AppException` family with stable error codes/categories covering validation, unauthenticated, permission denied, not found, conflict, unavailable/offline, rate limit, and unexpected failures.
- [ ] Keep the underlying technical cause private to redacted diagnostics; do not include request payloads, personal data, secrets, or raw SDK messages in values exposed to UI.
- [ ] Provide a predictable safe representation for logging and display mapping without making exception strings a source of user-facing copy.

### `error_mapper.dart`

- [ ] Map Firebase, platform, and domain failures into the appropriate `AppException` category using stable SDK codes where available; do not rely only on message substring matching.
- [ ] Preserve cancellation as cancellation rather than converting it to an ordinary failure.
- [ ] Attach only a safe correlation ID when one is available; never include personal identifiers or payload values.
- [ ] Keep presentation text mapping localized and separate from SDK exception handling.

## Implementation sequence

- [ ] Confirm the shared `Result`/error convention with `lib/shared/result.dart` and use it consistently across repositories and controllers.
- [ ] Implement the exception types and mapper as an injectable, testable boundary without feature-specific policy.
- [ ] Route errors to `AppFeedback` or the shared presentation mapper; do not display stack traces, backend internals, or raw exception messages.
- [ ] Update callers and the canonical docs if error categories or public APIs change.

## Completion criteria

- [ ] Known SDK codes map to stable domain categories; unknown and future codes fail safely to a generic unexpected/unavailable category.
- [ ] Cancellation, permission denial, validation, and network/unavailable errors remain distinguishable to application logic.
- [ ] Technical causes and sensitive values cannot leak through UI copy, `toString()`, or structured logs.
- [ ] Acceptance scenarios in [the canonical spec](../../../docs/lib/core.md#error-handling) are covered when test creation is authorized. This TODO does not itself authorize adding or running tests; follow [`AGENTS.md`](../../../AGENTS.md).
