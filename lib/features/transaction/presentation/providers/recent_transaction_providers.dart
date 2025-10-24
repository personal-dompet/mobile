import 'dart:async';

import 'package:dompet/features/transaction/data/transaction_repository.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_filter_form.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _RecentTansactionNotifier
    extends AsyncNotifier<List<TransactionDetailModel>> {
  @override
  FutureOr<List<TransactionDetailModel>> build() {
    final repository = ref.read(transactionRepositoryProvider);
    final form = TransactionFilterForm()
      ..page.value = 1
      ..limit.value = 5;
    return repository.getTransactions(form);
  }

  void optimisticCreate(TransactionDetailModel newTransaction,
      [int? placeholderId]) {
    if (!state.hasValue) return;

    final currentState = [...state.value!];

    if (newTransaction.id > 0) {
      state = AsyncData(currentState.map((transaction) {
        return transaction.id == placeholderId ? newTransaction : transaction;
      }).toList());
      return;
    }

    if (currentState.length >= 5 && newTransaction.id < 0) {
      currentState.removeLast();
    }

    state = AsyncData([newTransaction, ...currentState]);
  }

  void revertCreate(List<TransactionDetailModel> previousTransactions) {
    state = AsyncData(previousTransactions);
  }
}

final recentTransactionProvider = AsyncNotifierProvider<
    _RecentTansactionNotifier,
    List<TransactionDetailModel>>(_RecentTansactionNotifier.new);
