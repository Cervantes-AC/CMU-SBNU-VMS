# CMU–SBNU VMS Agent Guidance

This file applies to the Flutter application and repository-wide work. A more specific `AGENTS.md` applies within its directory. In particular, `prototype/AGENTS.md` governs the prototype only; treat `prototype/` as the visual and interaction reference for Flutter UI/UX.

## Product outcome

- The goal is a usable, end-to-end Flutter/Dart application, not a permanent prototype or a collection of preview screens. Use `docs/` as the requirements and delivery guide, and match the flows, layout, and visual language in `prototype/` while implementing them as native Flutter UI.
- Replace local synthetic preview implementations with working feature repositories and approved development Firebase/backend integrations as each feature is built. Keep synthetic data only in clearly labeled demo/sample paths and automated checks. Do not call a feature done while its primary user flow is preview-only.
- Implement in reviewable slices: working authentication/session and authorization foundation, then the approved core management workflows, then gated emergency workflows and release operations. For every slice, connect UI, state, validation, persistence/API, access control, failure/retry states, and its documented acceptance criteria.
- A functional release still respects institutional approval gates. Where an operational, privacy, security, or data decision is unresolved, keep that specific capability safely unavailable and visible as such; do not fake a successful action to make the app appear complete. Ordinary approved features should continue toward real functionality rather than staying mock-only.
- Maintain `docs/development-checklist.md` as the live implementation checklist and `docs/structure-redesign.md` as the target `lib/` layout and migration map. Update both as work lands; link implemented items to the relevant requirement IDs and verification evidence.

## Authority and project status

- Read the relevant files in `docs/specification/` and `docs/architecture.md` before changing a feature. The specification is the requirements source; architecture describes a proposed implementation approach. Check `docs/development-status.md` for current implementation boundaries.
- The planning baseline is proposed, not institutional approval. Treat requirements labeled proposed or for confirmation as open decisions. Do not present a proposed role matrix, workflow, provider, policy, or operational procedure as approved.
- Keep user-facing claims truthful about what is local, synthetic, connected, sent, delivered, or authorized. A screen or preview is not evidence of a production control or integration.
- The existing Firebase project `cmu-sbnu-vms` is approved for development use. This alone does not approve production data, region, identity providers, rules, or deployment. Keep real member and emergency data out of previews and unapproved environments.

## Architecture and ownership

- Keep the app a feature-first Flutter modular monolith. Use View → ViewModel → Repository → data source/service boundaries as appropriate; add domain/use-case policy where workflow complexity warrants it.
- Keep UI widgets focused on rendering and user actions. ViewModels own screen state and commands; repositories own feature data access and mapping; data sources adapt external APIs. Do not put Firestore paths, serialization, or authorization policy in widgets/ViewModels.
- Preserve feature ownership: `auth`, `access_control`, `organizations`, `volunteers`, `activities`, `attendance`, `announcements`, `incidents`, `sos`, `hotlines`, `reporting`, and `audit`. Share across features through documented public contracts; avoid dependency cycles and imports of another feature’s internals. Shared/core code must not depend on features.
- Use the established Provider/ChangeNotifier and GoRouter approach where it fits the existing code. Follow local naming, formatting, and design conventions. Use `prototype/` for visual direction, adapting it to the Flutter architecture and accessibility needs.
- Use `lib/app/` for bootstrap, dependency composition, routing, and theme; use `lib/core/` only for genuinely cross-cutting primitives; use `lib/shared/presentation/` only for reusable UI without feature policy. Put business UI, state, models, repositories, and data sources in the owning `lib/features/<feature>/` folder. Do not leave empty scaffold folders, duplicate feature logic, or let `lib/app.dart` become a container for routes, themes, and every feature dependency.
- Before adding a new folder or layer, make it serve real code in the current slice. Prefer the simplest layout that supports ownership and testing; add domain/application layers for complex policy and workflows, not as empty boilerplate. Migrate existing files in small steps and keep imports/build working at each step.
- Preserve explicit loading, empty, unavailable, error, and offline states. Provide a usable list alternative wherever a map is planned; do not make location permission a prerequisite for hotline access or location-optional workflows.

## Security, privacy, and safety boundaries

- Authentication establishes identity; it does not grant authorization. A hidden/disabled UI control is not an authorization boundary. Enforce access on trusted backend operations and Firestore Security Rules. Never permit self-promotion or client-controlled privilege changes.
- Keep Firestore rules deny-all until reviewed least-privilege rules and authorization tests are ready. Do not connect real data or weaken rules to make a screen work. Emulator use must be explicit with `--dart-define=USE_FIREBASE_EMULATORS=true`; never silently redirect ordinary builds to an emulator.
- Do not put secrets, service-account credentials, signing keys, or privileged server credentials in Flutter code or assets. Do not log passwords, tokens, incident narratives, precise location, or hotline verification secrets.
- QR codes are presentation of short-lived, activity-bound tokens, not reusable credentials. Do not implement attendance acceptance from client-side QR parsing alone. A trusted server must validate signature, expiry, activity state, participant eligibility, replay protection, and idempotency; server time is authoritative.
- SOS is not a public emergency-dispatch service. Until named responders, coverage, escalation/fallback procedures, training, and simulation are approved, keep it a clearly labeled local preview that cannot claim an alert was sent. Never broadcast sensitive alert details to all accounts. Production submission requires deliberate confirmation, trusted authorization, minimal payloads, an idempotent request key, and truthful delivery/unknown/failure states.
- Location is optional and workflow-specific, collected only after explicit permission and approved purpose/precision/retention. Do not add default or continuous background tracking, fake/sentinel coordinates, or location collection for ordinary attendance. Keep reporter identity and narrative out of map markers; restrict precise location and incident details to authorized reviewers.
- Hotline numbers and one-tap calling require institution-approved, current, verified entries. Unverified or expired entries must be visibly labeled and non-callable. A real call handoff requires final device confirmation.
- Restrict reports and exports to approved fields and scopes. Preview/export examples must remain synthetic; avoid unnecessary identifiers and sensitive details. Audit events must be restricted and append-only when implemented, not general analytics or editable history.
- For minors, sensitive profile data, attachments, notifications, retention, and privacy notices, follow the specification’s review gates; do not invent institutional policy or silently collect additional data.

## Development workflow

- Make changes in the owning feature and preserve existing user-visible disclosures. Update relevant documentation when implementation status or open decisions change.
- Before committing, inspect `git status` and stage only files belonging to the intended change. Do not stage generated platform plugin registrants/configuration as incidental build output.
- Format Dart changes with `dart format`. Use `flutter analyze --no-pub` for static checks when verification is needed. Do not add or run tests unless the user asks; when asked to implement a sensitive backend workflow, retain the specification’s required security and state-transition verification before treating it as ready.
- Never claim a feature, security control, institutional approval, or emergency operation is complete unless the corresponding implementation and review evidence exist.
