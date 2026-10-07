/// Immutable product-independent limits and configuration keys.
///
/// Do not store API keys, passwords, real phone numbers, role policies, or
/// mutable feature state here. Constants requiring product approval must be
/// annotated with the decision/source.
class AppConstants {
  AppConstants._();

  /// Maximum page size for paginated queries.
  static const int defaultPageSize = 20;

  /// Maximum page size for paginated queries (hard limit).
  static const int maxPageSize = 100;

  /// Maximum characters for short text inputs (e.g., titles, names).
  static const int shortTextMaxLength = 100;

  /// Maximum characters for long text inputs (e.g., descriptions, notes).
  static const int longTextMaxLength = 2000;

  /// Maximum characters for announcement body.
  static const int announcementBodyMaxLength = 5000;

  /// Cache schema version. Increment when cache format changes.
  static const int cacheSchemaVersion = 1;

  /// Unit timezone identifier (IANA). Confirmed by product decision.
  /// TODO: Replace with approved timezone once decision is recorded.
  static const String unitTimezone = 'Asia/Manila';

  /// Application metadata.
  static const String appName = 'CMU SBNU VMS';
  static const String appVersion = '1.0.0';

  /// Environment configuration keys (used with --dart-define).
  static const String envFirebaseProjectId = 'FIREBASE_PROJECT_ID';
  static const String envFirebaseApiKey = 'FIREBASE_API_KEY';
  static const String envFirebaseAppId = 'FIREBASE_APP_ID';
  static const String envFirebaseMessagingSenderId = 'FIREBASE_MESSAGING_SENDER_ID';
  static const String envFirebaseAuthDomain = 'FIREBASE_AUTH_DOMAIN';
  static const String envFirebaseStorageBucket = 'FIREBASE_STORAGE_BUCKET';
  static const String envFirebaseMeasurementId = 'FIREBASE_MEASUREMENT_ID';

  /// Feature flags (enable via --dart-define).
  static const String featureFlagAnalytics = 'FEATURE_ANALYTICS';
  static const String featureFlagOffline = 'FEATURE_OFFLINE';
  static const String featureFlagQrDuty = 'FEATURE_QR_DUTY';
  static const String featureFlagIncidents = 'FEATURE_INCIDENTS';
  static const String featureFlagReports = 'FEATURE_REPORTS';
  static const String featureFlagAdminTools = 'FEATURE_ADMIN_TOOLS';
}