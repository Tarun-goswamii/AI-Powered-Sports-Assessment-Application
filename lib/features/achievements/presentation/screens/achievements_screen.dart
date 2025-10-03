// lib/features/achievements/presentation/screens/achievements_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/utils/responsive_utils.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
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
    final responsive = ResponsiveUtils(context);
    return Container(
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
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.card.withOpacity(0.5),
                      padding: EdgeInsets.all(responsive.wp(3)),
                    ),
                  ),
                  SizedBox(width: responsive.wp(4)),
                  Expanded(
                    child: Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: responsive.sp(28),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Stats Overview
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard('47', 'Unlocked', AppColors.neonGreen),
                  ),
                  SizedBox(width: responsive.wp(4)),
                  Expanded(
                    child: _buildStatCard('23', 'In Progress', AppColors.warmOrange),
                  ),
                  SizedBox(width: responsive.wp(4)),
                  Expanded(
                    child: _buildStatCard('18', 'Locked', AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.hp(3)),

            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.3),
                borderRadius: BorderRadius.circular(responsive.wp(3)),
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
                  Tab(text: 'All'),
                  Tab(text: 'Unlocked'),
                  Tab(text: 'In Progress'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllAchievementsTab(),
                  _buildUnlockedAchievementsTab(),
                  _buildInProgressAchievementsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
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

  Widget _buildAllAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Sprint Master',
            'Complete 10 sprint tests with 5.0s or better',
            '8/10 completed',
            AppColors.neonGreen,
            true,
            true,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Consistency King',
            'Complete tests for 30 consecutive days',
            '15/30 completed',
            AppColors.warmOrange,
            false,
            true,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Vertical Jump Pro',
            'Achieve 80cm+ vertical jump',
            'Locked',
            AppColors.textSecondary,
            false,
            false,
          ),

          const SizedBox(height: 32),
          const Text(
            'Community Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Social Butterfly',
            'Post 50 times in community',
            '32/50 completed',
            AppColors.electricBlue,
            false,
            true,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Mentor Helper',
            'Help 10 fellow athletes',
            '7/10 completed',
            AppColors.royalPurple,
            false,
            true,
          ),

          const SizedBox(height: 32),
          const Text(
            'Store Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Shopaholic',
            'Spend 5000 credits in store',
            '2500/5000 credits',
            AppColors.warmOrange,
            false,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockedAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unlocked Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'First Steps',
            'Complete your first test',
            'Unlocked!',
            AppColors.neonGreen,
            true,
            false,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Speed Demon',
            'Achieve 5.5s or better in 40m sprint',
            'Unlocked!',
            AppColors.neonGreen,
            true,
            false,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Regular Athlete',
            'Complete tests for 7 consecutive days',
            'Unlocked!',
            AppColors.neonGreen,
            true,
            false,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Community Member',
            'Join your first community group',
            'Unlocked!',
            AppColors.neonGreen,
            true,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'In Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Sprint Master',
            'Complete 10 sprint tests with 5.0s or better',
            '8/10 completed',
            AppColors.neonGreen,
            true,
            true,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Consistency King',
            'Complete tests for 30 consecutive days',
            '15/30 completed',
            AppColors.warmOrange,
            false,
            true,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Social Butterfly',
            'Post 50 times in community',
            '32/50 completed',
            AppColors.electricBlue,
            false,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, String description, String progress,
      Color color, bool isUnlocked, bool isInProgress) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: isUnlocked
                  ? LinearGradient(
                      colors: [color, color.withOpacity(0.6)],
                    )
                  : null,
              color: isUnlocked ? null : AppColors.card.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnlocked ? Colors.transparent : AppColors.border,
                width: 2,
              ),
            ),
            child: Icon(
              isUnlocked ? Icons.emoji_events : Icons.lock,
              color: isUnlocked ? Colors.white : AppColors.textSecondary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  progress,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isInProgress) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _getProgressValue(progress),
                    backgroundColor: AppColors.card.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ],
            ),
          ),
          if (isUnlocked)
            Icon(
              Icons.check_circle,
              color: color,
              size: 24,
            ),
        ],
      ),
    );
  }

  double _getProgressValue(String progress) {
    if (progress.contains('/')) {
      final parts = progress.split('/');
      if (parts.length == 2) {
        final current = double.tryParse(parts[0]) ?? 0;
        final total = double.tryParse(parts[1]) ?? 1;
        return current / total;
      }
    }
    return 0.0;
  }
}
