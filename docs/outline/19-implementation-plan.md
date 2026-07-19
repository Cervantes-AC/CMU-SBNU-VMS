# Implementation Plan

## CMU-SBNU Volunteer Management System — Phased Delivery

---

## Phase 0 — Project Scaffolding (Week 1)

### Objectives

- Initialize Flutter project with clean architecture structure
- Configure Firebase (Auth, Firestore, Cloud Functions, Hosting)
- Set up Hive for local caching
- Establish theming, routing, and provider registration

### Deliverables

- `flutter create` with Android, Web, and iOS targets
- `lib/core/` — constants, theme (light/dark/NSRC Classic), utils (validators, input sanitizer, rate limiter, secure storage, audit logger)
- `lib/data/interfaces/` — 10 abstract service interfaces
- `lib/data/models/` — base model classes with serialization
- `lib/shared/` — app_shell.dart, route_guard.dart, sos_banner_overlay.dart, reusable widgets
- `app.dart` — provider registration, route table, splash screen
- `main.dart` — Firebase init, Hive init, Crashlytics, runZonedGuarded
- Firestore rules skeleton (deny-by-default)
- `analysis_options.yaml` — strict linting rules

### Milestone

App launches, displays splash screen, routes to landing page or login.

---

## Phase 1 — Authentication & User Management (Weeks 2–3)

### Objectives

- Full Firebase Auth integration with registration-approval workflow
- Role-based access control with RouteGuard
- MFA support (OTP + backup codes)
- Admin user management

### Deliverables

| Feature | Files |
|---|---|
| Login / Register | `features/auth/` |
| Password Reset | `features/auth/` |
| MFA (OTP + Backup Codes) | `features/auth/`, `data/services/mfa_service.dart` |
| RouteGuard (RBAC + MFA gate) | `shared/route_guard.dart` |
| User Management (Admin) | `features/user_management/` |
| Profile Management | `features/profile/` |
| Firestore rules — users, mfaCodes, userSessions | `firestore.rules` |

### Milestone

4 user roles can register, get approved, log in, and access role-appropriate screens. MFA works end-to-end.

---

## Phase 2 — Core Data Layer (Weeks 3–4)

### Objectives

- FirestoreService with full CRUD
- 7 repositories with cache-first strategy
- CacheService (Hive + SharedPreferences) with TTL
- ConnectivityService and SyncService (10-min auto-sync)
- Sealed Result type for error handling

### Deliverables

| Component | Path |
|---|---|
| FirestoreService | `data/services/firestore_service.dart` |
| EventRepository | `data/repositories/` |
| IncidentRepository | `data/repositories/` |
| UserRepository | `data/repositories/` |
| AttendanceRepository | `data/repositories/` |
| AnnouncementRepository | `data/repositories/` |
| AuditLogRepository | `data/repositories/` |
| QrDutyRepository | `data/repositories/` |
| CacheService | `core/cache/cache_service.dart` |
| ConnectivityService | `core/connectivity/` |
| SyncService | `core/sync/sync_service.dart` |
| Result\<T\> sealed class | `core/utils/` |

### Milestone

All 7 collections are readable/writable with offline caching and background sync.

---

## Phase 3 — Event Management (Week 5)

### Objectives

- Event CRUD with full lifecycle (Upcoming → Ongoing → Completed / Cancelled)
- Join request workflow (apply, approve, deny)
- Direct volunteer assignment
- Event detail view with volunteer list, join queue, attendance

### Deliverables

- `features/events/` — event list, create/edit form, detail view, join request management
- Firestore rules — events collection
- Audit logging for event operations

### Milestone

Officers can create events; members can join; admins have full control.

---

## Phase 4 — Attendance & QR Duty Monitoring (Weeks 6–7)

### Objectives

- Attendance marking (present/absent/excused) with bulk support
- QR code generation per event/session
- QR code scanning for time-in/time-out
- Duty record tracking and monitoring dashboard

### Deliverables

| Feature | Files |
|---|---|
| Attendance marking | `features/attendance/` |
| QR code generator | `features/qr_duty_monitoring/` |
| QR scanner (mobile_scanner) | `features/qr_duty_monitoring/` |
| Duty records & dashboard | `features/qr_duty_monitoring/` |
| Firestore rules — attendance, qrDutyRecords | `firestore.rules` |

### Milestone

Officers mark attendance; QR duty time-in/time-out works; duty records are queryable.

---

## Phase 5 — Incident Reporting & SOS (Weeks 7–8)

### Objectives

- Standard incident reports with GPS, media, severity
- Incident status workflow (Submitted → Under Review → Responded → Resolved)
- Tactical map (flutter_map + OpenStreetMap)
- SOS emergency system with FCM broadcast and alarm audio

### Deliverables

- `features/incidents/` — incident form, list, detail, map view
- SOS button with repeated FCM broadcast (3 rounds, 5s delay)
- Audio alarm playback with vibration
- `shared/sos_banner_overlay.dart` — global SOS banner
- Cloud Function `broadcastIncidentAlerts`
- Firestore rules — incidents collection

### Milestone

Incidents can be reported and tracked; SOS triggers emergency alerts to all users.

