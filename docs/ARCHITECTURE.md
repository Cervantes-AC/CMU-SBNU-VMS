# Flutter Source Architecture

This document describes the source organization for `cmu_sbnu_vms`. Add files as features are implemented. Do not create placeholder code or implement every planned feature at once.

For file-level guidance on focused widgets, separation of responsibilities, and reusing existing components, see the [Flutter Coding Guide](FLUTTER_CODING_GUIDE.md).

## Principles

- Organize application code by feature so a feature's UI and data logic can be found together.
- Separate presentation from data access. Widgets render state and forward user actions; view models/controllers coordinate state; repositories own data access; services wrap Firebase or platform APIs.
- Start with views, view models, repositories, and services. Add domain/use-case classes only when business rules or workflows justify the extra layer.
- Keep shared code small. Move code to `shared/` or `core/` only when it is genuinely reused or cross-cutting.
- Keep authorization in backend rules and trusted operations. Client route guards improve navigation but do not secure data.

## Proposed structure

```text
lib/
  main.dart                    # Flutter bootstrap
  app.dart                     # Root widget and app-level composition
  firebase_options.dart        # FlutterFire generated; do not hand-edit
  core/                        # Cross-feature configuration, errors, theme
  shared/                      # UI and helpers reused across features
  features/
    auth/
      presentation/            # Sign-in UI and auth view model/controller
      data/                    # Auth repository and Firebase adapter
    profile/
      presentation/
      data/
    events/
      presentation/
      data/
    announcements/
      presentation/
      data/
    attendance/
      presentation/
      data/
```

The feature list above is illustrative, not a commitment to build those features. Add only the feature folders needed for approved work. A feature may contain a `domain/` folder for complex business rules, but simple screens and data operations do not need one.

## Responsibilities

- **`main.dart`:** initialize Flutter bindings when needed and start the application. Keep feature behavior out of this file.
- **`app.dart`:** configure the root app, theme, router, and dependency composition as those needs arise.
- **`features/<feature>/presentation/`:** screens, feature widgets, and a view model/controller for UI state and user actions.
- **`features/<feature>/data/`:** feature-owned repository contracts/implementations and data services. Keep raw Firebase SDK details behind these boundaries.
- **`features/<feature>/domain/` (optional):** reusable business rules or use cases when a feature's logic becomes complex.
- **`core/`:** genuinely cross-feature foundations such as configuration, typed errors, and app-wide theme tokens.
- **`shared/`:** presentation components reused by multiple unrelated features.

Keep feature models close to the feature that owns them. Promote a model or component to shared code only when there are real multiple callers and its meaning is consistent across them.

## Implementation sequence

1. Keep the starter app small while confirming the first approved workflow.
2. Add only the UI state and presentation needed for that workflow.
3. Define a typed repository boundary and a fake/local implementation where useful.
4. Add Firebase or other service adapters only after local configuration and access policy are reviewed.
5. Add more layers only when complexity requires them; test each layer with synthetic data and authorized local tooling.

## Project boundaries

- Firebase is not initialized by the current starter app. Firestore rules currently deny client access.
- Use synthetic data and local development. Do not access production data or deploy without explicit authorization.
- See [`Development plans`](Development/README.md) for area-by-area planning. The plan does not grant feature or deployment approval.
