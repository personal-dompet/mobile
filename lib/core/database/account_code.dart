import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Kode child berikutnya yang deterministik: max suffix numerik + 1.
///
/// Tidak memakai `created_at` (resolusi 1 detik — seri saat insert cepat
/// beruntun sehingga `latest` salah tebak → kode duplikat → UNIQUE gagal).
/// Baris ter-soft-delete tetap dihitung agar kode monotonik naik dan
/// tidak pernah dipakai ulang.
Future<String> nextAccountCode(Transaction txn, {required String code}) async {
  final rows = await txn.query(
    accountTable,
    columns: [AccountKey.code],
    where: '${AccountKey.code} LIKE ?',
    whereArgs: ['$code.%'],
  );

  var maxIndex = 0;
  for (final row in rows) {
    final rowCode = row[AccountKey.code] as String?;
    if (rowCode == null) continue;
    final parts = rowCode.split('.');
    if (parts.isEmpty) continue;
    final index = int.tryParse(parts.last);
    if (index == null) continue;
    final prefix = rowCode.substring(
      0,
      rowCode.length - parts.last.length - 1,
    );
    if (prefix != code) continue;
    if (index > maxIndex) maxIndex = index;
  }

  final nextIndex = (maxIndex + 1).toString().padLeft(4, '0');
  return '$code.$nextIndex';
}
