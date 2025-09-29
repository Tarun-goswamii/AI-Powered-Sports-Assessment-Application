import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum TestStatus { notStarted, inProgress, completed }

class TestCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final TestStatus status;
  final VoidCallback? onStartTest;
  final int? duration;
  final String? difficulty;

  const TestCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
    this.onStartTest,
    this.duration,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 150, // Reduced height to prevent overflow
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onStartTest,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12), // Reduced padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with solid background
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40, // Reduced size
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _getStatusColor().withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: _getStatusColor(),
                        size: 20,
                      ),
                    ),
                    if (status == TestStatus.completed)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.card,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 8,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (duration != null || difficulty != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (duration != null) ...[
                        Icon(
                          Icons.timer,
                          size: 10,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${duration}min',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (difficulty != null) ...[
                        if (duration != null) const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            difficulty!,
                            style: TextStyle(
                              fontSize: 8,
                              color: _getDifficultyColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 28, // Reduced button height
                  child: ElevatedButton(
                    onPressed: onStartTest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(_getButtonText()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (status) {
      case TestStatus.notStarted:
        return 'Start Test';
      case TestStatus.inProgress:
        return 'Continue';
      case TestStatus.completed:
        return 'View Results';
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case TestStatus.notStarted:
        return AppColors.textSecondary;
      case TestStatus.inProgress:
        return AppColors.warning;
      case TestStatus.completed:
        return AppColors.success;
    }
  }

  Color _getDifficultyColor() {
    if (difficulty == null) return AppColors.textSecondary;

    switch (difficulty!.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
