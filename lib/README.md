# Flutter client structure

The client is being developed as a **working modular monolith** organized around CMU–SBNU workflows. Its requirements, boundary rules, target layout, and delivery status are in the [specification](../docs/specification/README.md), [architecture decision](../docs/architecture.md), [structure redesign](../docs/structure-redesign.md), and [development checklist](../docs/development-checklist.md). Some existing screens still use local synthetic data; those are incomplete development slices and must not be treated as production functionality.

```text
lib/
├── main.dart
├── app.dart
├── firebase_options.dart
├── app/
│   ├── bootstrap/app_bootstrap.dart
│   ├── dependencies/app_providers.dart
│   ├── routing/app_router.dart
│   └── theme/app_theme.dart
├── core/
│   ├── errors/
│   ├── logging/
│   ├── platform/                 # Shared low-level adapters, added when needed
│   └── types/                    # Stable cross-feature primitives, if needed
├── shared/
│   └── presentation/             # Common forms, loading/error states, widgets
└── features/
    ├── auth/                     # Identity and session
    ├── access_control/           # Account status, roles, scoped designations
    ├── organizations/            # Organization hierarchy and membership
    ├── volunteers/               # Profiles and roster
    ├── activities/               # Activities and participation
    ├── attendance/               # Attendance, corrections, QR
    ├── announcements/            # Audience-scoped communications
    ├── incidents/                # Incident reporting and review
    ├── sos/                      # Alert submission and responder workflow
    ├── hotlines/                 # Verified contacts and call handoff
    ├── reporting/                # Scoped analytics and export jobs
    └── audit/                    # Restricted audit review
```

Create feature subfolders when real code needs them. A simple feature can use `presentation/` (pages, ViewModels, widgets) and `data/` (repository, external data sources, and DTOs when needed). Add `application/` or `domain/` only for complex lifecycle rules, reusable policy, or cross-repository orchestration. Likely candidates are attendance/QR, incidents, SOS, and access control. Avoid empty scaffolding and migrate in small compiling steps.

## Where shared code goes

- `app/` wires the app and owns navigation, environment setup, theme, and dependency composition.
- `core/` holds cross-cutting primitives and low-level platform adapters. Promote an adapter only when multiple features use it.
- `shared/presentation/` holds reusable UI without business rules. Keep feature-specific screens/widgets in their feature.
- Feature repositories own data and shared state, including the auth session. Feature sources own Firebase queries, callable contracts, and serialization.
- Do not create a generic `FirebaseService` or `AppService`. Keep one-feature integrations local, such as QR scanning in attendance and phone handoff in hotlines.
- Firestore Rules and trusted backend operations enforce access; route guards and UI visibility only guide navigation.

Use the existing Provider and GoRouter dependencies. The app uses GoRouter for landing/workspace routes and Provider for feature ViewModels. Replace synthetic preview repositories with working, approved integrations as implementation proceeds; keep demo data explicit and clearly labeled. Do not add another state-management or routing package without a demonstrated need. See [architecture.md](../docs/architecture.md) for the Firebase trust boundary and [development-checklist.md](../docs/development-checklist.md) for outstanding work.
