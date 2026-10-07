# AI Coding Playbook

This playbook defines how AI coding agents work in `cmu_sbnu_vms` so implementation stays reviewable, secure, traceable and consistent. Root [`AGENTS.md`](../../AGENTS.md) is the short mandatory entry point; this folder contains the complete operating procedure.

## Read by task type

| Task | Read |
|---|---|
| Any code or documentation change | [Workflow](workflow.md), [Coding standards](coding-standards.md), and root `AGENTS.md` |
| Git branch, commit or release preparation | [Git and release](git-and-release.md) |
| Feature implementation | [Workflow](workflow.md), [file specs](../lib/index.md), [security and privacy](security-and-privacy.md), [testing and review](testing-and-review.md) |
| Firebase rules/functions/data model | [Security and privacy](security-and-privacy.md), [testing and review](testing-and-review.md), and relevant `docs/lib/data.md` section |
| UI-only work | [Coding standards](coding-standards.md), [testing and review](testing-and-review.md), and feature file specification |
| Release or deployment | [Git and release](git-and-release.md), [testing and review](testing-and-review.md), [implementation guide](../architecture/implementation-guide.md) release gates |

## Source-of-truth order

When instructions disagree, use this order:

1. Current explicit user instruction, within system/developer constraints.
2. Approved product, security, privacy and environment decisions for this target repository.
3. Root `AGENTS.md` and this playbook.
4. [`docs/architecture/implementation-guide.md`](../architecture/implementation-guide.md) and [`docs/lib/`](../lib/index.md) contracts.
5. Target code and tests, which may contain defects and do not silently override approved policy.
6. `D:\nsrc_vms` prototype. It is reference material only; it has no authority over target identity, security or requirements.

If a referenced approval/decision file is absent, stale or contradictory, do not invent its content. Implement independent work using synthetic data and mark the dependent behavior blocked pending the named owner decision.

## Required lifecycle

Every implementation task follows: **orient → define → plan → implement → verify (when authorized) → review diff → update docs → hand off**. Details and completion templates are in [workflow.md](workflow.md). Git discipline is in [git-and-release.md](git-and-release.md); coding conventions in [coding-standards.md](coding-standards.md); privacy boundaries in [security-and-privacy.md](security-and-privacy.md); and evidence expectations in [testing-and-review.md](testing-and-review.md).

## Templates

- [Task brief](task-template.md): scope and acceptance criteria before implementation.
- [Change handoff](handoff-template.md): concise, evidence-based completion report.
