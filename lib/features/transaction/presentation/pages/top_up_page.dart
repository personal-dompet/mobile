import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/core/widgets/account_pocket_selector.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/reactive_datetime_picker.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TopUpPage extends ConsumerStatefulWidget {
  const TopUpPage({
    super.key,
  });

  @override
  ConsumerState<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends ConsumerState<TopUpPage> {
  late FocusNode _descriptionFocusNode;

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
    final form = ProviderScope.containerOf(context).read(topUpFormProvider);
    if (form.valid) {
      // Show loading or disable button here if needed

      // Perform the top-up operation first
      // await walletNotifier.topUp();

      // Check if the widget is still mounted before updating UI
      // if (!mounted || !context.mounted) return;

      final payload = form;

      // Reset the form
      // form.reset();

      // context.showSuccessSnackbar('Top-up successful!');

      // Navigate back
      Navigator.of(context).pop<TopUpForm>(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final form = ref.watch(topUpFormProvider);

    form.date.value = now;

    final walletAsync = ref.watch(walletProvider);

    if (walletAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Wallet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                    final form = consumerForm as TopUpForm;
                    final account = form.accountValue;
                    final amount = form.amountValue;

                    final newBalance = (account?.balance ?? 0) + amount;
                    final formattedNewBalance =
                        FormatCurrency.formatRupiah(newBalance);

                    return AccountPocketSelector(
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
                      onTap: () async {
                        final selectedAccount = await SelectAccountRoute(
                          selectedAccountId: form.account.value?.id,
                        ).push<AccountModel>(context);
                        if (selectedAccount != null && mounted) {
                          form.account.value = selectedAccount;
                        }
                      },
                    );
                  },
                ),
              ),

              // Amount input
              CardInput(
                label: 'Amount',
                child: MaskedAmountInput(
                  formControlName: 'amount',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              CardInput(
                label: 'Top Up Date',
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
              const SizedBox(height: 24),

              // Submit button
              SubmitButton(
                text: 'Top Up',
                onPressed: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
