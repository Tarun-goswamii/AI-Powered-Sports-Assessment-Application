// lib/features/community/presentation/screens/community_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/enhanced_neon_button.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
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
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.card.withOpacity(0.5),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/leaderboard'),
                    icon: const Icon(Icons.leaderboard, color: Colors.white),
                  ),
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
                  Tab(text: 'Feed'),
                  Tab(text: 'Challenges'),
                  Tab(text: 'Groups'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFeedTab(),
                  _buildChallengesTab(),
                  _buildGroupsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create Post Button
          EnhancedNeonButton(
            text: '+ Share Your Achievement',
            onPressed: () {},
            size: NeonButtonSize.medium,
          ),
          const SizedBox(height: 24),

          // Posts
          _buildPost(
            'Rahul Sharma',
            'Just completed my 40m sprint test! 5.1 seconds - personal best! 🏃‍♂️',
            '2 hours ago',
            24,
            8,
            AppColors.neonGreen,
          ),
          const SizedBox(height: 16),
          _buildPost(
            'Priya Patel',
            'Vertical jump improved by 5cm this week! Thanks to the training plan. 💪',
            '4 hours ago',
            18,
            12,
            AppColors.electricBlue,
          ),
          const SizedBox(height: 16),
          _buildPost(
            'Amit Kumar',
            'Anyone up for a community challenge? Let\'s see who can improve their agility test the most!',
            '6 hours ago',
            32,
            15,
            AppColors.warmOrange,
          ),
          const SizedBox(height: 16),
          _buildPost(
            'Sneha Reddy',
            'Nutrition tip: Complex carbs before workouts give you sustained energy. Try sweet potatoes! 🥔',
            '8 hours ago',
            41,
            22,
            AppColors.royalPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Challenges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Challenge Cards
          _buildChallengeCard(
            'Monthly Sprint Challenge',
            'Beat your personal best in 40m sprint',
            'Ends in 12 days',
            156,
            AppColors.neonGreen,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            'Strength Building',
            'Max push-ups in 1 minute',
            'Ends in 18 days',
            89,
            AppColors.electricBlue,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            'Endurance Run',
            'Longest distance in 30 minutes',
            'Ends in 25 days',
            203,
            AppColors.warmOrange,
          ),

          const SizedBox(height: 32),
          const Text(
            'Completed Challenges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildCompletedChallenge('Agility Master', 'Top 10% in agility test', AppColors.royalPurple),
          const SizedBox(height: 12),
          _buildCompletedChallenge('Speed Demon', 'Sub 5.0s in 40m sprint', AppColors.neonGreen),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sports Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Groups
          _buildGroupCard(
            'Sprinters Club',
            'For all sprint enthusiasts',
            1247,
            true,
            AppColors.neonGreen,
          ),
          const SizedBox(height: 16),
          _buildGroupCard(
            'Strength Training',
            'Build power and muscle',
            892,
            true,
            AppColors.electricBlue,
          ),
          const SizedBox(height: 16),
          _buildGroupCard(
            'Endurance Athletes',
            'Long distance runners',
            654,
            false,
            AppColors.warmOrange,
          ),
          const SizedBox(height: 16),
          _buildGroupCard(
            'Youth Athletes',
            'Under 18 competitive athletes',
            432,
            true,
            AppColors.royalPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildPost(String author, String content, String time, int likes, int comments, Color accentColor) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: accentColor.withOpacity(0.2),
                child: Text(
                  author[0],
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      time,
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
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              Text(
                '$likes',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.comment_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              Text(
                '$comments',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(String title, String description, String timeLeft, int participants, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeLeft,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$participants participants',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EnhancedNeonButton(
            text: 'Join Challenge',
            onPressed: () {},
            size: NeonButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedChallenge(String title, String achievement, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events,
            color: color,
            size: 24,
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
                  achievement,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(String name, String description, int members, bool isJoined, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.group,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
                Text(
                  '$members members',
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          EnhancedNeonButton(
            text: isJoined ? 'Joined' : 'Join',
            onPressed: () {},
            size: NeonButtonSize.small,
            variant: isJoined ? NeonButtonVariant.outlined : NeonButtonVariant.filled,
          ),
        ],
      ),
    );
  }
}
