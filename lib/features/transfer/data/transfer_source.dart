import 'package:dio/dio.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_filter_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferSource {
  final Dio _dio;

  static final _prefix = '/api/transfers';

  TransferSource(this._dio);

  Future<List<dynamic>> pocketTransfers(PocketTransferFilterForm form) async {
    final response = await _dio.get<List<dynamic>>(
      '$_prefix/pockets',
      queryParameters: form.json,
    );
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> pocketTransfer(
      PocketTransferForm request) async {
    final response = await _dio.post<Map<String, dynamic>>('$_prefix/pockets',
        data: request.json);
    return response.data ?? {};
  }
}

final transferSourceProvider = Provider.autoDispose<TransferSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return TransferSource(dio);
});
