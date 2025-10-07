import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum TestStatus { notStarted, inProgress, completed }

class TestCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final TestStatus status;
  final int? duration;
  final String? difficulty;
  final VoidCallback onStartTest;

  const TestCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
    this.duration,
    this.difficulty,
    required this.onStartTest,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStartTest,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.royalPurple, AppColors.electricBlue],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color color;

    switch (status) {
      case TestStatus.notStarted:
        text = 'Start';
        color = Colors.grey;
        break;
      case TestStatus.inProgress:
        text = 'Continue';
        color = AppColors.warmOrange;
        break;
      case TestStatus.completed:
        text = 'Completed';
        color = AppColors.neonGreen;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
