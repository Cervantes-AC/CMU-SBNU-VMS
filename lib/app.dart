import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:cmu_sbnu_vms/core/cache/cache_service.dart';
import 'package:cmu_sbnu_vms/core/constants/route_names.dart';
import 'package:cmu_sbnu_vms/core/error/app_exception.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/theme/theme_provider.dart';
import 'package:cmu_sbnu_vms/data/interfaces/announcement_repository.dart';
import 'package:cmu_sbnu_vms/data/interfaces/auth_repository.dart';
import 'package:cmu_sbnu_vms/data/interfaces/event_repository.dart';
import 'package:cmu_sbnu_vms/data/interfaces/user_repository.dart';
import 'package:cmu_sbnu_vms/data/models/announcement.dart';
import 'package:cmu_sbnu_vms/data/models/event.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/access_denied_screen.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_screen.dart';
import 'package:cmu_sbnu_vms/features/auth/password_reset_screen.dart';
import 'package:cmu_sbnu_vms/features/announcements/announcements_controller.dart';
import 'package:cmu_sbnu_vms/features/announcements/announcements_screen.dart';
import 'package:cmu_sbnu_vms/features/dashboard/admin_dashboard.dart';
import 'package:cmu_sbnu_vms/features/dashboard/dashboard_router.dart';
import 'package:cmu_sbnu_vms/features/dashboard/demo_admin_dashboard_screen.dart';
import 'package:cmu_sbnu_vms/features/dashboard/member_dashboard.dart';
import 'package:cmu_sbnu_vms/features/dashboard/officer_dashboard.dart';
import 'package:cmu_sbnu_vms/features/events/events_controller.dart';
import 'package:cmu_sbnu_vms/features/events/events_screen.dart';
import 'package:cmu_sbnu_vms/features/landing/landing_page.dart';
import 'package:cmu_sbnu_vms/features/profile/profile_controller.dart';
import 'package:cmu_sbnu_vms/features/profile/profile_screen.dart';
import 'package:cmu_sbnu_vms/shared/route_guard.dart';
import 'package:cmu_sbnu_vms/shared/result.dart';
import 'package:cmu_sbnu_vms/shared/app_shell.dart';

/// Session state consumed by the router redirect.
///
/// Owns the auth-state subscription and the current profile stream. Profile
/// lookup is keyed to the session UID so a stale profile can never survive
/// an account change. Missing, malformed, or failed profile loads resolve to
/// `null` (fail closed) with `profileReady == true`.
class SessionController extends ChangeNotifier {
  SessionController({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _sessionSub = _authRepository.watchSession().listen(_onSession);
  }

  final AuthRepository _authRepository;
  StreamSubscription<String?>? _sessionSub;
  StreamSubscription<UserProfile?>? _profileSub;

  bool? _authenticated;
  UserProfile? _profile;
  bool _profileReady = true;

  /// Null while the auth state is resolving; false when signed out.
  bool? get authenticated => _authenticated;

  /// Current profile; null while loading, missing, malformed, or signed out.
  UserProfile? get profile => _profile;

  /// False until the first profile emission (or failure) for the current
  /// session UID has arrived.
  bool get profileReady => _profileReady;

  void _onSession(String? uid) {
    _authenticated = uid != null;
    _profile = null;
    _profileSub?.cancel();
    _profileSub = null;
    if (uid == null) {
      _profileReady = true;
      notifyListeners();
      return;
    }
    _profileReady = false;
    notifyListeners();
    _subscribeProfile(uid);
  }

  void _subscribeProfile(String uid) {
    _profileSub = _authRepository.watchCurrentProfile(uid).listen(
      (profile) {
        _profile = profile;
        _profileReady = true;
        notifyListeners();
      },
      onError: (Object _) {
        // Permission denial/offline while loading: fail closed rather than
        // granting a default view. The route guard sends the user to the
        // neutral access-denied screen.
        _profile = null;
        _profileReady = true;
        notifyListeners();
      },
    );
  }

  /// Re-checks the session/profile after a user-initiated retry.
  Future<void> retry() async {
    final uid = _authRepository.currentUid;
    _authenticated = uid != null;
    _profile = null;
    _profileSub?.cancel();
    _profileSub = null;
    if (uid == null) {
      _profileReady = true;
      notifyListeners();
      return;
    }
    _profileReady = false;
    notifyListeners();
    _subscribeProfile(uid);
    await _authRepository.refreshSession();
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    _sessionSub?.cancel();
    super.dispose();
  }
}

/// Auth repository used when Firebase was not initialized at bootstrap
/// (missing/invalid configuration). Keeps the app on the public pages and
/// fails every sign-in/reset with an explicit "not connected" message —
/// protected features never render without a working backend.
class UnconfiguredAuthRepository implements AuthRepository {
  const UnconfiguredAuthRepository();