---

## Phase 6 — Dashboard System (Week 9)

### Objectives

- 4 role-specific dashboards with tailored stats and quick actions
- Glassmorphism design with stat cards, skeleton loaders, shimmer, pull-to-refresh

### Deliverables

- `features/dashboard/` — admin, officer, member, organization dashboards
- Dashboard providers for each role

### Milestone

Each role sees a personalized dashboard with relevant data.

---

## Phase 7 — Announcements, Reports & Analytics (Weeks 10–11)

### Objectives

- Priority-based announcements (High/Medium/Low)
- Report generation from templates
- Analytics dashboard with fl_chart visualizations
- Report types: user activity, transaction, audit trail, system usage, custom

### Deliverables

| Feature | Files |
|---|---|
| Announcements | `features/announcements/` |
| Report generation | `features/report_generation/` |
| Analytics dashboard | `features/analytics/` |
| Reports UI | `features/reports/` |
| Firestore rules — announcements | `firestore.rules` |

### Milestone

Officers broadcast announcements; reports are generated; analytics display charts.

---

## Phase 8 — Admin Utilities (Week 12)

### Objectives

- Audit trail viewer with filtering
- Backup & database management
- Import/Export (CSV, JSON, PDF)
- Database browser

### Deliverables

| Feature | Files |
|---|---|
| Audit log viewer | `features/audit_logs/` |
| Backup management | `features/backup/` |
| Import/Export UI | `features/import_export/` |
| Database browser | `features/database_management/` |
| Firestore rules — auditLogs, backupRecords | `firestore.rules` |

### Milestone

Admins can view audit logs, manage backups, import/export data, and browse collections.

---

## Phase 9 — Notifications & Emergency Hotlines (Week 13)

### Objectives

- FCM token management and multi-channel delivery
- Foreground/background notification handling
- Local notifications for critical alerts (SOS)
- Emergency hotlines with one-tap calling

### Deliverables

- `data/services/notification_service.dart`
- `features/emergency_hotlines/`
- Android notification channels configuration

### Milestone

Push notifications work across foreground and background; emergency hotlines are accessible.

---

## Phase 10 — Landing Page, Settings & Polish (Week 14)

### Objectives

- Public landing page (hero, programs, contact form, privacy policy)
- Settings & preferences (theme, notifications, security, data, about, user guide)
- Theme cycling (Light → Dark → NSRC Classic → default)
- Offline banner indicator
- Warning system / soft delete dialogs

### Deliverables

- `features/landing/`
- `features/settings/`
- `features/user_guide/`
- `features/warning_system/`

### Milestone

Public landing page is live; all settings sections work; UI is polished.

---

## Phase 11 — Cloud Functions & Security Hardening (Week 15)

### Objectives

- All Cloud Functions implemented and deployed
- Firestore rules finalized (314 lines, deny-by-default)
- Security audit: XSS, CSRF, rate limiting, input sanitization
- CORS, CSP, HSTS headers configured

### Deliverables

- `functions/src/index.ts` — broadcastIncidentAlerts, organization account creation, others
- `firestore.rules` — complete collection-level rules
- Security review pass across all services

### Milestone

Server-side operations are secure; rules are comprehensive; no critical vulnerabilities.

---

## Phase 12 — Testing & QA (Weeks 16–17)

### Objectives

- Unit tests for services, repositories, models
- Widget tests for key screens
- Integration tests for critical flows (auth, event lifecycle, attendance)
- Firestore rules tests

### Deliverables

- `test/` — unit, widget, integration tests
- `seed/` — seed.js, seed-rest.js, seed-cli.js with mock data
- CI pipeline (flutter analyze, flutter test)

### Milestone

Test coverage meets threshold; all critical paths are tested; CI passes.

---

## Phase 13 — Deployment & Launch (Week 18)

### Objectives

- Build and deploy to Firebase Hosting (web)
- Build Android APK (release)
- Production Firestore rules deployment
- Monitoring and crash reporting active

### Deliverables

- `flutter build web` → Firebase Hosting
- `flutter build apk --release` → Distribution
- `firebase deploy` → Firestore rules + hosting
- Crashlytics and Analytics configured

### Milestone

Application is live and accessible to all user roles.

---

## Summary

| Phase | Focus | Duration |
|---|---|---|
| 0 | Scaffolding | Week 1 |
| 1 | Auth, MFA, RBAC | Weeks 2–3 |
| 2 | Data Layer & Caching | Weeks 3–4 |
| 3 | Event Management | Week 5 |
| 4 | Attendance & QR Duty | Weeks 6–7 |
| 5 | Incidents & SOS | Weeks 7–8 |
| 6 | Dashboards | Week 9 |
| 7 | Announcements, Reports, Analytics | Weeks 10–11 |
| 8 | Admin Utilities | Week 12 |
| 9 | Notifications & Emergency | Week 13 |
| 10 | Landing, Settings, Polish | Week 14 |
| 11 | Cloud Functions & Security | Week 15 |
| 12 | Testing & QA | Weeks 16–17 |
| 13 | Deployment & Launch | Week 18 |

**Total estimated timeline: 18 weeks**
