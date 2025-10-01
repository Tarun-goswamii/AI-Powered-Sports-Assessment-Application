import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        final convexService = ref.read(convexServiceProvider);
        final profile = await convexService.getUser(userId);
        if (mounted) {
          setState(() {
            _userProfile = profile;
          });
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    final user = authService.currentUser;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Profile Header
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.royalPurple.withOpacity(0.2),
                          child: Text(
                            user?.displayName?.isNotEmpty == true
                                ? user!.displayName![0].toUpperCase()
                                : user?.email?.isNotEmpty == true
                                    ? user!.email![0].toUpperCase()
                                    : 'A',
                            style: const TextStyle(
                              color: AppColors.royalPurple,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.neonGreen,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.background, width: 3),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.displayName ?? 'Athlete',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'athlete@email.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: _buildStatItem(
                            'Level ${_userProfile?['stats']?['level'] ?? 1}',
                            'Athlete Level'
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30, // Reduced height
                          color: AppColors.border,
                          margin: const EdgeInsets.symmetric(horizontal: 12), // Reduced margin
                        ),
                        Flexible(
                          child: _buildStatItem(
                            '${_userProfile?['stats']?['completedTests'] ?? 0}',
                            'Tests Completed'
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30, // Reduced height
                          color: AppColors.border,
                          margin: const EdgeInsets.symmetric(horizontal: 12), // Reduced margin
                        ),
                        Flexible(
                          child: _buildStatItem(
                            '${_userProfile?['stats']?['averageScore']?.toStringAsFixed(1) ?? '0.0'}',
                            'Avg Rating'
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Credits Balance
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.warmOrange, AppColors.warmOrange.withOpacity(0.6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credits Balance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Earn credits by completing tests and challenges',
                            style: TextStyle(
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
                          '${_userProfile?['credits'] ?? 100}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warmOrange,
                          ),
                        ),
                        Text(
                          'credits',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      Icons.edit,
                      'Edit Profile',
                      AppColors.royalPurple,
                      () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      Icons.leaderboard,
                      'Achievements',
                      AppColors.neonGreen,
                      () => context.go('/achievements'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      Icons.help,
                      'Help & Support',
                      AppColors.electricBlue,
                      () => context.go('/help'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      Icons.share,
                      'Share App',
                      AppColors.warmOrange,
                      () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Account Settings
              const Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsItem(
                Icons.notifications,
                'Notifications',
                'Manage push notifications',
                () {},
              ),
              _buildSettingsItem(
                Icons.privacy_tip,
                'Privacy',
                'Privacy settings and data',
                () {},
              ),
              _buildSettingsItem(
                Icons.security,
                'Security',
                'Password and authentication',
                () {},
              ),
              _buildSettingsItem(
                Icons.logout,
                'Logout',
                'Sign out of your account',
                () {},
                isDestructive: true,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Prevent overflow
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16, // Reduced font size
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2), // Reduced spacing
        Text(
          label,
          style: TextStyle(
            fontSize: 10, // Reduced font size
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2, // Limit lines
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return GlassCard(
      padding: const EdgeInsets.all(16), // Reduced padding
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          Container(
            padding: const EdgeInsets.all(10), // Reduced padding
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20, // Reduced size
            ),
          ),
          const SizedBox(height: 8), // Reduced spacing
          Flexible( // Allow text to resize
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12, // Reduced font size
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Limit lines
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.brightRed.withOpacity(0.2)
                    : AppColors.card.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.brightRed : AppColors.royalPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? AppColors.brightRed : Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
