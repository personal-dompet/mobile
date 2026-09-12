import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

void main() {
  test('getRemindedCounts pisah hampir-tempo vs lewat-tempo', () async {
    final dbService = await createTestDbService();
    addTearDown(() => disposeTestDbService(dbService));

    final form = CategoryForm();
    form.nameControl.updateValue('Listrik');
    form.typeControl.updateValue(AccountType.expense);
    final account = await CategoryRepository(
      dbService,
    ).createCategory(form: form);
    final plan = await BillPlanRepository(dbService).savePlan(
      accountId: account.id,
      name: 'Listrik',
      amount: 100000,
      period: 'monthly',
      billedSchedule: '5',
      dueDateSchedule: '10',
      reminderDays: 3,
      bulkCreate: false,
    );

    final now = DateTime(2026, 9, 15, 12);
    final nowSec = now.millisecondsSinceEpoch ~/ 1000;
    const day = 86400;
    final db = await dbService.database;

    Future<void> seed(String status, int reminded, int due, String period) =>
        db.insert(billTable, {
          BillKey.billPlanId: plan.id,
          BillKey.amount: 100000,
          BillKey.billPeriod: period,
          BillKey.billedAt: reminded - day,
          BillKey.dueDate: due,
          BillKey.remindedAt: reminded,
          BillKey.status: status,
          BillKey.isDeleted: 0,
        });

    await seed(
      BillStatus.unpaid.value,
      nowSec - 5 * day,
      nowSec + 2 * day,
      '2026-09',
    );
    await seed(
      BillStatus.unpaid.value,
      nowSec - 5 * day,
      nowSec - day,
      '2026-08',
    );
    await seed(
      BillStatus.unpaid.value,
      nowSec + 2 * day,
      nowSec + 5 * day,
      '2026-10',
    );
    await seed(BillStatus.paid.value, nowSec - 5 * day, nowSec - day, '2026-07');
    await seed(
      BillStatus.drafted.value,
      nowSec - 5 * day,
      nowSec + 2 * day,
      '2026-11',
    );

    final counts = await BillRepository(
      dbService,
    ).getRemindedCounts(now: now);

    expect(counts.dueSoon, 1);
    expect(counts.overdue, 1);
  });
}
