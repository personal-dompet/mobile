import 'package:dompet/features/transaction/presentation/pages/select_category_page.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Type-safe route configuration for the select category route
class SelectCategoryRoute extends AppRoute {
  final String? selectedCategoryIconKey;

  SelectCategoryRoute({
    this.selectedCategoryIconKey,
  });

  @override
  Routes get route => Routes.selectCategory;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (selectedCategoryIconKey != null) {
      params['selectedCategoryIconKey'] = selectedCategoryIconKey!;
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final selectedCategoryIconKeyParam =
        state.uri.queryParameters['selectedCategoryIconKey'];

    return SelectCategoryPage(
      selectedCategoryIconKey: selectedCategoryIconKeyParam,
    );
  }
}
