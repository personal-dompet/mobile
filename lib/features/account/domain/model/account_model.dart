import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';

class AccountModel extends FinancialEntityModel {
  final AccountType type;

  AccountModel({
    required super.id,
    required super.name,
    required this.type,
    required super.color,
    required super.balance,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final financialEntity = FinancialEntityModel.fromJson(json);
    return AccountModel(
      id: financialEntity.id,
      name: financialEntity.name,
      type: AccountType.fromValue(json['type']),
      color: financialEntity.color,
      balance: financialEntity.balance,
      createdAt: financialEntity.createdAt,
      updatedAt: financialEntity.updatedAt,
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
