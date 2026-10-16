import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/auth_repository.dart';
import '../../data/models/app_user.dart';

/// ViewModel for authentication screens.
///
/// Owns sign-in, registration, password reset, and sign-out state.
/// The UI depends only on this ViewModel, never on the repository or Firebase SDK.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required this.repository});

  final AuthRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  AppUser? _user;
  bool _obscurePassword = true;

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  AppUser? get user => _user;
  bool get isAuthenticated => repository.isAuthenticated;
  bool get isLoading => _status == LoadStatus.loading;
  bool get obscurePassword => _obscurePassword;

  /// Initialize and listen to auth state changes.
  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.userStream.listen(
      (user) {
        _user = user;
        _status = LoadStatus.loaded;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _status = LoadStatus.error;
        _error = e is AppFailure ? e : UnknownFailure();
        notifyListeners();
      },
    );
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Clear any stored error.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.signIn(email: email, password: password);
    if (result.hasData) {
      _user = result.data;
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.register(
      email: email,
      password: password,
      displayName: displayName,
    );
    if (result.hasData) {
      _user = result.data;
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> sendPasswordReset({required String email}) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.sendPasswordReset(email: email);
    if (result.success) {
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    _status = LoadStatus.loading;
    notifyListeners();

    final result = await repository.signOut();
    if (result.success) {
      _user = null;
      _status = LoadStatus.loaded;
      _error = null;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> updateDisplayName({required String displayName}) async {
    _status = LoadStatus.loading;
    notifyListeners();

    final result = await repository.updateDisplayName(displayName: displayName);
    if (result.success) {
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }
}

/// Provider registration helper.
AuthViewModel createAuthViewModel(AuthRepository repository) {
  return AuthViewModel(repository: repository);
}

AuthViewModel authViewModelOf(BuildContext context) {
  return Provider.of<AuthViewModel>(context, listen: false);
}
