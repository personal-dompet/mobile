import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:dompet/features/pocket/domain/provider/pocket_provider.dart';
import 'package:dompet/features/transfer/domain/forms/transfer_form.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_card_item.dart';
import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectPocketPage extends ConsumerWidget {
  const SelectPocketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketsAsync = ref.watch(pocketProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Pocket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshWrapper(
        onRefresh: () async => ref.invalidate(pocketProvider),
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
                        // Navigate to pocket creation page
                        final result = await context.push('/pockets/types');
                        if (result != null && context.mounted) {
                          final resultData = await context.push('/pockets/create');
                          if (resultData == null) return;

                          // After creating a pocket, pop back to this page to update the list
                          if (context.mounted) {
                            // Reload pockets after creation
                            ref.invalidate(pocketProvider);
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
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final pocket = data[index];
                        // Check if this pocket is currently selected in the form
                        final currentForm = ModalRoute.of(context)
                            ?.settings
                            .arguments as TransferForm?;
                        final isSelected =
                            currentForm?.fromPocket?.id == pocket.id;

                        return PocketCardItem(
                          pocket: pocket,
                          isSelected: isSelected,
                          onTap: () {
                            // Navigate back with the selected pocket
                            Navigator.of(context)
                                .pop<SimplePocketModel>(pocket);
                          },
                        );
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