import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/models/timestamp_model.dart';
import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:intl/intl.dart';

class TransactionModel extends TimestampModel {
  int id;
  int amount;
  String? description;
  TransactionType type;
  Category category;
  DateTime date;

  TransactionModel({
    required super.createdAt,
    super.updatedAt,
    required this.id,
    required this.amount,
    this.description,
    required this.type,
    required this.category,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final timestamp = TimestampModel.fromJson(json);
    return TransactionModel(
      createdAt: timestamp.createdAt,
      updatedAt: timestamp.updatedAt,
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      type: TransactionType.fromValue(json['type']),
      category: Category.fromValue(json['category']),
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] * 1000),
    );
  }

  factory TransactionModel.placeholder({
    DateTime? date,
    TransactionType? type,
    Category? category,
    int? amount,
    String? description,
  }) {
    return TransactionModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: -1,
      amount: amount ?? 0,
      description: description ?? '',
      type: type ?? TransactionType.expense,
      category: category ?? Category.others,
      date: date ?? DateTime.now(),
    );
  }

  String get formattedDate => DateFormat('dd MMM yyyy').format(date);
  String get formattedTime => DateFormat('HH:mm').format(date);
  String get formattedAmount => FormatCurrency.formatRupiah(amount);
  bool get isIncome => type == TransactionType.income;

  String get relativeFormattedDate {
    final now = DateTime.now();

    final difference = now.difference(date).inDays;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

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
      return formatter.format(date);
    }
  }
}
