// lib/core/theme/app_layout.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

// EXACT LAYOUT SPECIFICATIONS FROM REACT IMPLEMENTATION
class AppLayout {
  // Bottom Navigation specifications (from BottomNavigationBar component)
  static const double bottomNavHeight = 80.0;
  static const int bottomNavItemCount = 5;
  static const List<String> bottomNavLabels = ['Home', 'Results', 'Community', 'Mentors', 'Profile'];

  // Test Cards Grid specifications (from HomeScreen)
  static const int testGridCrossAxisCount = 2;           // 2 columns
  static const double testGridCrossAxisSpacing = 12.0;   // gap-3
  static const double testGridMainAxisSpacing = 12.0;    // gap-3
  static const double testGridChildAspectRatio = 0.85;   // Height slightly more than width
  static const int testGridItemCount = 6;                // 6 test cards total

  // Quick Access Cards specifications (from HomeScreen)
  static const int quickAccessCardCount = 5;
  static const List<String> quickAccessLabels = ['Mentors', 'Community', 'Nutrition', 'Recovery', 'Body Logs'];
  static const List<Color> quickAccessColors = [
    AppColors.royalPurple,  // Mentors - purple
    AppColors.electricBlue, // Community - blue
    AppColors.warmOrange,   // Nutrition - orange
    Color(0xFFEC4899),      // Recovery - pink
    Color(0xFF9CA3AF),      // Body Logs - gray
  ];

  // Home Screen Layout specifications
  static const EdgeInsets homeScreenPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
  static const double homeScreenSpacing = 24.0;          // Space between sections
  static const double progressCardHeight = 120.0;        // Progress card height
  static const double quickAccessHeight = 140.0;         // Quick access cards section height
  static const double quickAccessCardWidth = 120.0;      // Width of each quick access card
  static const double quickStatsHeight = 80.0;          // Quick stats section height

  // Glass Card specifications (matching React glassmorphism)
  static const double glassCardDefaultPadding = 20.0;    // Default padding inside cards
  static const double glassCardBorderRadius = 24.0;      // Default border radius
  static const double glassCardBorderWidth = 1.0;        // Border width
  static const double glassCardBlurRadius = 15.0;        // backdrop-filter: blur(15px)

  // Modal and Dialog specifications
  static const double modalBorderRadius = 24.0;
  static const EdgeInsets modalPadding = EdgeInsets.all(24.0);
  static const Color modalBarrierColor = Color(0x80000000); // Semi-transparent black

  // Safe area handling (from React CSS mobile optimizations)
  static const EdgeInsets safeAreaPadding = EdgeInsets.only(
    top: 44.0,    // Status bar height
    bottom: 34.0, // Home indicator height on newer iPhones
  );
}

// 🎯 EXACT COMPONENT SPECIFICATIONS FROM REACT IMPLEMENTATION
class AppComponents {
  // NeonButton specifications (from NeonButton.tsx)
  static const Map<String, double> buttonHeights = {
    'sm': 36.0,    // Small button
    'md': 44.0,    // Medium button (default)
    'lg': 52.0,    // Large button
  };

  static const Map<String, EdgeInsets> buttonPadding = {
    'sm': EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    'md': EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    'lg': EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
  };

  // TestCard specifications (exact layout from React component)
  static const double testCardWidth = 160.0;    // Calculated from grid
  static const double testCardHeight = 185.0;   // Based on aspect ratio
  static const double testCardIconSize = 48.0;  // Icon container size
  static const double testCardBadgeSize = 20.0; // Status badge size

  // Progress Card specifications (from HomeScreen progress section)
  static const double progressBarHeight = 8.0;
  static const double progressBarBorderRadius = 4.0;
  static const Color progressBarBackground = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)
  static const Gradient progressBarGradient = LinearGradient(
    colors: [AppColors.royalPurple, AppColors.electricBlue],
  );

  // Avatar specifications
  static const double avatarSizeSmall = 32.0;   // Small avatar
  static const double avatarSizeMedium = 48.0;  // Medium avatar
  static const double avatarSizeLarge = 64.0;   // Large avatar
  static const double avatarSizeXLarge = 96.0;  // Extra large (profile)

  // Icon sizes throughout the app
  static const double iconSizeSmall = 16.0;     // Small icons
  static const double iconSizeMedium = 20.0;    // Medium icons
  static const double iconSizeLarge = 24.0;     // Large icons
  static const double iconSizeXLarge = 32.0;    // Extra large icons

  // Badge specifications
  static const double badgeHeight = 24.0;
  static const double badgeBorderRadius = 12.0;
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);

  // Input field specifications
  static const double inputFieldHeight = 48.0;
  static const double inputFieldBorderRadius = 12.0;
  static const EdgeInsets inputFieldPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const Color inputFieldBackgroundColor = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)

  // Loading indicator specifications
  static const double loadingIndicatorSize = 32.0;
  static const double loadingIndicatorStrokeWidth = 3.0;
  static const Color loadingIndicatorColor = AppColors.royalPurple;
}
