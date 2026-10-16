import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../view_models/auth_view_model.dart';

/// Registration page — premium, fully functional.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      showPremiumSnackbar(
        context,
        message: 'Passwords do not match.',
        isError: true,
      );
      return;
    }
    setState(() => _isSubmitting = true);

    final viewModel = context.read<AuthViewModel>();
    await viewModel.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _displayNameController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (viewModel.error != null) {
        showPremiumSnackbar(
          context,
          message: viewModel.error!.message,
          isError: true,
        );
      } else if (viewModel.isAuthenticated) {
        showPremiumSnackbar(
          context,
          message: 'Account created. Awaiting approval.',
        );
        context.go('/workspace');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.lg),
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back arrow
                PremiumButton(
                  label: '',
                  onPressed: () => Navigator.of(context).maybePop(),
                  variant: ButtonVariant.ghost,
                  isFullWidth: false,
                  icon: Icons.arrow_back_rounded,
                ),
                const SizedBox(height: DesignTokens.xl),
                // Brand header
                Container(
                  width: 60,
                  height: 60,
                  decoration: DesignTokens.card3D(
                    color: DesignTokens.canvas,
                    shadowLevel: 1,
                  ),
                  child: ClipRRect(
                    borderRadius: DesignTokens.radiusLg,
                    child: Image.asset(
                      'assets/images/sbnu_app_icon.png',
                      semanticLabel: 'SBNU logo',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.lg),
                Text(
                  'Join the network',
                  style: DesignTokens.displayLarge.copyWith(
                    fontSize: 34,
                    color: DesignTokens.ink,
                  ),
                ),
                const SizedBox(height: DesignTokens.sm),
                Text(
                  'Create your volunteer profile. Account approval is required before signing in.',
                  style: DesignTokens.body.copyWith(
                    fontSize: 15,
                    color: DesignTokens.muted,
                  ),
                ),
                const SizedBox(height: DesignTokens.xxl),
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PremiumInputField(
                        controller: _displayNameController,
                        label: 'Full name',
                        hint: 'Juan Dela Cruz',
                        icon: Icons.person_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: _emailController,
                        label: 'Email address',
                        hint: 'you@cmu.edu.ph',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        icon: Icons.lock_rounded,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        suffixIcon: _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        onSuffixTap: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumInputField(
                        controller: _confirmPasswordController,
                        label: 'Confirm password',
                        hint: '••••••••',
                        icon: Icons.lock_rounded,
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          return null;
                        },
                        suffixIcon: _obscureConfirmPassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        onSuffixTap: () {
                          setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          );
                        },
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      PremiumButton(
                        label: 'Create account',
                        onPressed: _handleRegister,
                        isLoading: _isSubmitting,
                        icon: Icons.person_add_rounded,
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: DesignTokens.bodySmall.copyWith(
                              color: DesignTokens.muted,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/account/sign-in'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign in',
                              style: DesignTokens.captionBold.copyWith(
                                color: DesignTokens.forest,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
