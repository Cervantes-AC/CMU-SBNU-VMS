import 'package:flutter/material.dart';

import '../../../core/types/app_types.dart';

/// Premium design system for CMU–SBNU VMS.
/// High-class, formal, professional visual language with 3D-style depth,
/// glassmorphism, and sophisticated micro-interactions.

abstract class DesignTokens {
  // ── Premium color palette ──
  static const Color deepForest = Color(0xFF0B3D2E);
  static const Color forest = Color(0xFF134F35);
  static const Color forestLight = Color(0xFF1E6B4A);
  static const Color ink = Color(0xFF121B15);
  static const Color canvas = Color(0xFFFAFCF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF2F6F2);

  // Accent colors
  static const Color gold = Color(0xFFD5A52F);
  static const Color goldLight = Color(0xFFE9C46A);
  static const Color amber = Color(0xFFF4A300);

  // Semantic colors
  static const Color success = Color(0xFF196142);
  static const Color warning = Color(0xFFD58A2F);
  static const Color error = Color(0xFFB63D34);
  static const Color info = Color(0xFF4C735E);

  // Neutral
  static const Color muted = Color(0xFF68766D);
  static const Color line = Color(0xFFE1E6DF);

  // ── 3D depth shadows ──
  static List<BoxShadow> shadowSoft({
    Color color = const Color(0x1A000000),
    double blur = 20,
    double spread = 0,
    Offset offset = const Offset(0, 8),
  }) {
    return [
      BoxShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offset: offset,
      ),
    ];
  }

  static List<BoxShadow> shadowMedium({
    Color color = const Color(0x1A000000),
    double blur = 32,
    double spread = 0,
    Offset offset = const Offset(0, 16),
  }) {
    return [
      BoxShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offset: offset,
      ),
    ];
  }

  static List<BoxShadow> shadowStrong({
    Color color = const Color(0x25000000),
    double blur = 48,
    double spread = 2,
    Offset offset = const Offset(0, 24),
  }) {
    return [
      BoxShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offset: offset,
      ),
    ];
  }

  // ── Glassmorphism ──
  static BoxDecoration glass({
    Color color = Colors.white,
    double opacity = 0.6,
    double blur = 20,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(24)),
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: opacity),
      borderRadius: borderRadius,
      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      boxShadow: shadowSoft(color: const Color(0x10000000), blur: blur),
    );
  }

  // ── 3D card elevation ──
  static BoxDecoration card3D({
    Color color = Colors.white,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(28)),
    int shadowLevel = 1,
  }) {
    final shadows = <BoxShadow>[];
    switch (shadowLevel) {
      case 1:
        shadows.addAll(shadowSoft());
        break;
      case 2:
        shadows.addAll(shadowMedium());
        break;
      case 3:
        shadows.addAll(shadowStrong());
        break;
      default:
        break;
    }
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      boxShadow: shadows,
      border: Border.all(color: line, width: 1),
    );
  }

  // ── Typography ──
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w900,
    color: ink,
    height: 1.05,
    letterSpacing: -1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w800,
    color: ink,
    height: 1.1,
    letterSpacing: -0.8,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w800,
    color: ink,
    height: 1.25,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
    color: ink,
    height: 1.3,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: ink,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFF3A473F),
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: muted,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    color: Color(0xFF8A978E),
    height: 1.4,
    letterSpacing: 0.4,
  );

  static const TextStyle captionBold = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w700,
    color: muted,
    height: 1.4,
    letterSpacing: 0.4,
  );

  // ── Spacing ──
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // ── Border radius ──
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(20.0));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(28.0));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(40.0));
  static const BorderRadius radiusPill = BorderRadius.all(
    Radius.circular(50.0),
  );

  // ── Gradient helpers ──
  static LinearGradient get forestGradient =>
      LinearGradient(colors: [deepForest, forest, forestLight]);

  static LinearGradient get surfaceGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [canvas, surfaceElevated],
  );

  static LinearGradient get goldGradient =>
      LinearGradient(colors: [gold, goldLight]);

  static LinearGradient get successGradient =>
      LinearGradient(colors: [success, forestLight]);

  static LinearGradient get errorGradient =>
      LinearGradient(colors: [error, const Color(0xFFC0473C)]);
}

/// 3D-ish card with top light highlight and bottom shadow for depth.
class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.elevation = 1,
    this.borderRadius = DesignTokens.radiusLg,
    this.color = Colors.white,
    this.border,
    this.padding = const EdgeInsets.all(DesignTokens.lg),
    this.onTap,
  });

  final Widget child;
  final int elevation;
  final BorderRadius borderRadius;
  final Color color;
  final BoxBorder? border;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      decoration: DesignTokens.card3D(
        color: color,
        borderRadius: borderRadius,
        shadowLevel: elevation,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(padding: padding, child: child),
      ),
    );

    if (onTap == null) return widget;
    return InkWell(onTap: onTap, borderRadius: borderRadius, child: widget);
  }
}

