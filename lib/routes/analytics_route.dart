import 'package:dompet/features/analytic/presentation/analytic_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the analytics route
class AnalyticsRoute extends AppRoute {
  @override
  Routes get route => Routes.analytics;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) => AnalyticPage();
}
