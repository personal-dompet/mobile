import 'package:dompet/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the dompet route
class SplashRoute extends AppRoute {
  @override
  Routes get route => Routes.splash;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) => SplashPage();
}
