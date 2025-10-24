import 'package:dio/dio.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSource {
  final Dio _dio;

  static final _prefix = '/api/accounts';

  AccountSource(this._dio);

  Future<List<dynamic>> getAccounts() async {
    final response = await _dio.get(_prefix);
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> create(CreateAccountForm form) async {
    final response = await _dio.post(_prefix, data: form.json);
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> createDetail(
      CreateAccountForm form, CreateAccountDetailForm detailForm) async {
    final response = await _dio
        .post('$_prefix/detail', data: {...form.json, ...detailForm.json});
    return response.data ?? {};
  }
}

final accountSourceProvider = Provider.autoDispose<AccountSource>((ref) {
  final dio = ref.read(apiClientProvider);
  return AccountSource(dio);
});
