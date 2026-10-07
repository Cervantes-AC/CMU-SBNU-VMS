# Git, Version Control, and Release Procedure

These rules protect user work and make every change reviewable. Unless the user explicitly requests version-control operations, agents may inspect and edit local files but must not stage, commit, push, merge, tag, publish, or deploy.

## Repository identity and branch selection

- At task start, run `git status --short --branch` and inspect the current branch and diff. Do not assume the branch name or that the checkout is clean.
- Use the repository's configured integration branch as the base. If unclear, inspect local/remote branch configuration or ask the user; do not create a new long-lived branch by guessing.
- Work on an isolated task branch when the user/team workflow requires one. The target README's suggested pattern is `T-xx-short-purpose`; follow the actual task ID and repository convention where available.
- Never work directly on a release branch when the repository requires feature branches.
- Do not run `git reset --hard`, `git clean`, `git checkout -- <path>`, force-push, or destructive history edits to “clean up” a workspace. These can destroy user work.

## Protect existing changes

Before editing, capture mentally or in notes which changes were already present. During the task:

- Modify only files in the requested scope.
- Never stage all files with `git add .` or `git add -A` in a shared/untrusted worktree.
- Stage explicit paths only after reviewing each file and only when commit/push was requested.
- If an unrelated change appears, leave it untouched and mention it in handoff.
- If a tool formats generated or broad files, inspect the full status/diff and restore nothing automatically. Ask before any operation that could overwrite user changes.
- Do not rewrite another person's commit or amend shared history.

## Branch and change shape

One branch/commit series should address one coherent task. Keep changes small enough for a reviewer to understand. Split unrelated fixes. Avoid committing generated build output, local config, `.env`, SDK caches, IDE state or binaries unless a specific tracked asset is approved.

Suggested branch form (adapt to repository convention):

```text
T-123-short-imperative-description
```

Use an imperative, scoped commit subject with a stable type:

```text
feat(events): add paginated event list
fix(auth): reject disabled account sessions
docs(ai-coding): document safe git workflow
test(attendance): cover duplicate check-in
refactor(core): isolate date range parsing
```

Allowed types: `feat`, `fix`, `docs`, `test`, `refactor`, `build`, `ci`, `chore`, `security`. Subject should describe the result, not claim readiness. Add a body for user-visible behavior, data/rule changes, migration implications, security considerations, and verification evidence. Do not include secrets or personal data in messages.

## Git procedure when commits are authorized

1. Confirm the user explicitly authorized a commit (and whether push is also authorized).
2. Inspect branch and status; review diffs and untracked files.
3. Run only the requested/required checks and record outcomes.
4. Stage exact intended files: `git add -- path/to/file ...`.
5. Inspect `git diff --cached --check` and `git diff --cached`.
6. Confirm staged changes exclude credentials, local settings, unrelated work, generated caches and real data.
7. Commit using the repository subject format. A successful local commit does not authorize push.
8. If push was separately authorized, verify remote and branch, then push the exact branch. Never force push unless explicitly required and the user understands the history impact.
9. Report commit ID, branch, checks and push status accurately.

## Merge and conflict handling

- Do not merge or rebase unless asked or the repository workflow clearly delegates it.
- Before rebase/merge, inspect the working tree; it must not contain unprotected changes.
- Resolve conflicts by understanding both sides and preserving intentional behavior. Never choose “ours” or “theirs” for entire files without reviewing semantics.
- Re-run applicable checks after conflict resolution when authorized and inspect the complete diff.
- Do not remove a file merely because it was deleted in one branch; verify ownership and expected behavior.

## Versioning and changelog

- Keep `pubspec.yaml` version/build number aligned with the release policy. Do not bump version for ordinary local edits unless asked or a release task requires it.
- Use semantic versioning for public app releases when the product owner adopts it: major for incompatible user/data behavior, minor for backward-compatible features, patch for compatible fixes. Mobile build numbers must increase monotonically per store/environment.
- Record user-visible changes, migrations, data/rules changes and known limitations in the project changelog/release notes if one is adopted. Do not invent a changelog file as a substitute for approved release process.
- A Firestore schema/rules change must include rollout order, backward compatibility, index deployment and rollback notes.

## Release and deployment controls

Deployment is a separate, high-impact action. Before production deployment, require explicit authorization, named target project/hosting site, approved release artifact/commit, owner approval, successful staging checks, backup/recovery status and rollback procedure. Select Firebase aliases explicitly; verify the resolved project ID before any deploy command. Never rely on the Firebase CLI default project.

Production steps, in order:

1. Confirm release scope, app version/build, commit SHA, project owners and approval evidence.
2. Build the exact candidate from a clean CI checkout with locked dependencies.
3. Deploy rules/indexes/functions to staging and run security and smoke tests.
4. Review rule/function diff, index status, IAM, environment identifiers and privacy declarations.
5. Verify backup/restore and rollback plans appropriate to the change.
6. Obtain explicit production deployment authorization if not already granted.
7. Deploy with an authorized identity and explicit project/site. Deploy backend protections before clients that depend on them.
8. Run post-deploy health checks; monitor errors, auth denials, delivery, quota and cost.
9. Roll back by the documented procedure if health checks fail; never weaken authorization as a rapid fix.
10. Record artifact, environment, operator, time, outcome and any incident.

Do not store signing certificates, Apple credentials, Google Play keys, service-account JSON or deploy tokens in Git. Use the approved secret store/CI identity and least privilege.

