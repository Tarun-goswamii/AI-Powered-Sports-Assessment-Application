// lib/features/home/presentation/widgets/quick_stats_section.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class QuickStatsSection extends StatelessWidget {
  final List<StatItem> stats;

  const QuickStatsSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Your Performance',
            style: const TextStyle(
              fontSize: 16,
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
                  right: index < stats.length - 1 ? 8 : 0,
                ),
                child: GlassCard(
                  padding: const EdgeInsets.all(10),
                  enableNeonGlow: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              stat.color.withOpacity(0.8),
                              stat.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          stat.icon,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat.value,
                        style: TextStyle(
                          fontSize: 12,
                          color: stat.color,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        stat.label,
                        style: const TextStyle(
                          fontSize: 8,
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
                          fontSize: 7,
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
