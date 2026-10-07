# Coding and Documentation Standards for AI Work

## Language and architecture

- Follow Dart formatting and the repository's `analysis_options.yaml`. Prefer explicit types at public APIs and immutable state/models.
- Use one state-management and routing approach for the app. Do not add a competing framework to avoid learning the existing composition.
- Use the file responsibilities in [`docs/lib/`](../lib/INDEX.md). Widgets render; controllers coordinate; repositories own data operations; services adapt SDKs; models validate data.
- Constructor-inject external dependencies. Avoid global mutable state and hidden Firebase access.
- Keep public methods small, named for business intent, and documented when behavior is not obvious. Use `async`/`await` with deliberate cancellation/disposal for streams.
- Prefer domain enums and typed filter/patch objects over stringly typed status fields or `Map<String,dynamic>` across feature boundaries.
- Keep UI responsive at the target breakpoints, support text scaling, keyboard/focus and semantic labels. Color is never the sole status indicator.

## Data and error handling

- Parse and validate at system boundaries. Distinguish absent, invalid, unauthorized, offline and unexpected outcomes.
- Use UTC instants for stored timestamps and explicit timezone policy for date-based reports and operational days.
- Paginate potentially growing collections. Bound files, strings, batch writes and report ranges.
- Make retryable mutations idempotent; use server timestamps and trusted actor identity for authoritative data.
- Give the user clear next steps without exposing SDK internals. Preserve diagnostics only through redacted logs.
- Dispose stream subscriptions, controllers, focus nodes, animation controllers, platform listeners and temporary files.

## Dependencies and generated files

- Add a dependency only when it directly supports an approved requirement and cannot be reasonably met with existing platform/framework APIs.
- Before adding, check maintenance, license, platform support, release size, security/update posture and transitive dependencies. Pin via normal manifest/lockfile workflows.
- Explain new cloud providers, permissions, network endpoints or personal-data flows in docs and configuration.
- Never hand-edit generated Firebase options, plugin registrants, platform registries, lock-derived output, or build artifacts. Use the documented generator and inspect the exact diff.

## Naming and file layout

- Use `snake_case.dart`; type names use `UpperCamelCase`; members use `lowerCamelCase`.
- One file should have one cohesive responsibility. Split large screens when sections have independent state or behavior; do not create one-file-per-trivial-widget without reuse/clarity benefit.
- Keep feature-specific components under `lib/features/<feature>/`; cross-feature widgets belong under `lib/shared/` only when genuinely shared.
- Avoid “utils”, “manager”, or “helper” files that become catch-alls. Use domain names.
- Remove obsolete TODO comments when a task is complete; keep remaining TODOs actionable and link their decision/ticket when known.

## Comments and docs

- Explain why a non-obvious invariant exists; do not narrate syntax.
- Keep API docs in sync with actual signatures and behavior. Mark proposals and unresolved policy explicitly.
- Never leave copied prototype package IDs, Firebase project IDs, stale feature claims or incorrect privacy statements in target docs.
- Do not document sample personal data or actual secrets. Use unmistakably synthetic values.

