import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/fixture.dart';

/// Alur Dompet: daftar, tambah, validasi, ubah, arsip, pulihkan.
///
/// Menggabungkan:
/// - TC-DMP-001 s.d. TC-DMP-008, TC-DMP-012, TC-DMP-015/016/018/020
/// - TC-DSH-002 (Total Uang = jumlah dompet aktif cair)
///
/// Tidak diotomatiskan (butuh interaksi UI / manual):
/// - TC-DMP-009/010/011/021 (spasi-only, emoji, nominal raksasa, urutan counter)
/// - TC-DMP-013/014/017/019 (dialog detail & guard arsip terakhir di
///   asset_detail_page.dart — diverifikasi manual).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(resetFixture);
  tearDown(disposeFixture);

  AccountFilter activeLiquidFilter() =>
      const AccountFilter(isSystem: false, isLiqid: true, type: AccountType.asset);

  test(
    'TC-DMP-001/002 + TC-DSH-002 daftar, search, dan Total Uang',
    () async {
      final base = await seedBaseData();

      // TC-DSH-002: Tunai 1jt + BCA 5jt aktif cair.
      expect(await totalUang(), 6000000);

      // TC-DMP-001: daftar berisi kedua dompet dengan saldo benar.
      final accounts = await getIt<AccountRepository>().getAccounts(
        filter: activeLiquidFilter(),
      );
      expect(accounts.length, 2);
      final byName = {for (final a in accounts) a.name: a.balance};
      expect(byName['Tunai'], 1000000);
      expect(byName['BCA'], 5000000);
      expect(base.tunai.id, isNot(base.bca.id));

      // TC-DMP-002: search case-insensitive.
      final lower = await getIt<AccountRepository>().getAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
          name: 'bca',
        ),
      );
      expect(lower.map((a) => a.name), ['BCA']);

      final missing = await getIt<AccountRepository>().getAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
          name: 'xyz-tidak-ada',
        ),
      );
      expect(missing, isEmpty);
    },
  );

  test('TC-DMP-003/004 tambah dompet tanpa & dengan saldo awal', () async {
    await seedBaseData();
    final t0 = await totalUang();

    // TC-DMP-003: tanpa saldo awal — Total Uang tetap, saldo Rp0.
    final gopay = await createWallet(
      name: 'GoPay',
      preset: AccountPreset.eWallet,
    );
    expect(await balanceOf(gopay.id), 0);
    expect(await totalUang(), t0);

    // TC-DMP-004: dengan saldo awal Rp250.000 — Total Uang ikut naik.
    final ovo = await createWallet(
      name: 'OVO',
      preset: AccountPreset.eWallet,
      balance: 250000,
    );
    expect(await balanceOf(ovo.id), 250000);
    expect(await totalUang(), t0 + 250000);
  });

  test('TC-DMP-005/006/007 validasi tambah dompet ditolak', () async {
    await seedBaseData();

    // TC-DMP-005: nama kosong.
    final emptyName = AssetForm()
      ..codeControl.updateValue(AccountPreset.eWallet.code);
    expect(
      () => getIt<AssetRepository>().createAsset(emptyName),
      throwsException,
    );

    // TC-DMP-006: tanpa jenis.
    final noCode = AssetForm()..nameControl.updateValue('TanpaJenis');
    expect(
      () => getIt<AssetRepository>().createAsset(noCode),
      throwsException,
    );

    // TC-DMP-007: saldo negatif (validator: bulat >= 0).
    final negative = AssetForm()
      ..nameControl.updateValue('Negatif')
      ..codeControl.updateValue(AccountPreset.eWallet.code)
      ..balanceControl.updateValue(-50000);
    expect(negative.invalid, isTrue);
    expect(
      () => getIt<AssetRepository>().createAsset(negative),
      throwsException,
    );

    expect(await totalUang(), 6000000);
  });

  test('TC-DMP-008/012 duplikat diizinkan, ubah nama tak sentuh saldo',
      () async {
    await seedBaseData();
    final t0 = await totalUang();

    // TC-DMP-008: nama duplikat tersimpan dengan kode berbeda.
    final bca2 = await createWallet(
      name: 'BCA',
      preset: AccountPreset.bank,
    );
    expect(bca2.name, 'BCA');

    final accounts = await getIt<AccountRepository>().getAccounts(
      filter: activeLiquidFilter(),
    );
    final codes = accounts.map((a) => a.code).toSet();
    expect(codes.length, accounts.length);

    // TC-DMP-012: ubah nama & jenis — saldo & Total Uang tetap.
    final gopay = await createWallet(
      name: 'GoPay',
      preset: AccountPreset.eWallet,
      balance: 100000,
    );
    final edit = AssetForm()
      ..nameControl.updateValue('GoPay Baru')
      ..codeControl.updateValue(AccountPreset.bank.code);
    await getIt<AssetRepository>().updateAsset(form: edit, id: gopay.id);

    final updated = await getIt<AccountRepository>().getAccount(gopay.id);
    expect(updated?.name, 'GoPay Baru');
    expect(await balanceOf(gopay.id), 100000);
    expect(await totalUang(), t0 + 100000);
  });

  test('TC-DMP-015/016/018 arsip lalu pulihkan mengoreksi Total Uang',
      () async {
    final base = await seedBaseData();
    final t0 = await totalUang();

    // TC-DMP-015: arsip Tunai Rp1.000.000.
    await getIt<AccountRepository>().archiveAccount(base.tunai.id);
    expect(await totalUang(), t0 - 1000000);

    // Hilang dari daftar aktif tapi riwayat (baris DB) tetap ada.
    final active = await getIt<AccountRepository>().getAccounts(
      filter: activeLiquidFilter(),
    );
    expect(active.map((a) => a.id), isNot(contains(base.tunai.id)));
    final archived = await getIt<AccountRepository>()
        .getAccount(base.tunai.id);
    expect(archived?.isDeleted, isTrue);

    // TC-DMP-018: pulihkan — Total Uang kembali.
    await getIt<AccountRepository>().unarchiveAccount(base.tunai.id);
    expect(await totalUang(), t0);
    final restored = await getIt<AccountRepository>().getAccounts(
      filter: activeLiquidFilter(),
    );
    expect(restored.map((a) => a.id), contains(base.tunai.id));
  });

  test('TC-DMP-020 arsip dompet saldo Rp0 tak ubah Total Uang', () async {
    await seedBaseData();
    final t0 = await totalUang();

    final kosong = await createWallet(
      name: 'Kosong',
      preset: AccountPreset.eWallet,
    );
    await getIt<AccountRepository>().archiveAccount(kosong.id);

    expect(await totalUang(), t0);
  });

  test('TC-DMP-009/013 nama spasi & update tanpa nama ditolak', () async {
    await seedBaseData();

    // TC-DMP-009: nama spasi saja setara kosong (validator me-trim).
    final spaces = AssetForm()
      ..nameControl.updateValue('   ')
      ..codeControl.updateValue(AccountPreset.eWallet.code);
    expect(spaces.invalid, isTrue);
    expect(
      () => getIt<AssetRepository>().createAsset(spaces),
      throwsException,
    );

    // TC-DMP-013: ubah dompet tanpa nama.
    final gopay = await createWallet(
      name: 'GoPay',
      preset: AccountPreset.eWallet,
    );
    final empty = AssetForm()
      ..codeControl.updateValue(AccountPreset.eWallet.code);
    expect(
      () => getIt<AssetRepository>().updateAsset(form: empty, id: gopay.id),
      throwsException,
    );
    expect(await totalUang(), 6000000);
  });

  test('TC-DMP-011 + TC-GLB-005 saldo awal sangat besar tanpa overflow',
      () async {
    await seedBaseData();

    final raksasa = await createWallet(
      name: 'Raksasa',
      preset: AccountPreset.bank,
      balance: 999999999999,
    );
    expect(await balanceOf(raksasa.id), 999999999999);
    expect(await totalUang(), 6000000 + 999999999999);
  });

  test('TC-GLB-006 nama panjang + emoji round-trip utuh', () async {
    await seedBaseData();

    final name = '💰 Liburan Panjang ${'A' * 80}';
    final wallet = await createWallet(
      name: name,
      preset: AccountPreset.eWallet,
    );
    final stored = await getIt<AccountRepository>().getAccount(wallet.id);
    expect(stored?.name, name);
  });

  test('TC-DMP-021 dompet sering dipakai naik urutan', () async {
    final base = await seedBaseData();

    final zzz = await createWallet(
      name: 'Zzz',
      preset: AccountPreset.eWallet,
      balance: 1000000,
    );
    for (var i = 0; i < 3; i++) {
      await recordExpense(
        assetId: zzz.id,
        assetName: 'Zzz',
        assetBalance: 1000000 - i * 10000,
        categoryId: base.makanId,
        amount: 10000,
      );
    }

    final accounts = await getIt<AccountRepository>().getAccounts(
      filter: activeLiquidFilter(),
    );
    // Counter +1 per jurnal posted → Zzz (3) di atas Tunai/BCA (0).
    expect(accounts.first.id, zzz.id);
  });

  test('TC-GLB-003 hapus-buat ulang kode monotonik naik', () async {
    final base = await seedBaseData();

    // Dompet: Tunai = 101.0001.0001 → X = 0002 → arsip → X lagi = 0003.
    final x1 = await createWallet(name: 'X', preset: AccountPreset.cash);
    expect(x1.code, '101.0001.0002');
    await getIt<AccountRepository>().archiveAccount(x1.id);
    final x2 = await createWallet(name: 'X', preset: AccountPreset.cash);
    expect(x2.code, '101.0001.0003');

    // Target: Dana Darurat = 101.0006.0001 → A = 0002 → hapus → A = 0003.
    final a1 = await getIt<SavingRepository>().createPocket(name: 'A');
    expect(a1.accountCode, '101.0006.0002');
    await getIt<SavingRepository>().delete(a1.accountId);
    final a2 = await getIt<SavingRepository>().createPocket(name: 'A');
    expect(a2.accountCode, '101.0006.0003');

    // Kategori expense: sistem max 501.0011 → Hobi = 0012 → arsip → 0013.
    final hobi1 = await createCategoryAccount(name: 'Hobi');
    expect(hobi1.code, '501.0012');
    await getIt<AccountRepository>().archiveAccount(hobi1.id);
    final hobi2 = await createCategoryAccount(name: 'Hobi');
    expect(hobi2.code, '501.0013');

    expect(base.tunai.code, '101.0001.0001');
  });
}
