import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/transaction/data/transaction_repository.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TranscationLogicService {
  final Ref _ref;

  _TranscationLogicService(this._ref);

  Future create(TransactionForm request) async {
    final recentTransaction =
        await _ref.read(recentTransactionProvider.selectAsync((list) => list));
    final wallet = await _ref.read(walletProvider.selectAsync((data) => data));

    if (wallet == null) return;

    final relativeAmount = request.amountValue! *
        (request.typeValue! == TransactionType.income ? 1 : -1);

    final newPocket = request.pocketValue!.copyWith(
      balance: request.pocketValue!.balance + relativeAmount,
    );

    final newAccount = request.accountValue!.copyWith(
      balance: request.accountValue!.balance + relativeAmount,
    );

    final newWallet = wallet.copyWith(
      totalBalance: wallet.totalBalance + relativeAmount,
      balance: newPocket.type == PocketType.wallet
          ? newPocket.balance
          : wallet.balance,
    );

    final recentTransactionNotifier =
        _ref.read(recentTransactionProvider.notifier);

    final accountListNotifier = _ref.read(accountListProvider.notifier);
    final walletNotifier = _ref.read(walletProvider.notifier);
    final pocketListNotifier = _ref.read(pocketListProvider.notifier);

    accountListNotifier.optimisticUpdate(newAccount);
    pocketListNotifier.optimisticUpdate(newPocket);
    walletNotifier.optimisticUpdateTotalBalance(newWallet, true);
    walletNotifier.optimisticUpdateBalance(newWallet, true);
    recentTransactionNotifier
        .optimisticCreate(TransactionDetailModel.placeholder(
      amount: request.amountValue,
      category: request.categoryValue,
      date: request.dateValue,
      description: request.descriptionValue,
      type: request.typeValue,
      account: newAccount,
      pocket: newPocket,
      wallet: newWallet,
    ));

    try {
      final newState =
          await _ref.read(transactionRepositoryProvider).create(request);
      accountListNotifier.optimisticUpdate(newState.account);
      pocketListNotifier.optimisticUpdate(newState.pocket);
      walletNotifier.optimisticUpdateTotalBalance(newState.wallet);
      walletNotifier.optimisticUpdateBalance(newState.wallet);
      recentTransactionNotifier.optimisticCreate(newState);
    } catch (e) {
      accountListNotifier.optimisticUpdate(request.accountValue!);
      pocketListNotifier.optimisticUpdate(request.pocketValue!);
      walletNotifier.optimisticUpdateTotalBalance(wallet);
      walletNotifier.optimisticUpdateBalance(wallet);
      recentTransactionNotifier.revertCreate(recentTransaction);
    }
  }
}

final transactionLogicProvider = Provider.autoDispose<_TranscationLogicService>(
  (ref) => _TranscationLogicService(ref),
);
