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

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
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
        path: '/test-detail',
        builder: (context, state) => const TestDetailScreen(),
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
        ],
      ),
    ],
  );
}

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFF6A0DAD),
        unselectedItemColor: const Color(0xB3FFFFFF),
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        iconSize: 24.0,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Results'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Mentors'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
}
