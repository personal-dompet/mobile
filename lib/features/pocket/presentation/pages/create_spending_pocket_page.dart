import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/core/widgets/account_pocket_selector.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateSpendingPocketPage extends ConsumerWidget {
  const CreateSpendingPocketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketForm = ref.read(createPocketFormProvider);
    final spendingPocketForm = ref.read(createSpendingPocketFormProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Spending Pocket Detail'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ReactiveForm(
            formGroup: spendingPocketForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardInput(
                  label: 'Pocket',
                  child: AccountPocketSelector(
                    label: 'Pocket',
                    placeholder: '',
                    color: pocketForm.color.value,
                    icon: pocketForm.icon.value?.icon,
                    name: pocketForm.name.value,
                    isDisabled: true,
                    onTap: () {},
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final currentValue =
                        spendingPocketForm.lowBalanceReminder.value;
                    spendingPocketForm.lowBalanceReminder.updateValue(
                        currentValue == null ? true : !currentValue);
                    spendingPocketForm.lowBalanceReminder.markAsTouched();
                  },
                  child: CardInput(
                    child: Row(
                      spacing: 8,
                      children: [
                        ReactiveSwitch(
                          formControl: spendingPocketForm.lowBalanceReminder,
                        ),
                        Expanded(
                          child: Text(
                            'Set low balance reminder',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CardInput(
                  label: 'Low Balance Threshold',
                  info:
                      'Get notified when your pocket balance drops to this amount or lower. Just make sure the "Low Balance Reminder" is turned on above.',
                  child: MaskedAmountInput(
                    formControl: spendingPocketForm.lowBalanceThreshold,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      border: const OutlineInputBorder(),
                      // errorText: errorText,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 16).copyWith(bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              SubmitButton(
                text: 'Create Pocket with Details',
                onPressed: () {
                  Navigator.of(context).pop<CreationType>(CreationType.detail);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.disabledColor,
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  Navigator.of(context).pop<CreationType>(CreationType.basic);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Skip, Create Anyway'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
