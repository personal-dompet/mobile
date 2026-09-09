# 0001_FIXING_PLAN — Rencana Perbaikan & Implementasi Optimal

- Tanggal: 2026-09-07
- Sumber: `docs/0001_ISSUE.md` (17 ISSUE) + `docs/0001_IMPROVEMENT.md` (9 IMPROVEMENT)
- Review dasar: reviewer overlap/G1–G8 (dipakai, tidak diulang dari nol)
- Target pembaca: worker implementasi

---

## 1. Ringkasan hasil review overlap (wajib dibaca worker)

| Kelompok | Isi | Jenis | Keputusan plan |
|---|---|---|---|
| G1 validasi nominal | ISSUE 7 (TC-IN-005 pemasukan 0 lolos), 9 (TC-OUT-005), 10 (TC-TRF-004), 14 (TC-BGT-005 min 1) + IMP-4 (adjustment selisih 0 lolos) + terkait IMP-1 (overspend) | Duplikat akar `>0` hilang | Gabung jadi FIX-01. Satu helper/aturan `min 1`. IMP-4 repo-guard ikut FIX-01, UI snackbar ikut FIX-08/15 |
| G2 backup auth | ISSUE 16 (meta basi saat logout) + 17 (meta basi ganti akun) + 1 (setup pulihkan tak tampil email) | Duplikat akar `lastBackup` tak di-clear | Gabung jadi FIX-02 |
| G3 anggaran | ISSUE 15 (list anggaran basi setelah belanja target) vs IMP-7 (ubah/hapus Belanja) + IMP-8 (anggaran kategori diarsip) + IMP-9 (list rencana) | Konflik langsung + overlap layar | Putuskan IMP-7 dulu (lihat §2.3), baru FIX-09, FIX-12 |
| G4 target | ISSUE 13 (repos teks Terkumpul) + IMP-6 (info terkumpul di form tarik/belanja) + IMP-7 | Overlap layar target | Gabung batch target FIX-09/10 |
| G5 search | ISSUE 4 (empty state search Dompet) + 12 (tombol clear semua search + refetch) | Grup UX sama | Gabung FIX-13 |
| G6 agregasi | ISSUE 5 (saldo awal tampil di aktivitas, eksklusif ringkasan/laporan) vs 2 (Ringkasan Hari Ini) vs 6 (card Pemasukan per kategori) | Konflik agregasi potensial | Aturan tunggal §2.4, FIX-04/05/06 satu batch |
| G7 nav | ISSUE 8 (back stack jebol ke setup setelah perbaiki) vs IMP-2/3 (tambah route arsip) | Risiko regresi | Perbaiki nav dulu FIX-03 sebelum arsip FIX-14 |
| G8 snackbar | IMP-4 (snackbar "Tidak ada perubahan saldo" primary) vs IMP-5 (semua snackbar ke atas, bg seragam) | Dependensi urutan | Kerjakan sistem IMP-5 dulu (FIX-15), IMP-4 UI di atasnya (FIX-08). Repo-guard IMP-4 boleh duluan |
| Lifecycle kategori | ISSUE 11 (kategori baru tak auto-terpilih) + IMP-3 (list kategori arsip) + IMP-8 | Overlap lifecycle | Gabung batch kategori FIX-11/12/14 |

Temuan kode pendukung (verifikasi oracle):

- `saving_repository.dart:314,343,372` sudah `if (amount <= 0)`, tapi `transaction_repository.dart:25-28` hanya cek `null`, `transfer_repository.dart:18-21,35-38` hanya cek `null`, `TransactionForm` amount hanya `Validators.required`, `TransferForm` allow `0`. Jadi 0 lolos di form+repo transaksi/transfer.
- `BalanceAdjustmentRepository` selalu insert jurnal walau `difference==0`. `BalanceAdjustmentForm` hanya `required`.
- `BackupCubit.signOut():200-208` clear email tapi **tidak** `clearLastBackup`. `refreshMeta/signInAndRefreshMeta` sudah tangani `meta==null→clear`, tapi logout tak pernah clear → ISSUE 16. Ganti akun tanpa refresh penuh → ISSUE 17.
- `DompetSnackbar` (`core/widgets/dompet_snackbar.dart:3-37`) bg beda per tipe, posisi bottom default. Dipakai di `transaction_page:110,120`, `transfer_page:83,93`, `balance_adjustment_page:57,67`, `initial_setup_page:54`, `settings_page:52`, saving/budget pages.
- `transaction_page:58-75,160-170` + `transfer_page:42-55,121-128` dialog "Saldo mungkin negatif" lalu tetap simpan negatif → titik ubah IMP-1.
- `SavingSpendPage` fire `Saving/Account/Activity` tapi **tidak** `BudgetSignal` (banding `TransactionPage:192` fire `BudgetSignal`). `BudgetPage:52-54` listen `BudgetSignal→refresh`, `BudgetDetailPage:107` mirip. Ini akar ISSUE 15.
- `DompetTextField` `clearable` predicate salah: `(value != null \|\| (is String && isNotEmpty))` → `""` tetap dianggap ada; `reset()` belum tentu picu fetch. `AssetPage`, `BudgetPage`, `SavingPage`, `CategorySelector` semua debounce `valueChanges→fetch`.
- `CategorySelector` tombol `+`: `push(CategoryFormRoute)` lalu `maybePop()` tanpa result → kategori baru hilang → ISSUE 11. `CategoryField` (`category_field.dart`) terima result via `openCategorySelector` dan update controls.
- `AssetRepository.createAsset:62-121` jurnal saldo awal `source=setup`, `description='Konfigurasi saldo awal'`. Activity filter (`activity_filter.dart:29-42`) dan query kemungkinan eksklusikan `setup` → ISSUE 5. `ReportRepository` + `DashboardRepository` filter `IN (transaction, saving)` → sudah eksklusikan setup (bagus, jangan diubah).
- `TodaySummary:28-33` teks "Belum ada transaksi hari ini." → hapus (ISSUE 2).
- `ShellPage (dashboard/pages/shell_page.dart:28-45)` `PopScope(canPop:false)` + `Navigator.canPop→pop` else dialog tutup. `_AppBarTitle` map `SavingRoute→'Tabungan'` → ganti 'Target' (ISSUE 3). `ActivityDetailPage:127-160` edit pakai `push→replace(ActivityDetailRoute(id:result))` → audit scope router untuk ISSUE 8.
- `SavingDetailPage _HistorySection:1007-1012` teks `Terkumpul ...currency` di luar `ActivityItemTile`, `textAlign:end` → pindah ke dalam card (ISSUE 13).

