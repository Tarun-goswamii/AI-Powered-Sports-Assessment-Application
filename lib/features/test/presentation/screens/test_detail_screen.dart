// lib/features/test/presentation/screens/test_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/video_analysis_service.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class TestDetailScreen extends StatelessWidget {
  final ExerciseType exerciseType;
  
  const TestDetailScreen({
    super.key,
    this.exerciseType = ExerciseType.sprint, // Default for existing implementation
  });

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '40m Sprint Test',
                        style: TextStyle(
                          fontSize: 24,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Test Overview Card
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        enableNeonGlow: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [AppColors.royalPurple, AppColors.electricBlue],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    _getExerciseIcon(exerciseType),
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        VideoAnalysisService.getExerciseName(exerciseType),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getExerciseDescription(exerciseType),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _buildStatItem('Duration', '30 sec', Icons.timer),
                                const SizedBox(width: 24),
                                _buildStatItem('Credits', '+50', Icons.stars),
                                const SizedBox(width: 24),
                                _buildStatItem('Difficulty', 'Medium', Icons.trending_up),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Test Description
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Test Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'The 40m sprint test measures your acceleration and maximum speed capabilities. This test is crucial for athletes in sports requiring quick bursts of speed like football, basketball, and track events.',
                              style: TextStyle(
                                fontSize: 16,
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
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.royalPurple,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.royalPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.royalPurple,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(String step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.electricBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ),
      ],
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
