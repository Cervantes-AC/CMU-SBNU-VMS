# CMU SBNU VMS Documentation Index

This folder contains the implementation and operating documentation for the target repository `cmu_sbnu_vms`. The **root [`README.md`](../README.md) is the only root README**. Start here for the authoritative map; start at root [`AGENTS.md`](../AGENTS.md) when using an AI coding agent.

## Authority & Structure

1. **Overview & Product Scope:** [`overview/`](overview/index.md)
   - [Product Requirements](overview/product-requirements.md)
   - [Decision Register](overview/decision-register.md)
   - [About / Prototype Reference](overview/about.md)
2. **Architecture & Contracts:** [`architecture/`](architecture/index.md)
   - [Implementation Guide](architecture/implementation-guide.md)
   - [Data and Access Contract](architecture/data-and-access.md)
   - [Backend Contracts](architecture/backend-contracts.md)
   - [UI and Routes Contract](architecture/ui-and-routes.md)
3. **Guides & Workflow:** [`guides/`](guides/index.md)
   - [Environment Setup](guides/environment-setup.md)
   - [Development Readiness Checklist](guides/development-checklist.md)
   - [Implementation Backlog](guides/implementation-backlog.md)
   - [Operations Runbook](guides/operations-runbook.md)
   - [Test Plan and CI](guides/test-plan-and-ci.md)
4. **Source Code Specifications:** [`lib/`](lib/index.md)
   - [Core Architecture](lib/core.md)
   - [Data Models & Repositories](lib/data.md)
   - [Shared Shell & Components](lib/shared.md)
   - [Feature Specifications](lib/features.md)
5. **AI Coding Playbook:** [`ai-coding/`](ai-coding/index.md)
   - [AI Coding Workflow](ai-coding/workflow.md)
   - [Coding Standards](ai-coding/coding-standards.md)
   - [Git and Release Rules](ai-coding/git-and-release.md)
   - [Security and Privacy](ai-coding/security-and-privacy.md)
   - [Testing and Review](ai-coding/testing-and-review.md)
   - Templates: [Task Template](ai-coding/task-template.md) | [Handoff Template](ai-coding/handoff-template.md)

If a decision is `OPEN`, use the documented safe default for local/synthetic implementation only. Do not use real personal data, production infrastructure, publish institutional content, or release until required approvers record acceptance.

## Read by Task

| Task / Goal | Documents |
|---|---|
| Understand product scope and acceptance | [Product requirements](overview/product-requirements.md) → [Decision register](overview/decision-register.md) |
| Implement Flutter source | [Implementation guide](architecture/implementation-guide.md) → [lib file specifications](lib/index.md) → [AI coding workflow](ai-coding/index.md) |
| Design a schema or permission | [Data and access contract](architecture/data-and-access.md) → [Security/privacy rules](ai-coding/security-and-privacy.md) → [Test plan](guides/test-plan-and-ci.md) |
| Implement a privileged backend operation | [Trusted backend contracts](architecture/backend-contracts.md) → [Data and access contract](architecture/data-and-access.md) → [Test plan](guides/test-plan-and-ci.md) |
| Set up locally | [Environment setup](guides/environment-setup.md) |
| Verify development readiness | [Development checklist](guides/development-checklist.md) |
| Pick the next task | [Implementation backlog](guides/implementation-backlog.md) |
| Prepare CI/release | [Test plan and CI](guides/test-plan-and-ci.md) → [Operations runbook](guides/operations-runbook.md) → [Git/release rules](ai-coding/git-and-release.md) |
| Review prototype ideas | [Prototype reference note](overview/about.md), then verify against target requirements |

## Document Maintenance

Every behavior or contract change updates the relevant requirement, decision, data/access, route/file specification, backlog status and test plan. Each page states whether a requirement is **approved**, **proposed**, **open**, or **deferred**. Only the designated product/data/security owners can change an approval state; an AI agent records evidence but does not self-approve.
