import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/calculator.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/cubits/budget_action_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/budgets/forms/budget_plan_form.dart';
import 'package:dompet_app/features/budgets/models/budget_plan.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/widgets/category_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class BudgetPlanFormPage extends StatefulWidget {
  final Account category;
  final BudgetPlan? plan;
  const BudgetPlanFormPage({super.key, required this.category, this.plan});

  @override
  State<BudgetPlanFormPage> createState() => _BudgetPlanFormPageState();
}

class _BudgetPlanFormPageState extends State<BudgetPlanFormPage> {
  final _loading = LoadingOverlay();

  late final BudgetPlanForm _form;
  late final StreamSubscription<int?> _categoryChangeSub;

  bool get _isEdit => widget.plan != null;

  @override
  void initState() {
    super.initState();
    _form = BudgetPlanForm();
    _form.amountControl.value = widget.plan?.amount;
    _form.noteControl.value = widget.plan?.note;
    _form.categoryIdControl.value = widget.category.id;
    _form.categoryNameControl.value = widget.category.name;

    _categoryChangeSub = _form.categoryIdControl.valueChanges.listen((
      categoryId,
    ) async {
      if (categoryId == null || categoryId == widget.category.id) return;
      final requestedId = categoryId;
      final plan = await getIt<BudgetPlanRepository>().getByAccountId(
        requestedId,
      );
      if (!mounted) return;
      if (_form.categoryIdControl.value != requestedId) return;
      if (plan == null) return;
      final account = await getIt<CategoryCubit>().getCategoryById(requestedId);
      if (account == null || !mounted) return;
      if (_form.categoryIdControl.value != requestedId) return;
      context.router.replace(BudgetPlanRoute(category: account));
    });
  }

  @override
  void dispose() {
    _categoryChangeSub.cancel();
    _form.dispose();
    super.dispose();
  }

  void _showValidationMessage() {
    if (!_form.amountControl.valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(
          context,
          message: 'Nominal rencana belum diisi',
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

    final plan = await actionContext.read<BudgetActionCubit>().savePlan(
      form: _form,
      successMessage: _isEdit
          ? 'Rencana berhasil diubah'
          : 'Rencana berhasil disimpan',
    );

    if (!actionContext.mounted) return;

    if (plan != null) {
      actionContext.read<BudgetSignalCubit>().created();
      if (_isEdit) {
        actionContext.router.maybePop(true);
        return;
      }
      final account = await getIt<CategoryCubit>().getCategoryById(
        plan.accountId,
      );
      if (account == null || !context.mounted) return;
      actionContext.router.replace(BudgetPlanRoute(category: account));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEdit ? 'Ubah Rencana' : 'Buat Rencana',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => getIt<BudgetActionCubit>(),
          child: BlocListener<BudgetActionCubit, ActionState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {
                  _loading.hide();
                },
                loading: () {
                  _loading.show(context, text: 'Menyimpan rencana...');
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
                        child: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan'),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: AmountInput(
                        formControl: _form.amountControl,
                        errorMessage: 'Masukkan nominalnya dulu',
                      ),
                    ),
                    const SizedBox(width: 8),
                    CalculatorTriggerButton(
                      initialValue: _form.amountControl.value,
                      onValueApplied: (value) {
                        final control = _form.amountControl;
                        control
                          ..updateValue(value)
                          ..markAsDirty()
                          ..markAsTouched();
                      },
                    ),
                  ],
                ),

                CategoryField(
                  valueControl: _form.categoryIdControl,
                  nameControl: _form.categoryNameControl,
                  type: .expense,
                  required: true,
                  readOnly: _isEdit,
                  withBudget: true,
                ),

                const SizedBox(height: 8),

                DompetTextField(
                  label: 'Keterangan (Opsional)',
                  formControl: _form.noteControl,
                  keyboardType: TextInputType.multiline,
                  placeholder:
                      'Contoh: Kebutuhan bulanan, transport bulanan...',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
