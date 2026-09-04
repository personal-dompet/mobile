import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/cubits/saving_action_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_detail_cubit.dart';
import 'package:dompet_app/features/savings/forms/saving_plan_form.dart';
import 'package:dompet_app/features/savings/models/saving_detail.dart';
import 'package:dompet_app/features/savings/models/saving_insight.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/test_db.dart';

void main() {
  late DbService dbService;
  late Database db;
  late SavingRepository repository;
  late SavingDetailCubit cubit;

  setUp(() async {
    dbService = await createTestDbService();
    db = await dbService.database;
    repository = SavingRepository(dbService);
    cubit = SavingDetailCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await disposeTestDbService(dbService);
  });

  Future<int> accountIdByCode(String code) async {
    final result = await db.query(
      accountTable,
      where: '${AccountKey.code} = ?',
      whereArgs: [code],
      limit: 1,
    );
    return result.first[AccountKey.id] as int;
  }

  Future<void> fundAsset(int assetId, int amount) async {
    final initialId = await accountIdByCode(
      AccountPreset.intialBalance.code,
    );
    final entryId = await db.insert(journalEntryTable, {
      JournalEntryKey.entryDate:
          DateTime(2026, 1, 1).millisecondsSinceEpoch ~/ 1000,
      JournalEntryKey.source: JournalSource.setup.value,
      JournalEntryKey.description: 'fund test asset',
      JournalEntryKey.status: JournalStatus.posted.name,
    });
    await db.insert(journalLineTable, {
      JournalLineKey.journalEntryId: entryId,
      JournalLineKey.accountId: assetId,
      JournalLineKey.debitAmount: amount,
      JournalLineKey.creditAmount: 0,
      JournalLineKey.lineOrder: 0,
    });
    await db.insert(journalLineTable, {
      JournalLineKey.journalEntryId: entryId,
      JournalLineKey.accountId: initialId,
      JournalLineKey.debitAmount: 0,
      JournalLineKey.creditAmount: amount,
      JournalLineKey.lineOrder: 1,
    });
  }

  SavingDetail loadedOf(SavingDetailCubit c) {
    return c.state.maybeWhen(
      loaded: (detail) => detail,
      orElse: () => throw StateError('expected loaded, got ${c.state}'),
    );
  }

  test('tanpa target -> tambah nominal -> insight berubah', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    // Target tanpa nominal + 2 alokasi.
    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 1000000,
      date: DateTime(2026, 8, 27, 10),
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 500000,
      date: DateTime(2026, 9, 1, 10),
    );

    await cubit.fetch(plan.accountId);
    expect(
      loadedOf(cubit).insight.status,
      SavingInsightStatus.noTarget,
    );

    // Simulasi simpan form: tambah nominal target.
    final updated = await repository.updatePlan(
      accountId: plan.accountId,
      name: 'VGA',
      targetAmount: 10000000,
    );
    expect(updated?.targetAmount, 10000000);
    expect(updated?.hasTarget, isTrue);

    await cubit.fetch(plan.accountId);
    final detail = loadedOf(cubit);
    expect(detail.plan.hasTarget, isTrue);
    expect(detail.plan.targetAmount, 10000000);
    expect(detail.insight.status, SavingInsightStatus.projected);
  });

  test('punya nominal -> hapus nominal -> insight kembali tanpa target',
      () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(
      name: 'VGA',
      targetAmount: 10000000,
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 1000000,
      date: DateTime(2026, 8, 27, 10),
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 500000,
      date: DateTime(2026, 9, 1, 10),
    );

    await cubit.fetch(plan.accountId);
    expect(
      loadedOf(cubit).insight.status,
      SavingInsightStatus.projected,
    );

    await repository.updatePlan(
      accountId: plan.accountId,
      name: 'VGA',
      targetAmount: null,
    );

    await cubit.fetch(plan.accountId);
    final detail = loadedOf(cubit);
    expect(detail.plan.hasTarget, isFalse);
    expect(detail.insight.status, SavingInsightStatus.noTarget);
  });

  test('submit form dari null -> nominal (jalur _submit)', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 1000000,
      date: DateTime(2026, 8, 27, 10),
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 500000,
      date: DateTime(2026, 9, 1, 10),
    );

    // Persis seperti initState SavingFormPage untuk pocket tanpa target.
    final form = SavingPlanForm();
    form.nameControl.value = plan.accountName;
    form.iconCodeControl.value = plan.iconCode;
    form.targetAmountControl.value = plan.targetAmount; // null
    form.targetDateControl.value = plan.targetDateTime;
    form.noteControl.value = plan.note;

    // Simulasi user mengetik nominal.
    form.targetAmountControl.updateValue(10000000);
    expect(form.valid, isTrue);

    // Persis seperti _submit -> cubit.updatePlan.
    final actionCubit = SavingActionCubit(repository);
    final saved = await actionCubit.updatePlan(
      accountId: plan.accountId,
      form: form,
    );
    await actionCubit.close();
    expect(saved?.targetAmount, 10000000);

    await cubit.fetch(plan.accountId);
    expect(loadedOf(cubit).insight.status, SavingInsightStatus.projected);
  });
}
