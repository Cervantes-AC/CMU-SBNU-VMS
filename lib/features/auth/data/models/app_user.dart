import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Application user model mapped from Firebase Auth and Firestore.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.accountStatus = 'pending',
    this.roleRef,
    this.organizationIds = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String accountStatus;
  final String? roleRef;
  final List<String> organizationIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isAuthenticated => uid.isNotEmpty;
  bool get isActive => accountStatus == 'active';
  bool get isPending => accountStatus == 'pending';
  bool get isSuspended => accountStatus == 'suspended';

  factory AppUser.fromFirebaseAuthUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: data['uid'] as String? ?? doc.id,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      accountStatus: data['accountStatus'] as String? ?? 'pending',
      roleRef: data['roleRef'] as String?,
      organizationIds: List<String>.from(data['organizationIds'] ?? const []),
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      if (email != null) 'email': email,
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'accountStatus': accountStatus,
      if (roleRef != null) 'roleRef': roleRef,
      'organizationIds': organizationIds,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? accountStatus,
    String? roleRef,
    List<String>? organizationIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      accountStatus: accountStatus ?? this.accountStatus,
      roleRef: roleRef ?? this.roleRef,
      organizationIds: organizationIds ?? this.organizationIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, status: $accountStatus)';

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
