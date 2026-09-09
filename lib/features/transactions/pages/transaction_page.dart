import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/calculator.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/categories/widgets/category_field.dart';
import 'package:dompet_app/features/transactions/cubits/transaction_cubit.dart';
import 'package:dompet_app/features/transactions/effective_balance.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class TransactionPage extends StatefulWidget {
  final TransactionType type;
  final bool batch;
  final TransactionForm? form;
  final int? id;
  const TransactionPage({
    super.key,
    required this.type,
    this.batch = false,
    this.form,
    this.id,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _loading = LoadingOverlay();

  late TransactionForm _form;

  int _previousAmount = 0;
  int? _previousAssetId;

  @override
  void initState() {
    super.initState();
    _form = widget.form ?? TransactionForm();
    if (isEdit) {
      _previousAmount = _form.totalAmount ?? 0;
      _previousAssetId = _form.assetId;
    }
  }

  bool get isEdit => widget.id != null;

  /// FIX-07 (IMP-1, Q3): dialog persetujuan 2 jurnal dengan angka selisih.
  /// Setuju = catat Jurnal 1 penyesuaian selisih + Jurnal 2 transaksi biasa.
  Future<bool?> _insufficientBalanceConfirmation(
    BuildContext context, {
    required int shortfall,
    required int totalAmount,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return DompetDialog(
          title: 'Saldo tidak cukup',
          subtitle:
              'Saldo ${_form.assetName ?? 'dompet ini'} kurang ${shortfall.currency}. Untuk mencatat pengeluaran sebesar ${totalAmount.currency}, saldo akan disesuaikan terlebih dahulu sebesar ${shortfall.currency}.',
          confirmationText: 'Lanjut',
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
    final String appBarTitle = switch ((widget.type, isEdit)) {
      (.expense, false) => 'Catat Pengeluaran',
      (.expense, true) => 'Perbarui Catatan Pengeluaran',
      (.income, false) => 'Catat Pemasukan',
      (.income, true) => 'Perbarui Catatan Pemasukan',
    };

    return ReactiveForm(
      formGroup: _form,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle, style: TextStyle(fontWeight: .w500)),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => getIt<TransactionCubit>(),
          child: BlocListener<TransactionCubit, ActionState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {
                  _loading.hide();
                },
                loading: () {
                  _loading.show(
                    context,
                    text:
                        'Mencatat ${widget.type == .expense ? 'pengeluaran' : 'pemasukan'}...',
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
                    mainAxisSize: .min,
                    crossAxisAlignment: .stretch,
                    spacing: 8,
                    children: [
                      FilledButton(
                        key: TestKeys.transactionSave,
                        onPressed: () async {
                          _form.markAllAsTouched();

                          if (_form.valid) {
                            final totalAmount = _form.categories.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.amount!,
                            );
                            final effectiveBalance = computeEffectiveBalance(
                              currentBalance: _form.assetBalance!,
                              type: widget.type,
                              previousAmount: isEdit ? _previousAmount : null,
                              previousAssetId: _previousAssetId,
                              currentAssetId: _form.assetId,
                            );

                            if (widget.type == .expense &&
                                totalAmount > effectiveBalance) {
                              final result =
                                  await _insufficientBalanceConfirmation(
                                    context,
                                    shortfall: totalAmount - effectiveBalance,
                                    totalAmount: totalAmount,
                                  );

                              if (result != true) return;
                            }

                            if (!providedContext.mounted) return;

                            int? newEditedId;
                            if (isEdit) {
                              // FIX-07: void + penyesuaian selisih + catat baru,
                              // atomik di repo (re-check saldo live di txn).
                              newEditedId = await providedContext
                                  .read<TransactionCubit>()
                                  .updateTransactionAuto(
                                    id: widget.id!,
                                    form: _form,
                                    type: widget.type,
                                    previousAmount: _previousAmount,
                                    previousAssetId: _previousAssetId,
                                  );
                            } else {
                              await providedContext
                                  .read<TransactionCubit>()
                                  .recordTransactionAuto(
                                    form: _form,
                                    type: widget.type,
                                  );
                            }

                            if (!providedContext.mounted) return;
                            providedContext
                                .read<ActivitySignalCubit>()
                                .created();
                            providedContext.read<BudgetSignalCubit>().created();
                            providedContext.maybePop(newEditedId);
                          }
                        },
                        child: Text('Simpan'),
                      ),

                      if (!widget.batch && !isEdit)
                        TextButton(
                          onPressed: () {
                            providedContext.router.replace(
                              TransactionRoute(type: widget.type, batch: true),
                            );
                          },
                          child: Text('Catat banyak kategori sekaligus'),
                        ),

                      if (widget.batch)
                        TextButton(
                          onPressed: () {
                            providedContext.router.replace(
                              TransactionRoute(type: widget.type),
                            );
                          },
                          child: Text('Catat satu kategori'),
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
                if (!widget.batch)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: AmountInput(
                          key: TestKeys.transactionAmount,
                          formControl: _form.categories.first.amountControl,
                          errorMessage:
                              'Masukkan nominal ${widget.type == .expense ? 'pengeluaran' : 'pemasukan'} dulu',
                        ),
                      ),
                      const SizedBox(width: 8),
                      CalculatorTriggerButton(
                        onValueApplied: (value) {
                          final control = _form.categories.first.amountControl;
                          control
                            ..updateValue(value)
                            ..markAsDirty()
                            ..markAsTouched();
                        },
                      ),
                    ],
                  )
                else
                  AmountInput(
                    formControl: _form.totalAmountControl,
                    readOnly: true,
                  ),

                SizedBox.shrink(),

                if (widget.batch)
                  Column(
                    crossAxisAlignment: .stretch,
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      ReactiveFormArray(
                        formArray: _form.categoriesFormArray,
                        builder: (context, formArray, child) {
                          final categoriesForm = _form.categories;
                          return Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .stretch,
                            spacing: 8,
                            children: categoriesForm.indexed.map((record) {
                              final (index, categoryForm) = record;
                              final key = ValueKey(categoryForm);
                              return Card(
                                key: key,
                                child: Padding(
                                  padding: EdgeInsets.all(16).copyWith(
                                    bottom: categoriesForm.length > 1 ? 0 : 2,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: .stretch,
                                    children: [
                                      CategoryField(
                                        key: key,
                                        valueControl:
                                            categoryForm.categoryIdControl,
                                        nameControl:
                                            categoryForm.categoryNameControl,
                                        type: widget.type,
                                      ),
                                      SizedBox(height: 8),
                                      DompetNumberField(
                                        labelText: 'Nominal',
                                        formControl: categoryForm.amountControl,
                                        border: OutlineInputBorder(),
                                        isCurrency: true,
                                        showCalculator: true,
                                        validationMessages: {
                                          ValidationMessage.required: (error) =>
                                              'Masukkan nominal untuk kategori ini terlebih dahulu',
                                        },
                                      ),
                                      SizedBox(height: 8),
                                      DompetTextField(
                                        label: 'Keterangan',
                                        formControl: categoryForm.noteControl,
                                        placeholder: widget.type == .expense
                                            ? 'Contoh: Makan siang, beli kopi, ganti oli...'
                                            : 'Contoh: Gaji, bonus, komisi...',
                                      ),
                                      if (categoriesForm.length > 1)
                                        TextButton.icon(
                                          onPressed: () {
                                            _form.removeCategory(index);
                                          },
                                          label: Text('Hapus'),
                                          icon: Icon(Icons.delete_rounded),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _form.addCategory();
                        },
                        icon: Icon(Icons.add_rounded),
                        label: Text('Tambah Kategori'),
                      ),
                    ],
                  ),

                if (!widget.batch)
                  CategoryField(
                    valueControl: _form.categories.first.categoryIdControl,
                    nameControl: _form.categories.first.categoryNameControl,
                    type: widget.type,
                  ),

                AssetSelector(
                  key: TestKeys.transactionAsset,
                  accountSelectorForm: _form.assetForm,
                  label: 'Pilih Dompet',
                ),

                SizedBox.shrink(),
                DompetTextField(
                  label: 'Keterangan (Opsional)',
                  formControl: _form.noteControl,
                  keyboardType: TextInputType.multiline,
                  placeholder: switch ((widget.type, widget.batch)) {
                    (.expense, true) => 'Contoh: Belanja bulanan...',
                    (.expense, false) =>
                      'Contoh: Makan siang, beli kopi, ganti oli...',
                    (.income, true) => 'Contoh: Pendapatan bulan ini...',
                    (.income, false) => 'Contoh: Gaji, bonus, komisi...',
                  },
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
