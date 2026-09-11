import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/activities/extensions/activity_detail.dart';
import 'package:dompet_app/features/activities/pages/activity_detail_page.dart';
import 'package:dompet_app/features/bills/cubits/bill_cubit.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/forms/bill_plan_form.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_filter.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/models/bill_plan_detail.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:dompet_app/features/bills/widgets/bill_tile.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'helpers/fixture.dart';

/// Alur Tagihan: plan rutin, sinkronisasi malas, daftar bayar, pembayaran
/// (Dompet + Target sisihan), dan integrasi lintas fitur.
///
/// Menggabungkan (docs/0003_TEST_CASE.md):
/// - TC-BLP-001 s.d. TC-BLP-010, TC-BLP-012, TC-BLP-014/015/016/018
/// - TC-BLL-001 s.d. TC-BLL-008
/// - TC-BIL-001 s.d. TC-BIL-012, TC-BIL-015/016/017/018
/// - TC-SNK-002/004/005/006/008/009/011 (+ TC-SNK-010 via jalur repo sama)
/// - TC-BINT-001/003/004/005/006/007/008/009/010
/// - TC-BSCH-001 s.d. TC-BSCH-005
///
/// Tidak diotomatiskan (UI murni, tetap manual): TC-BLP-011/013/017,
/// TC-BLL-009, TC-BIL-013/014/019, TC-SNK-001/003/007, TC-BINT-002,
/// TC-BSCH-006, dan teks snackbar/dialog/navigasi di semua TC di atas.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(resetFixture);
  tearDown(disposeFixture);

  int nowSec() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
  BillPlanRepository plans() => getIt<BillPlanRepository>();
  BillRepository bills() => getIt<BillRepository>();

  /// Plan bulanan yang billed-nya hari ini (terpicu synchronizeBills).
  Future<BillPlan> monthlyPlan({
    required int accountId,
    String name = 'Listrik Rumah',
    int amount = 100000,
    int reminderDays = 3,
    DateTime? endedAt,
    bool bulkCreate = false,
    String? reference,
  }) {
    final today = DateTime.now();
    return plans().savePlan(
      accountId: accountId,
      name: name,
      amount: amount,
      period: 'monthly',
      billedSchedule: today.day.toString(),
      dueDateSchedule: 'last_day',
      reminderDays: reminderDays,
      endedAt: endedAt,
      bulkCreate: bulkCreate,
      reference: reference,
    );
  }

  /// Plan tahunan yang billed-nya hari ini.
  Future<BillPlan> yearlyPlan({
    required int accountId,
    String name = 'Pajak Motor',
    int amount = 1200000,
  }) {
    final today = DateTime.now();
    final due = today.add(const Duration(days: 5));
    String mmdd(DateTime d) =>
        '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return plans().savePlan(
      accountId: accountId,
      name: name,
      amount: amount,
      period: 'yearly',
      billedSchedule: mmdd(today),
      dueDateSchedule: mmdd(due),
      reminderDays: 0,
      bulkCreate: false,
    );
  }

  Future<int> journalCount({
    String? source,
    int? sourceId,
  }) async {
    final db = await getIt<DbService>().database;
    final where = [
      '${JournalEntryKey.status} = ?',
      if (source != null) '${JournalEntryKey.source} = ?',
      if (sourceId != null) '${JournalEntryKey.sourceId} = ?',
    ].join(' AND ');
    final args = [
      JournalStatus.posted.name,
      if (source != null) source,
      if (sourceId != null) sourceId,
    ];
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM $journalEntryTable WHERE $where',
      args,
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  test('TC-BLP-001/002/004/018 buat plan, tanpa draft, multi-plan satu kategori',
      () async {
    final base = await seedBaseData();
    final t0 = await totalUang();
    final jcSeed = await journalCount();

    // TC-BLP-001: buat lengkap.
    final plan = await monthlyPlan(
      accountId: base.makanId,
      reference: 'IDPEL 123',
    );
    expect(plan.name, 'Listrik Rumah');
    expect(plan.amount, 100000);
    expect(plan.reference, 'IDPEL 123');
    expect(plan.reminderDays, 3);
    // TC-BLP-001/002 efek samping: tanpa jurnal, saldo tetap.
    expect(await journalCount(), jcSeed);
    expect(await totalUang(), t0);

    // TC-BLP-002/004: tanpa endedAt / bulk mati = tanpa tagihan.
    final rows = await bills().getBills(
      pagination: const Pagination(page: 1, limit: 20),
      filter: BillFilter(billPlanId: plan.id),
    );
    expect(rows.items, isEmpty);

    // TC-BLP-018: satu kategori boleh banyak plan.
    final kos = await monthlyPlan(
      accountId: base.makanId,
      name: 'Listrik Kos',
    );
    final items = await plans().getPlansWithCategories();
    expect(items.map((e) => e.plan.name),
        containsAll(['Listrik Rumah', 'Listrik Kos']));
    expect(items.map((e) => e.category.name), everyElement(isNotEmpty));
    expect(kos.id, isNot(plan.id));
  });

  test('TC-BLP-005/006/008/016 validasi form: nominal, nama, kategori, jadwal',
      () async {
    BillPlanForm validForm() {
      final form = BillPlanForm();
      form.amountControl.updateValue(100000);
      form.nameControl.updateValue('Listrik');
      form.accountIdControl.updateValue(1);
      form.categoryNameControl.updateValue('Listrik');
      form.periodControl.updateValue('monthly');
      form.billedScheduleControl.updateValue('5');
      form.dueDateScheduleControl.updateValue('10');
      form.reminderDaysControl.updateValue(3);
      return form;
    }

    // TC-BLP-005: nominal kosong / 0 ditolak (min 1 global).
    final empty = validForm()..amountControl.updateValue(null);
    empty.markAllAsTouched();
    expect(empty.valid, isFalse);
    final zero = validForm()..amountControl.updateValue(0);
    zero.markAllAsTouched();
    expect(zero.valid, isFalse);
    expect(
      () => plans().savePlan(
        accountId: 1,
        name: 'X',
        amount: 0,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        bulkCreate: false,
      ),
      throwsException,
    );

    // TC-BLP-006: nama kosong ditolak repo.
    expect(
      () => plans().savePlan(
        accountId: 1,
        name: '',
        amount: 100000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        bulkCreate: false,
      ),
      throwsException,
    );

    // TC-BLP-007: kategori wajib.
    final noCategory = validForm()
      ..accountIdControl.updateValue(null)
      ..categoryNameControl.updateValue(null);
    noCategory.markAllAsTouched();
    expect(noCategory.valid, isFalse);

    // TC-BLP-008: kedua jadwal wajib.
    final noBilled = validForm()..billedScheduleControl.updateValue(null);
    noBilled.markAllAsTouched();
    expect(noBilled.valid, isFalse);
    final noDue = validForm()..dueDateScheduleControl.updateValue(null);
    noDue.markAllAsTouched();
    expect(noDue.valid, isFalse);

    // TC-BLP-016: Banyak Tagihan 0 ditolak.
    final zeroCount = validForm()..billCountControl.updateValue(0);
    zeroCount.markAllAsTouched();
    expect(zeroCount.valid, isFalse);
    expect(zeroCount.billCountControl.hasError('minCount'), isTrue);

    // Kontrol: form lengkap valid.
    final ok = validForm();
    ok.markAllAsTouched();
    expect(ok.valid, isTrue);
  });

  test('TC-BLP-009/010/012/014 urutan jadwal + reminder + yearly lintas tahun',
      () async {
    final base = await seedBaseData();

    // TC-BLP-009: monthly tagih >= tempo ditolak form + repo.
    final bad = BillPlanForm()
      ..amountControl.updateValue(50000)
      ..nameControl.updateValue('Internet')
      ..accountIdControl.updateValue(base.makanId)
      ..categoryNameControl.updateValue('Makan')
      ..periodControl.updateValue('monthly')
      ..billedScheduleControl.updateValue('10')
      ..dueDateScheduleControl.updateValue('5')
      ..reminderDaysControl.updateValue(0);
    bad.markAllAsTouched();
    expect(bad.hasError('scheduleOrder'), isTrue);
    expect(
      () => plans().savePlan(
        accountId: base.makanId,
        name: 'Internet',
        amount: 50000,
        period: 'monthly',
        billedSchedule: '10',
        dueDateSchedule: '5',
        reminderDays: 0,
        bulkCreate: false,
      ),
      throwsException,
    );
    final equal = BillPlanForm()
      ..amountControl.updateValue(50000)
      ..nameControl.updateValue('X')
      ..accountIdControl.updateValue(base.makanId)
      ..categoryNameControl.updateValue('Makan')
      ..periodControl.updateValue('monthly')
      ..billedScheduleControl.updateValue('10')
      ..dueDateScheduleControl.updateValue('10')
      ..reminderDaysControl.updateValue(0);
    equal.markAllAsTouched();
    expect(equal.hasError('scheduleOrder'), isTrue);

    // TC-BLP-010: 28 → last_day lolos.
    final okPlan = await plans().savePlan(
      accountId: base.makanId,
      name: 'Air',
      amount: 50000,
      period: 'monthly',
      billedSchedule: '28',
      dueDateSchedule: 'last_day',
      reminderDays: 0,
      bulkCreate: false,
    );
    expect(okPlan.billedSchedule, '28');

    // TC-BLP-014: reminder > selisih ditolak; maks = selisih tagih–tempo.
    expect(
      BillSchedule.maxReminderDays(
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
      ),
      5,
    );
    final over = BillPlanForm()
      ..amountControl.updateValue(50000)
      ..nameControl.updateValue('X')
      ..accountIdControl.updateValue(base.makanId)
      ..categoryNameControl.updateValue('Makan')
      ..periodControl.updateValue('monthly')
      ..billedScheduleControl.updateValue('5')
      ..dueDateScheduleControl.updateValue('10')
      ..reminderDaysControl.updateValue(6);
    over.markAllAsTouched();
    expect(over.hasError('reminderRange'), isTrue);

    // TC-BLP-012: yearly tempo lintas tahun (due tahun billed + 1).
    final first = BillSchedule.nextYearlyBilled(DateTime.now(), '12-20');
    final yearly = await plans().savePlan(
      accountId: base.makanId,
      name: 'Pajak',
      amount: 300000,
      period: 'yearly',
      billedSchedule: '12-20',
      dueDateSchedule: '01-05',
      reminderDays: 3,
      endedAt: DateTime(first.year, 12, 20),
      bulkCreate: true,
    );
    final db = await getIt<DbService>().database;
    final draftRows = await db.query(
      billTable,
      where: '${BillKey.billPlanId} = ?',
      whereArgs: [yearly.id],
    );
    expect(draftRows, hasLength(1));
    final billedAt = DateTime.fromMillisecondsSinceEpoch(
        (draftRows.first[BillKey.billedAt] as int) * 1000);
    final dueDate = DateTime.fromMillisecondsSinceEpoch(
        (draftRows.first[BillKey.dueDate] as int) * 1000);
    expect(dueDate.year, billedAt.year + 1);
    expect(draftRows.first[BillKey.billPeriod], billedAt.year.toString());
  });

  test('TC-BLL-001/002/003/004 list, search, ended, detail, recent max 5',
      () async {
    final base = await seedBaseData();
    final first = BillSchedule.nextMonthlyBilled(DateTime.now(), '5');
    final plan = await plans().savePlan(
      accountId: base.makanId,
      name: 'Listrik Rumah',
      amount: 100000,
      period: 'monthly',
      billedSchedule: '5',
      dueDateSchedule: '10',
      reminderDays: 3,
      endedAt: DateTime(first.year, first.month + 6, 5),
      reference: 'IDPEL 123',
      bulkCreate: true,
    );
    await monthlyPlan(accountId: base.transportId, name: 'Internet Kos');

    // TC-BLL-001: search parsial case-insensitive; blank = semua.
    final filtered =
        await plans().getPlansWithCategories(nameKeyword: 'LIS');
    expect(filtered.map((e) => e.plan.name), ['Listrik Rumah']);
    expect((await plans().getPlansWithCategories(nameKeyword: '  ')),
        hasLength(2));

    // TC-BLL-002: ended flag (plan aktif kini).
    final fetched = await plans().getById(plan.id);
    final detailActive = BillPlanDetail(
      plan: fetched!,
      category: base.tunai,
    );
    expect(detailActive.isEnded, isFalse);

    // TC-BLL-003/004: detail = plan + kategori + recent max 5 + total.
    final recent = await bills().getBills(
      pagination: const Pagination(page: 1, limit: 5),
      filter: BillFilter(billPlanId: plan.id),
    );
    expect(recent.items, hasLength(5));
    expect(recent.meta.total, 7);
    final detail = BillPlanDetail(
      plan: fetched,
      category: (await plans().getPlansWithCategories(nameKeyword: 'LIS'))
          .first
          .category,
      recentBills: recent.items,
      totalCount: recent.meta.total,
    );
    expect(detail.hasMore, isTrue);
    expect(detail.plan.reference, 'IDPEL 123');
    // Semua draft: belum bisa dibayar.
    expect(detail.recentBills.map((b) => b.canPay), everyElement(isFalse));

    // TC-BLL-002: plan berakhir bertanda.
    final ended = await plans().savePlan(
      id: plan.id,
      accountId: base.makanId,
      name: 'Listrik Rumah',
      amount: 100000,
      period: 'monthly',
      billedSchedule: '5',
      dueDateSchedule: '10',
      reminderDays: 3,
      endedAt: DateTime.now().subtract(const Duration(days: 1)),
      bulkCreate: false,
    );
    expect(
      BillPlanDetail(plan: ended, category: base.tunai).isEnded,
      isTrue,
    );
  });

  test('TC-BLL-005/006/007 ubah plan + regenerasi draft', () async {
    final base = await seedBaseData();
    final first = BillSchedule.nextMonthlyBilled(DateTime.now(), '5');
    final endedAt = DateTime(first.year, first.month + 1, 5);
    final created = await plans().savePlan(
      accountId: base.makanId,
      name: 'Kos',
      amount: 1000000,
      period: 'monthly',
      billedSchedule: '5',
      dueDateSchedule: '10',
      reminderDays: 3,
      endedAt: endedAt,
      bulkCreate: true,
    );

    Future<List<Map<String, Object?>>> billsOf(int id) async {
      final db = await getIt<DbService>().database;
      return db.query(
        billTable,
        where: '${BillKey.billPlanId} = ? AND ${BillKey.isDeleted} = 0',
        whereArgs: [id],
        orderBy: '${BillKey.billedAt} ASC',
      );
    }

    expect(await billsOf(created.id), hasLength(2));

    // TC-BLL-006: ubah + bulk → draft lama diganti nominal baru, id sama.
    final updated = await plans().savePlan(
      id: created.id,
      accountId: base.makanId,
      name: 'Kos Baru',
      amount: 1200000,
      period: 'monthly',
      billedSchedule: '5',
      dueDateSchedule: '10',
      reminderDays: 3,
      endedAt: endedAt,
      bulkCreate: true,
    );
    expect(updated.id, created.id);
    expect(updated.name, 'Kos Baru');
    final rebilled = await billsOf(updated.id);
    expect(rebilled, hasLength(2));
    expect(rebilled.map((b) => b[BillKey.amount]), everyElement(1200000));

    // TC-BLL-007: ubah tanpa bulk → tanpa tagihan baru.
    final renamed = await plans().savePlan(
      id: created.id,
      accountId: base.makanId,
      name: 'Kos Final',
      amount: 1200000,
      period: 'monthly',
      billedSchedule: '5',
      dueDateSchedule: '10',
      reminderDays: 3,
      bulkCreate: false,
    );
    expect(renamed.id, created.id);
    expect((await billsOf(created.id)).length, lessThanOrEqualTo(2));
  });

  test('TC-BLL-008 hapus plan: draft ikut, aktif utuh, target unlink',
      () async {
    final base = await seedBaseData();

    final yearly = await yearlyPlan(accountId: base.makanId);
    final target = await getIt<SavingRepository>().createPocket(
      name: 'Dana Pajak Motor',
      targetAmount: 1200000,
      billPlanId: yearly.id,
      billPeriod: DateTime.now().year.toString(),
    );
    await bills().synchronizeBills();
    final active = await bills().getBillByPlanAndPeriod(
        yearly.id, DateTime.now().year.toString());
    expect(active, isNotNull);
    expect(active!.status, BillStatus.unpaid.value);

    await plans().deletePlan(yearly.id);

    // Plan hilang, draft ikut terhapus lemas.
    expect(await plans().getById(yearly.id), isNull);
    // TC-BLL-008: unpaid aktif tetap ada & bisa dibayar.
    final kept = await bills().getBillById(active.id);
    expect(kept, isNotNull);
    expect(kept!.canPay, isTrue);
    await fundAsset(base.bca.id, 2000000);
    await bills().payBill(billId: kept.id, assetId: base.bca.id);
    expect((await bills().getBillById(kept.id))?.status,
        BillStatus.paid.value);
    // Target unlink tapi dana aman (tetap target biasa).
    final unlinked =
        await getIt<SavingRepository>().getByAccountId(target.accountId);
    expect(unlinked, isNotNull);
    expect(unlinked!.billPlanId, isNull);
    expect(unlinked.billPeriod, isNull);
  });

  test('TC-BIL-001/002/003/004 + TC-BSCH-003 sinkronisasi malas + idempoten',
      () async {
    final base = await seedBaseData();
    final t0 = await totalUang();
    final bcaSeed = await balanceOf(base.bca.id);

    // TC-BIL-002: plan tanpa tagihan periode berjalan → generate saat baca.
    await monthlyPlan(accountId: base.makanId);
    expect(await bills().getPendingTotal(), 0);
    final touched = await bills().synchronizeBills();
    expect(touched, 1);
    expect(await bills().getPendingTotal(), 100000);

    // TC-BIL-001: draft tiba → unpaid + 1 jurnal bill_generated posted.
    final bill = (await bills().getActiveBills()).single;
    expect(bill.status, BillStatus.unpaid.value);
    expect(bill.canPay, isTrue);
    expect(
      await journalCount(
          source: JournalSource.billGenerated.value, sourceId: bill.id),
      1,
    );
    final gen = (await bills().getBillJournals(bill.id)).single;
    expect(gen.description, 'Tagihan Listrik Rumah • ${bill.billPeriod}');
    // Efek samping akrual: Total & dompet tetap.
    expect(await totalUang(), t0);
    expect(await balanceOf(base.bca.id), bcaSeed);

    // TC-BSCH-003: idempoten — panggil lagi 0 tersentuh, tanpa ganda.
    expect(await bills().synchronizeBills(), 0);
    expect(
      await journalCount(
          source: JournalSource.billGenerated.value, sourceId: bill.id),
      1,
    );

    // TC-BIL-003: billed belum tiba → belum ada tagihan.
    final futureDay = DateTime.now().day == 28 ? 27 : 28;
    final future = await plans().savePlan(
      accountId: base.transportId,
      name: 'Masa Depan',
      amount: 50000,
      period: 'monthly',
      billedSchedule: futureDay.toString(),
      dueDateSchedule: 'last_day',
      reminderDays: 0,
      bulkCreate: false,
    );
    await bills().synchronizeBills();
    final futureBills = await bills().getBills(
      pagination: const Pagination(page: 1, limit: 10),
      filter: BillFilter(billPlanId: future.id),
    );
    final billedToday = BillSchedule.monthlyDate(
        DateTime.now().year, DateTime.now().month, futureDay.toString());
    if (billedToday.isAfter(DateTime.now())) {
      expect(futureBills.items, isEmpty);
    }

    // TC-BIL-004: plan berakhir → tidak generate lagi.
    final endedPlan = await plans().savePlan(
      accountId: base.transportId,
      name: 'Berakhir',
      amount: 50000,
      period: 'monthly',
      billedSchedule: DateTime.now().day.toString(),
      dueDateSchedule: 'last_day',
      reminderDays: 0,
      endedAt: DateTime.now().subtract(const Duration(days: 1)),
      bulkCreate: false,
    );
    await bills().synchronizeBills();
    final endedBills = await bills().getBills(
      pagination: const Pagination(page: 1, limit: 10),
      filter: BillFilter(billPlanId: endedPlan.id),
    );
    expect(endedBills.items, isEmpty);
  });

  test('TC-BIL-005/006 seksi daftar bayar + search', () async {
    final base = await seedBaseData();
    final db = await getIt<DbService>().database;
    final plan = await monthlyPlan(accountId: base.makanId, reminderDays: 0);

    // Satu unpaid dalam jendela reminder (attention), satu jauh tempo.
    final sec = nowSec();
    await db.insert(billTable, {
      BillKey.billPlanId: plan.id,
      BillKey.amount: 100000,
      BillKey.billPeriod: '2026-01',
      BillKey.billedAt: sec - 86400,
      BillKey.dueDate: sec + 2 * 86400,
      BillKey.remindedAt: sec - 86400,
      BillKey.status: BillStatus.unpaid.value,
      BillKey.isDeleted: 0,
    });

    final cubit = getIt<BillCubit>();
    await cubit.fetch();
    await cubit.close();
    final state = cubit.state;
    state.maybeWhen(
      loaded: (attention, upcoming, recentPaid) {
        // TC-BIL-005: reminder-tiba masuk Perlu Dibayar.
        expect(attention.map((b) => b.billPeriod), contains('2026-01'));
        expect(recentPaid, isEmpty);
      },
      orElse: () => fail('BillCubit harus loaded'),
    );

    // TC-BIL-006: search nama plan case-insensitive.
    final hit = await bills().getActiveBills(planKeyword: 'LISTRIK');
    expect(hit, isNotEmpty);
    final miss = await bills().getActiveBills(planKeyword: 'xyz-tidak-ada');
    expect(miss, isEmpty);
    final all = await bills().getActiveBills(planKeyword: '  ');
    expect(all.length, greaterThanOrEqualTo(1));
  });

  test('TC-BIL-009/010/018 + TC-BIL-008 status model detail', () async {
    final base = await seedBaseData();
    final now = DateTime.now();
    final sec = nowSec();
    const day = 86400;

    Bill make(String status, int remindedAt, int dueDate) => Bill(
          id: 1,
          billPlanId: 1,
          amount: 100000,
          billPeriod: '2026-09',
          billedAt: remindedAt - day,
          dueDate: dueDate,
          remindedAt: remindedAt,
          status: status,
        );

    // TC-BIL-009: unpaid bisa dibayar.
    final unpaid = make(BillStatus.unpaid.value, sec - day, sec + 2 * day);
    expect(unpaid.canPay, isTrue);
    expect(unpaid.isDueReminderAt(now), isTrue);

    // TC-BIL-010: drafted tidak bisa dibayar.
    final drafted = make(BillStatus.drafted.value, sec - day, sec - day);
    expect(drafted.canPay, isFalse);
    expect(drafted.isOverdueAt(now), isFalse);
    expect(drafted.isDueReminderAt(now), isFalse);

    // TC-BIL-008: lewat tempo → overdue + tetap bisa dibayar (pengingat,
    // bukan penilai). Label badge mengikuti cabang unpaid (catat aktual).
    final overdue = make(BillStatus.unpaid.value, sec - 5 * day, sec - day);
    expect(overdue.isOverdueAt(now), isTrue);
    expect(overdue.isDueReminderAt(now), isFalse);
    expect(overdue.canPay, isTrue);

    // TC-BLP-015: reminder mati (reminded == due) → tak pernah jendela.
    final silent = make(BillStatus.unpaid.value, sec + 5 * day, sec + 5 * day);
    expect(silent.isDueReminderAt(now), isFalse);

    // TC-BIL-009/018 riwayat: dibuat + pembayaran (2 entri, terbaru dulu).
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getActiveBills()).single;
    expect(await bills().getBillJournals(bill.id), hasLength(1));
    await fundAsset(base.bca.id, 500000);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);
    final history = await bills().getBillJournals(bill.id);
    expect(history, hasLength(2));
    expect(
      history.map((j) => j.source),
      containsAll(
          [JournalSource.billGenerated, JournalSource.billPayment]),
    );
  });

  test('TC-BIL-011/012/015/016/017 bayar dari Dompet + efek samping',
      () async {
    final base = await seedBaseData();
    final t0 = await totalUang();

    Future<int> freshBill(int amount) async {
      final plan = await monthlyPlan(
        accountId: base.makanId,
        name: 'Tagihan $amount',
        amount: amount,
      );
      await bills().synchronizeBills();
      return (await bills().getBillByPlanAndPeriod(
              plan.id,
              BillSchedule.billPeriodFor(
                  DateTime.now(), 'monthly')))!
          .id;
    }

    // TC-BIL-011: saldo cukup → 1 jurnal payment, tanpa adjustment.
    await fundAsset(base.bca.id, 500000);
    final b0 = await balanceOf(base.bca.id);
    final id1 = await freshBill(100000);
    final jc0 = await journalCount();
    await bills().payBill(billId: id1, assetId: base.bca.id);
    expect((await bills().getBillById(id1))?.status, BillStatus.paid.value);
    expect(await balanceOf(base.bca.id), b0 - 100000);
    expect(await totalUang(), t0 + 500000 - 100000);
    expect(await bills().getPendingTotal(), 0);
    expect(await journalCount(), jc0 + 1);
    // TC-BIL-019: selalu lunas penuh (API tanpa parameter cicilan).
    final lines = await bills().getBillJournals(id1);
    expect(lines.map((j) => j.source),
        contains(JournalSource.billPayment));

    // TC-BIL-012: saldo kurang → adjustment selisih + payment, floor 0.
    final tunai0 = await balanceOf(base.tunai.id);
    final id2 = await freshBill(tunai0 + 50000);
    await bills().payBill(billId: id2, assetId: base.tunai.id);
    expect(await balanceOf(base.tunai.id), 0);
    final adjustments = await journalCount(source: 'adjustment');
    expect(adjustments, 1);

    // TC-BIL-015: bayar dua kali ditolak, tanpa jurnal baru.
    final jc1 = await journalCount();
    expect(
      () => bills().payBill(billId: id1, assetId: base.bca.id),
      throwsException,
    );
    expect(await journalCount(), jc1);

    // TC-BIL-016: draft tidak bisa dibayar.
    final db = await getIt<DbService>().database;
    final draftId = await db.insert(billTable, {
      BillKey.billPlanId: 1,
      BillKey.amount: 10000,
      BillKey.billPeriod: '2099-01',
      BillKey.billedAt: secPlus(30),
      BillKey.dueDate: secPlus(35),
      BillKey.remindedAt: secPlus(33),
      BillKey.status: BillStatus.drafted.value,
      BillKey.isDeleted: 0,
    });
    expect(
      () => bills().payBill(billId: draftId, assetId: base.bca.id),
      throwsException,
    );

    // TC-BIL-017: dompet / tagihan tak dikenal.
    expect(
      () => bills().payBill(billId: id1, assetId: 999999),
      throwsException,
    );
    expect(
      () => bills().payBill(billId: 999999, assetId: base.bca.id),
      throwsException,
    );
  });

  test('TC-BINT-004/005/008 anggaran, laporan, konsistensi Total', () async {
    final base = await seedBaseData();
    final now = DateTime.now();
    final period = ReportPeriod(year: now.year, month: now.month);
    final t0 = await totalUang();

    // Baseline laporan: 1 pengeluaran biasa Rp50.000.
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: await balanceOf(base.bca.id),
      categoryId: base.makanId,
      amount: 50000,
    );
    final budget0 = (await getIt<BudgetRepository>().getBudgetsForMonth(period))
        .firstWhere((b) => b.accountId == base.makanId);

    // Generate tagihan Listrik Rp100.000.
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();

    // TC-BINT-004: bill_generated ikut actualSpend anggaran.
    final budget1 = (await getIt<BudgetRepository>().getBudgetsForMonth(period))
        .firstWhere((b) => b.accountId == base.makanId);
    expect(budget1.actualSpend, budget0.actualSpend + 100000);

    // TC-BINT-008 rantai: generate tidak gerakkan Total.
    expect(await totalUang(), t0 - 50000);

    // Bayar dari BCA.
    final bill = (await bills().getActiveBills()).single;
    await fundAsset(base.bca.id, 200000);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);

    // TC-BINT-004: payment tidak double-count spend.
    final budget2 = (await getIt<BudgetRepository>().getBudgetsForMonth(period))
        .firstWhere((b) => b.accountId == base.makanId);
    expect(budget2.actualSpend, budget1.actualSpend);

    // TC-BINT-005: laporan & ringkasan kecualikan Tagihan.
    final summary =
        await getIt<ReportRepository>().getMonthlySummary(period);
    expect(summary.expense, 50000);
    expect(summary.income, 0);
    expect(summary.transactionCount, 1);
    final dash =
        await getIt<DashboardRepository>().getTransactionSummary();
    expect(dash.expense, 50000);
    expect(dash.income, 0);

    // TC-BINT-008: Total = t0 − 50k (belanja) + 200k (dana uji) − 100k (bayar).
    expect(await totalUang(), t0 - 50000 + 200000 - 100000);
  });

  test('TC-SNK-002/004/005 link target + stale + samakan', () async {
    final base = await seedBaseData();
    final year = DateTime.now().year.toString();
    final plan = await yearlyPlan(accountId: base.makanId);

    // TC-SNK-002: belum ada target → null (syarat tawaran dialog).
    expect(await getIt<SavingRepository>().getLinkedTarget(plan.id, year),
        isNull);

    final target = await getIt<SavingRepository>().createPocket(
      name: 'Dana Pajak Motor',
      targetAmount: 1200000,
      targetDate: DateTime.now()
              .add(const Duration(days: 5))
              .millisecondsSinceEpoch ~/
          1000,
      billPlanId: plan.id,
      billPeriod: year,
    );
    // TC-SNK-004: link ditemukan untuk kemunculan terdekat.
    final linked =
        await getIt<SavingRepository>().getLinkedTarget(plan.id, year);
    expect(linked, isNotNull);
    expect(linked!.accountId, target.accountId);

    // TC-SNK-005: nominal berubah → stale → Samakan.
    await plans().savePlan(
      id: plan.id,
      accountId: base.makanId,
      name: 'Pajak Motor',
      amount: 1500000,
      period: 'yearly',
      billedSchedule: plan.billedSchedule,
      dueDateSchedule: plan.dueDateSchedule,
      reminderDays: 0,
      bulkCreate: false,
    );
    final stale =
        await getIt<SavingRepository>().getLinkedTarget(plan.id, year);
    expect(stale!.targetAmount, 1200000);
    expect(stale.targetAmount != 1500000, isTrue);
    await getIt<SavingRepository>().updateTargetAmount(
      accountId: target.accountId,
      targetAmount: 1500000,
    );
    final synced =
        await getIt<SavingRepository>().getLinkedTarget(plan.id, year);
    expect(synced!.targetAmount, 1500000);
  });

  test('TC-SNK-006/008/009/011 bayar dari Target + guard', () async {
    final base = await seedBaseData();
    final t0 = await totalUang();
    final year = DateTime.now().year.toString();
    final plan = await yearlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getBillByPlanAndPeriod(plan.id, year))!;
    final target = await getIt<SavingRepository>().createPocket(
      name: 'Dana Pajak Motor',
      targetAmount: 1200000,
      billPlanId: plan.id,
      billPeriod: year,
    );

    // TC-SNK-011: periode tanpa bill → null (belum tergenerate).
    expect(
        await bills().getBillByPlanAndPeriod(plan.id, '2099'), isNull);

    // TC-SNK-008: saldo kurang → gagal atomik, 0 jurnal.
    final jc0 = await journalCount();
    expect(
      () => bills().payBillFromPocket(
        billId: bill.id,
        pocketId: target.accountId,
        assetId: base.bca.id,
      ),
      throwsException,
    );
    expect(await journalCount(), jc0);
    expect((await bills().getBillById(bill.id))?.status,
        BillStatus.unpaid.value);

    // TC-SNK-009: target sisihan tidak bisa dibelanjakan.
    expect(
      () => getIt<SavingRepository>().spend(
        pocketId: target.accountId,
        assetId: base.bca.id,
        amount: 10000,
      ),
      throwsException,
    );

    // TC-SNK-006/010: saldo cukup → 2 jurnal, dompet neto 0, Total tetap.
    await getIt<SavingRepository>().topup(
      pocketId: target.accountId,
      assetId: base.bca.id,
      amount: 1200000,
    );
    final b0 = await balanceOf(base.bca.id);
    final g0 = (await getIt<SavingRepository>().getByAccountId(
            target.accountId))!
        .balance;
    final t1 = await totalUang();
    await bills().payBillFromPocket(
      billId: bill.id,
      pocketId: target.accountId,
      assetId: base.bca.id,
    );
    expect((await bills().getBillById(bill.id))?.status,
        BillStatus.paid.value);
    expect(await balanceOf(base.bca.id), b0);
    expect(
        (await getIt<SavingRepository>().getByAccountId(target.accountId))!
            .balance,
        g0 - 1200000);
    expect(await totalUang(), t1);
    expect(await journalCount(), jc0 + 3); // topup + withdraw + payment.
    // Topup memindahkan kas → pocket non-cair: Total turun 1,2jt duluan.
    expect(t1, t0 - 1200000);
  });

  test('TC-BINT-001 banner tertunda = total unpaid', () async {
    final base = await seedBaseData();
    expect(await pendingBillsTotal(), 0);
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    // Banner tampil bila > 0 (aturan total <= 0 → sembunyi milik widget).
    expect(await pendingBillsTotal(), 100000);
    final bill = (await bills().getActiveBills()).single;
    await fundAsset(base.bca.id, 500000);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);
    expect(await pendingBillsTotal(), 0);
  });

  test('TC-BINT-003 aktivitas: payment terfilter Tagihan, generated bukan Pengeluaran',
      () async {
    final base = await seedBaseData();
    const page = Pagination(page: 1, limit: 20);
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getActiveBills()).single;

    // Generated tampil di Semua, tapi BUKAN di filter Pengeluaran
    // (filter mengunci source = transaction).
    final all =
        await getIt<JournalRepository>().getJournals(pagination: page);
    expect(
        all.items.map((j) => j.source),
        contains(JournalSource.billGenerated));
    final asExpense = await getIt<JournalRepository>().getJournals(
      pagination: page,
      filter: const JournalFilter(type: ActivityType.expense),
    );
    expect(asExpense.items.map((j) => j.source),
        isNot(contains(JournalSource.billGenerated)));

    // Payment tampil di filter Tagihan.
    await fundAsset(base.bca.id, 500000);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);
    final asBill = await getIt<JournalRepository>().getJournals(
      pagination: page,
      filter: const JournalFilter(type: ActivityType.billPayment),
    );
    expect(asBill.items, hasLength(1));
    expect(asBill.items.single.source, JournalSource.billPayment);
  });

  test('TC-BINT-006 void payment mengembalikan bill ke unpaid', () async {
    final base = await seedBaseData();
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getActiveBills()).single;
    await fundAsset(base.bca.id, 500000);
    final b0 = await balanceOf(base.bca.id);
    final t0 = await totalUang();
    await bills().payBill(billId: bill.id, assetId: base.bca.id);

    // Hapus dari detail aktivitas = void jurnal payment.
    final payment = (await bills().getBillJournals(bill.id))
        .firstWhere((j) => j.source == JournalSource.billPayment);
    await voidJournal(payment.id);

    // Saldo kembali + bill unpaid lagi + bisa dibayar ulang.
    expect(await balanceOf(base.bca.id), b0);
    expect(await totalUang(), t0);
    final revived = await bills().getBillById(bill.id);
    expect(revived?.status, BillStatus.unpaid.value);
    expect(revived?.canPay, isTrue);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);
    expect((await bills().getBillById(bill.id))?.status,
        BillStatus.paid.value);
  });

  test('TC-BINT-007 form Perbaiki payment kosong (tombol disembunyikan)',
      () async {
    final base = await seedBaseData();
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getActiveBills()).single;
    await fundAsset(base.bca.id, 500000);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);

    // Jurnal payment hanya menyentuh payable + asset → tidak ada baris
    // kategori income/expense untuk dipetakan ke form transaksi.
    final journals = await getIt<JournalRepository>().getJournals(
      pagination: const Pagination(page: 1, limit: 5),
      filter: const JournalFilter(type: ActivityType.billPayment),
    );
    final form = journals.items.single.toTransactionForm();
    expect(form.categories, isEmpty);
    // Konsekuensi: Perbaiki harus disembunyikan untuk billPayment
    // (lihat activity_detail_page), bukan membuka form expense kosong.
  });

  test('TC-BSCH-001/002 kalender: clamp bulan pendek + yearly', () {
    // TC-BSCH-001: hari > umur bulan di-clamp; due tak mendahului billed.
    final feb = BillSchedule.monthlyDate(2026, 2, '31');
    expect((feb.month, feb.day), (2, 28));
    final febLeap = BillSchedule.monthlyDate(2024, 2, '30');
    expect((febLeap.month, febLeap.day), (2, 29));
    final last = BillSchedule.monthlyDate(2026, 2, 'last_day');
    expect((last.month, last.day), (2, 28));
    final apr = BillSchedule.monthlyDate(2026, 4, '31');
    expect((apr.month, apr.day), (4, 30));

    // TC-BSCH-002: 29 Feb non-kabisat dinormalisasi DateTime (catat aktual).
    final feb29 = BillSchedule.yearlyDate(2026, '02-29');
    expect((feb29.month, feb29.day), (3, 1));
    // Due lintas tahun selalu setelah billed.
    final billed = BillSchedule.yearlyDate(2026, '12-20');
    final due = BillSchedule.dueDateFor(billed, 'yearly', '01-05');
    expect(due.isAfter(billed), isTrue);
    expect(BillSchedule.billPeriodFor(billed, 'yearly'), '2026');
    expect(BillSchedule.billPeriodFor(DateTime(2026, 9, 15), 'monthly'),
        '2026-09');
  });

  test('TC-BSCH-004/005 nominal raksasa + nama panjang/emoji', () async {
    final base = await seedBaseData();

    // TC-BSCH-005: tersimpan tanpa crash.
    final emoji = await monthlyPlan(
      accountId: base.makanId,
      name: '💰 ${'Liburan Panjang ' * 7}X',
      amount: 100000,
    );
    expect(emoji.name.length, greaterThan(100));

    // TC-BSCH-004: generate + bayar presisi penuh.
    const huge = 999999999999;
    final today = DateTime.now();
    final plan = await plans().savePlan(
      accountId: base.transportId,
      name: 'Raksasa',
      amount: huge,
      period: 'monthly',
      billedSchedule: today.day.toString(),
      dueDateSchedule: 'last_day',
      reminderDays: 0,
      bulkCreate: false,
    );
    await bills().synchronizeBills();
    final bill = await bills().getBillByPlanAndPeriod(
        plan.id, BillSchedule.billPeriodFor(today, 'monthly'));
    expect(bill, isNotNull);
    expect(bill!.amount, huge);
    await fundAsset(base.bca.id, huge);
    final b0 = await balanceOf(base.bca.id);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);
    expect(await balanceOf(base.bca.id), b0 - huge);
  });

  testWidgets('TC-BINT-009 jurnal generated read-only di detail aktivitas',
      (tester) async {
    await initializeDateFormatting('id');
    final base = await seedBaseData();
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getActiveBills()).single;
    final gen = (await bills().getBillJournals(bill.id))
        .singleWhere((j) => j.source == JournalSource.billGenerated);

    // Akrual sistem: kelola via Tagihan Rutin, bukan dari Aktivitas.
    await pumpPage(tester, ActivityDetailPage(id: gen.id));
    await settleUntil(tester, find.text('Pengeluaran'));
    expect(find.text('Perbaiki'), findsNothing);
    expect(find.text('Hapus'), findsNothing);
  });

  testWidgets('TC-BINT-006/007 kontrol: payment ada Hapus tanpa Perbaiki',
      (tester) async {
    await initializeDateFormatting('id');
    final base = await seedBaseData();
    await monthlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getActiveBills()).single;
    await fundAsset(base.bca.id, 500000);
    await bills().payBill(billId: bill.id, assetId: base.bca.id);
    final payment = (await bills().getBillJournals(bill.id))
        .singleWhere((j) => j.source == JournalSource.billPayment);

    await pumpPage(tester, ActivityDetailPage(id: payment.id));
    await settleUntil(tester, find.text('Tagihan'));
    expect(find.text('Perbaiki'), findsNothing);
    expect(find.text('Hapus'), findsOneWidget);
  });

  test('TC-BINT-010 void kaki withdraw bayar-dari-Target cascade penuh',
      () async {
    final base = await seedBaseData();
    final year = DateTime.now().year.toString();
    final plan = await yearlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getBillByPlanAndPeriod(plan.id, year))!;
    final target = await getIt<SavingRepository>().createPocket(
      name: 'Dana Pajak Motor',
      targetAmount: 1200000,
      billPlanId: plan.id,
      billPeriod: year,
    );
    await getIt<SavingRepository>().topup(
      pocketId: target.accountId,
      assetId: base.bca.id,
      amount: 1200000,
    );
    final bPre = await balanceOf(base.bca.id);
    final gPre = (await getIt<SavingRepository>().getByAccountId(
            target.accountId))!
        .balance;
    final tPre = await totalUang();

    // Tarik biasa tetap bukan J1 (tak terkunci, void simetris).
    final plainId = await getIt<SavingRepository>().withdraw(
      pocketId: target.accountId,
      assetId: base.bca.id,
      amount: 50000,
    );
    final plain = (await getIt<SavingRepository>().getPocketJournals(
            target.accountId))
        .firstWhere((j) => j.id == plainId);
    expect(plain.isBillLinkedWithdraw, isFalse);
    await voidJournal(plain.id);
    // Void tarik biasa simetris: kembali ke saldo setelah topup.
    expect(
        (await getIt<SavingRepository>().getByAccountId(target.accountId))!
            .balance,
        gPre);

    await bills().payBillFromPocket(
      billId: bill.id,
      pocketId: target.accountId,
      assetId: base.bca.id,
    );

    // J1 teridentifikasi via metadata bill_id (bukan heuristik).
    final j1 = (await getIt<SavingRepository>().getPocketJournals(
            target.accountId))
        .firstWhere((j) => j.isBillLinkedWithdraw);
    expect(j1.isBillLinkedWithdraw, isTrue);

    // Void J1 = undo penuh: J1+J2 void, bill unpaid, saldo presisi kembali.
    final jc0 = await journalCount();
    await voidJournal(j1.id);
    expect((await bills().getBillById(bill.id))?.status,
        BillStatus.unpaid.value);
    expect((await bills().getBillById(bill.id))?.canPay, isTrue);
    final j2 = (await bills().getBillJournals(bill.id))
        .firstWhere((j) => j.source == JournalSource.billPayment);
    expect(j2.status, JournalStatus.voided);
    expect(await balanceOf(base.bca.id), bPre);
    expect(
        (await getIt<SavingRepository>().getByAccountId(target.accountId))!
            .balance,
        gPre);
    expect(await totalUang(), tPre);
    expect(await journalCount(), jc0 - 2);
    // Bisa dibayar ulang setelah undo.
    await bills().payBillFromPocket(
      billId: bill.id,
      pocketId: target.accountId,
      assetId: base.bca.id,
    );
    expect((await bills().getBillById(bill.id))?.status,
        BillStatus.paid.value);
  });

  testWidgets('TC-BINT-010 detail J1 terkunci, Tarik biasa tidak',
      (tester) async {
    await initializeDateFormatting('id');
    final base = await seedBaseData();
    final year = DateTime.now().year.toString();
    final plan = await yearlyPlan(accountId: base.makanId);
    await bills().synchronizeBills();
    final bill = (await bills().getBillByPlanAndPeriod(plan.id, year))!;
    final target = await getIt<SavingRepository>().createPocket(
      name: 'Dana Pajak Motor',
      targetAmount: 1200000,
      billPlanId: plan.id,
      billPeriod: year,
    );
    await getIt<SavingRepository>().topup(
      pocketId: target.accountId,
      assetId: base.bca.id,
      amount: 1200000,
    );
    await bills().payBillFromPocket(
      billId: bill.id,
      pocketId: target.accountId,
      assetId: base.bca.id,
    );
    final j1 = (await getIt<SavingRepository>().getPocketJournals(
            target.accountId))
        .firstWhere((j) => j.isBillLinkedWithdraw);

    // J1: tanpa Perbaiki maupun Hapus.
    await pumpPage(tester, ActivityDetailPage(id: j1.id));
    await settleUntil(tester, find.text('Pindah dana'));
    expect(find.text('Perbaiki'), findsNothing);
    expect(find.text('Hapus'), findsNothing);
  });

  testWidgets('TC-BINT-010 kontrol: Tarik biasa tetap bisa ubah/hapus',
      (tester) async {
    await initializeDateFormatting('id');
    final base = await seedBaseData();
    final target = await getIt<SavingRepository>().createPocket(
      name: 'Dana Biasa',
      targetAmount: 1000000,
    );
    await getIt<SavingRepository>().topup(
      pocketId: target.accountId,
      assetId: base.bca.id,
      amount: 500000,
    );
    await getIt<SavingRepository>().withdraw(
      pocketId: target.accountId,
      assetId: base.bca.id,
      amount: 50000,
    );
    final plain = (await getIt<SavingRepository>().getPocketJournals(
            target.accountId))
        .firstWhere((j) => !j.isBillLinkedWithdraw);

    await pumpPage(tester, ActivityDetailPage(id: plain.id));
    await settleUntil(tester, find.text('Pindah dana'));
    expect(find.text('Perbaiki'), findsOneWidget);
    expect(find.text('Hapus'), findsOneWidget);
  });

  testWidgets('TC-BIL-007 badge status tile sama dengan chip detail',
      (tester) async {
    await initializeDateFormatting('id');
    Bill tile(String status, int remindedAt, int dueDate) => Bill(
          id: 1,
          billPlanId: 1,
          amount: 100000,
          billPeriod: '2026-09',
          billedAt: remindedAt - 86400,
          dueDate: dueDate,
          remindedAt: remindedAt,
          status: status,
        );
    final sec = nowSec();
    const day = 86400;

    Future<void> shows(String status, int remindedAt, int dueDate,
        String label) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: BillTile(
                  bill: tile(status, remindedAt, dueDate))),
        ),
      );
      await tester.pump();
      expect(find.text(label), findsOneWidget);
    }

    await shows(BillStatus.drafted.value, sec - day, sec + day, 'Terjadwal');
    await shows(BillStatus.unpaid.value, sec + 5 * day, sec + 9 * day,
        'Belum dibayar');
    await shows(BillStatus.unpaid.value, sec - day, sec + 2 * day,
        'Segera dibayar');
    await shows(
        BillStatus.paid.value, sec - 5 * day, sec - day, 'Lunas');
    // Perilaku aktual: overdue (turunan waktu, tak tersimpan) mengikuti
    // cabang unpaid → 'Belum dibayar', bukan 'Terlambat'.
    await shows(BillStatus.unpaid.value, sec - 5 * day, sec - day,
        'Belum dibayar');
  });
}

int secPlus(int days) =>
    DateTime.now().millisecondsSinceEpoch ~/ 1000 + days * 86400;
