import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../features/habits/presentation/pages/today_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/timer/presentation/pages/timer_page.dart';
import '../constants/app_constants.dart';
import '../storage/hive_boxes.dart';
import 'app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final box = Hive.box<dynamic>(HiveBoxes.settings);
      final tutorialShown =
          box.get('tutorial_shown', defaultValue: false) as bool;
      final location = state.uri.toString();

      if (!tutorialShown && location != AppConstants.onboardingRoute) {
        return AppConstants.onboardingRoute;
      }

      if (tutorialShown && location == '/') {
        return AppConstants.todayRoute;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.onboardingRoute,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.todayRoute,
                name: 'today',
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.historyRoute,
                name: 'history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.timerRoute,
                name: 'timer',
                builder: (context, state) => const TimerPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.settingsRoute,
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
