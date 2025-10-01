import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../core/models/mentor_model.dart';
import '../../../../core/models/mentor_session_model.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class MentorScreen extends ConsumerStatefulWidget {
  const MentorScreen({super.key});

  @override
  ConsumerState<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends ConsumerState<MentorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<MentorModel> _mentors = [];
  List<MentorSessionModel> _sessions = [];
  List<MentorModel> _favorites = [];
  bool _isLoadingMentors = true;
  bool _isLoadingSessions = true;
  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMentors();
    _loadSessions();
    _loadFavorites();
  }

  Future<void> _loadMentors() async {
    setState(() => _isLoadingMentors = true);
    try {
      final convexService = ref.read(convexServiceProvider);
      final mentors = await convexService.getMentors();
      setState(() {
        _mentors = mentors.map((m) => MentorModel.fromJson(m)).toList();
        _isLoadingMentors = false;
      });
    } catch (e) {
      print('Error loading mentors: $e');
      setState(() => _isLoadingMentors = false);
    }
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoadingSessions = true);
    try {
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        final convexService = ref.read(convexServiceProvider);
        final sessions = await convexService.getUserMentorSessions(userId);
        setState(() {
          _sessions = sessions.map((s) => MentorSessionModel.fromJson(s)).toList();
          _isLoadingSessions = false;
        });
      } else {
        setState(() => _isLoadingSessions = false);
      }
    } catch (e) {
      print('Error loading sessions: $e');
      setState(() => _isLoadingSessions = false);
    }
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoadingFavorites = true);
    try {
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        final convexService = ref.read(convexServiceProvider);
        final favorites = await convexService.getUserFavoriteMentors(userId);
        setState(() {
          _favorites = favorites.map((f) => MentorModel.fromJson(f)).toList();
          _isLoadingFavorites = false;
        });
      } else {
        setState(() => _isLoadingFavorites = false);
      }
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() => _isLoadingFavorites = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
                        'Expert Mentors',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.go('/store'),
                      icon: const Icon(Icons.store, color: Colors.white),
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
                    Tab(text: 'All Mentors'),
                    Tab(text: 'My Sessions'),
                    Tab(text: 'Favorites'),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllMentorsTab(),
                    _buildMySessionsTab(),
                    _buildFavoritesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.royalPurple, AppColors.electricBlue],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppColors.neonGlowPurple,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.go('/ai-coach'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(
            Icons.smart_toy_rounded,
            color: Colors.white,
            size: 24,
          ),
          label: const Text(
            'AI Coach',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAllMentorsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search mentors by name or specialty...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                const SizedBox(width: 8),
                _buildFilterChip('Sprint', false),
                const SizedBox(width: 8),
                _buildFilterChip('Strength', false),
                const SizedBox(width: 8),
                _buildFilterChip('Nutrition', false),
                const SizedBox(width: 8),
                _buildFilterChip('Recovery', false),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Mentor Cards
          if (_isLoadingMentors)
            const Center(child: CircularProgressIndicator())
          else if (_mentors.isEmpty)
            const Center(
              child: Text(
                'No mentors available',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ..._mentors.map((mentor) => Column(
              children: [
                _buildMentorCard(
                  mentor.name,
                  mentor.subtitle,
                  mentor.specialty,
                  mentor.rating,
                  mentor.sessionsCount,
                  '\$${mentor.hourlyRate.toStringAsFixed(0)}/hr',
                  _getMentorColor(mentor.specialty),
                  mentor.isAvailable,
                ),
                const SizedBox(height: 16),
              ],
            )),
        ],
      ),
    );
  }

  Widget _buildMySessionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Sessions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Upcoming Sessions
          if (_isLoadingSessions)
            const Center(child: CircularProgressIndicator())
          else if (_sessions.where((s) => s.status == 'upcoming').isEmpty)
            const Center(
              child: Text(
                'No upcoming sessions',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ..._sessions.where((s) => s.status == 'upcoming').map((session) => Column(
              children: [
                _buildSessionCard(
                  session.mentorName ?? 'Unknown Mentor',
                  session.topic,
                  DateTime.fromMillisecondsSinceEpoch(session.scheduledAt).toString(),
                  session.type,
                  AppColors.neonGreen,
                ),
                const SizedBox(height: 16),
              ],
            )),

          const SizedBox(height: 32),
          const Text(
            'Past Sessions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Past Sessions
          if (_isLoadingSessions)
            const SizedBox() // Already showing loading above
          else if (_sessions.where((s) => s.status == 'completed').isEmpty)
            const Center(
              child: Text(
                'No past sessions',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ..._sessions.where((s) => s.status == 'completed').map((session) => Column(
              children: [
                _buildPastSessionCard(
                  session.mentorName ?? 'Unknown Mentor',
                  session.topic,
                  'Completed ${session.completedAt?.toString() ?? 'recently'}',
                  session.rating ?? 0.0,
                  AppColors.warmOrange,
                ),
                const SizedBox(height: 12),
              ],
            )),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorite Mentors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Favorite Mentors
          if (_isLoadingFavorites)
            const Center(child: CircularProgressIndicator())
          else if (_favorites.isEmpty)
            const Center(
              child: Text(
                'No favorite mentors yet',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ..._favorites.map((mentor) => Column(
              children: [
                _buildMentorCard(
                  mentor.name,
                  mentor.subtitle,
                  mentor.specialty,
                  mentor.rating,
                  mentor.sessionsCount,
                  '\$${mentor.hourlyRate.toStringAsFixed(0)}/hr',
                  _getMentorColor(mentor.specialty),
                  mentor.isAvailable,
                ),
                const SizedBox(height: 16),
              ],
            )),
        ],
      ),
    );
  }

  Color _getMentorColor(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'sprint':
      case 'speed':
        return AppColors.neonGreen;
      case 'nutrition':
        return AppColors.electricBlue;
      case 'strength':
        return AppColors.warmOrange;
      case 'recovery':
      case 'physiotherapy':
        return AppColors.royalPurple;
      default:
        return AppColors.neonGreen;
    }
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.royalPurple.withOpacity(0.2)
            : AppColors.card.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.royalPurple : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.royalPurple : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMentorCard(String name, String subtitle, String specialty,
      double rating, int sessions, String price, Color accentColor, bool isOnline) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: accentColor.withOpacity(0.2),
                    child: Text(
                      name.isNotEmpty ? name[0] : '?',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.neonGreen,
                          border: Border.all(color: AppColors.background, width: 2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: TextStyle(
                        fontSize: 14,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.warmOrange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$sessions sessions',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              NeonButton(
                text: 'Book Session',
                onPressed: () {},
                size: NeonButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(String mentor, String topic, String time, String type, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  topic,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              NeonButton(
                text: 'Join',
                onPressed: () {},
                size: NeonButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastSessionCard(String mentor, String topic, String time, double rating, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  topic,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.warmOrange,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
