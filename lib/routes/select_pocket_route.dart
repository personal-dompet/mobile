import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the select pocket route with parameters
class SelectPocketRoute extends AppRoute {
  final int? selectedPocketId;
  final SelectPocketTitle? title;
  final bool? disableEmpty;

  SelectPocketRoute({
    this.selectedPocketId,
    this.title,
    this.disableEmpty,
  });

  static const String selectedPocketIdParamKey = 'selectedPocketId';
  static const String titleParamKey = 'title';
  static const String disableEmptyParamKey = 'disableEmpty';

  @override
  Routes get route => Routes.selectPocket;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (selectedPocketId != null) {
      params[selectedPocketIdParamKey] = selectedPocketId.toString();
    }

    if (title != null) {
      params[titleParamKey] = title!.value;
    }

    if (disableEmpty != null) {
      params[disableEmptyParamKey] = disableEmpty!.toString();
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final selectedPocketId =
        int.tryParse(state.uri.queryParameters[selectedPocketIdParamKey] ?? '');
    final titleParam = SelectPocketTitle.fromValue(
        state.uri.queryParameters[titleParamKey] ?? SelectPocketTitle.general.value);
    final disableEmpty = state.uri.queryParameters[disableEmptyParamKey] == 'true';

    return SelectPocketPage(
      selectedPocketId: selectedPocketId,
      title: titleParam ?? SelectPocketTitle.general,
      disableEmpty: disableEmpty,
    );
  }
}