---

## 2. Keputusan konflik (final, jangan dibuka lagi kecuali bukti baru)

### 2.1 IMP-1 vs IMP-4 (edge `==saldo` vs `>saldo`)

- Aturan tunggal nominal:
  - Batas bawah global: **min 1** semua domain uang (pemasukan, pengeluaran, transfer, budget, topup/withdraw/spend, adjustment target nominal). `0`, negatif, null → tolak di form + repo.
  - `nominal == effectiveBalance` (pengeluaran/transfer): **langsung jurnal biasa, tanpa adjustment**. Tak ada dialog.
  - `nominal > effectiveBalance`: tampil dialog persetujuan 2 jurnal (lihat FIX-07). Adjustment = **selisih** (`nominal - effectiveBalance`), bukan penuh.
  - Adjustment saldo (`BalanceAdjustment`): jika `newAmount == currentBalance` → **no-op, tanpa jurnal**, pop + snackbar info (lihat FIX-08).
- Alasan: hindari jurnal `0` ganda, hindari adjustment penuh yang menggelembungkan mutasi.

### 2.2 IMP-5 (snackbar global)

- Pilih: **sistem baru dulu, pesan baru ikut sistem baru**.
- Spesifikasi beku:
  - Posisi: atas (`floating`, margin top di bawah AppBar, `behavior:floating` atau Overlay kustom — pilih satu, konsisten).
  - Background: **sama untuk semua tipe** (misal `surfaceContainerHigh` / warna kontras dari app bg + `elevation/shadow` jelas).
  - Pembeda: **warna teks/icon** per `success/error/info` (bukan bg).
  - API `DompetSnackbar(context, message, snackBarType)` **tetap** agar ~20 call-site tak diubah satu-satu.
- Alasan: cegah rework IMP-4 dan semua pesan sukses/error.

### 2.3 IMP-7 (Belanja dari Target) — keputusan P1

- Pilih: **Opsi B hybrid (Tarik + Pengeluaran, 2 jurnal atomik)**, bukan hapus Belanja.
- Rincian beku:
  - Form Belanja tambah pemilih **"Dari Dompet"** (dompet cair aktif) + info terkumpul (IMP-6).
  - Kategori **opsional**, kosong → fallback akun expense `Lain-Lain` (cari by code/name, buat jika belum ada — putuskan di implementasi, dokumentasikan).
  - Satu `db.transaction`: Jurnal 1 tarik (`debit dompet, credit target`, `source=saving`, meta `withdraw`-like + flag `spend_withdraw`), Jurnal 2 keluar (`debit expense, credit dompet`, `source=transaction` atau `saving/spend_expense` — pilih satu, konsisten dengan agregat).
  - Sinyal: `SavingSignal + AccountSignal + ActivitySignal + BudgetSignal` semua `created()`.
  - Report: hanya Jurnal 2 dihitung sebagai expense/kategori; Jurnal 1 kontribusi 0 (ikuti pola `report_repository.dart` existing: topup/withdraw 0).
  - Budget: Jurnal 2 masuk hitung `spent` kategori → ISSUE 15 otomatis relevan.
- Alasan: hapus total (opsi strict) sebabkan migrasi histori spend, hilangkan entry-point UX, dan buat ISSUE 15 basi. Opsi B pertahankan tracking anggaran + laporan, satu langkah user, tetap hormati "target bukan sumber expense langsung" karena expense resmi keluar dari dompet.

### 2.4 Aturan eksklusisi saldo awal (ISSUE 5 vs 2 vs 6)

