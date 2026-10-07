# Feature File Specifications

Feature screens compose the shared shell, feature controller and repository contracts from [data.md](data.md). Keep each screen's responsibilities narrow. Unless a feature is approved for an initial release, defer it explicitly instead of building an unreviewed high-risk tool. The module names below correspond to the scaffold's `lib/features/*/TODO.md` folders.

## Standard shape for a feature

For a module with non-trivial asynchronous behavior, create `<feature>_screen.dart`, `<feature>_controller.dart`, and focused `widgets/` files. The controller exposes immutable view state (loading/data/empty/error and operation state), listens to the repository, exposes user-intent methods, and disposes subscriptions. The screen renders that state and invokes methods. A simple read-only/help screen may use one screen file. Do not add controller/model files that merely rename repository calls.

## Identity and daily operations

### `lib/features/auth/`

**Files:** `auth_screen.dart` (`AuthScreen`), `auth_controller.dart` (`AuthController`, immutable `AuthViewState`), optional `widgets/sign_in_form.dart`, `widgets/registration_form.dart`, `widgets/password_reset_form.dart` when registration/reset complexity needs separation.

**Controller API:** `signIn(email,password)`, `sendPasswordReset(email)`, optional approved `submitRegistration(RegistrationDraft)`, `clearMessage()`. State includes submitting, validation errors, safe failure category, and success/verification/pending status. Never retain password after request.

**Screen contract:** sign-in, reset, and registration only if institution-approved; clear explanation of pending approval; no self-service role selection. Must handle keyboard, autofill, text scaling, retry and disabled accounts. It delegates auth to `AuthRepository` and profile gating to app session state.

**Tests:** valid/invalid input, duplicate submission, password reset generic response, pending-account routing, auth failure, no role choice, password not retained.

### `lib/features/dashboard/`

**Files:** `dashboard_router.dart` (`DashboardRouter` chooses by approved `UserRole`), `member_dashboard.dart`, `officer_dashboard.dart`, `admin_dashboard.dart`, optional `organization_dashboard.dart` only after this persona is approved, `dashboard_controller.dart` for cross-repository loading, `widgets/dashboard_summary_card.dart`, `widgets/dashboard_quick_action.dart` only when reused.

**Contract:** show only metrics/actions whose source repositories authorize the viewer. Member: own upcoming items/hours/announcements; officer: authorized event queue/attendance/incidents; admin: aggregate account and operations status. No dashboard may fetch an entire collection or expose sensitive incident text in a card. Each card has a destination gated by shared route metadata.

**Tests:** role-specific content, pending user denied, unavailable data/error, empty state, no cross-role leakage, responsive mobile/wide layouts.

### `lib/features/profile/`

**Files:** `profile_screen.dart`, `profile_controller.dart`, `profile_edit_form.dart`, optional `profile_avatar.dart` (only if approved avatar upload is implemented).

**Controller API:** `load(uid)`, `save(ProfilePatch)`, optional `selectAvatar()`/`uploadAvatar()` only after storage provider/privacy approved. Form fields derive from approved `UserProfile` field allowlist. Exclude role/status/UID/email changes unless explicitly authorized workflow. On save, refresh current session profile and invalidate cache.

**Tests:** self-only profile, allowlisted fields, disallowed-field rejection, partial failure, avatar cancellation/size/type if supported, signed-out cache clear.

### `lib/features/events/`

**Files:** `events_screen.dart`, `events_controller.dart`, `event_detail_screen.dart`, `event_form.dart`, `widgets/event_card.dart`, `widgets/event_filter_bar.dart` only if needed.

**Controller API:** paged `loadNextPage(filter)`, `refresh()`, `loadDetail(id)`, `create(draft)`, `update(id,draft)`, `cancel(id)`, `requestToJoin(id)` according to role. Event form validates start < end, required title/venue, approved capacity and audience limits. Lifecycle transitions use `Event` policy. Do not store attendees/join requests as unbounded event arrays.

**Tests:** paging, filters, valid/invalid interval, member cannot manage event, duplicate join request, transition rejection, canceled/completed visibility, error and stale states.

### `lib/features/announcements/`

**Files:** `announcements_screen.dart`, `announcements_controller.dart`, `announcement_detail_screen.dart` if deep-linkable, `announcement_form.dart` for staff, `widgets/announcement_card.dart` if useful.

