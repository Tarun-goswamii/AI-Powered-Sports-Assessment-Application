// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.royalPurple,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.electricBlue,
        onSecondary: AppColors.secondaryForeground,
        tertiary: AppColors.neonGreen,
        onTertiary: AppColors.accentForeground,
        error: AppColors.brightRed,
        onError: AppColors.destructiveForeground,
        background: AppColors.background,
        onBackground: AppColors.foreground,
        surface: AppColors.card,
        onSurface: AppColors.cardForeground,
        outline: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.foreground,
        elevation: 0,
      ),
    );
  }

  static ThemeData get lightTheme {
    // For completeness, though we use dark theme
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: AppColors.royalPurple,
        secondary: AppColors.electricBlue,
      ),
    );
  }
}
