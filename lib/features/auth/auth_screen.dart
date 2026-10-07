import 'package:flutter/material.dart';

typedef SignInHandler = Future<void> Function(String email, String password);

/// Sign-in form for the CMU SBNU VMS application.
///
/// Authentication is supplied by the application layer. When no handler is
/// provided, the form remains visible but cannot imply that sign-in works.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.onSignIn});

  final SignInHandler? onSignIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const _green = Color(0xFF245B4B);
  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF65736D);
  static const _line = Color(0xFFE0E7E1);

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
        setState(() {
          _errorMessage =
              'We couldn’t sign you in. Check your details and try again.';
        });
      }
    } finally {
      _passwordController.clear();
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F3),
      body: SafeArea(
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
                  _identityHeader(),
                  const SizedBox(height: 28),
                  Container(
                    padding: EdgeInsets.all(compact ? 22 : 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: _line),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C1C2B2A),
                          blurRadius: 28,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Sign in',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Use your approved unit account to continue.',
                            style: TextStyle(color: _muted, height: 1.45),
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _emailController,
                            enabled: !_submitting,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                            autocorrect: false,
                            decoration: _inputDecoration(
                              label: 'Email address',
                              hint: 'name@example.com',
                              icon: Icons.alternate_email_rounded,
                            ),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !_submitting,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => _submit(),
                            decoration:
                                _inputDecoration(
                                  label: 'Password',
                                  icon: Icons.lock_outline_rounded,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'Show password'
                                        : 'Hide password',
                                    onPressed: () => setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    }),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter your password.'
                                : null,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _submitting
                                  ? null
                                  : () => Navigator.of(
                                      context,
                                    ).pushNamed('/password-reset'),
                              child: const Text('Forgot password?'),
                            ),
                          ),
                          if (_errorMessage case final message?) ...[
                            const SizedBox(height: 4),
                            _messageBox(
                              icon: Icons.error_outline_rounded,
                              message: message,
                              background: const Color(0xFFFFF0EE),
                              foreground: const Color(0xFF8D352C),
                            ),
                            const SizedBox(height: 14),
                          ],
                          if (widget.onSignIn == null) ...[
                            _messageBox(
                              icon: Icons.info_outline_rounded,
                              message:
                                  'Authentication is not connected yet. Sign-in will be enabled when the approved auth service is ready.',
                              background: const Color(0xFFF1F5F1),
                              foreground: _muted,
                            ),
                            const SizedBox(height: 16),
                          ],
                          SizedBox(
                            height: 50,
                            child: FilledButton(
                              onPressed: _submitting || widget.onSignIn == null
                                  ? null
                                  : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: _green,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: const Color(
                                  0xFFB8C8BE,
                                ),
                              ),
                              child: _submitting
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Sign in',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Access is provided by unit administrators. Public account registration is unavailable.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _muted,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'For authorized CMU SBNU unit members',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _identityHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFE4EFE7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.volunteer_activism_outlined, color: _green),
      ),
      const SizedBox(width: 12),
      Flexible(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Management System',
              style: TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Secure unit member access',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) => InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(icon, size: 19),
    filled: true,
    fillColor: const Color(0xFFFBFCFB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: _line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: _green, width: 1.5),
    ),
  );

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  Widget _messageBox({
    required IconData icon,
    required String message,
    required Color background,
    required Color foreground,
  }) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: foreground),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: foreground, fontSize: 12, height: 1.4),
          ),
        ),
      ],
    ),
  );
}
