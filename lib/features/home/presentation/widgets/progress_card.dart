// lib/features/home/presentation/widgets/progress_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../core/utils/responsive_utils.dart';

class ProgressCard extends StatelessWidget {
  final int completedTests;
  final int totalTests;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.completedTests,
    required this.totalTests,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final progress = totalTests > 0 ? completedTests / totalTests : 0.0;
    final percentage = (progress * 100).round();

    return GlassCard(
      padding: EdgeInsets.all(responsive.wp(5)), // Responsive padding
      enableNeonGlow: true,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible( // Allow text to wrap if needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Progress',
                      style: TextStyle(
                        fontSize: responsive.sp(16).clamp(14.0, 18.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: responsive.hp(0.25)),
                    Text(
                      'Keep pushing forward!',
                      style: TextStyle(
                        fontSize: responsive.sp(11).clamp(10.0, 13.0),
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible( // Prevent overflow of completion badge
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(2.5).clamp(8.0, 12.0),
                    vertical: responsive.hp(0.5).clamp(3.0, 6.0),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(responsive.wp(3.5).clamp(12.0, 16.0)),
                    border: Border.all(
                      color: AppColors.neonGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$completedTests/$totalTests Complete',
                    style: TextStyle(
                      fontSize: responsive.sp(11).clamp(10.0, 13.0),
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(2)),
          // Premium progress bar
          Container(
            height: responsive.hp(1.5).clamp(10.0, 14.0),
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.3),
              borderRadius: BorderRadius.circular(responsive.wp(1.5).clamp(5.0, 8.0)),
              border: Border.all(
                color: AppColors.border.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(responsive.wp(1.5).clamp(5.0, 8.0)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.royalPurple,
                        AppColors.electricBlue,
                        AppColors.neonGreen,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.royalPurple.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: responsive.hp(1.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentage% Complete',
                style: TextStyle(
                  fontSize: responsive.sp(12).clamp(11.0, 14.0),
                  color: AppColors.textSecondary.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${totalTests - completedTests} tests remaining',
                style: TextStyle(
                  fontSize: responsive.sp(12).clamp(11.0, 14.0),
                  color: AppColors.warmOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
