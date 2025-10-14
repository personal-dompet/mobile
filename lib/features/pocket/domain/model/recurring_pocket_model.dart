import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';

class RecurringPocketModel extends PocketModel {
  final String productName;
  final int amount;
  final DateTime? dueDate;
  final String? productDescription;

  RecurringPocketModel({
    required this.productName,
    required this.amount,
    this.dueDate,
    this.productDescription,
    required super.id,
    required super.name,
    required super.color,
    required super.icon,
    required super.balance,
    required super.priority,
    required super.createdAt,
    required super.updatedAt,
  }) : super(
          type: PocketType.recurring,
        );

  factory RecurringPocketModel.fromJson(Map<String, dynamic> json) {
    final pocket = PocketModel.fromJson(json);
    return RecurringPocketModel(
      productName: json['product_name'],
      amount: json['amount'],
      dueDate: json['due_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['due_date'] * 1000)
          : null,
      productDescription: json['product_description'],
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

  factory RecurringPocketModel.placeholder({
    String? name,
    PocketColor? color,
    int? balance,
    Category? icon,
    int? priority,
    int? amount,
    String? productDescription,
    String? productName,
    DateTime? dueDate,
  }) {
    return RecurringPocketModel(
      productName: productName ?? '',
      amount: amount ?? 0,
      dueDate: dueDate,
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

  String get formattedAmount => FormatCurrency.formatRupiah(amount);
  String get formattedDueDate => dueDate?.toIso8601String() ?? '';

  @override
  RecurringPocketModel copyWith({
    String? productName,
    int? amount,
    String? productDescription,
    DateTime? dueDate,
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
    return RecurringPocketModel(
      productName: productName ?? this.productName,
      amount: amount ?? this.amount,
      productDescription: productDescription ?? this.productDescription,
      dueDate: dueDate ?? this.dueDate,
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
