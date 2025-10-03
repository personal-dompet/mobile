import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';

class WalletModel extends PocketModel {
  final int totalBalance;

  WalletModel({
    required super.id,
    required super.name,
    required super.type,
    required super.balance,
    required super.createdAt,
    required super.updatedAt,
    required this.totalBalance,
    super.icon,
    super.color,
    super.priority = 0,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final pocket = PocketModel.fromJson(json);
    return WalletModel(
      id: pocket.id,
      name: pocket.name,
      type: pocket.type,
      totalBalance: json['totalBalance'],
      balance: pocket.balance,
      createdAt: pocket.createdAt,
      updatedAt: pocket.updatedAt,
      color: pocket.color,
      icon: pocket.icon,
      priority: pocket.priority,
    );
  }

  factory WalletModel.placeholder({
    String? name,
    int? totalBalance,
    int balance = 0,
    PocketColor? color,
    Category? icon,
  }) {
    return WalletModel(
      id: -1,
      name: name ?? 'Wallet',
      type: PocketType.wallet,
      totalBalance: totalBalance ?? 0,
      balance: balance,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      color: color,
      icon: icon,
      priority: 0,
    );
  }

  String get formattedTotalBalance => FormatCurrency.formatRupiah(totalBalance);

  @override
  WalletModel copyWith({
    int? id,
    String? name,
    PocketColor? color,
    int? balance,
    Category? icon,
    int? priority,
    PocketType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalBalance,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }
}
