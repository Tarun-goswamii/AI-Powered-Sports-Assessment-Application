// lib/features/home/screens/dynamic_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../core/providers/dynamic_data_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/neon_button.dart';
import '../../../shared/widgets/quick_access_card.dart';
import '../../../shared/widgets/progress_card.dart';
import '../../../shared/widgets/test_card.dart';
import '../../../shared/widgets/daily_login_bonus.dart';

class DynamicHomeScreen extends ConsumerStatefulWidget {
  const DynamicHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DynamicHomeScreen> createState() => _DynamicHomeScreenState();
}

class _DynamicHomeScreenState extends ConsumerState<DynamicHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _refreshTimer;
  bool _showDailyBonus = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkDailyBonus();
    _startAutoRefresh();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _fadeController.forward();
  }

  void _checkDailyBonus() {
    // Check if user has collected daily bonus today
    // For now, show it randomly for demonstration
    if (DateTime.now().hour >= 6 && DateTime.now().hour <= 12) {
      setState(() {
        _showDailyBonus = true;
      });
    }
  }

  void _startAutoRefresh() {
    // Refresh data every 30 seconds for real-time updates
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        // Trigger provider refreshes
        ref.invalidate(globalLeaderboardProvider);
        ref.invalidate(communityPostsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final leaderboardAsync = ref.watch(globalLeaderboardProvider(50));
    final communityAsync = ref.watch(communityProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.royalPurple,
            backgroundColor: AppColors.surfaceColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.name ?? 'Athlete',
                                style: AppTypography.headingLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // Daily bonus button
                            if (_showDailyBonus)
                              GestureDetector(
                                onTap: _showDailyBonusDialog,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.sunsetOrange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.sunsetOrange.withOpacity(0.3),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.card_giftcard,
                                    color: AppColors.sunsetOrange,
                                    size: 20,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            // Notification button
                            GestureDetector(
                              onTap: () => context.push('/notifications'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.royalPurple.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.royalPurple.withOpacity(0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.royalPurple,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Progress Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: user != null
                        ? Consumer(
                            builder: (context, ref, child) {
                              final testResultsAsync = ref.watch(userTestResultsProvider(user.id));
                              return testResultsAsync.when(
                                data: (results) => ProgressCard(
                                  completedTests: results.length,
                                  totalTests: 6,
                                  progressPercentage: (results.length / 6 * 100).clamp(0, 100),
                                  onViewDetails: () => context.push('/progress'),
                                ),
                                loading: () => const ProgressCard(
                                  completedTests: 0,
                                  totalTests: 6,
                                  progressPercentage: 0,
                                ),
                                error: (error, stack) => const ProgressCard(
                                  completedTests: 0,
                                  totalTests: 6,
                                  progressPercentage: 0,
                                ),
                              );
                            },
                          )
                        : const ProgressCard(
                            completedTests: 0,
                            totalTests: 6,
                            progressPercentage: 0,
                          ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

                // Quick Access Cards
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Text(
                          'Quick Actions',
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          children: [
                            QuickAccessCard(
                              title: 'Mentors',
                              subtitle: 'Expert guidance',
                              icon: Icons.person_outline,
                              gradientColors: [
                                AppColors.royalPurple,
                                AppColors.royalPurple.withOpacity(0.7),
                              ],
                              onTap: () => context.push('/mentors'),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            QuickAccessCard(
                              title: 'Community',
                              subtitle: 'Connect & share',
                              icon: Icons.groups_outlined,
                              gradientColors: [
                                AppColors.oceanBlue,
                                AppColors.oceanBlue.withOpacity(0.7),
                              ],
                              onTap: () => context.push('/community'),
                              badge: communityAsync.posts.length > 10 ? 'New' : null,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            QuickAccessCard(
                              title: 'Leaderboard',
                              subtitle: 'Your ranking',
                              icon: Icons.leaderboard_outlined,
                              gradientColors: [
                                AppColors.electricGreen,
                                AppColors.electricGreen.withOpacity(0.7),
                              ],
                              onTap: () => context.push('/leaderboard'),
                              badge: leaderboardAsync.whenOrNull(
                                data: (data) => data.isNotEmpty ? '#${_getUserRank(data, user?.id)}' : null,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            QuickAccessCard(
                              title: 'Nutrition',
                              subtitle: 'Meal plans',
                              icon: Icons.restaurant_outlined,
                              gradientColors: [
                                AppColors.sunsetOrange,
                                AppColors.sunsetOrange.withOpacity(0.7),
                              ],
                              onTap: () => context.push('/nutrition'),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            QuickAccessCard(
                              title: 'Recovery',
                              subtitle: 'Rest & restore',
                              icon: Icons.self_improvement_outlined,
                              gradientColors: [
                                AppColors.magentaPink,
                                AppColors.magentaPink.withOpacity(0.7),
                              ],
                              onTap: () => context.push('/recovery'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

                // Test Cards Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Fitness Tests',
                                style: AppTypography.headingMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/all-tests'),
                              child: Text(
                                'View All',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.royalPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),

                // Test Cards Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                    ),
                    delegate: SliverChildListDelegate([
                      TestCard(
                        title: 'Vertical Jump',
                        subtitle: 'Explosive power',
                        icon: Icons.keyboard_double_arrow_up,
                        difficulty: 'Medium',
                        duration: '2 min',
                        points: 50,
                        status: _getTestStatus('vertical-jump', user?.id),
                        onTap: () => _startTest('vertical-jump', 'Vertical Jump'),
                      ),
                      TestCard(
                        title: 'Shuttle Run',
                        subtitle: 'Agility test',
                        icon: Icons.directions_run,
                        difficulty: 'Hard',
                        duration: '5 min',
                        points: 75,
                        status: _getTestStatus('shuttle-run', user?.id),
                        onTap: () => _startTest('shuttle-run', 'Shuttle Run'),
                      ),
                      TestCard(
                        title: 'Sit-ups',
                        subtitle: 'Core strength',
                        icon: Icons.fitness_center,
                        difficulty: 'Medium',
                        duration: '3 min',
                        points: 60,
                        status: _getTestStatus('sit-ups', user?.id),
                        onTap: () => _startTest('sit-ups', 'Sit-ups'),
                      ),
                      TestCard(
                        title: 'Push-ups',
                        subtitle: 'Upper body',
                        icon: Icons.fitness_center,
                        difficulty: 'Medium',
                        duration: '3 min',
                        points: 60,
                        status: _getTestStatus('push-ups', user?.id),
                        onTap: () => _startTest('push-ups', 'Push-ups'),
                      ),
                      TestCard(
                        title: 'Endurance Run',
                        subtitle: 'Cardio fitness',
                        icon: Icons.directions_run,
                        difficulty: 'Hard',
                        duration: '12 min',
                        points: 100,
                        status: _getTestStatus('endurance-run', user?.id),
                        onTap: () => _startTest('endurance-run', 'Endurance Run'),
                      ),
                      TestCard(
                        title: 'Flexibility',
                        subtitle: 'Range of motion',
                        icon: Icons.self_improvement,
                        difficulty: 'Easy',
                        duration: '5 min',
                        points: 40,
                        status: _getTestStatus('flexibility', user?.id),
                        onTap: () => _startTest('flexibility', 'Flexibility'),
                      ),
                    ]),
                  ),
                ),

                // Real-time Stats
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.lg),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live Stats',
                              style: AppTypography.headingMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            leaderboardAsync.when(
                              data: (leaderboard) => _buildLiveStats(leaderboard, user?.id),
                              loading: () => const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.royalPurple,
                                ),
                              ),
                              error: (error, stack) => Text(
                                'Unable to load live stats',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveStats(List<Map<String, dynamic>> leaderboard, String? userId) {
    final userRank = _getUserRank(leaderboard, userId);
    final totalUsers = leaderboard.length;
    final topPercentage = totalUsers > 0 ? ((totalUsers - userRank + 1) / totalUsers * 100).round() : 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Your Rank',
            '#$userRank',
            Icons.leaderboard,
            AppColors.royalPurple,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Top Percentile',
            '$topPercentage%',
            Icons.trending_up,
            AppColors.electricGreen,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Active Users',
            totalUsers.toString(),
            Icons.groups,
            AppColors.oceanBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  int _getUserRank(List<Map<String, dynamic>> leaderboard, String? userId) {
    if (userId == null) return leaderboard.length + 1;
    
    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i]['userId'] == userId) {
        return i + 1;
      }
    }
    return leaderboard.length + 1;
  }

  String _getTestStatus(String testId, String? userId) {
    if (userId == null) return 'not-started';
    
    // This would normally check the user's test results
    // For now, return mock status
    final completed = ['sit-ups', 'push-ups'].contains(testId);
    return completed ? 'completed' : 'not-started';
  }

  void _startTest(String testId, String testName) {
    final user = ref.read(userProvider);
    if (user == null) {
      _showLoginRequired();
      return;
    }

    context.push('/test-detail', extra: {
      'testId': testId,
      'testName': testName,
    });
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        title: const Text('Login Required', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Please log in to start taking tests and track your progress.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          NeonButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/auth');
            },
            variant: NeonButtonVariant.primary,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showDailyBonusDialog() {
    showDialog(
      context: context,
      builder: (context) => DailyLoginBonus(
        onCollect: (points) {
          setState(() {
            _showDailyBonus = false;
          });
          // Award points through service
          final user = ref.read(userProvider);
          if (user != null) {
            ref.read(integratedServiceManagerProvider).convexService.createCreditTransaction(
              userId: user.id,
              amount: points,
              type: 'daily_bonus',
              description: 'Daily login bonus',
            );
          }
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Invalidate all providers to trigger fresh data fetch
    ref.invalidate(globalLeaderboardProvider);
    ref.invalidate(communityProvider);
    
    final user = ref.read(userProvider);
    if (user != null) {
      ref.invalidate(userTestResultsProvider(user.id));
      ref.invalidate(userAchievementsProvider(user.id));
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }
}