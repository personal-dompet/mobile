import 'package:dompet/features/account/presentation/pages/select_account_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the select account route with parameters
class SelectAccountRoute extends AppRoute {
  final int? selectedAccountId;
  
  SelectAccountRoute({
    this.selectedAccountId,
  });
  
  @override
  Routes get route => Routes.selectAccount;
  
  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};
    
    if (selectedAccountId != null) {
      params['selectedAccountId'] = selectedAccountId.toString();
    }
    
    return params;
  }
  
  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final selectedAccountId = int.tryParse(
      state.uri.queryParameters['selectedAccountId'] ?? ''
    );
    
    return SelectAccountPage(selectedAccountId: selectedAccountId);
  }
}