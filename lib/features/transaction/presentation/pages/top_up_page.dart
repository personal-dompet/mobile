import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/core/utils/value_accessors/simple_account_value_accessor.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:dompet/features/account/presentation/pages/select_account_page.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
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

  final form = TopUpForm();

  void _submit(BuildContext context) async {
    // final walletNotifier =
    //     ProviderScope.containerOf(context).read(walletProvider.notifier);
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

    final walletAsync = ref.watch(walletProvider);

    if (walletAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final wallet = walletAsync.value;
    final balance = wallet?.formattedBalance ?? '0';

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
              const SizedBox(height: 16),

              CardInput(
                label: 'Account',
                child: ReactiveTextField<SimpleAccountModel>(
                  readOnly: true,
                  formControl: form.accountControl,
                  decoration: InputDecoration(
                    hintText: 'Select account',
                    suffixIcon: Icon(Icons.chevron_right_rounded),
                  ),
                  valueAccessor: SimpleAccountValueAccessor(),
                  onTap: (control) async {
                    final selectedAccount = await Navigator.of(context)
                        .push<SimpleAccountModel>(
                      MaterialPageRoute(
                        builder: (context) => SelectAccountPage(),
                        settings: RouteSettings(arguments: form),
                      ),
                    );
                    if (selectedAccount != null && mounted) {
                      form.accountControl.value = selectedAccount;
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

              // Balance information
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  final amount = formGroup.control('amount').value ?? 0;
                  final expectedBalance =
                      FormatCurrency.format((amount + (wallet?.balance ?? 0)));

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Balance Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Current Balance:'),
                              Text(balance),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Top Up Amount:'),
                              Text(amount > 0
                                  ? FormatCurrency.format(amount)
                                  : '0'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Divider(),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Expected Balance:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                expectedBalance,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
