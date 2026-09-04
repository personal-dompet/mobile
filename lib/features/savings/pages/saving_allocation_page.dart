import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_action_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:dompet_app/features/savings/forms/saving_allocation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class SavingAllocationPage extends StatefulWidget {
  final int accountId;
  final bool isWithdraw;
  const SavingAllocationPage({
    super.key,
    required this.accountId,
    this.isWithdraw = false,
  });

  @override
  State<SavingAllocationPage> createState() => _SavingAllocationPageState();
}

class _SavingAllocationPageState extends State<SavingAllocationPage> {
  final _loading = LoadingOverlay();

  late final SavingAllocationForm _form;

  bool get _isWithdraw => widget.isWithdraw;

  @override
  void initState() {
    super.initState();
    _form = SavingAllocationForm();
    _form.pocketIdControl.value = widget.accountId;
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext actionContext) async {
    _form.markAllAsTouched();

    if (!_form.valid) return;

    final cubit = actionContext.read<SavingActionCubit>();
    final journalId = _isWithdraw
        ? await cubit.withdraw(
            form: _form,
            successMessage: 'Penarikan berhasil dicatat',
          )
        : await cubit.topup(
            form: _form,
            successMessage: 'Alokasi berhasil dicatat',
          );

    if (!actionContext.mounted) return;

    if (journalId != null) {
      actionContext.read<SavingSignalCubit>().created();
      actionContext.read<AccountSignalCubit>().created();
      actionContext.read<ActivitySignalCubit>().created();
      actionContext.router.maybePop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isWithdraw ? 'Tarik Dana' : 'Alokasi Dana',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => getIt<SavingActionCubit>(),
          child: BlocListener<SavingActionCubit, ActionState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {
                  _loading.hide();
                },
                loading: () {
                  _loading.show(
                    context,
                    text: _isWithdraw
                        ? 'Menarik dana...'
                        : 'Mengalokasikan dana...',
                  );
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        onPressed: () => _submit(providedContext),
                        child: const Text('Simpan'),
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
              spacing: 16,
              children: [
                AmountInput(
                  formControl: _form.amountControl,
                  errorMessage: 'Masukkan nominalnya dulu',
                ),
                SizedBox.shrink(),
                AssetSelector(
                  accountSelectorForm: _form.assetForm,
                  label: _isWithdraw ? 'Ke Dompet' : 'Dari Dompet',
                ),
                SizedBox.shrink(),
                DompetTextField(
                  label: 'Keterangan (Opsional)',
                  formControl: _form.noteControl,
                  keyboardType: TextInputType.multiline,
                  placeholder: _isWithdraw
                      ? 'Contoh: Tarik untuk kebutuhan mendesak...'
                      : 'Contoh: Alokasi bulan ini...',
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
