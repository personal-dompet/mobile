import 'package:dompet/features/pocket/data/sources/pocket_source.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketRepository {
  final PocketSource _source;

  PocketRepository(this._source);

  Future<List<SimplePocketModel>> getPockets(PocketFilterForm form) async {
    final data = await _source.getPockets(form);
    return data.map((e) => SimplePocketModel.fromJson(e)).toList();
  }

  Future<SimplePocketModel> create(PocketCreateForm form) async {
    final data = await _source.create(form);
    return SimplePocketModel.fromJson(data);
  }
}

final pocketRepositoryProvider = Provider.autoDispose<PocketRepository>((ref) {
  final source = ref.read(pocketSourceProvider);
  return PocketRepository(source);
});
