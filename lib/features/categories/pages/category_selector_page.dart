import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class CategorySelectorPage extends StatefulWidget {
  final TransactionType type;
  const CategorySelectorPage({super.key, required this.type});

  @override
  State<CategorySelectorPage> createState() => _CategorySelectorPageState();
}

class _CategorySelectorPageState extends State<CategorySelectorPage> {
  final _keywordControl = FormControl<String>();

  Timer? _debounce;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoryAccountCubit
        ..fetch(type: widget.type, keyword: _keywordControl.value),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pilih Kategori ${widget.type == .expense ? 'Pengeluaran' : 'Pemasukan'}',
          ),
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
                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return ListTile(
                                title: Text(category.name),
                                leading: Icon(
                                  category.iconCode == null
                                      ? Icons.receipt_rounded
                                      : MaterialIconData.fromCode(
                                          category.iconCode!,
                                        ),
                                ),
                                onTap: () {
                                  debugPrint(
                                    'Selected category: ${category.name}',
                                  );
                                  Navigator.of(context).pop<Account>(category);
                                },
                              );
                            },
                          );
                        },
                        refreshing: (categories) {
                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return ListTile(
                                title: Text(category.name),
                                enabled: true,
                                leading: Icon(
                                  category.iconCode == null
                                      ? Icons.receipt_rounded
                                      : MaterialIconData.fromCode(
                                          category.iconCode!,
                                        ),
                                ),
                                onTap: () {
                                  debugPrint('print');
                                  Navigator.of(context).pop<Account>(category);
                                },
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
      ),
    );
  }
}
