# Landing Feature Status and TODO

**Current status:** A static landing concept preview using the repository's CMU and SBNU logo assets is now the local app startup screen through `NSRCApp`, at the user's request. This local preview does not record brand/publication approval. Do not publish or release it as the final landing experience while its approval gates remain open.

## Run the local preview

From the repository root:

```powershell
flutter run -d chrome
```

The page is presentation-only. It loads no Firebase, network, or member data and has no working sign-in, contact form, external link, or service action.

## Implemented files

- `lib/main.dart`: initializes Flutter bindings and starts `NSRCApp`.
- `lib/app.dart`: temporarily composes the Material 3 theme and uses `LandingPage` as the local preview home. Firebase initialization and the approved auth/public router are not implemented.
- `lib/features/landing/landing_page.dart`: responsive concept page with CMU/SBNU image assets in a contained logo row, a preview notice, static workspace illustration, planned capability cards, text scaling, and semantic image/headings.
- `test/widget_test.dart`: starter counter test replaced with a smoke test for the app's landing preview. It has not been run since this change.

## Approval gates before public use

- [ ] D-17: Approve whether a public landing route/site will exist, supported platforms, hosting/domain, and support ownership.
- [ ] D-18: Approve institutional name, logo use, colors, program claims, and publication context. The logos are included for this requested local preview only; public use still needs the recorded approval.
- [ ] D-21: Confirm supported browser/device matrix, accessibility expectations, and languages.
- [ ] Product owner reviews final copy, capability descriptions, navigation, metadata, and release behavior.
- [ ] Replace this temporary app root with the approved signed-out/auth route behavior. Do not expose a public landing route unless D-17 permits it.
- [ ] Add a contact form only after its destination, data-use notice, validation, backend abuse controls/rate limits, retention, and failure behavior are approved.

## Completion criteria for the local preview

- [x] Landing preview is connected to the default local app startup.
- [x] Layout adapts across narrow and wide widths; CMU and SBNU logos use `BoxFit.contain` and accessible labels.
- [x] The page states that content is conceptual and sign-in/records are not connected.
- [x] Capability cards are visibly marked planned; there are no unsupported service promises, private data, contact details, or unapproved external links.
- [ ] Updated root-preview smoke test and approved-width/accessibility review are completed.
- [ ] Owner review and D-17/D-18/D-21 decisions are recorded before public release.

**Verification boundary:** The smoke test was updated but not run. Do not add or run further tests unless the user explicitly asks to test or verify implementation. Public routing, branding, and contact workflow remain gated by the decisions above.