/// Glassmorphism card.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.elevation = 1,
    this.borderRadius = DesignTokens.radiusLg,
    this.padding = const EdgeInsets.all(DesignTokens.lg),
    this.color = Colors.white,
    this.opacity = 0.65,
    this.blur = 20.0,
  });

  final Widget child;
  final int elevation;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double opacity;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DesignTokens.glass(
        color: color,
        opacity: opacity,
        blur: blur,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Premium section heading with accent rule.
class PremiumSectionHeading extends StatelessWidget {
  const PremiumSectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.accentColor = DesignTokens.forest,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.0,
          height: 24.0,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: DesignTokens.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DesignTokens.headlineSmall.copyWith(
                  color: DesignTokens.ink,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: DesignTokens.xs / 2),
                Text(
                  subtitle!,
                  style: DesignTokens.bodySmall.copyWith(
                    color: DesignTokens.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          _PremiumTextAction(label: actionLabel!, onPressed: onAction!),
      ],
    );
  }
}

class _PremiumTextAction extends StatelessWidget {
  const _PremiumTextAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: DesignTokens.forest,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusSm),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6.0),
          const Icon(Icons.chevron_right, size: 16.0),
        ],
      ),
    );
  }
}

/// Premium metric card with 3D depth and accent glow.
class PremiumMetricCard extends StatelessWidget {
  const PremiumMetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.accentColor = DesignTokens.forest,
    this.glowColor,
    this.valueStyle = DesignTokens.displayMedium,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accentColor;
  final Color? glowColor;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    final glow = glowColor ?? accentColor.withValues(alpha: 0.15);
    return PremiumCard(
      elevation: 2,
      borderRadius: DesignTokens.radiusLg,
      padding: const EdgeInsets.all(DesignTokens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: glow,
              borderRadius: DesignTokens.radiusMd,
              boxShadow: DesignTokens.shadowSoft(
                color: accentColor.withValues(alpha: 0.25),
                blur: 16.0,
                spread: 0.0,
                offset: const Offset(0.0, 4.0),
              ),
            ),
            child: Icon(icon, color: accentColor, size: 24.0),
          ),
          const SizedBox(height: DesignTokens.lg),
          Text(value, style: valueStyle.copyWith(color: DesignTokens.ink)),
          const SizedBox(height: DesignTokens.xs / 2),
          Text(
            label,
            style: DesignTokens.captionBold.copyWith(
              color: accentColor,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium primary button with 3D press effect.
class PremiumButton extends StatefulWidget {
  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.isFullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ButtonVariant variant;
  final bool isFullWidth;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

enum ButtonVariant { primary, secondary, outline, ghost, destructive }

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    final color = _buttonColors(widget.variant);

    final child = AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            width: widget.isFullWidth ? double.infinity : null,
            decoration: BoxDecoration(
              borderRadius: DesignTokens.radiusXl,
              boxShadow: enabled && widget.variant == ButtonVariant.primary
                  ? DesignTokens.shadowSoft(
                      color: color.background.withValues(alpha: 0.35),
                      blur: 16.0,
                      spread: 0.0,
                      offset: const Offset(0.0, 8.0),
                    )
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: enabled ? widget.onPressed : null,
                borderRadius: DesignTokens.radiusXl,
                child: Container(
                  height: 56.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: enabled ? color.background : Colors.grey.shade200,
                    borderRadius: DesignTokens.radiusXl,
                    border: color.border != null
                        ? Border.all(color: color.border!, width: 1.5)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isLoading) ...[
                        const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ] else if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20.0, color: color.foreground),
                        const SizedBox(width: 10.0),
                      ],
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.isFullWidth) {
      return SizedBox(width: double.infinity, height: 56.0, child: child);
    }
    return SizedBox(height: 56.0, child: child);
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;

  _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });
}

_ButtonColors _buttonColors(ButtonVariant variant) {
  switch (variant) {
    case ButtonVariant.primary:
      return _ButtonColors(
        background: DesignTokens.forest,
        foreground: Colors.white,
      );
    case ButtonVariant.secondary:
      return _ButtonColors(
        background: DesignTokens.gold,
        foreground: DesignTokens.ink,
      );
    case ButtonVariant.outline:
      return _ButtonColors(
        background: Colors.white,
        foreground: DesignTokens.forest,
        border: DesignTokens.forest,
      );
    case ButtonVariant.ghost:
      return _ButtonColors(
        background: Colors.transparent,
        foreground: DesignTokens.forest,
      );
    case ButtonVariant.destructive:
      return _ButtonColors(
        background: DesignTokens.error,
        foreground: Colors.white,
      );
  }
}

