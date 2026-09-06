import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/widgets/dompet_date_picker.dart';
import 'package:dompet_app/core/widgets/dompet_date_time_picker.dart';
import 'package:dompet_app/features/savings/pages/saving_allocation_page.dart';
import 'package:dompet_app/features/savings/pages/saving_form_page.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/pages/transaction_page.dart';
import 'package:dompet_app/features/transactions/pages/transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/fixture.dart';
import 'helpers/test_app.dart';

/// Alur Onboarding + struktur Beranda.
///
/// Menggabungkan:
/// - TC-ONB-001 s.d. TC-ONB-003, TC-ONB-006, TC-ONB-007
/// - TC-DSH-001 (struktur Beranda), TC-DSH-005/006/007 (quick action)
///
/// Catatan: TC-ONB-008 s.d. TC-ONB-011 (Google Drive restore) butuh akun
/// Google + jaringan sehingga tidak diotomatiskan di sini.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TC-ONB fresh install', () {
    setUp(setupTestApp);
    tearDown(disposeFixture);

    testWidgets('TC-ONB-001 fresh install masuk Initial Setup', (tester) async {
      await pumpTestApp(tester);
      await settle(tester);

      expect(find.byKey(initialSetupKey), findsOneWidget);
      expect(find.text('Mulai rapikan keuanganmu'), findsOneWidget);
      expect(find.text('Mulai'), findsOneWidget);
    });

    testWidgets(
      'TC-ONB-002/003 tap Mulai masuk Wallet Setup, Lanjutkan disabled',
      (tester) async {
        await pumpTestApp(tester);
        await settle(tester);

        await tester.tap(find.text('Mulai'));
        await settle(tester);

        // Halaman setup dompet (TC-ONB-002).
        expect(
          find.text('Di mana biasanya kamu menyimpan uang?'),
          findsOneWidget,
        );

        // Tombol Lanjutkan disabled sebelum ada dompet (TC-ONB-003).
        final lanjutkan = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Lanjutkan'),
        );
        expect(lanjutkan.onPressed, isNull);
      },
    );
  });

  group('TC-ONB-007 + TC-DSH sesudah setup', () {
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

    testWidgets('TC-ONB-007 splash langsung ke Beranda', (tester) async {
      await pumpTestApp(tester);
      await settle(tester);

      expect(find.byKey(initialSetupKey), findsNothing);
      expect(find.text('Total Uang'), findsOneWidget);
    });

    testWidgets('TC-DSH-001 struktur Beranda lengkap', (tester) async {
      await pumpTestApp(tester);
      await settle(tester);

      expect(find.text('Total Uang'), findsOneWidget);
      expect(find.text('Mulai Catat'), findsOneWidget);
      expect(find.text('Pemasukan'), findsWidgets);
      expect(find.text('Pengeluaran'), findsWidgets);
      expect(find.text('Pindah dana'), findsOneWidget);
    });

    testWidgets('TC-DSH-005 quick action Pemasukan', (tester) async {
      await pumpTestApp(tester);
      await settle(tester);

      await tester.tap(find.text('Pemasukan').first);
      await settle(tester);

      expect(find.text('Catat Pemasukan'), findsOneWidget);
    });

    testWidgets('TC-DSH-006 quick action Pengeluaran', (tester) async {
      await pumpTestApp(tester);
      await settle(tester);

      await tester.tap(find.text('Pengeluaran').first);
      await settle(tester);

      expect(find.text('Catat Pengeluaran'), findsOneWidget);
    });

    testWidgets('TC-DSH-007 quick action Pindah Dana', (tester) async {
      await pumpTestApp(tester);
      await settle(tester);

      await tester.tap(find.text('Pindah dana'));
      await settle(tester);

      expect(find.text('Pindah Dana'), findsWidgets);
    });
  });

  group('TC-IN-007 + TC-TRG-005/012 batas tanggal picker', () {
    setUp(() async {
      // DompetDateTimePicker memakai DateFormat locale 'id' (main.dart
      // memanggil ini saat boot normal; pump langsung wajib manual).
      await initializeDateFormatting('id');
      await setupTestApp();
    });
    tearDown(disposeFixture);

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    testWidgets('form transaksi & alokasi blokir tanggal masa depan',
        (tester) async {
      await setupTestApp();
      final base = await seedBaseData();
      final today = DateTime.now();

      await tester.pumpWidget(
        const MaterialApp(home: TransactionPage(type: TransactionType.income)),
      );
      await settle(tester, 6);
      var picker = tester.widget<DompetDateTimePicker>(
        find.byType(DompetDateTimePicker),
      );
      // TC-IN-007: lastDate = hari ini.
      expect(picker.lastDate, isNotNull);
      expect(isSameDay(picker.lastDate!, today), isTrue);

      await tester.pumpWidget(const MaterialApp(home: TransferPage()));
      await settle(tester, 6);
      picker = tester.widget<DompetDateTimePicker>(
        find.byType(DompetDateTimePicker),
      );
      expect(picker.lastDate, isNotNull);
      expect(isSameDay(picker.lastDate!, today), isTrue);

      // TC-TRG-012: alokasi juga lastDate hari ini.
      await tester.pumpWidget(
        MaterialApp(
          home: SavingAllocationPage(accountId: base.target.accountId),
        ),
      );
      await settle(tester, 6);
      picker = tester.widget<DompetDateTimePicker>(
        find.byType(DompetDateTimePicker),
      );
      expect(picker.lastDate, isNotNull);
      expect(isSameDay(picker.lastDate!, today), isTrue);
    });

    testWidgets('TC-TRG-005 form target blokir tanggal lampau',
        (tester) async {
      await setupTestApp();
      final today = DateTime.now();

      await tester.pumpWidget(const MaterialApp(home: SavingFormPage()));
      await settle(tester, 6);
      final picker = tester.widget<DompetDatePicker>(
        find.byType(DompetDatePicker),
      );
      expect(picker.firstDate, isNotNull);
      expect(isSameDay(picker.firstDate!, today), isTrue);
    });
  });
}
