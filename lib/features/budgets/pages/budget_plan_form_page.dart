import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class BudgetPlanFormPage extends StatelessWidget {
  final Account category;
  const BudgetPlanFormPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final form = FormGroup({'month': FormControl<DateTime>()});
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Rencana Anggaran')),
      body: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: DompetMonthField(
              formControl: form.control('month') as FormControl<DateTime>,
              labelText: 'Bulan',
              hintText: 'Pilih bulan',
              validationMessages: {
                ValidationMessage.required: (_) => 'Pilih bulan dahulu',
              },
            ),
          ),
        ),
      ),
    );
  }
}
