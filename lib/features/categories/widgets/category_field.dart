import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/features/categories/utils/open_expense_account_selector.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CategoryField extends StatefulWidget {
  final FormControl<int> valueControl;
  final FormControl<String> nameControl;
  final TransactionType type;
  final bool required;
  final bool readOnly;
  final bool withBudget;
  const CategoryField({
    super.key,
    required this.valueControl,
    required this.nameControl,
    required this.type,
    this.required = false,
    this.readOnly = false,
    this.withBudget = false,
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
        if (focusNode.hasFocus && !widget.readOnly) {
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

    final result = await openCategorySelector(
      context,
      type: widget.type,
      selectedId: widget.valueControl.value,
      withBudget: widget.withBudget,
    );
    if (!context.mounted || result == null) return;

    widget.valueControl.updateValue(result.account.id);
    widget.nameControl.updateValue(result.account.name);
  }

  @override
  Widget build(BuildContext context) {
    return DompetTextField(
      key: widget.key,
      label: 'Pilih Kategori${widget.required ? '' : ' (Opsional)'}',
      formControl: widget.nameControl,
      readOnly: true,
      suffixIcon: widget.readOnly ? null : Icon(Icons.chevron_right_rounded),
      hidePrefixOnEmpty: true,
      focusNode: focusNode,
    );
  }
}
