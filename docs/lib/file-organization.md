# Organizing Flutter source files

Use this guide when adding or refactoring files under `lib/`. The goal is to keep each file readable and give every component an obvious owner without splitting code into tiny, hard-to-follow fragments.

## Ownership and placement

- Keep a screen, its screen-specific sections, and its private widgets inside `lib/features/<feature>/`.
- Put feature-specific reusable UI in that feature's `widgets/` or clearly named subfolder such as `parts/`.
- Put a widget in `lib/shared/` only when it is genuinely used by multiple unrelated features and has no feature-specific policy or data ownership.
- Keep application-wide routing and composition in `app.dart`; keep feature behavior out of the composition root.
- Keep one cohesive responsibility per file. Use `snake_case.dart` names that describe the component, such as `landing_hero.dart` or `sign_in_form_card.dart`.

## When to split a file

Split a screen when one or more sections have independent layout, substantial implementation, or a clear reuse/testing boundary. A practical starting point is:

```text
lib/features/<feature>/
  <feature>_screen.dart       # Screen state, composition, and feature callbacks
  parts/                      # Large screen sections that are only used here
  widgets/                    # Focused feature widgets used by more than one section
  <feature>_controller.dart   # Only when state/orchestration warrants it
```

Keep a small screen in one file when extracting its few lines would make navigation harder. Do not create a file for every trivial row, label, or one-use decoration. A controller is not required just to wrap a single callback or repository call; follow the feature contract in [features.md](features.md).

Keep UI composition in widgets and stateful behavior in the owning screen/controller. Pass callbacks, values, and controllers explicitly into child widgets. Child widgets should not reach into a screen's private state or duplicate navigation/business rules.

## Current landing and auth layout

These screens demonstrate the intended boundaries:

```text
lib/features/landing/
  landing_page.dart                 # Page scaffold, breakpoints, route callback
  parts/
    landing_header.dart             # University identity and sign-in action
    landing_hero.dart               # Hero copy, service overview, service rows
    landing_content.dart            # Feature cards and page footer

lib/features/auth/
  auth_screen.dart                  # Form state, validation, sign-in orchestration
  widgets/
    auth_identity_header.dart       # Unit identity block
    sign_in_form_card.dart          # Fields, validation display, and submit UI

lib/features/dashboard/
  demo_admin_dashboard_screen.dart  # Debug-only synthetic dashboard preview
  widgets/
    demo_metric_card.dart           # One display-only sample metric
    demo_activity_panel.dart        # Sample admin priority rows
```

The demo credentials live in `lib/features/auth/demo_admin_credentials.dart`; the app shell accepts them only inside its debug-only route wiring. Production auth and role routing remain separate work.

When a split changes public contracts, navigation, data access, or documented feature scope, update the corresponding catalog and architecture docs. For a presentational split that preserves behavior, keep this layout guide and source tree aligned.

## Refactor checklist

1. Confirm which feature owns the behavior and read its section in [features.md](features.md).
2. Extract one cohesive section at a time and pass its dependencies explicitly.
3. Keep names and imports direct; avoid catch-all `helpers.dart`, `utils.dart`, or `misc.dart` files.
4. Remove duplicate or obsolete implementations after the new owner is in place.
5. Format changed Dart files. Run tests or other verification only when the task explicitly requests it, per the repository work rules.
