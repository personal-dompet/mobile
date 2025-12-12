import 'package:dompet/features/pocket/data/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/domain/model/saving_pocket_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final detailPocketProvider =
    FutureProvider.autoDispose.family<PocketModel, int>(
  (Ref ref, int id) async {
    final repository = ref.read(pocketRepositoryProvider);
    final pocket = await repository.detail(id);
    debugPrint('${pocket.type == PocketType.saving}');
    if (pocket.type == PocketType.saving) {
      debugPrint((pocket as SavingPocketModel).targetDescription);
    }
    return pocket;
  },
);
