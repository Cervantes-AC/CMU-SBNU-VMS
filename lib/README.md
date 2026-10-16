# Flutter client structure

The client follows a **modular monolith** organized around CMU–SBNU workflows. Its boundary rules and rationale are in [the project architecture decision](../docs/architecture.md). The landing page and local preview workspace are implemented; the preview uses synthetic data and does not imply institutional approval or a connected backend.

```text
lib/
├── main.dart
├── app.dart
├── firebase_options.dart
├── app/
│   ├── bootstrap/
│   ├── dependencies/
│   ├── routing/
│   └── theme/
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

Keep each feature folder small until its first implementation. A feature usually grows to `presentation/` (pages, ViewModels, widgets) and `data/` (repository, external data sources, and DTOs when needed). Add `application/` or `domain/` only when a feature has complex lifecycle rules, reusable policy, or cross-repository orchestration. Likely candidates are attendance/QR, incidents, SOS, and access control.

## Where shared code goes

- `app/` wires the app and owns navigation, environment setup, theme, and dependency composition.
- `core/` holds cross-cutting primitives and low-level platform adapters. Promote an adapter only when multiple features use it.
- `shared/presentation/` holds reusable UI without business rules. Keep feature-specific screens/widgets in their feature.
- Feature repositories own data and shared state, including the auth session. Feature sources own Firebase queries, callable contracts, and serialization.
- Do not create a generic `FirebaseService` or `AppService`. Keep one-feature integrations local, such as QR scanning in attendance and phone handoff in hotlines.
- Firestore Rules and trusted backend operations enforce access; route guards and UI visibility only guide navigation.

Use the existing Provider and GoRouter dependencies. The app uses GoRouter for landing/workspace routes and Provider with feature-owned ViewModels/repositories for activity, attendance, announcements, emergency incident previews, volunteer profiles, organizations, and reporting state. Other preview sections still hold presentation state locally and should move behind feature-owned view models/repositories as they gain behavior. Do not add another state-management or routing package without a demonstrated need. See [architecture.md](../docs/architecture.md) for the Firebase trust boundary, module dependencies, and implementation order.
