import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/savings/cubits/saving_action_cubit.dart';
import 'package:dompet_app/features/savings/forms/saving_plan_form.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

void main() {
  late DbService dbService;

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  test('targetDate disimpan sebagai akhir hari (23:59)', () async {
    final cubit = SavingActionCubit(SavingRepository(dbService));
    addTearDown(cubit.close);

    final form = SavingPlanForm()
      ..nameControl.updateValue('VGA')
      ..targetDateControl.updateValue(DateTime(2026, 9, 4, 10, 30));

    final plan = await cubit.createPocket(form: form);

    expect(plan, isNotNull);
    expect(
      plan!.targetDate,
      DateTime(2026, 9, 4).endOfDay.secondsSinceEpoch,
    );

    final stored = DateTime.fromMillisecondsSinceEpoch(plan.targetDate! * 1000);
    expect(stored.day, 4);
    expect(stored.hour, 23);
    expect(stored.minute, 59);
  });

  test('updatePlan menormalkan targetDate ke akhir hari', () async {
    final cubit = SavingActionCubit(SavingRepository(dbService));
    addTearDown(cubit.close);

    final createForm = SavingPlanForm()
      ..nameControl.updateValue('VGA');
    final created = await cubit.createPocket(form: createForm);
    expect(created, isNotNull);

    final editForm = SavingPlanForm()
      ..nameControl.updateValue('VGA')
      ..targetDateControl.updateValue(DateTime(2026, 10, 1, 8, 0));
    final updated = await cubit.updatePlan(
      accountId: created!.accountId,
      form: editForm,
    );

    expect(updated, isNotNull);
    expect(
      updated!.targetDate,
      DateTime(2026, 10, 1).endOfDay.secondsSinceEpoch,
    );
  });
}
