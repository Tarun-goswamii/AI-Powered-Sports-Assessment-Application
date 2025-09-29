import 'package:flutter/material.dart';

class AppColors {
  // 🎯 STEADY PROFESSIONAL COLORS (No glowy effects)
  static const Color royalPurple = Color(0xFF6366F1);    // Indigo-500 - professional purple
  static const Color electricBlue = Color(0xFF3B82F6);   // Blue-500 - professional blue
  static const Color successGreen = Color(0xFF10B981);   // Emerald-500 - professional green
  static const Color deepCharcoal = Color(0xFF121212);   // Dark background
  static const Color warmOrange = Color(0xFFF59E0B);     // Amber-500 - professional orange
  static const Color errorRed = Color(0xFFEF4444);       // Red-500 - professional red
  static const Color warningYellow = Color(0xFFF59E0B);  // Amber-500 for warnings

  // 🌙 DARK THEME COLORS (Clean and professional)
  static const Color background = deepCharcoal;
  static const Color foreground = Colors.white;
  static const Color card = Color(0xFF1E1E1E);           // Subtle dark card
  static const Color cardForeground = Colors.white;
  static const Color primary = royalPurple;
  static const Color primaryForeground = Colors.white;
  static const Color secondary = electricBlue;
  static const Color secondaryForeground = Colors.white;
  static const Color muted = Color(0xFF2A2A2A);          // Muted surface
  static const Color mutedForeground = Color(0xFF9CA3AF); // Gray text
  static const Color accent = successGreen;
  static const Color accentForeground = Colors.white;
  static const Color destructive = errorRed;
  static const Color destructiveForeground = Colors.white;
  static const Color border = Color(0xFF374151);         // Subtle border
  static const Color input = Color(0xFF1F2937);          // Input background
  static const Color inputBackground = Color(0xFF1F2937);
  static const Color ring = electricBlue;

  // 📊 CHART COLORS (Professional data visualization)
  static const Color chart1 = royalPurple;
  static const Color chart2 = electricBlue;
  static const Color chart3 = successGreen;
  static const Color chart4 = warmOrange;
  static const Color chart5 = errorRed;

  // 🎨 SUBTLE BACKGROUNDS (No glassmorphism glow)
  static const Color glassmorphismBackground = Color(0xFF1A1A1A); // Solid dark
  static const Color glassmorphismBorder = Color(0xFF374151);     // Subtle border

  // 🌈 CLEAN GRADIENTS (No neon effects)
  static final LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [royalPurple, electricBlue],
  );

  static final LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successGreen, electricBlue],
  );

  // Background gradient for screens
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1A1A),
      deepCharcoal,
      Color(0xFF0A0A0A),
    ],
  );

  // 💫 SUBTLE SHADOWS (No neon glow)
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // 🎭 STATUS COLORS
  static const Color success = successGreen;
  static const Color warning = warningYellow;
  static const Color error = errorRed;
  static const Color info = electricBlue;

  // 📝 TEXT COLORS
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF4B5563);

  // 🛠️ UTILITY METHODS
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // 🪟 CLEAN CARD DECORATION (No glassmorphism)
  static BoxDecoration cardDecoration({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? customShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? card,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      border: Border.all(
        color: border,
        width: 1,
      ),
      boxShadow: customShadow ?? cardShadow,
    );
  }

  // 🎨 THEME DATA
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: primaryForeground,
        secondary: secondary,
        onSecondary: secondaryForeground,
        tertiary: accent,
        onTertiary: accentForeground,
        error: destructive,
        onError: destructiveForeground,
        background: background,
        onBackground: foreground,
        surface: card,
        onSurface: cardForeground,
        outline: border,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// 📐 SPACING SYSTEM
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  static const EdgeInsets paddingSmall = EdgeInsets.all(12.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(20.0);
}

// 🎨 BORDER RADIUS
class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 20.0;

  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(small));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(large));
}

// 📱 COMPONENT SIZES
class AppComponents {
  // Test Card
  static const double testCardWidth = 160.0;
  static const double testCardHeight = 180.0;
  static const double testCardIconSize = 40.0;

  // Buttons
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 52.0;

  // Progress
  static const double progressBarHeight = 6.0;

  // Icons
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
}
