// lib/features/auth/presentation/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Assess Your\nAthletic Potential',
      description: 'Discover your true athletic capabilities with our comprehensive fitness assessment platform designed for athletes across India.',
      icon: Icons.sports_soccer,
      gradient: LinearGradient(
        colors: [AppColors.royalPurple, AppColors.electricBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    OnboardingPage(
      title: 'AI-Powered\nPerformance Analysis',
      description: 'Get detailed insights and personalized recommendations powered by advanced AI algorithms that understand your unique athletic profile.',
      icon: Icons.analytics,
      gradient: LinearGradient(
        colors: [AppColors.electricBlue, AppColors.neonGreen],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    OnboardingPage(
      title: 'Join India\'s Largest\nSports Community',
      description: 'Connect with athletes, coaches, and sports enthusiasts nationwide. Share achievements, get motivated, and grow together.',
      icon: Icons.people,
      gradient: LinearGradient(
        colors: [AppColors.neonGreen, AppColors.warmOrange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveUtils(context);
        final iconSize = responsive.wp(40).clamp(120.0, 200.0);
        
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(6)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: responsive.hp(2)),
                  // Animated icon
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      gradient: page.gradient,
                      borderRadius: BorderRadius.circular(responsive.wp(10)),
                      boxShadow: [
                        BoxShadow(
                          color: page.gradient.colors.first.withOpacity(0.4),
                          blurRadius: responsive.wp(8),
                          spreadRadius: responsive.wp(1.3),
                        ),
                        BoxShadow(
                          color: page.gradient.colors.last.withOpacity(0.3),
                          blurRadius: responsive.wp(5),
                          spreadRadius: responsive.wp(0.5),
                        ),
                      ],
                    ),
                    child: Icon(
                      page.icon,
                      color: Colors.white,
                      size: responsive.sp(50).clamp(60.0, 100.0),
                    ),
                  ),
                  SizedBox(height: responsive.hp(6)),
                  // Title
                  Text(
                    page.title,
                    style: TextStyle(
                      fontSize: responsive.sp(28).clamp(24.0, 36.0),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: responsive.hp(3)),
                  // Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                    child: Text(
                      page.description,
                      style: TextStyle(
                        fontSize: responsive.sp(16).clamp(14.0, 20.0),
                        color: AppColors.textSecondary.withOpacity(0.9),
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveUtils(context);
        
        return Container(
          padding: EdgeInsets.all(responsive.wp(6)),
          child: Column(
            children: [
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: responsive.wp(1)),
                    width: _currentPage == index ? responsive.wp(6) : responsive.wp(2),
                    height: responsive.wp(2),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.royalPurple
                          : AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(responsive.wp(1)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsive.hp(4)),
              // Buttons
              Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.hp(1.5),
                          ),
                        ),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: responsive.sp(16).clamp(14.0, 18.0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (_currentPage > 0) SizedBox(width: responsive.wp(4)),
                  Expanded(
                    flex: _currentPage == 0 ? 1 : 2,
                    child: NeonButton(
                      text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      onPressed: _currentPage == _pages.length - 1
                          ? _completeOnboarding
                          : _nextPage,
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(2)),
              // Skip button
              TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(6),
                    vertical: responsive.hp(1),
                  ),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: responsive.sp(14).clamp(12.0, 16.0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() async {
    // Save onboarding completion to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (mounted) {
      context.go('/auth');
    }
  }

  void _skipOnboarding() async {
    // Save onboarding completion to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (mounted) {
      context.go('/auth');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
