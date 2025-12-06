import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';

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

  factory TransferModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? entityFromJson,
  ) {
    final timestamp = TimestampModel.fromJson(json);
    final parser =
        entityFromJson ?? ((json) => FinancialEntityModel.fromJson(json) as T);

    final source = parser(json['source']);
    final destination = parser(json['destination']);

    return TransferModel(
      createdAt: timestamp.createdAt,
      updatedAt: timestamp.updatedAt,
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      source: source,
      destination: destination,
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

  static List<TransferModel<T>> fromJsonList<T extends FinancialEntityModel>(
    List<dynamic> jsonList,
    T Function(Map<String, dynamic>)? entityFromJson,
  ) {
    return jsonList
        .map((json) => TransferModel.fromJson(json, entityFromJson))
        .toList();
  }

  String get formattedAmount => FormatCurrency.formatRupiah(amount);
}
