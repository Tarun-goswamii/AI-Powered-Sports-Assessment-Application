// lib/features/leaderboard/screens/dynamic_leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/dynamic_data_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/presentation/widgets/glass_card.dart';
import '../../../shared/presentation/widgets/neon_button.dart';

class DynamicLeaderboardScreen extends ConsumerStatefulWidget {
  const DynamicLeaderboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DynamicLeaderboardScreen> createState() => _DynamicLeaderboardScreenState();
}

class _DynamicLeaderboardScreenState extends ConsumerState<DynamicLeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'overall';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardAsync = ref.watch(leaderboardProvider(100));
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Leaderboard',
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.electricGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.wifi,
                      color: AppColors.electricGreen,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.electricGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [AppColors.royalPurple, AppColors.oceanBlue],
                  ),
                ),
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Global'),
                  Tab(text: 'Weekly'),
                  Tab(text: 'Monthly'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // User's Rank Card (if logged in)
            if (user != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: leaderboardAsync.when(
                  data: (leaderboard) => _buildUserRankCard(leaderboard, user.id),
                  loading: () => _buildUserRankCardSkeleton(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
              ),

            const SizedBox(height: AppSpacing.lg),

            // Leaderboard Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLeaderboardTab('global'),
                  _buildLeaderboardTab('weekly'),
                  _buildLeaderboardTab('monthly'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRankCard(List<Map<String, dynamic>> leaderboard, String userId) {
    final userRank = _findUserRank(leaderboard, userId);
    final totalUsers = leaderboard.length;
    final userScore = _getUserScore(leaderboard, userId);
    final percentile = totalUsers > 0 ? ((totalUsers - userRank + 1) / totalUsers * 100) : 0;

    return GlassCard(
      glowColor: AppColors.royalPurple,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.royalPurple, AppColors.oceanBlue],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.royalPurple.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '#$userRank',
                  style: AppTypography.headingSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Rank',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Top ${percentile.toStringAsFixed(1)}%',
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Score',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userScore.toString(),
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.electricGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRankCardSkeleton() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
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

  Widget _buildLeaderboardTab(String timeframe) {
    final leaderboardAsync = ref.watch(leaderboardProvider(100));

    return leaderboardAsync.when(
      data: (leaderboard) => _buildLeaderboardList(leaderboard),
      loading: () => _buildLeaderboardSkeleton(),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> leaderboard) {
    if (leaderboard.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.royalPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.leaderboard_outlined,
                size: 48,
                color: AppColors.royalPurple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No rankings yet',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete tests to see your ranking!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(leaderboardProvider);
      },
      color: AppColors.royalPurple,
      backgroundColor: AppColors.surfaceColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final entry = leaderboard[index];
          final rank = index + 1;
          return _buildLeaderboardItem(entry, rank);
        },
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> entry, int rank) {
    final userId = entry['userId'] as String? ?? '';
    final score = entry['totalScore'] as int? ?? 0;
    final isCurrentUser = ref.read(userProvider)?.id == userId;

    Color rankColor;
    Widget rankWidget;

    if (rank == 1) {
      rankColor = AppColors.sunsetOrange;
      rankWidget = const Icon(Icons.emoji_events, color: AppColors.sunsetOrange, size: 24);
    } else if (rank == 2) {
      rankColor = AppColors.textSecondary;
      rankWidget = const Icon(Icons.emoji_events, color: AppColors.textSecondary, size: 24);
    } else if (rank == 3) {
      rankColor = AppColors.magentaPink;
      rankWidget = const Icon(Icons.emoji_events, color: AppColors.magentaPink, size: 24);
    } else {
      rankColor = AppColors.textSecondary;
      rankWidget = Text(
        '#$rank',
        style: AppTypography.headingSmall.copyWith(
          color: rankColor,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GlassCard(
        glowColor: isCurrentUser ? AppColors.royalPurple : null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Rank
              SizedBox(
                width: 40,
                child: Center(child: rankWidget),
              ),
              const SizedBox(width: 16),
              
              // Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: isCurrentUser 
                    ? AppColors.royalPurple.withOpacity(0.2)
                    : AppColors.surfaceColor,
                child: Icon(
                  Icons.person,
                  color: isCurrentUser ? AppColors.royalPurple : AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCurrentUser ? 'You' : 'Athlete ${userId.substring(0, 8)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getPerformanceLabel(score),
                      style: AppTypography.bodySmall.copyWith(
                        color: _getPerformanceLabelColor(score),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    score.toString(),
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'points',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              // Trend indicator
              const SizedBox(width: 12),
              Icon(
                _getTrendIcon(rank),
                color: _getTrendColor(rank),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.surfaceColor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load leaderboard',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          NeonButton(
            onPressed: () => ref.invalidate(leaderboardProvider),
            variant: NeonButtonVariant.secondary,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  int _findUserRank(List<Map<String, dynamic>> leaderboard, String userId) {
    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i]['userId'] == userId) {
        return i + 1;
      }
    }
    return leaderboard.length + 1;
  }

  int _getUserScore(List<Map<String, dynamic>> leaderboard, String userId) {
    for (final entry in leaderboard) {
      if (entry['userId'] == userId) {
        return entry['totalScore'] as int? ?? 0;
      }
    }
    return 0;
  }

  String _getPerformanceLabel(int score) {
    if (score >= 500) return 'Elite Athlete';
    if (score >= 300) return 'Advanced';
    if (score >= 200) return 'Intermediate';
    if (score >= 100) return 'Beginner';
    return 'Getting Started';
  }

  Color _getPerformanceLabelColor(int score) {
    if (score >= 500) return AppColors.sunsetOrange;
    if (score >= 300) return AppColors.electricGreen;
    if (score >= 200) return AppColors.oceanBlue;
    if (score >= 100) return AppColors.royalPurple;
    return AppColors.textSecondary;
  }

  IconData _getTrendIcon(int rank) {
    if (rank <= 10) return Icons.trending_up;
    if (rank <= 50) return Icons.trending_flat;
    return Icons.trending_down;
  }

  Color _getTrendColor(int rank) {
    if (rank <= 10) return AppColors.electricGreen;
    if (rank <= 50) return AppColors.sunsetOrange;
    return AppColors.errorColor;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}