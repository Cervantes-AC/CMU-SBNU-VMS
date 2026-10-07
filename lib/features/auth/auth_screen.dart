import 'package:flutter/material.dart';

import 'demo_admin_credentials.dart';
import 'widgets/auth_identity_header.dart';
import 'widgets/sign_in_form_card.dart';

typedef SignInHandler = Future<void> Function(String email, String password);

/// Sign-in screen for the CMU SBNU VMS application.
///
/// Authentication is supplied by the application layer. Without a handler,
/// the form stays visible but cannot imply that sign-in works.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.onSignIn, this.demoMode = false});

  final SignInHandler? onSignIn;
  final bool demoMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final handler = widget.onSignIn;
    if (handler == null || _submitting) return;

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    try {
      await handler(_emailController.text.trim(), _passwordController.text);
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage =
              'We couldn’t sign you in. Check your details and try again.',
        );
      }
    } finally {
      _passwordController.clear();
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
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
                      isEnabled: widget.onSignIn != null,
                      infoMessage: widget.demoMode
                          ? 'Local demo only. Sign in with ${DemoAdminCredentials.email} / ${DemoAdminCredentials.password}. This does not create or access a real admin account.'
                          : null,
                      obscurePassword: _obscurePassword,
                      errorMessage: _errorMessage,
                      onSubmit: _submit,
                      onTogglePassword: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      onPasswordReset: () =>
                          Navigator.of(context).pushNamed('/password-reset'),
                      validateEmail: _validateEmail,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'For authorized CMU SBNU unit members',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
