import 'package:dompet/features/pocket/presentation/pages/create_pocket_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the create pocket route
class CreatePocketRoute extends AppRoute {
  @override
  Routes get route => Routes.createPocket;
  
  @override
  Widget buildPage(BuildContext context, GoRouterState state) => CreatePocketPage();
}