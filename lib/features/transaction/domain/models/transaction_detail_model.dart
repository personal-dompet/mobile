import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:dompet/features/transaction/domain/models/transaction_model.dart';

class TransactionDetailModel extends TransactionModel {
  final PocketModel pocket;
  final AccountModel account;

  TransactionDetailModel({
    required super.id,
    required super.amount,
    required super.description,
    required super.date,
    required super.type,
    required super.category,
    required super.createdAt,
    required super.updatedAt,
    required this.pocket,
    required this.account,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    final transaction = TransactionModel.fromJson(json);
    return TransactionDetailModel(
      id: transaction.id,
      amount: transaction.amount,
      description: transaction.description,
      date: transaction.date,
      type: transaction.type,
      category: transaction.category,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      pocket: PocketModel.fromJson(json['pocket']),
      account: AccountModel.fromJson(json['account']),
    );
  }

  factory TransactionDetailModel.placeholder({
    int? amount,
    String? description,
    DateTime? date,
    TransactionType? type,
    Category? category,
  }) {
    return TransactionDetailModel(
      id: -1,
      amount: amount ?? 0,
      description: description ?? '',
      date: date ?? DateTime.now(),
      type: type ?? TransactionType.income,
      category: category ?? Category.others,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      pocket: PocketModel.placeholder(),
      account: AccountModel.placeholder(),
    );
  }

  static List<TransactionDetailModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => TransactionDetailModel.fromJson(json))
        .toList();
  }
}
