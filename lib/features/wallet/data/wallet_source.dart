import 'package:dio/dio.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletSource {
  final Dio _dio;

  static final _prefix = '/api/wallets';

  WalletSource(this._dio);

  Future<Map<String, dynamic>?> getWallet() async {
    final response =
        await _dio.get<Map<String, dynamic>>(_prefix, queryParameters: {
      'color': AppTheme.primaryColor
          .toARGB32()
          .toRadixString(16)
          .substring(2)
          .padLeft(6, '0')
    });
    return response.data;
  }

  Future<Map<String, dynamic>?> topUp(TopUpForm form) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_prefix/top-up',
      data: form.json,
    );
    return response.data;
  }
}

final walletSourceProvider = Provider.autoDispose<WalletSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return WalletSource(dio);
});
