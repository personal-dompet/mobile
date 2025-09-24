import 'package:dompet/core/utils/helpers/format_currency.dart';

class WalletModel {
  final int id;
  final String userId;
  final int availableBalance;
  final int balance;
  final int createdAt;
  final int updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.availableBalance,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedBalance => FormatCurrency.formatRupiah(balance);
  String get formattedAvailableBalance =>
      FormatCurrency.formatRupiah(availableBalance);

  static WalletModel fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      userId: json['userId'],
      availableBalance: json['availableBalance'],
      balance: json['balance'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  WalletModel copyWith({int? balance, int? availableBalance}) {
    return WalletModel(
      id: id,
      userId: userId,
      availableBalance: availableBalance ?? this.availableBalance,
      balance: balance ?? this.balance,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
