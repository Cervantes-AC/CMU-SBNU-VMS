# Development Workflow

This workflow describes how to take a project change from request to review. Follow the area-specific plans in [`Development/`](Development/README.md), the source rules in [`ARCHITECTURE.md`](ARCHITECTURE.md), and the Git procedures in [`git-version-control.md`](git-version-control.md).

## 1. Select and define the work

- Choose one focused task or one small end-to-end feature slice.
- Check its area and current status in the development plans.
- Write down the user-visible result and clear completion conditions.
- Identify data, privacy, authorization, or owner decisions the task depends on.
- Do not treat a roadmap item as feature approval.

## 2. Check the project before editing

- Confirm the repository root, branch, and current worktree status.
- Read the relevant source, architecture, and policy documentation.
- Inspect existing changes in files that may be touched; preserve unrelated work.
- Confirm that required tools and local configuration exist. Do not assume Firebase emulators or cloud services are available.

## 3. Resolve prerequisites

- Use synthetic data and local development by default.
- Pause dependent implementation when approved scope, data fields, access rules, or retention policy are unclear.
- Use synthetic data and approved project configuration. Never reuse credentials or backend configuration from an unapproved source.
- Keep secrets out of source control and never put privileged credentials in the Flutter client.

## 4. Implement a focused slice

- Make the smallest change that meets the completion conditions.
- Follow the feature-first layout in `docs/ARCHITECTURE.md`; add source files only when needed.
- Keep widgets focused on presentation and user input. Put UI state in a view model/controller, data access in repositories, and SDK calls behind services.
- Add a domain/use-case layer only when the feature's business rules justify it.
- Enforce authorization in trusted backend rules or operations. Client navigation is not a security boundary.
- Update relevant documentation when behavior, structure, or status changes.

## 5. Verify when requested

- Agree on which verification is needed for the change.
- Run only authorized checks and report the exact commands and outcomes.
- Use synthetic fixtures and local emulators when configured; never use production member or incident data as test data.
- Do not claim tests, analysis, or builds ran when they did not.

## 6. Review and hand off

- Review the intended diff for correctness, accidental changes, secrets, and generated files.
- Use `git diff --check` for whitespace review when appropriate.
- Report what changed, files affected, checks run, and any unresolved decision or limitation.
- Do not stage or commit unless asked. Do not push, merge, publish, or deploy without explicit authorization.

## 7. Release work

- Release preparation begins only after owners approve the platform, environment, data use, and operational responsibilities.
- Review security rules, secret handling, privacy requirements, rollback, and monitoring for the named target.
- Deployment requires explicit authorization for that environment and action. A local build does not establish production readiness.
