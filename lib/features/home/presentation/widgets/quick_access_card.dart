// lib/features/home/presentation/widgets/quick_access_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../core/utils/responsive_utils.dart';

class QuickAccessCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const QuickAccessCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return GlassCard(
      padding: EdgeInsets.all(responsive.wp(4).clamp(14.0, 18.0)),
      enableNeonGlow: true,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          // Premium icon with gradient background
          Container(
            width: responsive.wp(10).clamp(35.0, 45.0),
            height: responsive.wp(10).clamp(35.0, 45.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.8),
                  color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(responsive.wp(3).clamp(10.0, 14.0)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: responsive.sp(20).clamp(18.0, 24.0),
              color: Colors.white,
            ),
          ),
          SizedBox(height: responsive.hp(1)),
          Flexible( // Allow text to resize
            child: Text(
              title,
              style: TextStyle(
                fontSize: responsive.sp(14).clamp(12.0, 16.0),
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Limit lines
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: responsive.hp(0.25)),
          Flexible( // Allow subtitle to resize
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: responsive.sp(10).clamp(9.0, 12.0),
                color: AppColors.textSecondary.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                height: 1.2, // Better line height
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Limit lines
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
