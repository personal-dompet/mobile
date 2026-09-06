import 'dart:convert';

import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/activities/extensions/activity.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_line.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id');
  });

  const cashId = 11;
  const pocketId = 20;
  const foodId = 30;

  JournalLine line({
    required int accountId,
    required String accountName,
    required AccountType accountType,
    int debit = 0,
    int credit = 0,
  }) {
    return JournalLine(
      id: accountId,
      journalEntryId: 1,
      accountId: accountId,
      debitAmount: debit,
      creditAmount: credit,
      accountName: accountName,
      accountType: accountType,
      accountNormalBalance: accountType.balanceType,
    );
  }

  JournalEntry entry({
    String? description,
    String? metadata,
    required List<JournalLine> lines,
  }) {
    return JournalEntry(
      id: 1,
      entryDate: DateTime(2026, 1, 2, 10, 30).millisecondsSinceEpoch ~/ 1000,
      description: description,
      source: JournalSource.saving,
      status: JournalStatus.posted,
      metadata: metadata,
      lines: lines,
    );
  }

  String meta(String tx) => jsonEncode({'saving_tx': tx, 'pocket_id': pocketId});

  group('topup', () {
    late JournalEntry topup;

    setUp(() {
      topup = entry(
        metadata: meta('TOPUP'),
        lines: [
          line(
            accountId: cashId,
            accountName: 'Tunai',
            accountType: AccountType.asset,
            credit: 50000,
          ),
          line(
            accountId: pocketId,
            accountName: 'VGA',
            accountType: AccountType.asset,
            debit: 50000,
          ),
        ],
      );
    });

    test('judul global deskriptif, bukan Tanpa keterangan', () {
      expect(topup.title(), 'Alokasi dari Tunai ke VGA');
    });

    test('judul per akun mengikuti sisi', () {
      expect(topup.title(accountId: cashId), 'Alokasi ke VGA');
      expect(topup.title(accountId: pocketId), 'Alokasi dari Tunai');
    });

    test('tanda nominal mengikuti sisi', () {
      expect(topup.displayAmount(accountId: cashId).startsWith('-'), isTrue);
      expect(topup.displayAmount(accountId: pocketId).startsWith('+'), isTrue);
    });

    test('metadata rute menampilkan asal ke pocket', () {
      expect(topup.activityData(), contains('Tunai → VGA'));
    });
  });

  group('withdraw', () {
    late JournalEntry withdraw;

    setUp(() {
      withdraw = entry(
        metadata: meta('WITHDRAW'),
        lines: [
          line(
            accountId: pocketId,
            accountName: 'VGA',
            accountType: AccountType.asset,
            credit: 20000,
          ),
          line(
            accountId: cashId,
            accountName: 'Tunai',
            accountType: AccountType.asset,
            debit: 20000,
          ),
        ],
      );
    });

    test('judul global deskriptif', () {
      expect(withdraw.title(), 'Tarik dana dari VGA ke Tunai');
    });

    test('judul per akun mengikuti sisi', () {
      expect(withdraw.title(accountId: pocketId), 'Tarik dana ke Tunai');
      expect(withdraw.title(accountId: cashId), 'Tarik dana dari VGA');
    });

    test('tanda nominal mengikuti sisi', () {
      expect(
        withdraw.displayAmount(accountId: pocketId).startsWith('-'),
        isTrue,
      );
      expect(
        withdraw.displayAmount(accountId: cashId).startsWith('+'),
        isTrue,
      );
    });

    test('metadata rute menampilkan pocket ke dompet', () {
      expect(withdraw.activityData(), contains('VGA → Tunai'));
    });
  });

  group('spend', () {
    late JournalEntry spend;

    setUp(() {
      spend = entry(
        metadata: meta('SPEND'),
        lines: [
          line(
            accountId: pocketId,
            accountName: 'VGA',
            accountType: AccountType.asset,
            credit: 15000,
          ),
          line(
            accountId: foodId,
            accountName: 'Makan / Minum',
            accountType: AccountType.expense,
            debit: 15000,
          ),
        ],
      );
    });

    test('judul global menyebut kategori dan pocket', () {
      expect(spend.title(), 'Belanja Makan / Minum dari VGA');
    });

    test('nominal global bertanda negatif', () {
      expect(spend.displayAmount().startsWith('-'), isTrue);
    });
  });

  test('deskripsi manual tetap menang atas judul otomatis', () {
    final custom = entry(
      description: 'Alokasi khusus',
      metadata: meta('TOPUP'),
      lines: [
        line(
          accountId: cashId,
          accountName: 'Tunai',
          accountType: AccountType.asset,
          credit: 1000,
        ),
        line(
          accountId: pocketId,
          accountName: 'VGA',
          accountType: AccountType.asset,
          debit: 1000,
        ),
      ],
    );

    expect(custom.title(), 'Alokasi khusus');
  });

  test('jurnal lama tanpa metadata tidak crash', () {
    final legacy = entry(
      lines: [
        line(
          accountId: cashId,
          accountName: 'Tunai',
          accountType: AccountType.asset,
          credit: 1000,
        ),
        line(
          accountId: pocketId,
          accountName: 'VGA',
          accountType: AccountType.asset,
          debit: 1000,
        ),
      ],
    );

    expect(legacy.title(), isNot('Tanpa keterangan'));
    expect(legacy.activityData(), isNotEmpty);
  });
}
