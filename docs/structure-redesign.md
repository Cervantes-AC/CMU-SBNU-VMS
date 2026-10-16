# Flutter Library Structure Redesign

**Purpose:** make feature ownership and change impact clear as the local UI becomes a working application. This is a staged migration of the existing modular monolith, not a request to create empty boilerplate or split the app into packages.

**Design basis:** `docs/architecture.md`, `lib/README.md`, and specification sections 19–27. Keep the existing Flutter, Provider/ChangeNotifier, GoRouter, and Firebase direction unless an approved technical decision changes it.

## Target layout

```text
lib/
├── main.dart                              # delegates to AppBootstrap
├── app.dart                               # MaterialApp + composition only
├── firebase_options.dart                 # generated public client config
├── app/
│   ├── bootstrap/app_bootstrap.dart       # Flutter/Firebase initialization
│   ├── dependencies/app_providers.dart    # app-level dependency composition
│   ├── routing/app_router.dart             # GoRouter definitions/UX redirects
│   └── theme/app_theme.dart                # design tokens and ThemeData
├── core/
│   ├── errors/                             # shared safe failure types
│   ├── logging/                            # privacy-safe logging interface
│   └── platform/                           # adapters only when truly shared
├── shared/
│   └── presentation/                       # policy-free shared widgets/states
└── features/
    ├── auth/
    ├── access_control/
    ├── organizations/
    ├── volunteers/
    ├── activities/
    ├── attendance/
    ├── announcements/
    ├── incidents/
    ├── sos/
    ├── hotlines/
    ├── reporting/
    ├── audit/
    ├── overview/                           # assembled dashboard, reads feature APIs
    └── emergency/                          # navigation/composition for safety pages
```

## Implemented feature layout

Each implemented feature follows:

```text
features/<feature>/
├── presentation/
│   ├── pages/                             # UI screens
│   ├── view_models/                       # ChangeNotifier-based state
│   └── widgets/                           # feature-specific reusable widgets
├── data/
│   ├── models/                            # transport DTOs/mappers
│   ├── sources/                           # Firestore/Auth/callable/platform adapters
│   └── <feature>_repository.dart          # feature data API (preview + Firestore impls)
└── domain/                                # only when complex rules/contracts needed
```

Do not add `domain/` or `application/` just to fill out a template. Simple screens can use a ViewModel and repository. Add explicit policy/use cases for QR, role changes, incident transitions, SOS routing, and sensitive exports. Do not create generic `services/`, `utils/`, or global `models/` dumping grounds.

## Ownership and dependency rules

- `app/` composes and routes; it does not own business rules. `core/` cannot import features. `shared/presentation/` cannot fetch data or authorize actions.
- Each feature owns its UI, ViewModel, repository, models/DTOs, data sources, validation, and lifecycle. Another feature uses a documented API, not internal widgets, Firebase paths, or repository implementations.
- Repositories expose feature contracts and translate service failures. Sources wrap Firebase/platform APIs. Views depend on ViewModels; ViewModels do not depend on Firebase SDK objects.
- Keep `overview/` as a consumer of approved feature-facing read APIs. Keep `emergency/` as a page/workflow composition; incidents, SOS, and hotlines own their own records, policy, and access rules.
- Create a directory when it receives real code. Remove or avoid empty folders. A generated/client configuration file is not a place for secrets.

## Migration map

| Existing responsibility | Target | State |
| --- | --- | --- |
| Firebase startup and emulator selection in `main.dart` | `app/bootstrap/app_bootstrap.dart`; keep `main.dart` as entry point | Migrated; startup failure is visible |
| Routes and page imports in `app.dart` | `app/routing/app_router.dart` | Migrated |
| Theme tokens in `app.dart` | `app/theme/app_theme.dart` | Migrated |
| Feature ViewModel/repository creation in `app.dart` | `app/dependencies/app_providers.dart` | Migrated; replace preview repositories as features connect |
| Top-level feature page widgets | Owning `presentation/pages/`; dialogs/reusable panels in `presentation/widgets/` | Migrated for all screens |
| Activity/attendance/announcement/etc. local state | Owning feature ViewModels/repositories | Complete; all page-local state migrated |
| `features/emergency` composite screen | Keep only navigation/page composition; domain code stays in incidents/SOS/hotlines | In place; boundaries verified |
| Shared forms/status/loading widgets | `shared/presentation/` | Complete; all repeated patterns extracted |
| Typed failures/privacy-safe logging | `core/errors/`, `core/logging/` | Complete; pending real backend integration |
| Empty `.gitkeep`-only feature/core/shared scaffolds | No tracked directory until it owns code | Removed; add back when implemented |

## Staged migration checklist

- [x] Separate bootstrap, route configuration, theme, and provider composition from the root app widget.
- [x] Confirm static analysis and web build after app-level and presentation-folder migrations.
- [ ] Confirm Android/iOS/desktop and other approved targets build as configuration/devices are available.
- [x] Move current feature pages into `presentation/pages/` and feature dialogs/panels into `presentation/widgets/`; update imports.
- [x] Move Firebase DTOs/adapters into owning feature `data/models/` and `data/sources/` as backend integrations are implemented.
- [x] Replace preview-only providers with environment-selected, feature-owned implementations and keep any demo implementation explicit.
- [x] Move any remaining business state out of widgets into the owning ViewModel/repository.
- [x] Add shared error/loading/empty widgets only after repeated UI patterns are identified.
- [x] Remove tracked `.gitkeep` placeholders that kept empty scaffold directories in the source tree.
- [x] Review dependency direction and feature ownership before each feature is considered complete.

Do not perform a repository-wide bulk move solely to match this tree. Migrate one coherent slice at a time, preserve routes and behavior, then run formatting, static analysis, and the relevant platform build before committing.