// lib/core/theme/app_border_radius.dart
import 'package:flutter/material.dart';

/// EXACT BORDER RADIUS FROM APP KA SAARANSH.md
class AppBorderRadius {
  // --radius: 1.5rem; /* 24px for large rounded corners */
  static const double small = 8.0;    // rounded-sm
  static const double medium = 12.0;  // rounded
  static const double large = 16.0;   // rounded-lg
  static const double xLarge = 20.0;  // rounded-xl
  static const double xxLarge = 24.0; // rounded-2xl (default --radius)
  static const double xxxLarge = 32.0; // rounded-3xl
  
  // Border radius objects
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(small));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(large));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(xLarge));
  static const BorderRadius radiusXXLarge = BorderRadius.all(Radius.circular(xxLarge));
  static const BorderRadius radiusXXXLarge = BorderRadius.all(Radius.circular(xxxLarge));
}