import 'package:dompet_app/core/enums/account_type.dart';
import 'package:dompet_app/core/enums/balance_type.dart';
import 'package:flutter/material.dart';

enum AccountPreset {
  // --- ASSET (101) ---
  cash('Tunai', .asset, '101.0001', Icons.payments_rounded),
  bank('Rekening Bank', .asset, '101.0002', Icons.account_balance_rounded),
  eWallet('E-Wallet', .asset, '101.0003', Icons.phone_android_rounded),
  receivable('Piutang', .asset, '101.0004', Icons.call_received_rounded),
  investment('Investasi', .asset, '101.0005', Icons.trending_up_rounded),

  // --- LIABILITY (201) ---
  delayedBill(
    'Tagihan Tertunda',
    .liability,
    '201.0001',
    Icons.pending_actions_rounded,
  ),
  creditCard('Kartu Kredit', .liability, '201.0002', Icons.credit_card_rounded),
  debt('Hutang', .liability, '201.0003', Icons.call_made_rounded),

  // --- EQUITY (301) ---
  intialBalance('Saldo Awal', .equity, '301.0001', Icons.first_page_rounded),
  balanceAdjustment(
    'Penyesuaian Saldo',
    .equity,
    '301.0002',
    Icons.swap_horiz_rounded,
  ),
  saving('Tabungan', .equity, '301.0003', Icons.savings_rounded),

  // --- INCOME (401) ---
  salary('Gaji / Pendapatan Tetap', .income, '401.0001', Icons.work_rounded),
  freelance('Usaha / Freelance', .income, '401.0002', Icons.storefront_rounded),
  bonus('Bonus', .income, '401.0003', Icons.monetization_on_rounded),
  reward('Hadiah', .income, '401.0004', Icons.card_giftcard_rounded),
  sale('Penjualan', .income, '401.0005', Icons.shopping_bag_rounded),
  otherIncome('Lain-lain', .income, '401.0006', Icons.more_horiz_rounded),

  // --- EXPENSE (501) ---
  food('Makan / Minum', .expense, '501.0001', Icons.restaurant_rounded),
  dailyPurchase(
    'Belanja Harian',
    .expense,
    '501.0002',
    Icons.shopping_cart_rounded,
  ),
  transport('Transportasi', .expense, '501.0003', Icons.directions_car_rounded),
  bill('Tagihan', .expense, '501.0004', Icons.receipt_long_rounded),
  entertainment(
    'Hiburan',
    .expense,
    '501.0005',
    Icons.confirmation_number_rounded,
  ),
  subscription('Langganan', .expense, '501.0006', Icons.subscriptions_rounded),
  healthcare('Kesehatan', .expense, '501.0007', Icons.medical_services_rounded),
  education('Pendidikan', .expense, '501.0008', Icons.school_rounded),
  social(
    'Donasi & Sosial',
    .expense,
    '501.0009',
    Icons.volunteer_activism_rounded,
  ),
  tax('Pajak', .expense, '501.0010', Icons.gavel_rounded),
  otherExpense('Lain-lain', .expense, '501.0011', Icons.more_horiz_rounded);

  final String value;
  final AccountType type;
  final IconData icon;
  final String code;

  const AccountPreset(this.value, this.type, this.code, this.icon);

  BalanceType get balanceType => type.balanceType;
}
