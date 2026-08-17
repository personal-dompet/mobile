import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/loading_overlay.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/widgets/category_grouped_list.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class CategoryPage extends StatefulWidget {
  final TransactionType type;
  const CategoryPage({super.key, required this.type});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _keywordControl = FormControl<String>();

  Timer? _debounce;

  final _loading = LoadingOverlay();

  final _categoryAccountCubit = getIt<CategoryCubit>();

  @override
  void initState() {
    super.initState();
    _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _categoryAccountCubit.fetch(keyword: keyword, type: widget.type);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _categoryAccountCubit.close();
    _keywordControl.dispose();
    super.dispose();
  }

  Future<void> _createCategory() async {
    final form = CategoryForm();
    form.typeControl.updateValue(widget.type == .expense ? .expense : .income);
    await context.router.push<Account?>(CategoryFormRoute(form: form));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSignalCubit, int>(
      listener: (context, state) {
        _categoryAccountCubit.refresh();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _categoryAccountCubit
              ..fetch(type: widget.type, keyword: _keywordControl.value),
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
                  DompetSnackbar(
                    context,
                    message: message,
                    snackBarType: .error,
                  ),
                );
              },
              loading: () =>
                  _loading.show(context, text: 'Menambah kategori...'),
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
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Kategori ${widget.type == .expense ? 'Pengeluaran' : 'Pemasukan'}',
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: _createCategory,
                    icon: Icon(Icons.add_rounded),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16).copyWith(bottom: 24),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    DompetTextField(
                      placeholder: 'Cari nama kategori...',
                      formControl: _keywordControl,
                      textInputAction: .search,
                      clearable: true,
                    ),
                    Expanded(
                      child: BlocBuilder<CategoryCubit, CategoryState>(
                        bloc: _categoryAccountCubit,
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => SizedBox.shrink(),
                            error: (message) => Center(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                textAlign: .center,
                              ),
                            ),
                            loading: () {
                              return Padding(
                                padding: const EdgeInsets.only(top: 64),
                                child: SpinnerLoading(),
                              );
                            },
                            loaded: (categories) {
                              return CategoryGroupedList(
                                categories: categories,
                                onCreate: _createCategory,
                                type: widget.type,
                              );
                            },
                            refreshing: (categories) {
                              return CategoryGroupedList(
                                categories: categories,
                                onCreate: _createCategory,
                                type: widget.type,
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
          ),
        ),
      ),
    );
  }
}