- Jurnal saldo awal (`source=setup`):
  - **Tampil** di semua list aktivitas: dashboard recent, halaman aktivitas, detail dompet, list aktivitas tiap dompet. Gaya success seperti pemasukan, prefix `+`.
  - **Jangan** masuk: Ringkasan Hari Ini, Total Uang? (Total Uang tetap hitung saldo — hanya ringkasan transaksi yang eksklusif), `ReportRepository.getMonthlySummary`, `getExpenseByCategory`/`getIncomeByCategory`, cashflow, trend, insight, budget spent.
- Alasan: cegah angka ganda saat FIX-06 tambah card pemasukan.

---

## 3. Daftar task final terdeduplikasi (FIX-xx)

> Jangan kerjakan 26 item mentah. Kerjakan FIX-01…FIX-15 berurutan per batch §4.

### FIX-01 — Unifikasi validasi nominal min 1 (ISSUE 7,9,10,14 + repo-guard IMP-4)

- Asal: ISSUE 7 TC-IN-005, 9 TC-OUT-005, 10 TC-TRF-004, 14 TC-BGT-005.
- Prioritas: P0.
- Acceptance:
  - Pemasukan, pengeluaran (single + batch multi-kategori), transfer, budget/plan, topup/withdraw/spend target, adjustment: nominal `0/null/negatif` ditolak di UI (touched error, tak panggil cubit/repo) + ditolak di repo (`Exception('Nominal harus lebih dari 0')` atau pesan domain setara).
  - TC-IN-005, TC-OUT-005, TC-TRF-004, TC-BGT-005 manual lolos (gagal simpan 0).
  - Edit flow juga ditolak (bukan hanya create).
- File/fungsi target:
  - `features/transactions/forms/transaction_form.dart` (`TransactionCategoryForm.amountControl`), `transfer_form.dart` (`amountControl`), `balance_adjustment_form.dart`, budget plan/form (`budget_plan_form_page`, repo budget), saving forms (`saving_*_form.dart`).
  - `features/transactions/repositories/transaction_repository.dart:25-28`, `transfer_repository.dart:18-21,35-38`, `balance_adjustment_repository.dart` (tambah guard `difference==0` → throw `NoOp` khusus atau return signal; lihat FIX-08), `budgets/repositories/*`, `savings/repositories/saving_repository.dart` (sudah ada, samakan pesan).
- Langkah:
  1. Buat helper validator tunggal (misal `DompetAmountValidators.min1()` = `required + min(1) + number(noNegatives, 0 decimals)`) dan pakai di semua amountControl.
  2. Tambah guard repo `if (amount == null || amount <= 0) throw ...` di transaction + transfer (+ budget jika belum).
  3. Pastikan batch mode jumlahkan per-kategori lalu validasi tiap item + total.
  4. Samakan pesan error ID.
- Jangan diubah/risiko: jangan ubah logika overspend (`>saldo`) di sini — itu FIX-07. Jangan ubah `saving_repository` topup/withdraw/spend yang sudah benar selain samakan pesan.

### FIX-02 — Backup auth: clear meta + tampil email (ISSUE 16,17,1)

- Asal: ISSUE 16, 17, 1.
- Prioritas: P0.
- Acceptance:
  - Login A ada cadangan → lihat meta A. Logout → meta hilang, section ganti teks "belum ada akun login" (bukan meta basi).
  - Login B tanpa cadangan → state kosong "belum ada cadangan di akun ini", bukan meta A.
  - Section pulihkan di `InitialSetupPage` tampilkan `accountEmail` aktual, bukan teks generik "Ada cadangan Dompet dari akun Google ini."
  - Ganti akun A→B tanpa logout eksplisit juga refresh meta.
- File/fungsi target:
  - `features/backup/cubits/backup_cubit.dart:200-208` (`signOut`), `signInAndRefreshMeta:163-174`, `init`, `refreshMeta`.
  - `features/backup/cubits/backup_state.dart` (`clearLastBackup/clearAccountEmail`).
  - `features/settings/pages/settings_page.dart:198` (baca `lastBackup`), `features/setup/pages/initial_setup_page.dart:206` + `_showSnack`.
  - `features/backup/services/backup_auth_service.dart:85-88`.
- Langkah:
  1. `signOut()` emit `clearLastBackup:true, clearAccountEmail:true, isSignedIn:false, isLoadingMeta:false`.
  2. Pastikan setiap `authenticate()` sukses → `accountEmail` update + `refreshMeta()` (atau inline `getLastBackupMeta` + `clearLastBackup: meta==null`).
  3. UI settings + setup: render 3 state eksplisit: `!isSignedIn` → ajak login; `isSignedIn && lastBackup==null && !isLoadingMeta` → "belum ada cadangan"; else tampil meta + email.
  4. `InitialSetupPage` ganti teks generik dengan email (`backupState.accountEmail ?? '-'`).
- Jangan diubah/risiko: jangan ubah logika `restore/backup` sukses. Waspada Drive client cache per-akun — pastikan `getLastBackupMeta` pakai kredensial akun aktif, bukan cache lama.

### FIX-03 — Navigasi back stack jebol ke setup (ISSUE 8)

- Asal: ISSUE 8 (11 langkah drawer→list dompet→detail→detail aktivitas→perbaiki→simpan→back×4 → harusnya dialog tutup, bukan setup).
- Prioritas: P1 (sebelum rute baru).
- Acceptance:
  - Reproduksi 11 langkah: back dari list dompet → beranda → dialog "Tutup aplikasi?" (tidak ke setup).
  - Tak ada regresi back di flow create/edit transaksi/transfer/adjustment lain.
