# Project Directory Structure

```
D:\nsrc_vms\
├── lib/                          # Main Dart/Flutter source
│   ├── main.dart                 # Entry point — Firebase init, Hive, Crashlytics
│   ├── app.dart                  # Root NSRCApp widget, routes, providers
│   ├── firebase_options.dart     # FlutterFire CLI-generated config
│   ├── core/                     # Core infrastructure
│   │   ├── cache/                # CacheService (Hive + SharedPreferences)
│   │   ├── connectivity/         # ConnectivityService (connectivity_plus)
│   │   ├── constants/            # AppStrings, AppRoutes, AppColors
│   │   ├── sync/                 # SyncService — auto-sync all repos every 10 min
│   │   ├── theme/                # AppTheme (light/dark/nsrc), ThemeProvider
│   │   └── utils/                # AuditLogger, Logger, Validators, InputSanitizer,
│   │                             # SecureStorage, RateLimiter, responsive helpers
│   ├── data/                     # Data layer
│   │   ├── interfaces/           # 10 abstract interfaces
│   │   ├── models/               # 7 data models + extensions/
│   │   ├── repositories/         # 7 repositories (cached CRUD wrappers)
│   │   └── services/             # 14+ service classes
│   ├── features/                 # 25 feature modules (screens + widgets)
│   │   ├── auth/                 # Login, register, MFA, password reset
│   │   ├── dashboard/            # Role-based dashboards
│   │   ├── events/               # Event CRUD, join requests, detail view
│   │   ├── incidents/            # Incident reporting, SOS, tactical map
│   │   ├── announcements/        # Announcement management
│   │   ├── attendance/           # Attendance tracking
│   │   ├── qr_duty_monitoring/   # QR scanner, generator, dashboard
│   │   ├── profile/              # User profile view/edit
│   │   ├── settings/             # 7 settings sections
│   │   ├── analytics/            # Charts and analytics
│   │   ├── audit_logs/           # Audit log viewer
│   │   ├── user_management/      # Admin user management
│   │   ├── database_management/  # Database browser
│   │   ├── backup/               # Backup management UI
│   │   ├── import_export/        # Import/export UI
│   │   ├── report_generation/    # Report generation
│   │   ├── landing/              # Public landing page
│   │   ├── emergency_hotlines/   # Emergency contacts
│   │   ├── user_guide/           # In-app help
│   │   └── warning_system/       # Warning dialogs, soft delete
│   └── shared/                   # Shared UI components
│       ├── app_shell.dart        # Main app shell (app bar, nav, drawer)
│       ├── route_guard.dart      # Role + MFA route access control
│       ├── sos_banner_overlay.dart # Global SOS alert overlay
│       └── widgets/              # 30+ reusable widgets
├── functions/                    # Firebase Cloud Functions (TypeScript)
├── seed/                         # Database seeding scripts
├── test/                         # Test suite (unit, widget, property)
├── assets/                       # Static assets (images, audio)
├── firestore.rules               # Firestore security rules (314 lines)
├── firebase.json                 # Firebase hosting + Firestore config
└── analysis_options.yaml         # Linter rules (64 lines)
```
