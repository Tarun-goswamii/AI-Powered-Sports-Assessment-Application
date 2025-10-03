// lib/features/home/presentation/widgets/quick_stats_section.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../core/utils/responsive_utils.dart';

class QuickStatsSection extends StatelessWidget {
  final List<StatItem> stats;

  const QuickStatsSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: responsive.hp(2)),
          child: Text(
            'Your Performance',
            style: TextStyle(
              fontSize: responsive.sp(16).clamp(14.0, 18.0),
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ),
        Row(
          children: List.generate(stats.length, (index) {
            final stat = stats[index];
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < stats.length - 1 ? responsive.wp(2) : 0,
                ),
                child: GlassCard(
                  padding: EdgeInsets.all(responsive.wp(2.5).clamp(8.0, 12.0)),
                  enableNeonGlow: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: responsive.wp(6).clamp(20.0, 28.0),
                        height: responsive.wp(6).clamp(20.0, 28.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              stat.color.withOpacity(0.8),
                              stat.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(responsive.wp(1.5).clamp(5.0, 8.0)),
                        ),
                        child: Icon(
                          stat.icon,
                          color: Colors.white,
                          size: responsive.sp(12).clamp(10.0, 14.0),
                        ),
                      ),
                      SizedBox(height: responsive.hp(0.5)),
                      Text(
                        stat.value,
                        style: TextStyle(
                          fontSize: responsive.sp(12).clamp(11.0, 14.0),
                          color: stat.color,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: responsive.hp(0.1)),
                      Text(
                        stat.label,
                        style: TextStyle(
                          fontSize: responsive.sp(8).clamp(7.0, 10.0),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        stat.subtitle,
                        style: TextStyle(
                          fontSize: responsive.sp(7).clamp(6.0, 9.0),
                          color: AppColors.textSecondary.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class StatItem {
  final String value;
  final String label;
  final String subtitle;
  final Color color;
  final IconData icon;

  const StatItem({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}
