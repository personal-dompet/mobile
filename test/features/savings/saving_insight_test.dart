import 'dart:convert';

import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_line.dart';
import 'package:dompet_app/features/savings/models/saving_insight.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:flutter_test/flutter_test.dart';

int _sec(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

SavingPlan _plan({
  int accountId = 100,
  int balance = 0,
  int? targetAmount = 10000000,
  DateTime? targetDate,
  String status = 'ACTIVE',
  required DateTime createdAt,
}) {
  return SavingPlan(
    id: 1,
    accountId: accountId,
    accountCode: '101.0006.0001',
    accountName: 'VGA',
    targetAmount: targetAmount,
    targetDate: targetDate == null ? null : _sec(targetDate),
    status: status,
    balance: balance,
    createdAt: _sec(createdAt),
  );
}

JournalEntry _topup({
  required int id,
  required int pocketId,
  required int amount,
  required DateTime date,
}) {
  return JournalEntry(
    id: id,
    entryDate: _sec(date),
    source: JournalSource.saving,
    status: JournalStatus.posted,
    metadata: jsonEncode({'saving_tx': 'TOPUP', 'pocket_id': pocketId}),
    lines: [
      JournalLine(
        id: id * 10,
        journalEntryId: id,
        accountId: pocketId,
        accountName: 'VGA',
        accountType: AccountType.asset,
        accountNormalBalance: BalanceType.debit,
        debitAmount: amount,
      ),
      JournalLine(
        id: id * 10 + 1,
        journalEntryId: id,
        accountId: 1,
        accountName: 'Tunai',
        accountType: AccountType.asset,
        accountNormalBalance: BalanceType.debit,
        creditAmount: amount,
      ),
    ],
  );
}

JournalEntry _nonTopup({
  required int id,
  required int pocketId,
  required int amount,
  required DateTime date,
  required String tx,
}) {
  return JournalEntry(
    id: id,
    entryDate: _sec(date),
    source: JournalSource.saving,
    status: JournalStatus.posted,
    metadata: jsonEncode({'saving_tx': tx, 'pocket_id': pocketId}),
    lines: [
      JournalLine(
        id: id * 10,
        journalEntryId: id,
        accountId: pocketId,
        accountName: 'VGA',
        accountType: AccountType.asset,
        accountNormalBalance: BalanceType.debit,
        creditAmount: amount,
      ),
      JournalLine(
        id: id * 10 + 1,
        journalEntryId: id,
        accountId: 1,
        accountName: 'Tunai',
        accountType: AccountType.asset,
        accountNormalBalance: BalanceType.debit,
        debitAmount: amount,
      ),
    ],
  );
}

void main() {
  final now = DateTime(2026, 9, 4, 12);
  final created = DateTime(2026, 8, 26); // 10 hari lalu (inklusif = 10)

  test('tanpa nominal tujuan -> noTarget, hanya kecepatan', () {
    final plan = _plan(
      targetAmount: null,
      balance: 500000,
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 300000, date: DateTime(2026, 8, 27)),
      _topup(id: 2, pocketId: 100, amount: 200000, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.status, SavingInsightStatus.noTarget);
    expect(insight.remaining, 0);
    expect(insight.daysRemaining, isNull);
    expect(insight.neededPerMonth, isNull);
    // Dibuat Agu, sekarang Sep -> 2 bulan kalender. 500rb ÷ 2.
    expect(insight.monthsElapsed, 2);
    expect(insight.avgPerMonth, 250000);
    expect(insight.projectedDate, isNull);
    expect(insight.totalTopup, 500000);
    expect(insight.topupCount, 2);
  });

  test('saldo mencapai target -> reached', () {
    final plan = _plan(
      targetAmount: 1000000,
      balance: 1000000,
      createdAt: created,
    );
    final insight = SavingInsight.compute(
      plan: plan,
      journals: const [],
      now: now,
    );
    expect(insight.status, SavingInsightStatus.reached);
    expect(insight.neededPerMonth, isNull);
    expect(insight.projectedDate, isNull);
  });

  test('deadline depan + histori cukup -> projected + butuh/bulan', () {
    // Dibuat 26 Agu, sekarang 4 Sep -> 2 bulan kalender (termasuk Agu).
    // Total 2jt ÷ 2 = 1jt/bulan. Sisa 8jt -> eta 8 bulan = 240 hari.
    final plan = _plan(
      targetAmount: 10000000,
      balance: 2000000,
      targetDate: DateTime(2026, 9, 14),
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 1000000, date: DateTime(2026, 8, 27)),
      _topup(id: 2, pocketId: 100, amount: 1000000, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.status, SavingInsightStatus.projected);
    expect(insight.daysRemaining, 11);
    expect(insight.neededPerMonth, (8000000 * 30 / 11).ceil());
    expect(insight.showNeedRate, isFalse);
    expect(
      insight.deadlineDurationLabel,
      'kurang dari sebulan lagi',
    );
    // ETA: 8jt ÷ 1jt/bulan = 8 bulan = 240 hari.
    expect(insight.monthsElapsed, 2);
    expect(insight.avgPerMonth, 1000000);
    expect(insight.etaDays, 240);
    expect(insight.etaDurationLabel, 'sekitar 8 bulan lagi');
    expect(
      insight.projectedDate,
      DateTime(2026, 9, 4).add(const Duration(days: 240)),
    );
    expect(insight.showNeededPerMonth, isTrue);
    expect(insight.showProjection, isTrue);
  });

  test('deadline hari ini -> daysRemaining 1, tanpa bagi-nol', () {
    final plan = _plan(
      targetAmount: 1000000,
      balance: 990000,
      targetDate: DateTime(2026, 9, 4),
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 500000, date: DateTime(2026, 8, 27)),
      _topup(id: 2, pocketId: 100, amount: 490000, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.daysRemaining, 1);
    expect(insight.isDueToday, isTrue);
    expect(insight.isOverdue, isFalse);
    expect(insight.neededPerMonth, 10000 * 30);
    expect(insight.deadlineDurationLabel, 'Tenggat bulan ini');
    // Total 990rb ÷ 2 bulan = 495rb/bulan. Sisa 10rb -> eta 1 hari.
    expect(insight.avgPerMonth, 495000);
    expect(insight.etaDays, 1);
    expect(
      insight.projectedDate,
      DateTime(2026, 9, 4).add(const Duration(days: 1)),
    );
  });

  test('deadline lewat -> overdue, butuh/bulan null', () {
    final plan = _plan(
      targetAmount: 1000000,
      balance: 800000,
      targetDate: DateTime(2026, 8, 20),
      createdAt: DateTime(2026, 8, 1),
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 400000, date: DateTime(2026, 8, 5)),
      _topup(id: 2, pocketId: 100, amount: 400000, date: DateTime(2026, 8, 10)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.daysRemaining, 0);
    expect(insight.isOverdue, isTrue);
    expect(insight.neededPerMonth, isNull);
    expect(insight.showNeededPerMonth, isFalse);
    expect(insight.deadlineDurationLabel, isNull);
  });

  test('punya target tapi tanpa histori -> notEnoughData', () {
    final plan = _plan(
      targetAmount: 1000000,
      balance: 100000,
      targetDate: null,
      createdAt: created,
    );
    final insight = SavingInsight.compute(
      plan: plan,
      journals: const [],
      now: now,
    );
    expect(insight.status, SavingInsightStatus.notEnoughData);
    expect(insight.projectedDate, isNull);
  });

  test('1x alokasi belum cukup untuk proyeksi tanggal', () {
    final plan = _plan(
      targetAmount: 1000000,
      balance: 500000,
      targetDate: null,
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 500000, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.status, SavingInsightStatus.notEnoughData);
    expect(insight.topupCount, 1);
    expect(insight.projectedDate, isNull);
  });

  test('withdraw/spend dan pocket lain diabaikan dari laju', () {
    final plan = _plan(
      targetAmount: 1000000,
      balance: 500000,
      targetDate: null,
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 300000, date: DateTime(2026, 8, 27)),
      _topup(id: 2, pocketId: 100, amount: 200000, date: DateTime(2026, 9, 1)),
      _nonTopup(
        id: 3,
        pocketId: 100,
        amount: 100000,
        date: DateTime(2026, 9, 2),
        tx: 'WITHDRAW',
      ),
      _nonTopup(
        id: 4,
        pocketId: 100,
        amount: 50000,
        date: DateTime(2026, 9, 2),
        tx: 'SPEND',
      ),
      _topup(id: 5, pocketId: 999, amount: 9000000, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.topupCount, 2);
    expect(insight.totalTopup, 500000);
  });

  test('sisa kecil tetap tampil memakai ceil (tidak nol)', () {
    final plan = _plan(
      targetAmount: 1000000,
      balance: 999990,
      targetDate: DateTime(2026, 10, 3), // 30 hari inklusif
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 500000, date: DateTime(2026, 8, 27)),
      _topup(id: 2, pocketId: 100, amount: 499990, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.daysRemaining, 30);
    expect(insight.neededPerMonth, 10);
    expect(insight.showNeedRate, isTrue);
    expect(insight.deadlineDurationLabel, 'sekitar 1 bulan lagi');
  });

  test('alokasi melebihi target tetap dihitung (overshoot ditoleransi)', () {
    // Saldo 1,2jt melewati target 1jt -> tetap reached (selebrasi),
    // bukan error. Laju tetap dihitung dari histori.
    final plan = _plan(
      targetAmount: 1000000,
      balance: 1200000,
      targetDate: null,
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 700000, date: DateTime(2026, 8, 27)),
      _topup(id: 2, pocketId: 100, amount: 500000, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.status, SavingInsightStatus.reached);
    expect(insight.remaining, -200000);
    expect(insight.avgPerMonth, 600000);
    expect(insight.neededPerMonth, isNull);
    expect(insight.projectedDate, isNull);
  });

  test('tanpa deadline memakai estimasi bulan dari histori', () {
    // Dibuat 26 Agu, sekarang 4 Sep -> 2 bulan kalender.
    // Total 2jt ÷ 2 = 1jt/bulan. Sisa 8jt -> eta 8 bulan = 240 hari.
    final plan = _plan(
      targetAmount: 10000000,
      balance: 2000000,
      targetDate: null,
      createdAt: created,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 1000000, date: DateTime(2026, 8, 27)),
      _topup(id: 2, pocketId: 100, amount: 1000000, date: DateTime(2026, 9, 1)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: now,
    );
    expect(insight.status, SavingInsightStatus.projected);
    expect(insight.hasDeadline, isFalse);
    expect(insight.neededPerMonth, isNull);
    expect(insight.monthsElapsed, 2);
    expect(insight.avgPerMonth, 1000000);
    expect(insight.etaDays, 240);
    expect(insight.etaDurationLabel, 'sekitar 8 bulan lagi');
    expect(
      insight.projectedDate,
      DateTime(2026, 9, 4).add(const Duration(days: 240)),
    );
  });

  test('target 1 hari: dibagi 1 bulan kalender, bukan diekstrapolasi', () {
    // Skenario: target 100k dibuat hari ini, 2 alokasi (10k + 5k).
    // Total 15k ÷ 1 bulan = Rp15rb/bulan (bukan Rp450rb/bulan).
    // Sisa 85k -> eta ceil(85/15*30) = 170 hari (~6 bulan).
    final today = DateTime(2026, 9, 4);
    final plan = _plan(
      targetAmount: 100000,
      balance: 15000,
      targetDate: null,
      createdAt: today,
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 10000, date: today),
      _topup(id: 2, pocketId: 100, amount: 5000, date: today),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: DateTime(2026, 9, 4, 12),
    );
    expect(insight.status, SavingInsightStatus.projected);
    expect(insight.monthsElapsed, 1);
    expect(insight.avgPerMonth, 15000);
    expect(insight.etaDays, 170);
    expect(insight.etaDurationLabel, 'sekitar 6 bulan lagi');
    expect(
      insight.projectedDate,
      DateTime(2026, 9, 4).add(const Duration(days: 170)),
    );
  });

  test('ETA di bawah sebulan -> label kurang dari sebulan', () {
    final plan = _plan(
      targetAmount: 100000,
      balance: 90000,
      targetDate: null,
      createdAt: DateTime(2026, 9, 1),
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 40000, date: DateTime(2026, 9, 2)),
      _topup(id: 2, pocketId: 100, amount: 50000, date: DateTime(2026, 9, 3)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: DateTime(2026, 9, 4, 12),
    );
    // Dibuat & sekarang sama-sama September -> 1 bulan kalender.
    // Total 90k ÷ 1 = 90rb/bulan, sisa 10k -> eta ceil(10/90*30) = 4 hari.
    expect(insight.status, SavingInsightStatus.projected);
    expect(insight.avgPerMonth, 90000);
    expect(insight.etaDays, 4);
    expect(insight.etaDurationLabel, 'kurang dari sebulan lagi');
  });

  test('bulan tanpa alokasi ikut dihitung dalam rata-rata', () {
    // Jan: 500rb + 300rb = 800rb; Feb: 0; Mar: 500rb.
    // Rata-rata = 1,3jt ÷ 3 bulan = Rp433.333/bulan (bukan ÷ 3 transaksi).
    final plan = _plan(
      targetAmount: 10000000,
      balance: 1300000,
      targetDate: null,
      createdAt: DateTime(2026, 1, 10),
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 500000, date: DateTime(2026, 1, 12)),
      _topup(id: 2, pocketId: 100, amount: 300000, date: DateTime(2026, 1, 20)),
      _topup(id: 3, pocketId: 100, amount: 500000, date: DateTime(2026, 3, 5)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: DateTime(2026, 3, 15, 12),
    );
    expect(insight.status, SavingInsightStatus.projected);
    expect(insight.monthsElapsed, 3);
    expect(insight.topupCount, 3);
    expect(insight.avgPerMonth, (1300000 / 3).round());
    // Sisa 8,7jt ÷ 433.333/bulan -> ~20 bulan.
    expect(insight.etaDays, (8700000 / (1300000 / 3) * 30).ceil());
    expect(insight.etaDurationLabel, 'sekitar 20 bulan lagi');
  });

  test('REGRESI kasus 1: target 30k tanpa alokasi, tenggat 27 hari', () {
    // Sisa 30rb, tenggat 30 Sep (27 hari inklusif dari 4 Sep).
    // Rate mentah = ceil(30rb*30/27) = 33.334 (> sisa!) -> rate
    // disembunyikan, hero menampilkan sisa + hitung mundur.
    final plan = _plan(
      targetAmount: 30000,
      balance: 0,
      targetDate: DateTime(2026, 9, 30),
      createdAt: DateTime(2026, 9, 4),
    );
    final insight = SavingInsight.compute(
      plan: plan,
      journals: const [],
      now: DateTime(2026, 9, 4, 12),
    );
    expect(insight.remaining, 30000);
    expect(insight.daysRemaining, 27);
    expect(insight.neededPerMonth, 33334);
    expect(insight.showNeededPerMonth, isTrue);
    expect(insight.showNeedRate, isFalse);
    expect(insight.deadlineDurationLabel, 'kurang dari sebulan lagi');
  });

  test('REGRESI kasus 2: target 10k alokasi Rp2, tenggat 27 hari', () {
    // Sisa 9.998, tenggat 27 hari -> rate mentah 11.109 (> sisa!).
    final plan = _plan(
      targetAmount: 10000,
      balance: 2,
      targetDate: DateTime(2026, 9, 30),
      createdAt: DateTime(2026, 9, 1),
    );
    final journals = [
      _topup(id: 1, pocketId: 100, amount: 2, date: DateTime(2026, 9, 2)),
    ];
    final insight = SavingInsight.compute(
      plan: plan,
      journals: journals,
      now: DateTime(2026, 9, 4, 12),
    );
    expect(insight.remaining, 9998);
    expect(insight.neededPerMonth, 11109);
    expect(insight.showNeedRate, isFalse);
    expect(insight.deadlineDurationLabel, 'kurang dari sebulan lagi');
  });
}
