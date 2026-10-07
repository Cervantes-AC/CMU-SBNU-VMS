/// Typed path builders for only approved collections and nested paths.
///
/// Validate path segments and never accept a raw user-provided collection name.
/// Names must match firestore.rules, indexes and the data dictionary.
class FirestorePaths {
  FirestorePaths._();

  // Collection names
  static const String users = 'users';
  static const String memberDirectory = 'memberDirectory';
  static const String events = 'events';
  static const String eventJoinRequests = 'eventJoinRequests';
  static const String attendance = 'attendance';
  static const String incidents = 'incidents';
  static const String announcements = 'announcements';
  static const String qrDutySessions = 'qrDutySessions';
  static const String qrDutyScans = 'qrDutyScans';
  static const String auditLogs = 'auditLogs';
  static const String userDevices = 'userDevices';
  static const String contactInquiries = 'contactInquiries';

  // Document path builders
  static String userDoc(String uid) => '$users/$uid';
  static String memberDirectoryDoc(String uid) => '$memberDirectory/$uid';
  static String eventDoc(String eventId) => '$events/$eventId';
  static String eventJoinRequestDoc(String requestId) => '$eventJoinRequests/$requestId';
  static String attendanceDoc(String attendanceId) => '$attendance/$attendanceId';
  static String incidentDoc(String incidentId) => '$incidents/$incidentId';
  static String announcementDoc(String announcementId) => '$announcements/$announcementId';
  static String qrDutySessionDoc(String sessionId) => '$qrDutySessions/$sessionId';
  static String qrDutyScanDoc(String scanId) => '$qrDutyScans/$scanId';
  static String auditLogDoc(String logId) => '$auditLogs/$logId';
  static String userDeviceTokenDoc(String uid, String tokenId) =>
      '$userDevices/$uid/tokens/$tokenId';
  static String contactInquiryDoc(String inquiryId) => '$contactInquiries/$inquiryId';

  // Subcollection path builders
  static String eventJoinRequestsCollection(String eventId) =>
      '${eventDoc(eventId)}/joinRequests';
  static String attendanceCollection(String eventId) =>
      '${eventDoc(eventId)}/attendance';
  static String qrDutyScansCollection(String sessionId) =>
      '${qrDutySessionDoc(sessionId)}/scans';

  /// Validates a document ID is safe for Firestore (non-empty, no forward slashes).
  static bool isValidDocId(String id) =>
      id.isNotEmpty && !id.contains('/') && id.length <= 1500;

  /// Validates a collection name is safe (non-empty, no forward slashes).
  static bool isValidCollectionName(String name) =>
      name.isNotEmpty && !name.contains('/');
}