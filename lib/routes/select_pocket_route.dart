import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the select pocket route with parameters
class SelectPocketRoute extends AppRoute {
  final int? selectedPocketId;
  final SelectPocketTitle? title;

  SelectPocketRoute({
    this.selectedPocketId,
    this.title,
  });

  @override
  Routes get route => Routes.selectPocket;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (selectedPocketId != null) {
      params['selectedAccountId'] = selectedPocketId.toString();
    }

    if (title != null) {
      params['title'] = title!.value;
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final selectedAccountId =
        int.tryParse(state.uri.queryParameters['selectedAccountId'] ?? '');
    final titleParam = SelectPocketTitle.fromValue(
        state.uri.queryParameters['title'] ?? SelectPocketTitle.general.value);

    return SelectPocketPage(
      selectedPocketId: selectedAccountId,
      title: titleParam ?? SelectPocketTitle.general,
    );
  }
}
