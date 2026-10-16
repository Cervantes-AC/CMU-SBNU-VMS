# Development Status

**Last updated:** 2026-10-16
**Status:** Interface development in progress. The planning specification remains proposed and requires institutional review.

## Implemented in the Flutter client

- Application theme, SBNU logo, and public landing page following the `prototype/` palette and card styling.
- Workspace navigation for Overview, Activities, Volunteers and Organizations, Attendance, Announcements, Emergency and Safety, Reports, and Access and Operations.
- Responsive mobile-first layouts with an expandable navigation drawer on wider screens.
- Synthetic sample content and local-only interactions for activity filters/drafts/join state, volunteer search, organization list, attendance roster toggles, announcement drafts, incident form previews, and copying an illustrative CSV to the clipboard.
- Candidate-role and environment status reference screen, with no ability to grant roles or change account access.
- Activities use a feature-owned preview repository and ViewModel; the source can be replaced by an approved adapter without making the widget call Firestore.
- GoRouter handles the public landing and workspace routes.
- User-visible disclosure where records are synthetic or local-only and where a service action is not connected.

## Deliberately not connected

- Firebase Auth and account approval/recovery.
- Firestore repositories, query contracts, Security Rules tests, or Cloud Functions.
- QR session issuance or scan validation. These require trusted server validation, expiry, activity eligibility, replay protection, idempotency, and reviewed authorization.
- Incident location, map provider, live incident access, or production incident review.
- SOS delivery, responder roster, acknowledgement, escalation, or push notification. The preview reports that no alert was sent.
- Institution-verified hotline data or phone handoff.
- Production analytics, authorization, and report export. The preview can copy a fixed synthetic CSV sample only.

Firestore rules continue to deny all client access. Firebase project/environment, region, account lifecycle, role/action matrix, retention, location policy, hotline ownership, responder coverage, and operational procedures remain open decisions in the specification. Do not add real member or emergency data until their owners approve the relevant controls.

## Next development sequence

1. Review and approve scope, supported platforms, role/action permissions, Firebase environments/region, privacy classification, and data retention.
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
