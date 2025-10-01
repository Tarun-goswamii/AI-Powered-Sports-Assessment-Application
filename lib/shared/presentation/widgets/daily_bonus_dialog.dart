// lib/shared/presentation/widgets/daily_bonus_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/services/auth_persistence_service.dart';
import 'glass_card.dart';
import 'enhanced_neon_button.dart';

class DailyBonusDialog extends ConsumerStatefulWidget {
  final VoidCallback? onClaimBonus;
  final VoidCallback? onClose;

  const DailyBonusDialog({
    Key? key,
    this.onClaimBonus,
    this.onClose,
  }) : super(key: key);

  @override
  ConsumerState<DailyBonusDialog> createState() => _DailyBonusDialogState();
}

class _DailyBonusDialogState extends ConsumerState<DailyBonusDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _coinController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _coinAnimation;

  bool _bonusClaimed = false;
  final int _bonusAmount = 100; // Daily bonus amount

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _coinController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _coinAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _coinController,
      curve: Curves.bounceOut,
    ));
    
    _startAnimations();
  }

  void _startAnimations() async {
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  void _claimBonus() async {
    if (_bonusClaimed) return;
    
    setState(() => _bonusClaimed = true);
    _coinController.forward();
    
    // Mark daily bonus as shown
    await AuthPersistenceService.setDailyBonusShown(true);
    
    // Call the callback
    widget.onClaimBonus?.call();
    
    // Auto close after animation
    await Future.delayed(const Duration(milliseconds: 1500));
    _closeDialog();
  }

  void _closeDialog() {
    widget.onClose?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleController,
          _glowController,
          _coinController,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 320,
              height: 400,
              child: Stack(
                children: [
                  // Main dialog content
                  InteractiveGlassCard(
                    enableHoverEffect: false,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: _closeDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                color: AppTextTheme.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Daily bonus icon with glow
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.warmOrange,
                                AppColors.neonGreen,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.warmOrange.withOpacity(0.5 * _glowAnimation.value),
                                blurRadius: 30 * _glowAnimation.value,
                                spreadRadius: 10 * _glowAnimation.value,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.card_giftcard,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Title
                        AppTextTheme.primaryText(
                          'Daily Login Bonus!',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        AppTextTheme.secondaryText(
                          'Claim your daily reward for logging in',
                          fontSize: 14,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Bonus amount with coin animation
                        if (!_bonusClaimed) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.royalPurple.withOpacity(0.3),
                                  AppColors.electricBlue.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.royalPurple.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  color: AppColors.warmOrange,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                AppTextTheme.primaryText(
                                  '+$_bonusAmount',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(width: 4),
                                AppTextTheme.secondaryText(
                                  'XP',
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Claimed animation
                          Transform.scale(
                            scale: _coinAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.neonGreen.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.neonGreen,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                color: AppColors.neonGreen,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextTheme.primaryText(
                            'Bonus Claimed!',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                        
                        const SizedBox(height: 32),
                        
                        // Claim button
                        if (!_bonusClaimed)
                          EnhancedNeonButton(
                            text: 'Claim Bonus',
                            onPressed: _claimBonus,
                            size: NeonButtonSize.large,
                            variant: NeonButtonVariant.filled,
                            color: AppColors.neonGreen,
                            enablePulse: true,
                          )
                        else
                          EnhancedNeonButton(
                            text: 'Continue',
                            onPressed: _closeDialog,
                            size: NeonButtonSize.large,
                            variant: NeonButtonVariant.filled,
                            color: AppColors.royalPurple,
                          ),
                      ],
                    ),
                  ),
                  
                  // Floating particles effect (optional)
                  if (!_bonusClaimed)
                    ...List.generate(6, (index) => 
                      _buildFloatingParticle(index)
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final size = 4.0 + (index % 3) * 2.0;
    final colors = [
      AppColors.royalPurple,
      AppColors.electricBlue,
      AppColors.neonGreen,
      AppColors.warmOrange,
    ];
    
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final offset = Offset(
          50 + (index * 40.0) + (20 * _glowAnimation.value),
          100 + (index * 30.0) + (10 * _glowAnimation.value),
        );
        
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Opacity(
            opacity: _glowAnimation.value * 0.7,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors[index % colors.length].withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Static method to show the dialog
  static Future<void> showDailyBonus(
    BuildContext context, {
    VoidCallback? onClaimBonus,
    VoidCallback? onClose,
  }) async {
    final shouldShow = await AuthPersistenceService.shouldShowDailyBonus();
    
    if (shouldShow && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DailyBonusDialog(
          onClaimBonus: onClaimBonus,
          onClose: onClose,
        ),
      );
    }
  }
}