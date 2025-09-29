// lib/features/test/presentation/screens/personalized_solution_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class PersonalizedSolutionScreen extends StatefulWidget {
  const PersonalizedSolutionScreen({super.key});

  @override
  State<PersonalizedSolutionScreen> createState() => _PersonalizedSolutionScreenState();
}

class _PersonalizedSolutionScreenState extends State<PersonalizedSolutionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/home'),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Your AI Analysis',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Performance Overview
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    enableNeonGlow: true,
                    neonGlowColor: AppColors.neonGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.neonGreen, AppColors.electricBlue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.analytics,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Performance Score: 8.2/10',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Excellent acceleration, room for improvement in top speed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildMetricRow('40m Time', '5.2s', 'Target: <5.0s'),
                        const SizedBox(height: 12),
                        _buildMetricRow('Acceleration', '85%', 'Excellent'),
                        const SizedBox(height: 12),
                        _buildMetricRow('Form Rating', '7.8/10', 'Good technique'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Personalized Recommendations
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personalized Recommendations',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildRecommendation(
                          'Training Focus',
                          'Incorporate more plyometric exercises to improve explosive power. Focus on hill sprints and resistance training.',
                          Icons.fitness_center,
                          AppColors.warmOrange,
                        ),
                        const SizedBox(height: 16),
                        _buildRecommendation(
                          'Technique Improvement',
                          'Work on your start position and first 10 meters. Practice with a coach to optimize your block start.',
                          Icons.school,
                          AppColors.royalPurple,
                        ),
                        const SizedBox(height: 16),
                        _buildRecommendation(
                          'Recovery Strategy',
                          'Implement active recovery with light jogging and stretching. Ensure 8 hours of sleep nightly.',
                          Icons.spa,
                          AppColors.neonGreen,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Weekly Training Plan
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '7-Day Training Plan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTrainingDay('Monday', 'Speed Work: 6x40m sprints', 'Rest 2 min between'),
                        const SizedBox(height: 12),
                        _buildTrainingDay('Tuesday', 'Strength: Squats, Deadlifts', '3 sets of 8 reps'),
                        const SizedBox(height: 12),
                        _buildTrainingDay('Wednesday', 'Recovery: Light jog + stretching', '30 minutes'),
                        const SizedBox(height: 12),
                        _buildTrainingDay('Thursday', 'Hill Sprints: 8x30m', 'Focus on form'),
                        const SizedBox(height: 12),
                        _buildTrainingDay('Friday', 'Technique Drills', 'Block starts practice'),
                        const SizedBox(height: 12),
                        _buildTrainingDay('Saturday', 'Long Run + Plyometrics', '45 minutes'),
                        const SizedBox(height: 12),
                        _buildTrainingDay('Sunday', 'Rest & Recovery', 'Active recovery only'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nutrition & Recovery
                  Row(
                    children: [
                      Expanded(
                        child: GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.restaurant,
                                color: AppColors.neonGreen,
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Nutrition',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'High protein intake, complex carbs, and adequate hydration.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary.withOpacity(0.7),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.spa,
                                color: AppColors.electricBlue,
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Recovery',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Foam rolling, ice baths, and proper sleep schedule.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary.withOpacity(0.7),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  NeonButton(
                    text: 'Start Training Plan',
                    onPressed: () => context.go('/home'),
                    size: NeonButtonSize.large,
                  ),
                  const SizedBox(height: 16),
                  NeonButton(
                    text: 'Connect with Mentor',
                    variant: NeonButtonVariant.secondary,
                    onPressed: () => context.go('/mentors'),
                  ),
                  const SizedBox(height: 16),
                  NeonButton(
                    text: 'View All Results',
                    variant: NeonButtonVariant.outline,
                    onPressed: () => context.go('/results'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, String note) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary.withOpacity(0.8),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              note,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.neonGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendation(String title, String description, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingDay(String day, String workout, String details) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
