import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_empty_list.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_grid.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_search_field.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector.dart';
import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketPage extends ConsumerWidget {
  const PocketPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(pocketFilterFormProvider);
    final pocketsAsync = ref.watch(pocketProvider(filter));
    return Scaffold(
      body: RefreshWrapper(
        onRefresh: () => ref.read(pocketProvider(filter).notifier).refresh(),
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
                      child: PocketGrid(
                        data: data,
                        onTap: (pocket) {},
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
