import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:dompet_app/features/splash/cubits/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) {
        context.read<AppConfigurationCubit>().init();
        return getIt<SplashCubit>()..check();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: Scaffold(
          body: SafeArea(
            child: BlocConsumer<SplashCubit, SplashState>(
            listener: (providedContext, state) {
              state.maybeWhen(
                orElse: () {},
                alreadySet: () {
                  providedContext.router.replaceAll([ShellRoute()]);
                },
                needToBeSet: () {
                  providedContext.router.replaceAll([InitialSetupRoute()]);
                },
              );
            },
            builder: (providedContext, state) {
              return state.maybeWhen(
                orElse: () => SizedBox.shrink(),
                loading: () => SizedBox(
                  width: double.infinity,
                  child: Center(child: SpinnerLoading()),
                ),
                error: (message) {
                  final themeData = Theme.of(context);
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        message,
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          color: themeData.colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        ),
      ),
    );
  }
}
