import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the create account transfer route with parameters
class CreateAccountTransferRoute extends AppRoute {
  final TransferStaticSubject? subject;

  CreateAccountTransferRoute({
    this.subject,
  });

  static const String staticParamKey = 'static';

  @override
  Routes get route => Routes.createAccountTransfer;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (subject != null) {
      params[staticParamKey] = subject!.name;
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    // TODO: Implement CreateAccountTransferPage once the page is created
    // This route is defined but the actual page implementation may not exist yet
    throw UnimplementedError('CreateAccountTransferPage not yet implemented');
  }
}