# Purpose Scope and Requirements

**Source:** `CMU_SBNU_Volunteer_Management_System_Documentation.docx`  
**Source status:** Planning baseline for review. Content below is transcribed and organized from the source; proposed requirements and controls are not represented as approved or implemented.


## 1. Executive Summary

CMU–SBNU is planning a volunteer management system for organizing volunteers, activities, attendance, communications, and operational reporting. The proposed product uses Flutter/Dart, Firebase services, and Cloud Firestore as its primary database. Final platform support, Firebase products, security design, costs, and operating procedures remain to be confirmed.

Initial scope includes volunteer management, attendance, activity management, organizational structure, announcements, reports and analytics, user roles and permissions, and QR-assisted attendance. Emergency scope adds SOS alert creation and authorized handling, incident reports with optional location, incident mapping, and an emergency hotline directory. One-tap calling is enabled only after institutional verification and approval of each number.

This is a planning baseline, not an implementation report. The decision register and readiness gates should be approved before development or production use.

## 2. Purpose, Status, and Use

### 2.1 Purpose

Use this package to agree on scope, responsibilities, requirements, data boundaries, workflows, and acceptance checks before implementation. It can guide design, estimation, procurement, and later user acceptance testing.

### 2.2 Planning conventions

**Table 02. 2.2 Planning conventions — Label / Meaning**

| Label | Meaning |
| --- | --- |
| For confirmation — | A policy, institutional owner, technical choice, or value needs an explicit decision. |
| Proposed | Candidate requirement or design for review; approve before treating as final. |
| Acceptance criterion | Condition to demonstrate and accept before the related release gate. |

### 2.3 Known inputs and limits

- Known: Flutter/Dart frontend, Firebase backend, Firestore database, and the selected features listed above.

- No repository, deployed Firebase project, approved role matrix, responder roster, hotline list, or production configuration was supplied for verification.

- No dates, budget, response-time promise, location provider, hotline number, or service-level target is assumed.

## 3. Scope and Boundaries

### 3.1 In-scope capabilities

**Table 03. 3.1 In-scope capabilities — Capability / Planning scope**

| Capability | Planning scope |
| --- | --- |
| Volunteer management | Onboarding, approved profile fields, organization membership, account review if needed. |
| Organizational structure | Represent approved units or organizations and coordinators. |
| Activity management | Create activities, schedules, venues, descriptions, capacity, and participation. |
| Attendance | Record, review, correct, and report attendance. |
| QR-assisted attendance | Use an approved QR workflow; token, expiry, and anti-reuse rules need design. |
| Announcements | Publish messages to approved audiences with author and time. |
| Reports and analytics | Summarize participation, attendance, service hours, and approved measures. |
| Roles and permissions | Restrict actions and sensitive data using an approved access matrix. |
| Incident reports and map | Submit/triage reports; map authorized location-bearing records with list alternative. |
| SOS alerts | Create urgent alert and route to designated, authorized handlers. |
| Emergency hotlines | Maintain verified contacts; one-tap calling only for approved verified entries. |
| Supporting administration | Public landing/contact page, user guidance, audit history, profile/settings, backup/restore, and import/export are supporting candidates for prioritization. |

### 3.2 Boundaries

- An in-app SOS alert does not contact public emergency services. No dispatch integration is included unless separately approved and designed.

- Do not claim guaranteed alert delivery or response; connectivity, device state, service availability, and staffing affect outcomes.

- Continuous background location tracking is outside this proposal. Location sharing is optional and workflow-specific.

- Supporting features not prioritized by the sponsor may be phased after the initial release.

For confirmation —  Approve first-release scope and identify which supporting capabilities are launch-critical.

## 4. Users and Permissions

Roles below are candidates retained from the project outline. CMU–SBNU must approve role names, account ownership, separation of duties, and the action-level permission matrix. A role must not automatically grant access to every record.

**Table 04. 4. Users and Permissions — Candidate role / Purpose / Candidate permissions**

