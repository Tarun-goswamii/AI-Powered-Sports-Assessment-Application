import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All Time';
  Stream<List<Map<String, dynamic>>>? _leaderboardStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeLeaderboardStream();
  }

  void _initializeLeaderboardStream() {
    final convexService = ref.read(convexServiceProvider);
    _leaderboardStream = convexService.subscribeToLeaderboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(responsive.wp(5)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.card.withOpacity(0.5),
                      padding: EdgeInsets.all(responsive.wp(3)),
                    ),
                  ),
                  SizedBox(width: responsive.wp(4)),
                  Expanded(
                    child: Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: responsive.sp(28),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(3),
                      vertical: responsive.hp(0.8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(responsive.wp(5)),
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
              margin: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.3),
                borderRadius: BorderRadius.circular(responsive.wp(3)),
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

            // Tab Content with Real-time Data
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _leaderboardStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.royalPurple),
                      ),
                    );
                  }

                  final leaderboardData = snapshot.data ?? _getMockLeaderboardData();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverallTab(leaderboardData),
                      _buildSprintTab(leaderboardData),
                      _buildStrengthTab(leaderboardData),
                      _buildAgilityTab(leaderboardData),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallTab(List<Map<String, dynamic>> leaderboardData) {
    final overallData = leaderboardData.where((item) => item['category'] == 'overall').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 Podium with Real Data
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
                  children: overallData.length >= 3 ? [
                    _buildPodiumItem(overallData[1]['name'], '${overallData[1]['score']} pts', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem(overallData[0]['name'], '${overallData[0]['score']} pts', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem(overallData[2]['name'], '${overallData[2]['score']} pts', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ] : [
                    _buildPodiumItem('Loading...', '0 pts', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0 pts', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0 pts', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Rankings List with Real Data
          const Text(
            'Full Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...overallData.skip(3).map((player) => _buildRankingItem(
            player['rank'],
            player['name'],
            '${player['score']} pts',
            player['change'] ?? '+0',
            AppColors.neonGreen,
          )),
        ],
      ),
    );
  }

  Widget _buildSprintTab(List<Map<String, dynamic>> leaderboardData) {
    final sprintData = leaderboardData.where((item) => item['category'] == 'sprint').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 for Sprint with Real Data
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
                  children: sprintData.length >= 3 ? [
                    _buildPodiumItem(sprintData[1]['name'], '${sprintData[1]['score']}s avg', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem(sprintData[0]['name'], '${sprintData[0]['score']}s avg', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem(sprintData[2]['name'], '${sprintData[2]['score']}s avg', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ] : [
                    _buildPodiumItem('Loading...', '0s avg', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0s avg', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0s avg', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sprint Rankings with Real Data
          const Text(
            'Sprint Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...sprintData.skip(3).map((player) => _buildRankingItem(
            player['rank'],
            player['name'],
            '${player['score']}s avg',
            player['change'] ?? '+0.0',
            AppColors.neonGreen,
          )),
        ],
      ),
    );
  }

  Widget _buildStrengthTab(List<Map<String, dynamic>> leaderboardData) {
    final strengthData = leaderboardData.where((item) => item['category'] == 'strength').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 for Strength with Real Data
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
                  children: strengthData.length >= 3 ? [
                    _buildPodiumItem(strengthData[1]['name'], '${strengthData[1]['score']} reps', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem(strengthData[0]['name'], '${strengthData[0]['score']} reps', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem(strengthData[2]['name'], '${strengthData[2]['score']} reps', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ] : [
                    _buildPodiumItem('Loading...', '0 reps', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0 reps', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0 reps', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Strength Rankings with Real Data
          const Text(
            'Strength Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...strengthData.skip(3).map((player) => _buildRankingItem(
            player['rank'],
            player['name'],
            '${player['score']} reps',
            player['change'] ?? '+0',
            AppColors.neonGreen,
          )),
        ],
      ),
    );
  }

  Widget _buildAgilityTab(List<Map<String, dynamic>> leaderboardData) {
    final agilityData = leaderboardData.where((item) => item['category'] == 'agility').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 for Agility with Real Data
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
                  children: agilityData.length >= 3 ? [
                    _buildPodiumItem(agilityData[1]['name'], '${agilityData[1]['score']}s avg', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem(agilityData[0]['name'], '${agilityData[0]['score']}s avg', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem(agilityData[2]['name'], '${agilityData[2]['score']}s avg', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ] : [
                    _buildPodiumItem('Loading...', '0s avg', 2, AppColors.electricBlue, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0s avg', 1, AppColors.warmOrange, Icons.workspace_premium),
                    _buildPodiumItem('Loading...', '0s avg', 3, AppColors.royalPurple, Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Agility Rankings with Real Data
          const Text(
            'Agility Rankings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...agilityData.skip(3).map((player) => _buildRankingItem(
            player['rank'],
            player['name'],
            '${player['score']}s avg',
            player['change'] ?? '+0.0',
            AppColors.neonGreen,
          )),
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

  // Mock data fallback
  List<Map<String, dynamic>> _getMockLeaderboardData() {
    return [
      {'rank': 1, 'name': 'Rahul Sharma', 'score': 2680, 'category': 'overall', 'change': '+15'},
      {'rank': 2, 'name': 'Priya Patel', 'score': 2450, 'category': 'overall', 'change': '+8'},
      {'rank': 3, 'name': 'Amit Kumar', 'score': 2320, 'category': 'overall', 'change': '+22'},
      {'rank': 4, 'name': 'Sneha Reddy', 'score': 2180, 'category': 'overall', 'change': '+5'},
      {'rank': 5, 'name': 'Vikram Singh', 'score': 2120, 'category': 'overall', 'change': '+12'},

      {'rank': 1, 'name': 'Priya Patel', 'score': 5.0, 'category': 'sprint', 'change': '+0.2'},
      {'rank': 2, 'name': 'Rahul Sharma', 'score': 5.2, 'category': 'sprint', 'change': '+0.1'},
      {'rank': 3, 'name': 'Amit Kumar', 'score': 5.4, 'category': 'sprint', 'change': '+0.3'},
      {'rank': 4, 'name': 'Sneha Reddy', 'score': 5.6, 'category': 'sprint', 'change': '+0.1'},
      {'rank': 5, 'name': 'Vikram Singh', 'score': 5.7, 'category': 'sprint', 'change': '+0.2'},

      {'rank': 1, 'name': 'Rahul Sharma', 'score': 92, 'category': 'strength', 'change': '+5'},
      {'rank': 2, 'name': 'Amit Kumar', 'score': 85, 'category': 'strength', 'change': '+3'},
      {'rank': 3, 'name': 'Vikram Singh', 'score': 78, 'category': 'strength', 'change': '+7'},
      {'rank': 4, 'name': 'Priya Patel', 'score': 75, 'category': 'strength', 'change': '+2'},
      {'rank': 5, 'name': 'Sneha Reddy', 'score': 72, 'category': 'strength', 'change': '+4'},

      {'rank': 1, 'name': 'Sneha Reddy', 'score': 11.8, 'category': 'agility', 'change': '+0.4'},
      {'rank': 2, 'name': 'Priya Patel', 'score': 12.3, 'category': 'agility', 'change': '+0.2'},
      {'rank': 3, 'name': 'Anjali Prasad', 'score': 12.7, 'category': 'agility', 'change': '+0.6'},
      {'rank': 4, 'name': 'Rahul Sharma', 'score': 13.1, 'category': 'agility', 'change': '+0.3'},
      {'rank': 5, 'name': 'Amit Kumar', 'score': 13.5, 'category': 'agility', 'change': '+0.5'},
    ];
  }
}