- File/fungsi target:
  - `features/dashboard/pages/shell_page.dart:28-45` (`PopScope`), `core/router/router.dart:11-17`, `router.gr.dart`.
  - `features/activities/pages/activity_detail_page.dart:127-160` (`push→replace`), `features/transactions/pages/transaction_page.dart:193`, `transfer_page.dart:145` (`maybePop(newEditedId)`).
- Langkah:
  1. Log stack (root vs nested tabs router) saat reproduksi; identifikasi `replace` yang pakai router salah scope (root `replace` bisa buang `ShellRoute`).
  2. Perbaiki: edit push harus `push` di router yang sama, selesai `pop(result)`, detail lama `replace` di scope yang sama; jangan `replaceAll` tak sengaja.
  3. Pastikan `Splash→replaceAll([Shell])` tak tinggalkan `InitialSetup` di stack.
  4. Tambah tes regresi manual ter-script (11 langkah) + jika ada integration test, otomatiskan.
- Jangan diubah/risiko: jangan tambah route arsip (FIX-14) sebelum ini hijau. Jangan ubah `PopScope` exit-dialog wording.

### FIX-04 — Jurnal saldo awal tampil di aktivitas, eksklusif agregat (ISSUE 5)

- Asal: ISSUE 5.
- Prioritas: P1 (fondasi G6, sebelum FIX-05/06).
- Acceptance:
  - Buat dompet saldo awal N → muncul di: dashboard recent, halaman aktivitas, detail dompet, list aktivitas tiap dompet. Warna success, nominal `+RpN`.
  - Tak pengaruhi: Ringkasan Hari Ini, `getMonthlySummary`, cashflow, per-kategori, trend, budget spent.
- File/fungsi target:
  - `features/assets/repositories/asset_repository.dart:62-121` (sumber `setup`, baca saja).
  - Activity queries: `features/activities/repositories/*`, `features/dashboard/repositories/dashboard_repository.dart:55-59`, asset detail/activity repo, `activity_filter.dart`.
  - Display: `features/activities/extensions/activity.dart:80-188` (title/meta/`+/-`), `activity_detail_page.dart:72-80,280-306`.
- Langkah:
  1. Include `source=setup` di semua query list aktivitas (tambah ke `IN (...)` atau `OR source=setup`).
  2. Petakan `setup` ke tipe tampilan income-like: title fallback "Saldo awal"/deskripsi, `+` prefix, tertiary/success color. Jangan buat tipe filter baru kecuali perlu.
  3. Verifikasi query summary/report/budget **tetap** eksklusikan `setup` (tambah test SQL).
- Jangan diubah/risiko: jangan ubah nilai saldo/double-entry (asset debit vs initialBalance credit sudah benar). Jangan sertakan `setup` ke `transaction_count`.

### FIX-05 — Ringkasan Hari Ini kosong (ISSUE 2)

- Asal: ISSUE 2.
- Prioritas: P1 (setelah FIX-04).
- Acceptance: belum ada aktivitas hari ini → teks "Belum ada transaksi hari ini." hilang; dua card Pengeluaran/Pemasukan tetap tampil (0).
- File: `features/dashboard/widgets/today_summary.dart:28-33`, `features/dashboard/pages/dashboard_page.dart`.
- Langkah: hapus blok `if (isEmpty) Text(...)` (atau ganti `SizedBox.shrink`), pastikan `isEmpty` tetap hormati eksklusisi FIX-04.
- Risiko: kecil. Jangan ubah `DashboardRepository.getTransactionSummary` di sini.

### FIX-06 — Card Pemasukan per kategori di Laporan (ISSUE 6)

- Asal: ISSUE 6.
- Prioritas: P1 (setelah FIX-04).
- Acceptance: ada card "Pemasukan per kategori", style sama dengan "Pengeluaran per kategori", angka konsisten dengan summary, eksklusikan saldo awal.
- File/fungsi target:
  - `features/reports/widgets/category_spending_card.dart:25` (duplikasi/parametrisasi), `pages/report_page.dart` (`_LoadedBody`), `repositories/report_repository.dart:126-` (`getExpenseByCategory` → tambah `getIncomeByCategory`), `cubits/report_cubit.dart` (state `categoryIncome`), model `CategorySpending`.
- Langkah:
  1. Tambah `getIncomeByCategory(period)` mirror expense tapi `type=income`.
  2. Cubit load `categoryIncome` bersama expense; page render dua card berurutan.
  3. Refactor widget agar satu komponen dipakai dua kali (param title+items+color).
- Risiko: jangan double-count saving topup/withdraw (harus 0, ikut pola existing). Jangan sertakan `setup`.

### FIX-07 — Overspend/over-transfer jadi 2 jurnal (IMPROVEMENT 1)

