import 'package:auto_route/auto_route.dart';
import 'package:dompet/core/constants/error_key.dart';
import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/core/widgets/account_pocket_selector.dart';
import 'package:dompet/core/widgets/animatied_opacity_container.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/pages/select_account_page.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:dompet/features/transfer/presentation/widgets/swap_button.dart';
import 'package:dompet/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class CreateAccountTransferPage extends ConsumerStatefulWidget {
  final TransferStaticSubject? subject;
  const CreateAccountTransferPage({super.key, this.subject});

  @override
  ConsumerState<CreateAccountTransferPage> createState() =>
      _CreateTransferPageState();
}

class _CreateTransferPageState
    extends ConsumerState<CreateAccountTransferPage> {
  late FocusNode _descriptionFocusNode;
  bool _hasValidated = false;

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    final form = ref.read(accountTransferFormProvider);
    if (!form.valid) {
      form.markAllAsTouched();
      setState(() {
        _hasValidated = true;
      });
      return;
    }
    final payload = form;
    Navigator.of(context).pop<AccountTransferForm>(payload);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(accountTransferFormProvider);

    return ReactiveForm(
      formGroup: form,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transfer Funds'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Transfer Funds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd MMMM yyyy').format(DateTime.now()),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              CardInput(
                label: 'Source',
                child: ReactiveFormConsumer(
                  builder: (context, consumerForm, _) {
                    final form = consumerForm as AccountTransferForm;
                    final fromAccount = form.fromAccountValue;
                    final amount = form.amountValue;

                    final newBalance = (fromAccount.balance) - amount;
                    final formattedNewBalance =
                        FormatCurrency.formatRupiah(newBalance);

                    return AccountPocketSelector(
                      label: 'From Account',
                      placeholder: 'Select source account',
                      color: fromAccount.color,
                      icon: fromAccount.type.icon,
                      name: fromAccount.name,
                      balance: fromAccount.formattedBalance,
                      formattedNewBalance: newBalance == fromAccount.balance
                          ? null
                          : formattedNewBalance,
                      showBalanceChange: newBalance != fromAccount.balance,
                      isDisabled:
                          widget.subject == TransferStaticSubject.source,
                      onTap: () async {
                        final selectedAccount = await context.router
                            .push<AccountModel>(SelectAccountRoute(
                          selectedAccountId: form.fromAccount.value?.id,
                          title: SelectAccountTitle.source,
                        ));
                        if (selectedAccount != null && mounted) {
                          form.fromAccount.value = selectedAccount;
                        }
                      },
                    );
                  },
                ),
              ),

              SwapButton(
                onTap: () {
                  if (widget.subject != null) {
                    context
                        .showErrorSnackbar('Locked account cannot be swapped.');
                    return;
                  }

                  final fromAccount = form.fromAccount.value;
                  final toAccount = form.toAccount.value;

                  if (fromAccount != null && toAccount != null) {
                    if (toAccount.balance <= 0) {
                      context.showErrorSnackbar(
                          'Source account after swap must have at least Rp1 balance.');
                      return;
                    }

                    form.fromAccount.value = toAccount;
                    form.toAccount.value = fromAccount;
                  }
                },
              ),

              CardInput(
                label: 'Destination',
                child: ReactiveFormConsumer(
                  builder: (context, consumerForm, _) {
                    final form = consumerForm as AccountTransferForm;
                    final toAccount = form.toAccountValue;
                    final amount = form.amountValue;

                    final newBalance = (toAccount.balance) + amount;
                    final formattedNewBalance =
                        FormatCurrency.formatRupiah(newBalance);

                    return ReactiveFormConsumer(
                      builder: (context, formGroup, _) {
                        final transferForm = formGroup as AccountTransferForm;
                        return AnimatedOpacityContainer(
                          isAnimated: (!transferForm.toAccount.hasErrors ||
                                  transferForm.toAccount.value != null) &&
                              transferForm.toAccount.value!.id < 0,
                          child: AccountPocketSelector(
                            formControl: transferForm.toAccount,
                            label: 'To Account',
                            placeholder: 'Select destination account',
                            color: transferForm.toAccount.value?.color,
                            icon: transferForm.toAccountValue.type.icon,
                            name: transferForm.toAccount.value?.name,
                            balance:
                                transferForm.toAccount.value?.formattedBalance,
                            isDisabled: widget.subject ==
                                TransferStaticSubject.destination,
                            formattedNewBalance: newBalance ==
                                    transferForm.toAccount.value?.balance
                                ? null
                                : formattedNewBalance,
                            showBalanceChange: newBalance !=
                                transferForm.toAccount.value?.balance,
                            onTap: () async {
                              final selectedAccount = await context.router
                                  .push<AccountModel>(SelectAccountRoute(
                                selectedAccountId: form.toAccount.value?.id,
                                title: SelectAccountTitle.destination,
                              ));
                              if (selectedAccount != null && mounted) {
                                form.toAccount.value = selectedAccount;
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Amount input
              CardInput(
                label: 'Amount',
                child: ReactiveFormConsumer(
                  builder: (context, form, child) {
                    final formGroup = form as AccountTransferForm;
                    final amountControl = formGroup.amount;
                    final fromAccountControl = formGroup.fromAccount;

                    String? errorText;
                    if (_hasValidated &&
                        amountControl.invalid &&
                        amountControl.hasError(ErrorKey.exceedsBalance.name)) {
                      final fromAccount = fromAccountControl.value;
                      if (fromAccount != null) {
                        errorText =
                            'Amount exceeds account balance of ${FormatCurrency.formatRupiah(fromAccount.balance)}';
                      }
                    } else if (_hasValidated &&
                        amountControl.invalid &&
                        amountControl.hasError(ErrorKey.min.name)) {
                      errorText = ErrorKey.min.message(min: 1);
                    }

                    return MaskedAmountInput(
                      formControl: form.amount,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                      ),
                      validationMessages: {
                        ErrorKey.required.name: (error) =>
                            ErrorKey.required.message(),
                        ErrorKey.min.name: (error) =>
                            ErrorKey.min.message(min: 1),
                        ErrorKey.exceedsBalance.name: (error) =>
                            ErrorKey.exceedsBalance.message(),
                      },
                    );
                  },
                ),
              ),

              // Description input
              CardInput(
                label: 'Description',
                child: ReactiveTextField<String?>(
                  formControlName: 'description',
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ReactiveFormConsumer(
          builder: (context, formGroup, _) {
            final accountTransferForm = formGroup as AccountTransferForm;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16).copyWith(bottom: 24),
              child: SubmitButton(
                text: 'Transfer Funds',
                onPressed: accountTransferForm.toAccount.value == null ||
                        accountTransferForm.toAccount.value!.id < 0
                    ? null
                    : () => _submit(context),
              ),
            );
          },
        ),
      ),
    );
  }
}
