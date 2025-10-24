import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';

class AccountDetailModel extends AccountModel {
  final String? provider;
  final String? accountNumber;

  AccountDetailModel({
    this.accountNumber,
    this.provider,
    required super.balance,
    required super.color,
    required super.createdAt,
    required super.id,
    required super.name,
    required super.type,
    required super.updatedAt,
  });

  factory AccountDetailModel.fromJson(Map<String, dynamic> json) {
    final account = AccountModel.fromJson(json);

    return AccountDetailModel(
      balance: account.balance,
      color: account.color,
      createdAt: account.createdAt,
      id: account.id,
      name: account.name,
      type: account.type,
      updatedAt: account.updatedAt,
      accountNumber: json['accountNumber'],
      provider: json['provider'],
    );
  }

  factory AccountDetailModel.placeholder({
    String? provider,
    String? accountNumber,
    String? name,
    AccountType? type,
    PocketColor? color,
    int? balance,
  }) {
    final account = AccountModel.placeholder(
      balance: balance,
      name: name,
      type: type,
      color: color,
    );

    return AccountDetailModel(
        balance: account.balance,
        name: account.name,
        type: account.type,
        color: account.color,
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
        id: account.id,
        provider: provider,
        accountNumber: accountNumber);
  }

  @override
  AccountDetailModel copyWith({
    int? id,
    String? name,
    AccountType? type,
    PocketColor? color,
    int? balance,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? provider,
    String? accountNumber,
  }) {
    return AccountDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      provider: provider ?? this.provider,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }
}