  static const _notConnected = UnavailableException(
    message:
        'Sign-in is not available in this build yet. Ask your unit administrator how to access the app.',
  );

  @override
  Stream<String?> watchSession() => Stream<String?>.value(null);

  @override
  Stream<UserProfile?> watchCurrentProfile(String uid) =>
      Stream<UserProfile?>.value(null);

  @override
  Future<Result<String>> signIn(String email, String password) async =>
      const Failure(_notConnected);

  @override
  Future<Result<void>> sendPasswordReset(String email) async =>
      const Failure(_notConnected);

  @override
  Future<Result<void>> signOut() async => const Success(null);

  @override
  Future<Result<void>> refreshSession() async => const Success(null);

  @override
  String? get currentUid => null;
}

/// User repository used when Firebase was not initialized at bootstrap.
/// Returns empty results for all operations.
class UnconfiguredUserRepository implements UserRepository {
  const UnconfiguredUserRepository();

  @override
  Stream<UserProfile?> watchProfile(String uid) => Stream<UserProfile?>.value(null);

  @override
  Future<Result<UserProfile>> getProfile(String uid) async =>
      const Failure(UnavailableException(
        message: 'Profile service is not available in this build.',
      ));

  @override
  Future<Result<UserProfile>> updateOwnProfile({
    required String uid,
    required Map<String, dynamic> fields,
  }) async =>
      const Failure(UnavailableException(
        message: 'Profile service is not available in this build.',
      ));

  @override
  Future<Result<UserProfile>> updateProfileAdmin({
    required String uid,
    required Map<String, dynamic> fields,
    required int expectedRevision,
  }) async =>
      const Failure(UnavailableException(
        message: 'Profile service is not available in this build.',
      ));

  @override
  Future<Result<({List<UserProfile> items, String? nextCursor})>> searchMembers({
    String? query,
    int limit = 20,
    String? startAfter,
  }) async =>
      const Failure(UnavailableException(
        message: 'Directory service is not available in this build.',
      ));
}

/// Event repository used when Firebase was not initialized at bootstrap.
/// Returns empty results for all operations.
class UnconfiguredEventRepository implements EventRepository {
  const UnconfiguredEventRepository();

  @override
  Stream<({List<Event> items, String? nextCursor})> watchEvents({
    String? audienceFilter,
    int limit = 20,
  }) =>
      Stream.value((items: <Event>[], nextCursor: null));

  @override
  Future<Result<({List<Event> items, String? nextCursor})>> getEvents({
    String? audienceFilter,
    int limit = 20,
    String? startAfter,
  }) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));

  @override
  Future<Result<Event>> getEvent(String eventId) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));

  @override
  Stream<Event?> watchEvent(String eventId) =>
      Stream.value(null);

  @override
  Future<Result<Event>> createEvent(EventDraft draft) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));

  @override
  Future<Result<Event>> updateEvent({
    required String eventId,
    required EventDraft draft,
    required int expectedRevision,
  }) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));

  @override
  Future<Result<void>> cancelEvent(String eventId,
      {required int expectedRevision}) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));

  @override
  Future<Result<void>> requestJoin(String eventId) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));

  @override
  Future<Result<void>> reviewJoinRequest({
    required String eventId,
    required String requesterUid,
    required JoinRequestDecision decision,
  }) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));

  @override
  Future<Result<JoinRequestStatus?>> getJoinRequestStatus(String eventId) async =>
      const Failure(UnavailableException(
        message: 'Events service is not available in this build.',
      ));
}

/// Announcement repository used when Firebase was not initialized at bootstrap.
/// Returns empty results for all operations.
class UnconfiguredAnnouncementRepository implements AnnouncementRepository {
  const UnconfiguredAnnouncementRepository();

  @override
  Stream<({List<Announcement> items, String? nextCursor})> watchAnnouncements({
    int limit = 20,
  }) =>
      Stream.value((items: <Announcement>[], nextCursor: null));

  @override
  Future<Result<({List<Announcement> items, String? nextCursor})>> getAnnouncements({
    int limit = 20,
    String? startAfter,
  }) async =>
      const Failure(UnavailableException(
        message: 'Announcements service is not available in this build.',
      ));

