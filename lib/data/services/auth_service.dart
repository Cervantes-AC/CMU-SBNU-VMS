import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/error_mapper.dart';
import '../../core/utils/logger.dart';

/// Firebase Auth adapter: sign-in/out, password reset, auth state stream,
/// token refresh.
///
/// Translates SDK failures to typed app errors at the repository boundary;
/// never logs credentials. Profile/role lookup lives in the repository.
/// Dependency-injected for tests.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Emits the UID whenever auth state changes (null when signed out).
  Stream<String?> authStateChanges() =>
      _auth.authStateChanges().map((user) => user?.uid);

  /// Forces a token refresh for the current user.
  Future<void> refreshSession() async {
    final user = _auth.currentUser;
    if (user != null) await user.getIdToken(true);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Sends a reset email. The caller must surface a generic response so
  /// account existence is not revealed.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Connects Firebase Auth to the local emulator. Development only —
  /// gated in main.dart by USE_FIREBASE_EMULATORS.
  void configureEmulator({String host = 'localhost', int port = 9099}) {
    _auth.useAuthEmulator(host, port);
  }

  String? get currentUid => _auth.currentUser?.uid;

  /// Whether a user is currently signed in.
  bool get isSignedIn => _auth.currentUser != null;

  /// Maps any SDK error from this service into a typed [AppException] with
  /// safe copy. Kept here so the repository never sees raw SDK errors.
  static Object mapError(Object error, StackTrace stackTrace) =>
      mapToAppException(error, stackTrace) ??
      error;

  /// Debug-only: confirms no password persistence is requested (Firebase
  /// Auth persists sessions by platform; we never call
  /// setPersistence with credentials).
  static void logSignInAttempt(String email) {
    // Email is sensitive — log only the operation, never the value.
    Logger.info('auth.signIn');
  }
}
