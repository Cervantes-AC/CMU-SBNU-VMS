import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/user_management_repository.dart';
import 'package:cmu_sbnu_vms/features/user_management/user_management.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for user management (admin only).
class UserManagementRepositoryImpl implements UserManagementRepository {
  UserManagementRepositoryImpl({
    required FirestoreService firestoreService,
    String? currentUid,
  }) : _firestore = firestoreService,
       _currentUid = currentUid;

  final FirestoreService _firestore;
  final String? _currentUid;

  CollectionReference<Map<String, dynamic>> _usersCollection() =>
      _firestore.instance.collection(FirestorePaths.users);

  @override
  Stream<({List<UserProfile> items, String? nextCursor})> watchUsers({
    UserManagementFilter? statusFilter,
    UserManagementSort? sort,
    int limit = 20,
  }) {
    var query = _usersCollection()
        .orderBy('displayName')
        .limit(limit);

    if (statusFilter != null) {
      query = query.where('status', isEqualTo: statusFilter.wire);
    }

    return query.snapshots().map((snapshot) {
      final users = <UserProfile>[];
      for (final doc in snapshot.docs) {
        try {
          users.add(UserProfile.fromFirestore(doc));
        } on FormatException {
          Logger.warn('user.parse', code: 'FORMAT',
              fields: {'uid': doc.id, 'exists': doc.exists});
        }
      }
      return (items: users, nextCursor: null);
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw UnexpectedException();
    });
  }

