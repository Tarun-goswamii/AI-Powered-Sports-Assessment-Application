import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedUnit = 'Metric';

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
    final size = MediaQuery.of(context).size;

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
                                'SETTINGS',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricBlue,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'Customize your experience',
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
                            color: AppColors.electricBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.electricBlue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.settings,
                            color: AppColors.electricBlue,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Settings Sections
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
                              _buildAccountSection(),
                              const SizedBox(height: 24),
                              _buildPrivacySection(),
                              const SizedBox(height: 24),
                              _buildNotificationsSection(),
                              const SizedBox(height: 24),
                              _buildAppearanceSection(),
                              const SizedBox(height: 24),
                              _buildDataSection(),
                              const SizedBox(height: 24),
                              _buildSupportSection(),
                              const SizedBox(height: 32),
                              _buildSignOutButton(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.electricBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.person,
            title: 'Profile Information',
            subtitle: 'Update your personal details',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.security,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: _selectedLanguage,
            trailing: _buildDropdownButton(
              value: _selectedLanguage,
              items: ['English', 'Hindi', 'Spanish', 'French'],
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRIVACY & SECURITY',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.electricBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.fingerprint,
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or face unlock',
            trailing: Switch(
              value: _biometricEnabled,
              onChanged: (value) {
                setState(() => _biometricEnabled = value);
              },
              activeColor: AppColors.neonGreen,
              activeTrackColor: AppColors.neonGreen.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: 'Data Privacy',
            subtitle: 'Manage your data sharing preferences',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTIFICATIONS',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.electricBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive app notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
              activeColor: AppColors.neonGreen,
              activeTrackColor: AppColors.neonGreen.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.email,
            title: 'Email Notifications',
            subtitle: 'Receive updates via email',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.neonGreen,
              activeTrackColor: AppColors.neonGreen.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APPEARANCE',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.electricBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Toggle between light and dark themes',
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() => _darkModeEnabled = value);
              },
              activeColor: AppColors.neonGreen,
              activeTrackColor: AppColors.neonGreen.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.straighten,
            title: 'Units',
            subtitle: _selectedUnit,
            trailing: _buildDropdownButton(
              value: _selectedUnit,
              items: ['Metric', 'Imperial'],
              onChanged: (value) {
                setState(() => _selectedUnit = value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATA MANAGEMENT',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.electricBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.download,
            title: 'Export Data',
            subtitle: 'Download your fitness data',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.delete_forever,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () {},
            textColor: AppColors.brightRed,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUPPORT',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.electricBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.help,
            title: 'Help & FAQ',
            subtitle: 'Get answers to common questions',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.contact_support,
            title: 'Contact Support',
            subtitle: 'Reach out to our team',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.brightRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brightRed,
          width: 1,
        ),
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          'SIGN OUT',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.brightRed,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.electricBlue,
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
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.electricBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.electricBlue,
          size: 20,
        ),
        dropdownColor: AppColors.card,
      ),
    );
  }
}
