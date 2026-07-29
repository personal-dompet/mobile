import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/widgets/category_selector.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CategoryField extends StatefulWidget {
  final FormControl<int> valueControl;
  final FormControl<String> nameControl;
  final TransactionType type;
  const CategoryField({
    super.key,
    required this.valueControl,
    required this.nameControl,
    required this.type,
  });

  @override
  State<CategoryField> createState() => _CategoryFieldState();
}

class _CategoryFieldState extends State<CategoryField> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          _openExpenseAccountSelector(context);
        }
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _openExpenseAccountSelector(BuildContext context) async {
    widget.valueControl.unfocus();
    widget.nameControl.unfocus();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) =>
                getIt<CategoryCubit>()..fetch(type: widget.type),
            child: CategorySelector(
              idControl: widget.valueControl,
              nameControl: widget.nameControl,
              type: widget.type,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DompetTextField(
      key: widget.key,
      label: 'Pilih Kategori (Opsional)',
      formControl: widget.nameControl,
      readOnly: true,
      suffixIcon: Icon(Icons.chevron_right_rounded),
      hidePrefixOnEmpty: true,
      focusNode: focusNode,
    );
  }
}
