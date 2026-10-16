# Implementation Plan

**Status:** Planning baseline derived from `CMU_SBNU_Volunteer_Management_System_Documentation.docx`. This is a proposed sequence, not an implementation status report. Requirements and operational decisions marked for confirmation in the source remain open until their owners approve them.

## 1. Goal and scope

Build a Flutter application for CMU's School-Based National Service Reserve Corps Unit to coordinate volunteers, organizations, activities, attendance, announcements, and operational reporting. The proposed full scope also includes QR-assisted attendance, incident reporting, an incident map/list, SOS alerts for designated handlers, and a verified hotline directory.

The planning document proposes Flutter/Dart with Firebase Authentication and Cloud Firestore, with trusted server-side operations (for example, callable Cloud Functions) for privileged actions. Confirm the final Firebase products, supported platforms, costs, and architecture during design. The app is not public emergency dispatch; do not promise alert delivery or response. Background location tracking and SMS dispatch are outside the proposed first release.

## 2. Working principles

- Treat the source specification as requirements to review, not proof that features or approvals already exist.
- Enforce access with Firestore Security Rules and trusted server-side checks; hiding a screen is not authorization.
- Use least privilege and organization/activity/assignment scope. Keep incident and SOS details limited to authorized people.
- Collect location only for an approved, user-initiated workflow. Location is optional in the proposed incident flow.
- Show truthful network and notification states. Unknown or failed delivery must never appear as delivered.
- Use synthetic data in development. Do not put service account credentials or production secrets in the client or repository.
- Keep audit history for privileged changes, incident/SOS lifecycle transitions, hotline verification, and attendance corrections.

## 3. Suggested implementation phases

### Phase A — Discovery and governance

**Work:** Agree on first-release scope, stakeholders and owners; approve platform targets; define roles and action permissions; establish privacy classification, retention, account lifecycle, incident/SOS procedures, hotline ownership, support, and cost assumptions.

**Exit evidence:** Sponsor-approved scope and role matrix; named technical, privacy, safety, and operational owners; documented open decisions and data-handling boundaries.

### Phase B — Solution design and foundations

**Work:** Confirm app architecture and state-management choice; design navigation, accessibility, visual tokens, Firebase project separation (local/staging/production), authentication lifecycle, data model, indexes, Security Rules, privileged function contracts, logging, and environment configuration. Set up the app shell and reusable core components.

**Exit evidence:** Reviewed architecture, schema/query plan, authorization matrix, threat/privacy review, environment setup, and UI prototype. No production credentials in the client.

### Phase C — Identity and organization

**Work:** Implement sign-in/recovery, profile, account approval and suspension, organization membership, scoped role/designation administration, and audit hooks.

**Exit evidence:** Approved account lifecycle and role workflows; users cannot elevate their own access; positive and negative access cases are covered.

### Phase D — Activities, participation, and attendance

**Work:** Build activity browse/detail/create/edit, participation requests and decisions, attendance roster/history/corrections, and reporting definitions. Add QR session issuance and scanning only with server validation, expiry, replay protection, eligibility checks, idempotency, and correction audit.

**Exit evidence:** Approved lifecycle and scope rules; pagination and query indexes reviewed; duplicate, expired, forged, wrong-activity, offline, and correction cases handled.

### Phase E — Announcements and reports

**Work:** Implement audience-scoped announcement feed/publishing and bounded, organization-scoped reporting/analytics. Log and protect exports; define retention/expiry for generated files.

**Exit evidence:** Audience permissions verified and report totals reconciled against known records; exports are authorized, bounded, and audited.

### Phase F — Incidents and hotline directory

**Work:** Add incident submission and review, optional location, status/history, restricted map and list views, and hotline entry/verification/expiry/call handoff. Keep map markers free of reporter identity and narrative; provide a list alternative.

**Exit evidence:** No-location reporting works; only authorized users see incident detail; unverified/expired numbers cannot initiate a call; call handoff requires user confirmation.

### Phase G — SOS alert path

**Work:** Implement deliberate confirmation, idempotent alert creation, delivery-state tracking, routing only to the approved active responder roster, responder acknowledgement/assignment/status, and safe failure/fallback UX. Add rate limits and audit events.

