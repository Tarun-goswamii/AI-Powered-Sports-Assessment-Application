// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';

/// EXACT TYPOGRAPHY SYSTEM FROM APP KA SAARANSH.md
class AppTypography {
  // Font family: 'Inter', 'Roboto', -apple-system, BlinkMacSystemFont, system-ui, sans-serif
  static const String fontFamily = 'Inter';
  
  // EXACT font weights from React CSS
  static const FontWeight normal = FontWeight.w400;   // --font-weight-normal: 400
  static const FontWeight medium = FontWeight.w500;   // --font-weight-medium: 500
  static const FontWeight semiBold = FontWeight.w600; // Semi-bold
  static const FontWeight bold = FontWeight.w700;     // Bold
  
  // EXACT text styles matching React CSS typography
  static const TextStyle h1 = TextStyle(
    fontSize: 32,           // --text-2xl equivalent
    fontWeight: semiBold,     // --font-weight-medium: 500
    height: 1.2,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,           // --text-xl equivalent  
    fontWeight: semiBold,     // --font-weight-medium: 500
    height: 1.3,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,           // --text-lg equivalent
    fontWeight: semiBold,     // --font-weight-medium: 500
    height: 1.4,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,           // --text-base equivalent
    fontWeight: normal,     // --font-weight-normal: 400
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,           // --text-sm equivalent
    fontWeight: normal,     // --font-weight-normal: 400
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,           // --text-xs equivalent
    fontWeight: normal,     // --font-weight-normal: 400
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,           // --text-base equivalent
    fontWeight: medium,     // --font-weight-medium: 500
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,           // --text-base equivalent
    fontWeight: medium,     // --font-weight-medium: 500
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  // Additional heading styles
  static const TextStyle headingLarge = h1;
  static const TextStyle headingMedium = h2;
  static const TextStyle headingSmall = h3;
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.4,
    fontFamily: fontFamily,
    color: Colors.white,
  );
}
