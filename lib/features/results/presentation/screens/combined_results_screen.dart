import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../widgets/analytics_charts.dart';

class CombinedResultsScreen extends ConsumerStatefulWidget {
  const CombinedResultsScreen({super.key});

  @override
  ConsumerState<CombinedResultsScreen> createState() => _CombinedResultsScreenState();
}

class _CombinedResultsScreenState extends ConsumerState<CombinedResultsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _userStats;
  List<Map<String, dynamic>> _testResults = [];
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
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        final convexService = ref.read(convexServiceProvider);

        // Load user stats
        final stats = await convexService.getUserStats(userId);
        // Load test results
        final results = await convexService.getTestResults(userId);

        if (mounted) {
          setState(() {
            _userStats = stats;
            _testResults = results;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print('Error loading results data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                      'My Results',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/achievements'),
                    icon: const Icon(Icons.emoji_events, color: Colors.white),
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
                  Tab(text: 'Overview'),
                  Tab(text: 'Tests'),
                  Tab(text: 'Analytics'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildTestsTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Summary
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildStatRow('Total Tests Completed', '${_userStats?['totalTests'] ?? 0}'),
                const SizedBox(height: 12),
                _buildStatRow('Average Score', '${(_userStats?['averageScore'] ?? 0.0).toStringAsFixed(1)}/10'),
                const SizedBox(height: 12),
                _buildStatRow('Ranking', _userStats?['ranking'] ?? 'Not ranked'),
                const SizedBox(height: 12),
                _buildStatRow('Improvement Rate', '+${_calculateImprovementRate()}%'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent Tests
          const Text(
            'Recent Tests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ..._testResults.take(3).map((result) => Column(
            children: [
              _buildRecentTestCard(
                result['testId'] ?? 'Unknown Test',
                '${result['score'] ?? 0}',
                _formatDate(result['completedAt']),
                _getScoreColor((result['score'] ?? 0).round()),
              ),
              const SizedBox(height: 12),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildTestsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Test History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ..._testResults.map((result) => Column(
            children: [
              _buildTestHistoryItem(
                result['testId'] ?? 'Unknown Test',
                '${result['score'] ?? 0}',
                _getRatingText((result['score'] ?? 0).round()),
                _formatDate(result['completedAt']),
                _getScoreColor((result['score'] ?? 0).round()),
              ),
              const SizedBox(height: 12),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Progress Over Time Line Chart
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress Over Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                PerformanceLineChart(testResults: _testResults),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Performance by Sport - Pie Chart
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score distribution across sports',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                PerformancePieChart(testResults: _testResults),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Average Scores by Sport - Bar Chart
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Average Scores by Sport',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Compare your performance across different sports',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                SportPerformanceBar(testResults: _testResults),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Strengths & Weaknesses
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        color: AppColors.neonGreen,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Strengths',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStrengthsText(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
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
                        Icons.thumb_down,
                        color: AppColors.brightRed,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Areas to Improve',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getWeaknessesText(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateImprovementRate() {
    if (_testResults.length < 2) return '0';
    // Simple calculation: compare first and last scores
    final firstScore = _testResults.last['score'] ?? 0;
    final lastScore = _testResults.first['score'] ?? 0;
    if (firstScore == 0) return '0';
    final improvement = ((lastScore - firstScore) / firstScore * 100).round();
    return improvement.toString();
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp as int);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return AppColors.neonGreen;
    if (score >= 6) return AppColors.electricBlue;
    if (score >= 4) return AppColors.warmOrange;
    return AppColors.brightRed;
  }

  String _getRatingText(int score) {
    if (score >= 9) return 'Excellent';
    if (score >= 8) return 'Very Good';
    if (score >= 7) return 'Good';
    if (score >= 6) return 'Average';
    if (score >= 4) return 'Below Average';
    return 'Needs Improvement';
  }

  String _getStrengthsText() {
    final avgScore = _userStats?['averageScore'] ?? 0.0;
    if (avgScore >= 8.0) return 'Speed, Power, Consistency';
    if (avgScore >= 6.0) return 'Technique, Endurance';
    return 'Determination, Participation';
  }

  String _getWeaknessesText() {
    final avgScore = _userStats?['averageScore'] ?? 0.0;
    if (avgScore < 6.0) return 'Speed, Power, Technique';
    if (avgScore < 8.0) return 'Consistency, Recovery';
    return 'Advanced Training Focus';
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTestCard(String testName, String result, String date, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            result,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestHistoryItem(String testName, String result, String rating, String date, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                result,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                rating,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
