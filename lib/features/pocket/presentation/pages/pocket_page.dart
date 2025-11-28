import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/entity_type_selector.dart';
import 'package:dompet/core/widgets/financial_entity_empty.dart';
import 'package:dompet/core/widgets/financial_entity_grid.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/filtered_pocket_list_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_flow_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketPage extends ConsumerWidget {
  const PocketPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pockets = ref.watch(filteredPocketListProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PocketSearchField(),
            ),
            const SizedBox(height: 16),
            EntityTypeSelector<PocketType>(
              types: [
                PocketType.all,
                PocketType.spending,
                PocketType.recurring,
                PocketType.saving,
              ],
              filter: ref.watch(pocketFilterProvider),
              onSelect: (type) {
                ref.read(pocketFilterProvider.notifier).setSelectedType(type);
              },
            ),
            const SizedBox(height: 16),
            if (pockets.isNotEmpty)
              Expanded(
                child: FinancialEntityGrid<PocketModel>(
                  data: pockets,
                  listType: ListType.filtered,
                  onTap: (pocket) {
                    // TODO: Rederect to detail
                  },
                  onCreate: () async {
                    await ref
                        .read(pocketFlowProvider(ListType.filtered))
                        .beginCreate(
                          context,
                        );
                  },
                ),
              ),
            if (pockets.isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: FinancialEntityEmpty(
                    onCreate: () async {
                      await ref
                          .read(pocketFlowProvider(ListType.filtered))
                          .beginCreate(
                            context,
                          );
                    },
                    filter: ref.watch(pocketFilterProvider),
                    listType: ListType.filtered,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PocketListSection extends ConsumerWidget {
  const _PocketListSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
