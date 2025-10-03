import 'package:dompet/features/pocket/data/pocket_source.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketRepository {
  final PocketSource _source;

  PocketRepository(this._source);

  Future<List<PocketModel>> getPockets(PocketFilterForm form) async {
    final data = await _source.getPockets(form);
    debugPrint('PocketRepository: $data');
    return data.map((e) => PocketModel.fromJson(e)).toList();
  }

  Future<PocketModel> create(PocketCreateForm form) async {
    final data = await _source.create(form);
    return PocketModel.fromJson(data);
  }
}

final pocketRepositoryProvider = Provider.autoDispose<PocketRepository>((ref) {
  final source = ref.read(pocketSourceProvider);
  return PocketRepository(source);
});
