import 'package:dompet/features/account/presentation/pages/create_account_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the create account route
class CreateAccountRoute extends AppRoute {
  @override
  Routes get route => Routes.createAccount;
  
  @override
  Widget buildPage(BuildContext context, GoRouterState state) => CreateAccountPage();
}