# Product Requirements and Acceptance Criteria

**Status:** proposed baseline for owner review; local implementation may use synthetic data.  
**Product:** CMU School-Based NSRC Unit Volunteer Management System.  
**Target repository:** `cmu_sbnu_vms`. The prototype in `D:\nsrc_vms` is not the target system.

This page is the single working product scope. Requirements labeled **Proposed** are sufficiently concrete for local/synthetic implementation but must be accepted by the product owner before being called institutionally approved or used with real data.

## 1. Goals and non-goals

### Proposed goals

- Give members one place to see approved unit announcements, events, their own attendance and profile.
- Give authorized officers tools to coordinate approved events and record attendance with traceable corrections.
- Give administrators a controlled account approval and access-management workflow.
- Provide an auditable, role-aware system that works on Android first and supports responsive web if the owner keeps web in release scope.
- Minimize personal data, limit access by role, and use synthetic data during development.

### Non-goals for initial release

- Replacing official emergency services or promising SOS delivery.
- Background/continuous location tracking or public incident maps.
- AI analysis of volunteer or incident data.
- Arbitrary Firestore query/edit console, user impersonation, client-side full backup/restore, or unrestricted bulk export.
- iOS/desktop release until their owners, support requirements and privacy declarations are confirmed.

## 2. Personas and authorization assumptions

| Role | Proposed allowed work |
|---|---|
| `member` | Read/update allowlisted own profile, read published events/announcements, submit event participation request if enabled, read own attendance/service summary, submit own incident if the incident module is approved |
| `officer` | Member capabilities plus manage events within the unit, review event participation, record/correct event attendance, view/respond to authorized incidents, draft reports |
| `admin` | Officer capabilities plus approve/deny accounts, change roles/status through trusted operation, publish announcements, read permitted aggregate analytics and audit records |
| `organization` | **Deferred**. Add only after an owner defines this external persona's identity proof, field-level access and purpose. Never infer it from prototype UI. |

All accounts begin `pending` if self-registration is enabled. Only an approved account can read protected application data. The production process for initial admin bootstrap is an owner-controlled trusted procedure and must not be a public sign-up choice.

## 3. Initial release scope (proposed)

| Priority | Feature | Release decision |
|---|---|---|
| P0 | App bootstrap, sign-in, password reset, approval gate, sign-out, access denied | Implement first; no public self-registration until D-07 closes |
| P0 | Profile read and allowlisted self-edit | Implement with synthetic profiles; field inventory requires D-03 approval before real data |
| P0 | Role-aware navigation/dashboard shell | Implement `member`, `officer`, `admin`; no organization dashboard |
| P1 | Events and announcements | Implement after event ownership, publication and audience policy review |
| P1 | Attendance and service-hour summary | Implement after hour policy and correction rules are approved; use synthetic events/records before then |
| P1 | Append-only audit log for privileged actions | Required for admin/attendance mutations; write via trusted backend |
| P2 | Incident submission and response | Deferred until privacy, consent, retention and response ownership decision D-11 |
| P2 | QR duty monitoring | Deferred until anti-replay/server validation design D-12 and event rules are approved |
| P2 | Reports/analytics | Only aggregates with an approved metric definition and data-minimization review |
| P3 | PDF, import/export, backup, database administration, query tool, public landing page, AI reports, SOS, maps | Individually deferred; require owner-approved use case/security/privacy plan |

## 4. Functional acceptance criteria

### Auth and approval gate (P0)

- A signed-out visitor can only access public routes explicitly listed in [`ui-and-routes.md`](../architecture/ui-and-routes.md).
- A valid authenticated account with missing, malformed, `pending`, `denied`, `blocked`, `suspended`, or `deactivated` profile cannot read protected app data and sees an access-denied/pending state.
- A `member` cannot choose or alter role/status. Role assignment and approval are performed by an authorized trusted operation and leave an audit entry.
- Password reset response does not disclose whether an address is registered. Sign-out clears in-memory user data, subscriptions and user-scoped cache.
- Session/profile changes re-evaluate route access without restarting the app.

### Profile (P0)

- The authenticated member can read their own approved profile fields; another member cannot read private fields.
- The member can update only the explicit self-edit allowlist. Role, account status, UID, email verification, created time, audit metadata and service totals cannot be set from a self-edit form.
- Form errors identify fields and do not display raw backend exceptions.

### Events and announcements (P1)

- Published/current unit records are visible to the intended audience only.
- Officers/admins can create/edit/cancel an event; members cannot. Invalid date interval and lifecycle transition are rejected in client and trusted backend.
- A join/participation request, if enabled, is unique per member/event and may be reviewed only by authorized staff.
- Draft/unpublished announcements are not visible to members. Publishing, audience, priority, start/end and expiry fields are validated.

### Attendance and service hours (P1)

- A member reads only their own attendance. Authorized staff can mark records for an event they manage; a member cannot award or modify their own hours.
- Repeated submission is idempotent. A correction records previous state, reason, actor and time; correction authority is explicit.
- Hours derive from approved attendance/duty facts by the policy in DECISION_REGISTER D-10. Before that decision closes, show raw attendance only and do not label derived values official.

### Incidents, QR, notification and advanced admin (deferred)

Acceptance criteria are defined in [implementation guide](../architecture/implementation-guide.md) and [file specs](../lib/features.md), but these features must remain disabled until their decision gates close. No UI affordance may imply an unimplemented emergency capability.

## 5. Non-functional requirements

- **Security:** deny-by-default backend rules, least privilege, server validation of sensitive writes, audit for privileged mutations, emulator authorization tests.
- **Privacy:** synthetic data only until D-03/D-22 approval; minimize fields; redacted diagnostics; retention/deletion defined before collection.
- **Reliability:** display loading, empty, error, retry and stale/offline states; never report a failed write as saved.
- **Accessibility:** semantic labels, keyboard/focus operation on web, scalable text, sufficient contrast, status conveyed by text/icon as well as color.
- **Performance:** paginated lists, bounded queries and file sizes, no full-collection reads for dashboards.
- **Compatibility:** baseline target is Flutter 3.38.9 / Dart 3.10.8 from the current repository planning record. Keep CI aligned and update this requirement when the supported toolchain intentionally changes.
- **Auditability:** privilege changes and consequential record changes have actor, server time, target entity and safe reason/correlation data.

## 6. Product-owner sign-off

Before production data or a public release, product owner must confirm: initial feature scope; member/officer/admin definitions; self-registration policy; supported platforms; account bootstrap; final user-facing copy and emergency limitations; and each applicable open item in [decision-register.md](decision-register.md). Approval records need approver name/role, date, evidence/reference and affected requirement IDs.

