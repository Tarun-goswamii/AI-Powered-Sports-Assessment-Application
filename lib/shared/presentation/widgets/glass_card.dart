// lib/shared/presentation/widgets/glass_card.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final bool enableNeonGlow;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.enableNeonGlow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: enableNeonGlow 
          ? [
              BoxShadow(
                color: const Color(0xFF6A0DAD).withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 0),
              ),
              BoxShadow(
                color: const Color(0xFF6A0DAD).withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
              ...?boxShadow,
            ]
          : boxShadow ?? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              border: Border.all(
                color: enableNeonGlow 
                  ? const Color(0xFF6A0DAD).withOpacity(0.5)
                  : borderColor ?? Colors.white.withOpacity(0.2),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}

class InteractiveGlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool enableHoverEffect;
  final bool enablePressEffect;

  const InteractiveGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
    this.enableHoverEffect = true,
    this.enablePressEffect = true,
  });

  @override
  State<InteractiveGlassCard> createState() => _InteractiveGlassCardState();
}

class _InteractiveGlassCardState extends State<InteractiveGlassCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _borderAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onHover(bool hover) {
    setState(() => _isHovered = hover);
    if (widget.enableHoverEffect) {
      if (hover) {
        _hoverController.forward();
        _glowController.repeat(reverse: true);
      } else {
        _hoverController.reverse();
        _glowController.stop();
        _glowController.reset();
      }
    }
  }

  void _onTapDown() {
    if (widget.enablePressEffect) {
      _pressController.forward();
    }
  }

  void _onTapUp() {
    if (widget.enablePressEffect) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: () => _onTapUp(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _hoverController,
            _pressController,
            _glowController,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value * (1.0 - _pressController.value * 0.05),
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10 + (_glowAnimation.value * 10),
                      offset: const Offset(0, 5),
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: (widget.borderColor ?? Colors.white).withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 20 + (_glowAnimation.value * 15),
                        spreadRadius: 5 + (_glowAnimation.value * 5),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
                    child: Container(
                      padding: widget.padding ?? const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(widget.opacity + (_isHovered ? 0.05 : 0.0)),
                        borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                        border: Border.all(
                          color: (widget.borderColor ?? Colors.white).withOpacity(0.2 + (_isHovered ? 0.3 : 0.0)),
                          width: widget.borderWidth * _borderAnimation.value,
                        ),
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}