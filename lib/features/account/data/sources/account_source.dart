import 'package:dio/dio.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSource {
  final Dio _dio;

  static final _prefix = '/api/accounts';

  AccountSource(this._dio);

  Future<List<dynamic>> getAccounts(AccountFilterForm form) async {
    final response = await _dio.get(_prefix, queryParameters: form.toJson());
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> create(AccountCreateForm form) async {
    final response = await _dio.post(_prefix, data: form.toJson());
    return response.data ?? {};
  }
}

final accountSourceProvider = Provider.autoDispose<AccountSource>((ref) {
  final dio = ref.read(apiClientProvider);
  return AccountSource(dio);
});