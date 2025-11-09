import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/enum/transaction_static_subject.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transaction/presentation/providers/transaction_flow_provider.dart';
import 'package:dompet/features/wallet/data/wallet_repository.dart';
import 'package:dompet/features/wallet/domain/model/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletProvider extends AsyncNotifier<WalletModel?> {
  @override
  Future<WalletModel?> build() async {
    return ref.read(walletRepositoryProvider).getWallet();
  }

  Future<void> topUp(BuildContext context) async {
    final form = ref.read(transactionFormProvider)
      ..pocket.value = state.value
      ..category.value = Category.topUp
      ..date.value = DateTime.now()
      ..type.value = TransactionType.income;

    final transactionFlow = ref.read(transactionFlowProvider);
    transactionFlow.beginTransaction(
      context,
      selectedPocket: form.pocketValue,
      subject: TransactionStaticSubject.pocket,
    );
  }

  void optimisticUpdateBalance(PocketModel newWalletPocket,
      [bool? isLoading = false]) {
    if (!state.hasValue) return;

    state = AsyncData(state.value!.copyWith(
      balance: newWalletPocket.balance,
      isLoading: isLoading,
    ));
  }

  void optimisticUpdateTotalBalance(
    WalletModel newWalletPocket, [
    bool? isLoading = false,
  ]) {
    if (!state.hasValue) return;

    state = AsyncData(state.value!.copyWith(
      balance: newWalletPocket.balance,
      totalBalance: newWalletPocket.totalBalance,
      isLoading: isLoading,
    ));
  }
}

final walletProvider =
    AsyncNotifierProvider<WalletProvider, WalletModel?>(WalletProvider.new);
