# AI Coding Workflow

Use this workflow for each task, including documentation-only work. Keep updates concise and report meaningful findings while work is underway.

## 1. Orient before editing

1. Read root `AGENTS.md`, the task-relevant docs, the relevant `TODO.md`, and the target source files.
2. Inspect `git status --short`, current branch, and relevant diffs. Treat all pre-existing changes as user-owned. Identify the exact files the task will touch.
3. Confirm that the requested behavior belongs to this target and that required feature/data decisions exist. Distinguish existing behavior from planned behavior and prototype behavior.
4. Inspect package/platform versions and current architecture before suggesting dependencies or replacing code.
5. For a multi-file or risky task, send a short progress update naming scope and any material assumptions. Do not ask permission for routine reversible local edits already requested.

## 2. Define a concrete slice

Write a brief internal task plan with:

- user-visible outcome and in-scope behavior;
- exact source/docs/backend files likely to change;
- data read/write and authorization boundary;
- failure, empty, offline and retry behavior;
- acceptance criteria and checks authorized by the user/task;
- decisions that genuinely block implementation.

Prefer one end-to-end vertical slice over unrelated scaffolding. Do not create placeholder classes/files with no caller just to make the tree look complete. Avoid broad refactors during feature work. If a prerequisite decision is missing, continue any safe independent scaffolding, but do not implement the dependent data use/deployment path.

## 3. Implement in dependency order

For a data-backed feature, work in this order unless the existing architecture provides a sound reason otherwise:

1. Confirm fields, status transitions, retention, viewer/edit permissions and query requirements.
2. Define/update the typed model and record its serialization/validation test cases. Add tests only when the user explicitly authorizes test creation.
3. Define repository interface and typed filters/results.
4. Implement Firebase/platform adapter and repository mapping/cache behavior.
5. Add deny-by-default rules/indexes/trusted function behavior for every operation.
6. Add controller/view state and screen/widgets.
7. Define negative authorization and failure-state coverage; add test cases only when the user explicitly authorizes test creation.
8. Update file specifications, data dictionary/access matrix, README or decision record as needed.

For UI-only changes, reuse approved models and design tokens. For documentation, verify statements against current target source and label proposed decisions as proposals rather than facts.

## 4. Keep changes safe and reviewable

- Make the smallest complete change satisfying the acceptance criteria.
- Use dependency injection and existing patterns; explain any new dependency or architecture pattern.
- Validate inputs at boundaries and again in trusted backend code.
- Keep errors actionable without disclosing personal data or internals.
- Keep secrets and production data out of fixtures, logs, screenshots and diffs.
- Never suppress analyzer errors broadly, weaken rules to make tests pass, or claim authorization based on UI visibility.
- Do not alter generated files by hand. Regenerate with the documented tool and inspect output.
- Do not reformat or modify unrelated files. Do not stage or commit unless asked.

## 5. Verify only within authorization

Do not add or run tests unless the user explicitly asks to test or verify implementation. This applies even when a feature acceptance checklist mentions tests. If tests are a required completion condition but are not authorized, record that evidence as pending and do not claim the feature is fully verified. Existing CI may run its configured checks automatically; do not launch additional checks on your own. If the user requests verification:

1. Run the narrowest relevant formatter/analyzer/test/emulator command first.
2. Review failures to distinguish pre-existing issues from introduced issues.
3. Run broader checks relevant to the changed surface.
4. Do not deploy as a test. Use local emulators or approved staging only.
5. Record exact command, pass/fail, and any skipped check with reason.

If a build/test command may rewrite generated artifacts, inspect status immediately afterward and preserve the user's files. See [testing-and-review.md](testing-and-review.md).

## 6. Review before handoff

Before declaring complete:

- Review the entire diff, not only the primary source file.
- Check `git status` and ensure no unrelated user changes were staged, overwritten or removed.
- Check access control, PII/logging, stale caches, async disposal, duplicate/retry behavior and error states for the changed feature.
- Check documentation links and ensure behavior/contracts are described accurately.
- Confirm every acceptance criterion and report evidence. Mention unverified assumptions and release gates.

Do not say “production ready” merely because code compiles. Use the evidence gate in `docs/architecture/implementation-guide.md`.

## Blocked work protocol

If a decision blocks an action, state:

1. the exact missing decision or owner approval;
2. why it matters (e.g. personal-data field, production environment, retention, public release);
3. which implementation action depends on it;
4. what independent synthetic/local work was completed or can continue.

Do not convert elapsed time, silence, or prototype behavior into approval. Do not block unrelated safe work.

