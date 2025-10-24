import 'package:dompet/features/transaction/data/transaction_source.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_filter_form.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionRepository {
  final TransactionSource _source;
  TransactionRepository(this._source);

  Future<TransactionDetailModel?> create(TransactionForm form) async {
    final response = await _source.create(form);
    if (response == null) return null;
    return TransactionDetailModel.fromJson(response);
  }

  Future<List<TransactionDetailModel>> getTransactions(
      TransactionFilterForm form) async {
    final response = await _source.getTransactions(form);
    return TransactionDetailModel.fromJsonList(response);
  }

  // Future<List<TransactionDetailModel>> getRecentTransaction(
  //     TransactionFilterForm form) async {
  //   final response = await _source.recentTransactions(form);
  //   return TransactionDetailModel.fromJsonList(response);
  // }
}

final transactionRepositoryProvider =
    Provider.autoDispose<TransactionRepository>((ref) {
  final source = ref.read(transactionSourceProvider);
  return TransactionRepository(source);
});
