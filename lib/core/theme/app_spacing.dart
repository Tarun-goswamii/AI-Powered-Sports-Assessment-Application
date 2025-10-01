// lib/core/theme/app_spacing.dart
import 'package:flutter/material.dart';

/// EXACT SPACING SYSTEM FROM APP KA SAARANSH.md
class AppSpacing {
  // Exact spacing scale from Tailwind/React implementation
  static const double xs = 4.0;    // 4px
  static const double sm = 8.0;    // 8px  
  static const double md = 12.0;   // 12px
  static const double lg = 16.0;   // 16px
  static const double xl = 20.0;   // 20px
  static const double xxl = 24.0;  // 24px
  static const double xxxl = 32.0; // 32px
  static const double huge = 48.0; // 48px
  
  // Padding values used throughout the app
  static const EdgeInsets paddingSmall = EdgeInsets.all(12.0);   // p-3
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);  // p-4
  static const EdgeInsets paddingLarge = EdgeInsets.all(20.0);   // p-5
  static const EdgeInsets paddingXLarge = EdgeInsets.all(24.0);  // p-6
  
  // Horizontal/Vertical specific padding
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: 16.0); // px-4
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: 20.0);  // px-5
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: 16.0);     // py-4
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: 20.0);      // py-5
}