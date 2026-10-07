# Verification, Testing, and Review Rules

Tests and checks provide evidence for a specific behavior; they do not alone establish production readiness.

## Authorization to run checks

Follow root `AGENTS.md`: do not add or run tests unless the user explicitly asks to test or verify implementation. A task that mentions acceptance coverage does not, by itself, authorize test creation. Existing CI may run configured checks automatically; the agent must not launch extra checks on its own. Never run deployment, production smoke tests, data migration or destructive integration test as an assumed “verification” step.

## Check selection

| Change | Appropriate checks when authorized |
|---|---|
| Pure model/utility | focused unit tests, `dart format`, `flutter analyze` |
| Widget/layout | focused widget tests and supported viewport checks |
| Repository/service | unit tests with fakes plus emulator integration for query/write semantics |
| Firestore/Storage rules or indexes | Firebase Emulator Suite tests for allowed and denied operations, followed by query/index checks |
| Cloud Functions | lint/typecheck/unit tests, emulator auth/authorization/idempotency tests |
| Platform permissions/config | clean build for affected platform and manual permission/denial path review |
| Full release candidate | CI format/analyze/test, emulator suite, supported release builds, dependency/security scan, staging smoke and restore/rollback evidence |
| Documentation | link/path check and review statements against target source; no application test is needed |

Run narrow checks first. Broaden only as requested/required by the task. Report exact commands and exit result. Do not claim an emulator, platform or browser was exercised if it was not.

## Test quality requirements

- Test behavior and policy invariants, not implementation trivia or widget existence.
- Include normal, boundary, malformed, permission-denied, network failure, retry/duplicate and lifecycle cases appropriate to the feature.
- For access-controlled data, test anonymous, pending/disabled, each role, owner, other user, unknown role/profile and privileged action cases.
- Keep tests deterministic: injected clock, IDs, repository fakes and platform adapters. Do not call live production services.
- Use synthetic fixtures with clearly fake identities and contact data.
- Keep rules tests separate from mock repository tests. Mocks cannot prove server authorization.
- Avoid tests asserting private implementation details that make safe refactors prohibitively costly.

## Review checklist

Reviewers/agents inspect:

1. Acceptance criteria met and no unrelated scope added.
2. File contracts, architecture and docs remain accurate.
3. UI states: first load, empty, failure, retry, stale/offline, permissions denied, success and cancellation.
4. Security: authorization is enforced server-side; fields/queries/exports are allowlisted; sensitive content is absent from logs/caches/notifications.
5. Data: validation, idempotency, timestamp, pagination, retention and schema compatibility are sound.
6. Resources: subscriptions/controllers/files disposed; duplicate async actions prevented.
7. Tests/checks are relevant, deterministic and actually run when required.
8. Build/config changes are target-specific and generated files are generated rather than hand-edited.
9. No credentials, personal data, build artifacts or unexplained dependency changes entered the diff.

## Failure reporting

When a check fails, include exact command, concise relevant output, whether the issue predates the change, and next action. Do not hide failing commands, modify the test to encode insecure behavior, or report only successful subsets. If unable to run due to missing tooling or environment, identify that limitation and give the command that should be run in CI/developer setup.

