import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_empty_list.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectPocketPage extends ConsumerWidget {
  final int? selectedPocketId;
  final SelectPocketTitle title;
  const SelectPocketPage({
    super.key,
    this.selectedPocketId,
    this.title = SelectPocketTitle.general,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketsAsync = ref.watch(pocketListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title.label),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshWrapper(
        onRefresh: () async {
          // Refresh the provider data
          ref.invalidate(pocketListProvider);
        },
        child: pocketsAsync.when(
          data: (data) {
            if (data.isEmpty) {
              return PocketEmptyList(
                listType: ListType.all,
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Expanded(
                    child: PocketGrid(
                      data: data,
                      selectedPocketId: selectedPocketId,
                      listType: ListType.all,
                      onTap: (pocket) {
                        // Navigate back with the selected pocket
                        Navigator.of(context).pop<PocketModel>(pocket);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading pockets: $error'),
          ),
        ),
      ),
    );
  }
}

enum SelectPocketTitle {
  destination('destination', 'Select Destination Pocket'),
  origin('origin', 'Select Origin Pocket'),
  general('general', 'Select Pocket');

  final String value;
  final String label;

  const SelectPocketTitle(this.value, this.label);

  static SelectPocketTitle? fromValue(String value) {
    try {
      return SelectPocketTitle.values.firstWhere(
        (status) => status.value.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
