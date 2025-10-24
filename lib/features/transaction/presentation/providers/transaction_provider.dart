import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/transaction/data/transaction_repository.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
import 'package:dompet/features/wallet/data/wallet_repository.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TranscationService {
  final Ref _ref;

  _TranscationService(this._ref);

  Future topUp(TopUpForm request) async {
    final recentTransaction =
        await _ref.read(recentTransactionProvider.selectAsync((list) => list));
    final wallet = await _ref.read(walletProvider.selectAsync((data) => data));

    if (wallet == null) return;

    final newWallet = wallet.copyWith(
      totalBalance: request.amountValue + wallet.totalBalance,
      balance: request.amountValue + wallet.balance,
    );

    final newAccount = request.accountValue
        .copyWith(balance: request.amountValue + request.accountValue.balance);

    final recentTransactionNotifier =
        _ref.read(recentTransactionProvider.notifier);

    final accountListNotifier = _ref.read(accountListProvider.notifier);
    final walletNotifier = _ref.read(walletProvider.notifier);

    accountListNotifier.optimisticUpdate(newAccount);
    walletNotifier.optimisticUpdateBalance(newWallet, true);
    walletNotifier.optimisticUpdateTotalBalance(newWallet.totalBalance, true);

    try {
      final newState = await _ref.read(walletRepositoryProvider).topUp(request);

      // accountListNotifier.optimisticUpdate(newState);
      // walletNotifier.optimisticUpdateBalance(newWallet, true);
      // walletNotifier.optimisticUpdateTotalBalance(newWallet.totalBalance, true);
    } catch (e) {
      print(e);
    }
  }
}
