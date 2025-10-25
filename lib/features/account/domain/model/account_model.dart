import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';

class AccountModel extends TimestampModel {
  final int id;
  final String name;
  final int balance;
  final PocketColor? color;
  final AccountType type;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.balance,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final timestamp = TimestampModel.fromJson(json);
    return AccountModel(
      id: json['id'],
      name: json['name'],
      type: AccountType.fromValue(json['type']),
      color: PocketColor.parse(json['color']),
      balance: json['balance'],
      createdAt: timestamp.createdAt,
      updatedAt: timestamp.updatedAt,
    );
  }

  factory AccountModel.placeholder({
    String? name,
    AccountType? type,
    PocketColor? color,
    int? balance,
  }) {
    return AccountModel(
      id: -1 * DateTime.now().millisecondsSinceEpoch,
      name: name ?? '',
      type: type ?? AccountType.cash,
      color: color,
      balance: balance ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String get formattedBalance => FormatCurrency.formatRupiah(balance);

  AccountModel copyWith({
    int? id,
    String? name,
    AccountType? type,
    PocketColor? color,
    int? balance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
