import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/core/constants/route_names.dart';

import 'demo_admin_credentials.dart';
import 'auth_controller.dart';
import 'widgets/auth_identity_header.dart';
import 'widgets/sign_in_form_card.dart';

/// Sign-in screen for the CMU SBNU VMS application.
///
/// Delegates real authentication to [AuthController] (which owns submitting
/// and safe failure state). Debug builds additionally accept a local-only
/// demo sign-in callback for the synthetic dashboard preview; those
/// credentials never reach Firebase Auth.
class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.controller,
    this.demoMode = false,
    this.demoSignIn,
  });

  final AuthController controller;

  /// Enables the local preview credential hint (debug builds only).
  final bool demoMode;

  /// Local-only demo sign-in; invoked when the debug demo credentials are
  /// entered. Never wired in profile/release builds.
  final Future<void> Function()? demoSignIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _demoSubmitting = false;
  String? _localErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _submitting =>
      _demoSubmitting || widget.controller.state.submitting;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _submitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() => _localErrorMessage = null);

    try {
      // Debug-only local demo preview: credentials checked in the app,
      // never sent to Firebase Auth, never grants real access.
      if (widget.demoMode &&
          widget.demoSignIn != null &&
          email == DemoAdminCredentials.email &&
          password == DemoAdminCredentials.password) {
        setState(() => _demoSubmitting = true);
        await widget.demoSignIn!();
        return;
      }

      // Real sign-in: controller owns submitting/failure state. The session
      // watcher drives navigation once the profile is approved.
      await widget.controller.signIn(email, password);
    } catch (_) {
      if (mounted) {
        setState(() => _localErrorMessage =
            'We couldn’t sign you in. Check your details and try again.');
      }
    } finally {
      _passwordController.clear();
      if (mounted) setState(() => _demoSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;
        final errorMessage = _localErrorMessage ?? state.errorMessage;
        return Scaffold(
          backgroundColor: const Color(0xFF0B1F16),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF08150D), Color(0xFF123520), Color(0xFF0B1F2E)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 20 : 32,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthIdentityHeader(),
                        const SizedBox(height: 28),
                        SignInFormCard(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isSubmitting: _submitting,
                          isEnabled: true,
                          infoMessage: widget.demoMode
                              ? 'Local demo only. Sign in with ${DemoAdminCredentials.email} / ${DemoAdminCredentials.password}. This does not create or access a real admin account.'
                              : null,
                          obscurePassword: _obscurePassword,
                          errorMessage: errorMessage,
                          onSubmit: _submit,
                          onTogglePassword: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          onPasswordReset: () => GoRouter.of(context)
                              .push(RouteNames.passwordReset),                          validateEmail: _validateEmail,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'For authorized CMU SBNU unit members',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }
}
