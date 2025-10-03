import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';

class TransferModel extends TimestampModel {
  final int id;
  final int amount;
  final String? description;

  const TransferModel({
    required super.createdAt,
    required super.updatedAt,
    required this.id,
    required this.amount,
    this.description,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    final timestamp = TimestampModel.fromJson(json);
    return TransferModel(
      createdAt: timestamp.createdAt,
      updatedAt: timestamp.updatedAt,
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
    );
  }

  factory TransferModel.placeholder({
    int? amount,
    String? description,
  }) {
    return TransferModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: -1,
      amount: amount ?? 0,
      description: description ?? '',
    );
  }

  String get formattedAmount => FormatCurrency.formatRupiah(amount);
}
