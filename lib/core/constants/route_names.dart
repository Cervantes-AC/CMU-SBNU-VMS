/// Typed route path/name definitions for public routes and feature routes.
///
/// Keep route authorization metadata in one shared route table used by the
/// router and [RouteGuard]; no screen should invent route strings.
class RouteNames {
  RouteNames._();

  /// Public landing page (unauthenticated).
  static const String landing = '/';

  /// Sign-in screen.
  static const String signIn = '/sign-in';

  /// Password reset request screen.
  static const String passwordReset = '/password-reset';

  /// Authenticated shell entry point (redirects to role-appropriate dashboard).
  static const String dashboard = '/dashboard';

  /// Member dashboard.
  static const String memberDashboard = '/dashboard/member';

  /// Officer dashboard.
  static const String officerDashboard = '/dashboard/officer';

  /// Administrator dashboard.
  static const String adminDashboard = '/dashboard/admin';

  /// Profile screen (own profile).
  static const String profile = '/profile';

  /// Profile edit screen.
  static const String profileEdit = '/profile/edit';

  /// Events list screen.
  static const String events = '/events';

  /// Event detail screen.
  static const String eventDetail = '/events/:eventId';

  /// Event form (create/edit) - staff only.
  static const String eventForm = '/events/form/:eventId?';

  /// Member's attendance history.
  static const String memberAttendance = '/attendance/mine';

  /// Event attendance roster (officer) - requires eventId.
  static const String eventAttendance = '/events/:eventId/attendance';

  /// QR Duty scanner (member).
  static const String qrDutyScanner = '/qr-duty/scan';

  /// QR Duty generator (officer) - requires eventId.
  static const String qrDutyGenerator = '/qr-duty/generate/:eventId';

  /// QR Duty monitoring (officer) - requires eventId.
  static const String qrDutyMonitoring = '/qr-duty/monitor/:eventId';

  /// Incidents list (reporter's own).
  static const String myIncidents = '/incidents/mine';

  /// Incident report form.
  static const String incidentReport = '/incidents/report';

  /// Incident detail screen.
  static const String incidentDetail = '/incidents/:incidentId';

  /// Responder incident queue (officer/admin).
  static const String incidentQueue = '/incidents/queue';

  /// Announcements list.
  static const String announcements = '/announcements';

  /// Announcement detail.
  static const String announcementDetail = '/announcements/:announcementId';

  /// Announcement form (staff).
  static const String announcementForm = '/announcements/form/:announcementId?';

  /// Reports screen.
  static const String reports = '/reports';

  /// Analytics screen.
  static const String analytics = '/analytics';

  /// User management (admin).
  static const String userManagement = '/admin/users';

  /// Audit logs (admin).
  static const String auditLogs = '/admin/audit-logs';

  /// Emergency hotlines.
  static const String emergencyHotlines = '/emergency-hotlines';

  /// Settings.
  static const String settings = '/settings';

  /// User guide.
  static const String userGuide = '/help';

  /// Access denied screen.
  static const String accessDenied = '/access-denied';

  /// Import/Export (admin).
  static const String importExport = '/admin/import-export';

  /// Backup management (admin).
  static const String backupManagement = '/admin/backup';

  /// Database management (admin).
  static const String databaseManagement = '/admin/database';

  /// Admin queries (admin).
  static const String adminQueries = '/admin/queries';

  /// Accomplishment reports (officer).
  static const String accomplishmentReports = '/reports/accomplishment';

  /// Landing page parts routes (if needed for deep linking).
  static const String landingHero = '/landing/hero';
  static const String landingContent = '/landing/content';
}