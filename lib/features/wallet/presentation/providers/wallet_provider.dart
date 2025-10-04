import 'package:dompet/features/account/presentation/provider/all_account_provider.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/wallet/data/wallet_repository.dart';
import 'package:dompet/features/wallet/domain/model/wallet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletProvider extends AsyncNotifier<WalletModel?> {
  @override
  Future<WalletModel?> build() async {
    return ref.read(walletRepositoryProvider).getWallet();
  }

  Future<void> topUp(TopUpForm form) async {
    final previousState = state.value;
    try {
      if (previousState != null) {
        state = AsyncValue.data(previousState.copyWith(
          balance: previousState.balance + form.amountValue,
          totalBalance: previousState.totalBalance + form.amountValue,
        ));
      }
      final wallet = await ref.read(walletRepositoryProvider).topUp(form);
      state = AsyncValue.data(wallet);
      ref.invalidate(allAccountProvider);
    } catch (e) {
      state = AsyncValue.data(previousState);
    }
  }
}

final walletProvider =
    AsyncNotifierProvider<WalletProvider, WalletModel?>(WalletProvider.new);