- Asal: IMP-1.
- Prioritas: P1 (setelah FIX-01).
- Acceptance:
  - Pengeluaran/transfer `> effectiveBalance` (edit memperhitungkan previous) → dialog baru: "Lanjutkan = setuju 2 jurnal: (1) penyesuaian selisih, (2) transaksi biasa." Tampilkan angka selisih.
  - Setuju → 2 jurnal posted atomik (satu `db.transaction`); saldo akhir = 0 sebelum jurnal biasa? Tepatnya: adjustment naikkan saldo ke `==nominal`, lalu expense/transfer kurangi. Batal → tak ada jurnal.
  - `==saldo` → tanpa dialog/adjustment.
  - Transfer hanya lihat aset sumber.
- File/fungsi target:
  - `features/transactions/pages/transaction_page.dart:58-75,160-170`, `transfer_page.dart:42-55,121-128`, `effective_balance.dart`, cubits `transaction_cubit/transfer_cubit`, repos `transaction_repository/transfer_repository + balance_adjustment_repository` (atau repo gabungan baru `overspend_repository`).
  - Dialog: `core/widgets/dompet_dialog.dart`.
- Langkah:
  1. Ganti wording dialog lama ("mungkin negatif") dengan spec 2 jurnal + nominal selisih.
  2. Implement repo `recordWithAutoAdjustment()` yang dalam satu txn: insert adjustment (selisih) + insert transaksi/transfer. Reuse `_record` helpers, jangan duplikasi SQL mentah.
  3. Edit flow: `effectiveBalance = currentBalance + previousAmount (jika aset sama)`.
  4. Sinyal: `ActivitySignal (+ BudgetSignal untuk expense)`.
- Jangan diubah/risiko: jangan izinkan saldo negatif lagi (hapus path lama). Waspada double `BudgetSignal` (cukup sekali). Uji konkurensi saldo berubah antar dialog→simpan (re-check balance di txn, throw jika kurang tak terduga).

### FIX-08 — Adjustment no-op tanpa jurnal (IMPROVEMENT 4, UI ikut FIX-15)

- Asal: IMP-4.
- Prioritas: P1 (repo-guard bareng FIX-01; UI setelah FIX-15).
- Acceptance: input adjustment `== saldo sekarang` → tak ada jurnal baru, pop ke detail dompet + snackbar info/primary "Tidak ada perubahan saldo" (wording kalem, ikut spec FIX-15 untuk posisi/bg).
- File: `features/transactions/pages/balance_adjustment_page.dart:55-70`, `repositories/balance_adjustment_repository.dart:56-59`, `models/balance_adjustment.dart` (`difference`).
- Langkah:
  1. Repo: jika `difference==0` throw `NoOpAdjustment` (atau return null) — jangan insert.
  2. Page/cubit: tangkap `NoOp` → `pop` + snackbar info (bukan error). Jangan tampilkan loading selamanya.
  3. Styling snackbar serahkan ke FIX-15 (pakai `SnackBarType.info` + pesan final).
- Risiko: bedakan dengan FIX-07 selisih adjustment (di sana selisih>0 selalu).

### FIX-09 — Belanja Target 2 jurnal + refresh anggaran (IMP-7 + ISSUE 15)

- Asal: IMP-7 + ISSUE 15 TC-BGT-011.
- Prioritas: P1 (setelah FIX-04/06, sebelum polish target).
- Acceptance:
  - Form Belanja ada pemilih dompet + info terkumpul (lihat FIX-10 untuk info).
  - Simpan → 2 jurnal atomik (FIX-07 spec §2.3), kategori opsional fallback Lain-Lain.
  - Jika kategori punya anggaran aktif: list anggaran + detail sama-sama segar (TC-BGT-011 hijau). Detail yang sudah benar jangan regresi.
  - Report kategorikan Jurnal 2 sebagai expense; Jurnal 1 nol.
- File/fungsi target:
  - `features/savings/pages/saving_spend_page.dart:42-73`, `forms/saving_spend_form.dart` (tambah asset field), `repositories/saving_repository.dart:spend()` (+ `_recordWithdraw`-reuse), `features/budgets/pages/budget_page.dart:52-54`, `budget_detail_page.dart:107`, `budget_signal_cubit`, `saving_signal/account_signal/activity_signal`.
  - Fallback kategori: cari akun expense `Lain-Lain` (by code/name) di repo.
- Langkah:
  1. Tambah `AssetSelector` dompet ke `SavingSpendForm` + validasi `amount<=pocketBalance` dan `amount<=?` (dompet tak perlu cukup karena Jurnal 1 isi dulu? Tetap validasi pocket cukup; dompet akhir netral).
  2. Tulis ulang `spend()` jadi 2 insert dalam satu `db.transaction` (pakai helper `_recordWithdraw`-like + expense insert). Metadata jelas (`spend_withdraw` + `spend_expense` atau setara) agar report/budget query tepat.
  3. Fire 4 sinyal (tambah `BudgetSignal.created()` yang hilang).
  4. Verifikasi `budget_repository` hitung Jurnal 2 (sesuaikan `WHERE source` jika perlu).
- Jangan diubah/risiko: jangan ubah `topup/withdraw` single-jurnal. Jangan biarkan 1 jurnal sukses 1 gagal (harus atomik). Jangan duplikasi expense di report (hanya Jurnal 2).

### FIX-10 — UI Target: repos Terkumpul + info saldo di form (ISSUE 13 + IMP-6)

