import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const forest = Color(0xFF134F35);
  static const ink = Color(0xFF17231C);
  static const canvas = Color(0xFFF3F5F0);

  static final light = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      primary: forest,
      secondary: const Color(0xFFD5A52F),
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Roboto',
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE1E6DF)),
        ),
      ),
    );
  }
}
