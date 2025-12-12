import 'package:dompet/features/pocket/data/pocket_source.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/domain/model/recurring_pocket_model.dart';
import 'package:dompet/features/pocket/domain/model/saving_pocket_model.dart';
import 'package:dompet/features/pocket/domain/model/spending_pocket_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PocketRepository {
  final PocketSource source;

  _PocketRepository(this.source);

  Future<List<PocketModel>> getPockets() async {
    final data = await source.getPockets();
    return data.map((e) {
      final pocket = PocketModel.fromJson(e);

      if (pocket.type == PocketType.recurring) {
        return RecurringPocketModel.fromJson(e);
      }

      if (pocket.type == PocketType.saving) {
        return SavingPocketModel.fromJson(e);
      }

      if (pocket.type == PocketType.spending) {
        return SpendingPocketModel.fromJson(e);
      }

      return pocket;
    }).toList();
  }

  Future<PocketModel> detail(int id) async {
    final data = await source.detail(id);
    final pocket = PocketModel.fromJson(data);

    if (pocket.type == PocketType.recurring) {
      return RecurringPocketModel.fromJson(data);
    }

    if (pocket.type == PocketType.saving) {
      return SavingPocketModel.fromJson(data);
    }

    if (pocket.type == PocketType.spending) {
      return SpendingPocketModel.fromJson(data);
    }

    return pocket;
  }

  Future<PocketModel> create() async {
    final data = await source.create();
    return PocketModel.fromJson(data);
  }

  Future<SpendingPocketModel> createSpending() async {
    final data = await source.createSpending();
    return SpendingPocketModel.fromJson(data);
  }

  Future<RecurringPocketModel> createRecurring() async {
    final data = await source.createRecurring();
    return RecurringPocketModel.fromJson(data);
  }

  Future<SavingPocketModel> createSaving() async {
    final data = await source.createSaving();
    return SavingPocketModel.fromJson(data);
  }
}

final pocketRepositoryProvider = Provider.autoDispose<_PocketRepository>((ref) {
  final source = ref.read(pocketSourceProvider);
  return _PocketRepository(source);
});