- Asal: ISSUE 13 + IMP-6.
- Prioritas: P2 (setelah FIX-09).
- Acceptance:
  - Detail target riwayat: teks "Terkumpul RpX" ada **di dalam** card item, di bawah nominal, sejajar keterangan waktu (bukan di luar card, bukan rata kanan luar).
  - Form Tarik + Belanja: ada info santai tak mencolok "Terkumpul sekarang RpX • maksimal …" (atau setara).
- File: `features/savings/pages/saving_detail_page.dart:914-1012` (`_HistorySection` + `ActivityItemTile`), `saving_allocation_page.dart`, `saving_spend_page.dart`, `saving_detail/cubit`.
- Langkah:
  1. Pindah `Text('Terkumpul ...')` ke dalam tile (kolom bawah nominal, `Row` dengan waktu). Sesuaikan padding.
  2. Tambah banner subtil di dua form (baca `plan.balance`/insight, bukan query baru berat).
- Risiko: jangan ubah perhitungan `balanceAfter` (chronological running sudah benar). Jangan ubah `ActivityItemTile` global kecuali via param.

### FIX-11 — Kategori baru langsung terpilih + lifecycle (ISSUE 11, fondasi IMP-3/8)

- Asal: ISSUE 11 TC-KAT-009.
- Prioritas: P1.
- Acceptance: flow pengeluaran/pemasukan → kategori → `+` → isi "Minum" → simpan → kembali ke form dengan field terisi kategori baru (tak kosong). Berlaku income+expense, single+batch.
- File: `features/categories/widgets/category_selector.dart` (tombol `+`), `utils/open_expense_account_selector.dart`, `widgets/category_field.dart`, `forms/category_form.dart`, `cubits/category_cubit`.
- Langkah:
  1. Setelah `push(CategoryFormRoute)` return `Account? category`, langsung `_onSelect(context, account: category)` (pop dengan tuple `(account, hasPlan)`) alih-alih `maybePop()` kosong.
  2. Pastikan `AccountSignal` refresh tak hapus seleksi.
- Risiko: jangan ubah flow pilih biasa. Jangan pop dua kali.

### FIX-12 — Anggaran: label arsip + list rencana (IMP-8 + IMP-9)

- Asal: IMP-8, IMP-9.
- Prioritas: P2 (setelah FIX-09/11).
- Acceptance IMP-8: kategori Hobi bisa diarsip kapan saja; anggaran aktif Hobi tetap aktif & tetap terhitung; list + detail tampil badge "Kategori diarsipkan" + icon (i) → modal info kalem ("anggaran tak bisa dilacak lagi"); tak crash saat kategori null.
  - Acceptance IMP-9: ada list rencana anggaran terpisah; navigasi via icon action di AppBar `BudgetPage` (sesuai diskusi) membuka `BudgetPlanRoute` list.
- File: `features/budgets/repositories/budget_repository.dart:145`, `budget_plan_repository.dart:28`, `pages/budget_page.dart` (tambah action), `pages/budget_detail_page.dart`, `widgets/budget_list.dart`, kategori archive flag (`isDeleted/isArchived`), modal `DompetDialog`/bottomsheet.
- Langkah:
  1. Ubah query budgets `INNER→LEFT JOIN` kategori + expose `categoryArchived`; jangan filter out arsip.
  2. UI badge + `(i)` modal di list tile + detail header.
  3. Pastikan pencatatan baru ke kategori arsip ditolak lembut (arahkan buat kategori baru) tapi histori/anggaran lama tetap jalan.
  4. Rencana: buat/gunakan `BudgetPlanPage` list; tambah `IconButton` (misal `calendar_month`/`assignment`) di AppBar Budget dengan tooltip "Rencana anggaran".
- Risiko: perubahan JOIN bisa gandakan baris — tambah `GROUP BY`/distinct + test Hobi end-to-end.

### FIX-13 — Search UX global + empty state (ISSUE 4 + 12) + judul Target (ISSUE 3)

- Asal: ISSUE 4, 12, 3 (digabung karena kecil + sentuh file berdekatan).
- Prioritas: P2.
- Acceptance:
  - Semua search field: tombol clear muncul jika `>=1 char`, tap → clear + `fetch` ulang tanpa keyword (tanpa perlu ketik ulang). Berlaku: Dompet, Anggaran, Target, Kategori, Pilih Kategori.
  - `AssetPage` keyword tanpa hasil → empty state ("Tidak ada dompet cocok …" + saran/CTA), bukan blank.
  - AppBar tabungan bertuliskan **"Target"** (ganti "Tabungan"; cek `_AppBarTitle` + bottom bar + `SavingPage` AppBar jika ada).
- File: `core/widgets/dompet_text_field.dart` (predicate clear), `features/assets/pages/asset_page.dart`, `features/budgets/pages/budget_page.dart`, `features/savings/pages/saving_page.dart`, `features/categories/*`, `features/dashboard/pages/shell_page.dart` (`_AppBarTitle`).
- Langkah:
  1. Perbaiki predicate: tampil clear hanya jika `value != null && (value is! String || value.isNotEmpty)`; pastikan `ReactiveTextField` rebuild saat value berubah (pakai `ReactiveValueListenableBuilder` bila perlu).
  2. `onPressed` clear: `reset()` + `unfocus()` + panggil `fetch(keyword:null)` eksplisit (jangan andalkan debounce saja).
  3. `AssetPage loaded && assets.isEmpty` → widget empty state (icon + teks + tombol reset pencarian). Opsional terapkan pola sama ke list kosong lain.
  4. Ganti string "Tabungan"→"Target" di judul (jangan ubah route name).
