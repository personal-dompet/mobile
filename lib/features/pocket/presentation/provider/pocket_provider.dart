import 'package:dompet/features/pocket/data/repositories/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Reusable function for creating pockets
Future<List<SimplePocketModel>> _createPocket(
  Ref ref,
  PocketCreateForm form,
  List<SimplePocketModel>? previousState, [
  PocketFilterForm? filter,
]) async {
  final filterType = filter?.type.value ?? PocketType.all;

  // Check if mounted before processing
  if (!ref.mounted) return previousState ?? [];

  List<SimplePocketModel> newState = previousState ?? [];

  if (previousState != null &&
      (filterType == form.type || filterType == PocketType.all)) {
    newState = [
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
    ];
  }

  try {
    final result = await ref.read(pocketRepositoryProvider).create(form);

    // Check if the provider is still mounted after the async operation
    if (!ref.mounted) return previousState ?? [];

    List<SimplePocketModel> updatedState = [];
    if (filterType == result.type || filterType == PocketType.all) {
      updatedState = [result];
    }

    // Check again if still mounted before final state update
    if (!ref.mounted) return previousState ?? [];

    newState = [
      ...updatedState,
      ...(previousState?.where((pocket) => pocket.id != result.id).toList() ??
          []),
    ];
  } catch (e) {
    // Return previous state if there's an error
    return previousState ?? [];
  }

  return newState;
}

class FilteredPocketProvider extends AsyncNotifier<List<SimplePocketModel>?> {
  @override
  Future<List<SimplePocketModel>?> build() async {
    final filter = ref.read(pocketFilterFormProvider);
    return await ref.read(pocketRepositoryProvider).getPockets(filter);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(PocketCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(pocketFilterFormProvider);
    final newState = await _createPocket(ref, form, previousState, filter);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(pocketListProvider);
    }
  }
}

class PocketListProvider extends AsyncNotifier<List<SimplePocketModel>?> {
  @override
  Future<List<SimplePocketModel>?> build() async {
    return await ref
        .read(pocketRepositoryProvider)
        .getPockets(PocketFilterForm());
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(PocketCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(pocketFilterFormProvider);
    final newState = await _createPocket(ref, form, previousState, filter);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(filteredPocketProvider);
    }
  }
}

final pocketListProvider =
    AsyncNotifierProvider<PocketListProvider, List<SimplePocketModel>?>(
        PocketListProvider.new);

final filteredPocketProvider =
    AsyncNotifierProvider<FilteredPocketProvider, List<SimplePocketModel>?>(
        FilteredPocketProvider.new);
