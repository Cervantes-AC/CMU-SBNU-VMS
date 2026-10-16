import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

/// Shared button adapter for the app's common button styles.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final variant = isDestructive
        ? ButtonVariant.destructive
        : isOutlined
        ? ButtonVariant.outline
        : ButtonVariant.primary;

    return PremiumButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      variant: variant,
    );
  }
}
