import 'package:dompet/features/transaction/presentation/pages/top_up_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the top-up route
class TopUpRoute extends AppRoute {
  @override
  Routes get route => Routes.topUp;
  
  @override
  Widget buildPage(BuildContext context, GoRouterState state) => TopUpPage();
}