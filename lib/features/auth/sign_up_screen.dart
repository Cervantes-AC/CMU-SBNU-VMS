import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/core/constants/route_names.dart';

import 'auth_controller.dart';
import 'widgets/auth_identity_header.dart';
import 'widgets/sign_up_form_card.dart';

/// Registration screen for the CMU SBNU VMS application.
///
/// Delegates real registration to [AuthController]. Institution-approved
/// registration must be enabled; otherwise the screen shows an info message.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.controller});

  final AuthController controller;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _localErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _submitting => widget.controller.state.submitting;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _submitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    setState(() => _localErrorMessage = null);

    if (password != confirmPassword) {
      setState(() => _localErrorMessage = 'Passwords do not match.');
      return;
    }

    try {
      await widget.controller.signUp(email, password);
    } catch (_) {
      if (mounted) {
        setState(
          () => _localErrorMessage =
              'We couldn\'t create your account. Check your details and try again.',
        );
      }
    } finally {
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Enter a password.';
    if (password.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirm = value ?? '';
    if (confirm.isEmpty) return 'Confirm your password.';
    if (confirm != _passwordController.text) return 'Passwords do not match.';
    return null;
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
                        SignUpFormCard(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          isSubmitting: _submitting,
                          isEnabled: true,
                          infoMessage: null,
                          obscurePassword: _obscurePassword,
                          obscureConfirmPassword: _obscureConfirmPassword,
                          errorMessage: errorMessage,
                          onSubmit: _submit,
                          onTogglePassword: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          onToggleConfirmPassword: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                          onSignIn: () =>
                              GoRouter.of(context).push(RouteNames.signIn),
                          validateEmail: _validateEmail,
                          validatePassword: _validatePassword,
                          validateConfirmPassword: _validateConfirmPassword,
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
}
