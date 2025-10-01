// lib/features/results/presentation/widgets/analytics_charts.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';

class PerformancePieChart extends StatelessWidget {
  final List<Map<String, dynamic>> testResults;

  const PerformancePieChart({
    super.key,
    required this.testResults,
  });

  @override
  Widget build(BuildContext context) {
    final sportData = _aggregateScoresBySport();

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: sportData.entries.map((entry) {
            return PieChartSectionData(
              color: _getColorForSport(entry.key),
              value: entry.value,
              title: '${entry.value.toStringAsFixed(1)}%',
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Map<String, double> _aggregateScoresBySport() {
    if (testResults.isEmpty) {
      return {
        'Vertical Jump': 20.0,
        'Shuttle Run': 20.0,
        'Sit-ups': 20.0,
        'Endurance': 20.0,
        'Others': 20.0,
      };
    }

    Map<String, List<double>> sportScores = {};
    for (var result in testResults) {
      final sport = result['testType'] as String? ?? 'Others';
      final score = (result['score'] as num?)?.toDouble() ?? 0.0;
      sportScores.putIfAbsent(sport, () => []).add(score);
    }

    // Calculate average scores
    Map<String, double> averages = {};
    double total = 0.0;
    sportScores.forEach((sport, scores) {
      final avg = scores.reduce((a, b) => a + b) / scores.length;
      averages[sport] = avg;
      total += avg;
    });

    // Convert to percentages
    if (total > 0) {
      averages.updateAll((key, value) => (value / total) * 100);
    }

    return averages;
  }

  Color _getColorForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'vertical jump':
        return AppColors.royalPurple;
      case 'shuttle run':
        return const Color(0xFF9333EA);
      case 'sit-ups':
      case 'situps':
        return AppColors.warmOrange;
      case 'endurance':
        return AppColors.neonGreen;
      default:
        return const Color(0xFFEC4899);
    }
  }
}

class PerformanceLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> testResults;
  final String? filterSport;

  const PerformanceLineChart({
    super.key,
    required this.testResults,
    this.filterSport,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = _prepareChartData();

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= chartData.length) return const Text('');
                  final date = chartData[value.toInt()]['date'] as DateTime;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.month}/${date.day}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          minX: 0,
          maxX: chartData.isEmpty ? 10 : chartData.length.toDouble() - 1,
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: chartData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value['score'] as double,
                );
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.royalPurple,
                  const Color(0xFF9333EA),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: AppColors.royalPurple,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.royalPurple.withOpacity(0.3),
                    const Color(0xFF9333EA).withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'Score: ${spot.y.toStringAsFixed(1)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _prepareChartData() {
    if (testResults.isEmpty) {
      // Return sample data
      return List.generate(7, (index) {
        return {
          'date': DateTime.now().subtract(Duration(days: 6 - index)),
          'score': 5.0 + (index * 0.5),
        };
      });
    }

    var filtered = testResults;
    if (filterSport != null) {
      filtered = testResults
          .where((r) => r['testType'] == filterSport)
          .toList();
    }

    // Sort by date
    filtered.sort((a, b) {
      final aDate = DateTime.fromMillisecondsSinceEpoch(a['timestamp'] ?? 0);
      final bDate = DateTime.fromMillisecondsSinceEpoch(b['timestamp'] ?? 0);
      return aDate.compareTo(bDate);
    });

    return filtered.take(10).map((result) {
      return {
        'date': DateTime.fromMillisecondsSinceEpoch(
          result['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
        ),
        'score': (result['score'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();
  }
}

class SportPerformanceBar extends StatelessWidget {
  final List<Map<String, dynamic>> testResults;

  const SportPerformanceBar({
    super.key,
    required this.testResults,
  });

  @override
  Widget build(BuildContext context) {
    final sportData = _aggregateAverageScores();

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${sportData.keys.elementAt(groupIndex)}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: rod.toY.toStringAsFixed(1),
                      style: TextStyle(
                        color: _getColorForSport(
                          sportData.keys.elementAt(groupIndex),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= sportData.length) return const Text('');
                  final sport = sportData.keys.elementAt(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getShortName(sport),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          barGroups: sportData.entries.map((entry) {
            final index = sportData.keys.toList().indexOf(entry.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  gradient: LinearGradient(
                    colors: [
                      _getColorForSport(entry.key),
                      _getColorForSport(entry.key).withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  Map<String, double> _aggregateAverageScores() {
    if (testResults.isEmpty) {
      return {
        'V.Jump': 6.5,
        'Shuttle': 7.2,
        'Sit-ups': 8.0,
        'Endurance': 5.8,
        'Others': 6.0,
      };
    }

    Map<String, List<double>> sportScores = {};
    for (var result in testResults) {
      final sport = result['testType'] as String? ?? 'Others';
      final score = (result['score'] as num?)?.toDouble() ?? 0.0;
      sportScores.putIfAbsent(sport, () => []).add(score);
    }

    // Calculate averages
    Map<String, double> averages = {};
    sportScores.forEach((sport, scores) {
      averages[sport] = scores.reduce((a, b) => a + b) / scores.length;
    });

    return averages;
  }

  String _getShortName(String sport) {
    switch (sport.toLowerCase()) {
      case 'vertical jump':
        return 'V.Jump';
      case 'shuttle run':
        return 'Shuttle';
      case 'sit-ups':
      case 'situps':
        return 'Sit-ups';
      case 'endurance':
        return 'Endurance';
      default:
        return sport.length > 8 ? sport.substring(0, 7) : sport;
    }
  }

  Color _getColorForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'vertical jump':
      case 'v.jump':
        return AppColors.royalPurple;
      case 'shuttle run':
      case 'shuttle':
        return const Color(0xFF9333EA);
      case 'sit-ups':
      case 'situps':
        return AppColors.warmOrange;
      case 'endurance':
        return AppColors.neonGreen;
      default:
        return const Color(0xFFEC4899);
    }
  }
}
