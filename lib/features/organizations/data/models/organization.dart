import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.status,
    required this.coordinatorUids,
    this.parentOrgId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String status; // active, inactive, pending
  final List<String> coordinatorUids;
  final String? parentOrgId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive => status == 'active';

  factory Organization.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Organization(
      id: doc.id,
      name: data['name'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      coordinatorUids: List<String>.from(data['coordinatorUids'] ?? const []),
      parentOrgId: data['parentOrgId'] as String?,
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'status': status,
      'coordinatorUids': coordinatorUids,
      if (parentOrgId != null) 'parentOrgId': parentOrgId,
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
