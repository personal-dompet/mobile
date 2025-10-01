import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_grid.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectPocketPage extends ConsumerWidget {
  final int? selectedPocketId;
  final SelectPocketTitle title;
  const SelectPocketPage(
      {super.key,
      this.selectedPocketId,
      this.title = SelectPocketTitle.general});

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
            if (data == null || data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wallet_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No pockets available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Show pocket type selection bottom sheet
                        final result = await showModalBottomSheet<PocketType>(
                          context: context,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          builder: (context) =>
                              const PocketTypeSelectorBottomSheet(),
                        );
                        if (result != null && context.mounted) {
                          final form = ref.read(pocketCreateFormProvider);
                          form.typeControl.value = result;

                          final resultData = await context
                              .push<PocketCreateForm>('/pockets/create');
                          if (resultData == null) return;

                          // Use a filter form to call create method
                          await ref
                              .read(pocketListProvider.notifier)
                              .create(resultData);

                          // After creating a pocket, pop back to this page to update the list
                          if (context.mounted) {
                            // Reload pockets after creation
                            ref.invalidate(pocketListProvider);
                          }
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Pocket'),
                    ),
                  ],
                ),
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
                      onTap: (pocket) {
                        // Navigate back with the selected pocket
                        Navigator.of(context).pop<SimplePocketModel>(pocket);
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
