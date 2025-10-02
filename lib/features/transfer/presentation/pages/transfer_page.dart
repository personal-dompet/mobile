import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/pocket/presentation/widgets/select_pocket_card.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransferPage extends ConsumerWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = PocketTransferForm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Funds'),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SelectPocketCard(
                formControlName: 'fromPocket',
                label: 'From Pocket',
                placeholder: 'Select source pocket',
              ),
              SelectPocketCard(
                formControlName: 'toPocket',
                label: 'To Pocket',
                placeholder: 'Select destination pocket',
              ),
              ReactiveTextField(
                formControlName: 'amount',
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validationMessages: {
                  ValidationMessage.required: (error) => 'Amount is required',
                  ValidationMessage.min: (error) =>
                      'Amount must be greater than 0',
                },
              ),
              ReactiveTextField(
                formControlName: 'description',
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  return SubmitButton(
                    text: 'Transfer Funds',
                    onPressed: () {
                      if (formGroup.valid) {
                        // Process the transfer
                        // Add your transfer logic here
                      } else {
                        formGroup.markAllAsTouched();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
