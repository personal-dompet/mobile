import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/budgets/cubits/budget_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/budgets/widgets/budget_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _keywordControl = FormControl<String>();

  Timer? _debounce;

  final _budgetCubit = getIt<BudgetCubit>();

  @override
  void initState() {
    super.initState();
    _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _budgetCubit.fetch(keyword: keyword);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _budgetCubit.close();
    _keywordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetSignalCubit, int>(
      listener: (context, state) {
        _budgetCubit.refresh();
      },
      child: BlocProvider.value(
        value: _budgetCubit..fetch(keyword: _keywordControl.value),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(bottom: 28),
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
                  child: BlocBuilder<BudgetCubit, BudgetState>(
                    bloc: _budgetCubit,
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
                        loaded: (budgets) {
                          return BudgetList(budgets: budgets);
                        },
                        refreshing: (budgets) {
                          return BudgetList(budgets: budgets);
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
