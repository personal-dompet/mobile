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

  /// Parse toleran case: DB lama + test memakai 'TOPUP', kode baru
  /// menulis lowercase. Bandingkan upper-case agar dua-duanya jalan.
  static SavingTxType? tryParse(Object? raw) {
    if (raw is! String) return null;
    final v = raw.toUpperCase();
    for (final e in values) {
      if (e.value.toUpperCase() == v) return e;
    }
    return null;
  }

  static List<String> get allValues {
    return SavingTxType.values.map((e) => e.value).toList();
  }
}
