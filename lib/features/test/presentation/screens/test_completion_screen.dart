// lib/features/test/presentation/screens/test_completion_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class TestCompletionScreen extends StatefulWidget {
  const TestCompletionScreen({super.key});

  @override
  State<TestCompletionScreen> createState() => _TestCompletionScreenState();
}

class _TestCompletionScreenState extends State<TestCompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Mock test results
  final testResult = {
    'testName': 'Vertical Jump',
    'score': 45.2,
    'unit': 'cm',
    'percentile': 78,
    'grade': 'Excellent',
    'points': 50,
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Celebration Animation
                SizedBox(
                  height: 200,
                  child: Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_xlkxtmul.json', // Celebration animation
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.celebration,
                        size: 100,
                        color: AppColors.neonGreen,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Success Message
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'Test Completed!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: AppColors.neonGreen.withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Great job! Your results are ready.',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Results Card
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Test Name
                            Text(
                              testResult['testName'] as String,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Score Display
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: AppGradients.purpleBlue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${testResult['score']}${testResult['unit']}',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    testResult['grade'] as String,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Stats
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    'Percentile',
                                    '${testResult['percentile']}%',
                                    AppColors.electricBlue,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatItem(
                                    'Points Earned',
                                    '+${testResult['points']}',
                                    AppColors.neonGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Action Buttons
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Column(
                        children: [
                          NeonButton(
                            text: 'View Detailed Results',
                            onPressed: () => _viewResults(context),
                          ),

                          const SizedBox(height: 16),

                          NeonButton(
                            text: 'Share Achievement',
                            variant: NeonButtonVariant.secondary,
                            onPressed: () => _shareAchievement(context),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: () => _retakeTest(context),
                            child: Text(
                              'Retake Test',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
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

  void _viewResults(BuildContext context) {
    // TODO: Navigate to results screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Results screen coming soon!')),
    );
  }

  void _shareAchievement(BuildContext context) {
    // TODO: Implement sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing feature coming soon!')),
    );
  }

  void _retakeTest(BuildContext context) {
    // TODO: Navigate back to test detail
    context.pop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
