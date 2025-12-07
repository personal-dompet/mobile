import 'package:auto_route/auto_route.dart';
import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/core/widgets/account_pocket_selector.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_recurring_pocket_form.dart';
import 'package:dompet/features/pocket/presentation/widgets/billing_date_option.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class CreateRecurringPocketPage extends ConsumerWidget {
  const CreateRecurringPocketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketForm = ref.read(createPocketFormProvider);
    final recurringPocketForm = ref.read(createRecurringPocketFormProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Recurring Pocket Detail'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ReactiveForm(
            formGroup: recurringPocketForm,
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
                CardInput(
                  label: 'Product',
                  child: ReactiveTextField<String?>(
                    formControl: recurringPocketForm.productName,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Enter product name',
                      border: OutlineInputBorder(),
                    ),
                    validationMessages: {
                      'required': (error) => 'Product name is required',
                    },
                  ),
                ),
                CardInput(
                  label: 'Product Description',
                  child: ReactiveTextField<String?>(
                    formControl: recurringPocketForm.productDescription,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                CardInput(
                  label: 'Amount',
                  child: MaskedAmountInput(
                    formControl: recurringPocketForm.amount,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      border: const OutlineInputBorder(),
                      // errorText: errorText,
                    ),
                    validationMessages: {
                      'required': (error) => 'Amount is required',
                    },
                  ),
                ),
                CardInput(
                  label: 'Billing Date',
                  info:
                      'Choose when this recurring payment will be charged each months',
                  child: ReactiveFormConsumer(
                    builder: (context, formGroup, _) {
                      final form = formGroup as CreateRecurringPocketForm;
                      return BillingDateOption(
                        selectedDate: form.billingDateValue,
                        onDateSelected: (value) {
                          form.billingDate.value = value;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 16).copyWith(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              SubmitButton(
                text: 'Create Pocket with Details',
                onPressed: () {
                  recurringPocketForm.markAllAsTouched();
                  if (recurringPocketForm.invalid) return;
                  Navigator.of(context).pop<CreationType>(CreationType.detail);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: AppTheme.disabledColor,
                    padding: const EdgeInsets.all(0)),
                onPressed: () {
                  Navigator.of(context).pop<CreationType>(CreationType.basic);
                },
                child: Text('Skip, Create Anyway'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
