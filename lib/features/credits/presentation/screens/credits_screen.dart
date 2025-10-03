// lib/features/credits/presentation/screens/credits_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/settings'),
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: responsive.sp(24)),
                  ),
                  Expanded(
                    child: Text(
                      'About & Credits',
                      style: TextStyle(
                        fontSize: responsive.sp(28),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: responsive.wp(12)), // Balance the back button
                ],
              ),
              SizedBox(height: responsive.hp(3)),

              // App Logo and Info
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.royalPurple, AppColors.electricBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'AI Sports Assessment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Revolutionizing sports talent assessment with AI-powered precision and comprehensive athlete development tools.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Key Features
              const Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                Icons.camera,
                'AI-Powered Test Recording',
                'Advanced computer vision for accurate fitness test analysis',
                AppColors.neonGreen,
              ),
              _buildFeatureItem(
                Icons.analytics,
                'Comprehensive Analytics',
                'Detailed performance insights and progress tracking',
                AppColors.electricBlue,
              ),
              _buildFeatureItem(
                Icons.group,
                'Community Platform',
                'Connect with fellow athletes and share achievements',
                AppColors.royalPurple,
              ),
              _buildFeatureItem(
                Icons.school,
                'Expert Mentorship',
                'Access to professional coaches and nutritionists',
                AppColors.warmOrange,
              ),

              const SizedBox(height: 32),

              // Technology Stack
              const Text(
                'Technology Stack',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTechItem('Flutter', 'Cross-platform mobile framework', AppColors.electricBlue),
                    const SizedBox(height: 12),
                    _buildTechItem('Dart', 'Programming language', AppColors.royalPurple),
                    const SizedBox(height: 12),
                    _buildTechItem('Convex', 'Backend as a Service', AppColors.neonGreen),
                    const SizedBox(height: 12),
                    _buildTechItem('TensorFlow Lite', 'AI/ML inference', AppColors.warmOrange),
                    const SizedBox(height: 12),
                    _buildTechItem('Camera Plugin', 'Native camera integration', AppColors.royalPurple),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Team Credits
              const Text(
                'Development Team',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildTeamMember(
                'Lead Developer',
                'AI Sports Team',
                'Full-stack development and AI integration',
                AppColors.neonGreen,
              ),
              const SizedBox(height: 12),
              _buildTeamMember(
                'UI/UX Designer',
                'Design Team',
                'User experience and interface design',
                AppColors.electricBlue,
              ),
              const SizedBox(height: 12),
              _buildTeamMember(
                'Sports Scientist',
                'Dr. Sports Lab',
                'Fitness testing protocols and validation',
                AppColors.royalPurple,
              ),

              const SizedBox(height: 32),

              // Acknowledgments
              const Text(
                'Acknowledgments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Special Thanks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Indian Sports Federations for collaboration and validation\n• Beta testers and early adopters\n• Open source community for amazing tools\n• Flutter and Convex teams for excellent frameworks',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Contact Information
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildContactItem(
                      Icons.email,
                      'support@aisports.in',
                      'General inquiries and support',
                      AppColors.electricBlue,
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      Icons.business,
                      'AI Sports Assessment Pvt Ltd',
                      'Mumbai, Maharashtra, India',
                      AppColors.royalPurple,
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      Icons.web,
                      'www.aisports.in',
                      'Visit our website',
                      AppColors.neonGreen,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Legal
              const Text(
                'Legal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildLegalItem('Privacy Policy', 'How we protect your data'),
              _buildLegalItem('Terms of Service', 'User agreement and conditions'),
              _buildLegalItem('Data Processing', 'Information about data usage'),

              const SizedBox(height: 40),

              // Social Links
              const Text(
                'Follow Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(Icons.facebook, AppColors.electricBlue),
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.camera_alt, AppColors.neonGreen), // Instagram
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.alternate_email, AppColors.royalPurple), // Twitter
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.play_arrow, AppColors.warmOrange), // YouTube
                ],
              ),

              const SizedBox(height: 40),

              // Copyright
              Center(
                child: Text(
                  '© 2025 AI Sports Assessment. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
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
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechItem(String name, String description, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(String role, String name, String description, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              Icons.person,
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
                  role,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
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
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}
