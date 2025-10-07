import 'package:flutter/material.dart';

/// Responsive utility class to handle different screen sizes
/// Ensures all UI elements scale properly across devices
class ResponsiveUtils {
  final BuildContext context;
  
  ResponsiveUtils(this.context);
  
  // Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;
  
  // Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;
  
  // Width percentage
  double wp(double percentage) {
    return screenWidth * (percentage / 100);
  }
  
  // Height percentage
  double hp(double percentage) {
    return screenHeight * (percentage / 100);
  }
  
  // Scale point (for font sizes)
  double sp(double size) {
    return size * (screenWidth / 375); // Base width 375 (iPhone SE)
  }
  
  // Check if mobile
  bool get isMobile => screenWidth < 600;
  
  // Check if tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  
  // Check if desktop
  bool get isDesktop => screenWidth >= 1024;
  
  // Generate responsive padding
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
      left: left != null ? wp(left) : (horizontal != null ? wp(horizontal) : (all != null ? wp(all) : 0)),
      right: right != null ? wp(right) : (horizontal != null ? wp(horizontal) : (all != null ? wp(all) : 0)),
      top: top != null ? hp(top) : (vertical != null ? hp(vertical) : (all != null ? hp(all) : 0)),
      bottom: bottom != null ? hp(bottom) : (vertical != null ? hp(vertical) : (all != null ? hp(all) : 0)),
    );
  }
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
