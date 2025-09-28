// lib/features/test/presentation/screens/test_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class TestDetailScreen extends StatelessWidget {
  const TestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get test ID from route parameters
    final testId = GoRouterState.of(context).uri.queryParameters['testId'] ?? 'vertical-jump';

    // Test data based on testId
    final testData = _getTestData(testId);

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
                padding: AppSpacing.paddingMedium,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        testData['title'] as String,
                        style: AppTypography.h2,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.paddingMedium,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Test Info Card
                      GlassCard(
                        padding: AppSpacing.paddingMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Information',
                              style: AppTypography.h3,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow('Duration', testData['duration'] as String),
                            _buildInfoRow('Difficulty', testData['difficulty'] as String),
                            _buildInfoRow('Equipment', (testData['equipment'] as List<String>).join(', ')),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      GlassCard(
                        padding: AppSpacing.paddingMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: AppTypography.h3,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              testData['description'] as String,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Instructions
                      GlassCard(
                        padding: AppSpacing.paddingMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instructions',
                              style: AppTypography.h3,
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(
                              (testData['instructions'] as List<String>).length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.royalPurple,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        (testData['instructions'] as List<String>)[index],
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tips
                      GlassCard(
                        padding: AppSpacing.paddingMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: AppColors.neonGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Pro Tips',
                                  style: AppTypography.h3,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(
                              (testData['tips'] as List<String>).length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  '• ${(testData['tips'] as List<String>)[index]}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Start Test Button
                      NeonButton(
                        text: 'Start Test',
                        onPressed: () => _startTest(context, testId),
                      ),

                      const SizedBox(height: 20),
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

  Map<String, dynamic> _getTestData(String testId) {
    final testDataMap = {
      'vertical-jump': {
        'title': 'Vertical Jump Test',
        'description': 'Measure your explosive leg power by jumping as high as possible from a standing position.',
        'duration': '2 minutes',
        'difficulty': 'Medium',
        'equipment': ['Measuring tape or wall', 'Chalk (optional)'],
        'instructions': [
          'Stand with feet shoulder-width apart',
          'Reach up and mark your standing reach height',
          'Jump as high as possible, touching the wall at the highest point',
          'Measure the difference between standing reach and jump height'
        ],
        'tips': [
          'Use a soft surface to avoid injury',
          'Practice the motion before recording',
          'Keep your arms extended upward during the jump'
        ]
      },
      'shuttle-run': {
        'title': 'Shuttle Run Test',
        'description': 'Test your agility and quick directional changes with this shuttle run assessment.',
        'duration': '3 minutes',
        'difficulty': 'Medium',
        'equipment': ['Cones or markers', 'Stopwatch'],
        'instructions': [
          'Place two markers 10 meters apart',
          'Start at one marker',
          'Run to the other marker and touch it',
          'Run back to the starting marker',
          'Repeat for the required number of shuttles'
        ],
        'tips': [
          'Keep your body low during direction changes',
          'Use quick, explosive movements',
          'Maintain good form throughout the test'
        ]
      },
      'sit-ups': {
        'title': 'Sit-ups Test',
        'description': 'Assess your core strength and endurance with this sit-ups assessment.',
        'duration': '2 minutes',
        'difficulty': 'Easy',
        'equipment': ['Mat or soft surface', 'Partner to count'],
        'instructions': [
          'Lie on your back with knees bent',
          'Place hands behind your head',
          'Lift your upper body off the ground',
          'Touch your elbows to your knees',
          'Lower back down and repeat'
        ],
        'tips': [
          'Keep your feet flat on the ground',
          'Don\'t pull on your neck',
          'Breathe steadily throughout the test'
        ]
      },
      'endurance': {
        'title': 'Endurance Run Test',
        'description': 'Measure your cardiovascular fitness and endurance with this running assessment.',
        'duration': '15 minutes',
        'difficulty': 'Hard',
        'equipment': ['Stopwatch', 'Measuring tape (for distance)'],
        'instructions': [
          'Warm up for 5 minutes',
          'Run at a steady pace for the test duration',
          'Maintain consistent speed throughout',
          'Cool down after completing the test'
        ],
        'tips': [
          'Stay hydrated before and during the test',
          'Maintain proper running form',
          'Pace yourself for the full duration'
        ]
      },
      'height': {
        'title': 'Height Measurement',
        'description': 'Record your accurate height for body composition analysis.',
        'duration': '1 minute',
        'difficulty': 'Easy',
        'equipment': ['Measuring tape or stadiometer'],
        'instructions': [
          'Stand straight against a wall',
          'Remove shoes and any headwear',
          'Keep heels, buttocks, shoulders, and head against the wall',
          'Look straight ahead',
          'Record the measurement at the top of your head'
        ],
        'tips': [
          'Measure in the morning before eating',
          'Stand tall with good posture',
          'Have someone help you measure accurately'
        ]
      },
      'weight': {
        'title': 'Weight Measurement',
        'description': 'Record your current weight for body composition tracking.',
        'duration': '1 minute',
        'difficulty': 'Easy',
        'equipment': ['Digital scale'],
        'instructions': [
          'Step on the scale barefoot',
          'Stand still in the center of the scale',
          'Keep your weight evenly distributed',
          'Record the weight shown'
        ],
        'tips': [
          'Weigh yourself at the same time each day',
          'Use the same scale consistently',
          'Weigh before eating or drinking'
        ]
      },
    };

    return testDataMap[testId] ?? testDataMap['vertical-jump']!;
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTest(BuildContext context, String testId) {
    // Navigate to calibration screen with testId
    context.go('/calibration?testId=$testId');
  }
}
