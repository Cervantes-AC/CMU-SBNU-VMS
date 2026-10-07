/// User account profile model with role and lifecycle status.
///
/// Wire values are defined in docs/architecture/data-and-access.md.
/// `totalServiceHours` is deliberately NOT part of the client-writable
/// profile — service-hour totals come from server-computed summaries.
/// `canAccessApp` is derived, never serialized as authority.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Role wire values are lowercase snake_case.
enum UserRole {
  member('member'),
  officer('officer'),
  admin('admin');

  const UserRole(this.wire);
  final String wire;

  /// Parses a wire value; unknown values resolve to null (fail closed at
  /// the call site).
  static UserRole? tryParse(String? raw) {
    if (raw == null) return null;
    for (final r in UserRole.values) {
      if (r.wire == raw) return r;
    }
    return null;
  }
}

/// Account lifecycle status wire values.
enum AccountStatus {
  pending('pending'),
  approved('approved'),
  denied('denied'),
  suspended('suspended'),
  deactivated('deactivated'),
  blocked('blocked');

  const AccountStatus(this.wire);
  final String wire;

  static AccountStatus? tryParse(String? raw) {
    if (raw == null) return null;
    for (final s in AccountStatus.values) {
      if (s.wire == raw) return s;
    }
    return null;
  }
}

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.revision = 0,
    this.schemaVersion = 1,
    this.email,
    this.photoUrl,
    this.course,
    this.yearLevel,
    this.contactNumber,
  });

  final String uid;
  final String displayName;
  final UserRole role;
  final AccountStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Optimistic-concurrency revision counter.
  final int revision;
  final int schemaVersion;

  /// Restricted fields — never shown in directory projections.
  final String? email;
  final String? photoUrl;
  final String? course;
  final String? yearLevel;
  final String? contactNumber;

  /// Derived: only approved accounts may enter protected routes. Not
  /// serialized as authority — backend rules re-check.
  bool get canAccessApp => status == AccountStatus.approved;

  /// Derived: whether this profile may manage events/attendance (UI hint only).
  bool get canOperate => role == UserRole.officer || role == UserRole.admin;

  /// Derived: whether this profile is an administrator (UI hint only).
  bool get isAdmin => role == UserRole.admin;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final uid = map['uid'];
    final displayName = map['displayName'];
    final role = UserRole.tryParse(map['role']);
    final status = AccountStatus.tryParse(map['status']);
    if (uid is! String || uid.isEmpty) {
      throw const FormatException('Missing uid');
    }
    if (displayName is! String) {
      throw const FormatException('Missing displayName');
    }
    if (role == null) {
      throw const FormatException('Unknown role');
    }
    if (status == null) {
      throw const FormatException('Unknown status');
    }
    return UserProfile(
      uid: uid,
      displayName: displayName,
      role: role,
      status: status,
      createdAt: _toUtc(map['createdAt']) ?? DateTime.now().toUtc(),
      updatedAt: _toUtc(map['updatedAt']) ?? DateTime.now().toUtc(),
      revision: map['revision'] is int ? map['revision'] as int : 0,
      schemaVersion:
          map['schemaVersion'] is int ? map['schemaVersion'] as int : 1,
      email: map['email'] is String ? map['email'] as String : null,
      photoUrl: map['photoUrl'] is String ? map['photoUrl'] as String : null,
      course: map['course'] is String ? map['course'] as String : null,
      yearLevel: map['yearLevel'] is String ? map['yearLevel'] as String : null,
      contactNumber:
          map['contactNumber'] is String ? map['contactNumber'] as String : null,
    );
  }

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const FormatException('Missing profile document');
    }
    return UserProfile.fromMap(data);
  }

  /// Serializes only approved client-readable fields. Privileged fields
  /// (role/status/createdAt/revision) are never written from the client.
  Map<String, dynamic> toMap() => {
        'uid': uid,
        'displayName': displayName,
        'role': role.wire,
        'status': status.wire,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'revision': revision,
        'schemaVersion': schemaVersion,
        if (email != null) 'email': email,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (course != null) 'course': course,
        if (yearLevel != null) 'yearLevel': yearLevel,
        if (contactNumber != null) 'contactNumber': contactNumber,
      };

  /// Fields a member may edit on their own profile (allowlist). Role,
  /// status, uid, createdAt and any hours total are excluded by design.
  static const Set<String> selfEditableFields = {
    'displayName',
    'photoUrl',
    'course',
    'yearLevel',
    'contactNumber',
  };

  UserProfile copyWith({
    String? displayName,
    String? photoUrl,
    String? course,
    String? yearLevel,
    String? contactNumber,
    AccountStatus? status,
    UserRole? role,
    int? revision,
    DateTime? updatedAt,
  }) =>
      UserProfile(
        uid: uid,
        displayName: displayName ?? this.displayName,
        role: role ?? this.role,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        revision: revision ?? this.revision,
        schemaVersion: schemaVersion,
        email: email,
        photoUrl: photoUrl ?? this.photoUrl,
        course: course ?? this.course,
        yearLevel: yearLevel ?? this.yearLevel,
        contactNumber: contactNumber ?? this.contactNumber,
      );

  static DateTime? _toUtc(Object? value) {
    if (value is Timestamp) return value.toDate().toUtc();
    if (value is String) return DateTime.tryParse(value)?.toUtc();
    return null;
  }

  @override
  String toString() =>
      'UserProfile(uid: $uid, role: ${role.wire}, status: ${status.wire})';
}
