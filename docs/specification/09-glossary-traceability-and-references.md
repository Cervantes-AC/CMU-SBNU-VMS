# Glossary Traceability and References

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 36. Glossary, Decisions, and Traceability

**Table 37. 36. Glossary, Decisions, and Traceability — Term / Meaning**

| Term | Meaning |
| --- | --- |
| CMU | Central Mindanao University. |
| SBNU | Southern Baptist Nursing Unit (confirm official institutional expansion/name). |
| NSRC | National Service Reserve Corps (confirm local unit naming/authority). |
| VMS | Volunteer Management System. |
| SOS | Emergency alert function; it does not itself guarantee emergency response. |
| PIC | Personal Information Controller under Philippine data protection framework. |
| DPO | Data Protection Officer. |
| NPC | National Privacy Commission. |
| FCM | Firebase Cloud Messaging. |
| RPO | Recovery Point Objective: maximum acceptable data loss measured in time. |
| RTO | Recovery Time Objective: target time to restore service. |

Decision register: unresolved institutional, operational, legal/privacy, and service-level choices remain marked “For confirmation.” Recommended defaults are planning proposals only and do not imply approval. Confirm no production data is loaded until the relevant privacy, safety, security, and region decisions are signed off.

## 37. Requirement Traceability Matrix

The matrix maps all 26 approved-baseline requirement IDs to candidate screens, canonical paths/functions, authorization tests, test-case identifiers, owners, and planning status. “For design” means implementation evidence is not yet available. AC-01–AC-12 provide cross-cutting Given/When/Then scenarios; each TC-<requirement ID> is a required implementation test to be authored and linked to the applicable acceptance scenario before release.

**Table 38. 37. Requirement Traceability Matrix — Req ID / Priority / Screen(s) / Collection / function**

| Req ID | Priority | Screen(s) | Collection / function | Rule test | Test case ID | Owner | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| AUTH-01 | High | Sign-in / recovery | Firebase Auth; users/{uid} | Auth + own-profile allow/deny | TC-AUTH-01 | Identity owner | For design |
| AUTH-02 | High | Account administration | users/{uid}; setAccountStatus | Admin scope; self-elevation deny | TC-AUTH-02 | Account owner | For design |
| AUTH-03 | High | All protected screens | All scoped collections/functions | Role × action positive/negative matrix | TC-AUTH-03 | Security owner | For design |
| VOL-01 | Medium | Volunteer profile / roster | users/{uid}; updateProfile | Own-field allowlist; sensitive-field deny | TC-VOL-01 | Volunteer data owner | For design |
| VOL-02 | High | Organization roster | users; organizations | Membership scope; cross-unit deny | TC-VOL-02 | Organization owner | For design |
| ACT-01 | Medium | Activity editor/detail | activities; create/update activity | Assigned coordinator scope | TC-ACT-01 | Activity owner | For design |
| ACT-02 | Medium | Activity browse / request | activities; participation | Eligibility and owner-only request | TC-ACT-02 | Activity owner | For design |
| ATT-01 | High | Attendance roster/editor | activities/{id}/attendance; recordAttendance | Assigned activity; correction reason/audit | TC-ATT-01 | Attendance owner | For design |
| ATT-02 | High | My attendance/history | attendance collection-group query | Own UID query; coordinator scope tests | TC-ATT-02 | Security owner | For design |
| QR-01 | High | QR issue/session | qrSessions; issueQrSession | Authorized issuer; no secret exposure | TC-QR-01 | Attendance owner | For design |
| QR-02 | High | QR scan/result | validateQrAttendance; attendance | Signature, expiry, eligibility, replay, idempotency | TC-QR-02 | Technical lead | For design |
| ANN-01 | Medium | Announcement feed/editor | announcements; publishAnnouncement | Publisher designation and audience scope | TC-ANN-01 | Communications owner | For design |
| REP-01 | Medium | Reports dashboard | reportJobs; createReportJob | Organization/date range scope; bounded query | TC-REP-01 | Reporting owner | For design |
| REP-02 | Medium | Analytics/export | attendance + participation; aggregateReport | Metric calculation and export-field allowlist | TC-REP-02 | Reporting owner | For design |
| ORG-01 | High | Organization administration | organizations; manageOrganization | No self-grant; hierarchy and scope validation | TC-ORG-01 | Organization owner | For design |
| INC-01 | High | Incident form | incidents; submitIncident | Optional location; bounded fields; reporter scope | TC-INC-01 | Safety/privacy owner | For design |
| INC-02 | High | Incident review/detail | incidents/{id}/history; reviewIncident | Designation, transition, expectedVersion, audit | TC-INC-02 | Safety owner | For design |
| MAP-01 | High | Incident map/list | bounded incidents query | locationShared gate; scoped access; no identity in marker | TC-MAP-01 | Safety/privacy owner | For design |
| SOS-01 | Critical | SOS confirmation/receipt | sosAlerts; createSosAlert | Permission, deliberate confirm, idempotency, rate limit | TC-SOS-01 | Emergency operations | For design |
| SOS-02 | Critical | Responder inbox | alertDeliveries; routeSosAlert | Active designated roster only; delivery state audit | TC-SOS-02 | Emergency operations | For design |
| SOS-03 | Critical | Responder detail/status | sosAlerts/events; updateSosStatus | Designation, expectedVersion, transitions, append-only history | TC-SOS-03 | Emergency operations | For design |
| HOT-01 | High | Hotline directory/admin | hotlines | Only approved scope; verification freshness | TC-HOT-01 | Hotline owner | For design |
| HOT-02 | High | Call confirmation | verified hotlines; device dialer handoff | Unverified/expired deny; user confirmation | TC-HOT-02 | Hotline verifier | For design |
| ADM-01 | High | Audit review | auditEvents | Restricted reader; append-only creation | TC-ADM-01 | Audit owner | For design |
| ADM-02 | High | Backup/restore/export | reportJobs; backup/restore service | Privileged approval; access and expiry logs | TC-ADM-02 | Operations owner | For design |
| OPS-01 | Medium | Help/support/settings | approved support configuration | Admin-only edits; public-safe fields | TC-OPS-01 | Service owner | For design |

