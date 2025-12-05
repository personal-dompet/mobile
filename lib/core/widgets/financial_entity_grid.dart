import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/widgets/add_entity_card.dart';
import 'package:dompet/core/widgets/financial_entity_card.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancialEntityGrid<T extends FinancialEntityModel>
    extends ConsumerWidget {
  final List<T> data;
  final int? selectedId;
  final T? source;
  final T? destination;
  final void Function(T entity) onTap;
  final void Function() onCreate;
  final ListType listType;
  final bool disableEmpty;

  const FinancialEntityGrid({
    super.key,
    this.data = const [],
    this.selectedId,
    required this.onTap,
    required this.onCreate,
    this.destination,
    this.source,
    this.listType = ListType.filtered,
    this.disableEmpty = false,
  });

  int get _itemCount => disableEmpty ? data.length : data.length + 1;
  String get _addButtonLabel =>
      data is PocketModel ? 'Add Pocket' : 'Add Account';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        if (index == data.length && !disableEmpty) {
          return AddEntityCard(
            onTap: onCreate,
            label: _addButtonLabel,
          );
        }
        final entity = data[index];
        TransferStaticSubject? transferRole;

        debugPrint('Destination ID: ${destination?.id}');
        debugPrint('Source ID: ${source?.id}');
        debugPrint('Entity ID: ${entity.id}');

        if (entity.id == source?.id) {
          transferRole = TransferStaticSubject.source;
        }
        if (entity.id == destination?.id) {
          transferRole = TransferStaticSubject.destination;
        }

        debugPrint('${entity.name}: ${transferRole?.name}');

        final isSelected = entity.id == selectedId;

        return FinancialEntityCard(
          item: entity,
          transferRole: transferRole,
          isSelected: isSelected,
          isDisabled: disableEmpty,
          onTap: () => onTap(entity),
        );
      },
    );
  }
}
