// lib/core/theme/text_theme.dart
import 'package:flutter/material.dart';

/// Enhanced text theme with proper contrast ratios for accessibility
class AppTextTheme {
  // High contrast text colors for dark backgrounds
  static const Color textPrimary = Colors.white;                    // #FFFFFF - Primary text
  static const Color textSecondary = Color(0xFFE0E0E0);            // #E0E0E0 - Secondary text
  static const Color textTertiary = Color(0xFFB0B0B0);             // #B0B0B0 - Tertiary text
  static const Color textDisabled = Color(0xFF808080);             // #808080 - Disabled text
  static const Color textOnPurple = Colors.white;                  // White on purple
  static const Color textOnBlue = Colors.white;                    // White on blue
  static const Color textOnGreen = Colors.black;                   // Black on green (better contrast)
  static const Color textOnOrange = Colors.black;                  // Black on orange (better contrast)
  static const Color textOnGlass = Colors.white;                   // White on glass surfaces

  // Contextual text colors
  static const Color textSuccess = Color(0xFF4CAF50);              // Success messages
  static const Color textWarning = Color(0xFFFFC107);              // Warning messages
  static const Color textError = Color(0xFFF44336);                // Error messages
  static const Color textInfo = Color(0xFF2196F3);                 // Info messages

  // Text styles with guaranteed visibility
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.25,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.25,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textTertiary,
    height: 1.3,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: textTertiary,
    height: 1.2,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.5,
  );

  // Helper methods for adaptive text colors
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine text color
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static TextStyle getContrastingTextStyle(Color backgroundColor, {
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final textColor = getTextColorForBackground(backgroundColor);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
    );
  }

  // Themed text widgets for guaranteed visibility
  static Widget primaryText(String text, {double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: textPrimary,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  static Widget secondaryText(String text, {double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: textSecondary,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 1,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
    );
  }

  static Widget glassText(String text, {double? fontSize, FontWeight? fontWeight}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}