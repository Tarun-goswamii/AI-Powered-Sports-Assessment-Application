// lib/shared/presentation/widgets/premium_animations.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PremiumAnimations {
  // Enhanced staggered animations with premium timing
  static AnimationLimiter staggeredList({
    required List<Widget> children,
    int duration = 1000,
    double horizontalOffset = 80.0,
    double verticalOffset = 60.0,
  }) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: Duration(milliseconds: duration),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: horizontalOffset,
            verticalOffset: verticalOffset,
            child: FadeInAnimation(child: widget),
          ),
          children: children,
        ),
      ),
    );
  }

  // Grid animations with bounce effect
  static AnimationLimiter staggeredGrid({
    required List<Widget> children,
    required int crossAxisCount,
    int duration = 1200,
    double scale = 0.8,
  }) {
    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(children.length, (index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: Duration(milliseconds: duration),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              scale: scale,
              child: FadeInAnimation(child: children[index]),
            ),
          );
        }),
      ),
    );
  }

  // Premium slide-in animation
  static Widget slideInFromBottom({
    required Widget child,
    int delay = 0,
    int duration = 800,
    double offset = 100.0,
  }) {
    return AnimationConfiguration.synchronized(
      child: SlideAnimation(
        verticalOffset: offset,
        duration: Duration(milliseconds: duration),
        delay: Duration(milliseconds: delay),
        child: FadeInAnimation(child: child),
      ),
    );
  }

  // Scale and fade animation
  static Widget scaleAndFade({
    required Widget child,
    int delay = 0,
    int duration = 600,
    double scale = 0.5,
  }) {
    return AnimationConfiguration.synchronized(
      child: ScaleAnimation(
        scale: scale,
        duration: Duration(milliseconds: duration),
        delay: Duration(milliseconds: delay),
        child: FadeInAnimation(child: child),
      ),
    );
  }

  // Bounce in animation
  static Widget bounceIn({
    required Widget child,
    int delay = 0,
    int duration = 1000,
  }) {
    return AnimationConfiguration.synchronized(
      child: ScaleAnimation(
        scale: 0.3,
        duration: Duration(milliseconds: duration),
        delay: Duration(milliseconds: delay),
        curve: Curves.elasticOut,
        child: FadeInAnimation(child: child),
      ),
    );
  }

  // Premium card hover effect (for web/desktop)
  static Widget hoverEffect({
    required Widget child,
    double scale = 1.05,
    int duration = 200,
  }) {
    return AnimatedScale(
      scale: scale,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}

// Enhanced animation curves for premium feel
class PremiumCurves {
  static const Curve bounceOut = Curves.elasticOut;
  static const Curve smoothEase = Curves.easeOutCubic;
  static const Curve sharpEase = Curves.easeOutExpo;
  static const Curve gentleEase = Curves.easeOutQuad;
}

// Premium timing configurations
class PremiumTiming {
  static const Duration instant = Duration(milliseconds: 150);
  static const Duration quick = Duration(milliseconds: 300);
  static const Duration standard = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration verySlow = Duration(milliseconds: 1200);
}

// Enhanced staggered animation for lists
class PremiumStaggeredList extends StatelessWidget {
  final List<Widget> children;
  final int duration;
  final double horizontalOffset;
  final double verticalOffset;
  final int delay;

  const PremiumStaggeredList({
    super.key,
    required this.children,
    this.duration = 1000,
    this.horizontalOffset = 80.0,
    this.verticalOffset = 60.0,
    this.delay = 100,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: Duration(milliseconds: duration),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: horizontalOffset,
            verticalOffset: verticalOffset,
            child: FadeInAnimation(
              delay: Duration(milliseconds: delay),
              child: widget,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}

// Premium grid animation
class PremiumStaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final int duration;
  final double scale;
  final int delay;

  const PremiumStaggeredGrid({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.duration = 1200,
    this.scale = 0.8,
    this.delay = 150,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(children.length, (index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: Duration(milliseconds: duration),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              scale: scale,
              child: FadeInAnimation(
                delay: Duration(milliseconds: delay * index),
                child: children[index],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Pulse animation for interactive elements
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scale;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.scale = 1.1,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

// Shimmer loading effect
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
