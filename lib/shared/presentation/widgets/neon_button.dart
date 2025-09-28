// lib/shared/presentation/widgets/neon_button.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
