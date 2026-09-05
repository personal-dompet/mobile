import 'dart:async';

import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/models/app_configuration.dart';
import 'package:dompet_app/core/router/router.dart';
import 'package:dompet_app/core/theme/app_theme.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:dompet_app/features/backup/services/backup_auth_service.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    await initDependency();
    // Pre-initialize Google Sign-In (no UI). Safe to ignore errors.
    try {
      await getIt<BackupAuthService>().ensureInitialized();
    } catch (error) {
      debugPrint('[MAIN] $error');
    }
    await initializeDateFormatting('id');
    runApp(MyApp());
  }, (error, stackTrace) => debugPrint('Error: $error, Trace: $stackTrace'));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ActivitySignalCubit>()),
        BlocProvider(create: (context) => getIt<AccountSignalCubit>()),
        BlocProvider(create: (context) => getIt<AppConfigurationCubit>()),
        BlocProvider(create: (context) => getIt<BudgetSignalCubit>()),
        BlocProvider(create: (context) => getIt<SavingSignalCubit>()),
      ],
      child: BlocBuilder<AppConfigurationCubit, AppConfiguration?>(
        builder: (context, appConfig) {
          final themeMode = switch (appConfig?.themeMode) {
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
            AppThemeMode.system || null => ThemeMode.system,
          };
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            scrollBehavior: MaterialScrollBehavior(),
            routerConfig: _appRouter.config(
              navigatorObservers: () => [NavigationHistoryObserver()],
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            supportedLocales: const [Locale('id', ''), Locale('en', '')],
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            builder: (context, child) {
              return RouterHistoryWrapper(
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: SafeArea(
                    top: false,
                    maintainBottomViewPadding: true,
                    child: child ?? const SizedBox.expand(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
