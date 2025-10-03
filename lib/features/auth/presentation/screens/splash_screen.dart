// lib/features/auth/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_persistence_service.dart';
import '../../../../core/utils/responsive_utils.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  late AnimationController _textAnimationController;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNextScreen();
  }

  void _setupAnimations() {
    // Logo animations
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeIn,
    ));

    // Text animations
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _logoAnimationController.forward().then((_) {
      _textAnimationController.forward();
    });
  }

  void _navigateToNextScreen() async {
    // Wait for animations to complete
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    try {
      // Check authentication status using our persistence service
      final isLoggedIn = await AuthPersistenceService.isLoggedIn();
      
      if (isLoggedIn) {
        // User is logged in, go to home
        context.go('/home');
      } else {
        // Check if user has seen onboarding using SharedPreferences directly
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
        
        if (hasSeenOnboarding) {
          context.go('/auth');
        } else {
          context.go('/onboarding');
        }
      }
    } catch (e) {
      // On error, go to auth screen
      context.go('/auth');
    }
  }

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedBuilder(
                  animation: _logoAnimationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Container(
                          width: responsive.wp(32).clamp(100.0, 140.0),
                          height: responsive.wp(32).clamp(100.0, 140.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.royalPurple.withOpacity(0.8),
                                AppColors.electricBlue.withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(responsive.wp(8)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.royalPurple.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: AppColors.electricBlue.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.sports_soccer,
                            color: Colors.white,
                            size: responsive.sp(60).clamp(50.0, 70.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: responsive.hp(5)),
                // Animated text
                AnimatedBuilder(
                  animation: _textAnimationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _textSlideAnimation,
                      child: Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: Column(
                          children: [
                            Text(
                              'Sports Assessment',
                              style: TextStyle(
                                fontSize: responsive.sp(28).clamp(24.0, 32.0),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: responsive.hp(1)),
                            Text(
                              'AI-Powered Talent Evaluation',
                              style: TextStyle(
                                fontSize: responsive.sp(16).clamp(14.0, 18.0),
                                color: AppColors.textSecondary.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.royalPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }
}
