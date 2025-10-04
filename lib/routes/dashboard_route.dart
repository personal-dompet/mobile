import 'package:dompet/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the dompet route
class DashboardRoute extends AppRoute {
  @override
  Routes get route => Routes.dashboard;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) => HomePage();
}
