// lib/features/test/presentation/screens/test_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/video_analysis_service.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/utils/responsive_utils.dart';

class TestDetailScreen extends StatelessWidget {
  final ExerciseType exerciseType;
  
  const TestDetailScreen({
    super.key,
    this.exerciseType = ExerciseType.sprint, // Default for existing implementation
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(responsive.wp(5)),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: responsive.wp(4)),
                    Expanded(
                      child: Text(
                        '40m Sprint Test',
                        style: TextStyle(
                          fontSize: responsive.sp(24).clamp(22.0, 28.0),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Test Overview Card
                      GlassCard(
                        padding: EdgeInsets.all(responsive.wp(6)),
                        enableNeonGlow: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: responsive.wp(16).clamp(50.0, 70.0),
                                  height: responsive.wp(16).clamp(50.0, 70.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [AppColors.royalPurple, AppColors.electricBlue],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(responsive.wp(4)),
                                  ),
                                  child: Icon(
                                    _getExerciseIcon(exerciseType),
                                    color: Colors.white,
                                    size: responsive.sp(30).clamp(26.0, 34.0),
                                  ),
                                ),
                                SizedBox(width: responsive.wp(4)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        VideoAnalysisService.getExerciseName(exerciseType),
                                        style: TextStyle(
                                          fontSize: responsive.sp(20).clamp(18.0, 24.0),
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: responsive.hp(0.5)),
                                      Text(
                                        _getExerciseDescription(exerciseType),
                                        style: TextStyle(
                                          fontSize: responsive.sp(14).clamp(12.0, 16.0),
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.hp(3)),
                            Row(
                              children: [
                                _buildStatItem('Duration', '30 sec', Icons.timer),
                                SizedBox(width: responsive.wp(6)),
                                _buildStatItem('Credits', '+50', Icons.stars),
                                SizedBox(width: responsive.wp(6)),
                                _buildStatItem('Difficulty', 'Medium', Icons.trending_up),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.hp(3)),

                      // Test Description
                      GlassCard(
                        padding: EdgeInsets.all(responsive.wp(6)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Description',
                              style: TextStyle(
                                fontSize: responsive.sp(18).clamp(16.0, 20.0),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: responsive.hp(2)),
                            Text(
                              'The 40m sprint test measures your acceleration and maximum speed capabilities. This test is crucial for athletes in sports requiring quick bursts of speed like football, basketball, and track events.',
                              style: TextStyle(
                                fontSize: responsive.sp(16).clamp(14.0, 18.0),
                                color: AppColors.textSecondary.withOpacity(0.9),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'The test involves sprinting as fast as possible for 40 meters from a standing start. Your performance will be analyzed using AI to provide personalized training recommendations.',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary.withOpacity(0.9),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Requirements
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Requirements',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildRequirementItem(
                              Icons.straighten,
                              'Clear 40m running space',
                            ),
                            const SizedBox(height: 12),
                            _buildRequirementItem(
                              Icons.phone_android,
                              'Smartphone with camera',
                            ),
                            const SizedBox(height: 12),
                            _buildRequirementItem(
                              Icons.wb_sunny,
                              'Good lighting conditions',
                            ),
                            const SizedBox(height: 12),
                            _buildRequirementItem(
                              Icons.accessibility,
                              'Wear athletic clothing',
                            ),
                            const SizedBox(height: 12),
                            _buildRequirementItem(
                              Icons.sports,
                              'Proper warm-up completed',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Instructions
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInstructionStep(
                              '1',
                              'Position your phone 5-10 meters away from the start line',
                            ),
                            const SizedBox(height: 12),
                            _buildInstructionStep(
                              '2',
                              'Ensure the camera can capture your full sprint',
                            ),
                            const SizedBox(height: 12),
                            _buildInstructionStep(
                              '3',
                              'Start from a standing position behind the start line',
                            ),
                            const SizedBox(height: 12),
                            _buildInstructionStep(
                              '4',
                              'Sprint as fast as possible for 40 meters',
                            ),
                            const SizedBox(height: 12),
                            _buildInstructionStep(
                              '5',
                              'The AI will analyze your speed and form',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Start Test Button
                      NeonButton(
                        text: 'Start Calibration',
                        onPressed: () => context.push(
                          '/test/calibration',
                          extra: {'exercise_type': exerciseType},
                        ),
                        size: NeonButtonSize.large,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Builder(
        builder: (context) {
          final responsive = ResponsiveUtils(context);
          return Column(
            children: [
              Icon(
                icon,
                color: AppColors.royalPurple,
                size: responsive.sp(24).clamp(20.0, 28.0),
              ),
              SizedBox(height: responsive.hp(1)),
              Text(
                value,
                style: TextStyle(
                  fontSize: responsive.sp(16).clamp(14.0, 18.0),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: responsive.hp(0.5)),
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.sp(12).clamp(10.0, 14.0),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequirementItem(IconData icon, String text) {
    return Builder(
      builder: (context) {
        final responsive = ResponsiveUtils(context);
        return Row(
          children: [
            Container(
              width: responsive.wp(8).clamp(28.0, 36.0),
              height: responsive.wp(8).clamp(28.0, 36.0),
              decoration: BoxDecoration(
                color: AppColors.royalPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(responsive.wp(2)),
              ),
              child: Icon(
                icon,
                color: AppColors.royalPurple,
                size: responsive.sp(16).clamp(14.0, 18.0),
              ),
            ),
            SizedBox(width: responsive.wp(3)),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: responsive.sp(14).clamp(12.0, 16.0),
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionStep(String step, String text) {
    return Builder(
      builder: (context) {
        final responsive = ResponsiveUtils(context);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: responsive.wp(6).clamp(20.0, 28.0),
              height: responsive.wp(6).clamp(20.0, 28.0),
              decoration: BoxDecoration(
                color: AppColors.electricBlue,
                borderRadius: BorderRadius.circular(responsive.wp(3)),
              ),
              child: Center(
                child: Text(
                  step,
                  style: TextStyle(
                    fontSize: responsive.sp(12).clamp(10.0, 14.0),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.wp(3)),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: responsive.sp(14).clamp(12.0, 16.0),
                  color: AppColors.textSecondary.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getExerciseIcon(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.pushup:
        return Icons.fitness_center;
      case ExerciseType.pullup:
        return Icons.accessibility_new;
      case ExerciseType.squat:
        return Icons.airline_seat_legroom_reduced;
      case ExerciseType.bicepCurl:
        return Icons.sports_gymnastics;
      case ExerciseType.shoulderPress:
        return Icons.sports_martial_arts;
      case ExerciseType.sprint:
        return Icons.directions_run;
      case ExerciseType.burpee:
        return Icons.sports_handball;
      case ExerciseType.plank:
        return Icons.hotel;
    }
  }

  String _getExerciseDescription(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.pushup:
        return 'Upper Body Strength Assessment';
      case ExerciseType.pullup:
        return 'Pull Strength & Endurance Test';
      case ExerciseType.squat:
        return 'Lower Body Power Assessment';
      case ExerciseType.bicepCurl:
        return 'Arm Strength & Form Analysis';
      case ExerciseType.shoulderPress:
        return 'Shoulder Stability Test';
      case ExerciseType.sprint:
        return 'Speed & Acceleration Assessment';
      case ExerciseType.burpee:
        return 'Full Body Conditioning Test';
      case ExerciseType.plank:
        return 'Core Strength & Endurance';
    }
  }
}
