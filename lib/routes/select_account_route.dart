import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/features/account/presentation/pages/select_account_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'base_routes.dart';

/// Type-safe route configuration for the select account route with parameters
class SelectAccountRoute extends AppRoute {
  final int? selectedAccountId;
  final SelectAccountTitle? title;
  final CreateFrom? createFrom;
  final bool? disableEmpty;

  SelectAccountRoute({
    this.selectedAccountId,
    this.createFrom,
    this.title,
    this.disableEmpty,
  });

  static const String selectedAccountIdParamKey = 'selectedAccountId';
  static const String createFromParamKey = 'createFrom';
  static const String titleParamKey = 'title';
  static const String disableEmptyParamKey = 'disableEmpty';

  @override
  Routes get route => Routes.selectAccount;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (selectedAccountId != null) {
      params[selectedAccountIdParamKey] = selectedAccountId.toString();
    }

    if (title != null) {
      params[titleParamKey] = title!.value;
    }

    if (createFrom != null) {
      params[createFromParamKey] = createFrom!.name;
    }

    if (disableEmpty != null) {
      params[disableEmptyParamKey] = disableEmpty!.toString();
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final selectedAccountId = int.tryParse(
        state.uri.queryParameters[selectedAccountIdParamKey] ?? '');
    final createFrom = CreateFrom.fromName(
        state.uri.queryParameters[createFromParamKey] ?? '');

    final titleParam = SelectAccountTitle.fromValue(
        state.uri.queryParameters[titleParamKey] ??
            SelectAccountTitle.general.value);

    final disableEmpty =
        state.uri.queryParameters[disableEmptyParamKey] == 'true';

    return SelectAccountPage(
      selectedAccountId: selectedAccountId,
      createFrom: createFrom,
      disableEmpty: disableEmpty,
      title: titleParam ?? SelectAccountTitle.general,
    );
  }
}
