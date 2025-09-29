// lib/features/help/presentation/screens/help_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.royalPurple, AppColors.electricBlue],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'FAQ'),
                  Tab(text: 'Guides'),
                  Tab(text: 'Contact'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFAQTab(),
                  _buildGuidesTab(),
                  _buildContactTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search FAQs...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // FAQ Items
          _buildFAQItem(
            'How do I start a fitness test?',
            'Go to the Home screen and tap on any available test card. Follow the on-screen instructions for calibration and recording.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'What equipment do I need?',
            'Most tests require only your smartphone with camera. Some advanced tests may need measuring tape or stopwatch.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'How accurate are the test results?',
            'Our AI-powered analysis provides results accurate to within 2-5% of professional testing equipment.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'Can I retake a test?',
            'Yes, you can retake any test. Previous results are saved for comparison and progress tracking.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'How do I earn credits?',
            'Complete tests, participate in challenges, and engage with the community to earn credits for store purchases.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'What is the leaderboard for?',
            'The leaderboard shows top performers across different tests and helps you track your ranking among athletes.',
          ),
        ],
      ),
    );
  }

  Widget _buildGuidesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How-to Guides',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Guide Categories
          _buildGuideCategory(
            'Getting Started',
            [
              _buildGuideItem(
                'Setting up your profile',
                'Complete your athlete profile for personalized recommendations',
                Icons.person,
                AppColors.royalPurple,
              ),
              _buildGuideItem(
                'First fitness test',
                'Learn how to perform your first test accurately',
                Icons.play_circle,
                AppColors.neonGreen,
              ),
              _buildGuideItem(
                'Understanding results',
                'How to interpret your test results and analytics',
                Icons.analytics,
                AppColors.electricBlue,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _buildGuideCategory(
            'Advanced Features',
            [
              _buildGuideItem(
                'Mentor sessions',
                'How to book and prepare for mentor sessions',
                Icons.school,
                AppColors.warmOrange,
              ),
              _buildGuideItem(
                'Community challenges',
                'Participate in community fitness challenges',
                Icons.group,
                AppColors.neonGreen,
              ),
              _buildGuideItem(
                'Store purchases',
                'How to use credits and purchase supplements',
                Icons.store,
                AppColors.royalPurple,
              ),
            ],
          ),

          const SizedBox(height: 32),
          _buildGuideCategory(
            'Troubleshooting',
            [
              _buildGuideItem(
                'Camera issues',
                'Fix common camera and recording problems',
                Icons.camera,
                AppColors.electricBlue,
              ),
              _buildGuideItem(
                'App performance',
                'Optimize app performance and battery usage',
                Icons.speed,
                AppColors.warmOrange,
              ),
              _buildGuideItem(
                'Account recovery',
                'Recover your account if you forget password',
                Icons.lock,
                AppColors.brightRed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Contact Options
          _buildContactOption(
            Icons.chat,
            'Live Chat',
            'Get instant help from our support team',
            'Available 9 AM - 9 PM IST',
            AppColors.neonGreen,
            () {},
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            Icons.email,
            'Email Support',
            'Send us a detailed message',
            'Response within 24 hours',
            AppColors.electricBlue,
            () {},
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            Icons.phone,
            'Phone Support',
            'Call our technical support',
            '+91-1800-XXX-XXXX',
            AppColors.warmOrange,
            () {},
          ),

          const SizedBox(height: 32),
          const Text(
            'Video Tutorials',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Video Tutorials
          _buildVideoTutorial(
            'Getting Started Guide',
            '5:32',
            'Learn the basics of using the app',
            AppColors.royalPurple,
          ),
          const SizedBox(height: 12),
          _buildVideoTutorial(
            'Perfect Test Recording',
            '8:15',
            'Tips for accurate test recordings',
            AppColors.neonGreen,
          ),
          const SizedBox(height: 12),
          _buildVideoTutorial(
            'Understanding Analytics',
            '6:48',
            'How to read and use your performance data',
            AppColors.electricBlue,
          ),

          const SizedBox(height: 32),
          const Text(
            'System Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // System Status
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Systems Operational',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Last updated: 2 minutes ago',
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
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCategory(String title, List<Widget> guides) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...guides,
      ],
    );
  }

  Widget _buildGuideItem(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
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
              Icons.play_arrow,
              color: color,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String title, String description,
      String availability, Color color, VoidCallback onTap) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
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
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  availability,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoTutorial(String title, String duration, String description, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.play_circle,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
