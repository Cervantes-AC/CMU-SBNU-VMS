import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/types/app_types.dart';
import '../data/models/app_user.dart';
import 'sources/auth_remote_source.dart';

/// Repository contract for authentication.
///
/// The repository is the single source of truth for auth state. It translates
/// Firebase SDK errors into safe typed failures and never leaks raw SDK objects
/// to the ViewModel or UI.
abstract class AuthRepository {
  /// Stream of the authenticated user. Emits null when signed out.
  Stream<AppUser?> get userStream;

  /// The current authenticated user, or null.
  AppUser? get currentUser;

  /// Whether a user is currently signed in.
  bool get isAuthenticated;

  /// Sign in with email and password.
  Future<AppResult<AppUser>> signIn({
    required String email,
    required String password,
  });

  /// Register a new account with email and password.
  Future<AppResult<AppUser>> register({
    required String email,
    required String password,
    String? displayName,
  });

  /// Send a password reset email.
  Future<CommandResult> sendPasswordReset({required String email});

  /// Sign out the current user.
  Future<CommandResult> signOut();

  /// Update the current user's display name.
  Future<CommandResult> updateDisplayName({required String displayName});
}

/// Concrete implementation backed by Firebase Auth.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required AuthRemoteSource remoteSource,
    required AppLogger logger,
  }) : _remote = remoteSource,
       _logger = logger;

  final AuthRemoteSource _remote;
  final AppLogger _logger;

  AppUser? _currentUser;

  @override
  Stream<AppUser?> get userStream => _remote.authStateChanges.map((user) {
    _currentUser = user != null ? AppUser.fromFirebaseAuthUser(user) : null;
    return _currentUser;
  });

  @override
  AppUser? get currentUser => _currentUser;

  @override
  bool get isAuthenticated =>
      _currentUser != null && _currentUser!.isAuthenticated;

  @override
  Future<AppResult<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _remote.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = AppUser.fromFirebaseAuthUser(credential.user!);
      _currentUser = user;
      _logger.info('auth.sign_in', fields: {'uid': user.uid});
      return AppResult.data(user);
    } on AppFailure catch (e) {
      _logger.warning('auth.sign_in_failed', fields: {'error': e.message});
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('auth.sign_in_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<AppResult<AppUser>> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _remote.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = AppUser.fromFirebaseAuthUser(credential.user!);
      if (displayName != null && displayName.isNotEmpty) {
        await _remote.updateDisplayName(displayName: displayName);
      }
      _currentUser = user.copyWith(displayName: displayName);
      _logger.security('auth.register', fields: {'uid': user.uid});
      return AppResult.data(_currentUser!);
    } on AppFailure catch (e) {
      _logger.warning('auth.register_failed', fields: {'error': e.message});
      return AppResult.error(e);
    } catch (e, s) {
      _logger.error('auth.register_error', error: e, stackTrace: s);
      return AppResult.error(UnknownFailure());
    }
  }

  @override
  Future<CommandResult> sendPasswordReset({required String email}) async {
    try {
      await _remote.sendPasswordResetEmail(email: email);
      _logger.info('auth.password_reset_sent', fields: {});
      return const CommandResult.success();
    } on AppFailure catch (e) {
      return CommandResult.failure(e);
    } catch (e) {
      return CommandResult.failure(UnknownFailure());
    }
  }

  @override
  Future<CommandResult> signOut() async {
    try {
      await _remote.signOut();
      _currentUser = null;
      _logger.info('auth.sign_out');
      return const CommandResult.success();
    } on AppFailure catch (e) {
      return CommandResult.failure(e);
    } catch (e) {
      return CommandResult.failure(UnknownFailure());
    }
  }

  @override
  Future<CommandResult> updateDisplayName({required String displayName}) async {
    try {
      await _remote.updateDisplayName(displayName: displayName);
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(displayName: displayName);
      }
      return const CommandResult.success();
    } on AppFailure catch (e) {
      return CommandResult.failure(e);
    } catch (e) {
      return CommandResult.failure(UnknownFailure());
    }
  }
}

/// Provider registration helper for the auth repository.
AuthRepository createAuthRepository(
  AuthRemoteSource remoteSource,
  AppLogger logger,
) {
  return FirebaseAuthRepository(remoteSource: remoteSource, logger: logger);
}

AuthRepository authRepositoryOf(BuildContext context) {
  return Provider.of<AuthRepository>(context, listen: false);
}
