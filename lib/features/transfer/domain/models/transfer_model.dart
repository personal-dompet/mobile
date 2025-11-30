import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';

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
    final timestamp = TimestampModel.fromJson(json);
    final source = T is PocketModel
        ? PocketModel.fromJson(json['source'])
        : AccountModel.fromJson(json['source']);
    final destination = T is PocketModel
        ? PocketModel.fromJson(json['destination'])
        : AccountModel.fromJson(json['destination']);

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
    late T transferSource;
    late T transferDestination;
    if (source != null) transferSource = source;
    if (destination != null) transferDestination = destination;
    if (T is PocketModel) {
      transferSource = PocketModel.placeholder() as T;
      transferDestination = PocketModel.placeholder() as T;
    }
    if (T is AccountModel) {
      transferSource = AccountModel.placeholder() as T;
      transferDestination = AccountModel.placeholder() as T;
    }
    return TransferModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: -1 * DateTime.now().millisecondsSinceEpoch,
      source: transferSource,
      destination: transferDestination,
      amount: amount ?? 0,
      description: description ?? '',
    );
  }

  static List<TransferModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TransferModel.fromJson(json)).toList();
  }

  String get formattedAmount => FormatCurrency.formatRupiah(amount);
}
