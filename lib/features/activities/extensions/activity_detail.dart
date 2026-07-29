import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
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
      _ => 'Detail Aktivitas',
    };
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
