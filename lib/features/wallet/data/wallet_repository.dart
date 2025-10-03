import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/wallet/data/wallet_source.dart';
import 'package:dompet/features/wallet/domain/model/wallet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletRepository {
  final WalletSource _source;
  WalletRepository(this._source);

  Future<WalletModel?> getWallet() async {
    final response = await _source.getWallet();
    if (response == null) return null;
    return WalletModel.fromJson(response);
  }

  Future<WalletModel?> topUp(TopUpForm form) async {
    final response = await _source.topUp(form);
    if (response == null) return null;
    return WalletModel.fromJson(response);
  }
}

final walletRepositoryProvider = Provider.autoDispose<WalletRepository>((ref) {
  final source = ref.watch(walletSourceProvider);
  return WalletRepository(source);
});
