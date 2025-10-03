import 'package:dompet/features/transaction/data/transaction_source.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionRepository {
  final TransactionSource _source;
  TransactionRepository(this._source);

  Future<List<TransactionDetailModel>> getRecentTransaction() async {
    final response = await _source.recentTransactions();
    return TransactionDetailModel.fromJsonList(response);
  }
}

final transactionRepositoryProvider =
    Provider.autoDispose<TransactionRepository>((ref) {
  final source = ref.read(transactionSourceProvider);
  return TransactionRepository(source);
});
