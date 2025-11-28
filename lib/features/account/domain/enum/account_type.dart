import 'package:dompet/core/models/entity_base_type.dart';
import 'package:flutter/material.dart';

enum AccountType implements EntityBaseType {
  all('all', 'All', Icons.account_balance_wallet_outlined, 'All account types',
      Colors.grey),
  cash('cash', 'Cash', Icons.money_outlined, 'Physical cash accounts',
      Colors.orange),
  bank('bank', 'Bank', Icons.account_balance_outlined, 'Bank accounts',
      Colors.blue),
  eWallet('e-wallet', 'E-Wallet', Icons.phone_android_outlined,
      'Digital wallets and payment apps', Colors.green);

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

  const AccountType(
      this.value, this.displayName, this.icon, this.description, this.color);

  static AccountType fromValue(String value) {
    for (final type in AccountType.values) {
      if (type.value == value) {
        return type;
      }
    }
    // Default to 'all' if no match found
    return AccountType.all;
  }
}
