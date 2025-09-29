// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
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
                  IconButton(
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
              const SizedBox(height: 24),

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
                Icons.person,
                'Profile Information',
                'Update your personal details',
                () {},
              ),
              _buildSettingsItem(
                Icons.security,
                'Password & Security',
                'Change password and security settings',
                () {},
              ),
              _buildSettingsItem(
                Icons.verified_user,
                'Account Verification',
                'Verify your athlete status',
                () {},
              ),

              const SizedBox(height: 32),

              // App Preferences
              const Text(
                'App Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSwitchItem(
                Icons.notifications,
                'Push Notifications',
                'Receive test reminders and updates',
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
              ),
              _buildSwitchItem(
                Icons.fingerprint,
                'Biometric Authentication',
                'Use fingerprint/face unlock',
                _biometricEnabled,
                (value) => setState(() => _biometricEnabled = value),
              ),
              _buildDropdownItem(
                Icons.language,
                'Language',
                'Choose your preferred language',
                _selectedLanguage,
                ['English', 'Hindi', 'Tamil', 'Telugu', 'Bengali'],
                (value) => setState(() => _selectedLanguage = value!),
              ),

              const SizedBox(height: 32),

              // Appearance
              const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSwitchItem(
                Icons.dark_mode,
                'Dark Mode',
                'Always use dark theme',
                _darkModeEnabled,
                (value) => setState(() => _darkModeEnabled = value),
              ),
              _buildSettingsItem(
                Icons.palette,
                'Theme Colors',
                'Customize app colors',
                () {},
              ),

              const SizedBox(height: 32),

              // Privacy & Data
              const Text(
                'Privacy & Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsItem(
                Icons.privacy_tip,
                'Privacy Policy',
                'Read our privacy policy',
                () {},
              ),
              _buildSettingsItem(
                Icons.description,
                'Terms of Service',
                'Read our terms and conditions',
                () {},
              ),
              _buildSettingsItem(
                Icons.download,
                'Export Data',
                'Download your test data',
                () {},
              ),
              _buildSettingsItem(
                Icons.delete_forever,
                'Delete Account',
                'Permanently delete your account',
                () {},
                isDestructive: true,
              ),

              const SizedBox(height: 32),

              // Support
              const Text(
                'Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsItem(
                Icons.help,
                'Help Center',
                'Get help and support',
                () => context.go('/help'),
              ),
              _buildSettingsItem(
                Icons.feedback,
                'Send Feedback',
                'Help us improve the app',
                () {},
              ),
              _buildSettingsItem(
                Icons.info,
                'About',
                'App version and information',
                () => context.go('/credits'),
              ),

              const SizedBox(height: 40),

              // Logout Button
              NeonButton(
                text: 'Logout',
                onPressed: () {},
                variant: NeonButtonVariant.outline,
                size: NeonButtonSize.medium,
              ),
              const SizedBox(height: 20),

              // Version Info
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle,
      VoidCallback onTap, {bool isDestructive = false}) {
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

  Widget _buildSwitchItem(IconData icon, String title, String subtitle,
      bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.royalPurple,
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
                    style: const TextStyle(
                      fontSize: 16,
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
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.neonGreen,
              activeTrackColor: AppColors.neonGreen.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownItem(IconData icon, String title, String subtitle,
      String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.royalPurple,
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
                    style: const TextStyle(
                      fontSize: 16,
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
                ],
              ),
            ),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: AppColors.card,
              underline: const SizedBox(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