- Risiko: `clearable:true` dipakai banyak — uji semua halaman, bukan hanya Dompet.

### FIX-14 — Halaman arsip Dompet + Kategori (IMP-2 + IMP-3)

- Asal: IMP-2, IMP-3.
- Prioritas: P2 (setelah FIX-03 + FIX-11).
- Acceptance:
  - Ada grid dompet arsip = grid aktif (2 kolom, `AssetCard`), tap → detail dompet; ada aksi pulihkan (long-press/button — tentukan, dokumentasikan).
  - Ada list kategori arsip per tipe (pemasukan/pengeluaran) = list aktif; swipe → tombol Pulihkan seperti "Kategori Saya".
  - Navigasi jelas: dari `AssetPage`/`CategoryPage` via AppBar icon arsip (konsisten dengan FIX-12).
- File: `features/assets/repositories/asset_repository.dart` (query `isDeleted=1` + `restore`), `features/categories/repositories/*` + cubits, pages baru `asset_archived_page.dart`, `category_archived_page.dart`, `router.dart` (tambah routes), drawer/AppBar entry.
- Langkah:
  1. Tambah repo `getArchived/restore` + cubit method.
  2. Duplikasi UI aktif dengan filter arsip (jangan refactor besar grid/list aktif).
  3. Daftarkan route + entry point; pastikan back stack tak jebol (regresi FIX-03).
- Risiko: jangan tampilkan arsip di list aktif (cek semua `WHERE isDeleted=0`). Jangan izinkan transaksi ke dompet/kategori arsip.

### FIX-15 — Sistem snackbar atas global (IMPROVEMENT 5)

- Asal: IMP-5 (fondasi untuk pesan FIX-08).
- Prioritas: P2 terakhir (sebelum pesan final FIX-08).
- Acceptance:
  - Semua snackbar muncul di **atas** halaman; satu background sama semua tipe; pembeda hanya warna teks/icon; kontras dari app bg + shadow jelas.
  - Tak ada call-site yang perlu diubah tanda tangannya (`DompetSnackbar(context, message, snackBarType)` tetap).
  - Manual cek: success/error/info di transaksi, transfer, adjustment, setup, settings, saving, budget.
- File: `core/widgets/dompet_snackbar.dart:3-37` (+ theme/elevation), mungkin helper `showDompetSnack()`.
- Langkah:
  1. Riset opsi Flutter: `ScaffoldMessenger` `behavior:floating` + `margin: EdgeInsets(top:...)` vs Overlay custom. Pilih yang dukung atas tanpa pecah `hideCurrentSnackBar` existing.
  2. Implement satu tempat; samakan `backgroundColor`, bedakan `content TextStyle` + icon per tipe.
  3. Screenshot/manual QA terang+gelap.
- Risiko: perubahan global — jangan ubah durasi/action semantics. Ini terakhir agar FIX-08 tinggal pakai.

---

## 4. Urutan eksekusi + batching worker

```text
Batch 0 — Bekukan spec (§2): IMP-7 opsi B, min-1, setup-exclusion, snackbar spec.
  └─ Tanpa kode. Owner setuju sebelum Batch 1.

Batch 1 — P0 fondasi (sequential, 1 worker): FIX-01 → FIX-02.
  └─ Test: §5 B1.

Batch 2 — Nav gate (1 worker, blokir arsip): FIX-03.
  └─ Test: 11-langkah ISSUE 8. Baru boleh lanjut ke arsip.

Batch 3 — Agregasi atomik (1 worker, jangan paralel): FIX-04 → FIX-05 → FIX-06.
  └─ Alasan: satu aturan setup-exclusion; paralel = angka ganda.
  └─ Test: §5 B3.

Batch 4 — Target+anggaran inti (1 worker): FIX-07 → FIX-09 → FIX-10.
  └─ FIX-08 repo-guard boleh selip di sini, UI-nya tunda ke Batch 6.
  └─ Test: §5 B4 (termasuk TC-BGT-011).

Batch 5 — Kategori+anggaran (1 worker, bisa paralel dengan Batch 6 jika beda lane/worktree):
  FIX-11 → FIX-12.
  └─ Test: TC-KAT-009 + skenario Hobi arsip + rencana list.

Batch 6 — Polish + sistem (1 worker): FIX-13 → FIX-15 → finalisasi UI FIX-08.
  └─ Test: semua search, judul, snackbar atas, no-op adjustment.

Batch 7 — Arsip (1 worker, setelah Batch 2 hijau): FIX-14.
  └─ Test: grid/list arsip + restore + regresi nav.

Jangan: kerjakan Batch 4 sebelum Batch 3 hijau (spend ganggu agregat);
jangan kerjakan FIX-14 sebelum FIX-03; jangan kerjakan pesan FIX-08 sebelum FIX-15.
Paralel hanya aman: Batch 5 vs Batch 6 (file beda), dengan 1 writer per cwd/worktree.
```

