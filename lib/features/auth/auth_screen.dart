import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/core/constants/route_names.dart';

import 'auth_controller.dart';
import 'widgets/auth_identity_header.dart';
import 'widgets/sign_in_form_card.dart';

/// Sign-in screen for the CMU SBNU VMS application.
///
/// Delegates real authentication to [AuthController] (which owns submitting
/// and safe failure state).
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.controller});

  final AuthController controller;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _localErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _submitting => widget.controller.state.submitting;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _submitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() => _localErrorMessage = null);

    try {
      // Real sign-in: controller owns submitting/failure state. The session
      // watcher drives navigation once the profile is approved.
      await widget.controller.signIn(email, password);
    } catch (_) {
      if (mounted) {
        setState(
          () => _localErrorMessage =
              'We couldn’t sign you in. Check your details and try again.',
        );
      }
    } finally {
      _passwordController.clear();
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
                colors: [
                  Color(0xFF08150D),
                  Color(0xFF123520),
                  Color(0xFF0B1F2E),
                ],
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
                          infoMessage: null,
                          obscurePassword: _obscurePassword,
                          errorMessage: errorMessage,
                          onSubmit: _submit,
                          onTogglePassword: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          onPasswordReset: () => GoRouter.of(
                            context,
                          ).push(RouteNames.passwordReset),
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
