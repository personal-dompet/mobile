import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';

extension Activity on JournalEntry {
  String get _title {
    if (description?.trim().isNotEmpty == true) return description!.trim();
    return switch (source) {
      .adjustment => 'Penyesuaian saldo',
      .billPayment => 'Pembayaran tagihan',
      .transaction =>
        otherLines.length > 1
            ? '${(type == .income ? 'Pemasukan dari' : 'Pengeluaran untuk')} ${otherLines.length} kategori'
            : otherLines.firstOrNull?.accountName ??
                  (type == .income ? 'Pemasukan' : 'Pengeluaran'),
      .transfer =>
        'Pindah dana dari ${assetLines.lastOrNull?.accountName ?? 'Dompet'} ke ${assetLines.firstOrNull?.accountName ?? 'Dompet'}',
      _ => 'Tanpa keterangan',
    };
  }

  String title({int? accountId}) {
    if (accountId != null &&
        description?.trim().isNotEmpty != true &&
        source == .transfer) {
      final line = assetLines
          .where((line) => line.accountId == accountId)
          .firstOrNull;

      if (line == null) return '-';

      final isDebit = line.debitAmount > 0;

      return isDebit
          ? 'Pindah dana dari ${assetLines.lastOrNull?.accountName ?? 'Dompet'}'
          : 'Pindah dana ke ${assetLines.firstOrNull?.accountName ?? 'Dompet'}';
    }
    return _title;
  }

  String displayAmount({int? accountId}) {
    if (accountId == null || source != .transfer) return _displayAmount;

    final line = assetLines
        .where((line) => line.accountId == accountId)
        .firstOrNull;

    if (line == null) return '-';

    final isDebit = line.debitAmount > 0;

    return isDebit ? '+${amount.currency}' : '-${amount.currency}';
  }

  String get _displayAmount {
    final currency = amount.currency;
    if (type == .income ||
        (type == .adjustment && assetLines.first.debitAmount > 0)) {
      return '+$currency';
    }
    if (type == .expense ||
        (type == .adjustment && assetLines.first.creditAmount > 0)) {
      return '-$currency';
    }
    return currency;
  }

  String activityData({bool hideDate = false, int? accountId}) {
    final metadata = <String>[];

    if (source == .transfer && accountId == null) {
      final [destination, source] = assetLines;
      metadata.add('${source.accountName} → ${destination.accountName}');
    } else if (accountId == null) {
      final account = assetLines.firstOrNull;
      metadata.add(account?.accountName ?? 'Dompet');
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(entryDate * 1000);

    if (!hideDate) {
      metadata.add(dateTime.format());
    }

    metadata.add(dateTime.formatTime(includeMinutes: true));

    return metadata.join(' • ');
  }
}
