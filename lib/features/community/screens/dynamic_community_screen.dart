// lib/features/community/screens/dynamic_community_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/dynamic_data_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/neon_button.dart';

class DynamicCommunityScreen extends ConsumerStatefulWidget {
  const DynamicCommunityScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DynamicCommunityScreen> createState() => _DynamicCommunityScreenState();
}

class _DynamicCommunityScreenState extends ConsumerState<DynamicCommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _postController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityProvider);
    final user = ref.watch(userProvider);
    final communityPostsStream = ref.watch(communityPostsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Community',
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showCreatePostDialog(),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.royalPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.royalPurple,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [AppColors.royalPurple, AppColors.oceanBlue],
                  ),
                ),
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: AppTypography.bodyMedium,
                tabs: const [
                  Tab(text: 'Feed'),
                  Tab(text: 'Challenges'),
                  Tab(text: 'Groups'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Feed Tab
                  _buildFeedTab(communityState, communityPostsStream),
                  
                  // Challenges Tab
                  _buildChallengesTab(),
                  
                  // Groups Tab
                  _buildGroupsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTab(CommunityState communityState, AsyncValue<List<Map<String, dynamic>>> streamData) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(communityProvider.notifier).refresh();
      },
      color: AppColors.royalPurple,
      backgroundColor: AppColors.surfaceColor,
      child: streamData.when(
        data: (posts) => _buildPostsList(posts),
        loading: () => _buildPostsList(communityState.posts, isLoading: true),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildPostsList(List<Map<String, dynamic>> posts, {bool isLoading = false}) {
    if (posts.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.royalPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.forum_outlined,
                size: 48,
                color: AppColors.royalPurple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share your fitness journey!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            NeonButton(
              onPressed: () => _showCreatePostDialog(),
              variant: NeonButtonVariant.primary,
              child: const Text('Create First Post'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: posts.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == posts.length && isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColors.royalPurple),
            ),
          );
        }

        final post = posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final type = post['type'] as String? ?? 'general';
    final content = post['content'] as String? ?? '';
    final likes = post['likes'] as int? ?? 0;
    final comments = post['comments'] as int? ?? 0;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(post['createdAt'] as int? ?? 0);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.royalPurple.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.royalPurple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Athlete ${post['userId']?.toString().substring(0, 8) ?? 'Unknown'}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatTimeAgo(createdAt),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPostTypeChip(type),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Content
              Text(
                content,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Actions
              Row(
                children: [
                  _buildActionButton(
                    Icons.favorite_outline,
                    likes.toString(),
                    AppColors.magentaPink,
                    () => _handleLike(post),
                  ),
                  const SizedBox(width: 24),
                  _buildActionButton(
                    Icons.comment_outlined,
                    comments.toString(),
                    AppColors.oceanBlue,
                    () => _handleComment(post),
                  ),
                  const Spacer(),
                  _buildActionButton(
                    Icons.share_outlined,
                    'Share',
                    AppColors.royalPurple,
                    () => _handleShare(post),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostTypeChip(String type) {
    Color color;
    String label;
    
    switch (type) {
      case 'achievement':
        color = AppColors.electricGreen;
        label = 'Achievement';
        break;
      case 'question':
        color = AppColors.sunsetOrange;
        label = 'Question';
        break;
      case 'motivation':
        color = AppColors.magentaPink;
        label = 'Motivation';
        break;
      default:
        color = AppColors.royalPurple;
        label = 'General';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.electricGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: AppColors.electricGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '30-Day Fitness Challenge',
                              style: AppTypography.headingMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Complete daily workouts for 30 days',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildChallengeMetric('Participants', '1,247'),
                      const SizedBox(width: 24),
                      _buildChallengeMetric('Days Left', '12'),
                      const SizedBox(width: 24),
                      _buildChallengeMetric('Reward', '500 pts'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  NeonButton(
                    onPressed: () => _joinChallenge(),
                    variant: NeonButtonVariant.primary,
                    child: const Text('Join Challenge'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    final groups = [
      {
        'name': 'Runners Club',
        'description': 'For passionate runners',
        'members': 324,
        'category': 'Running',
      },
      {
        'name': 'Strength Training',
        'description': 'Build muscle and strength',
        'members': 198,
        'category': 'Strength',
      },
      {
        'name': 'Yoga & Flexibility',
        'description': 'Improve flexibility and mindfulness',
        'members': 156,
        'category': 'Flexibility',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.royalPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.groups,
                      color: AppColors.royalPurple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group['name'] as String,
                          style: AppTypography.headingSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group['description'] as String,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${group['members']} members',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.royalPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NeonButton(
                    onPressed: () => _joinGroup(group['name'] as String),
                    variant: NeonButtonVariant.secondary,
                    child: const Text('Join'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChallengeMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          NeonButton(
            onPressed: () => ref.read(communityProvider.notifier).refresh(),
            variant: NeonButtonVariant.secondary,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog() {
    final user = ref.read(userProvider);
    if (user == null) {
      _showLoginRequired();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Post',
                  style: AppTypography.headingMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _postController,
                  maxLines: 4,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Share your fitness journey...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.royalPurple),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _postController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    NeonButton(
                      onPressed: () => _createPost(user.id),
                      variant: NeonButtonVariant.primary,
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createPost(String userId) async {
    if (_postController.text.trim().isEmpty) return;
    
    await ref.read(communityProvider.notifier).createPost(
      userId: userId,
      content: _postController.text.trim(),
      type: 'general',
    );
    
    _postController.clear();
    Navigator.of(context).pop();
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        title: const Text('Login Required', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Please log in to participate in the community.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          NeonButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/auth');
            },
            variant: NeonButtonVariant.primary,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _handleLike(Map<String, dynamic> post) {
    // Implement like functionality
    print('Liked post: ${post['content']}');
  }

  void _handleComment(Map<String, dynamic> post) {
    // Implement comment functionality
    print('Comment on post: ${post['content']}');
  }

  void _handleShare(Map<String, dynamic> post) {
    // Implement share functionality
    print('Share post: ${post['content']}');
  }

  void _joinChallenge() {
    // Implement join challenge functionality
    print('Joined challenge');
  }

  void _joinGroup(String groupName) {
    // Implement join group functionality
    print('Joined group: $groupName');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _postController.dispose();
    super.dispose();
  }
}