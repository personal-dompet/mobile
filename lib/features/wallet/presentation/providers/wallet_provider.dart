import 'package:dompet/features/account/presentation/provider/all_account_provider.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/wallet/data/wallet_repository.dart';
import 'package:dompet/features/wallet/domain/model/wallet_model.dart';
import 'package:flutter/widgets.dart';
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

  void optimisticUpdateBalance(PocketModel newWalletPocket,
      [bool? isLoading = false]) {
    if (!state.hasValue) return;

    state = AsyncData(state.value!.copyWith(
      balance: newWalletPocket.balance,
      isLoading: isLoading,
    ));
    debugPrint(state.value?.isLoading.toString());
  }

  void optimisticUpdateTotalBalance(int newTotalBalance, [bool? isLoading]) {
    if (!state.hasValue) return;

    state = AsyncData(state.value!.copyWith(
      totalBalance: newTotalBalance + state.value!.totalBalance,
      isLoading: isLoading,
    ));
  }
}

final walletProvider =
    AsyncNotifierProvider<WalletProvider, WalletModel?>(WalletProvider.new);
