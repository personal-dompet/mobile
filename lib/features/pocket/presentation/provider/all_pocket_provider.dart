import 'package:dompet/features/pocket/data/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/create_pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/filtered_pocket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllPocketProvider extends AsyncNotifier<List<PocketModel>> {
  @override
  Future<List<PocketModel>> build() async {
    return await ref
        .read(pocketRepositoryProvider)
        .getPockets(PocketFilterForm());
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(PocketCreateForm form) async {
    final previousState = state.value;
    final newState =
        await ref.read(createPocketProvider).execute(form, previousState);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(filteredPocketProvider);
    }
  }
}

final allPocketProvider =
    AsyncNotifierProvider.autoDispose<AllPocketProvider, List<PocketModel>>(
        AllPocketProvider.new);
