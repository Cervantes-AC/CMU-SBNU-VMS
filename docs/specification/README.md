# CMU SBNU Specification Markdown Set

**Purpose:** Topic-based Markdown transcription of the supplied planning specification. The source DOCX is preserved unchanged.

**Status:** The source calls itself a proposed planning baseline for review. Its requirements, architecture, roles, operational controls, and readiness criteria are not proof of approval, deployment, or completion.

## Source document control

CMU–SBNU

Volunteer Management System

Planning Baseline and Requirements Package

PLANNING STAGE  •  VERSION 2.5 REVIEWED FULL-STACK SPECIFICATION  •  16 OCTOBER 2026

STATUS  Proposed scope and requirements for review. No software, integration, security control, institutional approval, or emergency operation is represented as complete.

**Table 01. Project tables — Document control / Value**

| Document control | Value |
| --- | --- |
| Project | CMU–SBNU Volunteer Management System (NSRC VMS) |
| Audience | CMU–SBNU sponsor, unit leadership, coordinators, technical team, privacy/security reviewers |
| Document owner | To be confirmed |
| Approval status | Draft for planning review |
| Known technology direction | Flutter/Dart client; Firebase backend; Cloud Firestore database |
| Next gate | Approve scope, roles, emergency operations, privacy requirements, and feasibility |

Purpose: establish a shared, reviewable baseline before design and implementation. Unresolved local or technical decisions are marked For confirmation —.

## Section map

| Source section | Extracted Markdown section |
| --- | --- |
| 1. Executive Summary | [01-purpose-scope-and-requirements.md](./01-purpose-scope-and-requirements.md#1-executive-summary) |
| 2. Purpose, Status, and Use | [01-purpose-scope-and-requirements.md](./01-purpose-scope-and-requirements.md#2-purpose-status-and-use) |
| 3. Scope and Boundaries | [01-purpose-scope-and-requirements.md](./01-purpose-scope-and-requirements.md#3-scope-and-boundaries) |
| 4. Users and Permissions | [01-purpose-scope-and-requirements.md](./01-purpose-scope-and-requirements.md#4-users-and-permissions) |
| 5. Functional Requirements | [01-purpose-scope-and-requirements.md](./01-purpose-scope-and-requirements.md#5-functional-requirements) |
| 6. Emergency Workflows | [02-emergency-and-product-design.md](./02-emergency-and-product-design.md#6-emergency-workflows) |
| 7. Proposed Architecture | [02-emergency-and-product-design.md](./02-emergency-and-product-design.md#7-proposed-architecture) |
| 8. Data Model | [02-emergency-and-product-design.md](./02-emergency-and-product-design.md#8-data-model) |
| 9. Screen Inventory | [02-emergency-and-product-design.md](./02-emergency-and-product-design.md#9-screen-inventory) |
| 10. Security and Privacy | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#10-security-and-privacy) |
| 11. Notifications, Offline Use, and Operations | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#11-notifications-offline-use-and-operations) |
| 12. Quality Requirements | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#12-quality-requirements) |
| 13. Verification Plan | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#13-verification-plan) |
| 14. Acceptance Criteria | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#14-acceptance-criteria) |
| 15. Risks and Mitigations | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#15-risks-and-mitigations) |
| 16. Milestones and Readiness Gates | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#16-milestones-and-readiness-gates) |
| 17. Decision Register | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#17-decision-register) |
| 18. Glossary and References | [03-security-quality-and-governance.md](./03-security-quality-and-governance.md#18-glossary-and-references) |
| 19. Client Application Design | [04-client-and-backend-design.md](./04-client-and-backend-design.md#19-client-application-design) |
| 20. Backend Operations and API Contracts | [04-client-and-backend-design.md](./04-client-and-backend-design.md#20-backend-operations-and-api-contracts) |
| 21. Firestore Schema and Query Plan | [05-firestore-and-authorization.md](./05-firestore-and-authorization.md#21-firestore-schema-and-query-plan) |
| 22. Authorization and Security Rules Matrix | [05-firestore-and-authorization.md](./05-firestore-and-authorization.md#22-authorization-and-security-rules-matrix) |
| 23. SOS and Incident State Machines | [06-workflows-deployment-and-operations.md](./06-workflows-deployment-and-operations.md#23-sos-and-incident-state-machines) |
| 24. Environments, Deployment, and Release | [06-workflows-deployment-and-operations.md](./06-workflows-deployment-and-operations.md#24-environments-deployment-and-release) |
| 25. Observability, Backup, and Recovery | [06-workflows-deployment-and-operations.md](./06-workflows-deployment-and-operations.md#25-observability-backup-and-recovery) |
| 26. Repository and CI/CD Plan | [06-workflows-deployment-and-operations.md](./06-workflows-deployment-and-operations.md#26-repository-and-cicd-plan) |
| 27. Full-Stack Traceability and Open Decisions | [06-workflows-deployment-and-operations.md](./06-workflows-deployment-and-operations.md#27-full-stack-traceability-and-open-decisions) |
| 28. Official Technical References | [06-workflows-deployment-and-operations.md](./06-workflows-deployment-and-operations.md#28-official-technical-references) |
| 29. Field-Level Data Dictionary | [07-data-dictionary-and-api-examples.md](./07-data-dictionary-and-api-examples.md#29-field-level-data-dictionary) |
| 30. Request and Response Examples | [07-data-dictionary-and-api-examples.md](./07-data-dictionary-and-api-examples.md#30-request-and-response-examples) |
| 31. Delivery Backlog and Definition of Done | [08-delivery-and-acceptance.md](./08-delivery-and-acceptance.md#31-delivery-backlog-and-definition-of-done) |
| 32. Problem Framing, Outcomes, and Release Boundaries | [08-delivery-and-acceptance.md](./08-delivery-and-acceptance.md#32-problem-framing-outcomes-and-release-boundaries) |
| 33. Detailed Operational Workflows and Safety Rules | [08-delivery-and-acceptance.md](./08-delivery-and-acceptance.md#33-detailed-operational-workflows-and-safety-rules) |
| 34. Privacy, Security, Operations, and Delivery Readiness | [08-delivery-and-acceptance.md](./08-delivery-and-acceptance.md#34-privacy-security-operations-and-delivery-readiness) |
| 35. Acceptance Criteria and Verification Scenarios | [08-delivery-and-acceptance.md](./08-delivery-and-acceptance.md#35-acceptance-criteria-and-verification-scenarios) |
| 36. Glossary, Decisions, and Traceability | [09-glossary-traceability-and-references.md](./09-glossary-traceability-and-references.md#36-glossary-decisions-and-traceability) |
| 37. Requirement Traceability Matrix | [09-glossary-traceability-and-references.md](./09-glossary-traceability-and-references.md#37-requirement-traceability-matrix) |
| 38. Reference Sources and Revision History | [09-glossary-traceability-and-references.md](./09-glossary-traceability-and-references.md#38-reference-sources-and-revision-history) |

## Source fidelity notes

- Original section numbering, requirement identifiers, status labels, field names, examples, and tables are retained wherever possible.
- Table captions and headers come from the source. Line breaks inside cells are represented with `<br>`.
- The full source remains available at [`../CMU_SBNU_Volunteer_Management_System_Documentation.docx`](../CMU_SBNU_Volunteer_Management_System_Documentation.docx).
- Treat statements marked proposed, candidate, recommended, or for confirmation as open planning material until an authorized owner records a decision.
