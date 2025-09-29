import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                child: GestureDetector(
                  onTap: () async {
                    final selectedAccount = await context.push<
                            SimpleAccountModel?>(
                        '/accounts/select?selectedAccountId=${form.accountControl.value?.id}');
                    if (selectedAccount != null && mounted) {
                      form.accountControl.value = selectedAccount;
                    }
                  },
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: form.account?.color?.withValues(alpha: 0.2) ??
                              Colors.black,
                        ),
                        child: Icon(
                          form.account?.type.icon,
                          color: form.account?.color ?? Colors.white,
                          size: 36,
                        ),
                      ),
                      Expanded(
                        child: ReactiveFormConsumer(
                            builder: (context, consumerForm, _) {
                          final form = consumerForm as TopUpForm;
                          final account = form.account;
                          final amount = form.amount;

                          final newBalance = (account?.balance ?? 0) + amount;
                          final formattedNewBalance =
                              FormatCurrency.formatRupiah(newBalance);
                          return Text.rich(
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                                text: account?.name ?? 'Select account',
                                style: const TextStyle(fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: '\n${account?.formattedBalance}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: newBalance == account?.balance
                                        ? []
                                        : [
                                            TextSpan(
                                              text: '  →  ',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: formattedNewBalance,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                  )
                                ]),
                          );
                        }),
                      ),
                    ],
                  ),
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
