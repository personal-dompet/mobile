import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:intl/intl.dart';

class RecentTransactionModel {
  final int amount;
  final String? description;
  final int createdAt;
  final String type;
  final String category;

  // Computed properties for UI display
  late final String formattedAmount;
  late final String formattedDate;
  late final bool isIncome;

  RecentTransactionModel({
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.type,
    required this.category,
  }) {
    // Initialize computed properties
    formattedAmount = _formatAmount();
    formattedDate = _formatDate();
    isIncome = type == 'INCOME';
  }

  static List<RecentTransactionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => RecentTransactionModel.fromJson(json))
        .toList();
  }

  static RecentTransactionModel fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      amount: json['amount'],
      description: json['description'],
      createdAt: json['createdAt'],
      type: json['type'],
      category: json['category'],
    );
  }

  String _formatAmount() {
    final formattedNumber = FormatCurrency.format(amount.abs());
    return 'Rp $formattedNumber';
  }

  String _formatDate() {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);

    final difference = now.difference(date).inDays;

    if (difference == 0) {
      // Today
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return 'Today $hour:$minute';
    } else if (difference == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference < 7) {
      // Within a week
      return '$difference days ago';
    } else {
      // More than a week
      final formatter = DateFormat('dd MMMM yyyy HH:mm');
      return formatter.format(date);
    }
  }
}
