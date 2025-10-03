import 'package:dio/dio.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionSource {
  final Dio _dio;

  static final _prefix = '/api/transactions';

  TransactionSource(this._dio);

  Future<Map<String, dynamic>> getTransactions() async {
    final response = await _dio.get<Map<String, dynamic>>(_prefix);
    return response.data ?? {};
  }

  Future<List<dynamic>> recentTransactions() async {
    final response = await _dio.get('$_prefix/recents');
    if (response.data is List) {
      return response.data as List<dynamic>;
    }
    return [];
  }
}

final transactionSourceProvider =
    Provider.autoDispose<TransactionSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return TransactionSource(dio);
});
