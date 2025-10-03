import 'package:dompet/features/transaction/data/transaction_repository.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recentTransactionProvider =
    FutureProvider<List<TransactionDetailModel>>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return repository.getRecentTransaction();
});
