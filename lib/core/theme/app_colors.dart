// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class AppColors {
  // 🎯 EXACT BRAND COLORS FROM REACT CSS (DO NOT CHANGE HEX VALUES)
  static const Color royalPurple = Color(0xFF6A0DAD);    // --royal-purple: #6A0DAD
  static const Color electricBlue = Color(0xFF007BFF);   // --electric-blue: #007BFF
  static const Color neonGreen = Color(0xFF00FFB2);      // --neon-green: #00FFB2
  static const Color deepCharcoal = Color(0xFF121212);   // --deep-charcoal: #121212
  static const Color lightLavender = Color(0xFFE6E6FA);  // --light-lavender: #E6E6FA
  static const Color warmOrange = Color(0xFFFF7A00);     // --warm-orange: #FF7A00
  static const Color brightRed = Color(0xFFFF3B3B);      // --bright-red: #FF3B3B

  // 🌙 DARK THEME COLORS (Default - matching CSS variables)
  static const Color background = deepCharcoal;
  static const Color foreground = Colors.white;
  static const Color card = Color(0x0CFFFFFF);           // rgba(255,255,255,0.05)
  static const Color cardForeground = Colors.white;
  static const Color popover = deepCharcoal;
  static const Color popoverForeground = Colors.white;
  static const Color primary = royalPurple;
  static const Color primaryForeground = Colors.white;
  static const Color secondary = electricBlue;
  static const Color secondaryForeground = Colors.white;
  static const Color muted = Color(0x1AFFFFFF);          // rgba(255,255,255,0.1)
  static const Color mutedForeground = Color(0xB3FFFFFF); // rgba(255,255,255,0.7)
  static const Color accent = neonGreen;
  static const Color accentForeground = Colors.black;
  static const Color destructive = brightRed;
  static const Color destructiveForeground = Colors.white;
  static const Color border = Color(0x1AFFFFFF);         // rgba(255,255,255,0.1)
  static const Color input = Color(0x0CFFFFFF);          // rgba(255,255,255,0.05)
  static const Color inputBackground = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)
  static const Color ring = electricBlue;

  // 📊 CHART COLORS (Data visualization)
  static const Color chart1 = royalPurple;
  static const Color chart2 = electricBlue;
  static const Color chart3 = neonGreen;
  static const Color chart4 = warmOrange;
  static const Color chart5 = brightRed;

  // ✨ EXACT GLASSMORPHISM EFFECTS FROM REACT CSS
  // .glass-card { background: rgba(255, 255, 255, 0.08); backdrop-filter: blur(15px); }
  static const Color glassmorphismBackground = Color(0x14FFFFFF); // rgba(255,255,255,0.08) EXACT
  static const Color glassmorphismBorder = Color(0x26FFFFFF);     // rgba(255,255,255,0.15) EXACT

  // Additional glassmorphism variants from React CSS
  static const Color glassLight = Color(0x0DFFFFFF);              // rgba(255,255,255,0.05) from .glass
  static const Color cardBackground = Color(0x0CFFFFFF);          // rgba(255,255,255,0.05) from --card

  // 🌈 GRADIENT DEFINITIONS
  static final LinearGradient purpleBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [royalPurple, electricBlue],
  );

  static final LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      royalPurple.withOpacity(0.1),
      electricBlue.withOpacity(0.05),
    ],
  );

  static final LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFF1A1A1A),
      deepCharcoal,
      const Color(0xFF0A0A0A),
    ],
  );

  // 💫 EXACT NEON GLOW SHADOW EFFECTS FROM REACT CSS
  // .glass-card { box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3); }
  static final List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  // .neon-glow { box-shadow: 0 0 20px rgba(106, 13, 173, 0.5), 0 0 40px rgba(106, 13, 173, 0.3); }
  static final List<BoxShadow> neonGlowPurple = [
    BoxShadow(
      color: Color(0x806A0DAD), // rgba(106, 13, 173, 0.5) EXACT
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
    BoxShadow(
      color: Color(0x4D6A0DAD), // rgba(106, 13, 173, 0.3) EXACT
      blurRadius: 40,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  // .neon-glow-blue { box-shadow: 0 0 20px rgba(0, 123, 255, 0.5), 0 0 40px rgba(0, 123, 255, 0.3); }
  static final List<BoxShadow> neonGlowBlue = [
    BoxShadow(
      color: Color(0x80007BFF), // rgba(0, 123, 255, 0.5) EXACT
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
    BoxShadow(
      color: Color(0x4D007BFF), // rgba(0, 123, 255, 0.3) EXACT
      blurRadius: 40,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  // .neon-glow-green { box-shadow: 0 0 20px rgba(0, 255, 178, 0.5), 0 0 40px rgba(0, 255, 178, 0.3); }
  static final List<BoxShadow> neonGlowGreen = [
    BoxShadow(
      color: Color(0x8000FFB2), // rgba(0, 255, 178, 0.5) EXACT
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
    BoxShadow(
      color: Color(0x4D00FFB2), // rgba(0, 255, 178, 0.3) EXACT
      blurRadius: 40,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  // .neon-glow-orange { box-shadow: 0 0 20px rgba(255, 122, 0, 0.5), 0 0 40px rgba(255, 122, 0, 0.3); }
  static final List<BoxShadow> neonGlowOrange = [
    BoxShadow(
      color: Color(0x80FF7A00), // rgba(255, 122, 0, 0.5) EXACT
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
    BoxShadow(
      color: Color(0x4DFF7A00), // rgba(255, 122, 0, 0.3) EXACT
      blurRadius: 40,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  // .neon-glow-pink { box-shadow: 0 0 20px rgba(236, 72, 153, 0.5), 0 0 40px rgba(236, 72, 153, 0.3); }
  static final List<BoxShadow> neonGlowPink = [
    BoxShadow(
      color: Color(0x80EC4899), // rgba(236, 72, 153, 0.5) EXACT
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
    BoxShadow(
      color: Color(0x4DEC4899), // rgba(236, 72, 153, 0.3) EXACT
      blurRadius: 40,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  // .neon-glow-gray { box-shadow: 0 0 20px rgba(156, 163, 175, 0.5), 0 0 40px rgba(156, 163, 175, 0.3); }
  static final List<BoxShadow> neonGlowGray = [
    BoxShadow(
      color: Color(0x809CA3AF), // rgba(156, 163, 175, 0.5) EXACT
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
    BoxShadow(
      color: Color(0x4D9CA3AF), // rgba(156, 163, 175, 0.3) EXACT
      blurRadius: 40,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  // 🎭 STATUS COLORS
  static const Color success = neonGreen;
  static const Color warning = warmOrange;
  static const Color error = brightRed;
  static const Color info = electricBlue;

  // 📝 TEXT COLORS
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF);    // rgba(255,255,255,0.7)
  static const Color textTertiary = Color(0x80FFFFFF);     // rgba(255,255,255,0.5)
  static const Color textDisabled = Color(0x4DFFFFFF);     // rgba(255,255,255,0.3)

  // 🛠️ UTILITY METHODS
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // 🪟 EXACT GLASSMORPHISM DECORATION FACTORY (MATCHES REACT CSS)
  static BoxDecoration glassmorphismDecoration({
    BorderRadius? borderRadius,
    bool enableNeonGlow = false,
    Color? neonGlowColor,
    List<BoxShadow>? customShadow,
  }) {
    List<BoxShadow> shadows = customShadow ?? glassShadow;

    if (enableNeonGlow && neonGlowColor != null) {
      if (neonGlowColor == royalPurple) {
        shadows = neonGlowPurple;
      } else if (neonGlowColor == electricBlue) {
        shadows = neonGlowBlue;
      } else if (neonGlowColor == neonGreen) {
        shadows = neonGlowGreen;
      } else if (neonGlowColor == warmOrange) {
        shadows = neonGlowOrange;
      }
    }

    return BoxDecoration(
      color: glassmorphismBackground,
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      border: Border.all(
        color: glassmorphismBorder,
        width: 1,
      ),
      boxShadow: shadows,
    );
  }

  // 🎨 THEME DATA FACTORY
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
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
    );
  }
}

// ✍️ EXACT TYPOGRAPHY SYSTEM FROM REACT CSS
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

// 📐 EXACT SPACING SYSTEM FROM REACT CSS/TAILWIND
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

// 🎨 EXACT BORDER RADIUS FROM REACT CSS
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

// 🎬 EXACT ANIMATION SYSTEM FROM REACT CSS
class AppAnimations {
  // Animation durations matching React CSS keyframes
  static const Duration short = Duration(milliseconds: 150);     // Quick interactions
  static const Duration medium = Duration(milliseconds: 300);    // Standard transitions
  static const Duration long = Duration(milliseconds: 500);      // Complex animations
  static const Duration extraLong = Duration(milliseconds: 600); // bounce-in animation

  // Animation curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;

  // Exact animation values from React CSS

  // @keyframes float { 0%, 100% { transform: translateY(0px); } 50% { transform: translateY(-10px); } }
  static Tween<double> floatTween = Tween<double>(begin: 0.0, end: -10.0);
  static const Duration floatDuration = Duration(seconds: 3);

  // @keyframes bounce-in animation with cubic-bezier(0.68, -0.55, 0.265, 1.55)
  static Tween<double> scaleBounceTween = Tween<double>(begin: 0.3, end: 1.0);
  static const Duration bounceInDuration = extraLong;
  static const Curve bounceInCurve = Cubic(0.68, -0.55, 0.265, 1.55);

  // @keyframes slide-in-up { 0% { transform: translateY(100px); opacity: 0; } }
  static Tween<Offset> slideUpTween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  );
  static Tween<double> fadeInTween = Tween<double>(begin: 0.0, end: 1.0);
  static const Duration slideUpDuration = long;

  // @keyframes shake animation
  static const Duration shakeDuration = Duration(milliseconds: 500);
  static const List<double> shakeValues = [-2, 2, -2, 2, -2, 2, -2, 2, 0];

  // @keyframes glow animation with purple glow intensity changes
  static Tween<double> glowTween = Tween<double>(begin: 0.3, end: 0.6);
  static const Duration glowDuration = Duration(seconds: 2);

  // Button press animation (scale 1.0 → 0.95)
  static Tween<double> buttonPressTween = Tween<double>(begin: 1.0, end: 0.95);
  static const Duration buttonPressDuration = short;

  // Page transition animations
  static const Duration pageTransitionDuration = medium;
  static SlideTransition slideTransition(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: easeOut)),
      ),
      child: child,
    );
  }

  static FadeTransition fadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation.drive(
        Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: easeOut)),
      ),
      child: child,
    );
  }
}

// 📱 EXACT RESPONSIVE BREAKPOINTS FROM REACT CSS
class AppBreakpoints {
  // Mobile optimizations from React CSS
  static const double mobile = 480.0;    // Extra small devices
  static const double tablet = 768.0;    // Mobile breakpoint from CSS
  static const double desktop = 1024.0;  // Keep mobile-first design

  // Safe area constants for mobile devices
  static const double bottomNavHeight = 80.0;  // Height of bottom nav
  static const double statusBarHeight = 44.0;  // Typical status bar height

  // Responsive font sizes (matching CSS media queries)
  static const double baseFontSizeMobile = 14.0;      // :root { --font-size: 14px; }
  static const double baseFontSizeDesktop = 16.0;     // :root { --font-size: 16px; }

  // Touch target sizes for mobile (min 44px from CSS)
  static const double minTouchTarget = 44.0;
}

// 🏗️ EXACT LAYOUT SPECIFICATIONS FROM REACT IMPLEMENTATION
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

// 🎨 EXACT GRADIENT DEFINITIONS FROM REACT CSS
class AppGradients {
  // .gradient-purple-blue { background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); }
  static const LinearGradient purpleBlue = LinearGradient(
    begin: Alignment.topLeft,     // 135deg equivalent
    end: Alignment.bottomRight,
    colors: [
      AppColors.royalPurple,      // #6A0DAD 0%
      AppColors.electricBlue,     // #007BFF 100%
    ],
  );

  // .gradient-card { background: linear-gradient(135deg, rgba(106, 13, 173, 0.1) 0%, rgba(0, 123, 255, 0.05) 100%); }
  static const LinearGradient card = LinearGradient(
    begin: Alignment.topLeft,     // 135deg equivalent
    end: Alignment.bottomRight,
    colors: [
      Color(0x1A6A0DAD),          // rgba(106, 13, 173, 0.1) 0%
      Color(0x0D007BFF),          // rgba(0, 123, 255, 0.05) 100%
    ],
  );

  // Background gradient for screens
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1A1A),          // Slightly lighter than deep charcoal
      AppColors.deepCharcoal,     // #121212
      Color(0xFF0A0A0A),          // Darker than deep charcoal
    ],
  );

  // Button gradients
  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.royalPurple, AppColors.electricBlue],
  );

  static const LinearGradient secondaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1A6A0DAD),          // rgba(106, 13, 173, 0.1)
      Color(0x1A007BFF),          // rgba(0, 123, 255, 0.1)
    ],
  );
}
