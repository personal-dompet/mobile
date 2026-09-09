import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: InitialSetupRoute.page),
    AutoRoute(page: WalletSetupRoute.page),
    AutoRoute(
      page: ShellRoute.page,
      children: [
        AutoRoute(page: DashboardRoute.page, initial: true),
        AutoRoute(page: ActivityRoute.page),
        AutoRoute(page: BudgetRoute.page),
        AutoRoute(page: SavingRoute.page),
      ],
    ),
    AutoRoute(page: TransactionRoute.page),
    AutoRoute(page: TransferRoute.page),
    AutoRoute(page: BalanceAdjustmentRoute.page),
    AutoRoute(page: AssetRoute.page),
    AutoRoute(page: AssetDetailRoute.page),
    AutoRoute(page: AssetActivityRoute.page),
    AutoRoute(page: AssetFormRoute.page),
    // FIX-14 (IMP-2/IMP-3): halaman arsip. Push biasa (bukan
    // replaceAll) agar back stack FIX-03 tak jebol.
    AutoRoute(page: AssetArchivedRoute.page),
    AutoRoute(page: CategoryFormRoute.page),
    AutoRoute(page: CategoryRoute.page),
    AutoRoute(page: CategoryArchivedRoute.page),
    AutoRoute(page: BudgetPlanFormRoute.page),
    AutoRoute(page: BudgetPlanRoute.page),
    AutoRoute(page: BudgetPlanListRoute.page),
    AutoRoute(page: BudgetDetailRoute.page),
    AutoRoute(page: SavingDetailRoute.page),
    AutoRoute(page: SavingFormRoute.page),
    AutoRoute(page: SavingAllocationRoute.page),
    AutoRoute(page: SavingSpendRoute.page),
    AutoRoute(page: ActivityDetailRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: ReportRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
