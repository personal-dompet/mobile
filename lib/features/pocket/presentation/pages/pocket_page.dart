import 'package:auto_route/auto_route.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/entity_type_selector.dart';
import 'package:dompet/core/widgets/financial_entity_list_section.dart';
import 'package:dompet/core/widgets/financial_entity_page.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/presentation/provider/filtered_pocket_list_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_flow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class PocketPage extends StatelessWidget {
  const PocketPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FinancialEntityPage(
      typeSelector: _PocketTypeSelector(),
      onSearch: ({keyword}) {
        final ref = ProviderScope.containerOf(context);
        final filter = ref.read(pocketFilterProvider.notifier);
        filter.setSearchKeyword(keyword);
      },
      child: _PocketListSection(),
    );
  }
}

class _PocketTypeSelector extends ConsumerWidget {
  const _PocketTypeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(pocketFilterProvider);
    return EntityTypeSelector<PocketType>(
      types: [
        PocketType.all,
        PocketType.spending,
        PocketType.recurring,
        PocketType.saving,
      ],
      filter: filter,
      onSelect: (type) {
        ref.read(pocketFilterProvider.notifier).setSelectedType(type);
      },
    );
  }
}

class _PocketListSection extends ConsumerWidget {
  const _PocketListSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pockets = ref.watch(filteredPocketListProvider);
    final filter = ref.watch(pocketFilterProvider);

    return FinancialEntityListSection(
      filter: filter,
      data: pockets,
      onCreate: () async {
        await ref
            .read(
              pocketFlowProvider(ListType.filtered),
            )
            .beginCreate(
              context,
            );
      },
      onTap: (selected) {
        // TODO: To detail page
      },
    );
  }
}
