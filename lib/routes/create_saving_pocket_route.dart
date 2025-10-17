import 'package:dompet/features/pocket/presentation/pages/create_saving_pocket_page.dart';
import 'package:dompet/routes/base_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateSavingPocketRoute extends AppRoute {
  @override
  Routes get route => Routes.createSavingPocket;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    return CreateSavingPocketPage();
  }
}
