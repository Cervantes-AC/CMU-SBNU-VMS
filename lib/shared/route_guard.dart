import '../core/constants/route_names.dart';
import '../data/models/user.dart';

/// What a route requires of the visitor's session.
enum AuthRequirement {
  /// Anyone may view (landing, sign-in, password reset).
  public,

  /// Signed-in session required (profile, settings).
  authenticated,

  /// Signed-in AND `status == approved`.
  approved,

  /// Approved AND a specific role.
  role,
}

/// Explicit route access metadata shared by the router and [RouteGuard].
class RouteAccess {
  const RouteAccess({
    required this.path,
    required this.requirement,
    this.roles,
  });

  /// Route path pattern (go_router style, e.g. '/events/:eventId').
  final String path;
  final AuthRequirement requirement;

  /// Required roles when [requirement] is [AuthRequirement.role].
  final Set<UserRole>? roles;

  bool allows(UserRole? role) => requirement == AuthRequirement.role
      ? (role != null && roles!.contains(role))
      : true;
}

/// Central route access table. No screen invents route strings or
/// authorization metadata.
class RouteTable {
  RouteTable._();

  static const RouteAccess landing = RouteAccess(
    path: RouteNames.landing,
    requirement: AuthRequirement.public,
  );
  static const RouteAccess signIn = RouteAccess(
    path: RouteNames.signIn,
    requirement: AuthRequirement.public,
  );
  static const RouteAccess passwordReset = RouteAccess(
    path: RouteNames.passwordReset,
    requirement: AuthRequirement.public,
  );

