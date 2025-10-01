// lib/features/home/screens/simple_enhanced_home.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../../../shared/presentation/widgets/glass_card.dart';
import '../../../shared/presentation/widgets/animated_progress_card.dart';
import '../../../shared/presentation/widgets/daily_bonus_dialog.dart';

class SimpleEnhancedHome extends ConsumerStatefulWidget {
  const SimpleEnhancedHome({Key? key}) : super(key: key);

  @override
  ConsumerState<SimpleEnhancedHome> createState() => _SimpleEnhancedHomeState();
}

class _SimpleEnhancedHomeState extends ConsumerState<SimpleEnhancedHome>
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(),
                const SizedBox(height: 24),
                
                // Progress Cards
                _buildProgressSection(),
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

  Widget _buildHeader() {
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
                child: const Icon(
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
                    Text(
                      'Welcome back,',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppTextTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AppTextTheme.primaryText(
                      'Athlete',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      ),
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
                    'Level 1',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '0 XP',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
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
                      widthFactor: 0.0,
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextTheme.primaryText(
          'Your Progress',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AnimatedProgressCard(
                title: '0',
                subtitle: 'Assessments',
                progress: 0.0,
                icon: Icons.sports_score,
                color: AppColors.electricBlue,
                onTap: () => context.push('/assessments'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedProgressCard(
                title: '0',
                subtitle: 'Skills Improved',
                progress: 0.0,
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

  Widget _buildActionCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
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
          Text(
            title,
            style: AppTypography.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
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