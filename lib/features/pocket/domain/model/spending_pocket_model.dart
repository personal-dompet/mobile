import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';

class SpendingPocketModel extends PocketModel {
  final int lowBalanceThreshold;
  final bool lowBalanceReminder;

  SpendingPocketModel({
    required this.lowBalanceThreshold,
    required this.lowBalanceReminder,
    required super.id,
    required super.name,
    required super.color,
    required super.icon,
    required super.balance,
    required super.priority,
    required super.createdAt,
    required super.updatedAt,
  }) : super(
          type: PocketType.spending,
        );

  factory SpendingPocketModel.fromJson(Map<String, dynamic> json) {
    final pocket = PocketModel.fromJson(json);
    return SpendingPocketModel(
      lowBalanceThreshold: json['low_balance_threshold'],
      lowBalanceReminder: json['low_balance_reminder'],
      id: pocket.id,
      name: pocket.name,
      color: pocket.color,
      icon: pocket.icon,
      balance: pocket.balance,
      priority: pocket.priority,
      createdAt: pocket.createdAt,
      updatedAt: pocket.updatedAt,
    );
  }

  factory SpendingPocketModel.placeholder({
    String? name,
    PocketColor? color,
    int? balance,
    Category? icon,
    int? priority,
    int? lowBalanceThreshold,
    bool? lowBalanceReminder,
  }) {
    return SpendingPocketModel(
      lowBalanceThreshold: lowBalanceThreshold ?? 0,
      lowBalanceReminder: lowBalanceReminder ?? false,
      id: 0,
      name: name ?? '',
      color: color,
      icon: icon,
      balance: balance ?? 0,
      priority: priority ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String get formattedLowBalanceThreshold =>
      FormatCurrency.formatRupiah(lowBalanceThreshold);

  @override
  SpendingPocketModel copyWith({
    int? lowBalanceThreshold,
    bool? lowBalanceReminder,
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
    return SpendingPocketModel(
      lowBalanceThreshold: lowBalanceThreshold ?? this.lowBalanceThreshold,
      lowBalanceReminder: lowBalanceReminder ?? this.lowBalanceReminder,
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
