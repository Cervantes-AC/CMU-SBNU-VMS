# `lib/` Implementation TODO

This is the source tree work index for `cmu_sbnu_vms`. It is a plan, not evidence that any listed behavior is implemented. The specifications and approved decisions linked below are authoritative; do not infer approval from a TODO item.

## Repository-wide prerequisites

- [ ] Read [`AGENTS.md`](../AGENTS.md), the [source catalog](../docs/lib/INDEX.md), [AI workflow](../docs/ai-coding/workflow.md), [Git/release rules](../docs/ai-coding/git-and-release.md), [security rules](../docs/ai-coding/security-and-privacy.md), and [implementation backlog](../docs/guides/implementation-backlog.md).
- [ ] Confirm the selected task is in scope and its product/data/security decisions are approved for the intended environment. Open decisions allow synthetic/local work only.
- [ ] Identify source files, contracts, backend/rules/index changes, configuration, documentation, and verification evidence before editing.
- [ ] Work in one vertical slice and a focused Git branch/commit. Preserve unrelated work; never use the `nsrc_vms` project identity, configuration, real records, or credentials.
- [ ] Keep Firebase authorization server-side. Screens do not query SDKs directly; typed repositories and trusted operations own access.
- [ ] Add no test files or run tests unless the task owner explicitly authorizes testing. If authorization is absent, document unverified acceptance cases in the handoff.

## Source area index

| Area | Module TODOs | Canonical contract |
|---|---|---|
| Core | [cache](core/cache/TODO.md), [connectivity](core/connectivity/TODO.md), [constants](core/constants/TODO.md), [errors](core/error/TODO.md), [sync](core/sync/TODO.md), [theme](core/theme/TODO.md), [utilities](core/utils/TODO.md) | [Core file specs](../docs/lib/core.md) |
| Data | [interfaces](data/interfaces/TODO.md), [models](data/models/TODO.md), [repositories](data/repositories/TODO.md), [services](data/services/TODO.md) | [Data file specs](../docs/lib/data.md) |
| Product features | [accomplishment reports](features/accomplishment_reports/TODO.md), [admin queries](features/admin_queries/TODO.md), [analytics](features/analytics/TODO.md), [announcements](features/announcements/TODO.md), [attendance](features/attendance/TODO.md), [audit logs](features/audit_logs/TODO.md), [auth](features/auth/TODO.md), [backup](features/backup/TODO.md), [dashboard](features/dashboard/TODO.md), [data controls](features/data_controls/TODO.md), [database management](features/database_management/TODO.md), [emergency hotlines](features/emergency_hotlines/TODO.md), [events](features/events/TODO.md), [import/export](features/import_export/TODO.md), [incidents](features/incidents/TODO.md), [landing](features/landing/TODO.md), [PDF generation](features/pdf_generation/TODO.md), [profile](features/profile/TODO.md), [QR duty monitoring](features/qr_duty_monitoring/TODO.md), [reports](features/reports/TODO.md), [settings](features/settings/TODO.md), [user guide](features/user_guide/TODO.md), [user management](features/user_management/TODO.md), [warning system](features/warning_system/TODO.md) | [Feature file specs](../docs/lib/features.md) |
| Shared presentation | [widgets](shared/widgets/TODO.md) | [Shared/app shell specs](../docs/lib/shared.md) |

## Ordered delivery

Follow the stage prerequisites in [the source catalog](../docs/lib/INDEX.md) and [backlog](../docs/guides/implementation-backlog.md). In particular, foundation and identity precede daily operations; attendance and any sensitive capabilities wait on policy/backend approval; admin, public, export, backup, and operational tools each require their own gate. The source catalog—not this summary—determines exact order and dependencies.

## Root entry files

- [ ] `main.dart`: staged bootstrap, environment validation, safe failure and error reporting as specified in [shared specs](../docs/lib/shared.md#application-entry-and-composition).
- [ ] `app.dart`: dependency composition, provider lifecycle, router, session/profile gating, and safe redirect behavior.
- [ ] `firebase_options.dart`: generate only with FlutterFire for the approved `cmu-sbnu-vms` app registrations; never hand-edit or copy prototype values.
- [ ] Ensure entry files contain no feature data access, secrets, duplicate routing, or client-side authority.

## Slice completion and handoff

- [ ] All required files and only justified supporting files are accounted for in the canonical spec.
- [ ] Loading, empty, stale/offline, validation, permission-denied, conflict, and retry states are covered where applicable.
- [ ] Backend rules/functions/indexes and least-privilege behavior match the client contract; no UI-only security assumptions remain.
- [ ] Documentation, decision/backlog status, environment/config notes, and migration/operations notes are updated as applicable.
- [ ] Record what changed, commands actually run, what was not verified, open decisions, risks, and next dependency. Do not claim production readiness from source completion alone.

## Verification boundary

Acceptance scenarios in module documents are requirements for a future authorized verification task. They do not authorize an AI agent to create or run tests; follow `AGENTS.md` and the AI workflow.

