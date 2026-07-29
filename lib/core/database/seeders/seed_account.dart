import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:sqflite/sqflite.dart';

Future<void> seedAccount(Transaction txn) async {
  for (var accountPreset in AccountPreset.values) {
    bool isLiquid = [
      AccountPreset.bank,
      AccountPreset.cash,
      AccountPreset.eWallet,
    ].contains(accountPreset);

    await txn.rawInsert(
      '''
      INSERT INTO $accountTable (
        ${AccountKey.code},
        ${AccountKey.name},
        ${AccountKey.type},
        ${AccountKey.normalBalance},
        ${AccountKey.isLiquid},
        ${AccountKey.iconCode}
      ) VALUES (
        ?,
        ?,
        ?,
        ?,
        ?,
        ?
      ) ON CONFLICT DO NOTHING
    ''',
      [
        accountPreset.code,
        accountPreset.value,
        accountPreset.type.value,
        accountPreset.type.balanceType.value,
        isLiquid ? 1 : 0,
        accountPreset.icon.codePoint,
      ],
    );
  }
}
