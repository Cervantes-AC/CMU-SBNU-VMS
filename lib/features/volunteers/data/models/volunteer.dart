import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerProfile {
  const VolunteerProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.college,
    this.course,
    this.studentId,
    this.phone,
    this.status = 'pending',
    this.organizationIds = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String fullName;
  final String email;
  final String? college;
  final String? course;
  final String? studentId;
  final String? phone;
  final String status; // pending, active, suspended
  final List<String> organizationIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';

  factory VolunteerProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VolunteerProfile(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      college: data['college'] as String?,
      course: data['course'] as String?,
      studentId: data['studentId'] as String?,
      phone: data['phone'] as String?,
      status: data['status'] as String? ?? 'pending',
      organizationIds: List<String>.from(data['organizationIds'] ?? const []),
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
      if (college != null) 'college': college,
      if (course != null) 'course': course,
      if (studentId != null) 'studentId': studentId,
      if (phone != null) 'phone': phone,
      'status': status,
      'organizationIds': organizationIds,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
