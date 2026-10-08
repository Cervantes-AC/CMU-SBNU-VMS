# 01. Frontend

## Purpose

Own Flutter screens, navigation, presentation state, app theme, and reusable UI. Keep the project in its existing `lib/` layout. Use the source boundaries in [`../ARCHITECTURE.md`](../ARCHITECTURE.md) and file-level rules in [`../FLUTTER_CODING_GUIDE.md`](../FLUTTER_CODING_GUIDE.md).

## Current status

The responsive landing page presents the CMU, ODRRM, and SBNU marks, with SBNU as the primary identity, and reveals sections as the user scrolls. It remains a local preview in `lib/features/landing/presentation/`. App composition is in `lib/app.dart`; theme tokens are in `lib/core/theme/app_theme.dart`. The preview has no sign-in, member data, or backend connection. Public or official release still requires institutional approval under [`../branding.md`](../branding.md).

The landing page is the first approved frontend slice. New data-backed or role-aware workflows still require their product, privacy, and access decisions. See [Auth and Security](05-auth-and-security.md) before implementing identity, session, or role behavior.

## Start developing

Frontend work can start with presentation-only screens and synthetic content. Do not wait for backend setup to build a screen shell or demonstrate an approved local workflow.

1. Identify the user and task for the screen. Record the expected start, success, and exit states.
2. Check this plan and search `lib/` for existing theme tokens, widgets, and state patterns to reuse.
3. Add the screen under `lib/features/<feature>/presentation/`. Keep page composition separate from substantial sections and widgets.
4. Start with local synthetic data or a fake repository when the screen needs data. Do not connect Firebase from widgets.
5. Add route wiring only when the approved workflow needs more than the current landing route. Use the existing routing dependency if routing is needed; do not add another package.
6. Format changed Dart files. Run tests, analysis, or builds only when the user requests verification.

## Foundation checklist

- [x] Keep the Flutter entry point in `lib/main.dart` and app composition in `lib/app.dart`.
- [x] Establish SBNU theme tokens in `lib/core/theme/app_theme.dart` and use the supplied mark in the local landing preview.
- [x] Create the landing feature under `lib/features/landing/presentation/` with focused presentation files.
- [x] Make the landing page responsive and keep it independent from Firebase and member data.
- [ ] Add a router when an approved workflow introduces multiple destinations or navigation requirements.
- [ ] Add shared loading, error, empty, or offline presentation only when a real data-backed workflow needs it; keep feature-specific feedback in its feature.
- [ ] Add common design tokens or components when repeated use establishes a consistent pattern.

## Per-screen implementation checklist

Complete the applicable items for each approved screen or workflow:

- [ ] **Scope:** Identify the intended user, task, allowed information, and acceptance conditions. Record unresolved policy decisions as blockers for dependent behavior.
- [ ] **Structure:** Put the page in its feature's `presentation/` folder; split substantial sections into focused files; keep one-use pieces local; reuse existing components and theme tokens.
- [ ] **State:** Use typed UI state for non-trivial behavior. Keep state coordination in a controller/view model when it no longer belongs in a small widget.
- [ ] **Data boundary:** Inject a repository or service into the state coordinator. Use synthetic fixtures or a fake repository for local development. Keep SDK access out of widgets.
- [ ] **States:** For data-backed screens, present loading, populated, empty, failure, and offline states as applicable. Handle pending approval, denied access, and expired sessions only when the workflow policy defines them.
- [ ] **Navigation:** Provide an obvious way to continue, go back, or exit. Do not treat route guards or hidden controls as authorization.
- [ ] **Responsive layout:** Support the intended Android screen sizes; handle narrow widths, text scaling, keyboard insets, and scrolling without overflow.
- [ ] **Accessibility:** Use meaningful labels and semantics, adequate contrast, large enough tap targets, and predictable focus/keyboard behavior where applicable.
- [ ] **Privacy:** Show only information needed for the task. Avoid personal data in logs, errors, screenshots, and synthetic fixtures.
- [ ] **Review:** Inspect the intended diff, format changed Dart files, and update relevant documentation when behavior or status changes.
- [ ] **Verification:** Run only checks the user explicitly requested; report exact commands and outcomes.

## State guidance

Use only the states relevant to a screen. A static local landing page does not need fake loading or network feedback. A data-backed list will generally need:

| State | Frontend behavior |
| --- | --- |
| Loading | Show progress without implying that data is available yet. |
| Populated | Show only the records returned for the signed-in role. |
| Empty | Explain that there is currently nothing to show and offer an allowed next step. |
| Failure | Give a plain-language message and a safe retry or recovery action. |
| Offline | Explain what is unavailable and whether any cached content can be used. |
| Access denied or pending | Follow the approved policy and avoid exposing protected record details. |

## Suggested feature layout

Add only folders needed by approved work; this is a guide, not a requirement to create empty directories.

```text
lib/
  app.dart
  core/theme/
  shared/widgets/                  # reused by multiple unrelated features
  features/<feature>/
    presentation/
      <feature>_page.dart           # screen composition and user actions
      widgets/                      # substantial feature-owned sections
      <feature>_controller.dart     # only when state/action coordination needs it
    data/                           # repository and SDK adapters, when needed
```

## Frontend completion checklist

- [ ] The selected workflow and its UI states are approved and documented.
- [ ] The screen works locally with synthetic data or its authorized service boundary.
- [ ] Loading, empty, failure, offline, and access states are handled where relevant.
- [ ] The interface is responsive and accessible for its intended platform.
- [ ] Widgets contain no direct Firebase or other SDK calls.
- [ ] Authorization is enforced by trusted backend rules or operations where data access is involved; the UI is not treated as a security boundary.
- [ ] Requested verification passes, and the handoff reports any remaining limitations.

## Ready when

The approved workflow works locally, every relevant UI state is presented clearly, and users see only information allowed by the approved access policy. A polished local preview alone does not mean a data-backed workflow or production release is ready.
