import 'package:flutter/material.dart';

/// Responsive utility class to handle different screen sizes
/// Ensures all UI elements scale properly across devices
class ResponsiveUtils {
  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;
  late final double textScaleFactor;
  late final Orientation orientation;

  ResponsiveUtils(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    // Using textScaler for forward compatibility
    final textScaler = MediaQuery.of(context).textScaler;
    textScaleFactor = textScaler.scale(1.0);
    orientation = MediaQuery.of(context).orientation;
  }

  /// Get responsive width based on percentage (0.0 to 1.0)
  double wp(double percentage) => screenWidth * percentage / 100;

  /// Get responsive height based on percentage (0.0 to 1.0)
  double hp(double percentage) => screenHeight * percentage / 100;

  /// Get responsive font size
  double sp(double size) {
    // Base design on 375x812 (iPhone X)
    const baseWidth = 375.0;
    final scale = screenWidth / baseWidth;
    return size * scale;
  }

  /// Get responsive padding
  EdgeInsets responsivePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: wp(left ?? horizontal ?? all ?? 0),
      right: wp(right ?? horizontal ?? all ?? 0),
      top: hp(top ?? vertical ?? all ?? 0),
      bottom: hp(bottom ?? vertical ?? all ?? 0),
    );
  }

  /// Get responsive margin
  EdgeInsets responsiveMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: wp(left ?? horizontal ?? all ?? 0),
      right: wp(right ?? horizontal ?? all ?? 0),
      top: hp(top ?? vertical ?? all ?? 0),
      bottom: hp(bottom ?? vertical ?? all ?? 0),
    );
  }

  /// Check if device is mobile (width < 600)
  bool get isMobile => screenWidth < 600;

  /// Check if device is tablet (600 <= width < 1200)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Check if device is desktop (width >= 1200)
  bool get isDesktop => screenWidth >= 1200;

  /// Get responsive icon size
  double iconSize([double baseSize = 24.0]) {
    return sp(baseSize);
  }

  /// Get responsive border radius
  BorderRadius responsiveBorderRadius(double radius) {
    return BorderRadius.circular(wp(radius));
  }

  /// Get scaled value based on screen size
  double scale(double value) {
    const baseWidth = 375.0;
    return value * (screenWidth / baseWidth);
  }

  /// Get responsive spacing
  double spacing(double value) => wp(value);

  /// Safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(context).padding;

  /// Get responsive app bar height
  double get appBarHeight => kToolbarHeight * (screenWidth / 375.0).clamp(0.8, 1.2);

  /// Get responsive bottom navigation height
  double get bottomNavHeight => 60.0 * (screenWidth / 375.0).clamp(0.8, 1.2);
}

/// Extension on BuildContext for easy access
extension ResponsiveExtension on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
  
  /// Quick access to screen width
  double get screenWidth => MediaQuery.of(this).size.width;
  
  /// Quick access to screen height
  double get screenHeight => MediaQuery.of(this).size.height;
  
  /// Quick access to responsive width percentage
  double wp(double percentage) => ResponsiveUtils(this).wp(percentage);
  
  /// Quick access to responsive height percentage
  double hp(double percentage) => ResponsiveUtils(this).hp(percentage);
  
  /// Quick access to responsive font size
  double sp(double size) => ResponsiveUtils(this).sp(size);
}

/// Responsive widget wrapper
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveUtils responsive) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveUtils(context));
  }
}

/// Responsive sized box
class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const ResponsiveSizedBox({
    Key? key,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return SizedBox(
      width: width != null ? responsive.wp(width!) : null,
      height: height != null ? responsive.hp(height!) : null,
      child: child,
    );
  }
}

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? all;
  final double? horizontal;
  final double? vertical;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  const ResponsivePadding({
    Key? key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.left,
    this.right,
    this.top,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Padding(
      padding: responsive.responsivePadding(
        all: all,
        horizontal: horizontal,
        vertical: vertical,
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}
