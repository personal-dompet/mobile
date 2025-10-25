import 'package:dompet/features/transaction/presentation/pages/create_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the top-up route
class CreateTransactionRoute extends AppRoute {
  @override
  Routes get route => Routes.createTransaction;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) =>
      CreateTransactionPage();
}
