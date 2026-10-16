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

Implement a feature only as its work begins. A typical implemented feature should grow into:

```text
features/<feature>/
├── presentation/
│   ├── pages/
│   ├── view_models/
│   └── widgets/
├── data/
│   ├── models/                             # transport DTOs/mappers where needed
│   ├── sources/                            # Firestore/Auth/callable/platform adapters
│   └── <feature>_repository.dart           # feature data API and implementation
├── domain/                                 # only for complex rules/contracts
└── application/                            # only for multi-step workflows
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
| Activity/attendance/announcement/etc. local state | Owning feature ViewModels/repositories | Partial; inventory and migrate remaining page-local state |
| `features/emergency` composite screen | Keep only navigation/page composition; domain code stays in incidents/SOS/hotlines | In place; verify boundaries |
| Shared forms/status/loading widgets | `shared/presentation/` | Add when repeated; no empty placeholder widgets |
| Typed failures/privacy-safe logging | `core/errors/`, `core/logging/` | Pending real backend integration |

## Staged migration checklist

- [x] Separate bootstrap, route configuration, theme, and provider composition from the root app widget.
- [x] Confirm static analysis and web build after this app-level migration.
- [ ] Confirm Android/iOS/desktop and other approved targets build as configuration/devices are available.
- [ ] Move feature pages into `presentation/pages/` only as each feature is next changed; update imports in the same change.
- [ ] Move Firebase DTOs/adapters into owning feature `data/models/` and `data/sources/` as backend integrations are implemented.
- [ ] Replace preview-only providers with environment-selected, feature-owned implementations and keep any demo implementation explicit.
- [ ] Move any remaining business state out of widgets into the owning ViewModel/repository.
- [ ] Add shared error/loading/empty widgets only after repeated UI patterns are identified.
- [ ] Remove obsolete empty directories/files after checking references and updating documentation.
- [ ] Review dependency direction and feature ownership before each feature is considered complete.

Do not perform a repository-wide bulk move solely to match this tree. Migrate one coherent slice at a time, preserve routes and behavior, then run formatting, static analysis, and the relevant platform build before committing.
