# AI Coding Security and Privacy Rules

This guide applies to every agent edit, test fixture, generated artifact and handoff.

## Data minimization

- Collect only fields necessary for an approved workflow. Before adding a field, document purpose, sensitivity, source, authorized readers/writers, retention, deletion/export behavior and consent where relevant.
- Use synthetic data in local development. Do not copy records, screenshots, backups or logs from real environments into prompts, tests, issue descriptions or Git.
- Treat volunteer identity, contact details, location, attendance, incident reports, account state and device tokens as sensitive. Do not include them in analytics, crash reports, URLs, logs or push payloads.
- Clear or isolate user-scoped caches on sign-out, account change, disablement and profile deletion. Avoid persisting sensitive data locally unless an approved offline use case defines encryption, TTL and purge behavior.

## Authorization

- Default deny in Firestore/Storage rules. For every operation validate auth, account approval/status, role, ownership, allowed fields, value types/limits and resource state.
- Prevent self-escalation: clients cannot set `role`, `status`, actor UID, audit time, service hours, responder identity or trusted QR validation result.
- The backend derives actor identity from verified authentication. Client role/UID parameters are selectors at most, never proof of authority.
- Use field allowlists and immutable-field checks. Keep private incident detail separate from broadly visible summaries.
- Unit/widget tests do not replace Firebase Emulator Suite security tests. Include cross-user and denied-role cases.

## Secrets and external services

- Firebase client IDs/config values are not server secrets, but service-account keys, signing keys, private API keys, access tokens and credentials are secrets.
- Keep secrets in the approved secret manager or CI identity, never Dart code, web assets, Git, prompts, crash logs, command output or `--dart-define` in distributed apps.
- Third-party AI, image, mapping, analytics or messaging services need an approved data-flow review. Keep provider keys server-side and send the minimum necessary data.
- Verify external links, deep links, file names, CSV/PDF content, QR payloads and notification payloads as untrusted input.

## High-risk features requiring separate approval

Do not implement or enable the following without approved requirement, data owner, threat model and operational plan:

- public incident/live location map, persistent or background location tracking;
- SOS broadcast claiming emergency-service dispatch or guaranteeing delivery;
- arbitrary database/query console, user impersonation, client database editor;
- bulk export or backup download containing personal records;
- restore/delete/role changes with broad impact;
- AI processing of member, attendance or incident information;
- public signup that captures sensitive fields or grants access before review;
- use of real data or deployment to a production backend.

## Secure implementation checklist

Before closing a data-affecting task, inspect for: privilege escalation, cross-user IDOR, public read path, stale token/session access, replay/duplicate writes, unbounded query/file/batch, injection in rich text/CSV/PDF, malicious upload, sensitive log/exception, insecure cache, notification leakage, insecure redirect/deep link, and overly broad IAM. Record which checks apply and their evidence in review.

## Incident handling

If an agent discovers a credential, personal data, or possible security defect in the workspace, do not repeat it in chat or logs and do not commit it. Stop operations that would expose it, identify affected file/location in minimal terms, and notify the user with recommended containment. Do not attempt production remediation or contact third parties unless explicitly authorized.

