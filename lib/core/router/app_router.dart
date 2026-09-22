import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/lock_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/recycle_bin_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/important_dates/presentation/screens/personal_space_screen.dart';
import '../../features/cards_vault/presentation/screens/cards_screen.dart';
import '../../features/cards_vault/presentation/screens/card_detail_screen.dart';
import '../../features/cards_vault/domain/credit_card.dart';
import '../../shared/widgets/main_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LockScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cards',
              builder: (context, state) => const CardsScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    CreditCard card;
                    String? action;
                    if (state.extra is Map<String, dynamic>) {
                      final map = state.extra as Map<String, dynamic>;
                      card = map['card'] as CreditCard;
                      action = map['action'] as String?;
                    } else {
                      card = state.extra as CreditCard;
                    }
                    return CardDetailScreen(card: card, initialAction: action);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/personal_space',
              builder: (context, state) => PersonalSpaceScreen(initialAction: state.extra as String?),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/recycle_bin',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecycleBinScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
