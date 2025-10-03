import 'package:dio/dio.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketSource {
  final Dio _dio;

  static final _prefix = '/api/pockets';

  PocketSource(this._dio);

  Future<List<dynamic>> getPockets(PocketFilterForm form) async {
    final response = await _dio.get(_prefix, queryParameters: form.toJson());
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> create(PocketCreateForm form) async {
    final response = await _dio.post(_prefix, data: form.toJson());
    return response.data ?? {};
  }
}

final pocketSourceProvider = Provider.autoDispose<PocketSource>((ref) {
  final dio = ref.read(apiClientProvider);
  return PocketSource(dio);
});
