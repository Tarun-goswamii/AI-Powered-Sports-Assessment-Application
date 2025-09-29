// lib/features/leaderboard/presentation/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All Time';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.card.withOpacity(0.5),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.card.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      items: ['All Time', 'This Month', 'This Week', 'Today']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFilter = newValue!;
                        });
                      },
                      dropdownColor: AppColors.card,
                      underline: const SizedBox(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.royalPurple, AppColors.electricBlue],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'Overall'),
                  Tab(text: 'Sprint'),
                  Tab(text: 'Strength'),
                  Tab(text: 'Agility'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverallTab(),
                  _buildSprintTab(),
                  _buildStrengthTab(),
                  _buildAgilityTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 Podium
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Top Performers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPodiumItem('Rahul K.', '2,450 pts', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Priya S.', '2,680 pts', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Amit R.', '2,320 pts', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Rankings List
          const Text(
            'Full Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildRankingItem(4, 'Sneha M.', '2,180 pts', '+15', AppColors.neonGreen),
          _buildRankingItem(5, 'Vikram T.', '2,120 pts', '+8', AppColors.neonGreen),
          _buildRankingItem(6, 'Anjali P.', '2,050 pts', '+22', AppColors.neonGreen),
          _buildRankingItem(7, 'Rohit S.', '1,980 pts', '+5', AppColors.neonGreen),
          _buildRankingItem(8, 'Kavita L.', '1,920 pts', '+12', AppColors.neonGreen),
          _buildRankingItem(9, 'Arjun N.', '1,850 pts', '+3', AppColors.neonGreen),
          _buildRankingItem(10, 'Meera K.', '1,780 pts', '+18', AppColors.neonGreen),
        ],
      ),
    );
  }

  Widget _buildSprintTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 for Sprint
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Sprint Champions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPodiumItem('Rahul K.', '5.2s avg', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Priya S.', '5.0s avg', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Amit R.', '5.4s avg', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sprint Rankings
          const Text(
            'Sprint Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildRankingItem(4, 'Sneha M.', '5.6s avg', '+0.2', AppColors.neonGreen),
          _buildRankingItem(5, 'Vikram T.', '5.7s avg', '+0.1', AppColors.neonGreen),
          _buildRankingItem(6, 'Anjali P.', '5.8s avg', '+0.3', AppColors.neonGreen),
        ],
      ),
    );
  }

  Widget _buildStrengthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 for Strength
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Strength Leaders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPodiumItem('Amit R.', '85 push-ups', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Rahul K.', '92 push-ups', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Vikram T.', '78 push-ups', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Strength Rankings
          const Text(
            'Strength Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildRankingItem(4, 'Priya S.', '75 push-ups', '+5', AppColors.neonGreen),
          _buildRankingItem(5, 'Sneha M.', '72 push-ups', '+3', AppColors.neonGreen),
          _buildRankingItem(6, 'Anjali P.', '68 push-ups', '+7', AppColors.neonGreen),
        ],
      ),
    );
  }

  Widget _buildAgilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 for Agility
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Agility Masters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPodiumItem('Priya S.', '12.3s avg', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Sneha M.', '11.8s avg', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Anjali P.', '12.7s avg', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Agility Rankings
          const Text(
            'Agility Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildRankingItem(4, 'Rahul K.', '13.1s avg', '+0.4', AppColors.neonGreen),
          _buildRankingItem(5, 'Amit R.', '13.5s avg', '+0.2', AppColors.neonGreen),
          _buildRankingItem(6, 'Vikram T.', '13.8s avg', '+0.6', AppColors.neonGreen),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(String name, String score, int position, Color color, IconData medalIcon) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.6)],
            ),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(
            medalIcon,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          score,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$position',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingItem(int rank, String name, String score, String change, Color changeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rank <= 3 ? AppColors.warmOrange.withOpacity(0.2) : AppColors.card.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: rank <= 3 ? AppColors.warmOrange : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    score,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: changeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: changeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
