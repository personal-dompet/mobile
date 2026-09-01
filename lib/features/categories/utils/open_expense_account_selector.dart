import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/widgets/category_selector.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<({Account account, bool hasPlan})?> openCategorySelector(
  BuildContext context, {
  required TransactionType type,
  int? selectedId,
  bool withBudget = false,
}) async {
  return await Navigator.push<({Account account, bool hasPlan})>(
    context,
    MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              getIt<CategoryCubit>()..fetch(type: type, withBudget: withBudget),
          child: CategorySelector(
            type: type,
            selectedId: selectedId,
            withBudget: withBudget,
          ),
        );
      },
    ),
  );
}