  @override
  Future<Result<Announcement>> getAnnouncement(String id) async =>
      const Failure(UnavailableException(
        message: 'Announcements service is not available in this build.',
      ));

  @override
  Stream<Announcement?> watchAnnouncement(String id) =>
      Stream.value(null);

  @override
  Future<Result<Announcement>> createAnnouncement(AnnouncementDraft draft) async =>
      const Failure(UnavailableException(
        message: 'Announcements service is not available in this build.',
      ));

  @override
  Future<Result<Announcement>> updateAnnouncement({
    required String id,
    required AnnouncementDraft draft,
    required int expectedRevision,
  }) async =>
      const Failure(UnavailableException(
        message: 'Announcements service is not available in this build.',
      ));

  @override
  Future<Result<Announcement>> publishAnnouncement(String id, {required int expectedRevision}) async =>
      const Failure(UnavailableException(
        message: 'Announcements service is not available in this build.',
      ));

  @override
  Future<Result<Announcement>> unpublishAnnouncement(String id, {required int expectedRevision}) async =>
      const Failure(UnavailableException(
        message: 'Announcements service is not available in this build.',
      ));
}

/// Application composition root.
///
/// Accepts/injects root dependencies, establishes Provider scopes, applies
/// [AppTheme], constructs the single router, and selects public
/// landing/auth/protected shell according to current auth/profile state via
/// [RouteGuard]. Contains no feature business logic and issues no Firestore
/// queries itself.
class NSRCApp extends StatefulWidget {
  const NSRCApp({
    super.key,
    this.authRepository,
    this.userRepository,
    this.eventRepository,
    this.announcementRepository,
    this.themeProvider,
    this.cacheService,
  });

  /// Null falls back to [UnconfiguredAuthRepository] (public pages only,
  /// sign-in disabled with an explicit message).
  final AuthRepository? authRepository;

  /// Null falls back to [UnconfiguredUserRepository] (profile unavailable).
  final UserRepository? userRepository;

  /// Null falls back to [UnconfiguredEventRepository] (events unavailable).
  final EventRepository? eventRepository;

  /// Null falls back to [UnconfiguredAnnouncementRepository] (announcements unavailable).
  final AnnouncementRepository? announcementRepository;

  final ThemeProvider? themeProvider;
  final CacheService? cacheService;

  @override
  State<NSRCApp> createState() => _NSRCAppState();
}

