import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/transactions/cubits/transfer_cubit.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class TransferPage extends StatefulWidget {
  final TransferForm? form;
  final int? id;
  const TransferPage({super.key, this.form, this.id});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _loading = LoadingOverlay();

  late TransferForm _form;

  int _previousAmount = 0;

  @override
  void initState() {
    super.initState();
    _form = widget.form ?? TransferForm();
    if (isEdit) {
      _previousAmount = _form.amount ?? 0;
    }
  }

  bool get isEdit => widget.id != null;

  Future<bool?> _insufficientBalanceConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return DompetDialog(
          title: 'Saldo mungkin menjadi negatif',
          subtitle:
              'Nominal yang dipindahkan lebih besar dari saldo yang tersedia di ${_form.accountSourceName ?? 'dompet asal'}. Transfer tetap dapat disimpan.',
          confirmationText: 'Tetap Simpan',
          onCancel: () {
            Navigator.of(context).pop(false);
          },
          onConfirm: () {
            Navigator.of(context).pop(true);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pindah Dana', style: TextStyle(fontWeight: .w500)),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => getIt<TransferCubit>(),
          child: BlocListener<TransferCubit, ActionState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {
                  _loading.hide();
                },
                loading: () {
                  _loading.show(context, text: 'Memindahkan dana...');
                },
                error: (message) {
                  _loading.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    DompetSnackbar(
                      context,
                      message: message,
                      snackBarType: .error,
                    ),
                  );
                },
                success: (message) {
                  _loading.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    DompetSnackbar(
                      context,
                      message: message,
                      snackBarType: .success,
                    ),
                  );
                },
              );
            },
            child: Builder(
              builder: (providedContext) {
                return Padding(
                  padding: const EdgeInsets.all(16).copyWith(bottom: 24),
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .stretch,
                    children: [
                      FilledButton(
                        key: TestKeys.transferSave,
                        onPressed: () async {
                          _form.markAllAsTouched();

                          if (_form.valid) {
                            final balance =
                                _form.accountSourceBalance! + _previousAmount;
                            if (_form.amount! > balance) {
                              final result =
                                  await _insufficientBalanceConfirmation(
                                    context,
                                  );

                              if (result != true) return;
                            }

                            if (!providedContext.mounted) return;

                            int? newEditedId;
                            if (isEdit) {
                              newEditedId = await providedContext
                                  .read<TransferCubit>()
                                  .updateTransfer(form: _form, id: widget.id!);
                            } else {
                              await providedContext
                                  .read<TransferCubit>()
                                  .transferBalance(form: _form);
                            }

                            if (!providedContext.mounted) return;
                            providedContext
                                .read<ActivitySignalCubit>()
                                .created();
                            providedContext.maybePop(newEditedId);
                          }
                        },
                        child: Text('Simpan'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              // crossAxisAlignment: .stretch,
              spacing: 16,
              children: [
                AmountInput(
                  key: TestKeys.transferAmount,
                  formControl: _form.amountControl,
                  errorMessage: 'Masukkan nominalnya dulu',
                ),

                SizedBox.shrink(),

                ReactiveValueListenableBuilder(
                  formControl: _form.destinationForm.idControl,
                  builder: (context, control, child) {
                    final accountDestinationIdControl =
                        control as FormControl<int>;
                    final accountDestinationId =
                        accountDestinationIdControl.value;
                    return AssetSelector(
                      key: TestKeys.transferSource,
                      accountSelectorForm: _form.sourceForm,
                      label: 'Dari Dompet',
                      disabledAssetId: accountDestinationId,
                    );
                  },
                ),

                FilledButton.tonalIcon(
                  key: TestKeys.transferSwap,
                  onPressed: () {
                    final sourceId = _form.sourceForm.id;
                    final sourceName = _form.sourceForm.name;
                    final sourceBalance = _form.sourceForm.balance;

                    final destinationId = _form.destinationForm.id;
                    final destinationName = _form.destinationForm.name;
                    final destinationBalance = _form.destinationForm.balance;

                    _form.sourceForm.idControl.value = destinationId;
                    _form.sourceForm.nameControl.value = destinationName;
                    _form.sourceForm.balanceControl.value = destinationBalance;

                    _form.destinationForm.idControl.value = sourceId;
                    _form.destinationForm.nameControl.value = sourceName;
                    _form.destinationForm.balanceControl.value = sourceBalance;
                  },
                  label: Text('Tukar'),
                  icon: Icon(Icons.swap_vert_rounded),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),

                ReactiveValueListenableBuilder(
                  formControl: _form.sourceForm.idControl,
                  builder: (context, control, child) {
                    final accountSourceIdControl = control as FormControl<int>;
                    final accountSourceId = accountSourceIdControl.value;
                    return AssetSelector(
                      key: TestKeys.transferDestination,
                      accountSelectorForm: _form.destinationForm,
                      label: 'Ke Dompet',
                      disabledAssetId: accountSourceId,
                    );
                  },
                ),

                SizedBox.shrink(),
                DompetTextField(
                  label: 'Keterangan (Opsional)',
                  formControl: _form.noteControl,
                  keyboardType: TextInputType.multiline,
                  placeholder: 'Contoh: Top up GoPay, tarik saldo BCA...',
                ),

                DompetDateTimePicker(
                  formControl: _form.dateControl,
                  label: 'Tanggal Transaksi',
                  lastDate: DateTime.now(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
