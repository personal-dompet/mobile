import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/categories/widgets/category_field.dart';
import 'package:dompet_app/features/savings/cubits/saving_action_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:dompet_app/features/savings/forms/saving_spend_form.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:dompet_app/features/savings/widgets/pocket_balance_hint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class SavingSpendPage extends StatefulWidget {
  final int accountId;
  const SavingSpendPage({super.key, required this.accountId});

  @override
  State<SavingSpendPage> createState() => _SavingSpendPageState();
}

class _SavingSpendPageState extends State<SavingSpendPage> {
  final _loading = LoadingOverlay();

  late final SavingSpendForm _form;

  @override
  void initState() {
    super.initState();
    _form = SavingSpendForm();
    _form.pocketIdControl.value = widget.accountId;
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _showValidationMessage() {
    if (!_form.amountControl.valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(
          context,
          message: 'Nominal belanja belum diisi',
          snackBarType: .error,
        ),
      );
    }
  }

  Future<void> _submit(BuildContext actionContext) async {
    _form.markAllAsTouched();

    if (!_form.valid) {
      _showValidationMessage();
      return;
    }

    final journalId = await actionContext.read<SavingActionCubit>().spend(
      form: _form,
      successMessage: 'Pengeluaran berhasil dicatat',
    );

    if (!actionContext.mounted) return;

    if (journalId != null) {
      actionContext.read<SavingSignalCubit>().created();
      actionContext.read<AccountSignalCubit>().created();
      actionContext.read<ActivitySignalCubit>().created();
      // FIX-09/ISSUE-15: Jurnal 2 menyentuh akun expense — anggaran yang
      // melacak kategorinya harus segar (list + detail listen sinyal ini).
      actionContext.read<BudgetSignalCubit>().created();
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
            'Belanja dari Target',
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
                  _loading.show(context, text: 'Mencatat pengeluaran...');
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
                // FIX-10 (IMP-6, Q18): info terkumpul kini dari state detail.
                FutureBuilder(
                  future: getIt<SavingRepository>().getByAccountId(
                    widget.accountId,
                  ),
                  builder: (context, snapshot) {
                    final balance = snapshot.data?.balance;
                    if (balance == null) return const SizedBox.shrink();
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: PocketBalanceHint(balance: balance),
                    );
                  },
                ),
                AmountInput(
                  formControl: _form.amountControl,
                  errorMessage: 'Masukkan nominalnya dulu',
                ),
                SizedBox.shrink(),
                AssetSelector(
                  accountSelectorForm: _form.assetForm,
                  label: 'Dari Dompet',
                ),
                SizedBox.shrink(),
                // FIX-09: kategori opsional — kosong = fallback Lain-Lain.
                CategoryField(
                  valueControl: _form.categoryIdControl,
                  nameControl: _form.categoryNameControl,
                  type: .expense,
                ),
                SizedBox.shrink(),
                DompetTextField(
                  label: 'Keterangan (Opsional)',
                  formControl: _form.noteControl,
                  keyboardType: TextInputType.multiline,
                  placeholder: 'Contoh: Beli VGA...',
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
