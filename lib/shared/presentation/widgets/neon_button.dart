// lib/shared/presentation/widgets/neon_button.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';

enum NeonButtonVariant { primary, secondary, outline }
enum NeonButtonSize { small, medium, large }

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
    final responsive = ResponsiveUtils(context);
    
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
              padding: _getPadding(responsive),
              decoration: _getDecoration(responsive),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: responsive.sp(20).clamp(16.0, 24.0),
                        height: responsive.sp(20).clamp(16.0, 24.0),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.text,
                        style: _getTextStyle(responsive),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  EdgeInsets _getPadding(ResponsiveUtils responsive) {
    switch (widget.size) {
      case NeonButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: responsive.wp(4), 
          vertical: responsive.hp(1)
        );
      case NeonButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: responsive.wp(6), 
          vertical: responsive.hp(1.5)
        );
      case NeonButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: responsive.wp(8), 
          vertical: responsive.hp(2)
        );
    }
  }

  BoxDecoration _getDecoration(ResponsiveUtils responsive) {
    final borderRadius = responsive.wp(4);
    
    switch (widget.variant) {
      case NeonButtonVariant.primary:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.royalPurple, AppColors.electricBlue],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: AppColors.neonGlowPurple,
        );
      case NeonButtonVariant.secondary:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.electricBlue, AppColors.neonGreen],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: AppColors.neonGlowBlue,
        );
      case NeonButtonVariant.outline:
        return BoxDecoration(
          border: Border.all(color: AppColors.royalPurple, width: 2),
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }

  TextStyle _getTextStyle(ResponsiveUtils responsive) {
    return TextStyle(
      color: widget.variant == NeonButtonVariant.outline
          ? AppColors.royalPurple
          : Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: _getFontSize(responsive),
    );
  }

  double _getFontSize(ResponsiveUtils responsive) {
    switch (widget.size) {
      case NeonButtonSize.small:
        return responsive.sp(14).clamp(12.0, 16.0);
      case NeonButtonSize.medium:
        return responsive.sp(16).clamp(14.0, 18.0);
      case NeonButtonSize.large:
        return responsive.sp(18).clamp(16.0, 22.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