Render published/current announcements filtered by the viewer audience. Staff draft/create/edit/publish actions are hidden by UI policy and denied in repository/rules if unauthorized. Validate title/body lengths, priority and publication/expiry. Mark urgent priority accessibly; color alone is insufficient.

**Tests:** audience filtering, draft invisibility, expiration, unauthorized publishing denial, form bounds and error states.

### `lib/features/attendance/`

**Files:** `attendance_screen.dart` (authorized event roster), `member_attendance_screen.dart` (own history), `attendance_controller.dart`, `widgets/attendance_member_row.dart`, `widgets/attendance_status_picker.dart`, `widgets/attendance_summary.dart` only where reusable.

Officer flow selects event, loads paginated/appropriate roster, records allowed status, sees save/conflict state, and submits correction with reason if policy allows. Member flow is read-only. Hours are calculated from validated attendance/duty facts; no direct edit field for total hours. Protect against a second tap/retry duplicating a record.

**Tests:** member cannot mark attendance, officer scope check, duplicate prevention, corrected record audit, hour boundaries, event selection, offline/failed write state.

## Sensitive field operations

### `lib/features/qr_duty_monitoring/`

**Files:** `qr_duty_scanner_screen.dart`, `qr_code_generator_screen.dart`, `duty_monitoring_screen.dart`, `qr_duty_controller.dart`, `widgets/scan_permission_prompt.dart` if needed.

Member scanner requests camera permission after explanation, accepts only the documented opaque payload, submits it to trusted validation, provides accepted/rejected/expired/offline states, and prevents duplicate scanner callbacks. Officer generator creates a time-bound event session through the trusted service and renders printable QR without PII. Monitor uses authorized paged scans and distinguishes server receipt from pending local intent. No client-side secret signing or trust in device clock.

**Tests:** malformed/expired/replayed/cross-event/duplicate scans, camera denied, no PII in encoded contents, duplicate camera callback, session close, network unavailable. Security tests must run against the emulator/function, not only mocked repository.

### `lib/features/incidents/`

**Files:** `incidents_screen.dart`, `incidents_controller.dart`, `incident_report_form.dart`, `incident_detail_screen.dart`, `widgets/incident_card.dart`, `widgets/incident_filter_bar.dart`, `widgets/incident_location_consent.dart`, `widgets/sos_action.dart` if SOS is approved.

Reporter submits a minimal categorized report; location is optional and separately consented. Responder queue/detail/action uses a separate privileged repository API. Detail visibility is reporter/responders only; broad dashboards show minimum necessary summary. State transitions and notes follow policy and are audited. SOS confirmation states exactly who is notified, whether delivery is acknowledged, and what to do if it fails; no false claim that emergency services were dispatched. Do not show public live tactical map by default.

**Tests:** no-location path, consent revocation, location failure, access denial for unrelated user, legal transition, audit and notification failure, SOS duplicate/retry, sensitive text absent from logs.

### `lib/features/emergency_hotlines/`

**Files:** `emergency_hotlines_screen.dart`, optional `hotline_directory.dart`/model only if data source grows.

Display a small owner-verified directory from approved static config or secured backend, with display name, service area, phone, verified-at/source metadata. Call/SMS actions use platform adapters and clearly show the number before handoff. Do not imply the app or unit is continuously monitoring calls.

**Tests:** only approved contacts rendered, safe URI handling, unavailable platform fallback, external action confirmation.

## Oversight and records

### `lib/features/user_management/`

**Files:** `user_management_screen.dart`, `user_management_controller.dart`, `widgets/user_list.dart`, `widgets/user_filter_bar.dart`, `widgets/account_review_panel.dart`, `widgets/user_edit_form.dart`, `widgets/role_change_dialog.dart`.

Limit to authorized admin task set. Provide paginated pending/reviewed accounts, inspect only approved profile fields, approve/deny with reason if policy requires, and change roles with explicit confirmation/step-up auth if required. Mutations use trusted backend endpoint and return refreshed auth/profile state. No user impersonation in production scope. Never expose credentials or reset another user's password in client UI.

**Tests:** member/officer denied, pending list pagination, role escalation blocked, admin actor audit, denied-account routing, simultaneous review conflict, no impersonation path.

### `lib/features/audit_logs/`

