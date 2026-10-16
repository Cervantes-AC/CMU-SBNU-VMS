import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../view_models/auth_view_model.dart';

/// Sign-in page — premium, fully functional.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _obscurePassword = true;

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
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final viewModel = context.read<AuthViewModel>();
    await viewModel.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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
        showPremiumSnackbar(context, message: 'Welcome back!');
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
                  'Welcome back',
                  style: DesignTokens.displayLarge.copyWith(
                    fontSize: 34,
                    color: DesignTokens.ink,
                  ),
                ),
                const SizedBox(height: DesignTokens.sm),
                Text(
                  'Sign in to your volunteer account.',
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
                            return 'Please enter your password';
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
                      const SizedBox(height: DesignTokens.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.go('/account/recover'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot password?',
                            style: DesignTokens.captionBold.copyWith(
                              color: DesignTokens.forest,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      PremiumButton(
                        label: 'Sign in',
                        onPressed: _handleSignIn,
                        isLoading: _isSubmitting,
                        icon: Icons.login_rounded,
                      ),
                      const SizedBox(height: DesignTokens.xl),
                      PremiumDivider(),
                      const SizedBox(height: DesignTokens.lg),
                      Row(
                        children: [
                          Expanded(child: PremiumDivider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.md,
                            ),
                            child: Text(
                              'Or create account',
                              style: DesignTokens.captionBold.copyWith(
                                color: DesignTokens.muted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: PremiumDivider()),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      PremiumButton(
                        label: 'Create an account',
                        onPressed: () => context.go('/account/register'),
                        variant: ButtonVariant.outline,
                        icon: Icons.person_add_rounded,
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
