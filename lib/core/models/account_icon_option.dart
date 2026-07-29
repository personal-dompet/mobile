import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';

class AccountIconOption {
  const AccountIconOption({
    required this.icon,
    required this.keywords,
    required this.type,
  });

  final IconData icon;
  final List<String> keywords;
  final TransactionType type;

  bool matchKeyword({required String keyword}) {
    final normalized = keyword.trim().toLowerCase();

    if (normalized.isEmpty) {
      return true;
    }

    return keywords.any(
      (keyword) => keyword.toLowerCase().contains(normalized),
    );
  }
}
