import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:intl/intl.dart';

class SavingPocketModel extends PocketModel {
  final int? targetAmount;
  final String? targetDescription;
  final DateTime? targetDate;

  SavingPocketModel({
    this.targetAmount,
    this.targetDescription,
    this.targetDate,
    required super.id,
    required super.name,
    required super.color,
    required super.icon,
    required super.balance,
    required super.priority,
    required super.createdAt,
    required super.updatedAt,
  }) : super(
          type: PocketType.saving,
        );

  factory SavingPocketModel.fromJson(Map<String, dynamic> json) {
    final pocket = PocketModel.fromJson(json);
    return SavingPocketModel(
      targetAmount: json['target_amount'],
      targetDescription: json['target_description'],
      targetDate: json['target_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['target_date'] * 1000)
          : null,
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

  factory SavingPocketModel.placeholder({
    String? name,
    PocketColor? color,
    int? balance,
    Category? icon,
    int? priority,
    int? targetAmount,
    String? targetDescription,
    DateTime? targetDate,
  }) {
    return SavingPocketModel(
      targetAmount: targetAmount,
      targetDescription: targetDescription,
      targetDate: targetDate,
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

  String get formattedTargetAmount =>
      FormatCurrency.formatRupiah(targetAmount ?? 0);
  String get formattedtargetDate =>
      targetDate != null ? DateFormat('dd MMMM yyyy').format(targetDate!) : '';
  String get formattedtargetDateTime =>
      targetDate != null ? DateFormat('HH:mm').format(targetDate!) : '';

  String get relativeFormattedtargetDate {
    if (targetDate == null) {
      return '';
    }

    final now = DateTime.now();

    final difference = now.difference(targetDate!).inDays;
    final hour = targetDate!.hour.toString().padLeft(2, '0');
    final minute = targetDate!.minute.toString().padLeft(2, '0');

    if (difference == 0) {
      // Today
      return 'Today at $hour:$minute';
    } else if (difference == 1) {
      // Yesterday
      return 'Yesterday at $hour:$minute';
    } else if (difference < 7) {
      // Within a week
      return '$difference days ago at $hour:$minute';
    } else {
      // More than a week
      final formatter = DateFormat('dd MMMM yyyy HH:mm');
      return formatter.format(targetDate!);
    }
  }

  @override
  SavingPocketModel copyWith({
    int? targetAmount,
    String? targetDescription,
    DateTime? targetDate,
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
    return SavingPocketModel(
      targetAmount: targetAmount ?? this.targetAmount,
      targetDescription: targetDescription ?? this.targetDescription,
      targetDate: targetDate ?? this.targetDate,
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
