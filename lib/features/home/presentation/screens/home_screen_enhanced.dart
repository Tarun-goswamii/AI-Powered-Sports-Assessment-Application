// lib/features/home/presentation/screens/home_screen_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class HomeScreenEnhanced extends ConsumerStatefulWidget {
  const HomeScreenEnhanced({super.key});

  @override
  ConsumerState<HomeScreenEnhanced> createState() => _HomeScreenEnhancedState();
}

class _HomeScreenEnhancedState extends ConsumerState<HomeScreenEnhanced>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userName = 'Athlete'; // TODO: Get from auth provider
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            displacement: 120,
            color: AppColors.royalPurple,
            backgroundColor: AppColors.card,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: 160, // Increased for bottom nav + safe area
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: AnimationLimiter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 1000),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 80.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          const SizedBox(height: 16), // Premium top spacing
                          _buildHeader(userName),
                          const SizedBox(height: 48), // Premium section spacing
                          _buildProgressCard(),
                          const SizedBox(height: 56), // Premium section spacing
                          _buildQuickAccessCards(),
                          const SizedBox(height: 56), // Premium section spacing
                          _buildTestsGrid(),
                          const SizedBox(height: 56), // Premium section spacing
                          _buildQuickStats(),
                          const SizedBox(height: 48), // Bottom spacing
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Premium greeting with enhanced gradient animation
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.royalPurple,
                      AppColors.electricBlue,
                      AppColors.neonGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    'Hello, $userName',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Will be overridden by shader
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.card.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.4),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.royalPurple.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    'Ready to assess your performance?',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary.withOpacity(0.95),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          _buildDailyBonusButton(),
        ],
      ),
    );
  }

  Widget _buildDailyBonusButton() {
    return GestureDetector(
      onTap: _showDailyBonusDialog,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.warmOrange.withOpacity(0.9),
              AppColors.neonGreen.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warmOrange.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.neonGreen.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.celebration_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      enableNeonGlow: true,
      neonGlowColor: AppColors.royalPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Progress',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep pushing forward!',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.neonGreen.withOpacity(0.25),
                      AppColors.neonGreen.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.neonGreen.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '4/6 Complete',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.neonGreen,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          // Premium progress bar with enhanced design
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.border.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.67, // 4/6 = 67% progress
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.royalPurple,
                        AppColors.electricBlue,
                        AppColors.neonGreen,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.royalPurple.withOpacity(0.6),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '67% Complete',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.flag_rounded,
                    size: 18,
                    color: AppColors.warmOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '2 tests remaining',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.warmOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCards() {
    final cards = [
      {'title': 'Mentors', 'color': AppColors.royalPurple, 'icon': Icons.school_rounded, 'subtitle': 'Expert guidance'},
      {'title': 'Community', 'color': AppColors.electricBlue, 'icon': Icons.chat_bubble_rounded, 'subtitle': 'Connect & share'},
      {'title': 'Nutrition', 'color': AppColors.warmOrange, 'icon': Icons.restaurant_rounded, 'subtitle': 'Fuel your body'},
      {'title': 'Recovery', 'color': Color(0xFFEC4899), 'icon': Icons.spa_rounded, 'subtitle': 'Rest & recover'},
      {'title': 'Body Logs', 'color': Color(0xFF9CA3AF), 'icon': Icons.track_changes_rounded, 'subtitle': 'Track progress'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                  horizontalOffset: 80.0,
                  child: FadeInAnimation(
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(
                        right: index < cards.length - 1 ? 24 : 0,
                      ),
                      child: GlassCard(
                        padding: const EdgeInsets.all(28),
                        enableNeonGlow: true,
                        neonGlowColor: card['color'] as Color,
                        onTap: () => _onQuickAccessTap(card['title'] as String),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Premium icon with enhanced gradient background
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (card['color'] as Color).withOpacity(0.95),
                                    (card['color'] as Color).withOpacity(0.75),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: (card['color'] as Color).withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                card['icon'] as IconData,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              card['title'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              card['subtitle'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTestsGrid() {
    final tests = [
      {'id': 'vertical-jump', 'title': 'Vertical Jump', 'icon': Icons.arrow_upward_rounded, 'color': AppColors.neonGreen, 'completed': true, 'description': 'Measure explosive power'},
      {'id': 'shuttle-run', 'title': 'Shuttle Run', 'icon': Icons.directions_run_rounded, 'color': AppColors.electricBlue, 'completed': true, 'description': 'Test agility & speed'},
      {'id': 'sit-ups', 'title': 'Sit-ups', 'icon': Icons.fitness_center_rounded, 'color': AppColors.warmOrange, 'completed': true, 'description': 'Core strength assessment'},
      {'id': 'endurance', 'title': 'Endurance', 'icon': Icons.timer_rounded, 'color': AppColors.royalPurple, 'completed': true, 'description': 'Cardiovascular fitness'},
      {'id': 'height', 'title': 'Height', 'icon': Icons.height_rounded, 'color': Color(0xFF9CA3AF), 'completed': false, 'description': 'Body measurement'},
      {'id': 'weight', 'title': 'Weight', 'icon': Icons.monitor_weight_rounded, 'color': Color(0xFFEC4899), 'completed': false, 'description': 'Body composition'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Text(
            'Available Tests',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.92,
          ),
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];
            final isCompleted = test['completed'] as bool;

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 900),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: GlassCard(
                    padding: const EdgeInsets.all(28),
                    enableNeonGlow: isCompleted,
                    neonGlowColor: test['color'] as Color,
                    onTap: () => _onTestTap(test['id'] as String),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Premium icon with status indicator
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (test['color'] as Color).withOpacity(0.95),
                                    (test['color'] as Color).withOpacity(0.75),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: (test['color'] as Color).withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                test['icon'] as IconData,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            if (isCompleted)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.neonGreen,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.card,
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.neonGreen.withOpacity(0.5),
                                        blurRadius: 12,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          test['title'] as String,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          test['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        NeonButton(
                          text: isCompleted ? 'View Results' : 'Start Test',
                          size: NeonButtonSize.small,
                          onPressed: () => _onTestTap(test['id'] as String),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final stats = [
      {
        'value': '15',
        'label': 'Tests Taken',
        'color': AppColors.neonGreen,
        'icon': Icons.science_rounded,
        'subtitle': '+2 this week',
        'trend': 'up'
      },
      {
        'value': 'Top 25%',
        'label': 'Ranking',
        'color': AppColors.electricBlue,
        'icon': Icons.leaderboard_rounded,
        'subtitle': 'National rank',
        'trend': 'up'
      },
      {
        'value': '5',
        'label': 'Badges',
        'color': AppColors.warmOrange,
        'icon': Icons.military_tech_rounded,
        'subtitle': 'Achievements',
        'trend': 'up'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Text(
            'Your Performance',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Row(
          children: List.generate(stats.length, (index) {
            final stat = stats[index];
            return Expanded(
              child: AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                  horizontalOffset: 60.0,
                  child: FadeInAnimation(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < stats.length - 1 ? 20 : 0,
                      ),
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        enableNeonGlow: true,
                        neonGlowColor: stat['color'] as Color,
                        child: Column(
                          children: [
                            // Icon with gradient background
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (stat['color'] as Color).withOpacity(0.95),
                                    (stat['color'] as Color).withOpacity(0.75),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                stat['icon'] as IconData,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              stat['value'] as String,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: stat['color'] as Color,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              stat['label'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  stat['trend'] == 'up' ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                  size: 14,
                                  color: stat['trend'] == 'up' ? AppColors.neonGreen : AppColors.brightRed,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  stat['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Refresh data
  }

  void _showDailyBonusDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.warmOrange.withOpacity(0.9),
                      AppColors.neonGreen.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warmOrange.withOpacity(0.5),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.celebration_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Daily Bonus!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Claim your daily login bonus of 10 credits!',
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.textSecondary.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              NeonButton(
                text: 'Claim Bonus',
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Award credits
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQuickAccessTap(String title) {
    switch (title) {
      case 'Mentors':
        context.go('/mentors');
        break;
      case 'Community':
        context.go('/community');
        break;
      case 'Nutrition':
        context.go('/nutrition');
        break;
      case 'Recovery':
        context.go('/recovery');
        break;
      case 'Body Logs':
        context.go('/body-logs');
        break;
    }
  }

  void _onTestTap(String testId) {
    context.go('/test-detail?testId=$testId');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
