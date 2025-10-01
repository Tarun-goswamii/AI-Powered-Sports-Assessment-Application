// lib/features/home/presentation/widgets/test_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

enum TestStatus { notStarted, inProgress, completed }

class TestCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final TestStatus status;
  final VoidCallback? onStartTest;
  final int? duration;
  final String? difficulty;

  const TestCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
    this.onStartTest,
    this.duration,
    this.difficulty,
  });

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onStartTest,
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          enableNeonGlow: widget.status == TestStatus.completed,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getStatusColor().withOpacity(0.8),
                      _getStatusColor().withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor().withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              if (widget.status == TestStatus.completed)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.neonGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.card,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withOpacity(0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.duration != null || widget.difficulty != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.duration != null) ...[
                  Icon(
                    Icons.timer,
                    size: 14,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.duration}min',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (widget.difficulty != null) ...[
                  if (widget.duration != null) const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getDifficultyColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.difficulty!,
                      style: TextStyle(
                        fontSize: 10,
                        color: _getDifficultyColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: 16),
          NeonButton(
            text: statusConfig['buttonText'] as String,
            size: NeonButtonSize.small,
            onPressed: widget.onStartTest,
          ),
        ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig() {
    switch (widget.status) {
      case TestStatus.notStarted:
        return {
          'badge': 'Not Started',
          'badgeColor': AppColors.textSecondary.withOpacity(0.2),
          'textColor': AppColors.textSecondary,
          'buttonText': 'Start Test',
        };
      case TestStatus.inProgress:
        return {
          'badge': 'In Progress',
          'badgeColor': AppColors.warmOrange.withOpacity(0.2),
          'textColor': AppColors.warmOrange,
          'buttonText': 'Continue',
        };
      case TestStatus.completed:
        return {
          'badge': 'Completed',
          'badgeColor': AppColors.neonGreen.withOpacity(0.2),
          'textColor': AppColors.neonGreen,
          'buttonText': 'View Results',
        };
    }
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case TestStatus.notStarted:
        return AppColors.textSecondary;
      case TestStatus.inProgress:
        return AppColors.warmOrange;
      case TestStatus.completed:
        return AppColors.neonGreen;
    }
  }

  Color _getDifficultyColor() {
    if (widget.difficulty == null) return AppColors.textSecondary;

    switch (widget.difficulty!.toLowerCase()) {
      case 'easy':
        return AppColors.neonGreen;
      case 'medium':
        return AppColors.warmOrange;
      case 'hard':
        return AppColors.brightRed;
      default:
        return AppColors.textSecondary;
    }
  }
}
