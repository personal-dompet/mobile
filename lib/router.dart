import 'package:dompet/features/account/presentation/pages/account_page.dart';
import 'package:dompet/features/account/presentation/pages/create_account_page.dart';
import 'package:dompet/features/account/presentation/pages/select_account_page.dart';
import 'package:dompet/features/account/presentation/pages/select_account_type_page.dart';
import 'package:dompet/features/auth/presentation/widgets/auth_guard.dart';
import 'package:dompet/features/home/presentation/pages/home_page.dart';
import 'package:dompet/features/home/presentation/widgets/header.dart';
import 'package:dompet/features/pocket/presentation/pages/create_pocket_page.dart';
import 'package:dompet/features/pocket/presentation/pages/pocket_page.dart';
import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart';
import 'package:dompet/features/pocket/presentation/pages/select_pocket_type_page.dart';
import 'package:dompet/features/transaction/presentation/pages/top_up_page.dart';
import 'package:dompet/features/transfer/presentation/pages/create_transfer_page.dart';
import 'package:dompet/features/transfer/presentation/pages/transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        String? routeName;
        final path = state.uri.toString();
        if (path == '/' || path.isEmpty) {
          routeName = 'Dompet';
        } else if (path.startsWith('/pockets')) {
          routeName = 'Pocket';
        } else if (path.startsWith('/accounts')) {
          routeName = 'Account';
        } else if (path.startsWith('/analytics')) {
          routeName = 'Analytic';
        }

        return Scaffold(
          appBar: HeaderAppBar(title: routeName ?? 'Dompet'),
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
                  context.go('/pockets');
                  break;
                case 2:
                  context.go('/accounts');
                  break;
                case 3:
                  context.go('/analytics');
                  break;
                default:
                  context.go('/');
              }
            },
          ),
          // floatingActionButton: const SpeedDialFab(),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildPageWithNoTransition(
              context: context, state: state, child: HomePage()),
          name: 'Dompet',
        ),
        GoRoute(
          path: '/pockets',
          pageBuilder: (context, state) => _buildPageWithNoTransition(
              context: context, state: state, child: PocketPage()),
          name: 'Pocket',
        ),
        GoRoute(
          path: '/accounts',
          pageBuilder: (context, state) => _buildPageWithNoTransition(
              context: context, state: state, child: AccountPage()),
          name: 'Account',
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => _buildPageWithNoTransition(
              context: context, state: state, child: TransferPage()),
          name: 'Analytic',
        ),
      ],
    ),
    // Top Up page route (not using shell route layout)
    GoRoute(
      path: '/top-up',
      pageBuilder: (context, state) {
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: TopUpPage(),
        );
      },
      name: 'TopUp',
    ),
    GoRoute(
      path: '/pockets/types',
      pageBuilder: (context, state) {
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: SelectPocketTypePage(),
        );
      },
      name: 'SelectPocketType',
    ),
    GoRoute(
      path: '/pockets/create',
      pageBuilder: (context, state) {
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: CreatePocketPage(),
        );
      },
      name: 'CreatePocket',
    ),
    GoRoute(
      path: '/pockets/select',
      pageBuilder: (context, state) {
        final selectedAccountId =
            int.tryParse(state.uri.queryParameters['selectedAccountId'] ?? '');
        final title = SelectPocketTitle.fromValue(
            state.uri.queryParameters['title'] ??
                SelectPocketTitle.general.value);
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: SelectPocketPage(
            selectedPocketId: selectedAccountId,
            title: title ?? SelectPocketTitle.general,
          ),
        );
      },
      name: 'SelectPocket',
    ),
    GoRoute(
      path: '/accounts/select',
      pageBuilder: (context, state) {
        final selectedAccountId =
            int.tryParse(state.uri.queryParameters['selectedAccountId'] ?? '');
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: SelectAccountPage(selectedAccountId: selectedAccountId),
        );
      },
      name: 'SelectAccount',
    ),
    GoRoute(
      path: '/accounts/types',
      pageBuilder: (context, state) {
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: SelectAccountTypePage(),
        );
      },
      name: 'SelectAccountType',
    ),
    GoRoute(
      path: '/accounts/create',
      pageBuilder: (context, state) {
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: CreateAccountPage(),
        );
      },
      name: 'CreateAccount',
    ),
    GoRoute(
      path: '/transfers/create',
      pageBuilder: (context, state) {
        return _buildPageWithNoTransition(
          context: context,
          state: state,
          child: CreateTransferPage(),
        );
      },
      name: 'CreateTransfer',
    ),
  ],
);

int _calculateIndex(GoRouterState state) {
  final path = state.uri.toString();
  if (path.startsWith('/pockets')) return 1;
  if (path.startsWith('/accounts')) return 2;
  if (path.startsWith('/analytics')) return 3;
  return 0;
}

NoTransitionPage _buildPageWithNoTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return NoTransitionPage<T>(
    key: state.pageKey,
    child: child,
  );
}
