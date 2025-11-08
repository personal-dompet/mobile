import 'package:dompet/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the account route
class AuthRoute extends AppRoute {
  @override
  Routes get route => Routes.auth;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) => AuthPage();
}
