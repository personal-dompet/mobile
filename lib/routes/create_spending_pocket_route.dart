import 'package:dompet/features/pocket/presentation/pages/create_spending_pocket_page.dart';
import 'package:dompet/routes/base_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateSpendingPocketRoute extends AppRoute {
  @override
  Routes get route => Routes.createSpendingPocket;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    return CreateSpendingPocketPage();
  }
}
