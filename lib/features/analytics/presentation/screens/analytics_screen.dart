// lib/features/analytics/presentation/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/enhanced_snackbar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample analytics data
  final Map<String, dynamic> analyticsData = {
    'performanceTrends': [
      {'month': 'Jan', 'score': 65, 'tests': 3},
      {'month': 'Feb', 'score': 72, 'tests': 5},
      {'month': 'Mar', 'score': 78, 'tests': 4},
      {'month': 'Apr', 'score': 82, 'tests': 6},
      {'month': 'May', 'score': 85, 'tests': 7},
      {'month': 'Jun', 'score': 88, 'tests': 8},
    ],
    'testBreakdown': [
      {'name': 'Vertical Jump', 'count': 12, 'avgScore': 85, 'color': AppColors.neonGreen},
      {'name': 'Shuttle Run', 'count': 8, 'avgScore': 78, 'color': AppColors.electricBlue},
      {'name': 'Sit-ups', 'count': 15, 'avgScore': 92, 'color': AppColors.warmOrange},
      {'name': 'Endurance', 'count': 6, 'avgScore': 75, 'color': AppColors.royalPurple},
    ],
    'weeklyActivity': [
      {'day': 'Mon', 'tests': 2, 'minutes': 45},
      {'day': 'Tue', 'tests': 1, 'minutes': 30},
      {'day': 'Wed', 'tests': 3, 'minutes': 60},
      {'day': 'Thu', 'tests': 2, 'minutes': 40},
      {'day': 'Fri', 'tests': 1, 'minutes': 25},
      {'day': 'Sat', 'tests': 4, 'minutes': 80},
      {'day': 'Sun', 'tests': 2, 'minutes': 50},
    ],
    'strengths': [
      'Core Strength (92% avg)',
      'Explosive Power (85% avg)',
      'Agility (78% avg)',
      'Cardiovascular Endurance (75% avg)',
    ],
    'improvementAreas': [
      'Speed Endurance',
      'Reaction Time',
      'Flexibility',
      'Recovery Rate',
    ],
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.go('/profile'),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _exportAnalytics,
            icon: const Icon(Icons.download_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: AnimationLimiter(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 600),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      // Performance Overview
                      _buildPerformanceOverview(),

                      const SizedBox(height: 24),

                      // Performance Trends Chart
                      _buildPerformanceTrends(),

                      const SizedBox(height: 24),

                      // Test Breakdown
                      _buildTestBreakdown(),

                      const SizedBox(height: 24),

                      // Weekly Activity
                      _buildWeeklyActivity(),

                      const SizedBox(height: 24),

                      // Strengths & Improvements
                      _buildStrengthsAndImprovements(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceOverview() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      enableNeonGlow: true,
      neonGlowColor: AppColors.electricBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricBlue.withOpacity(0.8),
                      AppColors.electricBlue.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.electricBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your fitness journey insights',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              _buildOverviewStat(
                'Total Tests',
                '50',
                Icons.science_rounded,
                AppColors.neonGreen,
              ),
              const SizedBox(width: 16),
              _buildOverviewStat(
                'Avg Score',
                '82%',
                Icons.trending_up_rounded,
                AppColors.warmOrange,
              ),
              const SizedBox(width: 16),
              _buildOverviewStat(
                'Best Test',
                'Vertical Jump',
                Icons.emoji_events_rounded,
                AppColors.royalPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTrends() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart_rounded,
                color: AppColors.neonGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Performance Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.border.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                      interval: 20,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 60,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: analyticsData['performanceTrends']
                        .map<FlSpot>((item) => FlSpot(
                              analyticsData['performanceTrends'].indexOf(item).toDouble(),
                              item['score'].toDouble(),
                            ))
                        .toList(),
                    isCurved: true,
                    color: AppColors.neonGreen,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.neonGreen,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.neonGreen.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Consistent improvement over 6 months',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestBreakdown() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart_rounded,
                color: AppColors.warmOrange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Test Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...analyticsData['testBreakdown'].map<Widget>((test) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: test['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      test['name'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${test['count']} tests',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: test['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: test['color'].withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${test['avgScore']}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: test['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivity() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_view_week_rounded,
                color: AppColors.royalPurple,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Weekly Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: analyticsData['weeklyActivity'].map<Widget>((day) {
              final index = analyticsData['weeklyActivity'].indexOf(day);
              final isToday = index == 6; // Assuming Sunday is today

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.royalPurple.withOpacity(0.6),
                              AppColors.royalPurple.withOpacity(0.3),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isToday
                                ? AppColors.royalPurple
                                : AppColors.royalPurple.withOpacity(0.3),
                            width: isToday ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: (day['tests'] * 8.0).clamp(10, 60),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.royalPurple,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '${day['tests']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        day['day'].substring(0, 3),
                        style: TextStyle(
                          fontSize: 12,
                          color: isToday ? AppColors.royalPurple : AppColors.textSecondary,
                          fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Total: 13 tests • 330 minutes this week',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsAndImprovements() {
    return Row(
      children: [
        // Strengths
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_rounded,
                      color: AppColors.neonGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Strengths',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...analyticsData['strengths'].map<Widget>((strength) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            strength,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Areas for Improvement
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: AppColors.warmOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Focus Areas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...analyticsData['improvementAreas'].map<Widget>((area) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.warmOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            area,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _exportAnalytics() {
    EnhancedSnackbar.showInfo(
      context,
      'Analytics exported successfully!',
      actionLabel: 'View',
      action: () {
        // TODO: Open exported file
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
