import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class CreditsScreen extends ConsumerStatefulWidget {
  const CreditsScreen({super.key});

  @override
  ConsumerState<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends ConsumerState<CreditsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final int _currentCredits = 1250;
  final int _totalEarned = 2450;
  final int _totalSpent = 1200;

  final List<Map<String, dynamic>> _earnMethods = [
    {
      'title': 'Complete Fitness Test',
      'description': 'Earn 50 credits per test',
      'icon': Icons.directions_run,
      'color': AppColors.neonGreen,
      'credits': 50,
    },
    {
      'title': 'Share Results',
      'description': 'Earn 25 credits for sharing',
      'icon': Icons.share,
      'color': AppColors.electricBlue,
      'credits': 25,
    },
    {
      'title': 'Daily Login',
      'description': 'Earn 10 credits daily',
      'icon': Icons.calendar_today,
      'color': AppColors.warmOrange,
      'credits': 10,
    },
    {
      'title': 'Mentor Others',
      'description': 'Earn 100 credits per session',
      'icon': Icons.school,
      'color': AppColors.royalPurple,
      'credits': 100,
    },
    {
      'title': 'Community Challenge',
      'description': 'Earn 75 credits for participation',
      'icon': Icons.emoji_events,
      'color': AppColors.neonGreen,
      'credits': 75,
    },
    {
      'title': 'Weekly Goal',
      'description': 'Earn 150 credits for completing weekly goals',
      'icon': Icons.flag,
      'color': AppColors.brightRed,
      'credits': 150,
    },
  ];

  final List<Map<String, dynamic>> _spendMethods = [
    {
      'title': 'Premium Supplements',
      'description': 'Discounts on verified products',
      'icon': Icons.local_pharmacy,
      'color': AppColors.neonGreen,
    },
    {
      'title': 'Expert Consultation',
      'description': '1-on-1 sessions with coaches',
      'icon': Icons.person,
      'color': AppColors.electricBlue,
    },
    {
      'title': 'Premium Features',
      'description': 'Unlock advanced analytics',
      'icon': Icons.analytics,
      'color': AppColors.warmOrange,
    },
    {
      'title': 'Exclusive Content',
      'description': 'Access premium training videos',
      'icon': Icons.video_library,
      'color': AppColors.royalPurple,
    },
  ];

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
                                'CREDITS',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricBlue,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'Earn & spend your rewards',
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
                            color: AppColors.neonGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.neonGreen.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.stars,
                            color: AppColors.neonGreen,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Credits Overview
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
                            _buildCreditsOverview(),
                            const SizedBox(height: 32),
                            _buildEarnCreditsSection(),
                            const SizedBox(height: 32),
                            _buildSpendCreditsSection(),
                          ],
                        ),
                      ),
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

  Widget _buildCreditsOverview() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Main Credits Display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.neonGreen, AppColors.electricBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.neonGlowGreen,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.stars,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  '$_currentCredits',
                  style: GoogleFonts.inter(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'AVAILABLE CREDITS',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildCreditStat(
                  label: 'Total Earned',
                  value: _totalEarned.toString(),
                  color: AppColors.neonGreen,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.electricBlue.withOpacity(0.3),
              ),
              Expanded(
                child: _buildCreditStat(
                  label: 'Total Spent',
                  value: _totalSpent.toString(),
                  color: AppColors.warmOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditStat({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
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

  Widget _buildEarnCreditsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EARN CREDITS',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.electricBlue,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _earnMethods.length,
          itemBuilder: (context, index) {
            final method = _earnMethods[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 600),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: _buildCreditMethodCard(method, true),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSpendCreditsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SPEND CREDITS',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.electricBlue,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _spendMethods.length,
          itemBuilder: (context, index) {
            final method = _spendMethods[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 600),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: _buildCreditMethodCard(method, false),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCreditMethodCard(Map<String, dynamic> method, bool isEarn) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (method['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  method['icon'] as IconData,
                  color: method['color'] as Color,
                  size: 20,
                ),
              ),
              if (isEarn) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+${method['credits']}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonGreen,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          Text(
            method['title'] as String,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          Text(
            method['description'] as String,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
