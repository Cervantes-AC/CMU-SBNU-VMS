# Security Quality and Governance

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 10. Security and Privacy

Security/privacy personnel must review this baseline before collecting real personal or emergency data. This is not a compliance certification.

- Use least-privilege authorization; test Firestore rules independently of client screens.

- Restrict SOS/incident details. Notifications carry minimum information required to prompt an authorized handler.

- Explain purpose, access, retention, and contact route before collecting profile, incident, attachment, or location data.

- Collect location only for approved user-initiated workflows. No default background tracking.

- Keep secrets out of client code and logs; review diagnostics, exports, backups, and notification payloads for sensitive data.

- Define correction, removal, retention, backup expiry, access review, and breach/escalation procedures with institutional owners.

- Review applicability of Philippine Data Privacy Act of 2012 (RA 10173) and implementing rules with CMU–SBNU privacy personnel; this package is not legal advice.

Official references: Official Gazette, RA 10173: https://officialgazette.gov.ph/2012/08/15/republic-act-no-10173/ ; National Privacy Commission, Act and IRR: https://privacy.gov.ph/the-data-privacy-act-and-its-irr/. The Act states principles including transparency, legitimate purpose, and proportionality; institutional reviewers determine obligations.

## 11. Notifications, Offline Use, and Operations

### 11.1 Notifications

- Confirm whether push notifications are approved for SOS and announcements; device permission and service behavior affect delivery.

- Show truthful state where available; if delivery cannot be confirmed, say unknown or failed.

- Define retry/escalation with responders. Repeated rounds, sounds, vibration, and global banners need explicit safety and policy review.

### 11.2 Offline and service failure

- Decide which ordinary functions work offline and how pending changes reconcile.

- Never queue SOS silently and imply responders were notified. Show connection/submission state and approved fallback.

- Define backup/restore, monitoring, support ownership, incident response, and rollback before pilot.

### 11.3 Hotline and responder operations

- Maintain an owner for the hotline list and responder roster; review each on an approved schedule.

- Train primary and backup handlers; define coverage, handoff, escalation, and procedures if the app/network is unavailable.

## 12. Quality Requirements

**Table 09. 12. Quality Requirements — Area / Requirement / Target / decision**

| Area | Requirement | Target / decision |
| --- | --- | --- |
| Accessibility | Labels, screen-reader/keyboard support, contrast, non-map alternative. | Confirm standard and owner. |
| Usability | Understandable deliberate emergency action; avoid accidental activation. | Validate with users/responders. |
| Privacy | Minimize data and restrict display/export to approved purposes. | Approve notice, access, retention. |
| Reliability | Report status honestly during service/device/network failure. | Confirm availability/recovery targets. |
| Performance | Support expected user, activity, report, map volume. | Confirm capacity assumptions. |
| Compatibility | Support agreed OS and deployment targets. | Confirm platforms/minimum versions. |
| Maintainability | Document ownership, configuration, deployment, support. | Assign technical/operational owners. |
| Localization | Approved language, names, number formatting, date/time. | Confirm locale needs. |

## 13. Verification Plan

**Table 10. 13. Verification Plan — Test area / Verify / Evidence**

| Test area | Verify | Evidence |
| --- | --- | --- |
| Requirements/access | Each role performs only approved actions; unauthorized access fails at data boundary. | Role matrix and rules tests. |
| SOS | Confirmation, optional location, handler routing, acknowledgement, status history, failure display. | Integration test and responder simulation. |
| Incidents/map | Submit with/without location; workflow; map/list permissions and detail limits. | UI, rules, privacy tests. |
| Hotline calling | Unverified/expired cannot call; verified entry confirms before device call handoff. | State and device tests. |
| QR attendance | Valid/expired/reused token; right participant/activity; duplicate/offline. | Boundary and abuse-case tests. |
| Reports | Filters/totals match approved calculations; exports respect permissions. | Known-data reconciliation. |
| Privacy/security | Location, files, logs, notifications, backups, exports follow policy. | Review and remediation log. |
| Accessibility/compatibility | Screen reader, keyboard, text scale, permissions, supported devices. | Manual/automated evidence. |
| Operations | Coverage, fallback, backup/restore, monitoring, support handoff. | Tabletop/readiness sign-off. |

## 14. Acceptance Criteria

- Sponsor approves first-release scope, roles, and action permissions.

- Volunteer, activity, attendance, QR, announcements, reports, and analytics meet approved requirements and pass scoped tests.

- Permitted user creates SOS with optional location; only designated handlers see and act on details.

- Handlers acknowledge/update; state changes include actor/time; unknown delivery is never reported as delivered.

- Incident can be submitted without location, follows approved workflow, and is visible on map/list only to authorized users.

