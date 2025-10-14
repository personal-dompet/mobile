import 'package:dompet/features/pocket/data/pocket_source.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_recurring_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_saving_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketRepository {
  final PocketSource _source;

  PocketRepository(this._source);

  Future<List<PocketModel>> getPockets() async {
    final data = await _source.getPockets();
    return data.map((e) => PocketModel.fromJson(e)).toList();
  }

  Future<PocketModel> create(CreatePocketForm form) async {
    final data = await _source.create(form);
    return PocketModel.fromJson(data);
  }

  Future<PocketModel> createSpending(
      CreatePocketForm form, CreateSpendingPocketForm spendingForm) async {
    final data = await _source.createSpending(form, spendingForm);
    return PocketModel.fromJson(data);
  }

  Future<PocketModel> createRecurring(
      CreatePocketForm form, CreateRecurringPocketForm recurringForm) async {
    final data = await _source.createRecurring(form, recurringForm);
    return PocketModel.fromJson(data);
  }

  Future<PocketModel> createSaving(
      CreatePocketForm form, CreateSavingPocketForm savingForm) async {
    final data = await _source.createSaving(form, savingForm);
    return PocketModel.fromJson(data);
  }
}

final pocketRepositoryProvider = Provider.autoDispose<PocketRepository>((ref) {
  final source = ref.read(pocketSourceProvider);
  return PocketRepository(source);
});
