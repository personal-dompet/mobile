import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/provider/pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/add_pocket_card_item.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_card_item.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_empty_list.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_search_field.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector.dart';
import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PocketPage extends ConsumerWidget {
  const PocketPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketsAsync = ref.watch(pocketProvider);
    return Scaffold(
      body: RefreshWrapper(
        onRefresh: () => ref.read(pocketProvider.notifier).refresh(),
        child: pocketsAsync.when(
          data: (data) {
            return Padding(
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
                  if (data != null && data.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount:
                            data.length + 1, // Add 1 for the "Add Pocket" card
                        itemBuilder: (context, index) {
                          // If this is the last item, show the "Add Pocket" card
                          if (index == data.length) {
                            return AddPocketCardItem(
                              onTap: () async {
                                final result = await context
                                    .push<PocketType?>('/pockets/types');
                                if (result != null && context.mounted) {
                                  final form =
                                      ref.read(pocketCreateFormProvider);
                                  final typeControl = form.typeControl;
                                  typeControl.value = result;
                                  final resultData =
                                      await context.push<PocketCreateForm>(
                                          '/pockets/create');
                                  if (resultData == null) return;

                                  ref
                                      .read(pocketProvider.notifier)
                                      .create(resultData);
                                }
                              },
                            );
                          }
                          // Otherwise, show the regular pocket card
                          final pocket = data[index];
                          return PocketCardItem(pocket: pocket);
                        },
                      ),
                    ),
                  if (data == null || data.isEmpty)
                    Expanded(
                      child: SingleChildScrollView(child: PocketEmptyList()),
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(
            strokeWidth: 1,
          )),
          error: (error, stack) => Center(
            child: Text('Error loading transactions: $error'),
          ),
        ),
      ),
    );
  }
}
