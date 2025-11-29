import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/models/entity_base_type.dart';
import 'package:dompet/core/models/financial_entity_filter.dart';
import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/widgets/financial_entity_empty.dart';
import 'package:dompet/core/widgets/financial_entity_grid.dart';
import 'package:flutter/material.dart';

class FinancialEntityListSection<T extends FinancialEntityModel,
    F extends EntityBaseType> extends StatelessWidget {
  final List<T> data;
  final FinancialEntityFilter<F> filter;
  final VoidCallback onCreate;
  final void Function(T selected) onTap;
  final ListType listType;

  const FinancialEntityListSection(
      {super.key,
      required this.filter,
      required this.data,
      required this.onCreate,
      required this.onTap,
      this.listType = ListType.filtered});
  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      return FinancialEntityGrid<T>(
        data: data,
        listType: listType,
        onTap: onTap,
        onCreate: onCreate,
      );
    }
    return SingleChildScrollView(
      child: FinancialEntityEmpty(
        onCreate: onCreate,
        filter: filter,
        listType: listType,
      ),
    );
  }
}
