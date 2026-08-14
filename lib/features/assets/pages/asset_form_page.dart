import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/assets/cubits/asset_cubit.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class AssetFormPage extends StatefulWidget {
  final AssetForm? form;
  final int? id;
  const AssetFormPage({super.key, this.form, this.id})
    : assert(
        (form != null) == (id != null),
        'Form dan ID harus diisi bersamaan, atau keduanya harus dikosongkan.',
      );

  @override
  State<AssetFormPage> createState() => _AssetFormPageState();
}

class _AssetFormPageState extends State<AssetFormPage> {
  late AssetForm _form;

  final _loading = LoadingOverlay();

  @override
  void initState() {
    super.initState();
    _form = widget.form ?? AssetForm();
  }

  bool get isEdit => widget.form != null && widget.id != null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AssetCubit>()..getPresetAssets(),
        ),
        BlocProvider(create: (context) => getIt<AccountActionCubit>()),
      ],
      child: BlocListener<AccountActionCubit, ActionState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {
              _loading.hide();
            },
            error: (message) {
              _loading.hide();
              ScaffoldMessenger.of(context).showSnackBar(
                DompetSnackbar(context, message: message, snackBarType: .error),
              );
            },
            loading: () => _loading.show(context, text: 'Menambah dompet...'),
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
        child: ReactiveForm(
          formGroup: _form,
          child: Scaffold(
            appBar: AppBar(
              title: Text(isEdit ? 'Ubah Dompet' : 'Tambah Dompet Baru'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: BlocBuilder<AssetCubit, AssetState>(
                  builder: (context, state) {
                    final List<Account> presetAccounts = state.maybeWhen(
                      orElse: () => [],
                      loaded: (assets) => assets,
                    );
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        DompetDropdownField(
                          formControl: _form.codeControl,
                          items: presetAccounts.map((account) {
                            return DropdownMenuItem(
                              value: account.code,
                              child: Text(account.name),
                            );
                          }).toList(),
                          label: 'Jenis Dompet',
                          placeholder: 'Pilih jenis dompet',
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'Pilih jenis dompet dahulu',
                          },
                          readOnly: presetAccounts.isEmpty,
                        ),
                        DompetTextField(
                          label: 'Nama Dompet',
                          formControl: _form.nameControl,
                          placeholder: 'Contoh: Dompet Utama',
                          textInputAction: .next,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Masukkan nama dompet terlebih dahulu',
                          },
                        ),
                        if (!isEdit)
                          DompetNumberField(
                            labelText: 'Saldo saat ini (Opsional)',
                            formControl: _form.balanceControl,
                            border: OutlineInputBorder(),
                            isCurrency: true,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 24),
              child: Builder(
                builder: (providedContext) {
                  return FilledButton(
                    onPressed: () async {
                      _form.markAllAsTouched();
                      if (_form.valid) {
                        if (isEdit && widget.id != null) {
                          await providedContext
                              .read<AccountActionCubit>()
                              .updateAccount(form: _form, id: widget.id!);
                        } else {
                          await providedContext
                              .read<AccountActionCubit>()
                              .createAsset(_form);
                        }

                        if (!providedContext.mounted) return;

                        providedContext.read<AccountSignalCubit>().created();
                        providedContext.maybePop();
                      }
                    },
                    child: Text('Simpan'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
