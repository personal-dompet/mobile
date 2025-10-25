import 'package:dio/dio.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_filter_form.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionSource {
  final Dio _dio;

  static final _prefix = '/api/transactions';

  TransactionSource(this._dio);

  Future<List<dynamic>> getTransactions(TransactionFilterForm form) async {
    final response =
        await _dio.get<List<dynamic>>(_prefix, queryParameters: form.json);
    return response.data ?? [];
  }

  Future<List<dynamic>> recentTransactions(TransactionFilterForm form) async {
    final response =
        await _dio.get('$_prefix/recents', queryParameters: form.json);
    if (response.data is List) {
      return response.data as List<dynamic>;
    }
    return [];
  }

  Future<Map<String, dynamic>> create(TransactionForm form) async {
    final response = await _dio.post(_prefix, data: form.json);
    return response.data;
  }
}

final transactionSourceProvider =
    Provider.autoDispose<TransactionSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return TransactionSource(dio);
});
