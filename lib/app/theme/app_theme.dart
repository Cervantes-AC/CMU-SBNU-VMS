import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens matching the CMU–SBNU VMS prototype (`prototype/src/index.css`).
///
/// Palette:
///  --green: #134f35   (forest / primary)
///  --green-dark: #0a3524
///  --green-soft: #e5efe7
///  --gold: #d5a52f
///  --ink: #17231c
///  --muted: #748078
///  --line: #e1e6df
///  canvas background: #f3f5f0
///
/// Typography: DM Sans (body) and Manrope (headings/display).
abstract class AppTheme {
  static const forest = Color(0xFF134F35);
  static const forestDark = Color(0xFF0A3524);
  static const forestSoft = Color(0xFFE5EFE7);
  static const gold = Color(0xFFD5A52F);
  static const ink = Color(0xFF17231C);
  static const muted = Color(0xFF748078);
  static const line = Color(0xFFE1E6DF);
  static const canvas = Color(0xFFF3F5F0);
  static const surface = Color(0xFFFFFFFF);

  static const success = Color(0xFF196142);
  static const successSoft = Color(0xFFE7F1E9);
  static const error = Color(0xFFB63D34);
  static const errorSoft = Color(0xFFF8E9E7);
  static const warning = Color(0xFFD58A2F);
  static const warningSoft = Color(0xFFF8EFD9);
  static const info = Color(0xFF4C735E);
  static const infoSoft = Color(0xFFE6F0F3);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      scaffoldBackgroundColor: canvas,
      canvasColor: surface,
      cardColor: surface,
      dividerColor: line,
      primaryColor: forest,
      colorScheme: const ColorScheme.light(
        primary: forest,
        secondary: gold,
        surface: surface,
        error: error,
        onPrimary: surface,
        onSecondary: ink,
        onSurface: ink,
        onError: surface,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.manrope(
          fontSize: 37,
          fontWeight: FontWeight.w700,
          color: ink,
          height: 1.12,
          letterSpacing: -1.3,
        ),
        displayMedium: GoogleFonts.manrope(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: ink,
          height: 1.12,
          letterSpacing: -1.3,
        ),
        headlineLarge: GoogleFonts.manrope(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: ink,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF213027),
          height: 1.4,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: ink,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF7C877F),
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF7C877F),
          height: 1.6,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: muted,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: muted,
          height: 1.4,
          letterSpacing: 0.8,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: muted,
          height: 1.4,
          letterSpacing: 0.8,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(0, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF526158),
          side: const BorderSide(color: line, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(0, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: forest,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
          side: const BorderSide(color: line),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFBFCFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFDCE3DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFDCE3DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF2E7453), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: error),
        ),
        hintStyle: GoogleFonts.dmSans(
          fontSize: 10,
          color: const Color(0xFF9BA49E),
        ),
        labelStyle: GoogleFonts.dmSans(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4E5D54),
        ),
      ),
      dividerTheme: const DividerThemeData(color: line, thickness: 1, space: 1),
      iconTheme: const IconThemeData(color: muted, size: 19),
    );
  }
}
