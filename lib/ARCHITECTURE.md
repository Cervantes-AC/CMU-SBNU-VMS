# `lib/` Architecture

This is the planned source layout for `cmu_sbnu_vms`, aligned with [`docs/lib/index.md`](../docs/lib/index.md). Directories establish ownership; Dart files are added as their feature slice is implemented. An empty folder does not mean its feature is approved or complete.

```text
lib/
├── main.dart                         # Flutter entry point and safe bootstrap
├── app.dart                          # Root widget, dependency composition, router
├── firebase_options.dart             # FlutterFire generated; never hand-edit
├── core/
│   ├── cache/                         # Cache keys and user-scoped cache service
│   ├── connectivity/                 # Connectivity status adapter
│   ├── constants/                    # App config, route names, safe path builders
│   ├── error/                         # Typed app errors and SDK error mapping
│   ├── sync/                          # Only approved offline mutation workflows
│   ├── theme/                         # Theme tokens and persisted theme preference
│   └── utils/                         # Validation, dates, responsive helpers, logging
├── data/
│   ├── models/                        # Immutable domain models and serialization
│   ├── interfaces/                    # Typed repository contracts
│   ├── repositories/                  # Repository implementations/adapters
│   └── services/                      # Narrow Firebase/platform SDK wrappers
├── shared/
│   ├── result.dart                    # Typed success/failure result
│   ├── route_guard.dart               # Shared client route policy
│   ├── app_shell.dart                 # Authenticated navigation shell
│   ├── app_feedback.dart              # Safe user feedback mapping
│   ├── empty_state.dart               # Reusable empty state
│   ├── status_badge.dart              # Accessible status display
│   └── widgets/                       # Shared widgets with multiple callers
└── features/
    ├── auth/                          # Sign-in, reset, approved registration
    ├── dashboard/                     # Role-aware dashboards
    ├── profile/                       # Own-profile view and allowlisted edits
    ├── events/                        # Event browse and approved management
    ├── announcements/                 # Audience-filtered announcements
    ├── attendance/                    # Own history and authorized event roster
    ├── qr_duty_monitoring/             # Deferred; trusted QR duty workflow
    ├── incidents/                     # Deferred; sensitive incident workflows
    ├── emergency_hotlines/             # Owner-verified hotline directory
    ├── user_management/                # Deferred; trusted account review
    ├── audit_logs/                     # Authorized read-only audit view
    ├── analytics/                      # Approved bounded aggregate metrics
    ├── reports/                        # Approved report previews and exports
    ├── accomplishment_reports/         # Manual report drafting and review
    ├── import_export/                  # Deferred; separately approved tools
    ├── backup/                         # Deferred; trusted backup metadata only
    ├── database_management/            # Deferred; no arbitrary DB tools
    ├── admin_queries/                  # Deferred; no user-authored queries
    ├── data_controls/                  # Reusable typed table presentation
    ├── landing/                        # Public content only after approval
    ├── user_guide/                     # Role-filtered local help
    ├── settings/                       # Supported app/account preferences
    ├── warning_system/                 # Confirmation UI, no deletion policy
    └── pdf_generation/                 # Authorized report output adapter
```

## File placement rules

- Keep screens, controllers, and feature-specific widgets inside their owning `features/<name>/` directory.
- Keep cross-feature UI in `shared/` only after multiple unrelated features need it.
- Keep domain types and repository contracts under `data/models/` and `data/interfaces/`; Firebase SDK access belongs in `data/services/` and concrete repositories.
- Keep `main.dart` focused on startup. Keep root dependency composition and the single router in `app.dart`.
- Add only files listed in the relevant source specification or documented there before implementation. Do not add empty placeholder classes.
- Follow each module's implementation prerequisites in [`docs/lib/index.md`](../docs/lib/index.md), [`docs/lib/core.md`](../docs/lib/core.md), [`docs/lib/data.md`](../docs/lib/data.md), and [`docs/lib/features.md`](../docs/lib/features.md). Open decisions permit local synthetic work only; they do not approve production data or deployment.

## Suggested implementation order

1. Foundation: entry/bootstrap, core errors, constants, theme, shared result and feedback.
2. Identity: repository contracts, auth/session, route guard and access-denied states.
3. Daily operations: profile, events, announcements and role-aware dashboards.
4. Sensitive workflows: attendance, QR duty and incidents only after policy/backend gates close.
5. Oversight and administration: audit, analytics, reports and user management under their access contracts.
6. Separately gated capabilities: import/export, backup, database/query tools, public landing and PDF output.

This map describes intended ownership, not completion. The canonical contracts and owner decisions in `docs/` take precedence.
