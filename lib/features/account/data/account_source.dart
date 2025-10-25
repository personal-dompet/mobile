import 'package:dio/dio.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSource {
  final Dio _dio;
  final Ref _ref;

  static final _prefix = '/api/accounts';

  AccountSource(this._ref, this._dio);

  Future<List<dynamic>> getAccounts() async {
    final response = await _dio.get(_prefix);
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> create() async {
    try {
      final form = _ref.read(createAccountFormProvider);
      final response = await _dio.post(_prefix, data: form.json);
      return response.data ?? {};
    } finally {
      _ref.invalidateSelf();
    }
  }

  Future<Map<String, dynamic>> createDetail() async {
    try {
      final accountForm = _ref.read(createAccountFormProvider);
      final detailForm = _ref.read(createAccountDetailFormProvider);
      final response = await _dio.post('$_prefix/detail', data: {
        ...accountForm.json,
        ...detailForm.json,
      });
      return response.data ?? {};
    } finally {
      _ref.invalidateSelf();
    }
  }
}

final accountSourceProvider = Provider<AccountSource>((ref) {
  final dio = ref.read(apiClientProvider);
  return AccountSource(ref, dio);
});
