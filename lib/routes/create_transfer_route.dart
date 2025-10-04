import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/features/transfer/presentation/pages/create_transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the create transfer route with parameters
class CreateTransferRoute extends AppRoute {
  final TransferStaticSubject? subject;

  CreateTransferRoute({
    this.subject,
  });

  @override
  Routes get route => Routes.createTransfer;

  @override
  Map<String, String> get queryParameters {
    final params = <String, String>{};

    if (subject != null) {
      params['static'] = subject!.name;
    }

    return params;
  }

  @override
  Widget buildPage(BuildContext context, GoRouterState state) {
    final staticQuery = state.uri.queryParameters['static'];
    TransferStaticSubject? subject;

    if (staticQuery != null) {
      subject = TransferStaticSubject.values.firstWhere(
        (element) => element.name == staticQuery,
        orElse: () => TransferStaticSubject.source,
      );
    }

    return CreateTransferPage(subject: subject);
  }
}
