import 'package:dompet/features/pocket/data/pocket_source.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PocketRepository {
  final PocketSource source;

  _PocketRepository(this.source);

  Future<List<PocketModel>> getPockets() async {
    final data = await source.getPockets();
    return data.map((e) => PocketModel.fromJson(e)).toList();
  }

  Future<PocketModel> create() async {
    final data = await source.create();
    return PocketModel.fromJson(data);
  }

  Future<PocketModel> createSpending() async {
    final data = await source.createSpending();
    return PocketModel.fromJson(data);
  }

  Future<PocketModel> createRecurring() async {
    final data = await source.createRecurring();
    return PocketModel.fromJson(data);
  }

  Future<PocketModel> createSaving() async {
    final data = await source.createSaving();
    return PocketModel.fromJson(data);
  }
}

final pocketRepositoryProvider = Provider.autoDispose<_PocketRepository>((ref) {
  final source = ref.read(pocketSourceProvider);
  return _PocketRepository(source);
});
