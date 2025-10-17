import 'package:dompet/features/pocket/presentation/pages/create_recurring_pocket_page.dart';
import 'package:dompet/routes/base_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRecurringPocketRoute extends AppRoute {
  @override
  Routes get route => Routes.createRecurringPocket;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    return CreateRecurringPocketPage();
  }
}
