import 'dart:async';

import '../../core/cache/cache_keys.dart';
import '../../core/cache/cache_service.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/user_repository.dart';
import '../models/user.dart';
import '../services/firestore_service.dart';

/// Coordinates Firestore reads/writes for user profiles and directory.
///
/// Enforces the self-editable field allowlist on `updateOwnProfile`.
/// Admin mutations go through a separate method that validates revision.
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required FirestoreService firestoreService,
    CacheService? cacheService,
  }) : _firestore = firestoreService,
       _cache = cacheService;

  final FirestoreService _firestore;
  final CacheService? _cache;

  static const _profileCacheTtl = Duration(minutes: 5);

  @override
  Stream<UserProfile?> watchProfile(String uid) {
    if (!FirestorePaths.isValidDocId(uid)) {
      return Stream.value(null);
    }
    return _firestore.userDocument(uid).snapshots().map((doc) {
      try {
        if (!doc.exists) return null;
        final profile = UserProfile.fromFirestore(doc);
        _cacheEntry(uid, profile);
        return profile;
      } on FormatException {
        Logger.warn('profile.parse', code: 'FORMAT',
            fields: {'uid': uid, 'exists': doc.exists});
        return null;
      }
    }).handleError((Object error, StackTrace st) {
      final mapped = mapToAppException(error, st);
      if (mapped != null) throw mapped;
      throw const UnexpectedException();
    });
  }

  @override
  Future<Result<UserProfile>> getProfile(String uid) async {
    try {
      if (!FirestorePaths.isValidDocId(uid)) {
        return Failure(NotFoundException(resource: 'Profile'));
      }
      // Check cache first.
      final cached = await _cache?.get<UserProfile>(CacheKeys.currentProfile(uid));
      if (cached != null && !cached.isStale(_profileCacheTtl)) {
        return Success(cached.value);
      }
      final doc = await _firestore.userDocument(uid).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Profile'));
      }
      final profile = UserProfile.fromFirestore(doc);
      await _cacheEntry(uid, profile);
      return Success(profile);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<UserProfile>> updateOwnProfile({
    required String uid,
    required Map<String, dynamic> fields,
  }) async {
    try {
      if (!FirestorePaths.isValidDocId(uid)) {
        return const Failure(PermissionDeniedException());
      }
      // Filter to self-editable fields only.
      final allowed = <String, dynamic>{};
      for (final entry in fields.entries) {
        if (UserProfile.selfEditableFields.contains(entry.key)) {
          allowed[entry.key] = entry.value;
        }
      }
      if (allowed.isEmpty) {
        return Failure(ValidationException(
            message: 'No editable fields provided.',
            fieldErrors: {}));
      }
      // Read current revision for optimistic concurrency.
      final currentDoc = await _firestore.userDocument(uid).get();
      if (!currentDoc.exists) {
        return Failure(NotFoundException(resource: 'Profile'));
      }
      final current = UserProfile.fromFirestore(currentDoc);

      // Update only allowed fields with optimistic concurrency.
      final Map<String, dynamic> writeData = {
        ...allowed,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': current.revision + 1,
      };
      await _firestore.userDocument(uid).update(writeData);

      // Fetch and return updated profile.
      final freshDoc = await _firestore.userDocument(uid).get();
      final fresh = UserProfile.fromFirestore(freshDoc);
      await _cacheEntry(uid, fresh);
      return Success(fresh);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<UserProfile>> updateProfileAdmin({
    required String uid,
    required Map<String, dynamic> fields,
    required int expectedRevision,
  }) async {
    try {
      if (!FirestorePaths.isValidDocId(uid)) {
        return Failure(PermissionDeniedException());
      }
      final doc = await _firestore.userDocument(uid).get();
      if (!doc.exists) {
        return Failure(NotFoundException(resource: 'Profile'));
      }
      final current = UserProfile.fromFirestore(doc);
      if (current.revision != expectedRevision) {
        return Failure(ConflictException(
            message: 'Profile was modified by another process. Refresh and try again.'));
      }
      await _firestore.userDocument(uid).update({
        ...fields,
        'updatedAt': FirestoreService.serverTimestamp(),
        'revision': expectedRevision + 1,
      });
      final freshDoc = await _firestore.userDocument(uid).get();
      final fresh = UserProfile.fromFirestore(freshDoc);
      await _cacheEntry(uid, fresh);
      return Success(fresh);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<({List<UserProfile> items, String? nextCursor})>> searchMembers({
    String? query,
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      var q = _firestore.usersCollection()
          .orderBy('displayName')
          .limit(limit + 1); // fetch one extra for hasMore
      if (startAfter != null) {
        q = q.startAfter([startAfter]);
      }
      final snapshot = await q.get();
      final profiles = <UserProfile>[];
      for (final doc in snapshot.docs) {
        try {
          profiles.add(UserProfile.fromFirestore(doc));
        } on FormatException {
          // Skip malformed entries.
        }
      }
      final hasMore = profiles.length > limit;
      final items = hasMore ? profiles.sublist(0, limit) : profiles;
      final nextCursor = hasMore ? items.last.displayName : null;
      return Success((items: items, nextCursor: nextCursor));
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  Future<void> _cacheEntry(String uid, UserProfile profile) async {
    await _cache?.set(CacheKeys.currentProfile(uid), profile);
  }
}