import 'package:freezed_annotation/freezed_annotation.dart';

/// Jenis mutasi pocket tabungan virtual.
///
/// Disimpan di `journal_entries.metadata` sebagai JSON
/// `{"saving_tx":"TOPUP",...}`, bukan kolom DB tersendiri.
/// Single source of truth saldo tetap `v_account_balances`.
enum SavingTxType {
  @JsonValue('topup')
  topup('topup'),
  @JsonValue('withdraw')
  withdraw('withdraw'),
  @JsonValue('spend')
  spend('spend');

  final String value;

  const SavingTxType(this.value);

  static List<String> get allValues {
    return SavingTxType.values.map((e) => e.value).toList();
  }
}
