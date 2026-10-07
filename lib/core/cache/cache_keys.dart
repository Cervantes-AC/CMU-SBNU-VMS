/// Stable, namespaced cache keys with versioning.
///
/// User-specific keys include UID and schema version. Never use raw
/// Firestore paths as cache keys.
class CacheKeys {
  CacheKeys._();

  static const int schemaVersion = 1;

  static String _ns(String name) => 'cache.v$schemaVersion.$name';

  /// Session-independent keys.
  static String themeMode() => _ns('theme_mode');
  static String announcementsFeed(String audience) =>
      _ns('announcements.$audience');
  static String publishedEvents() => _ns('events.published');
  static String emergencyHotlines() => _ns('hotlines');

  /// User-scoped keys (clear on sign-out / account disable).
  static String userScope(String uid) => 'user.$uid';
  static String currentProfile(String uid) => _ns('profile.$uid');
  static String memberEvents(String uid) => _ns('events.member.$uid');
  static String memberAttendance(String uid) => _ns('attendance.member.$uid');
  static String memberIncidents(String uid) => _ns('incidents.member.$uid');
  static String serviceHourSummary(String uid) =>
      _ns('hours.member.$uid');
}
