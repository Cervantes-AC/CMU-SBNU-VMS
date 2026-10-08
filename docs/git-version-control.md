# Git Version Control Guide

Use this guide to keep changes focused and protect existing work in `cmu_sbnu_vms`.

## Before editing

1. Confirm you are in the target repository and inspect the branch and worktree:

   ```powershell
   git status --short --branch
   git log -5 --oneline
   ```

2. Inspect diffs for files you plan to change. Treat existing edits, deletions, and untracked files as user-owned unless the user explicitly includes them in the task.
3. Keep one task per change set. Follow the team's branch policy when one is provided; do not guess a branch or create one if the workflow is unclear.

## While working

- Make small, reviewable changes. Do not reformat or revert unrelated files.
- Do not use `git reset --hard`, `git clean`, or file checkout/restore commands to discard working changes.
- If you find an unrelated change, leave it untouched and mention it in your handoff.
- Never add secrets, service-account files, `.env` files, real member data, or private incident information. The repository ignore rules cover `.env*`, `service-account.json`, and `node_modules/`; verify files are ignored before staging sensitive local configuration.
- Use synthetic data and approved project configuration. Do not add unapproved source snapshots, credentials, or backend configuration to the application.

## Review before staging

Review only the intended paths:

```powershell
git status --short
git diff -- path/to/file
git diff --check
```

Look for accidental generated output, secrets, unrelated edits, and missing documentation updates. A clean whitespace check does not replace code review or authorized tests.

## Stage and commit

- Stage only after the user explicitly asks for a commit or staging operation.
- Add exact paths; do not use `git add .` or `git add -A` in this shared worktree.

  ```powershell
  git add -- docs/git-version-control.md README.md
  git diff --cached --check
  git diff --cached
  ```

- Verify the staged diff contains only the intended change before committing.
- Use a short, imperative message that describes the change. Follow an established team format if one is supplied.
- A local commit does not authorize push, merge, tag, publication, or deployment. Each remote or release action requires explicit authorization.

## Undoing mistakes safely

- To unstage a path while keeping its edits, use `git restore --staged -- path/to/file`.
- Before restoring or deleting any working file, inspect its diff and confirm the user authorized discarding it. Do not overwrite user work to make the tree look clean.
- If a merge/rebase conflict appears, inspect both sides and resolve the specific conflict. Do not select an entire side without reviewing its contents.

## Handoff

Report the branch, files changed, exact commands run, results, and any remaining work. State clearly if tests, analyzer checks, staging, or commit were not performed. Follow `AGENTS.md`: do not add or run tests unless the user explicitly asks to test or verify implementation.
