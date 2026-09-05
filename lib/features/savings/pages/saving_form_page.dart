import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/calculator.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_action_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:dompet_app/features/savings/forms/saving_plan_form.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class SavingFormPage extends StatefulWidget {
  final SavingPlan? plan;
  const SavingFormPage({super.key, this.plan});

  @override
  State<SavingFormPage> createState() => _SavingFormPageState();
}

class _SavingFormPageState extends State<SavingFormPage> {
  final _loading = LoadingOverlay();

  late final SavingPlanForm _form;

  bool get _isEdit => widget.plan != null;

  @override
  void initState() {
    super.initState();
    _form = SavingPlanForm();
    _form.nameControl.value = widget.plan?.accountName;
    _form.iconCodeControl.value = widget.plan?.iconCode;
    _form.targetAmountControl.value = widget.plan?.targetAmount;
    _form.targetDateControl.value = widget.plan?.targetDateTime;
    _form.noteControl.value = widget.plan?.note;
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _showValidationMessage() {
    if (!_form.nameControl.valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(
          context,
          message: 'Nama target belum diisi',
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

    final cubit = actionContext.read<SavingActionCubit>();
    final plan = _isEdit
        ? await cubit.updatePlan(
            accountId: widget.plan!.accountId,
            form: _form,
            successMessage: 'Target berhasil diubah',
          )
        : await cubit.createPocket(
            form: _form,
            successMessage: 'Target berhasil dibuat',
          );

    if (!actionContext.mounted) return;

    if (plan != null) {
      actionContext.read<SavingSignalCubit>().created();
      actionContext.read<AccountSignalCubit>().created();
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
            _isEdit ? 'Ubah Target' : 'Buat Target',
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
                  _loading.show(context, text: 'Menyimpan target...');
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
                        formControl: _form.targetAmountControl,
                        errorMessage: 'Masukkan nominalnya dulu',
                      ),
                    ),
                    const SizedBox(width: 8),
                    CalculatorTriggerButton(
                      initialValue: _form.targetAmountControl.value,
                      onValueApplied: (value) {
                        final control = _form.targetAmountControl;
                        control
                          ..updateValue(value)
                          ..markAsDirty()
                          ..markAsTouched();
                      },
                    ),
                  ],
                ),

                DompetTextField(
                  label: 'Nama Target',
                  formControl: _form.nameControl,
                  placeholder: 'Contoh: VGA, Liburan, Dana Darurat',
                  textInputAction: .next,
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'Masukkan nama target terlebih dahulu',
                  },
                ),

                DompetDatePicker(
                  formControl: _form.targetDateControl,
                  label: 'Tanggal Target (Opsional)',
                  firstDate: DateTime.now(),
                  showClearIcon: true,
                ),

                const SizedBox(height: 8),

                DompetTextField(
                  label: 'Keterangan (Opsional)',
                  formControl: _form.noteControl,
                  keyboardType: TextInputType.multiline,
                  placeholder: 'Contoh: VGA RTX 4060...',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
