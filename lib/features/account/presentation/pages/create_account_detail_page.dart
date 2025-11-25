import 'package:dompet/core/constants/error_key.dart';
import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/core/widgets/account_pocket_selector.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateAccountDetailPage extends ConsumerWidget {
  const CreateAccountDetailPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountForm = ref.read(createAccountFormProvider);
    final accountDetailForm = ref.read(createAccountDetailFormProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Create Account Detail'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ReactiveForm(
              formGroup: accountDetailForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardInput(
                    label: 'Account',
                    child: AccountPocketSelector(
                      label: 'Account',
                      placeholder: '',
                      color: accountForm.color.value,
                      icon: accountForm.type.value?.icon,
                      name: accountForm.name.value,
                      isDisabled: true,
                      onTap: () {},
                    ),
                  ),
                  CardInput(
                    label: 'Provider',
                    child: ReactiveTextField<String?>(
                      formControl: accountDetailForm.provider,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Enter provider',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ReactiveFormConsumer(builder: (context, formGroup, _) {
                    final form = formGroup as CreateAccountDetailForm;
                    final maskedNumber = form.maskedAccountNumber;
                    return CardInput(
                      label: 'Number',
                      info: maskedNumber != null
                          ? 'Your number will be saved and presented as $maskedNumber for security.'
                          : 'Your number will be masked for security.',
                      child: ReactiveTextField<String?>(
                        formControl: form.accountNumber,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: 'Enter account number or phone number',
                          border: OutlineInputBorder(),
                        ),
                        validationMessages: {
                          ErrorKey.minLength.name: (error) =>
                              ErrorKey.minLength.message(minLength: 8),
                          ErrorKey.maxLength.name: (error) =>
                              ErrorKey.maxLength.message(maxLength: 32),
                        },
                      ),
                    );
                  }),
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
                  text: 'Create Account with Details',
                  onPressed: () {
                    accountDetailForm.markAllAsTouched();
                    if (accountDetailForm.invalid) return;
                    Navigator.of(context)
                        .pop<CreationType>(CreationType.detail);
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
          )),
    );
  }
}
