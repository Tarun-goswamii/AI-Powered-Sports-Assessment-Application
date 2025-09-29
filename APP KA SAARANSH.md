# APP KA SAARANSH
## Complete Documentation for AI-Powered Sports Talent Assessment Platform

**🎯 IMPORTANT: This documentation is specifically designed for Flutter implementation. When implementing this app using AI, use Flutter/Dart exclusively. All code examples, architecture patterns, and implementation details are optimized for Flutter development.**

---

## 📋 TABLE OF CONTENTS

1. [Executive Summary](#executive-summary)
2. [App Architecture & Tech Stack](#app-architecture--tech-stack)
3. [Design System & Theme](#design-system--theme)
4. [Navigation & User Flow](#navigation--user-flow)
5. [Screen-by-Screen Implementation](#screen-by-screen-implementation)
6. [Core Features & Components](#core-features--components)
7. [Data Models & Backend Integration](#data-models--backend-integration)
8. [UI Components Library](#ui-components-library)
9. [State Management](#state-management)
10. [Flutter Implementation Guide](#flutter-implementation-guide)
11. [Development Setup](#development-setup)
12. [Production Deployment](#production-deployment)

---

## 🎯 EXECUTIVE SUMMARY

### App Vision
A world-class mobile application UI for an AI-powered sports talent assessment platform used by athletes across India to record and submit standardized fitness tests. The app combines premium, futuristic design with government trustworthiness, using glassmorphism effects and neon energy.

### Target Audience
- Athletes across India
- Sports enthusiasts
- Fitness professionals
- Government sports assessment programs

### Key Value Propositions
- Standardized fitness test recording
- AI-powered performance analysis
- Personalized coaching recommendations
- Community engagement platform
- Verified supplement marketplace
- Credit points reward system

---

## 🏗️ APP ARCHITECTURE & TECH STACK

### 🎯 PRIMARY IMPLEMENTATION: Flutter/Dart
```
Framework: Flutter 3.16+ with Dart 3.2+
State Management: Riverpod (Provider pattern) + Freezed
Routing: GoRouter 12.1.3+ with Custom App Router
UI Components: Material Design 3 + Custom Glassmorphism Widgets
Animations: Flutter Animation Framework + Custom Transitions
Backend: Supabase Flutter SDK 2.0+
Local Storage: SharedPreferences + Hive + Secure Storage
Platform Integration: Native iOS/Android APIs
Camera: Camera Plugin for test recording
Location: Geolocator for nearby stores
Notifications: Flutter Local Notifications + FCM
HTTP: Dio for API calls with retry mechanism
Image Handling: Cached Network Image + Image Picker
Icons: Material Icons (built-in) + Custom SVG assets
Typography: Google Fonts (Inter family)
Package Management: Pubspec.yaml with version constraints
```

### 📋 REFERENCE: React Implementation (For Comparison Only)
```
Frontend: React 18 + TypeScript
Styling: Tailwind CSS v4.0 + Custom CSS Variables
State Management: React Context API + Local State
Routing: Custom Screen Navigation System
UI Components: shadcn/ui + Custom Components
Animations: Motion (Framer Motion)
Icons: Lucide React
Backend: Supabase (PostgreSQL + Auth + Real-time)
Notifications: Sonner Toast System
```

### 🏗️ Architecture Pattern (Flutter-First)
- **Flutter**: Feature-first clean architecture with Riverpod state management
- **Layered Architecture**: Presentation → Business Logic → Data (Repository Pattern)
- **Dependency Injection**: Riverpod providers for service location
- **State Management**: Riverpod with Freezed for immutable state
- **Error Handling**: Centralized error boundary with user-friendly fallbacks
- **Backend**: Supabase BaaS with PostgreSQL database
- **Real-time**: WebSocket connections via Supabase Realtime
- **Offline Support**: Hive local database with sync capabilities
- **Testing**: Unit tests, Widget tests, Integration tests

---

## 🎨 DESIGN SYSTEM & THEME

### 🎨 PIXEL-PERFECT FLUTTER COLOR SYSTEM (EXACT REACT PARITY)

**CRITICAL: These are the EXACT colors from React implementation - DO NOT MODIFY**

**Complete app_colors.dart File**:
```dart
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
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
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
  static const List<double> shakeValues = [-2, 2, -2, 2, -2, 2, 0];
  
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
```

### Typography System
```css
Font Family: 'Inter', 'Roboto', system fonts
Font Weights: 400 (normal), 500 (medium), 600 (semibold), 700 (bold)

/* Text Scale */
--text-xs: 12px
--text-sm: 14px
--text-base: 16px
--text-lg: 18px
--text-xl: 20px
--text-2xl: 24px
--text-3xl: 28px
```

### Spacing System
```css
/* Spacing Scale */
--space-1: 4px
--space-2: 8px
--space-3: 12px
--space-4: 16px
--space-6: 24px
--space-8: 32px
--space-12: 48px
--space-16: 64px
```

### Border Radius
```css
--radius-sm: 8px
--radius-md: 12px
--radius-lg: 16px
--radius-xl: 24px
--radius-2xl: 32px
```

### Glassmorphism Effects
```css
.glass-card {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

/* Neon Glow Variations */
.neon-glow-purple { box-shadow: 0 0 20px rgba(106, 13, 173, 0.5); }
.neon-glow-blue { box-shadow: 0 0 20px rgba(0, 123, 255, 0.5); }
.neon-glow-green { box-shadow: 0 0 20px rgba(0, 255, 178, 0.5); }
```

---

## 🧭 NAVIGATION & USER FLOW

### 1. Authentication & Onboarding Flow
```
┌─────────────┐    ┌──────────────────────────────────────┐    ┌─────────────┐
│             │    │        ONBOARDING SCREEN             │    │             │
│   SPLASH    │───▶│  ┌────────────┐ ┌────────────┐ ┌─────────┐ │    AUTH     │
│   SCREEN    │    │  │   Slide 1  │ │   Slide 2  │ │ Slide 3 │ │   SCREEN    │
│             │    │  │ "Assess    │ │ "AI-Powered│ │ "Join   │ │             │
│ - App Logo  │    │  │ Athletic   │ │ Analysis"  │ │ Sports  │ │ - Login     │
│ - Loading   │    │  │ Potential" │ │            │ │ Community"│ │ - Signup    │
│ - Version   │    │  └────────────┘ └────────────┘ └─────────┘ │ - Social    │
│             │    │  ┌──────────────────────────────────────┐ │ - Forgot    │
│ ⏱️ 2.5s     │    │  │ Navigation: Dots, Skip, Next/Start  │ │   Password  │
│             │    │  └──────────────────────────────────────┘ │             │
└─────────────┘    └──────────────────────────────────────────┘ └─────────────┘
       │                                   │                           │
       │ (First Time)                      │ (Skip)                    │ (Success)
       │                                   │                           │
       │                 ┌─────────────────┴──────────────┐            │
       │ (Returning)     │                                │            ▼
       │                 ▼                                ▼      ┌─────────────┐
       └─────────────────────────────────────────────────────────▶│             │
                                                                  │ HOME SCREEN │
┌─────────────────────────────────────────────────────────────────▶│             │
│ (User Already Authenticated)                                    │ - Dashboard │
│                                                                 │ - Navigation│
└─────────────────────────────────────────────────────────────────┴─────────────┘

Authentication States:
• hasSeenOnboarding: false → Splash → Onboarding → Auth
• hasSeenOnboarding: true + !authenticated → Splash → Auth  
• hasSeenOnboarding: true + authenticated → Splash → Home
• Logout: Any Screen → Auth (maintains onboarding state)

Error Handling:
• Network Error → Retry mechanism with exponential backoff
• Auth Error → Error message + retry option
• Loading Timeout → Manual continue option
```

### 2. Home & Main Navigation Flow
```
                              ┌─────────────────────────┐
                              │      HOME SCREEN        │
                              │ ┌─────────────────────┐ ���
                              │ │ Header Section      │ │
                              │ │ - Greeting         │ │
                              │ │ - Daily Bonus Btn  │ │
                              │ │ - Notifications    │ │
                              │ └─────────────────────┘ │
                              │ ┌─────────────────────┐ │
                              │ │ Progress Card       │ │
                              │ │ - 4/6 tests done   │ │
                              │ │ - Progress bar     │ │
                              │ └─────────────────────┘ │
                              │ ┌─────────────────────┐ │
                              │ │ Quick Access Cards  │ │
                              │ │ - Mentors (purple) │ │
                              │ │ - Community (blue) │ │
                              │ │ - Nutrition (orange)│ │
                              │ │ - Recovery (pink)   │ │
                              │ │ - Body Logs (gray)  │ │
                              │ └─────────────────────┘ │
                              │ ┌─────────────────────┐ │
                              │ │ Test Grid (2x3)     │ │
                              │ │ V.Jump | Shuttle    │ │
                              │ │ Sit-up | Endurance  │ │
                              │ │ Height | Weight     │ │
                              │ └─────────────────────┘ │
                              │ ┌─────────────────────┐ │
                              │ │ Quick Stats         │ │
                              │ │ Tests|Rank|Badges   │ │
                              │ └─────────────────────┘ │
                              └─────────────────────────┘
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
                    ▼                    ▼                    ▼
         ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
         │   TEST CARDS    │  │ QUICK ACCESS    │  │ DAILY BONUS     │
         │                 │  │                 │  │                 │
         │ Click → Test    │  │ Mentors →       │  │ Click → Modal   │
         │ Detail Screen   │  │ Mentor Screen   │  │ - Claim Points  │
         │                 │  │                 │  │ - Streak Info   │
         │                 │  │ Community →     │  │ - Celebrations  │
         │                 │  │ Community Screen│  │                 │
         │                 │  │                 │  │                 │
         │                 │  │ Nutrition →     │  │                 │
         │                 │  │ Nutrition Screen│  │                 │
         │                 │  │                 │  │                 │
         │                 │  │ Recovery →      │  │                 │
         │                 │  │ Recovery Screen │  │                 │
         │                 │  │                 │  │                 │
         │                 │  │ Body Logs →     │  │                 │
         │                 │  │ Body Logs Screen│  │                 │
         └─────────────────┘  └─────────────────┘  └─────────────────┘

Bottom Navigation (Always Visible on Main Screens):
┌─────┬─────┬─────┬─────┬─────┐
│HOME │RESULTS│COMMUNITY│MENTORS│PROFILE│
└─────┴─────┴─────┴─────┴─────┘
  ↓     ↓      ↓       ↓      ↓
 Home  History Community Mentors Profile
Screen  Screen  Screen   Screen  Screen

Navigation Rules:
• Bottom nav visible on: Home, History, Community, Mentors, Profile
• Bottom nav hidden on: Auth, Test flow, Full-screen features
• Back button behavior: Hardware back → Previous screen or Home
• Deep linking: All screens support URL parameters
```

### 3. Test Assessment Flow  
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    HOME     │───▶│ TEST DETAIL │───▶│ CALIBRATION │───▶│ RECORDING   │
│   SCREEN    │    │   SCREEN    │    │   SCREEN    │    │   SCREEN    │
│             │    │             │    │             │    │             │
│ Test Card   │    │ - Test Info │    │ - Camera    │    │ - Live Feed │
│ Selection:  │    │ - Duration  │    │   Preview   │    │ - Timer     │
│ • V.Jump    │    │ - Equipment │    │ - Position  │    │ - Controls  │
│ • Shuttle   │    │ - Instructions│    │   Guide     │    │ - Metrics   │
│ • Sit-ups   │    │ - Difficulty│    │ - Markers   │    │ - Stop/Retry│
│ • Endurance │    │ - Requirements│    │ - Confirm   │    │             │
│ • Height    │    │ - Start Btn │    │   Setup     │    │             │
│ • Weight    │    │             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       ▲                  ▲                  ▲                  │
       │                  │                  │                  │
       │ (Home)           │ (Back)           │ (Back)           │
       │                  │                  │                  │
       │                  │                  │                  ▼
       │                  │                  │         ┌─────────────┐
       │                  │                  │         │   TEST      │
       │                  │                  │         │ COMPLETION  │
       │                  │                  │         │   SCREEN    │
       │                  │                  │         │             │
       │                  │                  │         │ - Success   │
       │                  │                  │         │   Animation │
       │                  │                  │         │ - Score     │
       │                  │                  │         │   Preview   │
       │                  │                  │         │ - Confetti  │
       │                  │                  │         │ - Next Steps│
       │                  │                  │         └─────────────┘
       │                  │                  │                  │
       │                  │                  │                  │
       │ (Home)           │ (Retake)         │                  ▼
       │                  │                  │         ┌─────────────┐
       │                  │                  │         │PERSONALIZED │
       │                  │                  │         │ SOLUTION    │
       │                  │                  │         │   SCREEN    │  
       │                  │                  │         │             │
       │                  │                  │         │ - AI Analysis│
       │                  │                  │         │ - Strengths │
       │                  │                  │         │ - Weaknesses│
       │                  │                  │         │ - Training  │
       │                  │                  │         │   Plan      │
       │                  │                  │         │ - Nutrition │
       │                  │                  │         │   Advice    │
       │                  │                  │         └─────────────┘
       │                  │                  │                  │
       │                  │                  │                  │
       │ (Complete)       │                  │                  ▼
       │                  │                  │         ┌─────────────┐
       │◀─────────────────┴──────────────────┴─────────│  RESULTS    │
       │                                               │   SCREEN    │
       │                                               │             │
       │                                               │ - Detailed  │
       │                                               │   Scores    │
       │                                               │ - Charts    │
       │                                               │ - Percentile│
       │                                               │ - History   │
       │                                               │ - Share     │
       │                                               │ - Retake    │
       └───────────────────────────────────────────────┴─────────────┘

Test States & Transitions:
• not-started → Start Test → Test Detail
• in-progress → Continue → Recording (skip calibration)
• completed → View Results → Results Screen
• Error States: Camera fail, Recording fail, Save fail
• Recovery: Auto-save every 30s, Resume on app restart

Special Cases:
• Height/Weight tests → Direct measurement (no recording)
• Network issues → Offline mode with sync later
• Hardware issues → Fallback to manual entry
```

### 4. Feature Access Flow
```
                          ┌─────────────────────────┐
                          │      HOME SCREEN        │
                          │   (Central Hub)         │
                          └─────┬───────────────────┘
                                │
                    ┌───────────┼───────────┐
                    │           │           │
                    ▼           ▼           ▼
          ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
          │   STORE     │ │ NUTRITION   │ │  RECOVERY   │
          │   SCREEN    │ │   SCREEN    │ │   SCREEN    │
          │             │ │             │ │             │
          │ - Products  │ │ - Meal Plans│ │ - Exercises │
          │ - Categories│ │ - Recipes   │ │ - Stretches │
          │ - Credit    │ │ - Nutrition │ │ - Rest Plans│
          │   Pricing   │ │   Tracking  │ │ - Sleep     │
          │ - Reviews   │ │ - Hydration │ │   Tracking  │
          │ - Wishlist  │ │ - Supplements│ │ - Meditation│
          │ - Cart      │ │ - AI Advice │ │ - Recovery  │
          │             │ │             │ │   Metrics   │
          └─────────────┘ └─────────────┘ └─────────────┘
                │               │               │
                ▼               ▼               ▼
       ┌─────────────────┐ ┌─────────────┐ ┌─────────────┐
       │ PRODUCT DETAIL  │ │MEAL PLANNER │ │SLEEP TRACKER│
       │    SCREEN       │ │   SCREEN    │ │   SCREEN    │
       │                 │ │             │ │             │
       │ - Full Details  │ │ - Custom    │ │ - Sleep Log │
       │ - Images        │ │   Plans     │ │ - Quality   │
       │ - Specifications│ │ - Calorie   │ │   Metrics   │
       │ - Reviews       │ │   Counter   │ │ - Patterns  │
       │ - Purchase      │ │ - Shopping  │ │ - Tips      │
       │ - Add to Cart   │ │   Lists     │ │             │
       └─────────────────┘ └─────────────┘ └─────────────┘
                │
                ▼
       ┌─────────────────┐
       │ NEARBY STORES   │
       │    SCREEN       │
       │                 │
       │ - Map View      │
       │ - Store List    │
       │ - Directions    │
       │ - Store Info    │
       │ - Inventory     │
       └─────────────────┘

Additional Feature Screens:
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ BODY LOGS   │    │  AI CHAT    │    │LEADERBOARD  │
│   SCREEN    │    │   SCREEN    │    │   SCREEN    │
│             │    │             │    │             │
│ - Weight    │    │ - Assistant │    │ - Rankings  │
│ - Body Fat  │    │ - Context   │    │ - Filters   │
│ - Muscle    │    │   Aware     │    │ - Categories│
│ - Progress  │    │ - Help &    │    │ - Friends   │
│   Photos    │    │   Guidance  │    │ - Challenges│
│ - Trends    │    │ - Training  │    │ - Rewards   │
│ - Goals     │    │   Tips      │    │             │
└─────────────┘    └─────────────┘    └─────────────┘

Navigation Patterns:
• Quick Access Cards → Direct to feature
• Menu/Settings → Full feature list
• Search functionality across all features
• Recently used features priority
• Contextual recommendations based on test results
```

### 5. Profile & Settings Flow
```
                    ┌─────────────────────────────────┐
                    │        PROFILE SCREEN           │
                    │ ┌─────────────────────────────┐ │
                    │ │ User Info Section           │ │
                    │ │ - Avatar                    │ │
                    │ │ - Name, Age, Location       │ │
                    │ │ - Sport Interests           │ │
                    │ │ - Fitness Level             │ │
                    │ └─────────────────────────────┘ │
                    │ ┌─────────────────────────────┐ │
                    │ │ Stats Overview              │ │
                    │ │ - Tests Completed: 15       │ │
                    │ │ - Current Rank: Top 25%     │ │
                    │ │ - Credit Points: 450        │ │
                    │ │ - Streak Days: 7            │ │
                    │ └─────────────────────────────┘ │
                    │ ┌─────────────────────────────┐ │
                    │ │ Quick Actions               │ │
                    │ │ - Edit Profile              │ │
                    │ │ - View Analytics            │ │  
                    │ │ - Achievements              │ │
                    │ │ - Test History              │ │
                    │ │ - Settings                  │ │
                    │ │ - Help & Support            │ │
                    │ │ - Logout                    │ │
                    │ └─────────────────────────────┘ │
                    └─────────────────────────────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            │                       │                       │
            ▼                       ▼                       ▼
   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
   │ PROFILE EDIT    │    │   ANALYTICS     │    │ ACHIEVEMENTS    │
   │    SCREEN       │    │    SCREEN       │    │    SCREEN       │
   │                 │    │                 │    │                 │
   │ - Avatar Upload │    │ - Performance   │    │ - Badge Gallery │
   │ - Basic Info    │    │   Trends        │    │ - Progress Bars │
   │ - Bio/About     │    │ - Test History  │    │ - Milestones    │
   │ - Sport Prefs   │    │   Charts        │    │ - Rare Badges   │
   │ - Privacy       │    │ - Comparison    │    │ - Social Share  │
   │ - Save/Cancel   │    │   Tools         │    │ - Challenges    │
   └─────────────────┘    │ - Export Data   │    └─────────────────┘
                          │ - Insights      │
                          └─────────────────┘
                                    │
                                    ▼
                          ┌─────────────────┐
                          │  TEST HISTORY   │
                          │    SCREEN       │
                          │                 │
                          │ - All Results   │
                          │ - Filter/Sort   │
                          │ - Performance   │
                          │   Graphs        │
                          │ - Export        │
                          │ - Compare       │
                          └─────────────────┘

Settings Branch:
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SETTINGS      │───▶│ NOTIFICATION    │    │  HELP/SUPPORT   │
│    SCREEN       │    │   SETTINGS      │    │    SCREEN       │
│                 │    │                 │    │                 │
│ - Notifications │    │ - Push Toggle   │    │ - FAQ Section   │
│ - Privacy       │    │ - Email Prefs   │    │ - Contact Us    │
│ - Data Export   │    │ - Sound/Vibrate │    │ - Bug Report    │
│ - App Info      │    │ - Quiet Hours   │    │ - Feature       │
│ - Terms         │    │ - Categories    │    │   Request       │
│ - Logout        │    │ - Save          │    │ - Tutorials     │
└─────────────────┘    └─────────────────┘    │ - App Guide     │
          │                                   │ - Version Info  │
          ▼                                   └─────────────────┘
┌─────────────────┐
│ LOGOUT CONFIRM  │
│     DIALOG      │
│                 │
│ - Confirm       │
│ - Cancel        │
│ - Data Warning  │
└─────────────────┘

Profile States:
• Authenticated → Full profile access
• Guest Mode → Limited features, conversion prompts
• Incomplete Profile → Setup wizard prompts
• Data Sync → Cloud backup/restore options
```

### 6. Complete App Connectivity Flow
```
                                    ┌─────────────┐
                                    │   SPLASH    │
                                    │   SCREEN    │
                                    │  (Entry)    │
                                    └──────┬──────┘
                                           │
                              ┌────────────┴────────────┐
                              │ First Time?             │
                              └────────┬────────────────┘
                                      │
                        ┌─────────────┴─────────────┐
                        │ Yes                   No  │
                        ▼                           ▼
                ┌──────────────┐           ┌──────────────┐
                │ ONBOARDING   │           │ Authenticated? │
                │ (3 Slides)   │           └─────┬────────┘
                └──────┬───────┘                 │
                       │                         │
                       ▼                   ┌─────┴─────┐
                ┌──────────────┐           │ Yes   No  │
                │     AUTH     │◀──────────┴──┐    │   │
                │   SCREEN     │              │    ▼   │
                └──────┬───────┘              │ ┌──────┴──┐
                       │                      │ │  AUTH   │
                       │ (Success)            │ │ SCREEN  │
                       ▼                      │ └─────────┘
        ┌──────────────────────────────────────┐    │
        │               HOME SCREEN             │◀───┘
        │            (Central Hub)              │
        └─────────┬────────────────────────────┘
                  │
       ┌──────────┼──────────┬─────────────────────┐
       │          │          │                     │
       ▼          ▼          ▼                     ▼
┌──────────┐ ┌──────────┐ ┌──────────┐     ┌──────────────┐
│ RESULTS  │ │COMMUNITY │ │ MENTORS  │     │   PROFILE    │
│ (History)│ │  SCREEN  │ │  SCREEN  │     │   SCREEN     │
└────┬─────┘ └──────────┘ └──────────┘     └──────┬───────┘
     │                                            │
     │          ┌──────────────┐                  │
     └─────────▶│ TEST RESULTS │                  │
                │   SCREEN     │                  │
                └──────────────┘                  │
                                                  │
┌─────────────────────────────────────────────────┼─────────────────┐
│                TEST FLOW                        │                 │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────┴──────┐          │
│  │   TEST   │→│CALIBRATE │→│RECORDING │→│ COMPLETION  │          │
│  │  DETAIL  │ │  SCREEN  │ │  SCREEN  │ │   SCREEN    │          │
│  └──────────┘ └──────────┘ └──────────┘ └─────┬───────┘          │
│                                               │                  │
│  ┌──────────────────────────────────────────────┘                │
│  │                                                               │
│  ▼                                                               │
│  ┌─────────────────┐    ┌──────────────────┐                    │
│  │ PERSONALIZED    │───▶│   RESULTS        │                    │
│  │   SOLUTION      │    │   SCREEN         │                    │
│  └─────────────────┘    └──────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
                                                                  │
┌─────────────────────────────────────────────────────────────────┘
│              FEATURE SCREENS
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│  │  STORE   │ │NUTRITION │ │ RECOVERY │ │BODY LOGS │
│  │  SCREEN  │ │  SCREEN  │ │  SCREEN  │ │  SCREEN  │
│  └────┬─────┘ └──────────┘ └──────────┘ └──────────┘
│       │
│       ▼
│  ┌─────────────────┐ ┌────────────────┐
│  │ PRODUCT DETAIL  │ │ NEARBY STORES  │
│  │    SCREEN       │ │    SCREEN      │
│  └─────────────────┘ └────────────────┘
│
│              PROFILE SUB-SCREENS
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│  │ PROFILE  │ │ANALYTICS │ │ACHIEVEMENTS│ │ SETTINGS │
│  │   EDIT   │ │  SCREEN  │ │  SCREEN    │ │  SCREEN  │
│  └──────────┘ └──────────┘ └──────────┘ └────┬─────┘
│                                              │
│                                              ▼
│                                        ┌──────────┐
│                                        │   HELP   │
│                                        │  SCREEN  │
│                                        └──────────┘
│
│              ADDITIONAL FEATURES
│  ┌──────────┐ ┌──────────┐ ┌──────────┐
│  │ AI CHAT  │ │LEADERBOARD│ │NOTIFICATIONS│
│  │  SCREEN  │ │  SCREEN   │ │   SYSTEM    │
│  └──────────┘ └───────────┘ └─────────────┘
└─────────────────────────────────────────────────

Navigation Rules & States:
═══════════════════════════════════════════════════
Bottom Navigation Visibility:
✅ Visible: Home, History, Community, Mentors, Profile
❌ Hidden: Auth flow, Test flow, Full-screen features

Back Button Behavior:
• Hardware Back: Previous screen or Home
• App Back: Contextual navigation
• Deep Back: Return to origin screen

Authentication States:
• Unauthenticated: Splash → Auth flow
• Authenticated: Splash → Home
• Session Expired: Current screen → Auth
• Logout: Any screen → Auth (preserve onboarding state)

Error Handling:
• Network Issues: Offline mode + sync later
• Screen Load Failure: Retry mechanism
• Critical Errors: Error boundary → Recovery options

Data Persistence:
• User Session: Secure storage
• Test Progress: Auto-save + recovery
• App State: Background/foreground handling
• Offline Queue: Sync when online

Performance Optimizations:
• Lazy Loading: Non-critical screens
• Preloading: Frequently accessed screens
• Caching: API responses and images
• Memory Management: Component cleanup
```

### Bottom Navigation Structure
```
┌─────────────────────────────────────────────────────────┐
│  [🏠 Home] [📊 Results] [💬 Community] [👥 Mentors] [👤 Profile] │
└─────────────────────────────────────────────────────────┘

Navigation Mapping:
- Home → HomeScreen
- Results → CombinedResultsScreen (History)
- Community → CommunityScreen
- Mentors → MentorScreen
- Profile → ProfileScreen
```

### Screen Hierarchy
```
Authentication Flow:
├── SplashScreen
├── OnboardingScreen
└── AuthScreen

Main App Flow:
├── HomeScreen (Bottom Nav)
├── Results/History (Bottom Nav)
├── CommunityScreen (Bottom Nav)
├── MentorScreen (Bottom Nav)
└── ProfileScreen (Bottom Nav)

Test Flow (Full Screen):
├── TestDetailScreen
├── CalibrationScreen
├── RecordingScreen
├── TestCompletionScreen
└── PersonalizedSolutionScreen

Feature Screens:
├── StoreScreen
├── NutritionScreen
├── RecoveryScreen
├── BodyLogsScreen
├── AIChatScreen
├── AchievementsScreen
├── AnalyticsScreen
├── SettingsScreen
└── HelpScreen
```

---

## 📱 SCREEN-BY-SCREEN IMPLEMENTATION

### 1. SplashScreen
**Purpose**: App initialization and branding
**Duration**: 2-3 seconds
**Components**:
- Gradient background (dark theme)
- App logo with glow effect
- Loading spinner
- Version number

**React Implementation**:
```typescript
export function SplashScreen({ onComplete }: { onComplete: () => void }) {
  useEffect(() => {
    const timer = setTimeout(onComplete, 2500);
    return () => clearTimeout(timer);
  }, [onComplete]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-purple-900 to-blue-900 flex items-center justify-center">
      {/* Logo and branding */}
    </div>
  );
}
```

**Flutter Implementation**:
```dart
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  void _initializeApp() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      context.go('/onboarding');
    }
  }
}
```

### 2. OnboardingScreen
**Purpose**: Introduce app features to new users
**Slides**: 3 interactive slides
**Components**:
- Slide indicators
- Swipeable content
- Skip button
- Get Started button

**Onboarding Content**:
1. **Slide 1**: "Assess Your Athletic Potential"
2. **Slide 2**: "AI-Powered Performance Analysis"  
3. **Slide 3**: "Join India's Largest Sports Community"

### 3. AuthScreen
**Purpose**: User authentication (login/signup)
**Methods**: Email/Password, Social Auth
**Components**:
- Email input field
- Password input field
- Login/Signup toggle
- Social auth buttons
- Forgot password link

**Validation Rules**:
- Email: RFC 5322 compliant
- Password: Min 8 chars, 1 uppercase, 1 number
- Real-time validation feedback

### 4. HomeScreen (Core Screen)
**Purpose**: Main dashboard and test access
**Layout Structure**:

```
┌─────────────────────────────────────┐
│ Header Section                      │
│ ├── Welcome message                 │
│ ├── Daily bonus button             │
│ └── Notification bell               │
├─────────────────────────────────────┤
│ Progress Card                       │
│ ├── Completion percentage           │
│ ├── Progress bar                    │
│ └── Tests completed count           │
├─────────────────────────────────────┤
│ Quick Access Cards                  │
│ ├── Mentors (purple glow)           │
│ ├── Community (blue glow)           │
│ ├── Nutrition (orange glow)         │
│ ├── Recovery (pink glow)            │
│ └── Body Logs (gray glow)           │
├─────────────────────────────────────┤
│ Tests Grid (2x3)                    │
│ ├── Vertical Jump                   │
│ ├── Shuttle Run                     │
│ ├── Sit-ups                         │
│ ├── Endurance Run                   │
│ ├── Height Measurement              │
│ └── Weight Measurement              │
├─────────────────────────────────────┤
│ Quick Stats                         │
│ ├── Tests Taken: 15                 │
│ ├── Ranking: Top 25%                │
│ └── Badges: 5                       │
└─────────────────────────────────────┘
```

**Key Components**:
- **Header**: Personalized greeting + daily bonus trigger
- **Progress Card**: Visual progress tracking
- **Quick Access Cards**: Feature shortcuts with neon glows
- **Test Cards**: Interactive test selection
- **Quick Stats**: Achievement summary

### 5. TestDetailScreen
**Purpose**: Test information and preparation
**Components**:
- Test description
- Requirements checklist
- Equipment needed
- Duration estimate
- Difficulty level
- Start test button

### 6. CalibrationScreen
**Purpose**: Camera/sensor setup before recording
**Components**:
- Camera preview
- Calibration markers
- Instructions overlay
- Device positioning guide
- Calibration confirmation

### 7. RecordingScreen
**Purpose**: Actual test recording
**Components**:
- Camera feed
- Recording controls
- Timer display
- Performance metrics (live)
- Stop/Retry buttons

### 8. TestCompletionScreen
**Purpose**: Post-test celebration and next steps
**Components**:
- Success animation
- Basic score preview
- Celebration confetti effect
- View detailed results button
- Share achievement option

### 9. PersonalizedSolutionScreen
**Purpose**: AI-generated recommendations
**Components**:
- Performance analysis
- Strengths/weaknesses breakdown
- Improvement recommendations
- Training plan suggestions
- Nutrition advice

### 10. CombinedResultsScreen (History)
**Purpose**: Test history and analytics
**Components**:
- Test result cards
- Performance trends
- Filter options
- Comparison tools
- Export options

---

## 🧩 CORE FEATURES & COMPONENTS

### 1. Test Cards System
**Test Types Available**:
1. **Vertical Jump** - Explosive power measurement
2. **Shuttle Run** - Agility assessment  
3. **Sit-ups** - Core strength test
4. **Endurance Run** - Cardiovascular fitness
5. **Height Measurement** - Physical attributes
6. **Weight Measurement** - Body composition

**Test Card States**:
- `not-started`: Gray state, "Start Test" button
- `in-progress`: Orange state, "Continue" button  
- `completed`: Green state, "View Results" button

**Test Card Props**:
```typescript
interface TestCardProps {
  title: string;
  description: string;
  icon: React.ReactNode;
  status: "not-started" | "in-progress" | "completed";
  onStartTest: () => void;
  duration?: number;
  difficulty?: "Easy" | "Medium" | "Hard";
}
```

### 2. Credit Points System
**Purpose**: Gamification and rewards
**Earning Methods**:
- Daily login: 10 points
- Test completion: 50 points
- Perfect scores: 100 bonus points
- Community participation: 25 points
- Referrals: 200 points

**Usage**:
- Store purchases
- Premium features unlock
- Leaderboard ranking

**Implementation**:
```typescript
interface CreditPointsState {
  currentPoints: number;
  totalEarned: number;
  recentTransactions: Transaction[];
}

interface Transaction {
  id: string;
  type: 'earned' | 'spent';
  amount: number;
  reason: string;
  timestamp: Date;
}
```

### 3. AI Chat Assistant
**Purpose**: Personalized guidance and support
**Features**:
- Contextual help during tests
- Performance analysis explanations
- Training recommendations
- Motivation and encouragement
- Technical support

**Context Types**:
- `general`: General assistance
- `test-help`: Test-specific guidance
- `nutrition`: Dietary advice
- `training`: Workout recommendations

### 4. Notification System
**Types**:
- **Test Reminders**: Scheduled test notifications
- **Achievement Unlocks**: Badge/milestone notifications
- **Community Updates**: New posts, events
- **System Alerts**: App updates, maintenance

**Implementation**:
```typescript
interface NotificationProps {
  id: string;
  type: 'reminder' | 'achievement' | 'community' | 'system';
  title: string;
  message: string;
  timestamp: Date;
  isRead: boolean;
  actionUrl?: string;
}
```

### 5. Store System
**Categories**:
- **Supplements**: Verified sports supplements
- **Equipment**: Fitness gear and accessories
- **Nutrition**: Meal plans and dietary guides
- **Apparel**: Sports clothing and footwear

**Product Features**:
- Credit points pricing
- User ratings/reviews
- Nearby store locator
- Wishlist functionality
- Purchase history

### 6. Community Features
**Components**:
- Discussion forums
- Achievement sharing
- Event calendar
- Athlete profiles
- Group challenges

**Post Types**:
- Text posts
- Image sharing
- Video highlights
- Achievement celebrations
- Question/Answer format

### 7. Mentor System
**Mentor Categories**:
- **Fitness Trainers**: General fitness coaching
- **Sport Specialists**: Sport-specific training
- **Nutritionists**: Dietary guidance
- **Physiotherapists**: Injury prevention

**Interaction Methods**:
- Video consultations
- Chat messaging
- Training plan sharing
- Progress reviews

---

## 🗄️ DATA MODELS & BACKEND INTEGRATION

### Supabase Database Schema

#### Users Table
```sql
create table users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  display_name text,
  avatar_url text,
  phone_number text,
  date_of_birth date,
  gender text check (gender in ('male', 'female', 'other')),
  height_cm integer,
  weight_kg decimal(5,2),
  sport_interests text[],
  fitness_level text check (fitness_level in ('beginner', 'intermediate', 'advanced')),
  location jsonb,
  credit_points integer default 0,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);
```

#### Tests Table
```sql
create table tests (
  id text primary key,
  name text not null,
  description text,
  instructions text,
  duration_seconds integer,
  difficulty text check (difficulty in ('easy', 'medium', 'hard')),
  category text,
  equipment_needed text[],
  scoring_method text,
  is_active boolean default true,
  created_at timestamp with time zone default now()
);
```

#### Test Results Table
```sql
create table test_results (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  test_id text references tests(id),
  score decimal(10,2),
  raw_data jsonb,
  video_url text,
  completed_at timestamp with time zone default now(),
  ai_analysis jsonb,
  percentile_rank decimal(5,2)
);
```

#### Credit Transactions Table
```sql
create table credit_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  amount integer not null,
  transaction_type text check (transaction_type in ('earned', 'spent')),
  reason text not null,
  reference_id text,
  created_at timestamp with time zone default now()
);
```

### API Endpoints

#### Authentication
```typescript
// Supabase Auth endpoints
POST /auth/v1/signup
POST /auth/v1/token?grant_type=password
POST /auth/v1/logout
GET /auth/v1/user
```

#### Tests API
```typescript
// Test management
GET /rest/v1/tests
GET /rest/v1/test_results?user_id=eq.{userId}
POST /rest/v1/test_results
PUT /rest/v1/test_results?id=eq.{resultId}
```

#### User Profile
```typescript
// Profile management
GET /rest/v1/users?id=eq.{userId}
PATCH /rest/v1/users?id=eq.{userId}
```

#### Credit Points
```typescript
// Points system
GET /rest/v1/credit_transactions?user_id=eq.{userId}
POST /rest/v1/credit_transactions
```

---

## 🎛️ UI COMPONENTS LIBRARY

### Core Components

#### 1. GlassCard Component
```typescript
interface GlassCardProps {
  children: React.ReactNode;
  className?: string;
  onClick?: () => void;
  glowColor?: 'purple' | 'blue' | 'green' | 'orange' | 'pink';
}

const GlassCard: React.FC<GlassCardProps> = ({ 
  children, 
  className, 
  onClick, 
  glowColor 
}) => {
  const glowClasses = {
    purple: 'neon-glow',
    blue: 'neon-glow-blue',
    green: 'neon-glow-green',
    orange: 'neon-glow-orange',
    pink: 'neon-glow-pink'
  };

  return (
    <div 
      className={cn(
        'glass-card rounded-3xl p-6 transition-all duration-300',
        glowColor && glowClasses[glowColor],
        onClick && 'cursor-pointer hover:scale-105',
        className
      )}
      onClick={onClick}
    >
      {children}
    </div>
  );
};
```

#### 2. NeonButton Component
```typescript
interface NeonButtonProps {
  children: React.ReactNode;
  variant: 'primary' | 'secondary' | 'outline';
  size: 'sm' | 'md' | 'lg';
  onClick?: () => void;
  disabled?: boolean;
  loading?: boolean;
}

const NeonButton: React.FC<NeonButtonProps> = ({
  children,
  variant,
  size,
  onClick,
  disabled,
  loading
}) => {
  const variants = {
    primary: 'bg-gradient-to-r from-purple-600 to-blue-600 text-white neon-glow',
    secondary: 'bg-gradient-to-r from-blue-600 to-green-600 text-white neon-glow-blue',
    outline: 'border-2 border-purple-500 text-purple-400 hover:bg-purple-500/20'
  };

  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  };

  return (
    <button
      className={cn(
        'rounded-xl font-medium transition-all duration-300',
        'hover:scale-105 active:scale-95',
        'disabled:opacity-50 disabled:cursor-not-allowed',
        variants[variant],
        sizes[size]
      )}
      onClick={onClick}
      disabled={disabled || loading}
    >
      {loading ? <Spinner /> : children}
    </button>
  );
};
```

#### 3. TestCard Component
```typescript
const TestCard: React.FC<TestCardProps> = ({
  title,
  description,
  icon,
  status,
  onStartTest
}) => {
  const statusConfig = {
    "not-started": {
      badge: "Not Started",
      badgeClass: "bg-gray-500/20 text-gray-400",
      buttonText: "Start Test"
    },
    "in-progress": {
      badge: "In Progress", 
      badgeClass: "bg-orange-500/20 text-orange-400",
      buttonText: "Continue"
    },
    "completed": {
      badge: "Completed",
      badgeClass: "bg-green-500/20 text-green-400", 
      buttonText: "View Results"
    }
  };

  return (
    <GlassCard className="hover:border-purple-500/30">
      <div className="flex items-center justify-between mb-4">
        <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-purple-500 to-blue-500 flex items-center justify-center">
          {icon}
        </div>
        <Badge className={statusConfig[status].badgeClass}>
          {statusConfig[status].badge}
        </Badge>
      </div>
      
      <h3 className="text-xl font-semibold text-white mb-2">{title}</h3>
      <p className="text-gray-400 text-sm mb-6">{description}</p>
      
      <NeonButton 
        variant="primary" 
        size="md" 
        onClick={onStartTest}
        className="w-full"
      >
        {statusConfig[status].buttonText}
      </NeonButton>
    </GlassCard>
  );
};
```

#### 4. MetricChip Component
```typescript
interface MetricChipProps {
  label: string;
  value: string | number;
  color: 'purple' | 'blue' | 'green' | 'orange' | 'red';
  size?: 'sm' | 'md';
}

const MetricChip: React.FC<MetricChipProps> = ({
  label,
  value,
  color,
  size = 'md'
}) => {
  const colorClasses = {
    purple: 'text-purple-400',
    blue: 'text-blue-400', 
    green: 'text-green-400',
    orange: 'text-orange-400',
    red: 'text-red-400'
  };

  return (
    <div className="glass-card p-4 text-center">
      <div className={cn(
        'font-bold mb-1',
        size === 'sm' ? 'text-lg' : 'text-2xl',
        colorClasses[color]
      )}>
        {value}
      </div>
      <div className="text-xs text-gray-400">{label}</div>
    </div>
  );
};
```

#### 5. ProgressBar Component
```typescript
interface ProgressBarProps {
  value: number;
  max: number;
  showPercentage?: boolean;
  color?: 'purple' | 'blue' | 'green';
  animated?: boolean;
}

const ProgressBar: React.FC<ProgressBarProps> = ({
  value,
  max,
  showPercentage = true,
  color = 'purple',
  animated = true
}) => {
  const percentage = Math.min((value / max) * 100, 100);
  
  const colorClasses = {
    purple: 'from-purple-500 to-blue-500',
    blue: 'from-blue-500 to-cyan-500',
    green: 'from-green-500 to-emerald-500'
  };

  return (
    <div className="w-full">
      {showPercentage && (
        <div className="flex justify-between text-sm text-gray-400 mb-2">
          <span>{value} of {max}</span>
          <span>{Math.round(percentage)}%</span>
        </div>
      )}
      
      <div className="w-full bg-gray-700/50 rounded-full h-3 overflow-hidden">
        <div
          className={cn(
            'h-full rounded-full transition-all duration-1000 ease-out',
            `bg-gradient-to-r ${colorClasses[color]}`,
            animated && 'neon-glow'
          )}
          style={{ width: `${percentage}%` }}
        />
      </div>
    </div>
  );
};
```

### Shadcn/ui Integration
The app utilizes shadcn/ui components for consistent design:

**Available Components**:
- `Button`, `Card`, `Badge`, `Input`, `Dialog`
- `Tabs`, `Sheet`, `Popover`, `Tooltip`, `Alert`
- `Progress`, `Switch`, `Slider`, `Calendar`
- `Table`, `Form`, `Select`, `Textarea`

**Customization**:
All shadcn components are themed with our custom color palette and glassmorphism effects through CSS variables in `globals.css`.

---

## ⚡ STATE MANAGEMENT

### React Context Pattern

#### 1. AuthContext
```typescript
interface AuthState {
  user: User | null;
  loading: boolean;
  error: string | null;
}

interface AuthContextType extends AuthState {
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string, profile: Partial<UserProfile>) => Promise<void>;
  signOut: () => Promise<void>;
  updateProfile: (updates: Partial<UserProfile>) => Promise<void>;
}

const AuthContext = createContext<AuthContextType | null>(null);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [state, setState] = useState<AuthState>({
    user: null,
    loading: true,
    error: null
  });

  // Auth methods implementation
  const signIn = async (email: string, password: string) => {
    try {
      setState(prev => ({ ...prev, loading: true, error: null }));
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      });
      
      if (error) throw error;
      setState(prev => ({ ...prev, user: data.user, loading: false }));
    } catch (error) {
      setState(prev => ({ 
        ...prev, 
        error: error.message, 
        loading: false 
      }));
    }
  };

  return (
    <AuthContext.Provider value={{
      ...state,
      signIn,
      signUp,
      signOut,
      updateProfile
    }}>
      {children}
    </AuthContext.Provider>
  );
};
```

#### 2. CreditPointsContext
```typescript
interface CreditPointsState {
  currentPoints: number;
  transactions: CreditTransaction[];
  loading: boolean;
}

interface CreditPointsContextType extends CreditPointsState {
  awardPoints: (amount: number, reason: string) => Promise<void>;
  spendPoints: (amount: number, reason: string) => Promise<boolean>;
  refreshPoints: () => Promise<void>;
}

export const CreditPointsProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [state, setState] = useState<CreditPointsState>({
    currentPoints: 0,
    transactions: [],
    loading: false
  });

  const awardPoints = async (amount: number, reason: string) => {
    try {
      const { data, error } = await supabase
        .from('credit_transactions')
        .insert({
          user_id: user?.id,
          amount,
          transaction_type: 'earned',
          reason
        })
        .select()
        .single();

      if (error) throw error;

      setState(prev => ({
        ...prev,
        currentPoints: prev.currentPoints + amount,
        transactions: [data, ...prev.transactions]
      }));
    } catch (error) {
      console.error('Error awarding points:', error);
    }
  };

  return (
    <CreditPointsContext.Provider value={{
      ...state,
      awardPoints,
      spendPoints,
      refreshPoints
    }}>
      {children}
    </CreditPointsContext.Provider>
  );
};
```

### Flutter Riverpod Pattern

#### 1. Auth Provider
```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.loading();
  }

  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      }
    } catch (error) {
      state = AuthState.error(error.toString());
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    state = const AuthState.unauthenticated();
  }
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}
```

#### 2. Test Results Provider
```dart
@riverpod
class TestResultsNotifier extends _$TestResultsNotifier {
  @override
  Future<List<TestResult>> build() async {
    return _fetchTestResults();
  }

