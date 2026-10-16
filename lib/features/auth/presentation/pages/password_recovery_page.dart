import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/shared/presentation/widgets/app_shared_presentation.dart';
import '../view_models/auth_view_model.dart';

/// Password recovery page — premium, fully functional.
class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

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
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final viewModel = context.read<AuthViewModel>();
    await viewModel.sendPasswordReset(email: _emailController.text.trim());

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (viewModel.error != null) {
        showPremiumSnackbar(
          context,
          message: viewModel.error!.message,
          isError: true,
        );
      } else {
        showPremiumSnackbar(
          context,
          message: 'If an account exists, a reset link has been sent.',
        );
        context.go('/account/sign-in');
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
                  'Account recovery',
                  style: DesignTokens.displayLarge.copyWith(
                    fontSize: 34,
                    color: DesignTokens.ink,
                  ),
                ),
                const SizedBox(height: DesignTokens.sm),
                Text(
                  'Enter your email and we will send instructions to reset your password.',
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
                      const SizedBox(height: DesignTokens.xl),
                      PremiumButton(
                        label: 'Send reset link',
                        onPressed: _handleReset,
                        isLoading: _isSubmitting,
                        icon: Icons.email_rounded,
                      ),
                      const SizedBox(height: DesignTokens.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Remember your password? ',
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
