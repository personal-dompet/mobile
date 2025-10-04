import 'package:dompet/features/transaction/data/transaction_repository.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_filter_form.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recentTransactionProvider =
    FutureProvider<List<TransactionDetailModel>>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  final form = TransactionFilterForm()
    ..page.value = 1
    ..limit.value = 5;
  return repository.getTransactions(form);
});