| Candidate role | Purpose | Candidate permissions |
| --- | --- | --- |
| Administrator | Configure approved settings and manage accounts. | User/role administration, reference data, audit review, approved backup/export. |
| Officer / Coordinator | Coordinate activities and operations. | Assigned activities, participation, attendance, announcements, incidents/SOS only if designated. |
| Volunteer / Member | Participate and maintain own profile. | Eligible activities, own attendance, incident reports, SOS if policy permits. |
| Organization / Unit coordinator | Coordinate a recognized group. | Only group records explicitly permitted by the approved matrix. |

### 4.1 Permission principles

- Apply least privilege and scope records by organization, activity, or assigned response role.

- Separate account administration from incident handling when staffing permits.

- Enforce sensitive access at trusted service and Firestore-rule boundaries; client-side screen hiding is not security.

- For confirmation — registration approval, MFA requirement, suspension, recovery, and account removal policy.

Operational designations: responder, hotline verifier, announcement publisher, report analyst, incident reviewer, and audit reviewer are scoped assignments, not automatic system-wide roles. Store designation scope and expiry/active status; grant only the required operations.

Separation of duties: the person who creates or edits a hotline entry cannot verify that same entry. An administrator cannot grant themselves responder or incident-reviewer designation; a second authorized approver must approve and the change is audited.

## 5. Functional Requirements

These requirements describe intended behavior for review and do not claim implementation is complete.

**Table 05. 5. Functional Requirements — ID / Requirement / Decision / note**

| ID | Requirement | Decision / note |
| --- | --- | --- |
| AUTH-01 | Authenticate users using the approved account method; provide sign-out and recovery. | Confirm method and recovery owner. |
| AUTH-02 | Apply approved registration, review, activation, suspension, and deactivation. | Confirm states and authority. |
| AUTH-03 | Enforce permissions for every sensitive action and record. | Approve role/action matrix. |
| VOL-01 | Create and maintain volunteer profiles using only approved fields. | Confirm fields and retention. |
| VOL-02 | Associate volunteers with approved units or organizations. | Confirm hierarchy. |
| ACT-01 | Authorized staff can create, edit, publish, cancel, and close activities. | Confirm status and editors. |
| ACT-02 | Volunteers can view eligible activities and request participation. | Confirm capacity and approvals. |
| ATT-01 | Authorized staff record attendance against an activity and participant. | Confirm statuses and corrections. |
| ATT-02 | Volunteers view own attendance; coordinators see authorized scope. | Confirm visibility. |
| QR-01 | Authorized operators issue activity-specific QR attendance sessions. | Design expiry, session, replay rules. |
| QR-02 | A valid scan records participant, activity, time, and validation result. | Confirm check-in/out and duplicates. |
| ANN-01 | Authorized staff publish, target, update, and archive announcements. | Confirm audience and priorities. |
| REP-01 | Authorized users view reports for permitted organizations/date ranges. | Confirm catalog and access. |
| REP-02 | Summarize participation, attendance, and approved service hours. | Confirm calculations and exports. |
| ORG-01 | Authorized administrators maintain the approved unit structure. | Confirm hierarchy and coordinators. |
| INC-01 | Submit incident category, narrative, time, and optional location. | Confirm severity, files, privacy notice. |
| INC-02 | Authorized reviewers assign, update status, and record response notes. | Confirm workflow and handlers. |
| MAP-01 | Authorized viewers see location-bearing incidents on map and list. | Choose provider and precision. |
| SOS-01 | Permitted user deliberately creates an SOS alert and sees submission state. | Confirm activation safeguards. |
| SOS-02 | Route minimal alert notice only to designated authorized handlers. | Confirm roster and delivery method. |
| SOS-03 | Handlers acknowledge, assign, update status, and record resolution. | Confirm procedure. |
| HOT-01 | Show hotline label, number, coverage/availability, verification, review date. | Institution owns source list. |
| HOT-02 | Enable one-tap calling only for institution-verified, approved numbers. | Unverified/expired remains disabled. |
| ADM-01 | Keep an auditable record of sensitive administration and emergency actions. | Confirm access and retention. |
| ADM-02 | Provide approved backup/restore and import/export controls. | Confirm scope and recovery goals. |
| OPS-01 | Provide approved user guidance, settings, and support contacts. | Confirm owners. |
