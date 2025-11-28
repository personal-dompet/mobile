import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/widgets/financial_entity_empty.dart';
import 'package:dompet/core/widgets/financial_entity_grid.dart';
import 'package:flutter/material.dart';

class FinancialEntityListSection<T extends FinancialEntityModel>
    extends StatelessWidget {
  final List<T> data;
  final VoidCallback onCreate;
  final void Function(T selected) onTap;

  const FinancialEntityListSection({
    super.key,
    required this.data,
    required this.onCreate,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      return FinancialEntityGrid<T>(
        data: data,
        listType: ListType.filtered,
        onTap: onTap,
        onCreate: onCreate,
      );
    }
    // return SingleChildScrollView(
    //   child: FinancialEntityEmpty(
    //     onCreate: onCreate,
    //     filter: ref.watch(pocketFilterProvider),
    //     listType: ListType.filtered,
    //   ),
    // );
    return Container();
  }
}
