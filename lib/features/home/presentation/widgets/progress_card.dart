// lib/features/home/presentation/widgets/progress_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressCard extends StatelessWidget {
  final int completedTests;
  final int totalTests;

  const ProgressCard({
    super.key,
    required this.completedTests,
    required this.totalTests,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalTests > 0 ? (completedTests / totalTests) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppColors.glassmorphismDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Test Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '$completedTests/$totalTests Complete',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.royalPurple),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