## 38. Reference Sources and Revision History

The following official documentation informs technical and regulatory planning statements. Confirm current versions and institutional applicability during detailed design.

- Firebase, Securely query data — https://firebase.google.com/docs/firestore/security/rules-query

- Firebase, Index overview — https://firebase.google.com/docs/firestore/query-data/index-overview

- Firebase, Firestore locations — https://firebase.google.com/docs/firestore/pipelines/locations

- Firebase, App Check for Flutter — https://firebase.google.com/docs/app-check/flutter/default-providers

- Firebase, Callable functions — https://firebase.google.com/docs/functions/callable

- Firebase, Custom claims — https://firebase.google.com/docs/auth/admin/custom-claims

- Firebase, Manage user sessions and token revocation — https://firebase.google.com/docs/auth/admin/manage-sessions

- Firebase, Cloud Messaging for Flutter — https://firebase.google.com/docs/cloud-messaging/flutter/get-started

- National Privacy Commission, Implementing Rules and Regulations of RA 10173 — https://privacy.gov.ph/wp-content/uploads/2023/06/IRR_RA-10173-as-amended.pdf

- National Privacy Commission, PIPs and PICs FAQs (updated Jan 2026) — https://privacy.gov.ph/pips-and-pics/faqs/

- National Privacy Commission, Circular 2022-04 on registration — https://privacy.gov.ph/wp-content/uploads/2023/05/Circular-2022-04.pdf

- National Privacy Commission, Data Privacy Act quick guide — https://privacy.gov.ph/wp-content/uploads/2022/01/DPA_QuickGuidefolder_10191.pdf

**Table 39. 38. Reference Sources and Revision History — Version / Date / Change summary / Status**

| Version | Date | Change summary | Status |
| --- | --- | --- | --- |
| 2.2 | Planning baseline | Initial CMU–SBNU volunteer system scope and selected Flutter/Firebase features. | Superseded |
| 2.3 | Planning update | Added emergency SOS, incident reporting/mapping, and hotline scope. | Superseded |
| 2.4 | 2026-10-16 | Reviewer-driven full-stack planning detail: measurable outcomes, unified states, QR/SOS workflows, privacy/security governance, architecture alignment, test scenarios, delivery readiness, and traceability. | For institutional review; no implementation claimed |
| 2.5 | 2026-10-16 | Gap review aligned SOS schema/versioning and lifecycle, completed incident transitions and request examples, corrected the requirement traceability matrix to use all 26 actual IDs, and clarified attendance collection-group security/index scope. | Planning review; implementation not claimed |
