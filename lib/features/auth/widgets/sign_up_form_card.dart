import 'package:flutter/material.dart';

class SignUpFormCard extends StatelessWidget {
  const SignUpFormCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isSubmitting,
    required this.isEnabled,
    this.infoMessage,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.errorMessage,
    required this.onSubmit,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSignIn,
    required this.validateEmail,
    required this.validatePassword,
    required this.validateConfirmPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isSubmitting;
  final bool isEnabled;
  final String? infoMessage;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSignIn;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePassword;
  final String? Function(String?) validateConfirmPassword;

  static const _green = Color(0xFF245B4B);
  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF65736D);
  static const _line = Color(0xFFE0E7E1);

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 22 : 32),
    decoration: BoxDecoration(
      color: const Color(0xFFFEFFFC),
      border: Border.all(color: const Color(0xFFE6E6D8)),
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 36,
          offset: Offset(0, 16),
        ),
      ],
    ),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Create account',
            style: TextStyle(
              color: _ink,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Register with your unit-approved email.',
            style: TextStyle(color: _muted, height: 1.45),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: emailController,
            enabled: !isSubmitting,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            autocorrect: false,
            style: const TextStyle(color: _ink),
            decoration: _inputDecoration(
              label: 'Email address',
              hint: 'name@example.com',
              icon: Icons.alternate_email_rounded,
            ),
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            enabled: !isSubmitting,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            onFieldSubmitted: (_) => onSubmit(),
            style: const TextStyle(color: _ink),
            decoration:
                _inputDecoration(
                  label: 'Password',
                  icon: Icons.lock_outline_rounded,
                ).copyWith(
                  suffixIcon: IconButton(
                    tooltip: obscurePassword
                        ? 'Show password'
                        : 'Hide password',
                    onPressed: onTogglePassword,
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
            validator: validatePassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: confirmPasswordController,
            enabled: !isSubmitting,
            obscureText: obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            onFieldSubmitted: (_) => onSubmit(),
            style: const TextStyle(color: _ink),
            decoration:
                _inputDecoration(
                  label: 'Confirm password',
                  icon: Icons.lock_outline_rounded,
                ).copyWith(
                  suffixIcon: IconButton(
                    tooltip: obscureConfirmPassword
                        ? 'Show password'
                        : 'Hide password',
                    onPressed: onToggleConfirmPassword,
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
            validator: validateConfirmPassword,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 4),
            _MessageBox(
              icon: Icons.error_outline_rounded,
              message: errorMessage!,
              background: const Color(0xFFFFF0EE),
              foreground: const Color(0xFF8D352C),
            ),
            const SizedBox(height: 14),
          ],
          if (!isEnabled || infoMessage != null) ...[
            _MessageBox(
              icon: Icons.info_outline_rounded,
              message:
                  infoMessage ??
                  'Registration is not available yet. Ask your unit administrator about account creation.',
              background: const Color(0xFFF1F5F1),
              foreground: _muted,
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: isSubmitting || !isEnabled ? null : onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFB8C8BE),
              ),
              child: isSubmitting
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Create account',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
              TextButton(
                onPressed: onSignIn,
                style: TextButton.styleFrom(
                  foregroundColor: _green,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Sign in'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Accounts require administrator approval. Public registration may be unavailable.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    ),
  );

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) => InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(icon, size: 19, color: _muted),
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
      borderSide: const BorderSide(color: _green, width: 1.5),
    ),
  );
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({
    required this.icon,
    required this.message,
    required this.background,
    required this.foreground,
  });
  final IconData icon;
  final String message;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
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
