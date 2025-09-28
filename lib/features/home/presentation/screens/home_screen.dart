// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
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
      duration: const Duration(milliseconds: 300),
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

  @override
  Widget build(BuildContext context) {
    final userName = 'Athlete'; // TODO: Get from auth provider

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
              padding: const EdgeInsets.only(bottom: 100),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(userName),
                      _buildProgressCard(),
                      _buildQuickAccessCards(),
                      _buildTestsGrid(),
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

  Widget _buildHeader(String userName) {
    return Padding(
      padding: AppSpacing.paddingHorizontalMedium,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ready to assess your performance?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildDailyBonusButton(),
        ],
      ),
    );
  }

  Widget _buildDailyBonusButton() {
    return GestureDetector(
      onTap: _showDailyBonusDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x33FFC107),
          border: Border.all(color: const Color(0x4DFFC107)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          '🎁 Test Bonus',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFFFFC107),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Padding(
      padding: AppSpacing.paddingHorizontalMedium,
      child: GlassCard(
        padding: AppSpacing.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Test Progress',
                  style: AppTypography.h3,
                ),
                Text(
                  '4/6 Complete',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.67, // 4/6 = 67% progress
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppGradients.purpleBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCards() {
    final cards = [
      {'title': 'Mentors', 'color': AppColors.royalPurple, 'icon': Icons.school},
      {'title': 'Community', 'color': AppColors.electricBlue, 'icon': Icons.chat_bubble},
      {'title': 'Nutrition', 'color': AppColors.warmOrange, 'icon': Icons.restaurant},
      {'title': 'Recovery', 'color': Color(0xFFEC4899), 'icon': Icons.spa},
      {'title': 'Body Logs', 'color': Color(0xFF9CA3AF), 'icon': Icons.track_changes},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.paddingHorizontalMedium,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            child: GlassCard(
              padding: AppSpacing.paddingSmall,
              enableNeonGlow: true,
              neonGlowColor: card['color'] as Color,
              onTap: () => _onQuickAccessTap(card['title'] as String),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    card['icon'] as IconData,
                    size: 32,
                    color: card['color'] as Color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card['title'] as String,
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestsGrid() {
    final tests = [
      {'id': 'vertical-jump', 'title': 'Vertical Jump', 'icon': Icons.arrow_upward},
      {'id': 'shuttle-run', 'title': 'Shuttle Run', 'icon': Icons.directions_run},
      {'id': 'sit-ups', 'title': 'Sit-ups', 'icon': Icons.fitness_center},
      {'id': 'endurance', 'title': 'Endurance', 'icon': Icons.timer},
      {'id': 'height', 'title': 'Height', 'icon': Icons.height},
      {'id': 'weight', 'title': 'Weight', 'icon': Icons.monitor_weight},
    ];

    return Padding(
      padding: AppSpacing.paddingHorizontalMedium,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          final test = tests[index];
          return GlassCard(
            padding: AppSpacing.paddingMedium,
            onTap: () => _onTestTap(test['id'] as String),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppGradients.purpleBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    test['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  test['title'] as String,
                  style: AppTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                NeonButton(
                  text: 'Start Test',
                  size: NeonButtonSize.small,
                  onPressed: () => _onTestTap(test['id'] as String),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: AppSpacing.paddingHorizontalMedium,
      child: Row(
        children: [
          Expanded(
            child: GlassCard(
              padding: AppSpacing.paddingSmall,
              child: Column(
                children: [
                  Text(
                    '15',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.neonGreen,
                    ),
                  ),
                  Text(
                    'Tests Taken',
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GlassCard(
              padding: AppSpacing.paddingSmall,
              child: Column(
                children: [
                  Text(
                    'Top 25%',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.electricBlue,
                    ),
                  ),
                  Text(
                    'Ranking',
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GlassCard(
              padding: AppSpacing.paddingSmall,
              child: Column(
                children: [
                  Text(
                    '5',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.warmOrange,
                    ),
                  ),
                  Text(
                    'Badges',
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Refresh data
  }

  void _showDailyBonusDialog() {
    // TODO: Show daily bonus modal
  }

  void _onQuickAccessTap(String title) {
    // TODO: Navigate to feature
  }

  void _onTestTap(String testId) {
    // TODO: Navigate to test detail
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
