import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/transactions/cubits/balance_adjustment_cubit.dart';
import 'package:dompet_app/features/transactions/forms/balance_adjustment_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class BalanceAdjustmentPage extends StatefulWidget {
  final Account account;
  const BalanceAdjustmentPage({super.key, required this.account});

  @override
  State<BalanceAdjustmentPage> createState() => _BalanceAdjustmentPageState();
}

class _BalanceAdjustmentPageState extends State<BalanceAdjustmentPage> {
  final _loading = LoadingOverlay();

  late BalanceAdjustmentForm _form;

  @override
  void initState() {
    super.initState();
    _form = BalanceAdjustmentForm();

    _form.accountControl.updateValue(widget.account);
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sesuaikan Saldo', style: TextStyle(fontWeight: .w500)),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => getIt<BalanceAdjustmentCubit>(),
          child: BlocListener<BalanceAdjustmentCubit, ActionState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {
                  _loading.hide();
                },
                loading: () {
                  _loading.show(context, text: 'Menyesuaikan saldo...');
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
                        onPressed: () async {
                          _form.markAllAsTouched();

                          if (_form.valid) {
                            await providedContext
                                .read<BalanceAdjustmentCubit>()
                                .adjustBalance(_form);

                            if (!providedContext.mounted) return;
                            providedContext
                                .read<ActivitySignalCubit>()
                                .created();
                            providedContext.maybePop(true);
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
              spacing: 16,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Saldo ${widget.account.name} sekarang',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        widget.account.balance.currency,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: .w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Saldo sebenarnya',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    AmountInput(
                      formControl: _form.amountControl,
                      textInputAction: .done,
                      errorMessage: 'Masukkan saldo yang sebenarnya dulu',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
