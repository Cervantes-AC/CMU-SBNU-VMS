# SBNU Application Project

**CMU – SBNU Volunteer Management System (NSRC VMS)**

A full-stack volunteer operations platform built with **Flutter** (mobile + web) and **Firebase** (Auth, Firestore, Cloud Messaging, Storage, Crashlytics, Cloud Functions, Hosting). It handles volunteer operations, attendance, QR-based duty monitoring, incident reporting, SOS alerts, rankings, announcements, analytics, AI-assisted accomplishment reports, and complete user administration for the CMU School-based NSRC Unit.

> **Package name:** `cmu_nsrc_app`
> **Version:** `1.0.0+1`
> **Firebase project:** `nsrc-vms`
> **Android application ID:** `com.nsrc.nsrc_vms`

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Technology Stack](#2-technology-stack)
3. [System Architecture](#3-system-architecture)
4. [Project Structure](#4-project-structure)
5. [Core Application Layer](#5-core-application-layer)
6. [Data Layer](#6-data-layer)
7. [Features](#7-features)
8. [Roles & Access Control](#8-roles--access-control)
9. [Firestore Security Rules](#9-firestore-security-rules)
10. [Cloud Functions (Backend)](#10-cloud-functions-backend)
11. [Offline-First & Caching](#11-offline-first--caching)
12. [Notifications & SOS Alerts](#12-notifications--sos-alerts)
13. [Seed Scripts](#13-seed-scripts)
14. [Testing](#14-testing)
15. [Deployment](#15-deployment)
16. [Getting Started](#16-getting-started)
17. [Quality Checks](#17-quality-checks)
18. [Documentation](#18-documentation)
19. [Recent Changes](#19-recent-changes)
20. [Known Notes & Caveats](#20-known-notes--caveats)

---

## 1. Project Overview

The **SBNU Volunteer Management System (NSRC VMS)** is a mobile-first and web-capable application that centralizes volunteer operations for the CMU School-based NSRC Unit. It was built against a numbered requirements list (references like `Req 3`, `Req 4`, `Req 11`–`Req 22` are embedded throughout the code) and provides four personas with tailored experiences:

| Persona | Experience |
|---|---|
| **Member** | Personal service hours, duty QR scanning, upcoming events, emergency alerts, incident reporting |
| **Officer** | Operations management, event & attendance handling, QR duty creation/monitoring, incident response, mission reports |
| **Admin / Super Admin** | Full system control: user management, analytics, audit logs, database browsing, backup/restore, import/export, announcements, incident review |
| **Organization** | Incident live feed and an embedded tactical map view |

The app is **offline-first**: repositories cache to Hive, Firestore offline persistence is enabled, and a `SyncService` reconciles data when connectivity returns.

---

## 2. Technology Stack

### Frontend (Flutter)
| Area | Technology |
|---|---|
| Framework | Flutter (Dart SDK `^3.10.8`) |
| State management | `provider` (`6.1.5`) — `MultiProvider` + `ChangeNotifier` |
| Routing | `go_router` (`14.8.1`) plus a named-route table in `app.dart` |
| Local caching | `hive` / `hive_flutter` (`2.2.3`) + `shared_preferences` (`2.5.5`) |
| Maps | `flutter_map` + `latlong2` (OpenStreetMap tiles — **no API key**) |
| Location | `geolocator` (`13.0.2`) |
| Audio (SOS alarm) | `audioplayers` (`6.6.0`) |
| Local notifications | `flutter_local_notifications` (`18.0.1`) |
| QR scanning / generation | `mobile_scanner` (`6.0.2`) / `qr_flutter` (`4.1.0`) |
| PDF export / printing | `pdf` (`3.11.1`) / `printing` (`5.13.4`) |
| Charts | `fl_chart` (`0.69.2`) |
| Image picking / upload | `image_picker` (`1.1.2`) + Cloudinary |
| Connectivity | `connectivity_plus` (`6.1.4`) |
| Network / crypto | `http` (`1.2.2`), `crypto` (`3.0.7`), `uuid` (`4.5.3`), `intl` (`0.19.0`) |
| Markdown | `flutter_markdown` (`0.7.6`) |
| Images | `cached_network_image` (`3.4.1`), `google_fonts` (`8.1.0`) |

### Backend (Firebase)
| Service | Purpose |
|---|---|
| **Firebase Auth** | Email/password sign-in, rate-limited, with MFA hooks |
| **Cloud Firestore** | Primary database — realtime streams, offline persistence |
| **Cloud Functions** | Incident broadcast (FCM), notification dispatch, scheduled cleanup/retry (Node 20, TypeScript) |
| **Cloud Messaging (FCM)** | Push notifications incl. SOS alarm sound |
| **Cloud Storage / Cloudinary** | Image uploads (profile photos) |
| **Crashlytics** | Error reporting — all uncaught errors are routed here |
| **Firebase Hosting** | Flutter web deployment with hardened security headers |
| **Cloudinary** | Signed image uploads for avatars/photos |

### Tooling
- Firebase CLI + Emulator Suite (for rules/function local testing)
- `kiri_check` — property-based testing
- `fake_cloud_firestore`, `firebase_auth_mocks`, `mock_exceptions` — Firebase fakes for unit tests
- `flutter_launcher_icons` — launcher icon generation
- Node scripts (`seed/`) for populating mock member data

---

## 3. System Architecture

The project follows a **layered / clean-ish architecture** with clear separation of concerns:

```
┌────────────────────────────────────────────────────────────────┐
│                         UI Layer (lib/features)                │
│   Screens + widgets, organized by feature (auth, dashboard,    │
│   events, incidents, attendance, reports, settings, admin…)    │
└───────────────────────────────┬────────────────────────────────┘
                                │
┌───────────────────────────────▼────────────────────────────────┐
│                 Shared Layer (lib/shared + core/utils)         │
│   AppShell, RouteGuard, Result<T>, status helpers, widgets     │
│   AuditLogger, validators, responsive scaling, transitions     │
└───────────────────────────────┬────────────────────────────────┘
                                │
┌───────────────────────────────▼────────────────────────────────┐
│               Data Layer (lib/data)                            │
│   ┌────────────┐   ┌──────────────┐   ┌────────────────────┐   │
│   │ Interfaces │──▶│ Repositories │──▶│ Services            │   │
│   │ (10 DI     │   │ (7, cached,  │   │ (Auth, Firestore,  │   │
│   │  contracts)│   │  offline-    │   │  Notifications,    │   │
│   │            │   │  first,      │   │  Location, Groq,   │   │
│   │            │   │  Result<T>)  │   │  MFA, Backup,      │   │
│   │            │   │              │   │  Import/Export,    │   │
│   │            │   │              │   │  Reports…)         │   │
│   └────────────┘   └──────────────┘   └────────────────────┘   │
└───────────────┬────────────────────────────────────────────────┘
                │
┌───────────────▼────────────────────────────────────────────────┐
│           Core Infrastructure (lib/core)                       │
│   CacheService (Hive + TTL), ConnectivityService, SyncService, │
│   Theme, AppConstants/Colors, utils                            │
└───────────────┬────────────────────────────────────────────────┘
                │
┌───────────────▼────────────────────────────────────────────────┐
│                 Firebase Backend                               │
│   Firestore (+ rules) · Auth · FCM · Cloud Functions ·        │
│   Hosting · Storage/Cloudinary · Crashlytics                   │
└────────────────────────────────────────────────────────────────┘
```

### Key design principles
- **Dependency injection via interfaces** — all services/repositories implement pure-Dart contracts under `lib/data/interfaces/`, enabling fakes in tests.
- **Offline-first** — repositories are `ChangeNotifier`-based, cache to Hive with TTL, and return `sealed Result<T>` (`Success`/`Failure`) for predictable error handling.
- **Realtime-first** — `FirestoreService` is the single gateway exposing realtime streams for every collection.
- **Role-aware** — the UI, routing (`RouteGuard`), and backend rules all enforce role/feature permissions.
- **Auditable** — destructive and important actions write append-only `auditLogs`.

---

## 4. Project Structure

```
nsrc_vms/
├── lib/                          # Flutter application source
│   ├── main.dart                 # Bootstrap: Hive, Firebase, Crashlytics, runApp
│   ├── app.dart                  # Root NSRCApp, DI (MultiProvider), routes, splash router
│   ├── firebase_options.dart     # Per-platform Firebase options
│   ├── core/                     # Infrastructure (cache, connectivity, constants, sync, theme, utils)
│   ├── data/                     # Interfaces, models, repositories, services
│   ├── features/                 # Feature modules (screens + widgets)
│   └── shared/                   # Cross-cutting widgets & primitives
├── test/                         # Widget, unit, and property-based tests
├── functions/                    # Firebase Cloud Functions (TypeScript, Node 20)
├── android/                      # Android app (Gradle Kotlin DSL, applicationId com.nsrc.nsrc_vms)
├── ios/                          # iOS app (Runner, needs GoogleService-Info.plist)
├── web/                          # Flutter web entry (index.html, manifest, icons)
├── docs/                         # Auto-generated per-module documentation (70+ files)
├── seed/                         # Data seeding scripts (Admin SDK + REST variants)
├── assets/                       # images/ and audio/
├── build/                        # Build output (served by Firebase Hosting)
├── firestore.rules               # Firestore security rules
├── firebase.json                 # Firebase project config (hosting, rules)
├── .firebaserc                   # Default project: nsrc-vms
├── pubspec.yaml                  # Dart dependencies
└── package.json                  # Node deps (cloudinary for image upload proxy)
```

### `lib/` detail

```
lib/
├── main.dart                        # Entry point (Hive → Firebase → Crashlytics → runApp)
├── app.dart                         # NSRCApp: MultiProvider DI, MaterialApp, routes, _SplashRouter, _NotificationTapHandler, _RouteObserver
├── firebase_options.dart
├── core/
│   ├── cache/                       # cache_service.dart (Hive + prefs, TTL), cache_keys.dart
│   ├── connectivity/                # connectivity_service.dart (connectivity_plus)
│   ├── constants/                   # app_constants.dart (AppStrings, AppRoutes), app_colors.dart
│   ├── error/                       # reserved (empty)
│   ├── sync/                        # sync_service.dart (auto-sync orchestrator)
│   ├── theme/                       # app_theme.dart (light/dark/NSRC), theme_provider.dart
│   └── utils/                       # audit_logger, cmu_data, date_helpers, logger (+Crashlytics),
│                                    # page_transition, responsive, responsive_app,
│                                    # service_hours_calculator, ui_helpers, validators
├── data/
│   ├── interfaces/                  # 10 DI contracts + barrel
│   ├── models/                      # user, event, incident, attendance, announcement, audit_log,
│   │                                # qr_duty_record (+ extensions: mfa_code, user_session,
│   │                                #  backup_record, notification_preference, report_config,
│   │                                #  enhanced_audit_log)
│   ├── repositories/                # 7 cached repositories + barrel
│   └── services/                    # auth, firestore, crud, groq, notification, audio, location,
│                                    # cloudinary, session, mfa, backup, import_export, pdf_export,
│                                    # report, ai_accomplishment_report
├── features/
│   ├── access_denied_screen.dart
│   ├── ai_accomplishment_reports/   # Officer mission reports (template/Groq) + PDF export
│   ├── ai_admin_intelligence/       # Stubbed (docs only)
│   ├── analytics/                   # Realtime charts & KPIs
│   ├── announcements/               # Priority-aware announcements CRUD
│   ├── attendance/                  # Officer per-event attendance; member duty records
│   ├── audit_logs/                  # Append-only log viewer + CSV export
│   ├── auth/                        # Login + multi-step registration
│   ├── backup/                      # Admin backup/restore
│   ├── dashboard/                   # Role-based dashboards + router
│   ├── data_controls/               # Generic sortable/filterable table
│   ├── database_management/         # Admin live Firestore dataset browser
│   ├── emergency_hotlines/          # Searchable hotline list (dial/SMS)
│   ├── events/                      # Event CRUD + attendance shortcut
│   ├── import_export/               # CSV/JSON import & export
│   ├── incidents/                   # Reporting, SOS, tactical map, review
│   ├── landing/                     # Public marketing page
│   ├── pdf_generation/              # Stubbed (docs only; PDF lives in data/services)
│   ├── profile/                     # Profile view/edit + photo upload
│   ├── qr_duty_monitoring/          # QR generator, duty scanner, monitoring dashboard
│   ├── reports/                     # Official reports screen
│   ├── settings/                    # 8 setting sections
│   ├── user_guide/                  # In-app help manual
│   ├── user_management/             # Admin account management (+ impersonation)
│   └── warning_system/              # Soft-delete mixin + warning dialogs
└── shared/
    ├── app_feedback.dart            # Snackbar helpers
    ├── app_shell.dart               # Scaffold: AppBar, role-aware drawer, bottom nav, SOS banner
    ├── result.dart                  # sealed Result<T> = Success | Failure
    ├── route_guard.dart             # Role/feature/MFA gating
    ├── role_aware_nav_drawer.dart
    ├── status_badge.dart / status_helpers.dart / audit_color_chip.dart
    ├── academic_dropdowns.dart / shimmer_loading.dart / sos_banner_overlay.dart
    └── widgets/                     # 20+ reusable widgets incl. a dashboard widget library
```

---

## 5. Core Application Layer

### `lib/main.dart` — Bootstrap
Runs inside `runZonedGuarded` so **every** uncaught error is sent to Firebase Crashlytics. Initialization order:

1. `Hive.initFlutter()` + open the `'cache'` box.
2. `Firebase.initializeApp` using `DefaultFirebaseOptions.currentPlatform`.
3. Enable Firestore **offline persistence** with unlimited cache size.
4. Route all Flutter errors to Crashlytics.
5. Construct `CacheService` and `ConnectivityService`.
6. `runApp(NSRCApp(...))` and unawaited `NotificationService().initialize()`.

On failure it renders `BootstrapFailureApp` — a branded screen that instructs the user to check Firebase config, cache access, and network.

### `lib/app.dart` — Root Widget & DI
`NSRCApp` wires the whole object graph through a `MultiProvider`:
- `ThemeProvider`, `AuthService`, `FirestoreService`, `CacheService`, `ConnectivityService`, `GroqConfig`/`GroqService`
- Repositories: `Event`, `Incident`, `User`, `Attendance`, `QrDuty`, `Announcement`, `AuditLog`
- Services: `SyncService` (starts immediately), `MfaService`, `SessionService`, `BackupService`, `ImportExportService`, `PdfExportService`, `ReportService`, `AuthServiceExtensions`

It also defines:
- **~24 named routes** with `smoothRoute` transitions (instant for splash/landing/auth).
- **`_SplashRouter`** — checks `FirebaseAuth.instance.currentUser`; routes to the landing page if signed out, otherwise restores the last session route (stored in `nsrc_last_route`) or the dashboard.
- **`_NotificationTapHandler`** — opens the Incidents screen when a notification is tapped, auto-selecting the incident.
- **`_RouteObserver`** — persists the last non-splash/landing/auth route so sessions can be restored.

### Shared primitives
- **`Result<T>`** — sealed `Success<T>` / `Failure<T>` used app-wide for errors.
- **`RouteGuard`** — splash loading → unauthenticated → role check → feature check → MFA gate → child.
- **`AppShell`** — shared scaffold with top bar, role-aware nav drawer, bottom navigation, and SOS banner overlay.

---

## 6. Data Layer

### Models (`lib/data/models`)
All models are Firestore-serializable (`fromJson`/`toJson`):
- **`AppUser`** — includes `UserRole`, `UserStatus`, and `Feature` enums plus permission helpers.
- **`Event`** — scheduling, location, organizer, join requests.
- **`Incident`** — reporting, severity, type, geo-location, review workflow.
- **`Attendance`** — per-event volunteer attendance (Present/Absent/Excused).
- **`Announcement`** — priority-aware notices.
- **`AuditLog`** — append-only compliance trail.
- **`QrDutyRecord`** — QR-based time-in/time-out duty records.

Extensions: `MfaCode`, `UserSession`, `BackupRecord`, `NotificationPreference`, `ReportConfig`, `EnhancedAuditLog`.

### Repositories (`lib/data/repositories`)
Seven repositories (`User`, `Event`, `Incident`, `Attendance`, `QrDuty`, `Announcement`, `AuditLog`) implement their interfaces, use `CacheService` for TTL'd Hive caching, and return `Result<T>` for error handling.

### Services (`lib/data/services`)
- **`AuthService`** — Firebase Auth + remember-me, cached user, 5-attempt login lockout, MFA and password-reset rate limiters, `RegistrationData`/`OrganizationAccountData` DTOs.
- **`FirestoreService`** — the single realtime-stream gateway for all collections; watches active SOS; exposes `lastError`.
- **`CrudService<T>`** — generic CRUD with input sanitization, audit logging, soft delete, and optimistic `version` locking.
- **`GroqService` / `GroqConfig`** — configurable LLM-backed report generation (6 selectable models; API key stored in preferences).
- **`NotificationService`** + **`AudioService`** — FCM + local notifications, foreground alerts, SOS alarm playback.
- **`LocationService`**, **`CloudinaryService`**, **`SessionService`**, **`MfaService`**, **`BackupService`**, **`ImportExportService`**, **`PdfExportService`**, **`ReportService`**, **`AIAccomplishmentReportService`**.

---

## 7. Features

| Feature | Location | Description |
|---|---|---|
| **Authentication & Registration** | `features/auth` | Login plus a 4-step registration flow (personal info → contact → competency → verification). Animated background, branding panel, remember-me, forgot-password, and verification gating. |
| **Role-Based Dashboard** | `features/dashboard` | Admin (system health, analytics, user mgmt, audit), Officer (operations, team performance, incident response), Member (service hours, events, alerts), Organization (incident live feed + tactical map). |
| **Events** | `features/events` | CRUD with search/filter/sort, detail overlay, form sheet, and attendance shortcut. |
| **Incidents & SOS** | `features/incidents` | GPS-tagged reporting, SOS button (alarm + broadcast), severity/type/assistance filters, tactical map view (flutter_map/OSM), list/grid toggle. |
| **Attendance** | `features/attendance` | Officers mark Present/Absent/Excused per volunteer per event with stats and "mark all"; members view their own QR duty records and service hours. |
| **AI Accomplishment Reports** | `features/ai_accomplishment_reports` | 4-step build (focus → cycle → date range → tactical filters) with live stats, generated via template builder or Groq LLM, copy or PDF export. |
| **User Management** | `features/user_management` | Approve/deny pending registrations, edit users, batch stats, impersonation, organization account creation. Uses Dart `part` files. |
| **Analytics** | `features/analytics` | Realtime Firestore-stream KPI bar and chart cards (users/events/incidents/attendance). |
| **Audit Logs** | `features/audit_logs` | Append-only log viewer with search, category/severity filters, CSV export. |
| **Profile** | `features/profile` | Avatar/name/role/service-hours overview, grouped info, edit form with Cloudinary photo upload. |
| **Announcements** | `features/announcements` | Priority-aware CRUD with stats bar, filter chips, form sheet. |
| **QR Duty Monitoring** | `features/qr_duty_monitoring` | Members scan event QR codes (mobile_scanner) for time-in/time-out; officers generate printable QR PDFs and monitor duty activity. |
| **Landing Page** | `features/landing` | Public marketing page: hero, about, programs, contact form (writes `contactInquiries`), footer. |
| **Settings** | `features/settings` | Profile, notifications, interface (themes incl. NSRC Classic), AI model (Groq key/model), account security (MFA), help, contact, about. |
| **Database Management** | `features/database_management` | Admin-only live Firestore dataset browser with searchable tables, dataset cards, hero stats, command bar. |
| **Backup** | `features/backup` | Admin backup/restore UI over `BackupService` (exports to `backupRecords`). |
| **Import / Export** | `features/import_export` | Admin CSV/JSON import (with preview) and collection export. |
| **Reports** | `features/reports` | Official reporting: pick type + date range, generate via `ReportService`, print/export PDF. |
| **Emergency Hotlines** | `features/emergency_hotlines` | Searchable hotline list with dial/SMS actions. |
| **User Guide** | `features/user_guide` | Searchable, category- and role-filtered in-app help manual. |
| **Warning System** | `features/warning_system` | Reusable soft-delete mixin and confirmation dialogs. |
| **Data Controls** | `features/data_controls` | Generic sortable/filterable data-table widget reused by audit/database screens. |
| *Planned (stubbed)* | `ai_admin_intelligence`, `pdf_generation` | Doc pages exist; Dart implementation pending. |

---

## 8. Roles & Access Control

Roles are modeled in `AppUser` (`UserRole` enum) and enforced at **three levels**: UI (`RouteGuard`), dashboard selection (`DashboardRouter`), and backend (`firestore.rules`).

| Role | Capabilities |
|---|---|
| **member** | Report incidents, scan QR duties, view own data, view public events/announcements |
| **officer** | Everything a member can do, plus event creation, attendance marking, QR duty generation/monitoring, announcement creation, audit log viewing, report generation |
| **organization** | View incident live feed + tactical map |
| **admin (Super Admin)** | Everything, plus user management/impersonation, database browsing, backup/restore, import/export, audit log access, confirming accounts; only admins may change roles/status |

Additional access gates include **MFA verification** (when enabled) and **feature flags** per user.

---

## 9. Firestore Security Rules

`firestore.rules` (`rules_version = '2'`) starts with a **deny-by-default global safety net**, then grants explicit per-collection access using helpers:

- **Identity:** `isSignedIn()`, `isOwner(userId)`, `getRole()`, `isOfficerOrAdmin()`, `isSuperAdmin()`, `isApprovedStaff()`.
- **Content security:** `isSafeText` / `isSafeShortText` reject HTML/script tags, `javascript:` URLs, inline handlers, and enforce length caps (200 / 10 000 chars).
- **Anti-escalation:** `roleFieldUnchanged()` / `statusFieldUnchanged()` prevent users changing their own role/status.
- **Entity validators:** enforce required keys, types, lengths, and whitelisted enum values for users, events, incidents (+reviews), announcements, attendance, QR duty records, and contact inquiries.

**Notable per-collection rules:**
- **users** — self-service create/update with a field whitelist and frozen role/status; deletes are super-admin only.
- **events / attendance / incidents / announcements / resources** — signed-in reads; staff writes; admin deletes.
- **auditLogs** — **append-only immutable log**: reads by staff, creates by signed-in, updates/deletes always denied.
- **backupRecords / siteConfig** — super admin only.
- **qrDutyRecords** — creates use a **deterministic doc id** (`qr_{userId}_{eventId|general}_{date}_{type}`) that must not already exist, preventing duplicate punch records.
- **mfaCodes / userSessions** — scoped to the owning user.
- **contactInquiries** — public create (validated, safe-text), staff view, admin modify.

> Always run emulator-backed rule checks before deploying rule changes.

---

## 10. Cloud Functions (Backend)

`functions/src/index.ts` (TypeScript, Node 20) exposes four functions:

| Function | Trigger | Behavior |
|---|---|---|
| **`broadcastIncidentAlerts`** | Firestore `incidents/{incidentId}` `onCreate` | Collects FCM tokens from all users (excluding the reporter), sends **3 alert rounds** 5s apart via chunked multicast (500/round). Titles escalate by severity (`SOS EMERGENCY` / `CRITICAL INCIDENT` / `INCIDENT REPORT`). Android uses the `sos_alarm` sound, max priority, sticky flag; APNs/Web deep-link to `/incidents/{id}`. Writes audit entries with success/failure counts. |
| **`sendIncidentNotification`** | Firestore `notifications/{notificationId}` `onCreate` | Single-target FCM push with exponential backoff (up to 3 attempts: 1s/2s/4s). Marks `sent`/`sentAt`/`fcmMessageId`, or writes `lastError`/`nextRetry` / `failed`. Logs to `auditLogs`. |
| **`cleanupOldNotifications`** | Scheduled daily 02:00 UTC | Deletes `notifications` older than 30 days in batches of 100. |
| **`resendFailedNotifications`** | Scheduled every 5 minutes | Retries up to 50 notifications where `sent == false && failed == false && nextRetry <= now` with the same backoff policy. |

Deploy with `firebase deploy --only functions`. Local emulation: `npm start` in `functions/`.

---

## 11. Offline-First & Caching

- **Hive cache** (`CacheService`) — every repository caches Firestore data with TTL expiry timestamps; UI reads from cache instantly and reconciles.
- **Firestore offline persistence** — enabled at bootstrap (`persistenceEnabled: true`, unlimited cache).
- **`SyncService`** — auto-syncs all repositories on app start, on interval, and whenever connectivity changes.
- **Connectivity awareness** — `connectivity_plus` powers connection streams so the app can degrade gracefully.

---

## 12. Notifications & SOS Alerts

- **FCM** via `NotificationService` with local notification fallback (`flutter_local_notifications`) for foreground alerts.
- A background FCM handler is registered for incident/SOS pushes.
- **SOS flows**: the SOS button triggers an alarm (via `AudioService`/`audioplayers`) and writes an incident record that triggers `broadcastIncidentAlerts` in the cloud.
- Notification taps deep-link into the Incidents screen and auto-open the selected incident.
- Web notification behavior is handled defensively (try-catch for null assertion safety).

---

## 13. Seed Scripts

`seed/` populates realistic mock data:

| Script | Method | Notes |
|---|---|---|
| `seed.js` | Firebase Admin SDK | `node seed.js <serviceAccountKey.json>`. Reads **41 mock members** from `mock-users.json`, derives UUID + email (`{name}@mock.nsrc`), builds full user docs (`role: 'member'`, `status: 'approved'`), writes to `users`. |
| `seed-cli.js` | Firestore REST | Reuses the local Firebase CLI token (`USERPROFILE\.config\configstore\firebase-tools.json`). |
| `seed-rest.js` | Anonymous REST | Web API-key based writes to Firestore REST endpoints (hardcoded `nsrc-vms` project). |

`mock-users.json` contains 41 realistic member records (name, serial number, birthdate, gender, course & year, competency, barangay/city/province, contact number).

---

## 14. Testing

```
test/
├── widget_test.dart                  # Smoke: NSRCApp class exists
├── widget/
│   ├── audit_color_chip_test.dart
│   ├── database_widgets_test.dart
│   ├── empty_state_test.dart
│   ├── route_guard_test.dart         # Role/feature/MFA gating
│   └── status_badge_test.dart
├── unit/
│   ├── ai_accomplishment_report_service_test.dart
│   ├── auth_service_test.dart        # Login/lockout/status gating with fakes
│   ├── firestore_service_test.dart   # fake_cloud_firestore
│   ├── location_service_test.dart
│   ├── service_hours_calculator_test.dart
│   ├── features/database_management/models_test.dart
│   ├── models/                       # user, event, incident, other_models
│   └── shared/                       # logger, result, status_helpers
└── property/                         # kiri_check property-based tests
    ├── access_control_properties_test.dart   # role-gating invariants
    ├── auth_properties_test.dart             # auth invariants
    └── firestore_properties_test.dart        # Firestore data invariants
```

Coverage: auth flows (gating, rate limits, lockouts), Firestore read/write streams, location capture, report generation, service-hours math, shared widgets, model (de)serialization, and property-based invariants using fakes (`fake_cloud_firestore`, `firebase_auth_mocks`, `mock_exceptions`).

Run with `flutter test`.

---

## 15. Deployment

### Android (primary target)
```powershell
flutter build apk --release
```
- `android/` uses Gradle Kotlin DSL; `applicationId = "com.nsrc.nsrc_vms"`.
- Requires `android/app/google-services.json`.

### iOS
- Requires `ios/Runner/GoogleService-Info.plist`.
- Build via `flutter build ios` / Xcode (`Runner.xcworkspace`).

### Web (Firebase Hosting)
1. `flutter build web`
2. `firebase deploy`

`firebase.json` serves `build/web` with an SPA rewrite to `index.html` and hardened security headers:
- **Content-Security-Policy** (self + Google/Groq endpoints)
- Strict-Transport-Security, X-Frame-Options `DENY`, X-Content-Type-Options `nosniff`, X-XSS-Protection, Referrer-Policy, Permissions-Policy (camera/mic/geolocation/notifications self-only)

### Cloud Functions
```powershell
cd functions
npm run build
firebase deploy --only functions
```

### Firebase emulators (local dev)
```powershell
firebase emulators:start
```

---

## 16. Getting Started

```powershell
# 1. Verify the toolchain
flutter doctor

# 2. Install Dart dependencies
flutter pub get

# 3. Confirm Firebase files exist
#    - lib/firebase_options.dart
#    - android/app/google-services.json
#    - ios/Runner/GoogleService-Info.plist  (iOS builds only)

# 4. Run locally
flutter run

# 5. (Optional) Seed mock members
node seed/seed.js <serviceAccountKey.json>

# 6. (Optional) Run Cloud Functions locally
cd functions
npm install
npm start   # builds + starts emulator
```

---

## 17. Quality Checks

Run these before shipping a build:

```powershell
flutter analyze
flutter test
flutter build apk --release
```

For Firebase rule changes, run emulator-backed checks before deployment. For production, review the release checklist in `docs/production-readiness.md` (see caveat in §20).

---

## 18. Documentation

`docs/` contains **70+ auto-generated Markdown files**, one per source module, plus index files (`root.md`, `core.md`, `data.md`, `features.md`, `shared.md`, `utils.md`). Naming convention: `{subtree_path_with_underscores}.md`, e.g. `features_settings_sections.md`, `data_services_mfa.md`, `shared_widgets_dashboard.md`.

Key docs:
- `docs/root.md` — app entry, DI graph, splash/router, routes
- `docs/core_*.md` — cache, connectivity, sync, theme, utils
- `docs/data_*.md` — interfaces, models (+extensions), repositories, services (mfa, reporting, etc.)
- `docs/features_*.md` — every feature module and its widgets/parts
- `docs/shared*.md` — shared widgets & dashboard library

---

## 19. Recent Changes

### Landing Page Redesign (May 14, 2026 — see `REDESIGN_CHANGES.txt`)
A responsive/overflow-safe redesign of the public landing page:
- **Hero** (`landing_hero.dart`): height clamped with `math.min()` instead of `math.max()`; every row wrapped in `SingleChildScrollView` (non-scrollable physics); typography reduced to 38–52px; tighter spacing.
- **Programs** (`landing_programs.dart`): reduced padding/grid gap, shortened descriptions, updated card aspect ratios.
- **Contact/Footer** (`landing_contact_footer.dart`): tighter layout consistent with the other sections.
- Breakpoints: mobile `< 760px`, tablet `760–1024px`, desktop `> 1024px`.
- **No breaking changes** — no new dependencies, no DB migrations, deployable immediately.

---

## 20. Known Notes & Caveats

1. **Stubbed features** — `ai_admin_intelligence` and `pdf_generation` have documentation but no Dart implementation yet (PDF export currently lives in `data/services/import_export/pdf_export_service.dart`).
2. **Missing doc file** — `README.md` references `docs/production-readiness.md`, but the file is not present in `docs/`.
3. **Requirement traceability** — code comments reference requirement numbers (`Req 3`, `Req 4`, `Req 8–22`) sourced from `Project Outline.docx` (binary; not plain-text readable).
4. **Groq API integration** — LLM report generation requires a Groq API key entered in Settings → AI Model. The app supports 6 selectable models.
5. **Cloudinary** — profile photo uploads require Cloudinary configuration (`package.json` includes the `cloudinary` node dependency for signed requests).
6. **`lib/utils/`** — docs refer to a top-level `utils/` tree; in practice utilities live under `lib/core/utils/`.
7. **Web audio** — SOS alarm playback requires try-catch handling on web (null assertion safety per `pubspec.yaml` comments).

---

*Document generated for the NSRC VMS (SBNU Application) project. Paths are relative to the repository root `D:\nsrc_vms`.*