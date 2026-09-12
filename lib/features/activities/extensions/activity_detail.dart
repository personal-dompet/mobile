import 'dart:convert';

import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';

extension ActivityDetail on JournalEntry {
  String get title {
    return switch (source) {
      .adjustment => 'Detail Penyesuaian Saldo',
      .billPayment => 'Detail Pembayaran Tagihan',
      .transaction =>
        type == .income ? 'Detail Pemasukan' : 'Detail Pengeluaran',
      .transfer => 'Detail Pindah Dana',
      // FIX-04: judul detail saldo awal.
      .setup => 'Detail Saldo Awal',
      _ => 'Detail Aktivitas',
    };
  }

  /// Kaki withdraw dari "bayar tagihan pakai Target" (J1): void/edit-nya
  /// harus terkunci + cascade seperti payment-nya (TC-BINT-010).
  /// False untuk Tarik biasa & jurnal lama tanpa `bill_id`.
  bool get isBillLinkedWithdraw {
    final meta = metadata;
    if (meta == null || meta.isEmpty) return false;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return false;
      if (SavingTxType.tryParse(json['saving_tx']) != SavingTxType.withdraw) {
        return false;
      }
      return json['bill_id'] is int;
    } catch (_) {
      return false;
    }
  }

  /// Kaki hybrid belanja-dari-Target (J1 tarik pocket maupun J2 expense):
  /// edit satu kaki tak punya semantik valid karena pasangannya tak ikut
  /// berubah, jadi Perbaiki disembunyikan seperti `isBillLinkedWithdraw`.
  /// Hapus tetap ada — void-nya cascade di repo ke pasangannya.
  bool get isHybridSpendLeg {
    final meta = metadata;
    if (meta == null || meta.isEmpty) return false;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return false;
      return (json['hybrid'] == true &&
              SavingTxType.tryParse(json['saving_tx']) ==
                  SavingTxType.spend) ||
          json['hybrid_expense'] == true;
    } catch (_) {
      return false;
    }
  }

  TransactionForm toTransactionForm() {
    final form = TransactionForm();

    final line = assetLines.firstOrNull;
    if (line != null) {
      form.assetForm.idControl.updateValue(line.accountId);
      form.assetForm.nameControl.updateValue(line.accountName);
      form.assetForm.balanceControl.updateValue(line.balance);
    }

    form.dateControl.updateValue(entryDate.dateTime);
    form.noteControl.updateValue(description);

    while (form.categoriesFormArray.controls.isNotEmpty) {
      form.removeCategory(0);
    }

    final categoryLines = lines
        .where(
          (line) => line.accountType == .income || line.accountType == .expense,
        )
        .toList();

    for (final line in categoryLines) {
      form.addCategory();

      final categoryForm = form.categories.last;
      categoryForm.categoryIdControl.updateValue(line.accountId);
      categoryForm.categoryNameControl.updateValue(line.accountName);
      categoryForm.amountControl.updateValue(line.amount.toInt());
      categoryForm.noteControl.updateValue(line.note);
    }

    return form;
  }

  TransferForm toTransferForm() {
    final form = TransferForm();

    form.amountControl.updateValue(amount.toInt());
    form.dateControl.updateValue(entryDate.dateTime);
    form.noteControl.updateValue(description);

    final sourceAccountId = lines
        .where((line) => line.debitAmount == 0 && line.creditAmount > 0)
        .first
        .accountId;

    final destinationAccountId = lines
        .where((line) => line.debitAmount > 0 && line.creditAmount == 0)
        .first
        .accountId;

    final sourceLine = assetLines
        .where((line) => line.accountId == sourceAccountId)
        .first;

    final destinationLine = assetLines
        .where((line) => line.accountId == destinationAccountId)
        .first;

    form.sourceForm.idControl.updateValue(sourceLine.accountId);
    form.sourceForm.nameControl.updateValue(sourceLine.accountName);
    form.sourceForm.balanceControl.updateValue(sourceLine.balance);

    form.destinationForm.idControl.updateValue(destinationLine.accountId);
    form.destinationForm.nameControl.updateValue(destinationLine.accountName);
    form.destinationForm.balanceControl.updateValue(destinationLine.balance);

    return form;
  }
}