**Exit evidence:** Approved handlers, backup coverage, escalation and offline procedures; responder simulation completed; unauthorized reads/updates denied; network failure is shown as not sent/unknown as appropriate. Do not enable production SOS before the operational gate is approved.

### Phase H — Operations, pilot, and release

**Work:** Add privacy-safe monitoring, backup/restore and rollback procedures, support and incident response, access reviews, training, privacy notice, migration planning (if needed), and pilot measurement.

**Exit evidence:** Security/privacy and operational sign-offs; verified hotline roster; restore and rollback rehearsal; named support owner; approved pilot cohort and go/no-go decision.

## 4. Proposed `lib/` layout

See [`lib/README.md`](../lib/README.md) and the [architecture decision](architecture.md). The folders are scaffolding only; they do not imply features are implemented. Follow the source specification's feature areas and keep presentation, domain rules, and data access separate as each feature is built.

## 5. Cross-cutting implementation checklist

- **Authorization:** map each action to role, organization/activity scope, and trusted enforcement point. Re-check current status for sensitive operations; client claims can be stale.
- **Data:** validate bounded fields, server timestamps, lifecycle transitions, retention, and location-sharing flags. Do not use fake coordinates or unbounded history arrays.
- **Emergency UX:** explain who receives SOS and what is shared before confirmation; request location only when approved; disclose that this app does not contact public emergency services or guarantee response.
- **Resilience:** distinguish loading, empty, offline, permission-denied, validation, retryable, and unknown-delivery states. Retry idempotently.
- **Accessibility:** support text scaling, semantic labels, keyboard focus, and alternatives to map-only interaction.
- **Quality:** use unit/widget tests for behavior, authorization/rules tests for access boundaries, and integration/UAT scenarios for QR, incident, SOS, hotline, backup, and restore paths.
- **Release:** separate Firebase environments, review rules and indexes, scan dependencies/secrets, verify configuration, monitor pilot outcomes, and document rollback.

## 6. Decisions to resolve before implementation

1. Sponsor-approved first-release scope and supported platforms.
2. Official unit naming, stakeholder/decision owners, and approved role/action matrix.
3. Registration approval, account recovery, MFA, suspension, and removal policies.
4. Firebase project/region/products, state-management approach, map provider, push behavior, and cost limits.
5. Data fields, privacy notice, sensitive-data handling, location precision/retention, attachments, audit access, and export policy.
6. Incident categories/severity, lifecycle transitions, reopen/close authority, and reviewer assignments.
7. SOS eligibility, designated primary/backup responders, coverage, escalation, cancellation, rate limits, fallback, and training.
8. Hotline numbers, verification/separation-of-duties process, review expiry, and owner.
9. Offline behavior, support hours, monitoring, backup frequency, recovery objectives, and rollback authority.
10. Pilot cohort, outcome baselines/targets, acceptance owners, budget, and dates.

Track each decision with an owner, due point, and recorded approval. Do not treat proposed values in the source as approved policy.

## 7. Readiness gates

| Gate | Required evidence |
| --- | --- |
| Design approval | Scope, roles, schema, authorization boundaries, privacy classification, and operational workflows reviewed. |
| Feature complete | Reviewed implementation, tests, rules, indexes/migrations, and user-facing states for the approved scope. |
| Security and privacy | Access tests, privacy notice, retention plan, location/notification review, and disposition of critical findings. |
| Operational readiness | Verified hotline and responder coverage, simulation, support owner, monitoring, backup/restore, and rollback. |
| Pilot approval | Named approver, limited cohort, training, feedback path, incident criteria, and review date. |
| Production approval | Required gates accepted and no unresolved critical security, privacy, or operational findings. |

## 8. Traceability

Use the [topic-based Markdown specification set](specification/README.md) for requirement IDs, proposed Firestore paths and field dictionary, API examples, lifecycle transitions, acceptance scenarios, and the traceability matrix. The original DOCX is preserved alongside it. Keep implementation tickets linked to those requirement IDs and update the source only through an explicit review of proposed decisions. The specification's status is planning/review; it does not certify institutional approval, production readiness, or implemented behavior.
