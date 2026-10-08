import 'package:flutter/material.dart';

typedef PasswordResetHandler = Future<void> Function(String email);

/// Password-reset request form. The repository owns delivery and response.
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key, this.onSubmit});

  final PasswordResetHandler? onSubmit;

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  static const _green = Color(0xFF245B4B);
  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF65736D);
  static const _line = Color(0xFFE0E7E1);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitting = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() ||
        widget.onSubmit == null ||
        _submitting) {
      return;
    }

    setState(() => _submitting = true);
    try {
      await widget.onSubmit!(_emailController.text.trim());
    } catch (_) {
      // Keep the same response for every address to avoid account enumeration.
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
          _sent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF4F7F3),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        tooltip: 'Back to sign in',
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4EFE7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: _green,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Reset your password',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the email address associated with your unit account. If an account matches, reset instructions will be sent.',
                      style: TextStyle(color: _muted, height: 1.5),
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      controller: _emailController,
                      enabled: !_submitting && !_sent,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.email],
                      onFieldSubmitted: (_) => _submit(),
                      style: const TextStyle(color: _ink),
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        hintText: 'name@example.com',
                        prefixIcon: const Icon(
                          Icons.alternate_email_rounded,
                          color: _muted,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFBFCFB),
                        labelStyle: const TextStyle(color: _ink),
                        hintStyle: const TextStyle(color: _muted),
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
                          borderSide: const BorderSide(
                            color: _green,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: _validateEmail,
                    ),
                    if (widget.onSubmit == null && !_sent) ...[
                      const SizedBox(height: 14),
                      const Text(
                        'Password reset will be available when authentication is connected.',
                        style: TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                    if (_sent) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF2EC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'If an account matches that address, password reset instructions will be sent.',
                          style: TextStyle(color: _green, height: 1.45),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 49,
                      child: FilledButton(
                        onPressed:
                            _submitting || _sent || widget.onSubmit == null
                            ? null
                            : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                        ),
                        child: _submitting
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Send reset instructions'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
}
