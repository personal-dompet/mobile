import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';

class PocketModel extends FinancialEntityModel {
  final Category? icon;
  final int priority;
  final PocketType type;

  PocketModel({
    required super.id,
    required super.name,
    required super.color,
    required super.balance,
    required this.icon,
    required this.priority,
    required this.type,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PocketModel.fromJson(Map<String, dynamic> json) {
    final financialEntity = FinancialEntityModel.fromJson(json);
    return PocketModel(
      id: financialEntity.id,
      name: financialEntity.name,
      type: PocketType.fromValue(json['type']),
      color: financialEntity.color,
      balance: financialEntity.balance,
      icon: json['icon'] != null ? Category.fromValue(json['icon']) : null,
      priority: json['priority'],
      createdAt: financialEntity.createdAt,
      updatedAt: financialEntity.updatedAt,
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
