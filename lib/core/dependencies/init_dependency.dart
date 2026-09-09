import 'package:dompet_app/core/cubits/pagination_cubit.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/network/connectivity_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/activities/cubits/activity_detail_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:dompet_app/features/app_configurations/repositories/app_configuration_repository.dart';
import 'package:dompet_app/features/assets/cubits/asset_cubit.dart';
import 'package:dompet_app/features/assets/cubits/asset_detail_cubit.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/features/budgets/cubits/budget_action_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_detail_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_plan_detail_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_plan_list_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/savings/cubits/saving_action_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_detail_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:dompet_app/features/dashboard/cubits/dashboard_cubit.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/reports/cubits/report_cubit.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/setup/cubits/asset_setup_cubit.dart';
import 'package:dompet_app/features/splash/cubits/splash_cubit.dart';
import 'package:dompet_app/features/transactions/cubits/balance_adjustment_cubit.dart';
import 'package:dompet_app/features/transactions/cubits/transaction_cubit.dart';
import 'package:dompet_app/features/transactions/cubits/transfer_cubit.dart';
import 'package:dompet_app/features/backup/cubits/backup_cubit.dart';
import 'package:dompet_app/features/backup/repositories/backup_repository.dart';
import 'package:dompet_app/features/backup/services/backup_auth_service.dart';
import 'package:dompet_app/features/backup/services/drive_backup_service.dart';
import 'package:dompet_app/features/transactions/repositories/balance_adjustment_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transfer_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initDependency({String? dbTestPath}) async {
  getIt.registerLazySingleton<DbService>(() => DbService(testPath: dbTestPath));

  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepository(getIt()),
  );
  getIt.registerLazySingleton<AssetRepository>(() => AssetRepository(getIt()));
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository(getIt()),
  );

  getIt.registerLazySingleton<BudgetRepository>(
    () => BudgetRepository(getIt()),
  );

  getIt.registerLazySingleton<BudgetPlanRepository>(
    () => BudgetPlanRepository(getIt()),
  );

  getIt.registerLazySingleton<SavingRepository>(
    () => SavingRepository(getIt()),
  );

  getIt.registerLazySingleton<AppConfigurationRepository>(
    () => AppConfigurationRepository(getIt()),
  );

  getIt.registerLazySingleton<JournalRepository>(
    () => JournalRepository(getIt()),
  );

  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(getIt()),
  );
  getIt.registerLazySingleton<TransferRepository>(
    () => TransferRepository(getIt()),
  );
  getIt.registerLazySingleton<BalanceAdjustmentRepository>(
    () => BalanceAdjustmentRepository(getIt()),
  );

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(getIt()),
  );

  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepository(getIt()),
  );

  // Connectivity awareness (offline-first app, backup/restore needs internet)
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerFactory<ConnectivityCubit>(
    () => ConnectivityCubit(connectivity: getIt()),
  );

  // Backup & Restore (Google Drive appDataFolder)
  getIt.registerLazySingleton<BackupAuthService>(() => BackupAuthService());
  getIt.registerLazySingleton<DriveBackupService>(
    () => DriveBackupService(getIt()),
  );
  getIt.registerLazySingleton<BackupRepository>(
    () => BackupRepository(getIt(), getIt()),
  );

  getIt.registerFactory<PaginationCubit<JournalEntry, JournalFilter>>(
    () => PaginationCubit(fetcher: getIt<JournalRepository>().getJournals),
  );

  getIt.registerFactory<SplashCubit>(() => SplashCubit(getIt()));
  getIt.registerFactory<AssetSetupCubit>(
    () => AssetSetupCubit(getIt(), getIt()),
  );
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory<ReportCubit>(() => ReportCubit(getIt(), getIt()));
  getIt.registerFactory<CategoryCubit>(() => CategoryCubit(getIt()));
  getIt.registerFactory<AssetDetailCubit>(
    () => AssetDetailCubit(getIt(), getIt()),
  );
  getIt.registerLazySingleton<AccountSignalCubit>(() => AccountSignalCubit());
  getIt.registerFactory<AccountActionCubit>(
    () => AccountActionCubit(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory<AssetCubit>(() => AssetCubit(getIt()));

  getIt.registerFactory<BudgetCubit>(() => BudgetCubit(getIt()));

  getIt.registerLazySingleton<BudgetSignalCubit>(() => BudgetSignalCubit());

  getIt.registerFactory<BudgetActionCubit>(() => BudgetActionCubit(getIt()));

  getIt.registerFactory<BudgetPlanDetailCubit>(
    () => BudgetPlanDetailCubit(getIt(), getIt()),
  );

  getIt.registerFactory<BudgetPlanListCubit>(() => BudgetPlanListCubit(getIt()));

  getIt.registerFactory<BudgetDetailCubit>(
    () => BudgetDetailCubit(getIt(), getIt(), getIt()),
  );

  getIt.registerFactory<SavingCubit>(() => SavingCubit(getIt()));

  getIt.registerLazySingleton<SavingSignalCubit>(() => SavingSignalCubit());

  getIt.registerFactory<SavingActionCubit>(() => SavingActionCubit(getIt()));

  getIt.registerFactory<SavingDetailCubit>(() => SavingDetailCubit(getIt()));

  getIt.registerLazySingleton<AppConfigurationCubit>(
    () => AppConfigurationCubit(getIt()),
  );
  getIt.registerFactory<TransactionCubit>(() => TransactionCubit(getIt()));
  getIt.registerFactory<TransferCubit>(() => TransferCubit(getIt()));
  getIt.registerFactory<BalanceAdjustmentCubit>(
    () => BalanceAdjustmentCubit(getIt()),
  );
  getIt.registerLazySingleton<ActivitySignalCubit>(() => ActivitySignalCubit());
  getIt.registerFactory<ActivityDetailCubit>(
    () => ActivityDetailCubit(getIt()),
  );

  getIt.registerFactory<BackupCubit>(
    () => BackupCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
  );
}
