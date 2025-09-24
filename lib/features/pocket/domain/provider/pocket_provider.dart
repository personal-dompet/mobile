import 'package:dompet/features/pocket/data/repositories/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketProvider extends AsyncNotifier<List<SimplePocketModel>?> {
  @override
  Future<List<SimplePocketModel>?> build() async {
    final form = ref.watch(pocketFilterFormProvider);
    return await ref.read(pocketRepositoryProvider).getPockets(form);
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
      if (filterType == result.type || filterType == PocketType.all) {
        state = AsyncData([result]);
      }
      state = AsyncData([
        ...state.value ?? [],
        ...previousState ?? [],
      ]);
    } catch (e) {
      state = AsyncData(previousState);
    }
  }
}

final pocketProvider =
    AsyncNotifierProvider<PocketProvider, List<SimplePocketModel>?>(
        PocketProvider.new);
