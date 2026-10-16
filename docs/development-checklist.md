# Flutter Application Development Checklist

**Goal:** deliver an end-to-end CMU–SBNU volunteer management application using the approved requirements in `docs/specification/` and the visual/interaction reference in `prototype/`. A local preview is a starting point, not an accepted implementation of a feature.

**Status:** Work in progress. The Flutter shell and several synthetic local workflows exist; authentication, persistence, authorization, and operational backend workflows are not yet complete. Keep this checklist current and link completed work to requirement IDs and verification evidence.

## 1. Foundations and maintainability

- [ ] Read the relevant specification, `docs/architecture.md`, `docs/implementation-plan.md`, and prototype guidance before each feature change.
- [ ] Keep the app compiling/analyzable after each slice; format Dart and record the exact verification run.
- [x] Move app startup, routing, theme, and provider composition out of the app widget into `lib/app/`.
- [ ] Finish the staged migration in [`structure-redesign.md`](structure-redesign.md); remove obsolete/empty scaffold folders only after references are migrated.
- [ ] Add environment-aware configuration for explicit local emulator and approved development backend use; fail visibly when required startup configuration is invalid.
- [ ] Establish privacy-safe logging, shared typed failures, reusable loading/empty/error/offline states, and accessibility review for common components.
- [ ] Keep requirements, feature status, and decisions traceable; do not mark an item complete without implementation and verification evidence.

## 2. Identity and permissions — AUTH-01..03, VOL-01..02, ORG-01

- [ ] Implement the approved Firebase Authentication sign-in, registration, recovery, and sign-out flows.
- [ ] Implement account status/approval and session restoration; protect workspace routes as UX only and enforce authorization at trusted data boundaries.
- [ ] Implement approved volunteer profile fields, self-edit allowlist, organization membership, and scoped organization hierarchy.
- [ ] Implement role/designation administration only after the action matrix and separation-of-duties decisions are approved; prevent self-promotion server-side and audit privileged changes.
- [ ] Replace placeholder auth pages with validated forms, useful errors, loading/retry states, and accessible semantics.

## 3. Core volunteer workflows — ACT-01..02, ATT-01..02, ANN-01, REP-01..02

- [ ] Connect activities to persisted data with approved lifecycle, capacity, eligibility, participation requests, decisions, and conflict handling.
- [ ] Connect attendance records, own-history/scoped roster views, authorized corrections, reason capture, and append-only audit history.
- [ ] Implement QR attendance only after trusted session issuance and server validation for signature, expiry, activity, eligibility, replay, and idempotency.
- [ ] Connect announcements to approved audiences and publisher permissions; implement draft/publish/archive and truthful delivery status.
- [ ] Implement scoped reports with documented calculations, bounded queries, field allowlists, and authorized/audited exports.
- [ ] Ensure overview/dashboard totals read the same repositories as their owning feature pages.

## 4. Safety workflows — INC-01..02, MAP-01, SOS-01..03, HOT-01..02, ADM-01

- [ ] Implement incident submission without requiring location; implement reviewer assignment, valid state transitions, version/conflict handling, and restricted history.
- [ ] Add map/list views only after the location provider, precision, access, retention, and privacy controls are approved; keep identity and narrative out of map markers.
- [ ] Populate hotline entries only from an institution-owned verified source; enforce review expiry, separation of duties, non-callable unverified/expired states, and user-confirmed dialer handoff.
- [ ] Enable SOS only after named primary/backup responders, coverage, escalation/fallback, training, rate limits, notification policy, and simulation are accepted.
- [ ] Implement SOS with deliberate confirmation, minimal payload, trusted scoped routing, idempotency, audit, and accurate pending/delivered/failed/unknown states; never label a local preview as sent.
- [ ] Implement restricted, append-only audit records for sensitive actions and lifecycle transitions.

## 5. Operations and release — OPS-01, ADM-02

- [ ] Confirm dev/staging/production separation, Firebase products/region, indexes, least-privilege rules, deployment ownership, and secret handling.
- [ ] Implement privacy notice, retention/deletion, support contact, monitoring, backup/restore, and rollback procedures.
- [ ] Verify offline/cache behavior per feature; do not queue SOS silently and reuse idempotency keys for safe retries.
- [ ] Complete dependency/configuration review, platform builds, accessibility review, security/privacy review, responder simulation where applicable, and sponsor/UAT acceptance.
- [ ] Release only after all applicable design, security/privacy, operational, pilot, and production gates have named approval evidence.

## 6. Feature status snapshot

Use this table as a short status index; the numbered checklists above are the acceptance work. A page or synthetic repository does not count as a connected feature.

| Feature | Current starting point | Completion target |
| --- | --- | --- |
| Auth and access control | Informational auth pages; proposed permission matrix | Authenticated session, approved account lifecycle, trusted scoped authorization |
| Organizations and volunteers | Synthetic list/profile data | Approved persisted records, validation, scoped access, useful empty/error states |
| Activities and attendance | Local preview repositories and UI workflows | Persisted lifecycle, participation, attendance, trusted QR and corrections |
| Announcements | Local draft previews | Audience-authorized publishing and truthful delivery states |
| Reporting and audit | Synthetic calculations/CSV and synthetic audit examples | Scoped real queries/exports and restricted append-only audit |
| Incidents, SOS, hotlines | Safe local previews with no real location/send/call | Approved operational integrations and full safety/security acceptance |

## Current verification

- [x] `dart format` on the app composition/bootstrap/routing/theme files.
- [x] `flutter analyze --no-pub` — passed on 2026-10-17.
- [x] `flutter build web --no-pub` — passed on 2026-10-17.
- [ ] Android/iOS/desktop builds and runtime flows — verify on supported targets as configuration and available devices permit.
- [ ] Authentication, backend integration, authorization, and feature acceptance scenarios — not yet implemented/verified end to end.
