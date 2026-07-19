# System Architecture

## Architectural Layers

The application follows a clean architecture pattern with three primary layers:

- **Presentation Layer (features/)** — UI screens and widgets organized by feature module
- **Domain/Data Layer (data/)** — Models, repositories, services, and interfaces
- **Core Layer (core/)** — Infrastructure utilities, caching, theming, connectivity, and sync

## Design Patterns

- **Repository Pattern** — 7 repositories wrap FirestoreService with CacheService for offline-first data access
- **Provider State Management** — 20+ providers registered in app.dart manage application state
- **Sealed Result Type** — Result\<T\> (Success/Failure) for consistent error handling throughout
- **Interface Segregation** — 10 abstract interfaces enforce dependency inversion between layers
- **Route Guard** — Widget-level RBAC enforcement with MFA challenge gate
- **Offline-First** — Hive caching + Firestore persistence + 10-minute auto-sync cycle
- **Glassmorphism UI** — Unified frosted-glass design system with 3 theme modes

## Application Startup Flow

- runZonedGuarded wraps the entire app for crash safety
- Hive local cache is initialized for offline storage
- Firebase is initialized with platform-specific configuration
- Firestore offline persistence is enabled (unlimited cache)
- Flutter errors are routed to Crashlytics
- CacheService and ConnectivityService are created
- NSRCApp widget tree is mounted with all providers
- NotificationService is initialized asynchronously
- SyncService starts a 10-minute auto-sync cycle

## Navigation Flow

The splash screen checks Firebase Auth state. If no user is authenticated, the Landing Page is displayed. If a session exists, restoreSession() is called and the user is routed to their last saved route or the role-specific Dashboard. RouteGuard wraps every authenticated screen to enforce auth state, role hierarchy, feature permissions, and MFA challenge requirements.
