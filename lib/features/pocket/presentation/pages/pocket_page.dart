import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/pocket/presentation/provider/filtered_pocket_list_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_empty_list.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_grid.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_search_field.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector.dart';
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
            PocketTypeSelector(),
            const SizedBox(height: 16),
            if (pockets.isNotEmpty)
              Expanded(
                child: PocketGrid(
                  data: pockets,
                  listType: ListType.filtered,
                  onTap: (pocket) {},
                ),
              ),
            if (pockets.isEmpty)
              Expanded(
                child: SingleChildScrollView(
                    child: PocketEmptyList(
                  listType: ListType.filtered,
                )),
              ),
          ],
        ),
      ),
    );
  }
}
