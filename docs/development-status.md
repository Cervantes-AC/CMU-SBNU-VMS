# Development Status

**Last updated:** 2026-10-16
**Status:** Interface development in progress. The planning specification remains proposed and requires institutional review.

## Implemented in the Flutter client

- Application theme, SBNU logo, and public landing page following the `prototype/` palette and card styling.
- Workspace navigation for Overview, Activities, Volunteers and Organizations, Attendance, Announcements, Emergency and Safety, Reports, and Access and Operations.
- Responsive mobile-first layouts with an expandable navigation drawer on wider screens.
- Synthetic sample content and local-only interactions for activity filters/draft creation/editing/discard/details/join/withdraw, volunteer search/college filter/profile detail, organization detail, attendance status corrections with a session-only reason/actor/time history, audience-targeted announcement drafts with edit/archive/restore, incident previews with occurrence time/discard, and filtered synthetic report summaries/CSV.
- Candidate-role and environment status reference screen, with no ability to grant roles or change account access.
- Activities use a feature-owned preview repository and ViewModel; local drafts capture, edit, and discard title, category, schedule, venue, description, and capacity, and sample records have a details view. The source can be replaced by an approved adapter without making the widget call Firestore.
- The overview activity count and upcoming list read the same local activity ViewModel as the Activities screen; its activity and safety cards navigate to their respective sections.
- Attendance uses a feature-owned preview repository and ViewModel; local status corrections require a reason and show a session-only history. QR session creation and server validation remain unavailable.
- Announcement drafts capture title, message, and an example audience, and can be edited or archived/restored in the local preview. Audience groups are proposed examples only; publishing and delivery are unavailable.
- Reports calculate synthetic participation, hours, and activity totals from local sample rows, with program/date filters and matching CSV output.
- GoRouter handles the public landing and workspace routes.
- Sign-in, registration, and recovery entry pages explain the unconfigured status without accepting credentials or sending recovery requests.
- Firebase Core initializes against the approved `cmu-sbnu-vms` project; app startup does not read or write project data.
- Firebase Auth and Firestore emulator endpoints are configured for explicit local use with `--dart-define=USE_FIREBASE_EMULATORS=true`.
- Start local Auth and Firestore emulators with `firebase emulators:start --only auth,firestore`, then launch Flutter with `--dart-define=USE_FIREBASE_EMULATORS=true`. Override `FIREBASE_EMULATOR_HOST` for Android emulators or a non-local emulator host.
- User-visible disclosure where records are synthetic or local-only and where a service action is not connected.

## Deliberately not connected

- Firebase Auth sign-in, account approval, and recovery. The project is selected, but provider and account lifecycle decisions remain pending.
- Firestore repositories, query contracts, Security Rules tests, or Cloud Functions.
- QR session issuance or scan validation. These require trusted server validation, expiry, activity eligibility, replay protection, idempotency, and reviewed authorization.
- Incident location collection, provider-backed map, live reviewer list, or production review. The map-status card explains the open provider, location, and reviewer-permission decisions without displaying locations.
- SOS delivery, responder roster, acknowledgement, escalation, or push notification. The preview reports that no alert was sent.
- Institution-verified hotline data or phone handoff.
- Production analytics, authorization, and report export. The preview can copy filtered synthetic rows only.

Firestore rules continue to deny all client access. Firebase project/environment, region, account lifecycle, role/action matrix, retention, location policy, hotline ownership, responder coverage, and operational procedures remain open decisions in the specification. Do not add real member or emergency data until their owners approve the relevant controls.

## Next development sequence

1. Review and approve scope, supported platforms, role/action permissions, Firebase region, privacy classification, and data retention. The existing `cmu-sbnu-vms` project is approved for development use.
2. Add authentication/session and account approval using the approved identity lifecycle.
3. Define feature repository contracts, Firestore queries/indexes, callable operations, and least-privilege Rules; test authorization allow and deny cases.
4. Connect activities, organizations, volunteer profiles, participation, attendance, and announcements to an approved development environment.
5. Add QR only after server validation and replay/idempotency rules are in place.
6. Add incidents, map/list, verified hotlines, and SOS only after privacy review and named operational owners/coverage are approved.
7. Complete security/privacy, accessibility, backup/restore, monitoring, support, pilot, and release gates.

## Current verification

- `flutter analyze --no-pub` passes for the current interface implementation.
- `flutter build web --no-pub` succeeds for the current interface implementation.
- Automated tests have not yet been run for the newly added screens.