  Future<List<TestResult>> _fetchTestResults() async {
    final user = ref.read(authProvider).value;
    if (user == null) return [];

    final response = await Supabase.instance.client
        .from('test_results')
        .select()
        .eq('user_id', user.id)
        .order('completed_at', ascending: false);

    return response.map((json) => TestResult.fromJson(json)).toList();
  }

  Future<void> addResult(TestResult result) async {
    await Supabase.instance.client
        .from('test_results')
        .insert(result.toJson());
    
    // Refresh the list
    ref.invalidateSelf();
  }
}
```

---

## 🎯 CRITICAL UI ELEMENT SPECIFICATIONS FOR PIXEL-PERFECT ACCURACY

### 📋 Bottom Navigation Implementation (EXACT React BottomNavigationBar)
```dart
// MUST match React implementation exactly
BottomNavigationBar(
  type: BottomNavigationBarType.fixed,           // Fixed type for 5 items
  backgroundColor: AppColors.deepCharcoal,       // #121212 exact
  selectedItemColor: AppColors.royalPurple,      // #6A0DAD when selected
  unselectedItemColor: AppColors.textSecondary,  // rgba(255,255,255,0.7)
  selectedFontSize: 12.0,                        // text-xs
  unselectedFontSize: 12.0,                      // text-xs
  iconSize: 24.0,                                // w-6 h-6 (24px)
  elevation: 0,                                  // No shadow
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_rounded),
      label: 'Results',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_rounded),
      label: 'Community',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school_rounded),
      label: 'Mentors',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ],
)
```

### 🏠 HomeScreen Grid Layout (EXACT React Implementation)
```dart
// Test cards grid - MUST be 2x3 layout exactly like React
GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,              // 2 columns EXACT
    crossAxisSpacing: 12.0,         // gap-3 EXACT
    mainAxisSpacing: 12.0,          // gap-3 EXACT  
    childAspectRatio: 0.85,         // Height > Width EXACT
  ),
  itemCount: 6,                     // Exactly 6 test cards
  itemBuilder: (context, index) {
    final tests = [
      {'id': 'vertical-jump', 'title': 'Vertical Jump', 'icon': Icons.arrow_upward},
      {'id': 'shuttle-run', 'title': 'Shuttle Run', 'icon': Icons.directions_run},
      {'id': 'sit-ups', 'title': 'Sit-ups', 'icon': Icons.fitness_center},
      {'id': 'endurance', 'title': 'Endurance', 'icon': Icons.timer},
      {'id': 'height', 'title': 'Height', 'icon': Icons.height},
      {'id': 'weight', 'title': 'Weight', 'icon': Icons.monitor_weight},
    ];
    return TestCard(test: tests[index]);
  },
)
```

### 🎴 Quick Access Cards (EXACT React Horizontal Scroll)
```dart
// Quick access cards - horizontal scroll exactly like React
SizedBox(
  height: 140.0,                    // Fixed height
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    itemCount: 5,                   // Exactly 5 cards
    itemBuilder: (context, index) {
      final cards = [
        {'title': 'Mentors', 'color': AppColors.royalPurple, 'icon': Icons.school},
        {'title': 'Community', 'color': AppColors.electricBlue, 'icon': Icons.chat_bubble}, 
        {'title': 'Nutrition', 'color': AppColors.warmOrange, 'icon': Icons.restaurant},
        {'title': 'Recovery', 'color': Color(0xFFEC4899), 'icon': Icons.spa},
        {'title': 'Body Logs', 'color': Color(0xFF9CA3AF), 'icon': Icons.track_changes},
      ];
      return Container(
        width: 120.0,                // Fixed width EXACT
        margin: const EdgeInsets.only(right: 12.0), // gap-3 spacing
        child: QuickAccessCard(card: cards[index]),
      );
    },
  ),
)
```

### 📊 Progress Card (EXACT React Layout)
```dart
// Progress card with animated progress bar exactly like React
Container(
  height: 120.0,                    // Fixed height EXACT
  margin: const EdgeInsets.symmetric(horizontal: 20.0),
  child: GlassCard(
    padding: const EdgeInsets.all(20.0), // p-5 EXACT
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Test Progress',
              style: AppTypography.h3,  // text-lg font-medium
            ),
            Text(
              '4/6 Complete',           // Dynamic progress text
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),   // Space before progress bar
        Container(
          height: 8.0,                  // h-2 EXACT
          decoration: BoxDecoration(
            color: AppColors.muted,     // Background color
            borderRadius: BorderRadius.circular(4.0), // rounded EXACT
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.67,          // 4/6 = 67% progress
            child: Container(
              decoration: BoxDecoration(
                gradient: AppGradients.purpleBlue, // Gradient fill
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
)
```

---

## 🚨 MANDATORY FLUTTER IMPLEMENTATION REQUIREMENTS

**CRITICAL INSTRUCTION FOR AI IMPLEMENTATION:**
- **ONLY USE FLUTTER/DART** - Do not implement any React/TypeScript code
- **Follow this documentation exactly** for Flutter implementation
- **Use the provided Flutter project structure** and dependencies
- **Implement all features using Flutter widgets and packages**
- **Use Riverpod for state management** (not React Context)
- **Use GoRouter for navigation** (not React Router)
- **Use Material Design 3** with custom glassmorphism effects
- **All code examples below are Flutter/Dart ready for implementation**

---

## 📱 COMPLETE FLUTTER IMPLEMENTATION GUIDE

### 🗂️ Complete Flutter Project Structure

**EXACT Directory Structure for AI Implementation**:
```
sports_assessment_app/
├── pubspec.yaml                          # Dependencies & configuration
├── analysis_options.yaml                # Dart analyzer settings
├── android/                             # Android platform files
│   ├── app/
│   │   ├── build.gradle                # Android build config
│   │   └── src/main/
│   │       ├── AndroidManifest.xml     # Permissions & config
│   │       └── kotlin/                 # Native Android code
├── ios/                                 # iOS platform files
│   ├── Runner/
│   │   ├── Info.plist                  # iOS permissions & config
│   │   └── AppDelegate.swift           # iOS app delegate
├── assets/                              # Static assets
│   ├── images/                         # App images & photos
│   │   ├── splash_logo.png
│   │   ├── app_mascot.png
│   │   ├── onboarding_1.png
│   │   ├── onboarding_2.png
│   │   └── onboarding_3.png
│   ├── icons/                          # App icons & SVG assets
│   │   ├── app_icon.png
│   │   ├── app_icon_foreground.png
│   │   └── menu_icons/
│   ├── animations/                     # Lottie animations
│   │   ├── success_celebration.json
│   │   ├── loading_spinner.json
│   │   └── test_completion.json
│   └── fonts/                          # Custom fonts
│       ├── Inter-Regular.ttf
│       ├── Inter-Medium.ttf
│       ├── Inter-SemiBold.ttf
│       └── Inter-Bold.ttf
├── lib/
│   ├── main.dart                       # App entry point & initialization
│   ├── core/                           # Core app functionality
│   │   ├── config/
│   │   │   ├── app_config.dart         # Environment & API configs
│   │   │   └── constants.dart          # App-wide constants
│   │   ├── theme/
│   │   │   ├── app_theme.dart          # Material Theme configuration
│   │   │   ├── app_colors.dart         # Color palette & glassmorphism
│   │   │   └── text_styles.dart        # Typography system
│   │   ├── router/
│   │   │   ├── app_router.dart         # GoRouter configuration
│   │   │   └── route_names.dart        # Route constants
│   │   ├── providers/                  # Global Riverpod providers
│   │   │   ├── app_providers.dart      # Provider exports
│   │   │   ├── auth_provider.dart      # Authentication state
│   │   │   ├── credit_points_provider.dart # Points system
│   │   │   ├── notification_provider.dart  # Notifications
│   │   │   ├── test_provider.dart      # Test management
│   │   │   └── user_provider.dart      # User profile state
│   │   ├── services/                   # External service integrations
│   │   │   ├── auth_service.dart       # Supabase auth wrapper
│   │   │   ├── supabase_service.dart   # Database operations
│   │   │   ├── notification_service.dart # Push notifications
│   │   │   ├── camera_service.dart     # Camera operations
│   │   │   └── location_service.dart   # GPS & location
│   │   └── utils/                      # Utility functions
│   │       ├── error_handler.dart      # Error management
│   │       ├── validators.dart         # Form validation
│   │       ├── formatters.dart         # Data formatting
│   │       └── extensions.dart         # Dart extensions
│   ├── features/                       # Feature-based modules
│   │   ├── auth/                       # Authentication feature
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_model.dart          # User data model
│   │   │   │   │   └── auth_state_model.dart    # Auth state model
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart     # Auth data layer
│   │   │   │   └── datasources/
│   │   │   │       └── auth_remote_datasource.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── splash_screen.dart       # App initialization
│   │   │       │   ├── onboarding_screen.dart   # 3-slide onboarding
│   │   │       │   └── auth_screen.dart         # Login/signup
│   │   │       └── widgets/
│   │   │           ├── auth_form.dart           # Login/signup form
│   │   │           └── onboarding_slide.dart    # Individual slide
│   │   ├── home/                       # Home screen feature
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── home_screen.dart         # Main dashboard
│   │   │       └── widgets/
│   │   │           ├── test_card.dart           # Test selection card
│   │   │           ├── progress_card.dart       # Progress tracking
│   │   │           ├── quick_access_card.dart   # Feature shortcuts
│   │   │           ├── daily_login_bonus.dart   # Daily bonus modal
│   │   │           └── quick_stats_section.dart # Stats overview
│   │   ├── test/                       # Test assessment feature
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── test_model.dart          # Test configuration
│   │   │   │   │   └── test_result_model.dart   # Test results
│   │   │   │   └── repositories/
│   │   │   │       └── test_repository.dart     # Test data operations
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── test_detail_screen.dart  # Test information
│   │   │           ├── calibration_screen.dart  # Camera setup
│   │   │           ├── recording_screen.dart    # Test recording
│   │   │           └── test_completion_screen.dart # Success screen
│   │   ├── results/                    # Results & analytics
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── results_screen.dart      # Individual results
│   │   │           └── combined_results_screen.dart # History view
│   │   ├── personalized_solution/      # AI recommendations
│   │   │   ├── data/
│   │   │   │   └── models/
│   │   │   │       └── personalized_solution_model.dart
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── personalized_solution_screen.dart
│   │   ├── profile/                    # User profile management
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── profile_screen.dart      # Profile overview
│   │   │           └── profile_edit_screen.dart # Edit profile
│   │   ├── community/                  # Social features
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── community_screen.dart    # Community hub
│   │   ├── mentors/                    # Mentor system
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── mentor_screen.dart       # Mentor marketplace
│   │   ├── store/                      # E-commerce features
│   │   │   ├── data/
│   │   │   │   └── models/
│   │   │   │       ├── product_model.dart       # Product data
│   │   │   │       └── physical_store_model.dart # Store locations
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── store_screen.dart        # Product catalog
│   │   │           ├── product_detail_screen.dart # Product details
│   │   │           └── nearby_stores_screen.dart # Store locator
│   │   ├── nutrition/                  # Nutrition features
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── nutrition_screen.dart    # Nutrition planning
│   │   ├── recovery/                   # Recovery features
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── recovery_screen.dart     # Recovery planning
│   │   ├── body_logs/                  # Body tracking
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── body_logs_screen.dart    # Progress tracking
│   │   ├── ai_chat/                    # AI assistant
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── ai_chat_screen.dart      # Chat interface
│   │   ├── achievements/               # Gamification
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── achievements_screen.dart # Badge system
│   │   ├── analytics/                  # Performance analytics
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── analytics_screen.dart    # Data visualization
│   │   ├── leaderboard/                # Rankings
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── leaderboard_screen.dart  # Global rankings
│   │   ├── settings/                   # App settings
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── settings_screen.dart     # User preferences
│   │   ├── help/                       # Support system
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── help_screen.dart         # Help & support
│   │   └── credits/                    # Credit point system
│   │       ├── data/
│   │       │   └── models/
│   │       │       └── credit_points_model.dart # Points model
│   │       └── presentation/
│   │           └── screens/
│   │               └── credits_screen.dart      # Points management
│   └── shared/                         # Shared UI components
│       └── presentation/
│           └── widgets/
│               ├── glass_card.dart              # Glassmorphism container
│               ├── neon_button.dart             # Glowing buttons
│               ├── main_layout.dart             # Base screen layout
│               ├── notification_system.dart     # Global notifications
│               ├── pull_to_refresh.dart         # Pull to refresh
│               ├── loading_indicator.dart       # Loading states
│               ├── error_widget.dart            # Error displays
│               ├── empty_state.dart             # Empty state UI
│               └── bottom_navigation_bar.dart   # Navigation bar
└── test/                               # Test files
    ├── unit/                           # Unit tests
    ├── widget/                         # Widget tests
    └── integration/                    # Integration tests
```

### Core App Setup

#### 🚀 Complete main.dart Implementation
**Copy this EXACT code for AI implementation**:
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/error_handler.dart';

void main() async {
  // Ensure Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    debug: AppConfig.enableLogging,
  );
  
  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    ErrorHandler.handleFlutterError(details);
  };
  
  runApp(const ProviderScope(child: SportsAssessmentApp()));
}

class SportsAssessmentApp extends ConsumerWidget {
  const SportsAssessmentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Always dark theme as per requirements
      
      // Router configuration
      routerConfig: AppRouter.router,
      
      // Global gesture handling
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: child,
        );
      },
      
      // Error handling
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        );
      },
    );
  }
}

// Global error screen
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.brightRed,
              ),
              SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please restart the app',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Theme Configuration
```dart
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.royalPurple,
        secondary: AppColors.electricBlue,
        tertiary: AppColors.neonGreen,
        background: AppColors.deepCharcoal,
        surface: AppColors.card,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
```

#### Router Setup
```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const CombinedResultsScreen(),
          ),
          // ... other routes
        ],
      ),
    ],
  );
}
```

### 🎯 PIXEL-PERFECT SCREEN LAYOUT SPECIFICATIONS

**CRITICAL: These specifications must be followed EXACTLY for pixel-perfect parity**

#### 📱 HomeScreen Layout (EXACT React Implementation)
```dart
// EXACT layout structure from React HomeScreen component
class HomeScreenLayout {
  // Screen structure (top to bottom):
  // 1. Status bar space (safe area)
  // 2. Header section (greeting + daily bonus)
  // 3. Progress card
  // 4. Quick access cards (horizontal scroll)
  // 5. Test cards grid (2x3)
  // 6. Quick stats section
  // 7. Bottom navigation space
  
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20.0);
  static const double sectionSpacing = 24.0;           // Space between major sections
  static const double headerHeight = 60.0;            // Header with greeting
  static const double progressCardHeight = 120.0;     // Progress tracking card
  static const double quickAccessHeight = 140.0;      // Quick access cards section
  static const double testGridHeight = 400.0;         // Test cards grid (calculated)
  static const double quickStatsHeight = 80.0;        // Bottom stats section
  
  // Quick access cards (horizontal scroll)
  static const double quickAccessCardWidth = 120.0;
  static const double quickAccessCardHeight = 100.0;
  static const double quickAccessCardSpacing = 12.0;
  
  // Test cards grid
  static const double testCardSpacing = 12.0;         // gap-3 from React
  static const int testGridColumns = 2;
  static const int testGridRows = 3;
  static const double testCardAspectRatio = 0.85;     // Width:Height ratio
}

