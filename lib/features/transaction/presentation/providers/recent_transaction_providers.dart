import 'package:dompet/features/transaction/data/repositories/transaction_repository.dart';
import 'package:dompet/features/transaction/domain/models/recent_transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recentTransactionProvider =
    FutureProvider<List<RecentTransactionModel>>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return repository.getRecentTransaction();
});
