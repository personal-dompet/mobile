import 'package:dompet/features/pocket/data/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/all_pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/create_pocket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilteredPocketProvider extends AsyncNotifier<List<PocketModel>> {
  @override
  Future<List<PocketModel>> build() async {
    final filter = ref.read(pocketFilterFormProvider);
    return await ref.read(pocketRepositoryProvider).getPockets(filter);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(PocketCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(pocketFilterFormProvider);
    final newState = await ref
        .read(createPocketProvider)
        .execute(form, previousState, filter);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(allPocketProvider);
    }
  }
}

final filteredPocketProvider = AsyncNotifierProvider.autoDispose<
    FilteredPocketProvider, List<PocketModel>>(FilteredPocketProvider.new);