// 🧩 EXACT COMPONENT DIMENSIONS FROM REACT
class ReactComponentDimensions {
  // TestCard component exact dimensions
  static const Size testCardSize = Size(160.0, 185.0);        // Calculated from React grid
  static const double testCardIconSize = 48.0;                // Icon container 12x12 (48px)
  static const EdgeInsets testCardPadding = EdgeInsets.all(16.0); // p-4
  static const double testCardBorderRadius = 24.0;            // rounded-2xl
  
  // ProgressCard component exact dimensions  
  static const Size progressCardSize = Size(double.infinity, 120.0);
  static const double progressBarHeight = 8.0;                // h-2
  static const double progressBarRadius = 4.0;                // rounded
  static const EdgeInsets progressCardPadding = EdgeInsets.all(20.0); // p-5
  
  // QuickAccessCard component exact dimensions
  static const Size quickAccessCardSize = Size(120.0, 100.0);
  static const double quickAccessIconSize = 32.0;             // Icon 8x8 (32px)
  static const EdgeInsets quickAccessCardPadding = EdgeInsets.all(12.0); // p-3
  static const double quickAccessCardBorderRadius = 16.0;     // rounded-xl
  
  // NeonButton component exact dimensions
  static const Map<String, Size> neonButtonSizes = {
    'sm': Size(120.0, 36.0),    // Small button
    'md': Size(160.0, 44.0),    // Medium button (default)
    'lg': Size(200.0, 52.0),    // Large button
  };
  
