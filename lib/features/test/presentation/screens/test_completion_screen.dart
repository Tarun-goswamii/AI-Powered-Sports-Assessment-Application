// lib/features/test/presentation/screens/test_completion_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/utils/responsive_utils.dart';

class TestCompletionScreen extends StatelessWidget {
  const TestCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: GlassCard(
                  padding: EdgeInsets.all(responsive.wp(6)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Test Completed!',
                        style: TextStyle(
                          fontSize: responsive.sp(24).clamp(22.0, 28.0),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: responsive.hp(2)),
                      Text(
                        'Your test has been recorded successfully. AI analysis is in progress.',
                        style: TextStyle(
                          fontSize: responsive.sp(16).clamp(14.0, 18.0),
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: responsive.hp(4)),
                      NeonButton(
                        text: 'View Results',
                        onPressed: () => context.go('/personalized-solution'),
                      ),
                    ],
                  ),
                ),
              ),
              // Back Button
              Positioned(
                top: responsive.hp(2.5),
                left: responsive.wp(5),
                child: IconButton(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.card.withOpacity(0.5),
                    padding: EdgeInsets.all(responsive.wp(3)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
