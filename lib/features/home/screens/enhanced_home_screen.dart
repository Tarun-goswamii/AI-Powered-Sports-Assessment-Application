// lib/features/home/screens/enhanced_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../core/providers/dynamic_data_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/presentation/widgets/glass_card.dart';
import '../../../shared/presentation/widgets/animated_progress_card.dart';
import '../../../shared/presentation/widgets/floating_action_menu.dart';

class EnhancedHomeScreen extends ConsumerStatefulWidget {
  const EnhancedHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends ConsumerState<EnhancedHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _headerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _headerAnimation;
  
  Timer? _refreshTimer;
  bool _showFloatingMenu = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAutoRefresh();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.elasticOut,
    ));
    
    _fadeController.forward();
    _slideController.forward();
    _headerController.forward();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      if (mounted) {
        // Refresh data periodically
        ref.invalidate(globalLeaderboardProvider);
        ref.invalidate(communityProvider);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _headerController.dispose();
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    ref.invalidate(globalLeaderboardProvider);
    ref.invalidate(communityProvider);
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final leaderboardAsync = ref.watch(globalLeaderboardProvider(50));
    final communityAsync = ref.watch(communityProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionMenu(
        isOpen: _showFloatingMenu,
        onToggle: () => setState(() => _showFloatingMenu = !_showFloatingMenu),
        mainIcon: Icons.add,
        mainColor: AppColors.royalPurple,
        items: [
          FloatingActionMenuItem(
            icon: Icons.sports_martial_arts,
            label: 'Start Assessment',
            color: AppColors.electricBlue,
            onTap: () => context.push('/assessment'),
          ),
          FloatingActionMenuItem(
            icon: Icons.people,
            label: 'Find Mentors',
            color: AppColors.neonGreen,
            onTap: () => context.push('/mentors'),
          ),
          FloatingActionMenuItem(
            icon: Icons.forum,
            label: 'Community',
            color: AppColors.warmOrange,
            onTap: () => context.push('/community'),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.royalPurple,
            backgroundColor: AppColors.glassmorphismBackground,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // Enhanced Header
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildEnhancedHeader(user),
                  ),
                ),
                
                // Quick Stats Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildQuickStatsSection(user),
                  ),
                ),
                
                // Quick Actions Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildQuickActionsGrid(context),
                  ),
                ),
                
                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(user) {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        return Transform.scale(
          scale: _headerAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: InteractiveGlassCard(
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Profile Avatar with Glow
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
                        child: ClipOval(
                          child: user?.profilePicture != null
                              ? Image.network(
                                  user!.profilePicture!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.name ?? 'Athlete',
                              style: AppTypography.h3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Notification Icon
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
                  // Level Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Level ${user?.level ?? 1}',
                            style: AppTypography.h4.copyWith(
                              color: AppColors.neonGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${user?.experiencePoints ?? 0} XP',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildXPProgressBar(user?.experiencePoints ?? 0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildXPProgressBar(int xp) {
    final currentLevelXP = xp % 1000; // Assuming 1000 XP per level
    final progress = currentLevelXP / 1000.0;

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
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

  Widget _buildQuickStatsSection(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: AppTypography.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.gapH16,
        Row(
          children: [
            Expanded(
              child: AnimatedProgressCard(
                title: '${user?.assessmentsCompleted ?? 0}',
                subtitle: 'Assessments',
                progress: (user?.assessmentsCompleted ?? 0) / 10.0,
                icon: Icons.sports_score,
                color: AppColors.electricBlue,
                onTap: () => context.push('/assessments'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedProgressCard(
                title: '${user?.skillsImproved ?? 0}',
                subtitle: 'Skills Improved',
                progress: (user?.skillsImproved ?? 0) / 20.0,
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

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.sports_martial_arts,
        title: 'New Assessment',
        subtitle: 'Start your evaluation',
        color: AppColors.royalPurple,
        route: '/assessment',
      ),
      _QuickAction(
        icon: Icons.people,
        title: 'Find Mentors',
        subtitle: 'Connect with experts',
        color: AppColors.electricBlue,
        route: '/mentors',
      ),
      _QuickAction(
        icon: Icons.forum,
        title: 'Community',
        subtitle: 'Join discussions',
        color: AppColors.neonGreen,
        route: '/community',
      ),
      _QuickAction(
        icon: Icons.analytics,
        title: 'Analytics',
        subtitle: 'View your stats',
        color: AppColors.warmOrange,
        route: '/analytics',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildQuickActionCard(context, action);
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(BuildContext context, _QuickAction action) {
    return InteractiveGlassCard(
      onTap: () => context.push(action.route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: action.color.withOpacity(0.3),
              ),
            ),
            child: Icon(
              action.icon,
              color: action.color,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            action.title,
            style: AppTypography.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            action.subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;

  _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}