  // DailyLoginBonus modal exact dimensions
  static const Size dailyBonusModalSize = Size(320.0, 400.0);
  static const double dailyBonusIconSize = 64.0;              // Large celebration icon
  static const EdgeInsets dailyBonusModalPadding = EdgeInsets.all(24.0); // p-6
  
  // Bottom Navigation exact dimensions
  static const double bottomNavHeight = 80.0;                 // Fixed height
  static const double bottomNavIconSize = 24.0;               // Icon size
  static const double bottomNavLabelFontSize = 12.0;          // Label text size
  
  // Status chips and badges
  static const double statusChipHeight = 24.0;                // Badge height
  static const EdgeInsets statusChipPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
  static const double statusChipBorderRadius = 12.0;          // Pill shape
  
  // Avatar sizes (consistent throughout app)
  static const Map<String, double> avatarSizes = {
    'xs': 24.0,    // Extra small
    'sm': 32.0,    // Small  
    'md': 48.0,    // Medium (default)
    'lg': 64.0,    // Large
    'xl': 96.0,    // Extra large (profile screen)
  };
}

// 🎨 EXACT COLOR USAGE MAP FROM REACT COMPONENTS
class ReactColorMapping {  
  // TestCard status colors (exact mapping from React)
  static const Map<String, Color> testStatusColors = {
    'not-started': Color(0xFF9CA3AF),      // Gray - text-gray-400
    'in-progress': AppColors.warmOrange,   // Orange - text-orange-400  
    'completed': AppColors.neonGreen,      // Green - text-green-400
  };
  
