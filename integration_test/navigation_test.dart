import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/activities/pages/activity_detail_page.dart';
import 'package:dompet_app/features/assets/pages/asset_detail_page.dart';
import 'package:dompet_app/features/budgets/pages/budget_plan_page.dart';
import 'package:dompet_app/features/savings/pages/saving_detail_page.dart';
import 'package:dompet_app/features/transactions/pages/transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'helpers/fixture.dart';
import 'helpers/test_app.dart';

/// Alur navigasi, dialog, dan interaksi widget.
///
/// Menggabungkan:
/// - TC-ONB-004/005/006 (setup dompet via preset + Lanjutkan)
/// - TC-DSH-003 (toggle visibilitas), TC-DSH-014 (drawer)
/// - TC-GLB-001 (FAB tambah), TC-GLB-012 spot-check (batal hapus)
/// - TC-TRF-002 (tukar), TC-IN-004 (toggle batch)
/// - TC-DMP-019 (guard arsip terakhir), TC-TRG-008 (layout detail),
///   TC-BGT-009 (tombol disabled), TC-ACT-007 (detail per tipe)
///
/// Memakai TestKeys (lib/core/constants/keys/key.dart) agar tidak
/// bergantung pada teks UI yang bisa berubah.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TC-DSH-003/014 + TC-GLB-001 Beranda', () {
    setUp(() async {
      await setupTestApp();
      await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
      await createWallet(
        name: 'BCA',
        preset: AccountPreset.bank,
        balance: 5000000,
      );
    });
    tearDown(disposeFixture);

    testWidgets('TC-DSH-003 toggle visibilitas Total Uang', (tester) async {
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Rp••••••••••'));

      await tester.tap(find.text('Total Uang'));
      await settleGone(tester, find.text('Rp••••••••••'));
      expect(find.textContaining('Rp6'), findsWidgets);
      await tester.tap(find.text('Total Uang'));
      await settleUntil(tester, find.text('Rp••••••••••'));
    });

    testWidgets('TC-DSH-014 drawer membuka 5 halaman', (tester) async {
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Total Uang'));
      await settle(tester, 3);

      final cases = {
        'Dompet': 'Dompet',
        'Kategori Pemasukan': 'Kategori Pemasukan',
        'Kategori Pengeluaran': 'Kategori Pengeluaran',
        'Laporan': 'Laporan',
        'Pengaturan': 'Pengaturan',
      };
      for (final entry in cases.entries) {
        await tester.tap(find.byIcon(Icons.menu));
        await settle(tester, 6);
        await tester.tap(find.text(entry.key).last);
        await settleGone(tester, find.byType(NavigationDrawer));
        expect(find.text(entry.value), findsWidgets);
        await tester.pageBack();
        await settleUntil(tester, find.text('Total Uang'));
        await settle(tester, 3);
      }
    });

    testWidgets('TC-GLB-001 FAB membuka bottom sheet tambah', (
      tester,
    ) async {
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Total Uang'));

      await tester.tap(find.byType(FloatingActionButton));
      await settleUntil(tester, find.text('Apa yang ingin kamu catat?'));
      expect(find.text('Pemasukan'), findsWidgets);
      expect(find.text('Pengeluaran'), findsWidgets);
      expect(find.text('Pindah dana'), findsWidgets);
    });
  });

  group('TC-TRF-002 + TC-IN-004 interaksi form', () {
    setUp(() async {
      await initializeDateFormatting('id');
      await setupTestApp();
    });
    tearDown(disposeFixture);

    Color primaryOf(WidgetTester tester) {
      return Theme.of(
        tester.element(find.byKey(TestKeys.transferSwap)),
      ).colorScheme.primary;
    }

    Color? nameColor(WidgetTester tester, Key selector, String name) {
      return tester
          .widget<Text>(
            find.descendant(
              of: find.byKey(selector),
              matching: find.text(name),
            ),
          )
          .style
          ?.color;
    }

    testWidgets('TC-TRF-002 tombol Tukar membalik asal-tujuan', (
      tester,
    ) async {
      final tunai = await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
      final bca = await createWallet(
        name: 'BCA',
        preset: AccountPreset.bank,
        balance: 5000000,
      );
      final form = transferForm(
        sourceId: bca.id,
        sourceName: 'BCA',
        sourceBalance: 5000000,
        destinationId: tunai.id,
        destinationName: 'Tunai',
        destinationBalance: 1000000,
        amount: 10000,
      );
      await pumpPage(tester, TransferPage(form: form));
      await settleUntil(
        tester,
        find.descendant(
          of: find.byKey(TestKeys.transferSource),
          matching: find.text('BCA'),
        ),
      );
      await tester.tap(find.byKey(TestKeys.transferSwap));
      await settle(tester, 2);
      // Kartu terpilih memakai warna primer: seleksi ikut tertukar.
      final primary = primaryOf(tester);
      expect(
        nameColor(tester, TestKeys.transferSource, 'Tunai'),
        primary,
      );
      expect(
        nameColor(tester, TestKeys.transferSource, 'BCA'),
        isNot(primary),
      );
      expect(
        nameColor(tester, TestKeys.transferDestination, 'BCA'),
        primary,
      );
      expect(
        nameColor(tester, TestKeys.transferDestination, 'Tunai'),
        isNot(primary),
      );
    });

    testWidgets('TC-IN-004 toggle batch bolak-balik tanpa crash', (
      tester,
    ) async {
      // Toggle memakai context.router → wajib lewat aplikasi penuh
      // (butuh ≥1 dompet agar splash masuk Beranda, bukan setup).
      await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Total Uang'));
      await tester.tap(find.text('Pengeluaran').first);
      await settleUntil(tester, find.text('Catat Pengeluaran'));

      await tester.tap(find.text('Catat banyak kategori sekaligus'));
      await settleUntil(tester, find.text('Catat satu kategori'));
      expect(find.text('Tambah Kategori'), findsOneWidget);

      await tester.tap(find.text('Catat satu kategori'));
      await settleUntil(tester, find.text('Catat banyak kategori sekaligus'));
    });
  });

  group('TC-DMP-019 + TC-TRG-008 + TC-BGT-009 + TC-ACT-007 detail', () {
    setUp(() async {
      await initializeDateFormatting('id');
      await setupTestApp();
    });
    tearDown(disposeFixture);

    testWidgets('TC-DMP-019 arsip dompet terakhir dibatalkan', (
      tester,
    ) async {
      final tunai = await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
      await pumpPage(tester, AssetDetailPage(id: tunai.id));
      await settleUntil(tester, find.text('Dompet Tunai'));

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await settleUntil(tester, find.text('Arsipkan'));
      await tester.tap(find.text('Arsipkan'));
      await settleUntil(
        tester,
        find.text(
          'Proses arsip dibatalkan. Setidaknya harus ada satu Dompet aktif.',
        ),
      );
      // Dompet tetap aktif, Total Uang tetap.
      expect(await totalUang(), 1000000);
    });

    testWidgets('TC-TRG-008 layout detail target awal', (tester) async {
      final base = await seedBaseData();
      await pumpPage(
        tester,
        SavingDetailPage(accountId: base.target.accountId),
      );
      await settleUntil(tester, find.text('Edit Target'));

      expect(find.text('Terkumpul'), findsWidgets);
      expect(find.text('Alokasi'), findsWidgets);
      expect(find.text('Belanja'), findsWidgets);
      expect(find.text('Tarik'), findsWidgets);
      expect(find.text('Edit Target'), findsOneWidget);
      expect(find.text('Hapus Target'), findsOneWidget);
    });

    testWidgets('TC-BGT-009 tombol disabled saat anggaran berjalan', (
      tester,
    ) async {
      final base = await seedBaseData();
      final makan = await getIt<AccountRepository>().getAccount(base.makanId);
      await pumpPage(tester, BudgetPlanPage(category: makan!));
      await settleUntil(tester, find.text('Anggaran sedang berjalan'));

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Anggaran sedang berjalan'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('TC-ACT-007 + TC-GLB-012 detail transfer & batal hapus',
        (tester) async {
      final base = await seedBaseData();
      await recordIncome(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: base.gajiId,
        amount: 100000,
      );
      final id = await lastPostedJournalId();
      await pumpPage(tester, ActivityDetailPage(id: id));
      // State loaded memakai judul dinamis (activity.title); tunggu
      // tombol aksi sebagai penanda konten termuat.
      await settleUntil(tester, find.text('Hapus'));
      expect(find.text('Perbaiki'), findsOneWidget);

      // TC-GLB-012 spot-check: dialog hapus → Batal → tidak ada perubahan.
      final t0 = await totalUang();
      await tester.tap(find.text('Hapus'));
      await settleUntil(tester, find.byKey(TestKeys.dialogCancel));
      await tester.tap(find.byKey(TestKeys.dialogCancel));
      await settleGone(tester, find.byKey(TestKeys.dialogCancel));
      expect(await totalUang(), t0);
      expect(find.text('Hapus'), findsOneWidget);
    });
  });
}
