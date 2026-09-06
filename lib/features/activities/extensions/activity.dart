import 'dart:convert';

import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_line.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';

extension Activity on JournalEntry {
  /// Jenis mutasi tabungan dari `journal_entries.metadata`
  /// (`{"saving_tx":"TOPUP","pocket_id":123}`). Null untuk jurnal lama
  /// tanpa metadata.
  SavingTxType? get _savingTx {
    final meta = metadata;
    if (meta == null || meta.isEmpty) return null;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return null;
      return SavingTxType.values
          .where((e) => e.value == json['saving_tx'])
          .firstOrNull;
    } catch (_) {
      return null;
    }
  }

  int? get _pocketId {
    final meta = metadata;
    if (meta == null || meta.isEmpty) return null;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return null;
      final id = json['pocket_id'];
      return id is int ? id : null;
    } catch (_) {
      return null;
    }
  }

  JournalLine? get _pocketLine {
    final id = _pocketId;
    if (id == null) return null;
    return lines.where((line) => line.accountId == id).firstOrNull;
  }

  /// Lawan transaksi pocket: dompet cair (topup/withdraw)
  /// atau kategori expense (spend).
  JournalLine? get _savingCounterLine {
    final pocket = _pocketLine;
    final others = pocket == null
        ? lines
        : lines.where((line) => line.accountId != pocket.accountId);
    return others
            .where((line) => line.accountType == .asset)
            .firstOrNull ??
        others.firstOrNull;
  }

  String get _savingTitle {
    final pocket = _pocketLine?.accountName ?? 'Target';
    final counter = _savingCounterLine?.accountName ?? 'Dompet';
    return switch (_savingTx) {
      SavingTxType.withdraw => 'Tarik dana dari $pocket ke $counter',
      SavingTxType.spend => 'Belanja $counter dari $pocket',
      _ => 'Alokasi dari $counter ke $pocket',
    };
  }

  /// Rute dana untuk baris metadata, mis. `Tunai → VGA`.
  String? get _savingRoute {
    final pocket = _pocketLine?.accountName;
    final counter = _savingCounterLine?.accountName;
    if (pocket == null || counter == null) return null;
    return switch (_savingTx) {
      SavingTxType.topup || null => '$counter → $pocket',
      _ => '$pocket → $counter',
    };
  }

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
      .saving => _savingTitle,
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
    if (accountId != null &&
        description?.trim().isNotEmpty != true &&
        source == .saving) {
      final line = lines
          .where((line) => line.accountId == accountId)
          .firstOrNull;

      if (line == null) return '-';

      final isPocket = line.accountId == _pocketId;
      final pocket = _pocketLine?.accountName ?? 'Target';
      final counter = _savingCounterLine?.accountName ?? 'Dompet';

      return switch (_savingTx) {
        SavingTxType.withdraw when isPocket => 'Tarik dana ke $counter',
        SavingTxType.withdraw => 'Tarik dana dari $pocket',
        SavingTxType.spend when isPocket => 'Belanja $counter',
        SavingTxType.spend => 'Belanja $counter dari $pocket',
        _ when isPocket => 'Alokasi dari $counter',
        _ => 'Alokasi ke $pocket',
      };
    }
    return _title;
  }

  String displayAmount({int? accountId}) {
    if (accountId == null) return _displayAmount;

    if (source == .transfer) {
      final line = assetLines
          .where((line) => line.accountId == accountId)
          .firstOrNull;

      if (line == null) return '-';

      final isDebit = line.debitAmount > 0;

      return isDebit ? '+${amount.currency}' : '-${amount.currency}';
    }

    if (source == .saving) {
      final line = lines
          .where((line) => line.accountId == accountId)
          .firstOrNull;

      if (line == null) return '-';

      final isDebit = line.debitAmount > 0;

      return isDebit ? '+${amount.currency}' : '-${amount.currency}';
    }

    return _displayAmount;
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
    } else if (source == .saving && accountId == null) {
      metadata.add(_savingRoute ?? assetLines.firstOrNull?.accountName ?? 'Dompet');
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