**Files:** `audit_logs_screen.dart`, `audit_logs_controller.dart`, `widgets/audit_filter_bar.dart`, `widgets/audit_entry_tile.dart`, optional `audit_export.dart` only after export approval.

Read-only paginated log view with filters on allowlisted action/entity/date/actor fields. Minimize displayed before/after values; omit incident narrative, credentials and raw payload. Export requires separate permission, field projection, confirmation and audit event.

**Tests:** access matrix, immutable behavior/no write calls, pagination, filter constraints, redacted fields, export policy.

### `lib/features/analytics/`

**Files:** `analytics_screen.dart`, `analytics_controller.dart`, `widgets/metric_card.dart`, `widgets/time_series_chart.dart` if charts are approved.

Use bounded aggregate queries or trusted precomputed aggregates; do not read all source documents to calculate totals in the client. Define each metric, source, freshness, date interval/timezone and minimum cohort/privacy treatment. Role-filter each metric. Handle insufficient data, delayed aggregates and chart accessibility with textual summary.

**Tests:** aggregate calculations, date/timezone boundary, viewer access, no small-cohort disclosure where relevant, empty/error/stale display.

### `lib/features/reports/`

**Files:** `reports_screen.dart`, `reports_controller.dart`, `report_filter_form.dart`, `report_preview.dart`, `report_export_action.dart`.

Only approved report types/columns and bounded dates. Build a preview before file generation, display data period and generation timestamp, and separate generated report content from AI text. Audit export. Sanitize CSV formula-leading cells and filenames. Export respects role visibility and does not bypass paging/authorization.

**Tests:** filter limits, access matrix, timezone boundaries, CSV injection, empty dataset, cancellation, export audit.

### `lib/features/accomplishment_reports/`

**Files:** `accomplishment_report_screen.dart`, `accomplishment_report_controller.dart`, `accomplishment_report_template.dart`, `accomplishment_report_preview.dart`.

Manual officer workflow per scaffold: choose approved reporting period/template, show source metrics and values, draft narrative, allow review/edit, retain author/reviewer and export only through approved report service. Keep source values distinguishable from manually written text. AI generation is not implied by this feature and requires a separate decision/service/key/privacy review.

**Tests:** template required sections, period boundaries, source-metric provenance, review state, permission check and export sanitation.

## Administration and import tools (separate approval gates)

### `lib/features/import_export/`

**Files:** `import_export_screen.dart`, `import_export_controller.dart`, `import_preview.dart`, `import_validator.dart`, `export_options_form.dart`.

Import defaults off until approved. Accept only documented formats/schema, impose file/row/field bounds, validate every row, show dry-run preview and exact create/update/skip counts, require authorized confirmation, use bounded batches/idempotency, and provide failure report/recovery. Export uses allowlisted columns and records who exported what scope. Reject formulas/macros where applicable; treat imported text as hostile.

**Tests:** malformed/oversized file, duplicate IDs, partial batch, rollback/retry, unauthorized role, CSV formula injection, no unapproved fields.

### `lib/features/backup/`

**Files:** `backup_management_screen.dart`, `backup_controller.dart`, `backup_policy_summary.dart`.

Do not build an app-managed “restore everything” button as a substitute for managed Firestore backup. If formally approved, show only trusted backup metadata, enforce separate export/restore permissions and step-up confirmation, show target environment, create immutable audit records and require a restore drill/rollback plan. Never download a service account key or broad database dump to a client.

**Tests:** unauthorized access, production environment mismatch, restore confirmation, audit, interrupted workflow and recovery state.

### `lib/features/database_management/`

**Files:** `database_management_screen.dart`, `database_management_controller.dart`, `widgets/collection_summary.dart`.

Initial production recommendation: defer or omit arbitrary collection browsing/mutation. If an approved narrow admin view exists, expose a fixed set of purpose-built aggregate/record views, never arbitrary collection names, raw document editing, query strings, or unbounded scans. Read-only by default; mutations belong in explicit domain features.

**Tests:** allowlisted data only, pagination, no arbitrary path input, admin authorization and no write path.

### `lib/features/admin_queries/`

**Files:** `admin_queries_screen.dart`, `admin_queries_controller.dart`, `saved_query_catalog.dart` if a fixed catalog is approved.

