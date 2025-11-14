import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/features/account/presentation/pages/select_account_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'base_routes.dart';

/// Type-safe route configuration for the select account route with parameters
class SelectAccountRoute extends AppRoute {
  final int? selectedAccountId;
  final CreateFrom? createFrom;
  final bool? disableEmpty;

  SelectAccountRoute({
    this.selectedAccountId,
    this.createFrom,
    this.disableEmpty,
  });

  @override
  Routes get route => Routes.selectAccount;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (selectedAccountId != null) {
      params['selectedAccountId'] = selectedAccountId.toString();
    }

    if (createFrom != null) {
      params['createFrom'] = createFrom!.name;
    }

    if (disableEmpty != null) {
      params['disableEmpty'] = disableEmpty!.toString();
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final selectedAccountId =
        int.tryParse(state.uri.queryParameters['selectedAccountId'] ?? '');
    final createFrom =
        CreateFrom.fromName(state.uri.queryParameters['createFrom'] ?? '');

    final disableEmpty = state.uri.queryParameters['disableEmpty'] == 'true';

    return SelectAccountPage(
      selectedAccountId: selectedAccountId,
      createFrom: createFrom,
      disableEmpty: disableEmpty,
    );
  }
}
