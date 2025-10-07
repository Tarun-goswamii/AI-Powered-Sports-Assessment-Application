// lib/features/home/presentation/widgets/daily_login_bonus.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DailyLoginBonus extends StatelessWidget {
  const DailyLoginBonus({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: AppColors.glassmorphismDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard, size: 64, color: AppColors.neonGreen),
            const SizedBox(height: 16),
            const Text(
              '🎉 Daily Bonus!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You earned 10 credit points!',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.royalPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Claim Reward'),
            ),
          ],
        ),
      ),
    );
  }
}
