import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

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
    final responsive = ResponsiveUtils(context);
    
    return Container(
      width: responsive.wp(42).clamp(140.0, 180.0),
      height: responsive.hp(20).clamp(140.0, 170.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(responsive.wp(4)),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: responsive.wp(2),
            offset: Offset(0, responsive.hp(0.25)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onStartTest,
          borderRadius: BorderRadius.circular(responsive.wp(4)),
          child: Padding(
            padding: EdgeInsets.all(responsive.wp(3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with solid background
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: responsive.wp(10).clamp(35.0, 45.0),
                      height: responsive.wp(10).clamp(35.0, 45.0),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(responsive.wp(2.5)),
                        border: Border.all(
                          color: _getStatusColor().withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: _getStatusColor(),
                        size: responsive.sp(18).clamp(16.0, 22.0),
                      ),
                    ),
                    if (status == TestStatus.completed)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: responsive.wp(4).clamp(14.0, 18.0),
                          height: responsive.wp(4).clamp(14.0, 18.0),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.card,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: responsive.sp(7).clamp(6.0, 10.0),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: responsive.hp(1)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.sp(12).clamp(11.0, 14.0),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.hp(0.5)),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: responsive.sp(9).clamp(8.0, 11.0),
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (duration != null || difficulty != null) ...[
                  SizedBox(height: responsive.hp(0.75)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (duration != null) ...[
                        Icon(
                          Icons.timer,
                          size: responsive.sp(9).clamp(8.0, 11.0),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: responsive.wp(0.5)),
                        Text(
                          '${duration}min',
                          style: TextStyle(
                            fontSize: responsive.sp(8).clamp(7.0, 10.0),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (difficulty != null) ...[
                        if (duration != null) SizedBox(width: responsive.wp(1)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(0.75),
                            vertical: responsive.hp(0.1),
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(responsive.wp(1)),
                          ),
                          child: Text(
                            difficulty!,
                            style: TextStyle(
                              fontSize: responsive.sp(7).clamp(6.0, 9.0),
                              color: _getDifficultyColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                SizedBox(height: responsive.hp(1)),
                SizedBox(
                  width: double.infinity,
                  height: responsive.hp(3.5).clamp(26.0, 32.0),
                  child: ElevatedButton(
                    onPressed: onStartTest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.wp(1.5)),
                      ),
                      padding: EdgeInsets.zero,
                      textStyle: TextStyle(
                        fontSize: responsive.sp(10).clamp(9.0, 12.0),
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
