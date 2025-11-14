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

  static const String selectedCategoryIconKeyParam = 'selectedCategoryIconKey';

  @override
  Routes get route => Routes.selectCategory;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (selectedCategoryIconKey != null) {
      params[selectedCategoryIconKeyParam] = selectedCategoryIconKey!;
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final selectedCategoryIconKeyFromUri =
        state.uri.queryParameters[selectedCategoryIconKeyParam];

    return SelectCategoryPage(
      selectedCategoryIconKey: selectedCategoryIconKeyFromUri,
    );
  }
}
