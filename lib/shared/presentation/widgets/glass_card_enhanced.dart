// lib/shared/presentation/widgets/glass_card_enhanced.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class GlassCardEnhanced extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool enableNeonGlow;
  final Color? neonGlowColor;
  final VoidCallback? onTap;
  final double blurStrength;
  final double opacity;
  final Color? customBackgroundColor;
  final List<BoxShadow>? customShadow;

  const GlassCardEnhanced({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.enableNeonGlow = false,
    this.neonGlowColor,
    this.onTap,
    this.blurStrength = 20.0,
    this.opacity = 0.15,
    this.customBackgroundColor,
    this.customShadow,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(24);
    final backgroundColor = customBackgroundColor ?? AppColors.card.withOpacity(opacity);

    // Enhanced shadow system
    List<BoxShadow> shadows = customShadow ?? [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ];

    // Add neon glow if enabled
    if (enableNeonGlow && neonGlowColor != null) {
      shadows.addAll(_getNeonGlowShadows(neonGlowColor!));
    }

    Widget card = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: defaultBorderRadius,
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurStrength,
            sigmaY: blurStrength,
          ),
          child: Container(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );

    // Add tap functionality if provided
    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }

  List<BoxShadow> _getNeonGlowShadows(Color color) {
    // Enhanced neon glow with multiple layers for premium effect
    return [
      BoxShadow(
        color: color.withOpacity(0.6),
        blurRadius: 24,
        spreadRadius: 2,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: 48,
        spreadRadius: 1,
        offset: const Offset(0, 3),
      ),
      BoxShadow(
        color: color.withOpacity(0.2),
        blurRadius: 72,
        spreadRadius: 0,
        offset: const Offset(0, 2),
      ),
    ];
  }
}

// Enhanced Glass Card with iOS-inspired design
class PremiumGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool enableGlow;
  final Color? glowColor;
  final VoidCallback? onTap;
  final double elevation;
  final Color? backgroundColor;

  const PremiumGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.enableGlow = false,
    this.glowColor,
    this.onTap,
    this.elevation = 16.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(28);
    final bgColor = backgroundColor ?? AppColors.card.withOpacity(0.18);

    // Premium shadow system
    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: elevation,
        offset: Offset(0, elevation / 3),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation / 6),
      ),
    ];

    // Add premium glow
    if (enableGlow && glowColor != null) {
      shadows.addAll([
        BoxShadow(
          color: glowColor!.withOpacity(0.4),
          blurRadius: 32,
          spreadRadius: 4,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: glowColor!.withOpacity(0.2),
          blurRadius: 64,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ]);
    }

    Widget card = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: defaultBorderRadius,
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 24,
            sigmaY: 24,
          ),
          child: Container(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

// Ultra-premium card with animated effects
class UltraGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? accentColor;
  final VoidCallback? onTap;
  final bool enablePulse;

  const UltraGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.accentColor,
    this.onTap,
    this.enablePulse = false,
  });

  @override
  State<UltraGlassCard> createState() => _UltraGlassCardState();
}

class _UltraGlassCardState extends State<UltraGlassCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.enablePulse) {
      _pulseController = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      )..repeat(reverse: true);

      _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.enablePulse) {
      _pulseController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? AppColors.royalPurple;
    final defaultBorderRadius = widget.borderRadius ?? BorderRadius.circular(32);

    Widget card = AnimatedBuilder(
      animation: widget.enablePulse ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      builder: (context, child) {
        final pulseValue = widget.enablePulse ? _pulseAnimation.value : 0.0;

        return Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.2 + pulseValue * 0.1),
            borderRadius: defaultBorderRadius,
            border: Border.all(
              color: AppColors.border.withOpacity(0.5 + pulseValue * 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: accentColor.withOpacity(0.3 + pulseValue * 0.3),
                blurRadius: 48 + pulseValue * 16,
                spreadRadius: 4 + pulseValue * 4,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: accentColor.withOpacity(0.2 + pulseValue * 0.2),
                blurRadius: 80 + pulseValue * 20,
                spreadRadius: 2 + pulseValue * 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: defaultBorderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 28,
                sigmaY: 28,
              ),
              child: Container(
                color: Colors.transparent,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );

    if (widget.onTap != null) {
      card = GestureDetector(
        onTap: widget.onTap,
        child: card,
      );
    }

    return card;
  }
}
