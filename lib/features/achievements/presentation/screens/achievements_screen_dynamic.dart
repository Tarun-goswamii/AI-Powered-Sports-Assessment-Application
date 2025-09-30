import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _allAchievements = [];
  List<Map<String, dynamic>> _userAchievements = [];
  Map<String, dynamic> _userStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final convexService = ref.read(convexServiceProvider);
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid;

      if (userId != null) {
        // Load user achievements and stats
        _userAchievements = await convexService.getUserAchievements(userId);
        _userStats = await convexService.getUserStats(userId);
      }

      // Load all available achievements
      _allAchievements = await convexService.getAllAchievements();
    } catch (e) {
      print('Error loading achievements data: $e');
      // Fallback to empty lists
      _allAchievements = [];
      _userAchievements = [];
      _userStats = {'totalTests': 0, 'completedTests': 0, 'averageScore': 0, 'achievements': 0};
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: const SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final unlockedCount = _userAchievements.length;
    final inProgressCount = _calculateInProgressCount();
    final lockedCount = _allAchievements.length - unlockedCount - inProgressCount;

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
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.card.withOpacity(0.5),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 28,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(unlockedCount.toString(), 'Unlocked', AppColors.neonGreen),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(inProgressCount.toString(), 'In Progress', AppColors.warmOrange),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(lockedCount.toString(), 'Locked', AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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

  int _calculateInProgressCount() {
    // Simple calculation - in real app, this would be more sophisticated
    // For now, assume some achievements are in progress based on user stats
    final totalTests = _userStats['totalTests'] ?? 0;
    if (totalTests > 0 && totalTests < 10) return 2;
    if (totalTests >= 10 && totalTests < 30) return 3;
    return 1;
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
            'All Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          if (_allAchievements.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'No achievements available yet.',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ..._allAchievements.map((achievement) {
              final isUnlocked = _userAchievements.any((ua) => ua['achievementId'] == achievement['id']);
              final progress = _calculateAchievementProgress(achievement);
              final isInProgress = progress > 0 && progress < 1;

              return Column(
                children: [
                  _buildAchievementCard(
                    achievement['title'] ?? 'Unknown Achievement',
                    achievement['description'] ?? '',
                    _formatProgress(progress, achievement),
                    _getAchievementColor(achievement['category']),
                    isUnlocked,
                    isInProgress,
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildUnlockedAchievementsTab() {
    final unlockedAchievements = _allAchievements.where((achievement) {
      return _userAchievements.any((ua) => ua['achievementId'] == achievement['id']);
    }).toList();

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

          if (unlockedAchievements.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'No achievements unlocked yet. Keep testing!',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...unlockedAchievements.map((achievement) => Column(
              children: [
                _buildAchievementCard(
                  achievement['title'] ?? 'Unknown Achievement',
                  achievement['description'] ?? '',
                  'Unlocked!',
                  _getAchievementColor(achievement['category']),
                  true,
                  false,
                ),
                const SizedBox(height: 16),
              ],
            )),
        ],
      ),
    );
  }

  Widget _buildInProgressAchievementsTab() {
    final inProgressAchievements = _allAchievements.where((achievement) {
      final progress = _calculateAchievementProgress(achievement);
      final isUnlocked = _userAchievements.any((ua) => ua['achievementId'] == achievement['id']);
      return !isUnlocked && progress > 0;
    }).toList();

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

          if (inProgressAchievements.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'No achievements in progress. Start testing to unlock achievements!',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...inProgressAchievements.map((achievement) {
              final progress = _calculateAchievementProgress(achievement);
              return Column(
                children: [
                  _buildAchievementCard(
                    achievement['title'] ?? 'Unknown Achievement',
                    achievement['description'] ?? '',
                    _formatProgress(progress, achievement),
                    _getAchievementColor(achievement['category']),
                    false,
                    true,
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
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

  double _calculateAchievementProgress(Map<String, dynamic> achievement) {
    // Simple progress calculation based on user stats
    // In a real app, this would be more sophisticated
    final totalTests = _userStats['totalTests'] ?? 0;
    final achievementId = achievement['id'];

    switch (achievementId) {
      case 'first_test':
        return totalTests >= 1 ? 1.0 : 0.0;
      case 'speed_demon':
        return totalTests >= 5 ? 1.0 : totalTests / 5.0;
      case 'consistency_master':
        return totalTests >= 30 ? 1.0 : totalTests / 30.0;
      default:
        return totalTests > 0 ? 0.5 : 0.0; // Partial progress for others
    }
  }

  String _formatProgress(double progress, Map<String, dynamic> achievement) {
    if (progress >= 1.0) return 'Unlocked!';
    if (progress <= 0.0) return 'Locked';

    final totalTests = _userStats['totalTests'] ?? 0;
    final achievementId = achievement['id'];

    switch (achievementId) {
      case 'consistency_master':
        return '${totalTests.toInt()}/30 completed';
      case 'speed_demon':
        return '${totalTests.toInt()}/5 completed';
      default:
        return '${(progress * 100).toInt()}% complete';
    }
  }

  Color _getAchievementColor(String? category) {
    switch (category) {
      case 'performance': return AppColors.neonGreen;
      case 'community': return AppColors.electricBlue;
      case 'store': return AppColors.warmOrange;
      default: return AppColors.royalPurple;
    }
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
    if (progress.contains('%')) {
      final percentStr = progress.replaceAll('%', '');
      final percent = double.tryParse(percentStr) ?? 0;
      return percent / 100.0;
    }
    return 0.0;
  }
}
