import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/presentation/widgets/color_picker.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateAccountPage extends ConsumerWidget {
  const CreateAccountPage({super.key});

  // Get color based on account type
  Color _getAccountTypeColor(BuildContext context, AccountType type) {
    debugPrint(type.toString());
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case AccountType.cash:
        return Colors.orange; // Orange for cash
      case AccountType.bank:
        return Colors.blue; // Blue for bank
      case AccountType.eWallet:
        return Colors.green; // Green for e-wallet
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountCreateForm = ref.watch(accountCreateFormProvider);

    final colorControl = accountCreateForm.colorControl;

    final type = accountCreateForm.typeControl.value;

    if (colorControl.value == null) {
      colorControl.value = PocketColor.randomColor;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.invalidate(accountCreateFormProvider);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Account'),
          actions: [
            if (type != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getAccountTypeColor(context, type)
                        .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      type.icon,
                      color: _getAccountTypeColor(context, type),
                    ),
                    onPressed: () async {
                      final result =
                          await context.push<AccountType?>('/accounts/types');
                      if (result != null && context.mounted) {
                        final typeControl = accountCreateForm.typeControl;
                        typeControl.value = result;
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ReactiveForm(
            formGroup: accountCreateForm,
            child: ReactiveFormConsumer(
              builder: (context, formGroup, child) {
                final form = formGroup as AccountCreateForm;
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          color: form.color?.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            form.type?.icon ?? Icons.question_mark,
                            color: form.color,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardInput(
                      label: 'Name',
                      child: ReactiveTextField<String>(
                        formControl: form.nameControl,
                        decoration: const InputDecoration(
                          hintText: 'Enter account name',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardInput(
                      label: 'Color',
                      child: ColorPicker(form: form),
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(
                      text: 'Create Account',
                      onPressed: () {
                        // TODO: Implement form submission
                        // For now, just pop back with the form data
                        Navigator.of(context).pop(accountCreateForm);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}