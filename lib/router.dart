import 'package:auto_route/auto_route.dart';
import 'package:dompet/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(path: '/', page: DashboardRoute.page, children: [
          AutoRoute(path: '', page: HomeRoute.page),
          AutoRoute(path: 'pockets', page: PocketRoute.page),
          AutoRoute(path: 'accounts', page: AccountRoute.page),
          AutoRoute(path: 'analytics', page: AnalyticRoute.page),
        ]),
        AutoRoute(page: CreatePocketRoute.page),
        AutoRoute(page: CreateSpendingPocketRoute.page),
        AutoRoute(page: CreateSavingPocketRoute.page),
        AutoRoute(page: CreateRecurringPocketRoute.page),
        AutoRoute(page: SelectPocketRoute.page),
        AutoRoute(page: SelectAccountRoute.page),
        AutoRoute(page: CreateAccountRoute.page),
        AutoRoute(page: CreateAccountDetailRoute.page),
        AutoRoute(page: CreatePocketTransferRoute.page),
        AutoRoute(page: CreateAccountTransferRoute.page),
        AutoRoute(page: CreateTransactionRoute.page),
        AutoRoute(page: SelectCategoryRoute.page),
        AutoRoute(page: PocketDetailRoute.page),
      ];
}
