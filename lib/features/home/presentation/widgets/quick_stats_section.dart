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
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            'Your Performance',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate available width per stat item
            final availableWidth = constraints.maxWidth;
            final spacing = 16.0 * (stats.length - 1); // Total spacing between items
            final itemWidth = (availableWidth - spacing) / stats.length;

            return Row(
              children: List.generate(stats.length, (index) {
                final stat = stats[index];
                return Container(
                  width: itemWidth,
                  margin: EdgeInsets.only(
                    right: index < stats.length - 1 ? 16 : 0,
                  ),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16), // Reduced padding
                    enableNeonGlow: true,
                    neonGlowColor: stat.color,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon with gradient background
                        Container(
                          width: 32, // Smaller icon
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                stat.color.withOpacity(0.8),
                                stat.color.withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            stat.icon,
                            color: Colors.white,
                            size: 16, // Smaller icon
                          ),
                        ),
                        const SizedBox(height: 8), // Reduced spacing
                        Flexible(
                          child: Text(
                            stat.value,
                            style: TextStyle(
                              fontSize: 16, // Smaller font
                              color: stat.color,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Flexible(
                          child: Text(
                            stat.label,
                            style: const TextStyle(
                              fontSize: 10, // Smaller font
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Flexible(
                          child: Text(
                            stat.subtitle,
                            style: TextStyle(
                              fontSize: 8, // Smaller font
                              color: AppColors.textSecondary.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
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
