# TODO: profile

**Status:** Profile screen, ProfileController, UserRepository interface/impl implemented. ProfileController coordinates loading/updating against UserRepository; enforces self-editable field allowlist and optimistic concurrency. UserRepository provides watchProfile, getProfile, updateOwnProfile, updateProfileAdmin, and searchMembers. Follow the repository rules and the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This is the `features/profile/TODO.md` module. Its detailed file-by-file contract is in [the canonical specification](../../../docs/lib/features.md). The [implementation backlog](../../../docs/guides/implementation-backlog.md), [decision register](../../../docs/overview/decision-register.md), [data/access contract](../../../docs/architecture/data-and-access.md), and [backend contracts](../../../docs/architecture/backend-contracts.md) govern sequencing, approval, data and trusted operations. Resolve mismatches by updating the canonical contract and decision record before implementation; do not invent APIs silently.

## Approval and safety gate

Edit only approved self-service fields. Role, status, UID, email authority, and computed hours are not ordinary profile fields.

Identify each relevant requirement as approved, proposed, open, or deferred before coding. Open decisions permit local synthetic work only. Never use real personal data or production credentials in development. Client checks are not authorization; privileged behavior requires documented backend operations and server enforcement.

## Canonical file-level contract

### `lib/features/profile/`

**Files:** `profile_screen.dart`, `profile_controller.dart`, `profile_edit_form.dart`, optional `profile_avatar.dart` (only if approved avatar upload is implemented).

**Controller API:** `load(uid)`, `save(ProfilePatch)`, optional `selectAvatar()`/`uploadAvatar()` only after storage provider/privacy approved. Form fields derive from approved `UserProfile` field allowlist. Exclude role/status/UID/email changes unless explicitly authorized workflow. On save, refresh current session profile and invalidate cache.

**Tests:** self-only profile, allowlisted fields, disallowed-field rejection, partial failure, avatar cancellation/size/type if supported, signed-out cache clear.

## Implementation checklist

- [ ] Confirm backlog stage and dependencies. If a prerequisite contract is missing, scope that work explicitly before building dependent UI.
- [ ] Create the named files and only justified local helpers. Preserve specified public APIs, file responsibilities, route names, domain invariants, and view-state behavior.
- [ ] Inject dependencies. Keep presentation, orchestration, domain policy, persistence, and SDK/platform adapters separated; avoid hidden global clients.
- [ ] Handle validation, persisted-data parsing, bounded pagination, retries/idempotency, and relevant loading, empty, stale/offline, failure, permission-denied, and conflict states.
- [ ] Enforce record and role scope in backend/rules as well as UI affordances. Derive actor identity and privileged values on the trusted side.
- [ ] Redact personal/sensitive data from logs, errors, analytics labels, cache, exports, URLs, and serialized payloads. Clear user-scoped state at sign-out/revocation where applicable.
- [ ] Update related data, route, backend, environment, operations, and backlog documentation when contracts or dependencies change. Record unresolved decisions.

## Acceptance and handoff

- [ ] All required files meet their specified responsibilities; no undeclared privileged behavior was added.
- [ ] Routes and repositories use the intended access policy; backend denial remains authoritative.
- [ ] Canonical boundary, retry, concurrency/idempotency, failure, and unauthorized-access scenarios are accounted for.
- [ ] Handoff states changed files, actual verification performed, unverified acceptance cases, configuration/migration needs, open decisions, and limitations.

**Verification rule:** Scenarios here and in canonical specifications describe future required evidence. They do not authorize adding or running tests. Follow [`AGENTS.md`](../../../AGENTS.md) and [testing/review guidance](../../../docs/ai-coding/testing-and-review.md).