/// Premium outlined input field.
class PremiumInputField extends StatefulWidget {
  const PremiumInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixText,
    this.suffixText,
    this.errorText,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final String? prefixText;
  final String? suffixText;
  final String? errorText;

  @override
  State<PremiumInputField> createState() => _PremiumInputFieldState();
}

class _PremiumInputFieldState extends State<PremiumInputField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3A473F),
                ),
              ),
            ),
            if (hasError)
              const Icon(
                Icons.error_outline,
                size: 14.0,
                color: DesignTokens.error,
              ),
          ],
        ),
        const SizedBox(height: DesignTokens.sm / 2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _focused ? Colors.white : Colors.grey.shade50,
            borderRadius: DesignTokens.radiusLg,
            border: Border.all(
              color: hasError
                  ? DesignTokens.error
                  : _focused
                  ? DesignTokens.forest
                  : DesignTokens.line,
              width: hasError || _focused ? 1.5 : 1,
            ),
            boxShadow: _focused
                ? DesignTokens.shadowSoft(
                    color: DesignTokens.forest.withValues(alpha: 0.1),
                    blur: 12.0,
                    offset: const Offset(0.0, 4.0),
                  )
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            validator: widget.validator,
            onChanged: widget.onChanged,
            style: const TextStyle(
              fontSize: 15.0,
              color: DesignTokens.ink,
              fontWeight: FontWeight.w500,
            ),
            onTap: () => setState(() => _focused = true),
            onTapOutside: (_) => setState(() => _focused = false),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF9AA89E),
              ),
              prefixIcon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      size: 20.0,
                      color: _focused
                          ? DesignTokens.forest
                          : const Color(0xFF9AA89E),
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                      onTap: widget.onSuffixTap,
                      child: Icon(
                        widget.suffixIcon,
                        size: 20.0,
                        color: _focused
                            ? DesignTokens.forest
                            : const Color(0xFF9AA89E),
                      ),
                    )
                  : null,
              prefixText: widget.prefixText,
              suffixText: widget.suffixText,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 16.0,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorText: widget.errorText,
              errorStyle: const TextStyle(
                fontSize: 12.0,
                color: DesignTokens.error,
                height: 1.3,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: DesignTokens.xs / 2),
          Text(
            widget.errorText!,
            style: const TextStyle(
              fontSize: 12.0,
              color: DesignTokens.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Premium chip / badge.
class PremiumChip extends StatelessWidget {
  const PremiumChip({
    super.key,
    required this.label,
    this.color = DesignTokens.forest,
    this.textColor,
    this.size = ChipSize.md,
  });

  final String label;
  final Color color;
  final Color? textColor;
  final ChipSize size;

  @override
  Widget build(BuildContext context) {
    final (padding, radius, fontSize) = switch (size) {
      ChipSize.sm => (
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        DesignTokens.radiusPill,
        10.0,
      ),
      ChipSize.md => (
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        DesignTokens.radiusPill,
        11.0,
      ),
      ChipSize.lg => (
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        DesignTokens.radiusPill,
        12.0,
      ),
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: radius,
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: textColor ?? color,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

enum ChipSize { sm, md, lg }

/// Premium divider.
class PremiumDivider extends StatelessWidget {
  const PremiumDivider({
    super.key,
    this.color = DesignTokens.line,
    this.height = 1.0,
  });

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, color: color, thickness: 1);
  }
}

/// Premium empty state.
class PremiumEmptyState extends StatelessWidget {
  const PremiumEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
    this.actionVariant = ButtonVariant.primary,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final String? actionLabel;
  final ButtonVariant actionVariant;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.0,
              height: 88.0,
              decoration: BoxDecoration(
                color: DesignTokens.canvas,
                borderRadius: DesignTokens.radiusXl,
                boxShadow: DesignTokens.shadowSoft(
                  blur: 24.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ),
              child: Icon(icon, size: 40.0, color: DesignTokens.muted),
            ),
            const SizedBox(height: DesignTokens.lg),
            Text(
              title,
              style: DesignTokens.headline.copyWith(color: DesignTokens.ink),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: DesignTokens.sm),
              Text(
                subtitle!,
                style: DesignTokens.body.copyWith(color: DesignTokens.muted),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: DesignTokens.xl),
              action!,
            ] else if (actionLabel != null) ...[
              const SizedBox(height: DesignTokens.xl),
              PremiumButton(
                label: actionLabel!,
                onPressed: () {},
                variant: actionVariant,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Premium error state.
class PremiumErrorState extends StatelessWidget {
  const PremiumErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Try again',
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.0,
              height: 88.0,
              decoration: BoxDecoration(
                color: DesignTokens.error.withValues(alpha: 0.1),
                borderRadius: DesignTokens.radiusXl,
                boxShadow: DesignTokens.shadowSoft(
                  color: DesignTokens.error.withValues(alpha: 0.15),
                  blur: 24.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40.0,
                color: DesignTokens.error,
              ),
            ),
            const SizedBox(height: DesignTokens.lg),
            Text(
              'Something went wrong',
              style: DesignTokens.headline.copyWith(color: DesignTokens.ink),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.sm),
            Text(
              message,
              style: DesignTokens.body.copyWith(color: DesignTokens.muted),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: DesignTokens.xl),
              PremiumButton(
                label: retryLabel,
                onPressed: onRetry,
                variant: ButtonVariant.primary,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Premium loading state.
class PremiumLoadingState extends StatelessWidget {
  const PremiumLoadingState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: DesignTokens.forest.withValues(alpha: 0.1),
                borderRadius: DesignTokens.radiusXl,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(DesignTokens.forest),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: DesignTokens.lg),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: DesignTokens.muted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Premium offline state.
class PremiumOfflineState extends StatelessWidget {
  const PremiumOfflineState({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.0,
              height: 88.0,
              decoration: BoxDecoration(
                color: DesignTokens.warning.withValues(alpha: 0.1),
                borderRadius: DesignTokens.radiusXl,
                boxShadow: DesignTokens.shadowSoft(
                  color: DesignTokens.warning.withValues(alpha: 0.15),
                  blur: 24.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40.0,
                color: DesignTokens.warning,
              ),
            ),
            const SizedBox(height: DesignTokens.lg),
            Text(
              'You appear to be offline',
              style: DesignTokens.headline.copyWith(color: DesignTokens.ink),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.sm),
            Text(
              message ?? 'Check your connection and try again.',
              style: const TextStyle(
                fontSize: 14.0,
                color: DesignTokens.muted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: DesignTokens.xl),
              PremiumButton(
                label: 'Try again',
                onPressed: onRetry,
                variant: ButtonVariant.primary,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Premium permission denied state.
class PremiumPermissionDeniedState extends StatelessWidget {
  const PremiumPermissionDeniedState({super.key, this.message, this.onBack});

  final String? message;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.0,
              height: 88.0,
              decoration: BoxDecoration(
                color: DesignTokens.muted.withValues(alpha: 0.1),
                borderRadius: DesignTokens.radiusXl,
                boxShadow: DesignTokens.shadowSoft(
                  color: DesignTokens.muted.withValues(alpha: 0.15),
                  blur: 24.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 40.0,
                color: DesignTokens.muted,
              ),
            ),
            const SizedBox(height: DesignTokens.lg),
            Text(
              'Not authorized',
              style: DesignTokens.headline.copyWith(color: DesignTokens.ink),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.sm),
            Text(
              message ?? 'You do not have permission to view this page.',
              style: DesignTokens.body.copyWith(color: DesignTokens.muted),
              textAlign: TextAlign.center,
            ),
            if (onBack != null) ...[
              const SizedBox(height: DesignTokens.xl),
              PremiumButton(
                label: 'Back to workspace',
                onPressed: onBack,
                variant: ButtonVariant.secondary,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Premium snackbar.
void showPremiumSnackbar(
  BuildContext context, {
  required String message,
  bool isError = false,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? DesignTokens.error : DesignTokens.forest,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.radiusLg),
      margin: const EdgeInsets.all(DesignTokens.md),
      elevation: 8.0,
    ),
  );
}

/// Wraps content and shows loading, empty, error, offline, or permission-denied states
/// using premium design components.
class AppStateWrapper extends StatelessWidget {
  const AppStateWrapper({
    super.key,
    required this.status,
    this.child,
    this.onRetry,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.errorMessage,
    this.offlineMessage,
    this.permissionMessage,
  });

  final LoadStatus status;
  final Widget? child;
  final VoidCallback? onRetry;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final String? errorMessage;
  final String? offlineMessage;
  final String? permissionMessage;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return PremiumLoadingState(message: _statusMessage(status));
      case LoadStatus.loaded:
        if (child == null) {
          return PremiumEmptyState(
            icon: emptyIcon,
            title: emptyTitle ?? 'No items available.',
            subtitle: emptySubtitle,
          );
        }
        return child!;
      case LoadStatus.error:
        return PremiumErrorState(
          message: errorMessage ?? 'An unexpected error occurred.',
          onRetry: onRetry,
        );
      case LoadStatus.offline:
        return PremiumOfflineState(message: offlineMessage, onRetry: onRetry);
    }
  }

  String? _statusMessage(LoadStatus status) {
    switch (status) {
      case LoadStatus.initial:
        return 'Getting ready…';
      case LoadStatus.loading:
        return 'Loading…';
      case LoadStatus.loaded:
      case LoadStatus.error:
      case LoadStatus.offline:
        return null;
    }
  }
}
