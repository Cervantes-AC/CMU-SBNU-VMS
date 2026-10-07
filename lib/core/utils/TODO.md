# TODO: Core utilities

**Status:** Planning scaffold. This file is an implementation plan, not evidence that these files or behaviors exist. Follow the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

Implement pure, shared helpers for `lib/core/utils/`. The canonical file contracts are in [Core Infrastructure File Specifications](../../../docs/lib/core.md#pure-shared-utilities). Follow the [implementation backlog](../../../docs/guides/implementation-backlog.md) and relevant decisions. Client-side validation improves usability but never replaces trusted backend validation.

## Required files and responsibilities

### `validators.dart`

- [ ] Provide pure, structured validators for required text, length, email, phone input/display, safe free text, and approved identifiers.
- [ ] Preserve meaningful user content; do not silently normalize it. Cover whitespace, Unicode, malformed values, markup, and control characters in the acceptance cases.

### `date_helpers.dart`

- [ ] Provide parsers, formatters, and explicit timezone conversion helpers. Persisted timestamps remain UTC.
- [ ] Require a timezone argument for unit-local date boundaries. Do not hard-code `Asia/Manila` or another unit timezone until the owner decision is recorded.
- [ ] Document inclusive/exclusive interval semantics and invalid-input behavior.

### `service_hours_calculator.dart`

- [ ] Implement deterministic calculation from approved attendance/duty facts; never accept a client-maintained total as authoritative.
- [ ] Before official totals are exposed, resolve attendance rules and hour authority in D-10 and D-25. Document rounding, minimum/maximum duration, timezone, overnight events, corrections, and overlap handling.
- [ ] Until those decisions are approved, keep any calculations synthetic and explicitly provisional.

### `responsive.dart`

- [ ] Expose layout breakpoints/helpers based on available constraints rather than device identity.
- [ ] Support the approved compact, tablet, and wide layouts; respect large text scaling.

### `logger.dart`

- [ ] Provide structured log levels and a single redaction boundary for all application logs.
- [ ] Exclude entered text, email, phone, location, auth/FCM tokens, document payloads, and exception causes containing user data. Include only safe operation names and correlation IDs.

## Implementation sequence

- [ ] Keep helpers deterministic and side-effect free; inject any required clock/timezone source instead of reading global state.
- [ ] Make policy-dependent behavior explicit in parameters or decision-linked configuration, never hidden constants.
- [ ] Use the same validation and date semantics in models/controllers that the backend contract enforces.
- [ ] Update canonical file specs and decision records when a helper’s public API or policy changes.

## Completion criteria

- [ ] Boundary and malformed-input cases in the canonical spec are accounted for.
- [ ] No timezone, service-hours policy, or device-specific rule is asserted without an approved source.
- [ ] Sensitive values are redacted before reaching logs; errors remain typed and actionable.
- [ ] Acceptance scenarios in [the canonical spec](../../../docs/lib/core.md#pure-shared-utilities) are covered when test creation is authorized. This TODO does not itself authorize adding or running tests; follow [`AGENTS.md`](../../../AGENTS.md).
