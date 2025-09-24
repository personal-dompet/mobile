import 'package:dompet/features/transaction/data/sources/transaction_source.dart';
import 'package:dompet/features/transaction/domain/models/recent_transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionRepository {
  final TransactionSource _source;
  TransactionRepository(this._source);

  Future<List<RecentTransactionModel>> getRecentTransaction() async {
    final response = await _source.recentTransactions();
    return RecentTransactionModel.fromJsonList(response);
  }
}

final transactionRepositoryProvider =
    Provider.autoDispose<TransactionRepository>((ref) {
  final source = ref.read(transactionSourceProvider);
  return TransactionRepository(source);
});
