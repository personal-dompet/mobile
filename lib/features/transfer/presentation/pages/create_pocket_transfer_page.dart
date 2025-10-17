import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/core/widgets/account_pocket_selector.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreatePocketTransferPage extends ConsumerStatefulWidget {
  final TransferStaticSubject? subject;
  const CreatePocketTransferPage({super.key, this.subject});

  @override
  ConsumerState<CreatePocketTransferPage> createState() =>
      _CreateTransferPageState();
}

class _CreateTransferPageState extends ConsumerState<CreatePocketTransferPage> {
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
    final form = ref.read(pocketTransferFormProvider);
    if (!form.valid) {
      form.markAllAsTouched();
      setState(() {
        _hasValidated = true;
      });
      return;
    }
    final payload = form;
    Navigator.of(context).pop<PocketTransferForm>(payload);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(pocketTransferFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Funds'),
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
                    final form = consumerForm as PocketTransferForm;
                    final fromPocket = form.fromPocketValue;
                    final amount = form.amountValue;

                    final newBalance = (fromPocket.balance) - amount;
                    final formattedNewBalance =
                        FormatCurrency.formatRupiah(newBalance);

                    return AccountPocketSelector(
                      label: 'From Pocket',
                      placeholder: 'Select source pocket',
                      color: fromPocket.color,
                      icon: fromPocket.icon?.icon,
                      name: fromPocket.name,
                      balance: fromPocket.formattedBalance,
                      formattedNewBalance: newBalance == fromPocket.balance
                          ? null
                          : formattedNewBalance,
                      showBalanceChange: newBalance != fromPocket.balance,
                      isDisabled:
                          widget.subject == TransferStaticSubject.source,
                      onTap: () async {
                        final selectedPocket = await context
                            .pushNamed<PocketModel>('SelectPocket',
                                queryParameters: {
                              'selectedPocketId':
                                  form.fromPocket.value?.id.toString(),
                              'title': 'origin',
                            });
                        if (selectedPocket != null && mounted) {
                          form.fromPocket.value = selectedPocket;
                        }
                      },
                    );
                  },
                ),
              ),

              CardInput(
                label: 'Destination',
                child: ReactiveFormConsumer(
                  builder: (context, consumerForm, _) {
                    final form = consumerForm as PocketTransferForm;
                    final toPocket = form.toPocketValue;
                    final amount = form.amountValue;

                    final newBalance = (toPocket.balance) + amount;
                    final formattedNewBalance =
                        FormatCurrency.formatRupiah(newBalance);

                    return AccountPocketSelector(
                      label: 'To Pocket',
                      placeholder: 'Select destination pocket',
                      color: toPocket.color,
                      icon: toPocket.icon?.icon,
                      name: toPocket.name,
                      balance: toPocket.formattedBalance,
                      isDisabled:
                          widget.subject == TransferStaticSubject.destination,
                      formattedNewBalance: newBalance == toPocket.balance
                          ? null
                          : formattedNewBalance,
                      showBalanceChange: newBalance != toPocket.balance,
                      onTap: () async {
                        final selectedPocket = await context
                            .pushNamed<PocketModel>('SelectPocket',
                                queryParameters: {
                              'selectedPocketId':
                                  form.toPocket.value?.id.toString(),
                              'title': 'destination',
                            });
                        if (selectedPocket != null && mounted) {
                          form.toPocket.value = selectedPocket;
                        }
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
                    final formGroup = form as PocketTransferForm;
                    final amountControl = formGroup.amount;
                    final fromPocketControl = formGroup.fromPocket;

                    String? errorText;
                    if (_hasValidated &&
                        amountControl.invalid &&
                        amountControl.hasError('exceedsBalance')) {
                      final fromPocket = fromPocketControl.value;
                      if (fromPocket != null) {
                        errorText =
                            'Amount exceeds pocket balance of ${FormatCurrency.formatRupiah(fromPocket.balance)}';
                      }
                    } else if (_hasValidated &&
                        amountControl.invalid &&
                        amountControl.hasError('min')) {
                      errorText = 'Amount must be at least 1';
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
              const SizedBox(height: 24),

              // Submit button
              SubmitButton(
                text: 'Transfer Funds',
                onPressed: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
