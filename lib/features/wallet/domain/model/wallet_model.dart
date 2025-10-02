import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';

class WalletModel extends SimplePocketModel {
  final String userId;
  final int totalBalance;
  final int createdAt;
  final int updatedAt;

  WalletModel({
    required super.id,
    required super.name,
    required super.type,
    required super.balance,
    required this.userId,
    required this.totalBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedTotalBalance => FormatCurrency.formatRupiah(totalBalance);

  static WalletModel fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      name: json['name'],
      type: PocketType.wallet,
      userId: json['userId'],
      totalBalance: json['totalBalance'],
      balance: json['balance'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  WalletModel copyWith({int? balance, int? totalBalance}) {
    return WalletModel(
      id: id,
      name: name,
      type: type,
      userId: userId,
      totalBalance: totalBalance ?? this.totalBalance,
      balance: balance ?? this.balance,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
