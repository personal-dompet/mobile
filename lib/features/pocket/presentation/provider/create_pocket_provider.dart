import 'package:dompet/features/pocket/data/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePocketProvider {
  final PocketRepository _repository;

  CreatePocketProvider(this._repository);

  Future<List<PocketModel>> execute(
    PocketCreateForm form,
    List<PocketModel>? previousState, [
    PocketFilterForm? filter,
  ]) async {
    final filterType = filter?.type.value ?? PocketType.all;

    List<PocketModel> newState = previousState ?? [];

    if (previousState != null &&
        (filterType == form.type || filterType == PocketType.all)) {
      newState = [
        PocketModel.placeholder(
          balance: 0,
          name: form.name,
          type: form.type!,
          color: form.color!,
          icon: form.icon,
          priority: 0,
        ),
        ...previousState,
      ];
    }

    try {
      final result = await _repository.create(form);

      List<PocketModel> updatedState = [];
      if (filterType == result.type || filterType == PocketType.all) {
        updatedState = [result];
      }

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
}

final createPocketProvider = Provider.autoDispose<CreatePocketProvider>((ref) {
  return CreatePocketProvider(ref.read(pocketRepositoryProvider));
});
