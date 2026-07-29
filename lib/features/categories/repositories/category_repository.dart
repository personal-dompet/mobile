import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:flutter/material.dart';

class CategoryRepository {
  final DbService _dbService;

  CategoryRepository(this._dbService);

  Future<Account> createCategory({required CategoryForm form}) async {
    if (form.invalid) {
      throw Exception('Kesalahan syntax, data tidak valid. Hubungi developer.');
    }

    final db = await _dbService.database;

    int iconCode = switch (form.type) {
      .expense =>
        form.icon?.icon.codePoint ??
            Icons.account_balance_wallet_rounded.codePoint,
      .income => form.icon?.icon.codePoint ?? Icons.payment_rounded.codePoint,
      _ => Icons.wallet_rounded.codePoint,
    };

    final latestAccountResult = await db.query(
      accountTable,
      where:
          '''
        ${AccountKey.type} = ?
        AND NOT (${AccountKey.isSystem} = 1 AND ${AccountKey.name} = 'Lain-Lain')
      ''',
      whereArgs: [form.type!.value],
      orderBy: '${AccountKey.code} DESC',
      limit: 1,
    );

    final latestAccount = Account.fromJson(latestAccountResult.first);

    List<String> splittedCode = latestAccount.code.split('.');

    final nextCodeSequence = int.parse(splittedCode.last) + 1;

    splittedCode.last = nextCodeSequence.toString().padLeft(4, '0');

    final nextCode = splittedCode.join('.');

    final categoryId = await db.insert(accountTable, {
      AccountKey.code: nextCode,
      AccountKey.iconCode: iconCode,
      AccountKey.name: form.name,
      AccountKey.normalBalance: form.type!.balanceType.value,
      AccountKey.type: form.type!.value,
      AccountKey.isSystem: 0,
    });

    final categoryResult = await db.query(
      accountTable,
      where: '${AccountKey.id} = ?',
      whereArgs: [categoryId],
    );

    if (categoryResult.isEmpty) {
      throw Exception('Kategori belum berhasil dibuat.');
    }

    return Account.fromJson(categoryResult.first);
  }

  Future<void> updateCategory({
    required int id,
    required CategoryForm form,
  }) async {
    if (form.invalid) {
      throw Exception('Kesalahan syntax, data tidak valid. Hubungi developer.');
    }

    final db = await _dbService.database;

    await db.update(
      accountTable,
      {
        AccountKey.name: form.name,
        AccountKey.iconCode: form.icon?.icon.codePoint,
      },
      where: '${AccountKey.id} = ?',
      whereArgs: [id],
    );
  }
}
