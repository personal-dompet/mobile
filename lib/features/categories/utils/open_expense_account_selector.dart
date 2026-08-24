import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/widgets/category_selector.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<void> openCategorySelector(
  BuildContext context, {
  required TransactionType type,
  required FormControl<int> idControl,
  required FormControl<String> nameControl,
}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => getIt<CategoryCubit>()..fetch(type: type),
          child: CategorySelector(
            idControl: idControl,
            nameControl: nameControl,
            type: type,
          ),
        );
      },
    ),
  );
}
