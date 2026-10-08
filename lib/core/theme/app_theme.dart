import 'package:flutter/material.dart';

/// Color palette sampled from the CMU, ODRRM, and SBNU marks.
///
/// SBNU colors lead the interface; CMU and ODRRM colors are supporting accents.
abstract final class AppColors {
  // SBNU is the primary identity in the app.
  static const sbnuNavy = Color(0xFF0A1E4D);
  static const sbnuOrange = Color(0xFFF05A24);
  static const sbnuGold = Color(0xFFF9C016);

  // CMU supporting colors.
  static const cmuGreen = Color(0xFF036800);
  static const cmuGold = Color(0xFFFFC000);

  // ODRRM supporting colors.
  static const odrrmForest = Color(0xFF164E24);
  static const odrrmGreen = Color(0xFF106D31);
  static const odrrmOlive = Color(0xFF91A423);
  static const odrrmGold = Color(0xFFFDCA02);

  // Semantic aliases keep screen code focused on use rather than brand source.
  static const navy = sbnuNavy;
  static const orange = sbnuOrange;
  static const gold = cmuGold;
  static const green = cmuGreen;
  static const canvas = Color(0xFFF7F8F1);
  static const mutedText = Color(0xFF667085);
}

abstract final class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      secondary: AppColors.orange,
      tertiary: AppColors.cmuGold,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.canvas,
    useMaterial3: true,
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: AppColors.navy,
      displayColor: AppColors.navy,
    ),
  );
}
