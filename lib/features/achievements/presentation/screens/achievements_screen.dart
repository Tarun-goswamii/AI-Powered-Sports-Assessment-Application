import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.background,
              AppColors.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  floating: true,
                  pinned: false,
                  flexibleSpace: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.electricBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ACHIEVEMENTS',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricBlue,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'Your sports journey milestones',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.electricBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.electricBlue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.emoji_events,
                            color: AppColors.electricBlue,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Stats Overview
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            const SizedBox(height: 8),
                            _buildStatsOverview(),
                            const SizedBox(height: 32),
                            _buildAchievementCategories(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Achievement Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _buildAchievementCard(
                                title: _getAchievementTitle(index),
                                description: _getAchievementDescription(index),
                                icon: _getAchievementIcon(index),
                                isUnlocked: index < 6, // First 6 are unlocked
                                progress: index < 6 ? 1.0 : 0.7,
                                points: _getAchievementPoints(index),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: 12,
                    ),
                  ),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              value: '24',
              label: 'Total Badges',
              icon: Icons.military_tech,
              color: AppColors.electricBlue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.electricBlue.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              value: '1,250',
              label: 'Points Earned',
              icon: Icons.stars,
              color: AppColors.neonGreen,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.electricBlue.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              value: '85%',
              label: 'Completion',
              icon: Icons.trending_up,
              color: AppColors.warmOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAchievementCategories() {
    return Row(
      children: [
        Expanded(
          child: _buildCategoryChip('All', true),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCategoryChip('Fitness', false),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCategoryChip('Performance', false),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCategoryChip('Social', false),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.electricBlue.withOpacity(0.1)
            : AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.electricBlue
              : AppColors.electricBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.electricBlue : AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isUnlocked,
    required double progress,
    required int points,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Progress
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.electricBlue.withOpacity(0.1)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUnlocked
                        ? AppColors.electricBlue
                        : AppColors.electricBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isUnlocked ? AppColors.electricBlue : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.neonGreen.withOpacity(0.1)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUnlocked
                        ? AppColors.neonGreen
                        : AppColors.electricBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  isUnlocked ? 'UNLOCKED' : 'LOCKED',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? AppColors.neonGreen : AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Description
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // Progress and Points
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$points pts',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.electricBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.card,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isUnlocked ? AppColors.neonGreen : AppColors.electricBlue,
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

  String _getAchievementTitle(int index) {
    const titles = [
      'First Steps',
      'Speed Demon',
      'Endurance Master',
      'Perfect Form',
      'Team Player',
      'Consistency King',
      'Power Surge',
      'Recovery Pro',
      'Social Butterfly',
      'Data Driven',
      'Mentor Spirit',
      'Elite Athlete',
    ];
    return titles[index % titles.length];
  }

  String _getAchievementDescription(int index) {
    const descriptions = [
      'Complete your first fitness test',
      'Achieve maximum speed rating',
      'Complete 10 endurance tests',
      'Perfect form in 5 assessments',
      'Join 3 community challenges',
      'Test consistently for 30 days',
      'Reach peak power metrics',
      'Complete 20 recovery sessions',
      'Share 10 workout results',
      'Analyze 50 performance reports',
      'Mentor 5 fellow athletes',
      'Achieve elite status in all categories',
    ];
    return descriptions[index % descriptions.length];
  }

  IconData _getAchievementIcon(int index) {
    const icons = [
      Icons.directions_run,
      Icons.speed,
      Icons.timer,
      Icons.check_circle,
      Icons.group,
      Icons.calendar_today,
      Icons.bolt,
      Icons.spa,
      Icons.share,
      Icons.analytics,
      Icons.school,
      Icons.star,
    ];
    return icons[index % icons.length];
  }

  int _getAchievementPoints(int index) {
    const points = [50, 100, 150, 75, 80, 200, 120, 90, 60, 110, 130, 300];
    return points[index % points.length];
  }
}