Do not execute user-authored Firestore queries or SQL from the client. If admins need reports, provide a fixed query catalog with parameter validation, permission-reviewed fields, bounded result size and audit. Default state is deferred pending approved use case/threat model.

**Tests:** arbitrary query rejection, parameter bounds, role denial, bounded result and audit.

### `lib/features/data_controls/`

**Files:** `data_table_widget.dart` (or `data_table_controls.dart`) with typed `DataColumnSpec`, `SortSpec`, `FilterSpec`, `PageState`.

Reusable presentation behavior only: sortable/filterable columns from an allowlisted feature configuration, responsive table/list mode, pagination and accessible headers. It must not issue Firestore queries, invent field names, bypass permission, or stringify sensitive objects. Feature repository supplies typed pages.

**Tests:** sorting, stable pagination, filter semantics, responsive view, semantic header and no query dependency.

## Public and support experiences

### `lib/features/landing/`

**Files:** `landing_page.dart`, optional `parts/landing_hero.dart`, `parts/landing_about.dart`, `parts/landing_programs.dart`, `parts/landing_contact_form.dart`, `parts/landing_footer.dart` when approved brand/content is supplied.

Public-safe content only. Institutional name, logos, program claims, contact details and links require owner approval. Contact form includes data-use notice, validation, abuse/rate limit at backend and no public list access. Do not link directly into protected record IDs. Ensure responsive layouts, text scaling, keyboard navigation and search/metadata if web is deployed.

The current implementation is limited to a static concept preview shown as the local app home through `NSRCApp`. At the user's request, it displays the repository CMU and SBNU logo assets locally using contained image rendering and accessible labels. It does not access Firebase or personal data and has no sign-in, contact, or external-link actions. This local preview does not approve public content or logo publication: replace the temporary root behavior with the approved signed-out/auth flow, and keep public routing/publication gated on D-17/D-18. Confirm supported device/browser and accessibility scope under D-21.

**Tests:** no private data in public tree, form validation, failed submit, responsive widths and external link handling.

### `lib/features/user_guide/`

**Files:** `user_guide_screen.dart`, `guide_content.dart` (typed local content with role tags), optional `guide_search.dart` if substantial.

Provide versioned help instructions matching shipped behavior. Filter content to the viewer's role, make search local and bounded, include support contact only after verification, and include explicit limitations for SOS/offline behavior. Do not promise features that are not implemented.

**Tests:** role filtering, search, empty result, every guide route resolves and content version is visible.

### `lib/features/settings/`

**Files:** `settings_screen.dart`, `settings_controller.dart`, `sections/profile_settings_section.dart`, `sections/notification_settings_section.dart`, `sections/accessibility_settings_section.dart`, `sections/account_security_section.dart`, `sections/about_section.dart` as relevant.

Only expose settings that are implemented and supported. Preferences are namespaced per user/device as appropriate. Notification permission state reflects OS settings; it does not promise delivery. Account deletion/deactivation/security changes must use approved workflows. Do not place provider API key inputs in the client for production AI integrations.

**Tests:** preference persistence/reset, sign-out clears scoped state, OS permission denied, route access and build/version information.

### `lib/features/warning_system/`

**Files:** `warning_dialogs.dart` (`WarningDialog`/`ConfirmDialog`) and optional `soft_delete_mixin.dart` only if approved soft-delete policy exists.

Provide explicit, accessible confirmation for destructive actions, describing the target and whether the action can be undone. The widget does not perform deletion. A soft-delete mixin must not be a generic client-side override; define retention, restoration rights, server timestamp/actor, filtering and audit behavior in the data contract before adding it.

**Tests:** cancel performs no callback, confirm runs once, keyboard/screen-reader semantics, destructive wording and no accidental dismiss when required.

## Document/PDF output

### `lib/features/pdf_generation/`

**Files:** `pdf_document_service.dart` (pure layout/data projection), `pdf_generation_controller.dart` only if async state needs coordination.

PDF generation is a reusable output adapter, not a second source of report policy. Accept a typed authorized report view model rather than raw database data. Bound page/row count, escape untrusted text, handle long text/page breaks, include generation timestamp and approved branding only, and return a file/share result with cancellation/error states. Keep platform printing/sharing behind an adapter. Do not embed secrets or unsupported fonts/assets.

**Tests:** text escaping, long content pagination, empty report, cancellation and data projection contains only authorized fields.