  @override
  Future<Result<({List<UserProfile> items, String? nextCursor})>> getUsers({
    UserManagementFilter? statusFilter,
    UserManagementSort? sort,
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      var query = _usersCollection().orderBy('displayName').limit(limit + 1);

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.wire);
      }
      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.get();
      final users = <UserProfile>[];
      for (final doc in snapshot.docs) {
        try {
          users.add(UserProfile.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = users.length > limit;
      final items = hasMore ? users.sublist(0, limit) : users;
      final nextCursor = hasMore ? items.last.displayName : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<UserProfile>> getUser(String uid) async {
    try {
      if (!FirestorePaths.isValidDocId(uid)) {
        return Failure(NotFoundException(resource: 'User'));
      }
      final doc = await _usersCollection().doc(uid).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'User'));
      }
      final user = UserProfile.fromFirestore(doc);
      return Success(user);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<UserManagementActionResult>> updateUserStatus({
    required String uid,
    required AccountStatus newStatus,
    required int expectedRevision,
  }) async {
    try {
      final uidCurrent = _currentUid;
      if (uidCurrent == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(uid)) {
        return Failure(PermissionDeniedException());
      }
      if (uidCurrent == uid) {
        return Failure(ValidationException(
            message: 'Cannot change your own status.',
            fieldErrors: {'status': 'Cannot change your own status.'}));
      }

      final doc = await _usersCollection().doc(uid).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'User'));
      }
      final current = UserProfile.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'User was modified by another process. Refresh and try again.'));
      }

      await _usersCollection().doc(uid).update({
        'status': newStatus.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _usersCollection().doc(uid).get();
      final updated = UserProfile.fromFirestore(freshDoc);
      return Success(UserManagementActionResult(
        success: true,
        message: 'Status updated to ${newStatus.wire}.',
        updatedUser: updated,
      ));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<UserManagementActionResult>> updateUserRole({
    required String uid,
    required UserRole newRole,
    required int expectedRevision,
  }) async {
    try {
      final uidCurrent = _currentUid;
      if (uidCurrent == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(uid)) {
        return Failure(PermissionDeniedException());
      }
      if (uidCurrent == uid) {
        return Failure(ValidationException(
            message: 'Cannot change your own role.',
            fieldErrors: {'role': 'Cannot change your own role.'}));
      }

      final doc = await _usersCollection().doc(uid).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'User'));
      }
      final current = UserProfile.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'User was modified by another process. Refresh and try again.'));
      }

      await _usersCollection().doc(uid).update({
        'role': newRole.wire,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _usersCollection().doc(uid).get();
      final updated = UserProfile.fromFirestore(freshDoc);
      return Success(UserManagementActionResult(
        success: true,
        message: 'Role updated to ${newRole.wire}.',
        updatedUser: updated,
      ));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<UserManagementActionResult>> updateUser({
    required String uid,
    required Map<String, dynamic> fields,
    required int expectedRevision,
  }) async {
    try {
      final uidCurrent = _currentUid;
      if (uidCurrent == null) {
        return Failure(UnauthenticatedException());
      }
      if (!FirestorePaths.isValidDocId(uid)) {
        return Failure(PermissionDeniedException());
      }
      if (uidCurrent == uid) {
        // Allow self-update of non-privileged fields
        final allowedFields = UserProfile.selfEditableFields;
        final filteredFields = Map<String, dynamic>.from(fields)
          ..removeWhere((key, _) => !allowedFields.contains(key));
        if (filteredFields.isEmpty) {
          return Failure(ValidationException(
              message: 'No editable fields provided.',
              fieldErrors: {}));
        }
      } else {
        // Admin can update any field - but protect privileged fields
        if (fields.containsKey('role') || fields.containsKey('status') ||
            fields.containsKey('uid') || fields.containsKey('createdAt') ||
            fields.containsKey('revision')) {
          return Failure(PermissionDeniedException());
        }
      }

      final doc = await _usersCollection().doc(uid).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'User'));
      }
      final current = UserProfile.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'User was modified by another process. Refresh and try again.'));
      }

      await _usersCollection().doc(uid).update({
        ...fields,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });

      final freshDoc = await _usersCollection().doc(uid).get();
      final updated = UserProfile.fromFirestore(freshDoc);
      return Success(UserManagementActionResult(
        success: true,
        message: 'User updated successfully.',
        updatedUser: updated,
      ));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<UserManagementActionResult>> deactivateUser(String uid) async {
    return updateUserStatus(
      uid: uid,
      newStatus: AccountStatus.deactivated,
      expectedRevision: 0, // Will be validated in updateUserStatus
    );
  }

  @override
  Future<Result<UserManagementActionResult>> reactivateUser(String uid) async {
    return updateUserStatus(
      uid: uid,
      newStatus: AccountStatus.approved,
      expectedRevision: 0,
    );
  }

  @override
  Future<Result<({List<UserProfile> items, String? nextCursor})>> searchUsers({
    required String searchQuery,
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      // Simple case-insensitive search on displayName
      // In production, use Algolia or Firestore full-text search
      var query = _usersCollection()
          .where('displayName', isGreaterThanOrEqualTo: searchQuery)
          .where('displayName', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .orderBy('displayName')
          .limit(limit + 1);

      if (startAfter != null) {
        // For search, we can't easily paginate with prefix matching
        // This is a simplified implementation
      }

      final snapshot = await query.get();
      final users = <UserProfile>[];
      for (final doc in snapshot.docs) {
        try {
          users.add(UserProfile.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = users.length > limit;
      final items = hasMore ? users.sublist(0, limit) : users;
      final nextCursor = hasMore ? items.last.displayName : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }

  @override
  Future<Result<UserStatistics>> getUserStatistics() async {
    try {
      final snapshot = await _usersCollection().get();
      int total = 0;
      int pending = 0;
      int approved = 0;
      int denied = 0;
      int suspended = 0;
      int deactivated = 0;
      int blocked = 0;
      int officers = 0;
      int admins = 0;

      for (final doc in snapshot.docs) {
        try {
          final user = UserProfile.fromFirestore(doc);
          total++;
          switch (user.status) {
            case AccountStatus.pending:
              pending++;
              break;
            case AccountStatus.approved:
              approved++;
              break;
            case AccountStatus.denied:
              denied++;
              break;
            case AccountStatus.suspended:
              suspended++;
              break;
            case AccountStatus.deactivated:
              deactivated++;
              break;
            case AccountStatus.blocked:
              blocked++;
              break;
          }
          if (user.role == UserRole.officer) officers++;
          if (user.role == UserRole.admin) admins++;
        } on FormatException {
          // Skip malformed entries.
        }
      }

      return Success(UserStatistics(
        total: total,
        pending: pending,
        approved: approved,
        denied: denied,
        suspended: suspended,
        deactivated: deactivated,
        blocked: blocked,
        officers: officers,
        admins: admins,
      ));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? UnexpectedException());
    }
  }
}