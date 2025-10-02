import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';

class SimplePocketModel {
  final int id;
  final String name;
  final PocketType type;
  final int balance;
  final PocketColor? color;
  final Category? icon;
  final int priority;

  SimplePocketModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.color,
    this.icon,
    this.priority = 0,
  });

  String get formattedBalance => FormatCurrency.formatRupiah(balance);

  factory SimplePocketModel.fromJson(Map<String, dynamic> json) {
    return SimplePocketModel(
      id: json['id'],
      name: json['name'],
      type: PocketType.fromString(json['type']),
      balance: json['balance'],
      color: PocketColor.parse(json['color']),
      icon: json['icon'] != null ? Category.fromString(json['icon']) : null,
      priority: json['priority'],
    );
  }

  factory SimplePocketModel.empty() {
    return SimplePocketModel(
      id: 0,
      name: '',
      type: PocketType.all,
      balance: 0,
      color: null,
      icon: null,
      priority: 0,
    );
  }
}