---

## 5. Test/validasi per batch

- B1 (FIX-01/02):
  - TC-IN-005, TC-OUT-005, TC-TRF-004, TC-BGT-005: simpan `0` → ditolak (form error + tak ada jurnal). Ulangi mode edit.
  - Adjustment `==saldo` → tak ada jurnal (cek DB count tetap).
  - Backup: login A bermeta → logout → meta null + teks belum-login; login B tanpa cadangan → kosong; setup tampil email.
- B2 (FIX-03): skrip 11 langkah ISSUE 8 → dialog tutup. Uji back create/edit semua tipe.
- B3 (FIX-04/05/06):
  - Dompet baru saldo awal N → muncul `+N` success di 4 list aktivitas; Ringkasan Hari Ini tetap 0 + tanpa teks; Laporan income/expense/cashflow/per-kategori tak berubah; `transaction_count` tak naik.
- B4 (FIX-07/09/10):
  - Expense/transfer `==saldo` → 1 jurnal, tanpa dialog. `>saldo` → dialog 2 jurnal, setuju → 2 jurnal posted, saldo akhir benar; batal → 0 jurnal.
  - Belanja target → 2 jurnal atomik (matikan tengah jalan harus rollback — uji dengan kategori invalid); TC-BGT-011: list+detail segar sama; fallback Lain-Lain saat kategori kosong.
  - Detail target: "Terkumpul" di dalam card sejajar waktu; form tarik/belanja ada info terkumpul.
- B5 (FIX-11/12): TC-KAT-009 ("Minum" auto-terpilih); arsip Hobi → badge + modal (i) di list+detail, anggaran tetap aktif; icon AppBar buka list rencana.
- B6 (FIX-13/15/08): semua search clear→refetch; Asset kosong→empty state; judul "Target"; snackbar atas bg seragam teks beda (terang+gelap); adjustment no-op → pop + "Tidak ada perubahan saldo".
- B7 (FIX-14): arsip grid/list mirror aktif; tap→detail; pulihkan→kembali ke aktif; arsip tak bisa ditransaksikan; regresi B2.

---

## 6. Risiko sisa + yang sengaja tak diubah

- Nav ISSUE 8 akar pasti belum 100% tanpa reproduksi + log stack (kemungkinan scope `replace` salah). FIX-03 wajibkan log sebelum klaim sembuh.
- `getLastBackupMeta` cache akun lama bisa sebabkan ISSUE 17 walau state di-clear — verifikasi Drive credential scope di FIX-02.
- Query budget spent untuk Jurnal 2 (FIX-09) belum diverifikasi penuh — baca `budget_repository.dart` saat implementasi; sesuaikan `WHERE source` sekali, jangan dua tempat.
- Fallback "Lain-Lain" (FIX-09) perlu putuskan cari-vs-buat; catat pilihan di kode.
- `DompetTextField` dipakai luas — perubahan predicate clear (FIX-13) wajib QA semua halaman search.
- Snackbar atas (FIX-15) risiko visual di semua halaman — taruh terakhir + QA tema terang/gelap.
- Tak diubah: double-entry saldo awal, `Total Uang` (tetap hitung saldo), pesan error repo saving yang sudah `<=0`, wording dialog tutup aplikasi.

---

## 7. Need dari main agent (keputusan beku sebelum worker jalan)

1. Setujui IMP-7 **Opsi B 2-jurnal** (§2.3) — jika pilih hapus total, FIX-09 ditulis ulang.
2. Setujui **min 1 global** (§2.1) — jika ada domain boleh 0, sebutkan.
3. Setujui spec snackbar atas (§2.2) — warna bg tunggal + teks pembeda.
4. Setujui entry navigasi arsip + rencana via **AppBar icon** (FIX-12/14) — jika mau via drawer, ubah FIX-12/14.

---

## 8. Suggested execution prompt (untuk worker, per batch)

> Gunakan hanya setelah §7 disetujui. Satu batch satu worker, sequential dalam batch.
>
> **Worker Batch 1 (FIX-01→FIX-02):** "Di `C:/Users/lutfi/Documents/Projects/dompet/dompet_app`, implementasi `docs/0001_FIXING_PLAN.md` FIX-01 lalu FIX-02 berurutan. Patuhi acceptance + file target + jangan-ubah. Validasi B1 (TC-IN-005/OUT-005/TRF-004/BGT-005 + logout/ganti-akun). Return file diubah + hasil tes."
>
> **Worker Batch 3 (FIX-04→05→06):** "Implementasi FIX-04 lalu FIX-05 lalu FIX-06 atomik satu worker. Hormati aturan eksklusisi §2.4. Validasi B3. Return diff + bukti angka report tak ganda."
>
> **Worker Batch 4 (FIX-07→09→10):** "Implementasi FIX-07 lalu FIX-09 lalu FIX-10. 2-jurnal harus satu `db.transaction` atomik + 4 sinyal. Validasi B4 termasuk TC-BGT-011."
>
> Pola sama untuk Batch 2, 5, 6, 7. Tanpa handoff paralel di file yang sama.