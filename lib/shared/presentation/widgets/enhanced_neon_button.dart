// lib/shared/presentation/widgets/enhanced_neon_button.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum NeonButtonSize { small, medium, large }
enum NeonButtonVariant { filled, outlined, ghost }

class EnhancedNeonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final NeonButtonSize size;
  final NeonButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool enablePulse;

  const EnhancedNeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.size = NeonButtonSize.medium,
    this.variant = NeonButtonVariant.filled,
    this.icon,
    this.isLoading = false,
    this.enablePulse = false,
  });

  @override
  State<EnhancedNeonButton> createState() => _EnhancedNeonButtonState();
}

class _EnhancedNeonButtonState extends State<EnhancedNeonButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOutCubic,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _buttonColor => widget.color ?? AppColors.royalPurple;
  
  double get _buttonHeight {
    switch (widget.size) {
      case NeonButtonSize.small:
        return 40;
      case NeonButtonSize.medium:
        return 56;
      case NeonButtonSize.large:
        return 64;
    }
  }
  
  double get _fontSize {
    switch (widget.size) {
      case NeonButtonSize.small:
        return 14;
      case NeonButtonSize.medium:
        return 16;
      case NeonButtonSize.large:
        return 18;
    }
  }
  
  double get _iconSize {
    switch (widget.size) {
      case NeonButtonSize.small:
        return 18;
      case NeonButtonSize.medium:
        return 22;
      case NeonButtonSize.large:
        return 26;
    }
  }

  void _onTapDown() {
    _pressController.forward();
  }

  void _onTapUp() {
    _pressController.reverse();
  }

  void _onHover(bool hover) {
    setState(() => _isHovered = hover);
    if (hover) {
      _glowController.forward();
    } else {
      _glowController.reverse();
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
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressController,
            _glowController,
            _pulseController,
          ]),
          builder: (context, child) {
            double scale = _scaleAnimation.value;
            if (widget.enablePulse) {
              scale *= _pulseAnimation.value;
            }
            
            return Transform.scale(
              scale: scale,
              child: Container(
                height: _buttonHeight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: _buildDecoration(),
                child: _buildContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    switch (widget.variant) {
      case NeonButtonVariant.filled:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _buttonColor,
              _buttonColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _buttonColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: _buttonColor.withOpacity(0.5 * _glowAnimation.value),
              blurRadius: 20 * _glowAnimation.value,
              spreadRadius: 5 * _glowAnimation.value,
            ),
          ],
        );
        
      case NeonButtonVariant.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _buttonColor.withOpacity(_isHovered ? 1.0 : 0.7),
            width: _isHovered ? 2 : 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: _buttonColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 3,
              ),
          ],
        );
        
      case NeonButtonVariant.ghost:
        return BoxDecoration(
          color: _buttonColor.withOpacity(_isHovered ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _buttonColor.withOpacity(0.3),
            width: 1,
          ),
        );
    }
  }

  Widget _buildContent() {
    Color textColor;
    switch (widget.variant) {
      case NeonButtonVariant.filled:
        textColor = Colors.white;
        break;
      case NeonButtonVariant.outlined:
      case NeonButtonVariant.ghost:
        textColor = _buttonColor;
        break;
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              color: textColor,
              size: _iconSize,
            ),
            const SizedBox(width: 8),
          ],
          if (widget.isLoading)
            SizedBox(
              width: _iconSize,
              height: _iconSize,
              child: CircularProgressIndicator(
                color: textColor,
                strokeWidth: 2,
              ),
            )
          else
            Text(
              widget.text,
              style: TextStyle(
                color: textColor,
                fontSize: _fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}