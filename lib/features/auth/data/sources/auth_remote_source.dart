import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_failure.dart';

/// Data source for Firebase Auth operations.
class AuthRemoteSource {
  AuthRemoteSource({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Current authenticated user, or null if not signed in.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Register with email and password.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Send password reset email.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Update the current user's display name.
  Future<void> updateDisplayName({required String displayName}) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  AppFailure _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-email':
      case 'user-disabled':
        return UnauthenticatedFailure(message: 'Invalid email or password.');
      case 'email-already-in-use':
        return InvalidRequestFailure(
          message: 'An account with this email already exists.',
        );
      case 'weak-password':
        return InvalidRequestFailure(message: 'Password is too weak.');
      case 'operation-not-allowed':
        return InvalidRequestFailure(
          message: 'Email/password accounts are not enabled.',
        );
      case 'too-many-requests':
        return NetworkFailure(
          message: 'Too many attempts. Please try again later.',
        );
      case 'network-request-failed':
        return NetworkFailure();
      case 'permission-denied':
        return PermissionDeniedFailure();
      default:
        return UnknownFailure(
          message: 'Authentication error: ${e.message ?? e.code}',
        );
    }
  }
}
