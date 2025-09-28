// lib/features/community/presentation/screens/community_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> posts = [
    {
      'id': '1',
      'user': 'Alex Johnson',
      'avatar': 'AJ',
      'time': '2h ago',
      'content': 'Just completed my vertical jump test! Scored 42cm - not bad for a beginner! 🎯',
      'likes': 24,
      'comments': 8,
      'shares': 3,
      'type': 'achievement',
    },
    {
      'id': '2',
      'user': 'Sarah Chen',
      'avatar': 'SC',
      'time': '4h ago',
      'content': 'Looking for training partners in Mumbai. Anyone interested in shuttle run practice sessions?',
      'likes': 12,
      'comments': 15,
      'shares': 2,
      'type': 'question',
    },
    {
      'id': '3',
      'user': 'Mike Rodriguez',
      'avatar': 'MR',
      'time': '6h ago',
      'content': 'New personal best in endurance run! 2100m in 12 minutes. The training plan from my mentor really works! 💪',
      'likes': 45,
      'comments': 22,
      'shares': 7,
      'type': 'achievement',
    },
    {
      'id': '4',
      'user': 'Priya Patel',
      'avatar': 'PP',
      'time': '8h ago',
      'content': 'Nutrition question: What\'s the best post-workout meal for muscle recovery?',
      'likes': 18,
      'comments': 31,
      'shares': 5,
      'type': 'question',
    },
  ];

  final List<Map<String, dynamic>> events = [
    {
      'title': 'Weekly Shuttle Run Challenge',
      'date': 'Tomorrow, 6:00 PM',
      'location': 'Central Park, Mumbai',
      'participants': 23,
      'maxParticipants': 30,
    },
    {
      'title': 'Vertical Jump Workshop',
      'date': 'Saturday, 10:00 AM',
      'location': 'Sports Academy, Delhi',
      'participants': 15,
      'maxParticipants': 20,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Community',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _createPost,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
          IconButton(
            onPressed: _openMessages,
            icon: const Icon(Icons.message_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Quick Actions
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      text: 'Create Post',
                      size: NeonButtonSize.small,
                      onPressed: _createPost,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeonButton(
                      text: 'Find Events',
                      variant: NeonButtonVariant.secondary,
                      size: NeonButtonSize.small,
                      onPressed: _findEvents,
                    ),
                  ),
                ],
              ),
            ),

            // Upcoming Events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: _buildEventCard(events[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Feed
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildPostCard(posts[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return GlassCard(
      width: 280,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                event['date'],
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event['location'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.people,
                size: 14,
                color: AppColors.electricBlue,
              ),
              const SizedBox(width: 4),
              Text(
                '${event['participants']}/${event['maxParticipants']} joined',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.electricBlue,
                ),
              ),
              const Spacer(),
              NeonButton(
                text: 'Join',
                size: NeonButtonSize.small,
                onPressed: () => _joinEvent(event),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.royalPurple,
                child: Text(
                  post['avatar'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['user'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      post['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showPostMenu(post),
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Post Content
          Text(
            post['content'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Engagement Stats
          Row(
            children: [
              _buildEngagementButton(
                icon: Icons.thumb_up_outlined,
                count: post['likes'],
                onPressed: () => _likePost(post),
              ),
              const SizedBox(width: 16),
              _buildEngagementButton(
                icon: Icons.comment_outlined,
                count: post['comments'],
                onPressed: () => _commentOnPost(post),
              ),
              const SizedBox(width: 16),
              _buildEngagementButton(
                icon: Icons.share_outlined,
                count: post['shares'],
                onPressed: () => _sharePost(post),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementButton({
    required IconData icon,
    required int count,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() {
    // TODO: Navigate to create post screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create post feature coming soon!')),
    );
  }

  void _openMessages() {
    // TODO: Navigate to messages screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Messages feature coming soon!')),
    );
  }

  void _findEvents() {
    // TODO: Navigate to events screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Events feature coming soon!')),
    );
  }

  void _joinEvent(Map<String, dynamic> event) {
    // TODO: Join event logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Joined ${event['title']}')),
    );
  }

  void _showPostMenu(Map<String, dynamic> post) {
    // TODO: Show post options menu
  }

  void _likePost(Map<String, dynamic> post) {
    // TODO: Like post logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post liked!')),
    );
  }

  void _commentOnPost(Map<String, dynamic> post) {
    // TODO: Navigate to comments
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comments feature coming soon!')),
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    // TODO: Share post logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post shared!')),
    );
  }
}