  static const RouteAccess dashboard = RouteAccess(
    path: RouteNames.dashboard,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess memberDashboard = RouteAccess(
    path: RouteNames.memberDashboard,
    requirement: AuthRequirement.role,
    roles: {UserRole.member, UserRole.officer, UserRole.admin},
  );
  static const RouteAccess officerDashboard = RouteAccess(
    path: RouteNames.officerDashboard,
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );
  static const RouteAccess adminDashboard = RouteAccess(
    path: RouteNames.adminDashboard,
    requirement: AuthRequirement.role,
    roles: {UserRole.admin},
  );

  static const RouteAccess profile = RouteAccess(
    path: RouteNames.profile,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess profileEdit = RouteAccess(
    path: RouteNames.profileEdit,
    requirement: AuthRequirement.approved,
  );

  static const RouteAccess events = RouteAccess(
    path: RouteNames.events,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess eventDetail = RouteAccess(
    path: RouteNames.eventDetail,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess eventForm = RouteAccess(
    path: '/events/form/:eventId?',
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );

  static const RouteAccess memberAttendance = RouteAccess(
    path: RouteNames.memberAttendance,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess eventAttendance = RouteAccess(
    path: '/events/:eventId/attendance',
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );

  static const RouteAccess qrDutyScanner = RouteAccess(
    path: RouteNames.qrDutyScanner,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess qrDutyGenerator = RouteAccess(
    path: '/qr-duty/generate/:eventId',
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );
  static const RouteAccess qrDutyMonitoring = RouteAccess(
    path: '/qr-duty/monitor/:eventId',
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );

  static const RouteAccess myIncidents = RouteAccess(
    path: RouteNames.myIncidents,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess incidentReport = RouteAccess(
    path: RouteNames.incidentReport,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess incidentDetail = RouteAccess(
    path: RouteNames.incidentDetail,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess incidentQueue = RouteAccess(
    path: RouteNames.incidentQueue,
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );

  static const RouteAccess announcements = RouteAccess(
    path: RouteNames.announcements,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess announcementDetail = RouteAccess(
    path: RouteNames.announcementDetail,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess announcementForm = RouteAccess(
    path: '/announcements/form/:announcementId?',
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );

  static const RouteAccess reports = RouteAccess(
    path: RouteNames.reports,
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );
  static const RouteAccess analytics = RouteAccess(
    path: RouteNames.analytics,
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );
  static const RouteAccess userManagement = RouteAccess(
    path: RouteNames.userManagement,
    requirement: AuthRequirement.role,
    roles: {UserRole.admin},
  );
  static const RouteAccess auditLogs = RouteAccess(
    path: RouteNames.auditLogs,
    requirement: AuthRequirement.role,
    roles: {UserRole.admin},
  );
  static const RouteAccess importExport = RouteAccess(
    path: RouteNames.importExport,
    requirement: AuthRequirement.role,
    roles: {UserRole.admin},
  );
  static const RouteAccess backupManagement = RouteAccess(
    path: RouteNames.backupManagement,
    requirement: AuthRequirement.role,
    roles: {UserRole.admin},
  );
  static const RouteAccess databaseManagement = RouteAccess(
    path: RouteNames.databaseManagement,
    requirement: AuthRequirement.role,
    roles: {UserRole.admin},
  );
  static const RouteAccess adminQueries = RouteAccess(
    path: RouteNames.adminQueries,
    requirement: AuthRequirement.role,
    roles: {UserRole.admin},
  );
  static const RouteAccess accomplishmentReports = RouteAccess(
    path: RouteNames.accomplishmentReports,
    requirement: AuthRequirement.role,
    roles: {UserRole.officer, UserRole.admin},
  );

  static const RouteAccess settings = RouteAccess(
    path: RouteNames.settings,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess userGuide = RouteAccess(
    path: RouteNames.userGuide,
    requirement: AuthRequirement.approved,
  );
  static const RouteAccess emergencyHotlines = RouteAccess(
    path: RouteNames.emergencyHotlines,
    requirement: AuthRequirement.approved,
  );

  /// The authenticated shell entry target per role (single source of truth
  /// for post-sign-in routing).
  static String dashboardPathFor(UserRole? role) => switch (role) {
    UserRole.admin => RouteNames.adminDashboard,
    UserRole.officer => RouteNames.officerDashboard,
    UserRole.member => RouteNames.memberDashboard,
    null => RouteNames.landing,
  };

  /// All protected routes for redirect evaluation.
  static const List<RouteAccess> protected = [
    dashboard,
    memberDashboard,
    officerDashboard,
    adminDashboard,
    profile,
    profileEdit,
    events,
    eventDetail,
    eventForm,
    memberAttendance,
    eventAttendance,
    qrDutyScanner,
    qrDutyGenerator,
    qrDutyMonitoring,
    myIncidents,
    incidentReport,
    incidentDetail,
    incidentQueue,
    announcements,
    announcementDetail,
    announcementForm,
    reports,
    analytics,
    userManagement,
    auditLogs,
    importExport,
    backupManagement,
    databaseManagement,
    adminQueries,
    accomplishmentReports,
    settings,
    userGuide,
    emergencyHotlines,
  ];
}

/// Why a redirect decision was made — useful for tests and diagnostics.
enum GuardDecision {
  allow,
  redirectToSignIn,
  redirectToDashboard,
  redirectToDenied,
}

class GuardResult {
  const GuardResult(this.decision, {this.location});
  final GuardDecision decision;

  /// Redirect target path when applicable.
  final String? location;

  @override
  String toString() => 'GuardResult($decision, $location)';
}

/// Applies signed-in, approved status, and role policy to route decisions.
///
/// Resolves unknown/malformed roles to denied. Returns redirect decisions
/// without doing database I/O during widget build; the app layer consumes
/// the auth/profile stream. Backend rules remain authoritative.
class RouteGuard {
  const RouteGuard({
    required this.location,
    required this.authenticated,
    required this.profile,
    this.profileReady = true,
  });

  /// The location being evaluated (path with optional query).
  final String location;

  /// Null while the auth state is still resolving; false when signed out.
  final bool? authenticated;

  /// Current profile; null while loading, missing, or signed out.
  final UserProfile? profile;

  /// False until the first profile emission for the signed-in user has
  /// arrived (or failed). While false, protected locations hold on a public
  /// page instead of bouncing through access-denied.
  final bool profileReady;

  static final RegExp _publicPatterns = RegExp(
    r'^(/|/sign-in|/sign-up|/password-reset|/access-denied|/access/pending|/demo-admin)$',
  );

  /// Matches parameterized public-style prefixes.
  static bool _isPublic(String location) {
    if (_publicPatterns.hasMatch(location)) return true;
    // Public routes with optional params (none currently parameterized).
    return false;
  }

  GuardResult evaluate() {
    final pathOnly = location.split('?').first;
    final isPublic = _isPublic(pathOnly);

    // Not signed in (or auth state still resolving: fail closed toward the
    // public pages and re-evaluate when the session emits).
    if (authenticated == null || authenticated == false) {
      return isPublic
          ? const GuardResult(GuardDecision.allow)
          : const GuardResult(
              GuardDecision.redirectToSignIn,
              location: RouteNames.signIn,
            );
    }

    // Signed in, profile not resolved yet: hold on public pages, keep
    // protected deep links on the landing page until the profile arrives.
    if (!profileReady) {
      return isPublic
          ? const GuardResult(GuardDecision.allow)
          : const GuardResult(
              GuardDecision.redirectToDashboard,
              location: RouteNames.landing,
            );
    }

    // Signed in but visiting public auth pages → hand off to dashboard.
    if (pathOnly == RouteNames.signIn || pathOnly == RouteNames.passwordReset) {
      if (profile?.canAccessApp == true) {
        return GuardResult(
          GuardDecision.redirectToDashboard,
          location: RouteTable.dashboardPathFor(profile?.role),
        );
      }
      // Signed-in but not approved: allow password reset, deny sign-in by
      // sending to access-denied (pending users must not reach app data).
      return pathOnly == RouteNames.passwordReset
          ? const GuardResult(GuardDecision.allow)
          : const GuardResult(
              GuardDecision.redirectToDenied,
              location: RouteNames.accessDenied,
            );
    }

    // Profile resolved: missing or malformed profile fails closed.
    final current = profile;
    if (current == null) {
      return const GuardResult(
        GuardDecision.redirectToDenied,
        location: RouteNames.accessDenied,
      );
    }
    if (!current.canAccessApp) {
      // Pending users get a dedicated screen; other non-approved statuses get access denied.
      final isPending = current.status == AccountStatus.pending;
      return GuardResult(
        isPending
            ? GuardDecision.redirectToDenied
            : GuardDecision.redirectToDenied,
        location: isPending
            ? RouteNames.pendingAccess
            : RouteNames.accessDenied,
      );
    }

    // Public pages remain reachable for approved users (access-denied,
    // debug-only local preview).
    if (pathOnly != RouteNames.landing &&
        pathOnly != RouteNames.signIn &&
        pathOnly != RouteNames.passwordReset &&
        isPublic) {
      return const GuardResult(GuardDecision.allow);
    }

    // Landing for an approved user hands off to their dashboard.
    if (pathOnly == RouteNames.landing) {
      return GuardResult(
        GuardDecision.redirectToDashboard,
        location: RouteTable.dashboardPathFor(current.role),
      );
    }

    // Find matching protected route by longest-pattern match.
    final access = _match(pathOnly);
    if (access == null) {
      // Unknown path → denied (fail closed).
      return const GuardResult(
        GuardDecision.redirectToDenied,
        location: RouteNames.accessDenied,
      );
    }

    // Role requirement: unknown role values already fail closed in
    // UserRole.tryParse, so profile.role is always a known value.
    if (access.requirement == AuthRequirement.role &&
        !access.allows(current.role)) {
      return GuardResult(
        GuardDecision.redirectToDenied,
        location: RouteTable.dashboardPathFor(current.role),
      );
    }

    return const GuardResult(GuardDecision.allow);
  }

  /// Longest-pattern match of [path] against the protected table.
  static RouteAccess? _match(String path) {
    RouteAccess? best;
    for (final access in RouteTable.protected) {
      if (_patternMatches(access.path, path)) {
        if (best == null || access.path.length > best.path.length) {
          best = access;
        }
      }
    }
    return best;
  }

  /// Matches a route pattern containing ':param' or ':param?' segments.
  static bool _patternMatches(String pattern, String path) {
    final patternSegments = pattern.split('/');
    final pathSegments = path.split('/');
    if (patternSegments.length != pathSegments.length) return false;
    for (var i = 0; i < patternSegments.length; i++) {
      final p = patternSegments[i];
      final v = pathSegments[i];
      if (p.startsWith(':')) {
        final optional = p.endsWith('?');
        if (v.isEmpty && !optional) return false;
        continue;
      }
      if (p != v) return false;
    }
    return true;
  }
}
