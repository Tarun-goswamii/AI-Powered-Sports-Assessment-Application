// lib/features/home/presentation/widgets/daily_login_bonus.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/utils/responsive_utils.dart';

class DailyLoginBonus extends StatefulWidget {
  final VoidCallback? onClaimBonus;

  const DailyLoginBonus({
    super.key,
    this.onClaimBonus,
  });

  @override
  State<DailyLoginBonus> createState() => _DailyLoginBonusState();
}

class _DailyLoginBonusState extends State<DailyLoginBonus>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: GlassCard(
                padding: EdgeInsets.all(responsive.wp(8).clamp(24.0, 36.0)),
                enableNeonGlow: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Celebration icon with glow
                    Container(
                      width: responsive.wp(20).clamp(70.0, 90.0),
                      height: responsive.wp(20).clamp(70.0, 90.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.neonGreen.withOpacity(0.8),
                            AppColors.electricBlue.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonGreen.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.celebration,
                        color: Colors.white,
                        size: responsive.sp(40).clamp(36.0, 48.0),
                      ),
                    ),
                    SizedBox(height: responsive.hp(3)),
                    Text(
                      'Daily Bonus!',
                      style: TextStyle(
                        fontSize: responsive.sp(24).clamp(22.0, 28.0),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(1.5)),
                    Text(
                      'Welcome back! Claim your daily login bonus of 10 credits.',
                      style: TextStyle(
                        fontSize: responsive.sp(16).clamp(14.0, 18.0),
                        color: AppColors.textSecondary.withOpacity(0.9),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(4).clamp(12.0, 18.0),
                        vertical: responsive.hp(1).clamp(6.0, 10.0),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(responsive.wp(5).clamp(18.0, 24.0)),
                        border: Border.all(
                          color: AppColors.neonGreen.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '+10 Credits',
                        style: TextStyle(
                          fontSize: responsive.sp(14).clamp(12.0, 16.0),
                          color: AppColors.neonGreen,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(4)),
                    NeonButton(
                      text: 'Claim Bonus',
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onClaimBonus?.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
