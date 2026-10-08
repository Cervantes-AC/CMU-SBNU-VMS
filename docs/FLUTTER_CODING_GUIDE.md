# Flutter Coding Guide

Use this guide with [Flutter Source Architecture](ARCHITECTURE.md). The architecture describes where code belongs; this guide describes how to keep each change readable, focused, and reusable.

## Keep files focused

- Do not put an entire feature in one large Dart file. Separate the screen, feature sections/widgets, state coordination, and data access by responsibility.
- Keep a screen file focused on composing its sections and connecting user actions. Put substantial sections and feature-specific widgets in nearby files under that feature's `presentation/` folder.
- Keep small, one-use widgets beside the screen when extracting them would make navigation harder. Split a widget when it has a clear responsibility, meaningful complexity, or more than one caller.
- Keep UI state and action handling in a controller or view model when the screen has non-trivial behavior. Do not create empty layers or placeholder files just to match a template.
- Keep Firebase and platform SDK access behind feature data/services. Widgets render state and forward actions; they do not query SDKs directly.

## Reuse before adding

- Before writing a new widget, helper, model, or theme value, search `lib/` for an existing implementation and reuse or extend it when its meaning matches.
- Keep app-wide colors, typography, and component styling in `core/theme/`. Use theme tokens instead of repeating raw colors and dimensions throughout screens.
- Keep a reusable widget in its feature while it serves only that feature. Move it to `shared/` only when multiple unrelated features use it and its meaning remains consistent.
- Prefer a small explicit component over a configurable abstraction with options no current caller needs.
- Do not duplicate business rules between screens. Put shared rules in the appropriate feature/domain layer when there are real multiple callers.

## Organize by feature

```text
lib/
  app.dart
  core/theme/
  shared/widgets/                 # genuinely cross-feature presentation
  features/<feature>/
    presentation/
      <feature>_page.dart         # page composition and UI actions
      widgets/                    # feature-owned sections/components
    data/                         # repositories and SDK adapters, when needed
```

Use `snake_case.dart` filenames and `UpperCamelCase` types. Import across directories with `package:cmu_sbnu_vms/...`. Keep feature-specific parts inside their feature; do not create directories for features that are not being implemented.

## UI and data boundaries

- Give each data-backed screen explicit loading, empty, failure, and offline presentations when those states apply.
- Use typed state and errors instead of loosely related booleans or raw backend objects in widgets.
- Inject repositories/services into state coordinators. Keep widgets independent of Firebase initialization and configuration.
- Do not treat hidden controls or client navigation as authorization. Trusted backend rules and operations enforce access.
- Use synthetic content in local previews. Do not add production records, credentials, or prototype backend configuration.

## Change discipline

- Make focused changes and preserve unrelated work. Inspect `git status` and relevant diffs before editing.
- Format changed Dart files with `dart format`.
- Do not add dependencies, delete files, stage, commit, deploy, or contact people without the authorization required by the repository instructions.
- Follow the repository instructions for tests and verification; do not run checks unless the user asks for testing or verification.
