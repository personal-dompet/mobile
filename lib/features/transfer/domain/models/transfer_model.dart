import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:flutter/cupertino.dart';

class TransferModel<T extends FinancialEntityModel> extends TimestampModel {
  final int id;
  final int amount;
  final String? description;
  final T source;
  final T destination;

  const TransferModel({
    required super.createdAt,
    required super.updatedAt,
    required this.id,
    required this.amount,
    required this.source,
    required this.destination,
    this.description,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    debugPrint('json $json');
    final timestamp = TimestampModel.fromJson(json);
    debugPrint('timestamp $timestamp');
    final source = FinancialEntityModel.fromJson(json['source']);
    final destination = FinancialEntityModel.fromJson(json['destination']);

    return TransferModel(
      createdAt: timestamp.createdAt,
      updatedAt: timestamp.updatedAt,
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      source: source as T,
      destination: destination as T,
    );
  }

  factory TransferModel.placeholder({
    int? amount,
    String? description,
    T? source,
    T? destination,
  }) {
    return TransferModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: -1 * DateTime.now().millisecondsSinceEpoch,
      source: source ?? FinancialEntityModel.placeholder() as T,
      destination: destination ?? FinancialEntityModel.placeholder() as T,
      amount: amount ?? 0,
      description: description ?? '',
    );
  }

  static List<TransferModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TransferModel.fromJson(json)).toList();
  }

  String get formattedAmount => FormatCurrency.formatRupiah(amount);
}
