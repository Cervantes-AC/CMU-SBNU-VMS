import 'package:flutter/material.dart';

/// Central semantic design tokens and light/dark theme factories.
///
/// Use institution logos/colors only after branding approval (D-18). No
/// screen-level hard-coded palette for status semantics.
class AppTheme {
  AppTheme._();

  // Brand tokens (unit green identity already used by the approved local
  // landing/auth screens; institutional logo publication remains gated).
  static const Color seed = Color(0xFF245B4B);
  static const Color canvasLight = Color(0xFFF5F7F1);
  static const Color canvasDark = Color(0xFF0E1512);
  static const Color ink = Color(0xFF1C2B2A);
  static const Color muted = Color(0xFF65736D);
  static const Color goldAccent = Color(0xFFD4AF37);

  // Status semantics (never rely on color alone; pair with text/icon).
  static const Color success = Color(0xFF2E7D4F);
  static const Color warning = Color(0xFFB7791F);
  static const Color danger = Color(0xFFB3372C);
  static const Color info = Color(0xFF2C6E9E);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    final textTheme = ThemeData(brightness: brightness).textTheme.apply(
          bodyColor: isLight ? ink : Colors.white,
          displayColor: isLight ? ink : Colors.white,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isLight ? canvasLight : canvasDark,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? canvasLight : canvasDark,
        surfaceTintColor: Colors.transparent,
        foregroundColor: isLight ? ink : Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? const Color(0xFFFBFCFB) : const Color(0xFF17201B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: isLight ? const Color(0xFFE0E7E1) : const Color(0xFF2A3630)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: isLight ? const Color(0xFFE0E7E1) : const Color(0xFF2A3630)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: seed, width: 1.5),
        ),
        labelStyle: TextStyle(color: isLight ? muted : Colors.white70),
        prefixIconColor: isLight ? muted : Colors.white70,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isLight ? const Color(0xFFB8C8BE) : const Color(0xFF33463C),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isLight ? ink : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: seed),
      ),
      cardTheme: CardThemeData(
        color: isLight ? Colors.white : const Color(0xFF17201B),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: isLight ? const Color(0xFFE1E8E1) : const Color(0xFF2A3630)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? ink : Colors.white,
        contentTextStyle: TextStyle(
          color: isLight ? Colors.white : ink,
          fontSize: 13,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isLight ? const Color(0xFFE1E8E1) : const Color(0xFF2A3630),
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: seed),
      focusColor: seed.withAlpha(30),
      hoverColor: seed.withAlpha(15),
      // Respect reduced motion: Material's disableAnimations is handled by
      // the platform; transitions below stay short and standard.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Status color mapping shared by badges/feedback. Pair with text.
  static Color statusColor(String status, Brightness brightness) {
    switch (status) {
      case 'approved':
      case 'active':
      case 'published':
      case 'present':
      case 'completed':
        return success;
      case 'pending':
      case 'draft':
      case 'scheduled':
      case 'late':
        return warning;
      case 'denied':
      case 'suspended':
      case 'deactivated':
      case 'blocked':
      case 'rejected':
      case 'canceled':
      case 'absent':
      case 'closed':
        return danger;
      case 'in_progress':
      case 'open':
      case 'acknowledged':
        return info;
      default:
        return brightness == Brightness.light ? muted : Colors.white70;
    }
  }
}
