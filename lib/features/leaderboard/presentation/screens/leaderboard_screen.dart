import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = ['Overall', 'Speed', 'Endurance', 'Strength', 'Flexibility'];
  String _selectedCategory = 'Overall';

  final List<Map<String, dynamic>> _leaderboardData = [
    {
      'rank': 1,
      'name': 'Rajesh Kumar',
      'score': 2850,
      'change': 2,
      'avatar': 'RK',
      'location': 'Mumbai',
      'badge': '🏆',
    },
    {
      'rank': 2,
      'name': 'Priya Sharma',
      'score': 2720,
      'change': -1,
      'avatar': 'PS',
      'location': 'Delhi',
      'badge': '🥈',
    },
    {
      'rank': 3,
      'name': 'Amit Singh',
      'score': 2680,
      'change': 1,
      'avatar': 'AS',
      'location': 'Bangalore',
      'badge': '🥉',
    },
    {
      'rank': 4,
      'name': 'Sneha Patel',
      'score': 2590,
      'change': 0,
      'avatar': 'SP',
      'location': 'Ahmedabad',
      'badge': null,
    },
    {
      'rank': 5,
      'name': 'Vikram Rao',
      'score': 2540,
      'change': 3,
      'avatar': 'VR',
      'location': 'Pune',
      'badge': null,
    },
  ];

  final Map<String, dynamic> _currentUser = {
    'rank': 15,
    'name': 'You',
    'score': 2150,
    'change': 5,
    'avatar': 'YO',
    'location': 'Your City',
    'isCurrentUser': true,
  };

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
                                'LEADERBOARD',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricBlue,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'Compete with athletes nationwide',
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
                            color: AppColors.warmOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.warmOrange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.leaderboard,
                            color: AppColors.warmOrange,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Categories and Content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      AnimationLimiter(
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 600),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 30.0,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: [
                              const SizedBox(height: 8),
                              _buildCategories(),
                              const SizedBox(height: 24),
                              _buildTopThree(),
                              const SizedBox(height: 24),
                              ..._leaderboardData.map((entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildLeaderboardEntry(entry),
                              )),
                              const SizedBox(height: 16),
                              _buildCurrentUserEntry(),
                            ],
                          ),
                        ),
                      ),
                    ]),
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

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((category) {
          final isSelected = category == _selectedCategory;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() => _selectedCategory = category);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.electricBlue.withOpacity(0.1)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.electricBlue
                        : AppColors.electricBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.electricBlue : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopThree() {
    return Row(
      children: [
        Expanded(
          child: _buildTopThreeCard(_leaderboardData[1], 2, AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _buildTopThreeCard(_leaderboardData[0], 1, AppColors.neonGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTopThreeCard(_leaderboardData[2], 3, AppColors.warmOrange),
        ),
      ],
    );
  }

  Widget _buildTopThreeCard(Map<String, dynamic> user, int position, Color accentColor) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              position.toString(),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.electricBlue.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                user['avatar'] as String,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user['name'] as String,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${user['score']} pts',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (user['badge'] != null) ...[
            const SizedBox(height: 4),
            Text(
              user['badge'] as String,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeaderboardEntry(Map<String, dynamic> entry) {
    final isTopThree = entry['rank'] <= 3;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isTopThree ? AppColors.neonGreen.withOpacity(0.1) : AppColors.card,
              shape: BoxShape.circle,
              border: Border.all(
                color: isTopThree ? AppColors.neonGreen : AppColors.electricBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                entry['rank'].toString(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isTopThree ? AppColors.neonGreen : AppColors.electricBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.electricBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                entry['avatar'] as String,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  entry['location'] as String,
                  style: GoogleFonts.inter(
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
                '${entry['score']} pts',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonGreen,
                ),
              ),
              Row(
                children: [
                  Icon(
                    (entry['change'] as int) > 0 ? Icons.arrow_upward :
                    (entry['change'] as int) < 0 ? Icons.arrow_downward : Icons.remove,
                    color: (entry['change'] as int) > 0 ? AppColors.neonGreen :
                           (entry['change'] as int) < 0 ? AppColors.brightRed : AppColors.textSecondary,
                    size: 14,
                  ),
                  Text(
                    '${(entry['change'] as int).abs()}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: (entry['change'] as int) > 0 ? AppColors.neonGreen :
                             (entry['change'] as int) < 0 ? AppColors.brightRed : AppColors.textSecondary,
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

  Widget _buildCurrentUserEntry() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.royalPurple.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.royalPurple,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _currentUser['rank'].toString(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.royalPurple,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.royalPurple.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.royalPurple,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _currentUser['avatar'] as String,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.royalPurple,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.royalPurple,
                  ),
                ),
                Text(
                  _currentUser['location'] as String,
                  style: GoogleFonts.inter(
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
                '${_currentUser['score']} pts',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonGreen,
                ),
              ),
              Row(
                children: [
                  Icon(
                    (_currentUser['change'] as int) > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: (_currentUser['change'] as int) > 0 ? AppColors.neonGreen : AppColors.brightRed,
                    size: 14,
                  ),
                  Text(
                    '${(_currentUser['change'] as int).abs()}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: (_currentUser['change'] as int) > 0 ? AppColors.neonGreen : AppColors.brightRed,
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
}
