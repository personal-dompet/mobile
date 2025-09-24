import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';

class SimpleAccountModel {
  final int id;
  final String name;
  final AccountType type;
  final int balance;
  final PocketColor? color;

  SimpleAccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.color,
  });

  String get formattedBalance => FormatCurrency.formatRupiah(balance);

  factory SimpleAccountModel.fromJson(Map<String, dynamic> json) {
    return SimpleAccountModel(
      id: json['id'],
      name: json['name'],
      type: AccountType.fromString(json['type']),
      balance: json['balance'],
      color: PocketColor.parse(json['color']),
    );
  }
}