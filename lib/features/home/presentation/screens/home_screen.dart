import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../widgets/test_card_new.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_access_card.dart';
import '../widgets/daily_login_bonus.dart';
import '../widgets/quick_stats_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Map<String, dynamic>> _availableTests = [];
  Map<String, dynamic> _userStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
    // Show daily login bonus on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDailyLoginBonus();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final convexService = ref.read(convexServiceProvider);

      // Load available tests from Firestore
      final tests = await firebaseService.getAvailableTests();
      _availableTests = tests.map((test) => {
        'id': test.id,
        'title': test.title,
        'description': test.description,
        'icon': _getTestIcon(test.category.name),
        'status': TestStatus.notStarted, // TODO: Check user progress
        'duration': test.durationMinutes,
        'difficulty': test.difficulty.name,
        'category': test.category.name,
      }).toList();

      // Load user stats from CONVEX
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        _userStats = await convexService.getUserStats(userId);
      }
    } catch (e) {
      print('Error loading home data: $e');
      // Fallback to mock data
      _loadMockData();
    }

    setState(() => _isLoading = false);
  }

  void _loadMockData() {
    _availableTests = [
      {
        'id': '1',
        'title': 'Vertical Jump',
        'description': 'Measure explosive power',
        'icon': Icons.arrow_upward,
        'status': TestStatus.notStarted,
        'duration': 5,
        'difficulty': 'Medium',
        'category': 'Power',
      },
      {
        'id': '2',
        'title': 'Shuttle Run',
        'description': 'Test agility and speed',
        'icon': Icons.directions_run,
        'status': TestStatus.inProgress,
        'duration': 10,
        'difficulty': 'Hard',
        'category': 'Speed',
      },
      {
        'id': '3',
        'title': 'Sit-ups',
        'description': 'Core strength assessment',
        'icon': Icons.fitness_center,
        'status': TestStatus.completed,
        'duration': 3,
        'difficulty': 'Easy',
        'category': 'Strength',
      },
      {
        'id': '4',
        'title': 'Endurance Run',
        'description': 'Cardiovascular fitness test',
        'icon': Icons.timer,
        'status': TestStatus.notStarted,
        'duration': 15,
        'difficulty': 'Hard',
        'category': 'Endurance',
      },
      {
        'id': '5',
        'title': 'Height Test',
        'description': 'Physical measurements',
        'icon': Icons.height,
        'status': TestStatus.completed,
        'duration': 2,
        'difficulty': 'Easy',
        'category': 'Physical',
      },
      {
        'id': '6',
        'title': 'Push-ups',
        'description': 'Upper body strength test',
        'icon': Icons.fitness_center,
        'status': TestStatus.notStarted,
        'duration': 5,
        'difficulty': 'Medium',
        'category': 'Strength',
      },
    ];

    _userStats = {
      'totalTests': 15,
      'averageScore': 8.4,
      'ranking': 'Top 25%',
      'badges': 5,
      'completedTests': 2,
      'totalAvailableTests': 6,
    };
  }

  IconData _getTestIcon(String category) {
    switch (category.toLowerCase()) {
      case 'speed':
        return Icons.directions_run;
      case 'power':
        return Icons.arrow_upward;
      case 'strength':
        return Icons.fitness_center;
      case 'endurance':
        return Icons.timer;
      case 'agility':
        return Icons.shuffle;
      default:
        return Icons.science;
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _showDailyLoginBonus() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DailyLoginBonus(),
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
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      SizedBox(height: AppLayout.homeScreenSpacing),
                      ProgressCard(
                        completedTests: _getCompletedTestsCount(),
                        totalTests: _getTotalTestsCount(),
                      ),
                      SizedBox(height: AppLayout.homeScreenSpacing),
                      _buildQuickAccessCards(),
                      SizedBox(height: AppLayout.homeScreenSpacing),
                      _buildTestGrid(),
                      SizedBox(height: AppLayout.homeScreenSpacing),
                      _buildQuickStats(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final authService = ref.watch(authServiceProvider);
    final user = authService.currentUser;

    return Row(
      children: [
        Expanded(
          flex: 3, // Give more space to the text
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName != null ? 'Hello, ${user!.displayName}!' : 'Hello, Athlete!',
                style: AppTypography.h2.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w600,
                  fontSize: 20, // Reduced font size to prevent overflow
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                'Ready to assess your performance?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13, // Reduced font size
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        // Demo and Daily bonus buttons
        Flexible(
          flex: 2, // Constrain button area
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Judge Demo Button
              Flexible(
                child: GestureDetector(
                  onTap: () => context.push('/demo'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced padding
                    decoration: BoxDecoration(
                      color: AppColors.royalPurple.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.royalPurple.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          color: AppColors.royalPurple,
                          size: 14, // Reduced icon size
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            'Demo',
                            style: TextStyle(
                              color: AppColors.royalPurple,
                              fontSize: 10, // Reduced font size
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6), // Reduced spacing
              // Daily bonus button
              Flexible(
                child: GestureDetector(
                  onTap: _showDailyLoginBonus,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.neonGreen.withOpacity(0.8),
                          AppColors.neonGreen.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGreen.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 14, // Reduced icon size
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            'Bonus',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10, // Reduced font size
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCards() {
    return SizedBox(
      height: 130, // Reduced height to prevent overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: AppLayout.quickAccessCardCount,
        itemBuilder: (context, index) {
          final cardData = _getQuickAccessCardData(index);
          return Container(
            width: 110, // Reduced width for better fit
            margin: EdgeInsets.only(
              right: index < AppLayout.quickAccessCardCount - 1
                  ? 12 // Consistent spacing
                  : 0,
            ),
            child: QuickAccessCard(
              title: cardData['title'] as String,
              subtitle: cardData['subtitle'] as String,
              icon: cardData['icon'] as IconData,
              color: cardData['color'] as Color,
              onTap: () => context.go(cardData['route'] as String),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Tests',
          style: AppTypography.h3.copyWith(
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Fixed to 2 columns
            crossAxisSpacing: 12.0, // Consistent spacing
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.9, // Adjusted aspect ratio to prevent overflow
          ),
          itemCount: _availableTests.isNotEmpty ? _availableTests.length.clamp(0, 6) : 6, // Use actual data or fallback
          itemBuilder: (context, index) {
            // Use available tests data if loaded, otherwise use mock data
            final testData = _availableTests.isNotEmpty && index < _availableTests.length
                ? _availableTests[index]
                : _getTestData(index);
            
            return TestCard(
              title: testData['title'] as String,
              description: testData['description'] as String,
              icon: testData['icon'] as IconData,
              status: testData['status'] as TestStatus,
              duration: testData['duration'] as int?,
              difficulty: testData['difficulty'] as String?,
              onStartTest: () => context.go('/test-detail'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return QuickStatsSection(
      stats: [
        StatItem(
          value: (_userStats['totalTests'] ?? 0).toString(),
          label: 'Tests Taken',
          subtitle: 'Total',
          color: AppColors.royalPurple,
          icon: Icons.science,
        ),
        StatItem(
          value: _userStats['ranking'] ?? 'Not ranked',
          label: 'Ranking',
          subtitle: 'National',
          color: AppColors.electricBlue,
          icon: Icons.leaderboard,
        ),
        StatItem(
          value: (_userStats['badges'] ?? 0).toString(),
          label: 'Badges',
          subtitle: 'Earned',
          color: AppColors.neonGreen,
          icon: Icons.military_tech,
        ),
      ],
    );
  }

  Map<String, dynamic> _getQuickAccessCardData(int index) {
    final cards = [
      {
        'title': 'Mentors',
        'subtitle': 'Expert Guidance',
        'icon': Icons.school,
        'color': AppLayout.quickAccessColors[0],
        'route': '/mentors',
      },
      {
        'title': 'Community',
        'subtitle': 'Connect & Share',
        'icon': Icons.chat_bubble,
        'color': AppLayout.quickAccessColors[1],
        'route': '/community',
      },
      {
        'title': 'Nutrition',
        'subtitle': 'Meal Plans',
        'icon': Icons.restaurant,
        'color': AppLayout.quickAccessColors[2],
        'route': '/nutrition',
      },
      {
        'title': 'Recovery',
        'subtitle': 'Rest & Recovery',
        'icon': Icons.spa,
        'color': AppLayout.quickAccessColors[3],
        'route': '/recovery',
      },
      {
        'title': 'Body Logs',
        'subtitle': 'Track Progress',
        'icon': Icons.track_changes,
        'color': AppLayout.quickAccessColors[4],
        'route': '/body-logs',
      },
    ];
    return cards[index];
  }

  Map<String, dynamic> _getTestData(int index) {
    final tests = [
      {
        'title': 'Vertical Jump',
        'description': 'Measure explosive power',
        'icon': Icons.arrow_upward,
        'status': TestStatus.notStarted,
        'duration': 5,
        'difficulty': 'Medium',
      },
      {
        'title': 'Shuttle Run',
        'description': 'Test agility and speed',
        'icon': Icons.directions_run,
        'status': TestStatus.inProgress,
        'duration': 10,
        'difficulty': 'Hard',
      },
      {
        'title': 'Sit-ups',
        'description': 'Core strength assessment',
        'icon': Icons.fitness_center,
        'status': TestStatus.completed,
        'duration': 3,
        'difficulty': 'Easy',
      },
      {
        'title': 'Endurance',
        'description': 'Cardiovascular fitness',
        'icon': Icons.timer,
        'status': TestStatus.notStarted,
        'duration': 15,
        'difficulty': 'Hard',
      },
      {
        'title': 'Height',
        'description': 'Physical measurements',
        'icon': Icons.height,
        'status': TestStatus.completed,
        'duration': 2,
        'difficulty': 'Easy',
      },
      {
        'title': 'Weight',
        'description': 'Body composition',
        'icon': Icons.monitor_weight,
        'status': TestStatus.notStarted,
        'duration': 2,
        'difficulty': 'Easy',
      },
    ];
    return tests[index];
  }

  int _getCompletedTestsCount() {
    if (_availableTests.isNotEmpty) {
      return _availableTests.where((test) => test['status'] == TestStatus.completed).length;
    }
    // Fallback to mock data count
    final mockTests = [
      {'status': TestStatus.notStarted},
      {'status': TestStatus.inProgress},
      {'status': TestStatus.completed},
      {'status': TestStatus.notStarted},
      {'status': TestStatus.completed},
      {'status': TestStatus.notStarted},
    ];
    return mockTests.where((test) => test['status'] == TestStatus.completed).length;
  }

  int _getTotalTestsCount() {
    if (_availableTests.isNotEmpty) {
      return _availableTests.length;
    }
    return 6; // Default number of available tests
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // Refresh data logic here
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
