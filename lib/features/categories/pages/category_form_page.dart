import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/constants/category_icon_options.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/models/account_icon_option.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/loading_overlay.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class CategoryFormPage extends StatefulWidget {
  final CategoryForm form;
  final int? id;
  const CategoryFormPage({super.key, required this.form, this.id});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _loading = LoadingOverlay();
  final _iconKeywordControl = FormControl<String>();

  List<AccountIconOption> get _options {
    return switch (widget.form.type) {
      .expense => expenseCategoryIconOptions,
      .income => incomeCategoryIconOptions,
      _ => [],
    };
  }

  bool get isEdit => widget.id != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccountActionCubit>(),
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
            loading: () => _loading.show(context, text: 'Menambah kategori...'),
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
          formGroup: widget.form,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                isEdit
                    ? 'Ubah Kategori'
                    : 'Tambah Kategori ${widget.form.type == .expense ? 'Pengeluaran' : 'Pemasukan'}',
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DompetTextField(
                      label: 'Nama kategori',
                      formControl: widget.form.nameControl,
                      placeholder: 'Contoh: Liburan',
                      textInputAction: .next,
                      validationMessages: {
                        ValidationMessage.required: (error) =>
                            'Masukkan nama kategori terlebih dahulu',
                      },
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Pilih Ikon',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: .start,
                      ),
                    ),
                    SizedBox(height: 8),
                    DompetTextField(
                      formControl: _iconKeywordControl,
                      placeholder: 'Cari ikon...',
                      textInputAction: .search,
                      clearable: true,
                    ),
                    Expanded(
                      child: ReactiveValueListenableBuilder(
                        formControl: _iconKeywordControl,
                        builder: (context, control, child) {
                          final keywordControl = control as FormControl<String>;
                          List<AccountIconOption> options = _options;

                          if (keywordControl.value != null) {
                            options = _options
                                .where(
                                  (option) => option.matchKeyword(
                                    keyword: keywordControl.value!,
                                  ),
                                )
                                .toList();
                          }

                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options[index];
                              return ReactiveValueListenableBuilder(
                                formControl: widget.form.iconControl,
                                builder: (context, control, _) {
                                  final iconControl =
                                      control as FormControl<AccountIconOption>;
                                  return Card(
                                    clipBehavior: .antiAlias,
                                    color:
                                        iconControl.value?.icon.codePoint ==
                                            option.icon.codePoint
                                        ? Theme.of(context).colorScheme.primary
                                              .withValues(alpha: 0.15)
                                        : null,
                                    child: InkWell(
                                      onTap: () {
                                        widget.form.iconControl.updateValue(
                                          option,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          option.icon,
                                          color:
                                              iconControl
                                                      .value
                                                      ?.icon
                                                      .codePoint ==
                                                  option.icon.codePoint
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : null,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 24),
              child: Builder(
                builder: (providedContext) {
                  return FilledButton(
                    onPressed: () async {
                      widget.form.markAllAsTouched();
                      if (widget.form.valid) {
                        Account? category;
                        if (isEdit && widget.id != null) {
                          await providedContext
                              .read<AccountActionCubit>()
                              .updateCategory(
                                form: widget.form,
                                id: widget.id!,
                              );
                        } else {
                          category = await providedContext
                              .read<AccountActionCubit>()
                              .createCategory(form: widget.form);
                        }

                        if (!providedContext.mounted) return;

                        providedContext.read<AccountSignalCubit>().created();
                        providedContext.maybePop(category);
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
