// lib/features/test/presentation/screens/test_results_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/video_analysis_service.dart';
import '../../../../core/services/convex_http_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';


class TestResultsScreen extends StatefulWidget {
  final ExerciseMetrics results;
  final ExerciseType exerciseType;
  
  const TestResultsScreen({
    super.key,
    required this.results,
    required this.exerciseType,
  });

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  List<Map<String, dynamic>> _leaderboard = [];
  bool _isLoadingLeaderboard = true;
  int _userRank = 0;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      setState(() {
        _isLoadingLeaderboard = true;
      });

      print('Loading leaderboard from Convex...');
      // Load leaderboard data
      final leaderboardData = await ConvexHttpService().getLeaderboard(
        testType: widget.exerciseType.toString().split('.').last,
        limit: 10,
      );

      print('Loaded ${leaderboardData.length} leaderboard entries');
      
      if (mounted) {
        setState(() {
          _leaderboard = leaderboardData.map((entry) => {
            'user_name': entry['name'] ?? 'Unknown User',
            'score': (entry['totalScore'] ?? 0).toDouble(),
            'repetitions': entry['repetitions'] ?? 0,
            'avatar': _getAvatarForUser(entry['name'] ?? ''),
            'is_current_user': false,
          }).toList();
          
          // Add current user result to leaderboard
          _leaderboard.add({
            'user_name': 'You',
            'score': widget.results.overallScore,
            'repetitions': widget.results.repetitions,
            'avatar': '👤',
            'is_current_user': true,
          });
          
          // Sort by score descending
          _leaderboard.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
          
          _userRank = _calculateUserRank();
          _isLoadingLeaderboard = false;
        });
      }
    } catch (e) {
      print('Error loading leaderboard: $e');
      // Generate mock leaderboard for demo
      final mockLeaderboard = _generateMockLeaderboard();
      if (mounted) {
        setState(() {
          _leaderboard = mockLeaderboard;
          _userRank = _calculateUserRank();
          _isLoadingLeaderboard = false;
        });
      }
    }
  }

  String _getAvatarForUser(String name) {
    // Simple avatar assignment based on name
    if (name.toLowerCase().contains('alex')) return '🏆';
    if (name.toLowerCase().contains('sarah')) return '💪';
    if (name.toLowerCase().contains('mike')) return '🔥';
    if (name.toLowerCase().contains('emma')) return '⭐';
    return '🏃';
  }

  List<Map<String, dynamic>> _generateMockLeaderboard() {
    final currentScore = widget.results.overallScore;
    return [
      {
        'user_name': 'Alex Champion',
        'score': 95.2,
        'repetitions': widget.results.repetitions + 5,
        'avatar': '🏆',
      },
      {
        'user_name': 'Sarah Strong',
        'score': 92.8,
        'repetitions': widget.results.repetitions + 3,
        'avatar': '💪',
      },
      {
        'user_name': 'Mike Muscle',
        'score': 90.1,
        'repetitions': widget.results.repetitions + 2,
        'avatar': '🔥',
      },
      {
        'user_name': 'You',
        'score': currentScore,
        'repetitions': widget.results.repetitions,
        'avatar': '👤',
        'is_current_user': true,
      },
      {
        'user_name': 'Jenny Fit',
        'score': currentScore - 5.2,
        'repetitions': widget.results.repetitions - 1,
        'avatar': '⭐',
      },
      {
        'user_name': 'Tom Trainer',
        'score': currentScore - 8.1,
        'repetitions': widget.results.repetitions - 2,
        'avatar': '💫',
      },
    ]..sort((a, b) => b['score'].compareTo(a['score']));
  }

  int _calculateUserRank() {
    for (int i = 0; i < _leaderboard.length; i++) {
      if (_leaderboard[i]['is_current_user'] == true) {
        return i + 1;
      }
    }
    return _leaderboard.length;
  }

  String _getPerformanceMessage() {
    final score = widget.results.overallScore;
    if (score >= 90) return 'Outstanding! You\'re in elite form! 🏆';
    if (score >= 80) return 'Excellent work! Keep pushing! 💪';
    if (score >= 70) return 'Great job! You\'re getting stronger! 🔥';
    if (score >= 60) return 'Good effort! Keep training! ⭐';
    return 'Nice start! Every rep counts! 💫';
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  Widget _buildMetricCard(String title, double value, String unit, IconData icon, Color color) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> entry, int rank) {
    final isCurrentUser = entry['is_current_user'] == true;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GlassCard(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: isCurrentUser
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 2),
                )
              : null,
          child: Row(
            children: [
              // Rank
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: rank <= 3 
                      ? (rank == 1 ? Colors.amber : rank == 2 ? Colors.grey[400] : Colors.brown[300])
                      : AppColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    rank.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Avatar
              Text(
                entry['avatar'] ?? '👤',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              
              // Name and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry['user_name'] ?? 'Unknown',
                      style: TextStyle(
                        color: isCurrentUser ? AppColors.primary : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${entry['repetitions'] ?? 0} reps',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Score
              Text(
                '${(entry['score'] ?? 0).toStringAsFixed(1)}',
                style: TextStyle(
                  color: _getScoreColor(entry['score'] ?? 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Test Results',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Share results
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Performance Summary
                      GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                VideoAnalysisService.getExerciseName(widget.exerciseType),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Overall Score Circle
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      _getScoreColor(widget.results.overallScore),
                                      _getScoreColor(widget.results.overallScore).withOpacity(0.6),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.results.overallScore.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'SCORE',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              Text(
                                _getPerformanceMessage(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              
                              Text(
                                'Rank: #$_userRank worldwide',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Detailed Metrics
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildMetricCard(
                            'Repetitions',
                            widget.results.repetitions.toDouble(),
                            'reps',
                            Icons.repeat,
                            AppColors.primary,
                          ),
                          _buildMetricCard(
                            'Accuracy',
                            widget.results.accuracy,
                            '%',
                            Icons.gps_fixed,
                            Colors.green,
                          ),
                          _buildMetricCard(
                            'Speed',
                            widget.results.speed,
                            'score',
                            Icons.speed,
                            Colors.orange,
                          ),
                          _buildMetricCard(
                            'Form',
                            widget.results.form,
                            'score',
                            Icons.fitness_center,
                            Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Leaderboard
                      GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Global Leaderboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              if (_isLoadingLeaderboard)
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                              else
                                Column(
                                  children: _leaderboard
                                      .asMap()
                                      .entries
                                      .map((entry) => _buildLeaderboardItem(
                                            entry.value,
                                            entry.key + 1,
                                          ))
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/home'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Take Another Test',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}