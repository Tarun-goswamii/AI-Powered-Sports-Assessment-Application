// lib/features/results/presentation/screens/combined_results_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class CombinedResultsScreen extends StatefulWidget {
  const CombinedResultsScreen({super.key});

  @override
  State<CombinedResultsScreen> createState() => _CombinedResultsScreenState();
}

class _CombinedResultsScreenState extends State<CombinedResultsScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  String _selectedSort = 'Newest';

  final List<Map<String, dynamic>> testResults = [
    {
      'id': '1',
      'testName': 'Vertical Jump',
      'score': 45.2,
      'unit': 'cm',
      'percentile': 78,
      'grade': 'Excellent',
      'date': '2024-01-15',
      'status': 'completed',
    },
    {
      'id': '2',
      'testName': 'Shuttle Run',
      'score': 8.5,
      'unit': 'seconds',
      'percentile': 65,
      'grade': 'Good',
      'date': '2024-01-12',
      'status': 'completed',
    },
    {
      'id': '3',
      'testName': 'Sit-ups',
      'score': 42,
      'unit': 'reps',
      'percentile': 82,
      'grade': 'Excellent',
      'date': '2024-01-10',
      'status': 'completed',
    },
    {
      'id': '4',
      'testName': 'Endurance Run',
      'score': 1850,
      'unit': 'meters',
      'percentile': 71,
      'grade': 'Good',
      'date': '2024-01-08',
      'status': 'completed',
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
          'Test History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Filters and Sort
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSortDropdown(),
                  ),
                ],
              ),
            ),

            // Stats Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('Total Tests', '15', AppColors.electricBlue),
                    ),
                    Expanded(
                      child: _buildStatItem('Avg Score', '78%', AppColors.neonGreen),
                    ),
                    Expanded(
                      child: _buildStatItem('Best Test', 'Vertical Jump', AppColors.warmOrange),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Results List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: testResults.length,
                itemBuilder: (context, index) {
                  final result = testResults[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildResultCard(result),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButton<String>(
        value: _selectedFilter,
        isExpanded: true,
        dropdownColor: AppColors.card,
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox(),
        items: ['All', 'This Week', 'This Month', 'Excellent', 'Good', 'Average']
            .map((filter) => DropdownMenuItem(
                  value: filter,
                  child: Text(filter),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedFilter = value!;
          });
        },
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButton<String>(
        value: _selectedSort,
        isExpanded: true,
        dropdownColor: AppColors.card,
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox(),
        items: ['Newest', 'Oldest', 'Highest Score', 'Lowest Score']
            .map((sort) => DropdownMenuItem(
                  value: sort,
                  child: Text(sort),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedSort = value!;
          });
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    Color gradeColor;
    switch (result['grade']) {
      case 'Excellent':
        gradeColor = AppColors.neonGreen;
        break;
      case 'Good':
        gradeColor = AppColors.electricBlue;
        break;
      case 'Average':
        gradeColor = AppColors.warmOrange;
        break;
      default:
        gradeColor = AppColors.textSecondary;
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      onTap: () => _viewDetailedResult(result),
      child: Row(
        children: [
          // Test Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppGradients.purpleBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTestIcon(result['testName']),
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Test Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result['testName'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result['date'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Score and Grade
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${result['score']} ${result['unit']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gradeColor.withOpacity(0.3)),
                ),
                child: Text(
                  result['grade'],
                  style: TextStyle(
                    fontSize: 12,
                    color: gradeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Percentile
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${result['percentile']}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Percentile',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTestIcon(String testName) {
    switch (testName) {
      case 'Vertical Jump':
        return Icons.arrow_upward;
      case 'Shuttle Run':
        return Icons.directions_run;
      case 'Sit-ups':
        return Icons.fitness_center;
      case 'Endurance Run':
        return Icons.timer;
      default:
        return Icons.sports;
    }
  }

  void _viewDetailedResult(Map<String, dynamic> result) {
    // Navigate to detailed result screen
    // TODO: Implement detailed result screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${result['testName']} results')),
    );
  }
}

// Import needed for gradients
class AppGradients {
  static const LinearGradient purpleBlue = LinearGradient(
    colors: [Color(0xFF6A0DAD), Color(0xFF007BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