- Unverified/overdue hotline cannot initiate calling; verified contact details appear for confirmation before call handoff.

- Security/privacy reviewers approve data, location, notification, retention, and access controls before real data use.

- Designated responders complete an alert simulation and approve coverage, escalation, and fallback.

- Production support, backups, monitoring, recovery, and rollback have written approval.

## 15. Risks and Mitigations

**Table 11. 15. Risks and Mitigations — Risk / Effect / Mitigation / decision**

| Risk | Effect | Mitigation / decision |
| --- | --- | --- |
| No responder coverage | Alert may go unanswered. | Name primary/backup handlers, coverage, escalation, training, fallback. |
| Network/device failure | Delivery delayed or unknown. | Show honest state; test failure; publish fallback; no guarantee. |
| Outdated hotline | Incorrect contact may be called. | Verifier, review date, periodic recheck, disable expired. |
| Location overexposure | Privacy or safety harm. | Minimize precision; restrict roles; review map details. |
| QR reuse/fraud | Attendance inaccurate. | Approve session validation, expiry, replay handling, correction audit. |
| Incorrect role rules | Sensitive data exposed. | Approve matrix; test data rules; audit privileged changes. |
| Unbounded scope/cost | Schedule and operating cost rise. | Prioritize scope and estimate hosting, maps, messaging, support. |
| Unclear retention/closure | Excess retention or unresolved cases. | Assign owner; approve retention, review, closure, escalation. |

## 16. Milestones and Readiness Gates

**Table 12. 16. Milestones and Readiness Gates — Milestone / Outcome / Exit evidence**

| Milestone | Outcome | Exit evidence |
| --- | --- | --- |
| M1 Scope/governance | Approve sponsor, owner, roles, release scope, responder owner, reviewers. | Approved scope and decisions. |
| M2 Requirements/design | Approve workflows, data classification, status, access, map/call dependencies, architecture. | Reviewed requirements/design. |
| M3 Build/configuration | Implement approved client, rules, integrations, admin tasks, audit behavior. | Build/config record; no assumed completion. |
| M4 Verification | Complete feature, access, privacy, accessibility, failure, responder tests. | Evidence and critical findings closed. |
| M5 Pilot readiness | Verify hotline, train handlers, publish procedures, approve support/rollback. | Named sign-offs and pilot plan. |
| M6 Pilot/evaluation | Run limited approved pilot and decide next release. | Pilot review and go/no-go. |

Dates, effort, budget, owners, and duration are For confirmation — items; no launch date/readiness is asserted.

## 17. Decision Register

**Table 13. 17. Decision Register — ID / Decision / Owner to confirm / Status**

| ID | Decision | Owner to confirm | Status |
| --- | --- | --- | --- |
| D-01 | Sponsor, product owner, operating unit, official name. | CMU–SBNU leadership | For review |
| D-02 | First-release scope and supporting features. | Sponsor / owner | For review |
| D-03 | Roles, account review, organization hierarchy, permissions. | Owner / technical lead | For review |
| D-04 | SOS recipients, coverage, escalation, fallback, training. | Emergency operations | For review |
| D-05 | Incident categories, status, visibility, files, retention, owner. | Unit / privacy reviewer | For review |
| D-06 | Location need/precision, map provider, access, retention. | Privacy / technical lead | For review |
| D-07 | Hotline numbers, verification authority, review, disable procedure. | Institution verifier | For review |
| D-08 | Platforms, Firebase products/region, costs, backups, support. | Technical lead / sponsor | For review |
| D-09 | Privacy notice, lawful basis, retention, institutional review. | Privacy personnel | For review |
| D-10 | Accessibility, language, report formulas, exports, pilot owner. | Owner / users | For review |

## 18. Glossary and References

**Table 14. 18. Glossary and References — Term / Meaning**

| Term | Meaning |
| --- | --- |
| SOS alert | In-app urgent notice to designated handlers; not a public emergency call. |
| Incident report | User-submitted record for review, with optional location. |
| Authorized handler | Person explicitly designated and permitted to receive/act on SOS. |
| Verified hotline | Institution-checked contact with accountable verifier and review date. |
| For confirmation — | Decision/fact requiring institutional or technical confirmation. |

Official Gazette, Republic Act No. 10173: https://officialgazette.gov.ph/2012/08/15/republic-act-no-10173/

National Privacy Commission, Data Privacy Act and IRR: https://privacy.gov.ph/the-data-privacy-act-and-its-irr/

These references support institutional review and do not replace advice from CMU–SBNU privacy or legal personnel.

This annex translates the approved planning scope into a candidate implementation design for Flutter/Dart, Firebase, and Cloud Firestore. It is detailed enough to estimate and review, but must be validated against the selected platforms, Firebase project, institutional policies, cost plan, and implementation team skills. It does not describe a completed build.
