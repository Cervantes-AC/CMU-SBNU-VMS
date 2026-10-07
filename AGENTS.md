# Instructions for AI coding agents

This repository is the project of record for `cmu_sbnu_vms`. Before editing, read:

1. [`README.md`](README.md) for project identity, current state and approved setup.
2. [`docs/index.md`](docs/index.md) for the current authoritative document map.
3. [`docs/overview/product-requirements.md`](docs/overview/product-requirements.md) and [`docs/overview/decision-register.md`](docs/overview/decision-register.md) for scope and owner gates.
4. [`docs/architecture/implementation-guide.md`](docs/architecture/implementation-guide.md), [`docs/architecture/backend-contracts.md`](docs/architecture/backend-contracts.md) and [`docs/architecture/data-and-access.md`](docs/architecture/data-and-access.md) for architecture and data operations.
5. [`docs/lib/index.md`](docs/lib/index.md) and the relevant linked file specifications before changing `lib/`.
6. [`docs/ai-coding/index.md`](docs/ai-coding/index.md) for workflow, Git, review, verification and handoff rules.
7. Relevant feature `TODO.md` and approved decision/requirements records. A missing or unresolved approval is not permission to infer a production policy.

## Project identity and safety rules

- Use only target identity/configuration from this repository. Never use the `D:\nsrc_vms` Firebase project, credentials, production data, seed data or configuration. The reference app is design input only.
- Do not commit credentials, tokens, service-account keys, real volunteer data, personal incident data, or unapproved institutional assets.
- Use synthetic fixtures and Firebase emulators for development. Do not access or modify production data or deploy to a cloud environment unless the task explicitly authorizes that operation.
- Do not implement impersonation, arbitrary database writes/queries, bulk personal-data export, restore, public incident maps, background location tracking, or client-held privileged keys without an approved requirement and threat-model decision.
- Backend rules/functions enforce authorization. A hidden button or guarded route is never sufficient security.
- Preserve existing user changes. Inspect `git status` and diffs before editing; never discard, overwrite, stage, or commit unrelated changes.

## Work rules

- Follow [`docs/ai-coding/workflow.md`](docs/ai-coding/workflow.md) for every task and [`docs/ai-coding/git-and-release.md`](docs/ai-coding/git-and-release.md) for version control.
- Work in small vertical slices. Read the file specification before designing source changes; update documentation when implementation changes a contract.
- Do not add or run tests unless the user explicitly asks to test or verify implementation. Existing CI may run its configured checks automatically; do not launch additional checks on your own.
- Never claim a check, review, deployment, or completion that did not happen. State commands and outcomes exactly.
- Do not push, publish, merge, deploy, contact another person, or modify external systems unless explicitly authorized in the active session.
- Ask the user only for decisions that block safe implementation. Continue independent work while clarifying; explain the exact missing decision and the dependent operation.

