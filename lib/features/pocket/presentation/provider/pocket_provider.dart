import 'package:dompet/features/pocket/data/repositories/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketProvider
    extends FamilyAsyncNotifier<List<SimplePocketModel>?, PocketFilterForm> {
  @override
  Future<List<SimplePocketModel>?> build(PocketFilterForm filter) async {
    return await ref.read(pocketRepositoryProvider).getPockets(filter);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(PocketCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(pocketFilterFormProvider);
    final filterType = filter.type.value;

    if (previousState != null &&
        (filterType == form.type || filterType == PocketType.all)) {
      state = AsyncData([
        SimplePocketModel(
          balance: 0,
          id: -1,
          name: form.name,
          type: form.type!,
          color: form.color!,
          icon: form.icon!,
          priority: 0,
        ),
        ...previousState,
      ]);
    }

    try {
      final result = await ref.read(pocketRepositoryProvider).create(form);

      // Check if the provider is still mounted after the async operation
      if (!ref.mounted) return;

      List<SimplePocketModel> newState = [];
      if (filterType == result.type || filterType == PocketType.all) {
        newState = [result];
      }

      // Check again if still mounted before final state update
      if (!ref.mounted) return;

      state = AsyncData([
        ...newState,
        ...(previousState?.where((pocket) => pocket.id != result.id).toList() ??
            []),
      ]);
    } catch (e) {
      // Check if still mounted before reverting to previous state
      if (ref.mounted) {
        state = AsyncData(previousState);
      }
    }
  }
}

final pocketProvider = AsyncNotifierProvider.autoDispose
    .family<PocketProvider, List<SimplePocketModel>?, PocketFilterForm>(
        PocketProvider.new);
