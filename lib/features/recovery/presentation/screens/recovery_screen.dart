// lib/features/recovery/presentation/screens/recovery_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                      'Recovery',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(Icons.person, color: Colors.white),
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
                  Tab(text: 'Today'),
                  Tab(text: 'Sleep'),
                  Tab(text: 'Injuries'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTodayTab(),
                  _buildSleepTab(),
                  _buildInjuriesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recovery Score
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Recovery Score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.85, // 85% recovery
                        strokeWidth: 8,
                        backgroundColor: AppColors.card.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '85%',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neonGreen,
                          ),
                        ),
                        Text(
                          'Excellent',
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRecoveryMetric('Sleep', '8.5h', AppColors.electricBlue),
                    _buildRecoveryMetric('HRV', '72', AppColors.royalPurple),
                    _buildRecoveryMetric('Soreness', 'Low', AppColors.warmOrange),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recovery Activities
          const Text(
            'Recovery Activities',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            'Foam Rolling',
            'Lower body mobility',
            '15 min',
            Icons.sports_gymnastics,
            AppColors.neonGreen,
            true,
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            'Stretching',
            'Full body flexibility',
            '20 min',
            Icons.accessibility,
            AppColors.electricBlue,
            false,
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            'Ice Bath',
            'Inflammation reduction',
            '10 min',
            Icons.ac_unit,
            AppColors.royalPurple,
            false,
          ),

          const SizedBox(height: 24),

          // Massage Booking
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book Massage Therapy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Professional sports massage to enhance recovery and prevent injuries.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: NeonButton(
                        text: 'Book Now',
                        onPressed: () {},
                        size: NeonButtonSize.small,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeonButton(
                        text: 'Schedule',
                        onPressed: () {},
                        variant: NeonButtonVariant.outline,
                        size: NeonButtonSize.small,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleep Quality
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Sleep Quality',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSleepMetric('Duration', '8.5h', AppColors.neonGreen),
                    _buildSleepMetric('Quality', '85%', AppColors.electricBlue),
                    _buildSleepMetric('REM', '2.1h', AppColors.royalPurple),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sleep Stages (Last Night)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSleepStage('Deep Sleep', 0.25, '2.1h', AppColors.royalPurple),
                const SizedBox(height: 8),
                _buildSleepStage('REM Sleep', 0.20, '1.7h', AppColors.electricBlue),
                const SizedBox(height: 8),
                _buildSleepStage('Light Sleep', 0.45, '3.8h', AppColors.neonGreen),
                const SizedBox(height: 8),
                _buildSleepStage('Awake', 0.10, '0.9h', AppColors.warmOrange),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sleep Tips
          const Text(
            'Sleep Optimization Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            'Consistent Schedule',
            'Go to bed and wake up at the same time every day',
            Icons.schedule,
            AppColors.neonGreen,
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            'Cool Environment',
            'Keep your bedroom cool (65-68°F) for better sleep',
            Icons.thermostat,
            AppColors.electricBlue,
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            'Limit Screen Time',
            'Avoid screens 1 hour before bedtime',
            Icons.phone_android,
            AppColors.royalPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildInjuriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Injuries
          const Text(
            'Injury Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // No injuries card
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  Icons.health_and_safety,
                  size: 48,
                  color: AppColors.neonGreen,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Active Injuries',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Great job maintaining your physical health! Continue with proper recovery practices.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Injury Prevention
          const Text(
            'Injury Prevention',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildPreventionItem(
            'Dynamic Warm-up',
            'Always perform dynamic stretches before training',
            Icons.directions_run,
            AppColors.neonGreen,
          ),
          const SizedBox(height: 12),
          _buildPreventionItem(
            'Progressive Overload',
            'Gradually increase training intensity',
            Icons.trending_up,
            AppColors.electricBlue,
          ),
          const SizedBox(height: 12),
          _buildPreventionItem(
            'Recovery Days',
            'Include rest days in your training schedule',
            Icons.hotel,
            AppColors.royalPurple,
          ),

          const SizedBox(height: 24),

          // Report Injury
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report an Injury',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'If you experience any pain or discomfort, report it immediately for proper assessment.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                NeonButton(
                  text: 'Report Injury',
                  onPressed: () {},
                  variant: NeonButtonVariant.outline,
                  size: NeonButtonSize.medium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String description, String duration, IconData icon, Color color, bool completed) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (completed) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.check_circle,
                        color: AppColors.neonGreen,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepStage(String stage, double percentage, String duration, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            stage,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.card.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          duration,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String title, String description, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
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
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreventionItem(String title, String description, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
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
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
