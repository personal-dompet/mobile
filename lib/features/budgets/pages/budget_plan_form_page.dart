import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/utils/format_currency.dart';
import 'package:dompet_app/core/widgets/calculator.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BudgetPlanFormPage extends StatelessWidget {
  final Account category;
  const BudgetPlanFormPage({super.key, required this.category});

  void _showApplied(BuildContext context, int value) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Nilai diterapkan: ${FormatCurrency.formatRupiah(value)}',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Calculator'),
        actions: [
          CalculatorTriggerButton(
            onValueApplied: (value) => _showApplied(context, value),
          ),
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Preview widget kalkulator. Tekan ikon kalkulator di kanan atas untuk membuka bottom sheet.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
