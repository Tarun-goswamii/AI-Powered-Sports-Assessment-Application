import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/service_manager.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/utils/responsive_utils.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = true;
  String _selectedLanguage = 'English';

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.brightRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logging out...'),
              duration: Duration(seconds: 1),
            ),
          );
        }

        final authService = ref.read(authServiceProvider);
        await authService.signOut();

        if (mounted) {
          context.go('/auth');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: responsive.sp(28),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: responsive.wp(12)),
                ],
              ),
              SizedBox(height: responsive.hp(4)),

              Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: responsive.sp(20),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: responsive.hp(2)),
              _buildSettingsItem(
                Icons.person,
                'Edit Profile',
                'Update your personal information',
                () => context.go('/profile'),
              ),
              _buildSettingsItem(
                Icons.security,
                'Privacy & Security',
                'Manage your privacy settings',
                () {},
              ),
              _buildSettingsItem(
                Icons.verified,
                'Account Verification',
                'Verify your athlete status',
                () {},
              ),

              SizedBox(height: responsive.hp(5)),

              NeonButton(
                text: 'Logout',
                onPressed: () => _handleLogout(context),
                variant: NeonButtonVariant.outline,
                size: NeonButtonSize.medium,
              ),
              SizedBox(height: responsive.hp(2)),

              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: responsive.sp(12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: responsive.hp(5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final responsive = ResponsiveUtils(context);
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(2)),
      child: GlassCard(
        padding: EdgeInsets.all(responsive.wp(4)),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(responsive.wp(2)),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.brightRed.withOpacity(0.2)
                    : AppColors.card.withOpacity(0.5),
                borderRadius: BorderRadius.circular(responsive.wp(2)),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.brightRed : AppColors.royalPurple,
                size: responsive.sp(20),
              ),
            ),
            SizedBox(width: responsive.wp(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: responsive.sp(16),
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? AppColors.brightRed : Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: responsive.sp(12),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: responsive.sp(20),
            ),
          ],
        ),
      ),
    );
  }
}
