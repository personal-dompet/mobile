import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
import 'package:dompet/features/wallet/data/wallet_repository.dart';
import 'package:dompet/features/wallet/domain/model/wallet_model.dart';
import 'package:dompet/routes/select_account_route.dart';
import 'package:dompet/routes/top_up_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletProvider extends AsyncNotifier<WalletModel?> {
  @override
  Future<WalletModel?> build() async {
    return ref.read(walletRepositoryProvider).getWallet();
  }

  Future newTopUp(BuildContext context) async {
    final selectedAccount =
        await SelectAccountRoute().push<AccountModel>(context);

    if (selectedAccount == null || !context.mounted || !state.hasValue) return;

    final form = ref.read(transactionFormProvider)
      ..pocket.value = state.value
      ..category.value = Category.topUp
      ..type.value = TransactionType.income
      ..account.value = selectedAccount;

    final topUpForm = await TopUpRoute().push<TopUpForm>(context);

    if (topUpForm == null) {
      ref.invalidate(transactionFormProvider);
      return;
    }

    form
      ..amount.value = topUpForm.amountValue
      ..description.value = topUpForm.descriptionValue
      ..date.value = topUpForm.dateValue;

    final newWallet = state.value!.copyWith(
      balance: state.value!.balance + (form.amountValue ?? 0),
      totalBalance: state.value!.totalBalance + (form.amountValue ?? 0),
    );
    final newAccount = form.accountValue!
        .copyWith(balance: form.accountValue!.balance + form.amountValue!);

    final accountListNotifier = ref.read(accountListProvider.notifier);
    final recentTransactionNotifier =
        ref.read(recentTransactionProvider.notifier);

    optimisticUpdateBalance(newWallet);
    optimisticUpdateTotalBalance(newWallet.totalBalance);
    accountListNotifier.optimisticUpdate(newAccount);
    recentTransactionNotifier.optimisticCreate(
      TransactionDetailModel.placeholder(
        amount: form.amountValue,
        category: form.categoryValue,
        date: form.dateValue,
        description: form.descriptionValue,
        type: form.typeValue,
      ),
    );
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
      ref.invalidate(accountListProvider);
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
