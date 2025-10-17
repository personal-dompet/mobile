import 'package:dompet/features/auth/presentation/widgets/auth_guard.dart';
import 'package:dompet/features/home/presentation/widgets/header.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.dashboard.path,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        final path = state.uri.toString();
        final routeName = Routes.fromPath(path).name;

        return Scaffold(
          appBar: HeaderAppBar(title: routeName),
          body: SafeArea(
            child: AuthGuard(child: child),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _calculateIndex(state),
            iconSize: 32,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Dompet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet_rounded),
                label: 'Pocket',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card_rounded),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart_rounded),
                label: 'Analytic',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 1:
                  PocketRoute().go(context);
                  break;
                case 2:
                  AccountRoute().go(context);
                  break;
                case 3:
                  AnalyticsRoute().go(context);
                  break;
                default:
                  DashboardRoute().go(context);
              }
            },
          ),
          // floatingActionButton: const SpeedDialFab(),
        );
      },
      routes: [
        DashboardRoute().goRoute,
        PocketRoute().goRoute,
        AccountRoute().goRoute,
        AnalyticsRoute().goRoute,
      ],
    ),
    // Top Up page route (not using shell route layout)
    TopUpRoute().goRoute,
    CreatePocketRoute().goRoute,
    CreateSpendingPocketRoute().goRoute,
    CreateSavingPocketRoute().goRoute,
    CreateRecurringPocketRoute().goRoute,
    SelectPocketRoute().goRoute,
    SelectAccountRoute().goRoute,
    CreateAccountRoute().goRoute,
    CreatePocketTransferRoute().goRoute,
    CreateAccountTransferRoute().goRoute,
  ],
);

int _calculateIndex(GoRouterState state) {
  final path = state.uri.toString();
  final route = Routes.fromPath(path);
  if (route == Routes.pockets) return 1;
  if (route == Routes.accounts) return 2;
  if (route == Routes.analytics) return 3;
  return 0;
}
