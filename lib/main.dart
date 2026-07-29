import 'dart:async';

import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
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
      ],
      child: MaterialApp.router(
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
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
            tertiary: Colors.green.shade300,
            tertiaryContainer: Colors.green.shade600,
            onTertiary: Colors.green.shade900,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
          ),
          cardTheme: const CardThemeData(
            margin: EdgeInsets.all(0),
            elevation: 0,
          ),
          appBarTheme: const AppBarTheme(
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          tooltipTheme: TooltipThemeData(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            textStyle: TextStyle(
              color: Colors.white,
            ), // Optional: Change text color too
          ),
          splashColor: Colors.white.withValues(alpha: 0.05),
          highlightColor: Colors.white.withValues(alpha: 0.03),
        ),
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
      ),
    );
  }
}
