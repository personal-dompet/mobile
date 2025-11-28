import 'package:dompet/core/models/entity_base_type.dart';
import 'package:dompet/core/models/financial_entity_filter.dart';
import 'package:dompet/core/widgets/entity_type_selector_item.dart';
import 'package:flutter/material.dart';

class EntityTypeSelector<T extends EntityBaseType> extends StatelessWidget {
  final FinancialEntityFilter<T> filter;
  final ValueChanged<T> onSelect;
  final List<T> types;

  const EntityTypeSelector({
    super.key,
    required this.types,
    required this.filter,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          return EntityTypeSelectorItem(
            displayName: type.displayName,
            color: type.color,
            isSelected: type == filter.type,
            onPressed: () {
              onSelect(type);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 4),
      ),
    );
  }
}
