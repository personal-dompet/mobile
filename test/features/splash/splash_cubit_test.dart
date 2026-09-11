import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/splash/cubits/splash_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

class _FailingBillRepository extends BillRepository {
  // Super field privat (_dbService), tak bisa pakai super-parameter.
  // ignore: use_super_parameters
  _FailingBillRepository(DbService db) : super(db);

  @override
  Future<int> synchronizeBills({DateTime? now}) =>
      throw Exception('sync gagal');
}

/// Splash memicu sinkronisasi malas tagihan (TC-BIL-020):
/// akun belum ada → needToBeSet tanpa sync; akun ada → sync lalu
/// alreadySet; sync gagal → error (blokir navigasi, bukan diam-diam lolos).
void main() {
  late DbService dbService;

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  Future<int> createExpenseCategory(String name) async {
    final form = CategoryForm();
    form.nameControl.updateValue(name);
    form.typeControl.updateValue(AccountType.expense);
    final account = await CategoryRepository(
      dbService,
    ).createCategory(form: form);
    return account.id;
  }

  Future<void> createWallet() async {
    final form = AssetForm()
      ..nameControl.updateValue('Tunai')
      ..codeControl.updateValue(AccountPreset.cash.code);
    await AssetRepository(dbService).createAsset(form);
  }

  test('belum ada dompet → needToBeSet, sync tidak jalan', () async {
    final cubit = SplashCubit(
      AccountRepository(dbService),
      BillRepository(dbService),
    );
    addTearDown(cubit.close);

    await cubit.check();

    expect(cubit.state, const SplashState.needToBeSet());
    expect(await BillRepository(dbService).getPendingTotal(), 0);
  });

  test('dompet ada → sync generate periode berjalan lalu alreadySet',
      () async {
    await createWallet();
    final categoryId = await createExpenseCategory('Listrik');
    final today = DateTime.now();
    await BillPlanRepository(dbService).savePlan(
      accountId: categoryId,
      name: 'Listrik Rumah',
      amount: 100000,
      period: 'monthly',
      billedSchedule: today.day.toString(),
      dueDateSchedule: 'last_day',
      reminderDays: 0,
      bulkCreate: false,
    );

    final cubit = SplashCubit(
      AccountRepository(dbService),
      BillRepository(dbService),
    );
    addTearDown(cubit.close);

    await cubit.check();

    expect(cubit.state, const SplashState.alreadySet());
    final actives = await BillRepository(dbService).getActiveBills();
    expect(actives, hasLength(1));
    expect(actives.single.status, BillStatus.unpaid.value);
  });

  test('sync gagal → error (blokir navigasi)', () async {
    await createWallet();
    final cubit = SplashCubit(
      AccountRepository(dbService),
      _FailingBillRepository(dbService),
    );
    addTearDown(cubit.close);

    await cubit.check();

    expect(cubit.state, isA<SplashState>().having(
      (s) => s.maybeWhen(orElse: () => '', error: (m) => m),
      'message',
      contains('sync gagal'),
    ));
  });
}
