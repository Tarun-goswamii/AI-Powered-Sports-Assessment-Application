// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/test/presentation/screens/test_detail_screen.dart';
import '../../features/test/presentation/screens/calibration_screen.dart';
import '../../features/test/presentation/screens/recording_screen.dart';
import '../../features/test/presentation/screens/test_completion_screen.dart';
import '../../features/test/presentation/screens/personalized_solution_screen.dart';
import '../../features/test/presentation/screens/camera_calibration_screen.dart';
import '../../features/test/presentation/screens/video_recording_screen.dart';
import '../../features/test/presentation/screens/video_analysis_screen.dart';
import '../../features/test/presentation/screens/test_results_screen.dart';
import '../../features/results/presentation/screens/combined_results_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';
import '../../features/mentors/presentation/screens/mentor_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/store/presentation/screens/store_screen.dart';
import '../../features/credits/presentation/screens/credits_screen.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../../features/recovery/presentation/screens/recovery_screen.dart';
import '../../features/body_logs/presentation/screens/body_logs_screen.dart';
import '../../features/demo/presentation/screens/integration_demo_screen.dart';
import '../../features/ai_chat/ai_chat_screen.dart';
import '../../core/services/video_analysis_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // If we're on splash, always allow it to handle its own logic
      if (state.matchedLocation == '/splash') {
        return null;
      }
      
      // If we're on auth or onboarding routes, allow them
      if (state.matchedLocation == '/auth' || state.matchedLocation == '/onboarding') {
        return null;
      }
      
      // For all other routes, we'll let the splash screen handle authentication checks
      // The splash screen will redirect to auth if needed, or to home if authenticated
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/demo',
        builder: (context, state) => const IntegrationDemoScreen(),
      ),
      GoRoute(
        path: '/test-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final exerciseType = extra?['exercise_type'] as ExerciseType? ?? ExerciseType.sprint;
          return TestDetailScreen(exerciseType: exerciseType);
        },
      ),
      GoRoute(
        path: '/test/calibration',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final exerciseType = extra?['exercise_type'] as ExerciseType? ?? ExerciseType.sprint;
          return CameraCalibrationScreen(exerciseType: exerciseType);
        },
      ),
      GoRoute(
        path: '/test/recording',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final exerciseType = extra?['exercise_type'] as ExerciseType? ?? ExerciseType.sprint;
          final cameraController = extra?['camera_controller'];
          return VideoRecordingScreen(
            exerciseType: exerciseType,
            cameraController: cameraController,
          );
        },
      ),
      GoRoute(
        path: '/test/analysis',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final videoPath = extra?['video_path'] as String? ?? '';
          final exerciseType = extra?['exercise_type'] as ExerciseType? ?? ExerciseType.sprint;
          return VideoAnalysisScreen(
            videoPath: videoPath,
            exerciseType: exerciseType,
          );
        },
      ),
      GoRoute(
        path: '/test/results',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final results = extra?['results'] as ExerciseMetrics?;
          final exerciseType = extra?['exercise_type'] as ExerciseType? ?? ExerciseType.sprint;
          return TestResultsScreen(
            results: results!,
            exerciseType: exerciseType,
          );
        },
      ),
      GoRoute(
        path: '/calibration',
        builder: (context, state) => const CalibrationScreen(),
      ),
      GoRoute(
        path: '/recording',
        builder: (context, state) => const RecordingScreen(),
      ),
      GoRoute(
        path: '/test-completion',
        builder: (context, state) => const TestCompletionScreen(),
      ),
      GoRoute(
        path: '/personalized-solution',
        builder: (context, state) => const PersonalizedSolutionScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const CombinedResultsScreen(),
          ),
          GoRoute(
            path: '/community',
            builder: (context, state) => const CommunityScreen(),
          ),
          GoRoute(
            path: '/mentors',
            builder: (context, state) => const MentorScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/help',
            builder: (context, state) => const HelpScreen(),
          ),
          GoRoute(
            path: '/store',
            builder: (context, state) => const StoreScreen(),
          ),
          GoRoute(
            path: '/credits',
            builder: (context, state) => const CreditsScreen(),
          ),
          GoRoute(
            path: '/leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: '/nutrition',
            builder: (context, state) => const NutritionScreen(),
          ),
          GoRoute(
            path: '/recovery',
            builder: (context, state) => const RecoveryScreen(),
          ),
          GoRoute(
            path: '/body-logs',
            builder: (context, state) => const BodyLogsScreen(),
          ),
          GoRoute(
            path: '/ai-coach',
            builder: (context, state) => const AIChatScreen(),
          ),
        ],
      ),
    ],
  );
}

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  late AnimationController _navAnimationController;
  late Animation<double> _navAnimation;

  @override
  void initState() {
    super.initState();
    _setupNavAnimation();
  }

  void _setupNavAnimation() {
    _navAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _navAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _navAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _navAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AnimatedBuilder(
        animation: _navAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, (1 - _navAnimation.value) * 100),
            child: Opacity(
              opacity: _navAnimation.value,
              child: _buildBottomNavigationBar(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1A1A1A).withOpacity(0.95),
            const Color(0xFF121212).withOpacity(0.98),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF333333).withOpacity(0.3),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF6A0DAD),
        unselectedItemColor: const Color(0xB3FFFFFF),
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        iconSize: 24.0,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home_rounded, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            activeIcon: Icon(Icons.bar_chart_rounded, size: 28),
            label: 'Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded, size: 28),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_rounded),
            activeIcon: Icon(Icons.supervisor_account_rounded, size: 28),
            label: 'Mentors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            activeIcon: Icon(Icons.person_rounded, size: 28),
            label: 'Profile',
          ),
        ],
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/community');
              break;
            case 3:
              context.go('/mentors');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }

  static int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/community')) return 2;
    if (location.startsWith('/mentors')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  void dispose() {
    _navAnimationController.dispose();
    super.dispose();
  }
}
