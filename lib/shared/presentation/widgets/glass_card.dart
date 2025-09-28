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
