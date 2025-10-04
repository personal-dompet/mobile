import 'package:dompet/features/account/presentation/pages/account_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the account route
class AccountRoute extends AppRoute {
  @override
  Routes get route => Routes.accounts;
  
  @override
  Widget buildPage(BuildContext context, GoRouterState state) => AccountPage();
}