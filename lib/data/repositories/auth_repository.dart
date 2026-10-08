import 'dart:async';

import '../../core/cache/cache_service.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';
import '../../shared/result.dart';
import '../interfaces/auth_repository.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Coordinates [AuthService] and current profile loading.
///
/// - Clears user-scoped cache on sign-out.
/// - Prevents a stale profile from remaining active after a UID change by
///   keying the profile stream to the current session UID.
/// - Missing/malformed profile documents emit `null` (fail closed).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required FirestoreService firestoreService,
    CacheService? cacheService,
  }) : _auth = authService,
       _firestore = firestoreService,
       _cache = cacheService;

  final AuthService _auth;
  final FirestoreService _firestore;
  final CacheService? _cache;

  String? _lastUid;

  @override
  String? get currentUid => _auth.currentUid;

  @override
  Stream<String?> watchSession() {
    // authStateChanges is a broadcast source; cleanup runs once per change
    // per listener. Clearing a user's cache is idempotent.
    return _auth.authStateChanges().map((uid) {
      final previous = _lastUid;
      _lastUid = uid;
      // UID changed or signed out: drop the previous user's scoped cache.
      if (previous != null && previous != uid) {
        unawaited(_cache?.clearUserScope(previous));
      }
      if (uid == null && previous != null) {
        Logger.info('auth.signOut');
      }
      return uid;
    });
  }

  @override
  Stream<UserProfile?> watchCurrentProfile(String uid) {
    if (!FirestorePaths.isValidDocId(uid)) {
      return Stream.value(null);
    }
    // Key the stream to the session UID: emissions for a user who is no
    // longer signed in are suppressed and mapped to null.
    return _auth.authStateChanges().asyncExpand((currentUid) {
      if (currentUid != uid) return Stream<UserProfile?>.value(null);
      return _firestore
          .userDocument(uid)
          .snapshots()
          .map((doc) {
            try {
              if (!doc.exists) return null;
              return UserProfile.fromFirestore(doc);
            } on FormatException {
              // Malformed profile: fail closed, log safe details only.
              Logger.warn(
                'profile.parse',
                code: 'FORMAT',
                fields: {'exists': doc.exists},
              );
              return null;
            }
          })
          .handleError((Object error, StackTrace st) {
            // Permission denial / offline must surface as typed errors to the
            // repository caller, not as a silent empty profile. Re-throw as
            // AppException; the app layer maps it to a safe state.
            final mapped = mapToAppException(error, st);
            if (mapped != null) throw mapped;
            throw UnexpectedException();
          });
    });
  }

  @override
  Future<Result<String>> signIn(String email, String password) async {
    try {
      AuthService.logSignInAttempt(email);
      await _auth.signInWithEmailAndPassword(email.trim(), password);
      final uid = _auth.currentUid;
      if (uid == null) {
        return const Failure(
          UnauthenticatedException(message: 'Sign-in did not complete.'),
        );
      }
      return Success(uid);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<String>> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email.trim(), password);
      final uid = _auth.currentUid;
      if (uid == null) {
        return const Failure(
          UnauthenticatedException(message: 'Registration did not complete.'),
        );
      }
      return Success(uid);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<void>> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email.trim());
      return const Success(null);
    } catch (error, st) {
      // Keep account non-enumerable: 'user-not-found' is still an OK
      // outcome for the caller, which shows identical copy either way.
      final mapped = mapToAppException(error, st);
      if (mapped is NotFoundException || mapped is UnauthenticatedException) {
        return const Success(null);
      }
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      final uid = _auth.currentUid;
      await _auth.signOut();
      if (uid != null) {
        await _cache?.clearUserScope(uid);
      }
      return const Success(null);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }

  @override
  Future<Result<void>> refreshSession() async {
    try {
      await _auth.refreshSession();
      return const Success(null);
    } catch (error, st) {
      final mapped = mapToAppException(error, st);
      return Failure(mapped ?? const UnexpectedException());
    }
  }
}
