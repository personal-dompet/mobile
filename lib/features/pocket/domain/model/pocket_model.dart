import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';

class PocketModel extends TimestampModel {
  final int id;
  final String name;
  final PocketColor? color;
  final int balance;
  final Category? icon;
  final int priority;
  final PocketType type;

  PocketModel({
    required this.id,
    required this.name,
    required this.color,
    required this.balance,
    required this.icon,
    required this.priority,
    required this.type,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PocketModel.fromJson(Map<String, dynamic> json) {
    final timestamp = TimestampModel.fromJson(json);
    return PocketModel(
      id: json['id'],
      name: json['name'],
      color: json['color'] != null ? PocketColor.parse(json['color']) : null,
      balance: json['balance'],
      icon: json['icon'] != null ? Category.fromValue(json['icon']) : null,
      priority: json['priority'],
      type: PocketType.fromValue(json['type']),
      createdAt: timestamp.createdAt,
      updatedAt: timestamp.updatedAt,
    );
  }

  factory PocketModel.placeholder({
    String? name,
    PocketColor? color,
    int? balance,
    Category? icon,
    int? priority,
    PocketType? type,
  }) {
    return PocketModel(
      id: -1 * DateTime.now().millisecondsSinceEpoch,
      name: name ?? '',
      color: color,
      balance: balance ?? 0,
      icon: icon,
      priority: priority ?? 0,
      type: type ?? PocketType.all,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String get formattedBalance => FormatCurrency.formatRupiah(balance);

  PocketModel copyWith({
    int? id,
    String? name,
    PocketColor? color,
    int? balance,
    Category? icon,
    int? priority,
    PocketType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PocketModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
