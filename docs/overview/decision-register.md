# Decision Register

This register replaces references to missing decision/ADR files. “Proposed default” enables safe local work, not production approval. An AI agent may implement the default with synthetic/emulator data where the status allows it, but cannot mark an owner decision accepted.

| ID | Decision | Status | Proposed default | Required owner/evidence |
|---|---|---|---|---|
| D-01 | Ownership, distribution/license and internal/public repository status | OPEN | Internal/private; no license assertion | Repository owner + CMU sponsor; written distribution decision |
| D-02 | Product owner and operational service owner | OPEN | No production support promise | CMU sponsor names product owner, system owner, support contact |
| D-03 | Personal data inventory, purpose, lawful basis/notice, retention, correction/deletion | OPEN | Synthetic data only; data minimization | CMU data/privacy authority approval and retention schedule |
| D-04 | Firebase project identity for this app | DECIDED per target README | `cmu-sbnu-vms`; never use prototype `nsrc-vms` | Preserve target FlutterFire mapping; verify in dev bootstrap |
| D-05 | Production Firebase project ownership, billing account, region and IAM | OPEN | Use local emulator; do not deploy | Cloud/project owner provides project ID, region, billing, IAM/deploy operator |
| D-06 | Separate dev/staging/prod project names and alias policy | OPEN | Emulator for local; explicit aliases, never CLI default | Project owner approves IDs and environment table |
| D-07 | Registration, identity verification and initial admin provisioning | OPEN | No public registration/admin role choice; controlled synthetic accounts | Unit administrator signs process and trusted bootstrap procedure |
| D-08 | Final role definitions, officer assignment scope and organization persona | OPEN | member/officer/admin only; no organization role | Product owner approves role/permission matrix |
| D-09 | Exact profile fields and self-edit allowlist | OPEN | Minimum display name/contact only in synthetic schema | Data owner approves field-by-field purpose/readers/retention |
| D-10 | Attendance statuses, duration source, rounding, late/overnight/correction policy | OPEN | Do not label hours official until approved | Unit officer/product owner signs policy and examples |
| D-11 | Incident data, location consent, responder access, retention and response ownership | OPEN | Incident module disabled; no location tracking | Data/privacy owner + operational responder lead approval |
| D-12 | QR duty token, validation, offline behavior and replay policy | OPEN | QR feature disabled; server validation required | Security owner approves threat model and state/expiry rules |
| D-13 | Notifications, FCM/APNs setup, SOS semantics and delivery expectation | OPEN | Non-emergency notices only; no SOS claim | Unit and privacy owners define recipients, payload, failure UX |
| D-14 | Storage/image hosting provider and file policy | OPEN | No profile image upload; use initials/avatar placeholder | Owner approves provider, region, access, retention and size/type limits |
| D-15 | AI report generation and external processor/data transfer | OPEN | No AI processing of unit data | Product/privacy owner approves provider, data classes, consent, review |
| D-16 | Analytics/Crashlytics/telemetry collection and consent | OPEN | No personal data; disable optional telemetry until review | Privacy/security owner approves event list and retention |
| D-17 | Deployment targets and public hosting/domain | OPEN | Android/dev emulator first; no public deployment | Product owner approves platform list, domain, hosting and support |
| D-18 | Institutional names, marks, logo assets and publication rights | OPEN per target README | Do not publish current logo files until rights are confirmed | CMU brand owner approves named assets/use/context |
| D-19 | Offline access and local sensitive-data persistence | OPEN | Online writes only; cache non-sensitive published reads only if needed | Product/security owner approves offline scenarios, TTL/encryption/conflicts |
| D-20 | Backup, restore, RPO/RTO, retention and restore authority | OPEN | Use managed provider backup only after setup; no client dump/restore | Project owner/security owner approves plan and restore drill |
| D-21 | Accessibility, languages and supported browser/device matrix | OPEN | English, accessible Material defaults, Android + responsive web candidate | Product owner approves language/platform/device support |
| D-22 | Permission to store unit/volunteer data in target production project | OPEN per target README | No real data; synthetic data only | Institutional/data owner approval and documented project controls |
| D-23 | Initial product release scope and feature priority | PROPOSED | P0/P1 scope in PRODUCT_REQUIREMENTS.md; advanced tools deferred | Product owner accepts or amends requirements |
| D-24 | Git hosting, default/integration branch, PR approvals and release authority | OPEN | Never push/merge/deploy without explicit task authorization | Repository owner documents host, branch protection and approvers |
| D-25 | Official service-hours source of truth and correction authority | OPEN | Derived from approved event attendance, never client total | Unit officer + data owner approve and designate correction role |
| D-26 | Emergency hotline directory source and verification cadence | OPEN | Do not publish unverified contacts | Named owner validates contact numbers and review schedule |
| D-27 | Cloud Functions runtime and backend deployment generation | OPEN | Pin a runtime supported by selected Firebase project/Functions generation; no local “latest” assumption | Backend owner records runtime, region, generation, support window and CI version |

## Decision change procedure

1. Create/update an ADR in `docs/decisions/NNNN-short-title.md` for architectural/security decisions; product/data approvals may be recorded here with attached authoritative evidence.
2. Include context, options, chosen option, rejected options, consequences, owner, approval date, and affected requirement/data/rule IDs.
3. Update this table and all affected docs/config/tests in the same change.
4. Never retroactively mark a decision accepted based only on existing config, prototype behavior, silence or a successful build.

