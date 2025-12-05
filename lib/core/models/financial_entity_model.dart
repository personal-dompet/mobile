import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';

/// Abstract base class for financial entities like accounts and pockets
class FinancialEntityModel extends TimestampModel {
  final int id;
  final String name;
  final PocketColor? color;
  final int balance;

  FinancialEntityModel({
    required this.id,
    required this.name,
    required this.color,
    required this.balance,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FinancialEntityModel.fromJson(Map<String, dynamic> json) {
    final timestamp = TimestampModel.fromJson(json);
    return FinancialEntityModel(
      id: json['id'],
      name: json['name'],
      color: json['color'] != null ? PocketColor.parse(json['color']) : null,
      balance: json['balance'],
      createdAt: timestamp.createdAt,
      updatedAt: timestamp.updatedAt,
    );
  }

  factory FinancialEntityModel.placeholder({
    String? name,
    PocketColor? color,
    int? balance,
    int? priority,
  }) {
    return FinancialEntityModel(
      id: -1 * DateTime.now().millisecondsSinceEpoch,
      name: name ?? '',
      color: color,
      balance: balance ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String get formattedBalance => FormatCurrency.formatRupiah(balance);
}
