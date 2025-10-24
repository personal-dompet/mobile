import 'package:dompet/features/account/presentation/pages/create_account_detail_page.dart';
import 'package:dompet/routes/base_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateAccountDetailRoute extends AppRoute {
  @override
  Routes get route => Routes.createAccountDetail;

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    return CreateAccountDetailPage();
  }
}
