import 'package:dompet/core/models/entity_base_type.dart';
import 'package:flutter/material.dart';

enum PocketType implements EntityBaseType {
  all('all', 'All', Icons.wallet_outlined, 'All pocket types', Colors.grey),
  wallet('wallet', 'Wallet', Icons.wallet_outlined,
      'Main wallet for general funds', Colors.grey),
  spending(
      'spending',
      'Spending',
      Icons.shopping_cart_outlined,
      'For day-to-day expenses like groceries and entertainment',
      Colors.redAccent),
  saving(
      'saving',
      'Saving',
      Icons.savings_outlined,
      'For building emergency funds or saving for specific goals',
      Colors.greenAccent),
  recurring(
      'recurring',
      'Recurring',
      Icons.repeat_outlined,
      'For regular bills and subscriptions like rent or streaming services',
      Colors.blueAccent);

  @override
  final String value;
  @override
  final String displayName;
  @override
  final IconData icon;
  @override
  final String description;
  @override
  final Color color;

  const PocketType(
      this.value, this.displayName, this.icon, this.description, this.color);

  static PocketType fromValue(String value) {
    for (final type in PocketType.values) {
      if (type.value == value) {
        return type;
      }
    }
    // Default to 'all' if no match found
    return PocketType.all;
  }
}