  // QuickAccessCard neon glow colors (exact from React)  
  static const Map<String, List<BoxShadow>> quickAccessGlows = {
    'mentors': AppColors.neonGlowPurple,   // Purple glow
    'community': AppColors.neonGlowBlue,   // Blue glow
    'nutrition': AppColors.neonGlowOrange, // Orange glow
    'recovery': AppColors.neonGlowPink,    // Pink glow
    'body-logs': AppColors.neonGlowGray,   // Gray glow
  };
  
  // Progress bar colors (exact gradient from React)
  static const Gradient progressBarGradient = LinearGradient(
    colors: [AppColors.royalPurple, AppColors.electricBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Button color variants (exact from NeonButton component)
  static const Map<String, Color> buttonColors = {
    'primary': AppColors.royalPurple,      // Primary actions
    'secondary': AppColors.electricBlue,   // Secondary actions
    'success': AppColors.neonGreen,        // Success states
    'warning': AppColors.warmOrange,       // Warning states
    'danger': AppColors.brightRed,         // Danger states
  };
}

### 🧩 Complete Flutter Widget Implementations

#### 1. GlassCard Widget (EXACT React Parity)
**Complete glass_card.dart Implementation**:
```dart
// lib/shared/presentation/widgets/glass_card.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool enableNeonGlow;
  final Color? neonGlowColor;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.enableNeonGlow = false,
    this.neonGlowColor,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: AppColors.glassmorphismDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        enableNeonGlow: enableNeonGlow,
        neonGlowColor: neonGlowColor,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          splashColor: AppColors.royalPurple.withOpacity(0.1),
          highlightColor: AppColors.royalPurple.withOpacity(0.05),
          child: content,
        ),
      );
    }

    return content;
  }
}

// Interactive Glass Card with hover effects
class InteractiveGlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool enableNeonGlow;
  final Color? neonGlowColor;

  const InteractiveGlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.enableNeonGlow = false,
    this.neonGlowColor,
  });

  @override
  State<InteractiveGlassCard> createState() => _InteractiveGlassCardState();
}

class _InteractiveGlassCardState extends State<InteractiveGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding ?? const EdgeInsets.all(20),
              decoration: AppColors.glassmorphismDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(24),
                enableNeonGlow: widget.enableNeonGlow,
                neonGlowColor: widget.neonGlowColor,
              ).copyWith(
                boxShadow: widget.enableNeonGlow && widget.neonGlowColor != null
                    ? AppColors.neonGlowPurple.map((shadow) => BoxShadow(
                        color: shadow.color.withOpacity(
                          shadow.color.opacity * _glowAnimation.value,
                        ),
                        blurRadius: shadow.blurRadius * _glowAnimation.value,
                        spreadRadius: shadow.spreadRadius,
                        offset: shadow.offset,
                      )).toList()
                    : null,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

#### NeonButton Widget
```dart
class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final NeonButtonVariant variant;
  final NeonButtonSize size;
  final bool isLoading;

  const NeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = NeonButtonVariant.primary,
    this.size = NeonButtonSize.medium,
    this.isLoading = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: _getPadding(),
              decoration: _getDecoration(),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.text,
                        style: _getTextStyle(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case NeonButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case NeonButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case NeonButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  BoxDecoration _getDecoration() {
    switch (widget.variant) {
      case NeonButtonVariant.primary:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.royalPurple, AppColors.electricBlue],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.neonGlowPurple,
        );
      case NeonButtonVariant.secondary:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.electricBlue, AppColors.neonGreen],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.neonGlowBlue,
        );
      case NeonButtonVariant.outline:
        return BoxDecoration(
          border: Border.all(color: AppColors.royalPurple, width: 2),
          borderRadius: BorderRadius.circular(16),
        );
    }
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      color: widget.variant == NeonButtonVariant.outline
          ? AppColors.royalPurple
          : Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: _getFontSize(),
    );
  }

  double _getFontSize() {
    switch (widget.size) {
      case NeonButtonSize.small:
        return 14;
      case NeonButtonSize.medium:
        return 16;
      case NeonButtonSize.large:
        return 18;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum NeonButtonVariant { primary, secondary, outline }
enum NeonButtonSize { small, medium, large }
```

### Screen Implementation Example

#### HomeScreen Flutter
```dart
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final userName = user?.displayName ?? 'Athlete';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(userName),
                      _buildProgressCard(),
                      _buildQuickAccessCards(),
                      _buildTestsGrid(),
                      _buildQuickStats(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ready to assess your performance?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildDailyBonusButton(),
        ],
      ),
    );
  }

  Widget _buildDailyBonusButton() {
    return GestureDetector(
      onTap: _showDailyBonusDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x33FFC107),
          border: Border.all(color: const Color(0x4DFFC107)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          '🎁 Test Bonus',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFFFFC107),
          ),
        ),
      ),
    );
  }

  // ... other build methods

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // Refresh data
  }

  void _showDailyBonusDialog() {
    // Show daily bonus dialog
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

### 🎯 COMPLETE FLUTTER APP IMPLEMENTATION CHECKLIST

**FOR AI IMPLEMENTATION - FOLLOW THIS EXACT ORDER:**

1. **Initialize Flutter Project**
   ```bash
   flutter create sports_assessment_app
   cd sports_assessment_app
   ```

2. **Copy Exact pubspec.yaml** (from documentation above)

3. **Create Exact Directory Structure** (as specified above)

4. **Implement Core Files in This Order:**
   - `lib/core/theme/app_colors.dart` (complete color system)
   - `lib/core/theme/app_theme.dart` (Material theme configuration)
   - `lib/core/config/app_config.dart` (environment setup)
   - `lib/core/router/app_router.dart` (navigation system)
   - `lib/core/providers/` (all Riverpod providers)

5. **Implement Shared Widgets:**
   - `lib/shared/presentation/widgets/glass_card.dart`
   - `lib/shared/presentation/widgets/neon_button.dart`
   - `lib/shared/presentation/widgets/main_layout.dart`

6. **Implement Features (Priority Order):**
   - Authentication (splash, onboarding, auth screens)
   - Home screen with all components
   - Test flow (detail, calibration, recording, completion)
   - Results and analytics
   - Profile and settings
   - Store and community features

7. **Integration & Testing:**
   - Supabase configuration
   - Camera functionality
   - Notifications
   - Offline support

### 🚨 CRITICAL FLUTTER IMPLEMENTATION NOTES:

- **ONLY use Flutter/Dart** - no React/TypeScript code
- **Use Material Design 3** with custom glassmorphism
- **Implement Riverpod** for all state management
- **Use GoRouter** for navigation (no React Router)
- **Follow exact color values** from AppColors class
- **Implement all animations** using Flutter Animation framework
- **Use exact project structure** as documented
- **All UI must match React version** pixel-perfectly

---

## 🛠️ FLUTTER DEVELOPMENT SETUP

### 🎯 FLUTTER SETUP (PRIMARY IMPLEMENTATION)

#### 🔧 Prerequisites for AI Implementation
```bash
Flutter SDK 3.16+ (Latest stable)
Dart SDK 3.2+ (Comes with Flutter)
Android Studio (for Android development)
Xcode (for iOS development - macOS only)
Git (version control)
VS Code with Flutter extension (recommended)
```

#### 📱 Complete Flutter Setup Steps
```bash
# 1. Verify Flutter installation
flutter doctor

# 2. Create new Flutter project
flutter create sports_assessment_app
cd sports_assessment_app

# 3. Replace pubspec.yaml with documentation version
# Copy exact pubspec.yaml from documentation above

# 4. Install all dependencies
flutter pub get

# 5. Generate code for Freezed/JSON serialization
flutter packages pub run build_runner build

# 6. Configure app icons and splash screen
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create

# 7. Set up environment configuration
# Create lib/core/config/app_config.dart:
```

**app_config.dart Implementation**:
```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String appName = 'Sports Assessment';
  static const String appVersion = '1.0.0';
  
  // Supabase Configuration (replace with your values)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Environment flags
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool enableLogging = !isProduction;
  
  // API endpoints
  static const String baseApiUrl = supabaseUrl;
  
  // App constants
  static const int sessionTimeoutMinutes = 30;
  static const int maxRetryAttempts = 3;
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Feature flags
  static const bool enableAIChat = true;
  static const bool enableCameraTests = true;
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
}
```

**Continue Setup**:
```bash
# 8. Run the app
flutter run

# 9. Build for release (when ready)
flutter build apk --release        # Android
flutter build ios --release        # iOS
flutter build web --release        # Web
```

#### Complete pubspec.yaml Configuration

**EXACT pubspec.yaml for AI Implementation**:
```yaml
name: sports_assessment_app
description: AI-Powered Sports Talent Assessment Platform
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: '>=3.16.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  freezed_annotation: ^2.4.1
  
  # Navigation
  go_router: ^12.1.3
  
  # Backend & Database
  supabase_flutter: ^2.0.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Storage & Preferences
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  path_provider: ^2.1.1
  
  # Networking
  dio: ^5.3.2
  connectivity_plus: ^5.0.2
  
  # UI & Animations
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
  google_fonts: ^6.1.0
  lottie: ^2.7.0
  flutter_staggered_animations: ^1.1.1
  
  # Camera & Media
  camera: ^0.10.5+5
  video_player: ^2.8.1
  image_picker: ^1.0.4
  
  # Permissions & Device
  permission_handler: ^11.1.0
  device_info_plus: ^9.1.0
  package_info_plus: ^4.2.0
  
  # Location & Maps
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  firebase_messaging: ^14.7.9
  
  # Charts & Data Visualization
  fl_chart: ^0.65.0
  
  # Utils
  intl: ^0.18.1
  uuid: ^4.2.1
  url_launcher: ^6.2.2
  share_plus: ^7.2.1
  
  # JSON & Serialization
  json_annotation: ^4.8.1
  equatable: ^2.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  
  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  
  # App Configuration
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.6
  
  # Testing
  mockito: ^5.4.4
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
    - assets/fonts/
  
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700

# App Icons Configuration
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  adaptive_icon_background: "#121212"
  adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"

# Splash Screen Configuration  
flutter_native_splash:
  color: "#121212"
  image: "assets/images/splash_logo.png"
  android_gravity: center
  ios_content_mode: center
  web: false
  android_12:
    image: "assets/images/splash_logo.png"
    color: "#121212"
```

**Build commands**:
```bash
# Generate code
flutter packages pub run build_runner build

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build for web
flutter build web
```

### Database Setup

#### Supabase Configuration
```sql
-- Enable RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE credit_transactions ENABLE ROW LEVEL SECURITY;

-- Users can only see their own data
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Test results policies
CREATE POLICY "Users can view own test results" ON test_results
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own test results" ON test_results
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Credit transactions policies
CREATE POLICY "Users can view own transactions" ON credit_transactions
  FOR SELECT USING (auth.uid() = user_id);
```

#### Database Functions
```sql
-- Function to update user points
CREATE OR REPLACE FUNCTION update_user_points()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users 
  SET credit_points = credit_points + NEW.amount
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update points
CREATE TRIGGER update_points_trigger
  AFTER INSERT ON credit_transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_user_points();
```

#### Sample Data
```sql
-- Insert sample tests
INSERT INTO tests (id, name, description, duration_seconds, difficulty, category) VALUES
('vertical-jump', 'Vertical Jump', 'Measure your explosive leg power', 60, 'medium', 'power'),
('shuttle-run', 'Shuttle Run', 'Test your agility and quick directional changes', 120, 'medium', 'agility'),
('sit-ups', 'Sit-ups', 'Assess your core strength and endurance', 180, 'easy', 'strength'),
('endurance-run', 'Endurance Run', 'Measure your cardiovascular fitness', 900, 'hard', 'endurance'),
('height', 'Height Measurement', 'Record your accurate height', 30, 'easy', 'measurement'),
('weight', 'Weight Measurement', 'Record your current weight', 30, 'easy', 'measurement');
```

---

## 🚀 PRODUCTION DEPLOYMENT

### React Deployment

#### Vercel Deployment
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy to Vercel
vercel --prod

# Set environment variables in Vercel dashboard
NEXT_PUBLIC_SUPABASE_URL=your_production_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_production_key
```

#### Manual Build
```bash
# Build for production
npm run build

# Test production build locally
npm start

# Deploy to your hosting provider
# Upload 'out' directory for static hosting
# Upload entire project for server-side hosting
```

### Flutter Deployment

#### Android Play Store
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended)
flutter build appbundle --release

# Sign the APK/Bundle with your keystore
# Upload to Google Play Console
```

#### iOS App Store
```bash
# Build for iOS
flutter build ios --release

# Archive in Xcode
# Upload to App Store Connect via Xcode or Application Loader
```

#### Web Deployment
```bash
# Build for web
flutter build web --release

# Deploy to Firebase Hosting, Netlify, or other static host
# Upload 'build/web' directory
```

### Performance Optimization

#### React Optimizations
```typescript
// Lazy loading components
const TestDetailScreen = lazy(() => import('./screens/TestDetailScreen'));

// Memoization for expensive calculations
const expensiveValue = useMemo(() => {
  return heavyCalculation(data);
}, [data]);

// Callback optimization
const handleClick = useCallback(() => {
  onClick(id);
}, [onClick, id]);
```

#### Flutter Optimizations
```dart
// Use const constructors
const MyWidget({super.key});

// Implement proper dispose methods
@override
void dispose() {
  controller.dispose();
  super.dispose();
}

// Use RepaintBoundary for expensive widgets
RepaintBoundary(
  child: ExpensiveWidget(),
)
```

### Monitoring & Analytics

#### Error Tracking
- **React**: Sentry integration
- **Flutter**: Crashlytics integration
- **Backend**: Supabase built-in monitoring

#### Performance Monitoring
- **React**: Web Vitals tracking
- **Flutter**: Firebase Performance
- **Analytics**: Custom event tracking

#### User Feedback
- In-app feedback system
- App store review monitoring
- User support chat integration

---

## 📚 ADDITIONAL RESOURCES

### Code Style Guidelines
- **React**: ESLint + Prettier configuration
- **Flutter**: Dart formatting + Analysis options
- **Git**: Conventional commits format

### Testing Strategy
- **Unit Tests**: Core business logic
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end user flows
- **Performance Tests**: Load and stress testing

### Security Considerations
- API key management
- User data encryption
- Secure authentication flows
- Input validation and sanitization

### Accessibility Features
- Screen reader support
- High contrast mode
- Font size scaling
- Voice control compatibility

---

## 🚨 MANDATORY FLUTTER IMPLEMENTATION REQUIREMENTS

### 🎯 FOR AI IMPLEMENTATION - CRITICAL INSTRUCTIONS:

**ABSOLUTELY ESSENTIAL: This app MUST be implemented in Flutter/Dart ONLY**

#### 📱 ALL SCREENS TO IMPLEMENT (25+ Screens)

**Authentication Flow (3 screens):**
1. `lib/features/auth/presentation/screens/splash_screen.dart`
2. `lib/features/auth/presentation/screens/onboarding_screen.dart`
3. `lib/features/auth/presentation/screens/auth_screen.dart`

**Main Navigation Screens (5 screens):**
4. `lib/features/home/presentation/screens/home_screen.dart`
5. `lib/features/results/presentation/screens/combined_results_screen.dart`
6. `lib/features/community/presentation/screens/community_screen.dart`
7. `lib/features/mentors/presentation/screens/mentor_screen.dart`
8. `lib/features/profile/presentation/screens/profile_screen.dart`

**Test Flow Screens (6 screens):**
9. `lib/features/test/presentation/screens/test_detail_screen.dart`
10. `lib/features/test/presentation/screens/calibration_screen.dart`
11. `lib/features/test/presentation/screens/recording_screen.dart`
12. `lib/features/test/presentation/screens/test_completion_screen.dart`
13. `lib/features/personalized_solution/presentation/screens/personalized_solution_screen.dart`
14. `lib/features/results/presentation/screens/results_screen.dart`

**Feature Screens (11+ screens):**
15. `lib/features/store/presentation/screens/store_screen.dart`
16. `lib/features/store/presentation/screens/product_detail_screen.dart`
17. `lib/features/store/presentation/screens/nearby_stores_screen.dart`
18. `lib/features/nutrition/presentation/screens/nutrition_screen.dart`
19. `lib/features/recovery/presentation/screens/recovery_screen.dart`
20. `lib/features/body_logs/presentation/screens/body_logs_screen.dart`
21. `lib/features/ai_chat/presentation/screens/ai_chat_screen.dart`
22. `lib/features/achievements/presentation/screens/achievements_screen.dart`
23. `lib/features/analytics/presentation/screens/analytics_screen.dart`
24. `lib/features/leaderboard/presentation/screens/leaderboard_screen.dart`
25. `lib/features/settings/presentation/screens/settings_screen.dart`
26. `lib/features/help/presentation/screens/help_screen.dart`
27. `lib/features/profile/presentation/screens/profile_edit_screen.dart`

### 🧩 MANDATORY FLUTTER WIDGETS TO IMPLEMENT:

**Core Widgets (Must implement ALL):**
- `lib/shared/presentation/widgets/glass_card.dart` (Glassmorphism container)
- `lib/shared/presentation/widgets/neon_button.dart` (Glowing buttons)
- `lib/shared/presentation/widgets/main_layout.dart` (Base screen layout)
- `lib/features/home/presentation/widgets/test_card.dart` (Test selection cards)
- `lib/features/home/presentation/widgets/progress_card.dart` (Progress tracking)
- `lib/features/home/presentation/widgets/quick_access_card.dart` (Feature shortcuts)
- `lib/features/home/presentation/widgets/daily_login_bonus.dart` (Bonus modal)
- `lib/features/home/presentation/widgets/quick_stats_section.dart` (Stats display)

### 🔧 FLUTTER TECHNICAL REQUIREMENTS:

1. **State Management**: ONLY use Riverpod - no React Context
2. **Navigation**: ONLY use GoRouter - no React Router
3. **UI Framework**: Material Design 3 with custom glassmorphism
4. **Color System**: Exact AppColors class implementation
5. **Typography**: Google Fonts with Inter family
6. **Animations**: Flutter Animation framework - no Framer Motion
7. **Icons**: Material Icons - no Lucide React
8. **HTTP**: Dio for API calls - no Axios
9. **Local Storage**: Hive + SharedPreferences - no localStorage
10. **Camera**: Camera plugin for test recording
11. **Notifications**: Flutter Local Notifications + FCM
12. **Maps/Location**: Geolocator for nearby stores
13. **Charts**: FL Chart for analytics
14. **Image Handling**: Cached Network Image

### 🎨 FLUTTER UI REQUIREMENTS:

**Exact Design Implementation:**
- **Colors**: Use exact hex values from AppColors class
- **Glassmorphism**: rgba(255,255,255,0.08) background + blur(15px)
- **Neon Glows**: Box shadows with color-specific opacity
- **Typography**: Inter font family with exact weights
- **Spacing**: 4px, 8px, 16px, 24px, 32px, 48px scale
- **Border Radius**: 8px, 12px, 16px, 24px, 32px scale
- **Grid Layout**: 2x3 test cards grid
- **Bottom Nav**: 5 tabs with Material Design styling

**Animation Requirements:**
- Page transitions with slide/fade effects
- Button press scale animations (1.0 → 0.95)
- Card hover effects with scale + glow intensity
- Progress bar fill animations
- Modal slide-in animations
- Success confetti animations

### 📋 FEATURE IMPLEMENTATION CHECKLIST:

#### ✅ Authentication System
- [ ] Splash screen with app logo and loading
- [ ] 3-slide onboarding with skip functionality
- [ ] Login/signup forms with validation
- [ ] Supabase authentication integration
- [ ] Session management with secure storage

#### ✅ Home Screen (Core Hub)
- [ ] Header with greeting and daily bonus button
- [ ] Progress card with animated progress bar
- [ ] 5 quick access cards with neon glows
- [ ] 2x3 test cards grid with status indicators
- [ ] Quick stats section with metrics
- [ ] Pull-to-refresh functionality

#### ✅ Test Assessment Flow
- [ ] Test detail with information and requirements
- [ ] Camera calibration with position guides
- [ ] Video recording with timer and controls
- [ ] Success screen with celebration animation
- [ ] AI-powered personalized solution
- [ ] Detailed results with charts and insights

#### ✅ Navigation System
- [ ] GoRouter with exact route structure
- [ ] Bottom navigation with 5 tabs
- [ ] Proper back button handling
- [ ] Deep linking support
- [ ] Navigation state persistence

#### ✅ Store System
- [ ] Product catalog with glassmorphism cards
- [ ] Product detail with images and specs
- [ ] Shopping cart functionality
- [ ] Credit points payment system
- [ ] Nearby stores with map integration

#### ✅ Social Features
- [ ] Community posts and discussions
- [ ] Mentor profiles and booking
- [ ] Achievement badges and sharing
- [ ] Leaderboard with rankings
- [ ] User profiles with stats

#### ✅ Additional Features
- [ ] AI chat assistant with context awareness
- [ ] Nutrition planning and tracking
- [ ] Recovery plans and sleep tracking
- [ ] Body logs with progress photos
- [ ] Analytics dashboard with charts
- [ ] Settings and preferences
- [ ] Help system and support

### 🛠️ INTEGRATION REQUIREMENTS:

1. **Supabase Backend**: User auth, data storage, real-time updates
2. **Camera Integration**: Test recording with proper permissions
3. **Push Notifications**: Daily reminders and achievements
4. **Offline Support**: Hive local storage with sync capabilities
5. **Error Handling**: User-friendly error screens and recovery
6. **Performance**: Lazy loading, caching, memory management
7. **Responsive Design**: Support for different screen sizes
8. **Accessibility**: Screen reader support and high contrast
9. **Testing**: Unit tests, widget tests, integration tests
10. **CI/CD**: Automated build and deployment pipeline

---

## 🎯 CONCLUSION

This comprehensive documentation provides everything needed to recreate the AI-Powered Sports Talent Assessment Platform from scratch **using Flutter/Dart exclusively**. The app combines cutting-edge design with robust functionality, delivering a premium user experience for mobile platforms.

### 🎯 Key Success Factors for Flutter Implementation
1. **Flutter-First Design**: Optimized for mobile-native performance and user experience
2. **Pixel-Perfect UI**: Exact design replication using Flutter widgets and Material Design 3
3. **Glassmorphism Effects**: Custom implementation using BackdropFilter and Container decorations
4. **State Management**: Robust Riverpod implementation for reactive state handling
5. **Offline Capabilities**: Hive local storage with automatic cloud synchronization
6. **Camera Integration**: Native camera functionality for test recordings
7. **Push Notifications**: Real-time engagement through Firebase Cloud Messaging

### 📱 Flutter Implementation Steps (AI Development)
1. **Initialize Flutter Project** with exact pubspec.yaml configuration
2. **Implement Core Architecture** (theme, colors, routing, state management)
3. **Build Authentication Flow** (splash, onboarding, login/signup)
4. **Create Home Screen** with all components (cards, navigation, stats)
5. **Implement Test Flow** (detail → calibration → recording → results)
6. **Add Feature Screens** (store, community, mentors, profile, settings)
7. **Integrate Backend Services** (Supabase, camera, notifications, location)
8. **Implement Advanced Features** (AI chat, analytics, achievements)
9. **Add Offline Support** and error handling
10. **Test and Deploy** to App Store and Google Play

### 🚨 CRITICAL REMINDER FOR AI IMPLEMENTATION:
**This documentation is specifically designed for Flutter development. When implementing this app using AI, use ONLY Flutter/Dart code. All React examples are provided for reference only. The Flutter implementation is the primary and mandatory approach for this project.**

This documentation serves as the complete blueprint for building a world-class sports assessment application using Flutter that can scale to serve athletes across India and beyond.

---

*Last Updated: January 2025*
*Version: 1.0.0*
*Authors: AI Sports Assessment Team*