class _NSRCAppState extends State<NSRCApp> {
  late final ThemeProvider _themeProvider;
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final AuthController _authController;
  late final ProfileController _profileController;
  late final EventsController _eventsController;
  late final AnnouncementsController _announcementsController;
  late final SessionController _sessionController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _themeProvider = widget.themeProvider ?? ThemeProvider();
    // ignore: discarded_futures
    _themeProvider.load();
    _authRepository =
        widget.authRepository ?? const UnconfiguredAuthRepository();
    _userRepository = widget.userRepository ?? const UnconfiguredUserRepository();
    _authController = AuthController(authRepository: _authRepository);
    _profileController = ProfileController(userRepository: _userRepository);
    _eventsController = EventsController(
      eventRepository: widget.eventRepository ?? const UnconfiguredEventRepository(),
    );
    _announcementsController = AnnouncementsController(
      announcementRepository: widget.announcementRepository ?? const UnconfiguredAnnouncementRepository(),
    );
    _sessionController = SessionController(authRepository: _authRepository);
    _router = _createRouter();
  }

  @override
  void dispose() {
    _router.dispose();
    _sessionController.dispose();
    _authController.dispose();
    _profileController.dispose();
    _eventsController.dispose();
    _announcementsController.dispose();
    super.dispose();
  }

  Future<void> _signOut() => _authController.signOut();

  GoRouter _createRouter() => GoRouter(
        initialLocation: RouteNames.landing,
        refreshListenable: Listenable.merge([
          _sessionController,
          _themeProvider,
        ]),
        redirect: (context, state) {
          final result = RouteGuard(
            location: state.matchedLocation,
            authenticated: _sessionController.authenticated,
            profile: _sessionController.profile,
            profileReady: _sessionController.profileReady,
          ).evaluate();
          return switch (result.decision) {
            GuardDecision.allow => null,
            _ => result.location,
          };
        },
        errorBuilder: (context, state) => _PageUnavailableScreen(
          location: state.uri.path,
          onHome: () => context.go(RouteNames.landing),
        ),
        routes: [
          GoRoute(
            path: RouteNames.landing,
            builder: (context, state) => const LandingPage(),
          ),
          GoRoute(
            path: RouteNames.signIn,
            builder: (context, state) => AuthScreen(
              controller: _authController,
              demoMode: kDebugMode,
              demoSignIn: kDebugMode ? _openDemoPreview : null,
            ),
          ),
          GoRoute(
            path: RouteNames.passwordReset,
            builder: (context, state) =>
                PasswordResetScreen(onSubmit: _authController.sendPasswordReset),
          ),
          GoRoute(
            path: RouteNames.accessDenied,
            builder: (context, state) => AccessDeniedScreen(
              onSignOut: _signOut,
              onRetry: _sessionController.retry,
            ),
          ),
          // Protected routes are wrapped in AppShell
          ShellRoute(
            builder: (context, state, child) => ListenableBuilder(
              listenable: _sessionController,
              builder: (context, _) => AppShell(
                currentRoute: state.matchedLocation,
                profile: _sessionController.profile,
                onNavigate: (route) => context.go(route),
                onSignOut: _signOut,
                child: child,
              ),
            ),
            routes: [
              GoRoute(
                path: RouteNames.dashboard,
                builder: (context, state) => DashboardRouter(
                  profile: _sessionController.profile,
                  onSignOut: _signOut,
                ),
              ),
              GoRoute(
                path: RouteNames.memberDashboard,
                builder: (context, state) => MemberDashboard(
                  displayName: _sessionController.profile?.displayName ?? '',
                  onSignOut: _signOut,
                ),
              ),
              GoRoute(
                path: RouteNames.officerDashboard,
                builder: (context, state) => OfficerDashboard(
                  displayName: _sessionController.profile?.displayName ?? '',
                  onSignOut: _signOut,
                ),
              ),
              GoRoute(
                path: RouteNames.adminDashboard,
                builder: (context, state) => AdminDashboard(
                  displayName: _sessionController.profile?.displayName ?? '',
                  onSignOut: _signOut,
                ),
              ),
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => ListenableBuilder(
                  listenable: _sessionController,
                  builder: (context, _) => ProfileScreen(
                    controller: _profileController,
                    profile: _sessionController.profile!,
                    onSignOut: _signOut,
                  ),
                ),
              ),
              GoRoute(
                path: RouteNames.events,
                builder: (context, state) => ListenableBuilder(
                  listenable: _sessionController,
                  builder: (context, _) => EventsScreen(
                    controller: _eventsController,
                    sessionController: _sessionController,
                    authController: _authController,
                    onEventTap: (event) =>
                        context.go('${RouteNames.eventDetail}/${event.eventId}'),
                  ),
                ),
              ),
              GoRoute(
                path: RouteNames.announcements,
                builder: (context, state) => ListenableBuilder(
                  listenable: _sessionController,
                  builder: (context, _) => AnnouncementsScreen(
                    controller: _announcementsController,
                    sessionController: _sessionController,
                    authController: _authController,
                  ),
                ),
              ),
            ],
          ),
          if (kDebugMode)
            GoRoute(
              path: '/demo-admin',
              builder: (context, state) => const DemoAdminDashboardScreen(),
            ),
        ],
      );

  /// Debug-only local synthetic preview entry. No session, no data.
  Future<void> _openDemoPreview() async => _router.go('/demo-admin');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: _themeProvider),
        ChangeNotifierProvider<AuthController>.value(value: _authController),
        ChangeNotifierProvider<ProfileController>.value(value: _profileController),
        ChangeNotifierProvider<EventsController>.value(value: _eventsController),
        ChangeNotifierProvider<AnnouncementsController>.value(value: _announcementsController),
        ChangeNotifierProvider<SessionController>.value(
            value: _sessionController),
      ],
      child: ListenableBuilder(
        listenable: _themeProvider,
        builder: (context, _) => MaterialApp.router(
          title: 'Volunteer Management System',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _themeProvider.mode,
          routerConfig: _router,
        ),
      ),
    );
  }
}

/// Shown when a location passes the route guard but the screen is not
/// registered yet (feature not implemented in this build). Fails closed:
/// no protected content is rendered.
class _PageUnavailableScreen extends StatelessWidget {
  const _PageUnavailableScreen({
    required this.location,
    required this.onHome,
  });

  final String location;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Not available')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.construction_rounded, size: 34),
                  const SizedBox(height: 16),
                  Text(
                    'This area isn\'t available in this build yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'It is still being connected. Return to your dashboard '
                    'and check again later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(onPressed: onHome, child: const Text('Go home')),
                ],
              ),
            ),
          ),
        ),
      );
}