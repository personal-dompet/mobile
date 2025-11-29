import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/entity_type_selector_bottom_sheet.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/features/account/presentation/widgets/color_picker.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateAccountPage extends ConsumerWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountCreateForm = ref.watch(createAccountFormProvider);

    final colorControl = accountCreateForm.color;

    final type = accountCreateForm.type.value;

    if (colorControl.value == null) {
      colorControl.value = PocketColor.randomColor;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // ref.invalidate(createAccountFormProvider);
      },
      child: ReactiveForm(
        formGroup: accountCreateForm,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Account'),
            actions: [
              if (type != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReactiveFormConsumer(
                      builder: (context, formGroup, child) {
                    final form = formGroup as CreateAccountForm;
                    return Container(
                      decoration: BoxDecoration(
                        color: (form.typeValue?.color ?? Colors.grey)
                            .withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          form.typeValue?.icon ?? Icons.question_mark,
                          color: form.typeValue?.color ?? Colors.grey,
                        ),
                        onPressed: () async {
                          final result =
                              await showModalBottomSheet<AccountType>(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            builder: (context) =>
                                EntityTypeSelectorBottomSheet<AccountType>(
                              types: [
                                AccountType.cash,
                                AccountType.bank,
                                AccountType.eWallet,
                              ],
                              onSelect: (type) {
                                Navigator.of(context).pop<AccountType>(type);
                              },
                            ),
                          );
                          if (result != null && context.mounted) {
                            final typeControl = form.type;
                            typeControl.value = result;
                          }
                        },
                      ),
                    );
                  }),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ReactiveFormConsumer(
              builder: (context, formGroup, child) {
                final form = formGroup as CreateAccountForm;
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          color: form.colorValue?.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            form.typeValue?.icon ?? Icons.question_mark,
                            color: form.colorValue,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    CardInput(
                      label: 'Name',
                      child: ReactiveTextField<String>(
                        formControl: form.name,
                        decoration: const InputDecoration(
                          hintText: 'Enter account name',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        validationMessages: {
                          'required': (error) => 'Name is required',
                        },
                      ),
                    ),
                    CardInput(
                      label: 'Color',
                      child: ColorPicker(form: form),
                    ),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16).copyWith(bottom: 24),
            child: ReactiveFormConsumer(
              builder: (context, formGroup, _) {
                final form = formGroup as CreateAccountForm;
                final type = form.typeValue;

                return SubmitButton(
                  text: 'Next',
                  onPressed: () async {
                    form.markAllAsTouched();
                    if (form.invalid) return;
                    CreationType? creationType;

                    if (type == AccountType.cash) {
                      creationType = CreationType.basic;
                    } else {
                      creationType = await CreateAccountDetailRoute()
                          .push<CreationType?>(context);
                    }

                    if (creationType == null || !context.mounted) return;

                    Navigator.of(context).pop<CreationType?>(creationType);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
