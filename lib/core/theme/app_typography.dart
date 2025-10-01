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
    fontSize: 24,           // --text-2xl equivalent
    fontWeight: medium,     // --font-weight-medium: 500
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 20,           // --text-xl equivalent  
    fontWeight: medium,     // --font-weight-medium: 500
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 18,           // --text-lg equivalent
    fontWeight: medium,     // --font-weight-medium: 500
    height: 1.5,           // line-height: 1.5
    fontFamily: fontFamily,
    color: Colors.white,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 16,           // --text-base equivalent
    fontWeight: medium,     // --font-weight-medium: 500
    height: 1.5,           // line-height: 1.5
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
}
