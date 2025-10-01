// lib/features/home/screens/fixed_enhanced_home.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../../../shared/presentation/widgets/glass_card.dart';
import '../../../shared/presentation/widgets/animated_progress_card.dart';
import '../../../shared/presentation/widgets/daily_bonus_dialog.dart';

class FixedEnhancedHome extends ConsumerStatefulWidget {
  const FixedEnhancedHome({Key? key}) : super(key: key);

  @override
  ConsumerState<FixedEnhancedHome> createState() => _FixedEnhancedHomeState();
}

class _FixedEnhancedHomeState extends ConsumerState<FixedEnhancedHome>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _fadeController.forward();
    
    // Check for daily bonus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDailyBonus();
    });
  }

  void _checkDailyBonus() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    final shouldShow = await authNotifier.shouldShowDailyBonus();
    
    if (shouldShow && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DailyBonusDialog(
          onClaimBonus: () {
            // Handle bonus claiming logic here
            // e.g., update user XP, show success message
          },
          onClose: () {
            // Dialog closes automatically
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userData = authState.userData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Header
                _buildHeader(userData),
                const SizedBox(height: 24),
                
                // Progress Cards
                _buildProgressSection(userData),
                const SizedBox(height: 24),
                
                // Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/assessment'),
        backgroundColor: AppColors.royalPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic>? userData) {
    final userName = userData?['name'] ?? 'Athlete';
    final userLevel = userData?['level'] ?? 1;
    final userXP = userData?['experiencePoints'] ?? 0;

    return InteractiveGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.royalPurple,
                      AppColors.electricBlue,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.royalPurple.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: userData?['profilePicture'] != null
                    ? ClipOval(
                        child: Image.network(
                          userData!['profilePicture'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextTheme.secondaryText(
                      'Welcome back,',
                      fontSize: 14,
                    ),
                    const SizedBox(height: 4),
                    AppTextTheme.primaryText(
                      userName,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.royalPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.royalPurple.withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.royalPurple,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level $userLevel',
                    style: AppTextTheme.h4.copyWith(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppTextTheme.secondaryText(
                    '$userXP XP',
                    fontSize: 14,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildXPProgressBar(userXP),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildXPProgressBar(int xp) {
    final currentLevelXP = xp % 1000; // Assuming 1000 XP per level
    final progress = currentLevelXP / 1000.0;

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonGreen,
                    AppColors.electricBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(Map<String, dynamic>? userData) {
    final assessments = userData?['assessmentsCompleted'] ?? 0;
    final skills = userData?['skillsImproved'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextTheme.primaryText(
          'Your Progress',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AnimatedProgressCard(
                title: '$assessments',
                subtitle: 'Assessments',
                progress: assessments / 10.0,
                icon: Icons.sports_score,
                color: AppColors.electricBlue,
                onTap: () => context.push('/assessments'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedProgressCard(
                title: '$skills',
                subtitle: 'Skills Improved',
                progress: skills / 20.0,
                icon: Icons.trending_up,
                color: AppColors.neonGreen,
                onTap: () => context.push('/skills'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextTheme.primaryText(
          'Quick Actions',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              Icons.sports_martial_arts,
              'New Assessment',
              'Start evaluation',
              AppColors.royalPurple,
              () => context.push('/assessment'),
            ),
            _buildActionCard(
              Icons.people,
              'Find Mentors',
              'Connect with experts',
              AppColors.electricBlue,
              () => context.push('/mentors'),
            ),
            _buildActionCard(
              Icons.forum,
              'Community',
              'Join discussions',
              AppColors.neonGreen,
              () => context.push('/community'),
            ),
            _buildActionCard(
              Icons.analytics,
              'Analytics',
              'View your stats',
              AppColors.warmOrange,
              () => context.push('/analytics'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return InteractiveGlassCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.3),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          AppTextTheme.primaryText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          AppTextTheme.secondaryText(
            subtitle,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}