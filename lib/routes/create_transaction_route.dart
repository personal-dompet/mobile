import 'package:dompet/core/enum/transaction_static_subject.dart';
import 'package:dompet/features/transaction/presentation/pages/create_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_routes.dart';

/// Type-safe route configuration for the top-up route
class CreateTransactionRoute extends AppRoute {
  final TransactionStaticSubject? subject;

  CreateTransactionRoute({
    this.subject,
  });

  @override
  Routes get route => Routes.createTransaction;

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
    TransactionStaticSubject? subject;

    if (staticQuery != null) {
      subject = TransactionStaticSubject.values.firstWhere(
        (element) => element.name == staticQuery,
        orElse: () => TransactionStaticSubject.account,
      );
    }

    return CreateTransactionPage(
      subject: subject,
    );
  }
}
