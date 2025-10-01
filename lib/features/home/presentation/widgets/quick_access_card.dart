// lib/features/home/presentation/widgets/quick_access_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

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
    return GlassCard(
      padding: const EdgeInsets.all(16), // Reduced padding to prevent overflow
      enableNeonGlow: true,
      neonGlowColor: color,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          // Premium icon with gradient background
          Container(
            width: 40, // Reduced size to fit better
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.8),
                  color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
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
              size: 20, // Reduced icon size
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8), // Reduced spacing
          Flexible( // Allow text to resize
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14, // Reduced font size
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Limit lines
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2), // Reduced spacing
          Flexible( // Allow subtitle to resize
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 10, // Reduced font size
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
