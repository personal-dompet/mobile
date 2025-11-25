import 'package:dompet/core/constants/error_key.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/transaction_static_subject.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/core/widgets/account_pocket_selector.dart';
import 'package:dompet/core/widgets/animatied_opacity_container.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/reactive_datetime_picker.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/routes/routes.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateTransactionPage extends ConsumerWidget {
  final TransactionStaticSubject? subject;

  const CreateTransactionPage({super.key, this.subject});

  void _submit(BuildContext context) async {
    final form =
        ProviderScope.containerOf(context).read(transactionFormProvider);
    form.markAllAsTouched();
    if (form.valid) {
      final payload = form;
      Navigator.of(context).pop<TransactionForm>(payload);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final form = ref.watch(transactionFormProvider);

    form.date.value = now;
    form.type.value = form.typeValue ?? TransactionType.income;

    return ReactiveForm(
      formGroup: form,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create ${form.typeValue!.label} Transaction'),
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
                    Text(
                      form.typeValue!.label,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: form.typeValue == TransactionType.income
                              ? AppTheme.successColor
                              : AppTheme.errorColor),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd MMMM yyyy').format(now),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              CardInput(
                label: 'Account',
                child: ReactiveFormConsumer(
                  builder: (context, consumerForm, _) {
                    final form = consumerForm as TransactionForm;
                    final account = form.accountValue;
                    final amount = form.amountValue ?? 0;

                    final newBalance = (account?.balance ?? 0) +
                        (amount *
                            (form.typeValue == TransactionType.income
                                ? 1
                                : -1));
                    final formattedNewBalance =
                        FormatCurrency.formatRupiah(newBalance);

                    return ReactiveFormConsumer(
                        builder: (context, formGroup, _) {
                      final transactionForm = formGroup as TransactionForm;
                      return AnimatedOpacityContainer(
                        isAnimated: (!transactionForm.account.hasErrors ||
                                transactionForm.account.value != null) &&
                            transactionForm.account.value!.id < 0,
                        child: AccountPocketSelector(
                          label: 'Account',
                          placeholder: 'Select account',
                          color: account?.color,
                          icon: account?.type.icon,
                          name: account?.name,
                          balance: account?.formattedBalance,
                          formattedNewBalance: newBalance == account?.balance
                              ? null
                              : formattedNewBalance,
                          showBalanceChange: newBalance != account?.balance,
                          isDisabled:
                              subject == TransactionStaticSubject.account,
                          onTap: () async {
                            final selectedAccount = await SelectAccountRoute(
                                    selectedAccountId: form.account.value?.id,
                                    createFrom: CreateFrom.transaction)
                                .push<AccountModel>(context);
                            if (selectedAccount != null && context.mounted) {
                              form.account.value = selectedAccount;
                            }
                          },
                        ),
                      );
                    });
                  },
                ),
              ),

              CardInput(
                label: 'Pocket',
                child: ReactiveFormConsumer(
                  builder: (context, consumerForm, _) {
                    final form = consumerForm as TransactionForm;
                    final pocket = form.pocketValue;
                    final amount = form.amountValue ?? 0;

                    final newBalance = (pocket?.balance ?? 0) +
                        (amount *
                            (form.typeValue == TransactionType.income
                                ? 1
                                : -1));
                    final formattedNewBalance =
                        FormatCurrency.formatRupiah(newBalance);

                    return ReactiveFormConsumer(
                        builder: (context, formGroup, _) {
                      final transactionForm = formGroup as TransactionForm;
                      return AnimatedOpacityContainer(
                        isAnimated: (!transactionForm.pocket.hasErrors ||
                                transactionForm.pocket.value != null) &&
                            transactionForm.pocket.value!.id < 0,
                        child: AccountPocketSelector(
                          label: 'Pocket',
                          placeholder: 'Select pocket',
                          color: pocket?.color,
                          icon: pocket?.type.icon,
                          name: pocket?.name,
                          balance: pocket?.formattedBalance,
                          formattedNewBalance: newBalance == pocket?.balance
                              ? null
                              : formattedNewBalance,
                          showBalanceChange: newBalance != pocket?.balance,
                          isDisabled:
                              subject == TransactionStaticSubject.pocket,
                          onTap: () async {
                            final selectedPocket = await SelectPocketRoute(
                              selectedPocketId: form.pocket.value?.id,
                              disableEmpty:
                                  subject == TransactionStaticSubject.pocket,
                            ).push<PocketModel>(context);
                            if (selectedPocket != null && context.mounted) {
                              form.pocket.value = selectedPocket;
                            }
                          },
                        ),
                      );
                    });
                  },
                ),
              ),

              // Amount input
              CardInput(
                label: 'Amount',
                child: MaskedAmountInput(
                  formControl: form.amount,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                  validationMessages: {
                    ErrorKey.required.name: (error) => ErrorKey.required.message(),
                    ErrorKey.number.name: (error) => ErrorKey.number.message(),
                    ErrorKey.exceedsPocketBalance.name: (error) =>
                        ErrorKey.exceedsPocketBalance.message(),
                    ErrorKey.exceedsAccountBalance.name: (error) =>
                        ErrorKey.exceedsAccountBalance.message(),
                    ErrorKey.exceedsBalance.name: (error) =>
                        ErrorKey.exceedsBalance.message(),
                  },
                ),
              ),

              CardInput(
                label: 'Category',
                child: ReactiveTextField(
                  formControl: form.category,
                  valueAccessor: _CategoryAccessor(),
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.chevron_right),
                    prefixIcon: Icon(form.categoryValue!.icon),
                  ),
                  onTap: (control) async {
                    if (control.value is Category) {
                      final selectedCategory = control.value as Category;
                      final category = await SelectCategoryRoute(
                              selectedCategoryIconKey: selectedCategory.iconKey)
                          .push<Category>(context);

                      if (category != null) {
                        control.value = category;
                      }
                    }
                  },
                ),
              ),

              CardInput(
                label: 'Transaction Date',
                child: DompetReactiveDateTimePicker(
                  formControl: form.date,
                  hintText: 'Select date',
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ),
              ),

              // Description input
              CardInput(
                label: 'Description',
                child: ReactiveTextField<String?>(
                  formControlName: 'description',
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ReactiveFormConsumer(
          builder: (context, formGroup, _) {
            final transactionForm = formGroup as TransactionForm;
            final isCreatingAccount = (!transactionForm.account.hasErrors ||
                    transactionForm.account.value != null) &&
                transactionForm.account.value!.id < 0;
            final isCreatingPocket = (!transactionForm.pocket.hasErrors ||
                    transactionForm.pocket.value != null) &&
                transactionForm.pocket.value!.id < 0;

            final isWaiting = isCreatingPocket || isCreatingAccount;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16).copyWith(bottom: 24),
              child: SubmitButton(
                text: 'Record Transaction',
                onPressed: isWaiting ? null : () => _submit(context),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryAccessor extends ControlValueAccessor<Category, String> {
  @override
  String? modelToViewValue(Category? modelValue) {
    if (modelValue == null) return null;
    // Convert Category to String for display
    return modelValue.displayName;
  }

  @override
  Category? viewToModelValue(String? viewValue) {
    if (viewValue == null) return null;
    // Convert String back to Category for the form control
    return Category.fromValue(viewValue);
  }
}
