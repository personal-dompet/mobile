import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  dashboard('/dashboard', 'Dashboard'),
  pockets('/pockets', 'Pocket'),
  accounts('/accounts', 'Account'),
  analytics('/analytics', 'Analytic'),
  topUp('/top-up', 'TopUp'),
  createPocket('/pockets/create', 'CreatePocket'),
  createSpendingPocket('/pockets/spendings/create', 'CreateSpendingPocket'),
  createSavingPocket('/pockets/savings/create', 'CreateSavingPocket'),
  createRecurringPocket('/pockets/recurrings/create', 'CreateRecurringPocket'),
  selectPocket('/pockets/select', 'SelectPocket'),
  selectAccount('/accounts/select', 'SelectAccount'),
  createAccount('/accounts/create', 'CreateAccount'),
  createAccountDetail('/accounts/create/detail', 'CreateAccountDetail'),
  createPocketTransfer('/transfers/pockets/create', 'CreatePocketTransfer'),
  createAccountTransfer('/transfers/accounts/create', 'CreateAccountTransfer');

  final String path;
  final String name;

  const Routes(this.path, this.name);

  static Routes fromPath(String path) {
    for (final route in Routes.values) {
      if (path.startsWith(route.path)) {
        return route;
      }
    }
    // Default to 'dashboard' if no match found
    return dashboard;
  }

  static Routes fromName(String name) {
    for (final route in Routes.values) {
      if (route.name == name) {
        return route;
      }
    }
    // Default to 'dashboard' if no match found
    return dashboard;
  }
}

/// Base class for all app routes, providing common functionality
/// for navigation with type-safe parameters
abstract class AppRoute {
  /// The enum value that represents this route
  Routes get route;

  /// Get the path for this route
  String get path => route.path;
  String get name => route.name;

  /// Builds the page widget for this route
  Widget buildPage(BuildContext context, GoRouterState state);

  /// Getter for GoRoute
  GoRoute get goRoute => GoRoute(
        path: path,
        pageBuilder: (context, state) {
          return _buildPageWithNoTransition(
            context: context,
            state: state,
            child: buildPage(context, state),
          );
        },
        name: name,
      );

  /// Navigate to this route
  void go(BuildContext context) {
    GoRouter.of(context).goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  /// Push this route to the stack
  Future<T?> push<T>(BuildContext context) async {
    return await GoRouter.of(context).pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  /// Replace the current route with this one
  void replace(BuildContext context) {
    GoRouter.of(context).replaceNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  /// Go back from current route
  void goBack<T extends Object?>(BuildContext context, [T? result]) {
    GoRouter.of(context).pop(result);
  }

  /// Type-safe way to get path parameters
  Map<String, String> get pathParameters {
    // This will be overridden by routes that have path parameters
    return const {};
  }

  /// Type-safe way to get query parameters
  Map<String, String> get queryParameters {
    // This will be overridden by routes that have query parameters
    return const {};
  }

  /// Combined parameters getter
  Map<String, String> get allParameters => {
        ...pathParameters,
        ...queryParameters,
      };

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
}
