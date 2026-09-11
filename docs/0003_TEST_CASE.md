# TEST CASE Fase-3 — Fitur Tagihan (Tagihan Rutin + Daftar Bayar + Sisihan Target)

> Cakupan: fitur Tagihan yang dibuat di `feat: bill` + `feat: linkup yearly bill and saving feature` (plan `BillPlan`, sinkronisasi malas, daftar bayar, bayar dari Dompet, target sisihan tahunan + bayar dari Target).
> Format ikut `0001_TEST_CASE.md`: Prakondisi → Langkah → Ekspektasi → Efek samping. Tag `[P]` = Positif, `[N]` = Negatif, `[E]` = Edge/Boundary.
> Bahasa UI ikut `DOCUMENT.md` + kode: **Tagihan**, **Tagihan Rutin**, **Tagihan Tertunda**, **Buat Tagihan Rutin**, **Jadwal Ditagih**, **Jadwal Jatuh Tempo**, **Banyak Tagihan**, **Catat Pembayaran**, **Bayar dari Target**, **Dana Sisihan**, **Samakan**.
> Cara pakai: jalankan berurutan (§1 → §7). Setiap TC mencatat saldo dompet (`S0`), Total Uang (`T0`), total tertunda banner (`P0`), dan journal count sebelum aksi saldo.
>
> Status otomatisasi (`integration_test/bill_flow_test.dart` — 26 test hijau di device via `flutter test integration_test/bill_flow_test.dart`, plus unit `test/features/bills/` + `test/features/splash/splash_cubit_test.dart`):
> `✅` = logika + efek samping (saldo / Total Uang / banner tertunda / anggaran / laporan) terverifikasi otomatis dan lolos.
> `-` = masih manual. Teks snackbar, layout, dialog, dan interaksi UI murni (schedule picker, bottom sheet, switch/stepper, navigasi) tetap dicek manual meski TC bertanda ✅.
> Cakupan: 62 dari 74 TC bertanda ✅. Belum otomatis (12 TC UI-murni): TC-BLP-007 (pemilih kategori expense-only), TC-BLP-011 (reset jadwal), TC-BLP-013 (picker 2 tahap), TC-BLP-017 (firstDate berakhir), TC-BLL-009 (dialog batal hapus), TC-BIL-013/014 (sheet tanpa dompet / tutup sheet), TC-SNK-001/003 (dialog + CTA sisihan), TC-SNK-007 (tombol disabled), TC-BINT-002 (tab Shell), TC-BSCH-006 (offline).
> Perbaikan kode dari temuan automation: TC-BINT-006 (void payment kini mengembalikan bill ke unpaid — `JournalRepository.deleteJournal`), TC-BINT-007 (tombol `Perbaiki` disembunyikan untuk payment Tagihan — form expense hasil mapping kosong), TC-BINT-009 (detail jurnal `bill_generated` tak lagi crash + full read-only — tanpa `Perbaiki`/`Hapus`), TC-BINT-010 (J1 bayar-dari-Target bawa `bill_id` di metadata + terkunci di UI + void cascade J1+J2/buka kunci bill).

**Setup data dasar (sama 0001 + Tagihan):**
- 2 Dompet aktif (`Tunai` Rp1.000.000, `BCA` Rp5.000.000), 1 Kategori Pengeluaran (`Listrik`), 1 Kategori Pengeluaran (`Pajak Motor`).
- 1 Tagihan Rutin bulanan (`Listrik Rumah` Rp100.000, Ditagih Tanggal 5, Tempo Tanggal 10, pengingat H-3).
- 1 Tagihan Rutin tahunan (`Pajak Motor` Rp1.200.000, Ditagih 5 Jan, Tempo 10 Jan) bila menguji §6.
- Catat **Total Uang** awal (`T0`), saldo dompet (`S0`), banner `Tagihan tertunda` (`P0`), dan journal count sebelum tiap aksi bayar/sinkronisasi.
- Format nominal: bilangan bulat, tanpa desimal, tanpa negatif. Pisahkan ribu dengan titik.

**Prinsip akuntansi Tagihan (contekan, terverifikasi di kode):**
- Saat ditagih (aktivasi/draft→unpaid / generate periode): jurnal `bill_generated` posted — Dr beban kategori / Kr Tagihan Tertunda. Dompet & Total Uang TIDAK berubah.
- Saat bayar dari Dompet: jurnal `bill_payment` posted — Dr Tagihan Tertunda / Kr Dompet (+ jurnal `adjustment` selisih dulu bila saldo kurang, pola sama seperti Pengeluaran/Transfer). Dompet & Total Uang berkurang penuh.
- Saat bayar dari Target: J1 withdraw Target→Dompet (`source=saving`) + J2 `bill_payment`. Dompet neto 0, Total Uang tetap, Target berkurang.
- Laporan/Laporan per kategori/Ringkasan Hari Ini HANYA membaca `source IN (transaction, saving)` → Tagihan tidak masuk metrik mana pun. Anggaran (`v_budget_tracker`) menjumlah SEMUA jurnal posted pada akun expense → jurnal `bill_generated` ikut `actualSpend` (verifikasi di TC-BINT-004).

---

## 1. Tagihan Rutin — Buat (Form)

### TC-BLP-001 — Buat tagihan rutin bulanan lengkap [P]
- **Prakondisi:** Drawer/menu → Tagihan → ikon `Tagihan rutin` → FAB `+` (halaman `Buat Tagihan Rutin`). Kategori `Listrik` ada.
- **Langkah:**
  1. Nominal `100000`, Nama `Listrik Rumah`, Kategori `Listrik`, Penanda `IDPEL 123`.
  2. Periode `Bulanan`, Jadwal Ditagih `Tanggal 5`, Jadwal Jatuh Tempo `Tanggal 10`.
  3. Kosongkan Tanggal Berakhir, isi Keterangan `Listrik rumah`.
  4. Biarkan pengingat aktif H-3 → `Simpan`.
- **Ekspektasi:** Snackbar `Tagihan rutin berhasil disimpan`, kembali ke list, plan muncul (nama, Rp100.000, `Listrik • Bulanan • 5 → 10`).
- **Efek samping:**
  - Tanpa jurnal (jurnal `bill_generated` baru ditulis saat aktivasi, bukan saat simpan)
  - Total Uang & saldo dompet tetap
  - tanpa draft (bulk default mati).
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-002 — Buat tanpa tanggal berakhir = tanpa draft [P]
- **Prakondisi:** Di form buat, jadwal sudah lengkap.
- **Langkah:**
  1. Pastikan `Tanggal Berakhir` kosong → perhatikan area checkbox bulk.
  2. Simpan.
- **Ekspektasi:** Checkbox `Buat semua tagihan sekaligus` tidak tampil (hanya muncul bila Tanggal Berakhir terisi). Plan tersimpan tanpa satu pun tagihan.
- **Efek samping:** Detail plan → `Tagihan Terbaru` = `Belum ada tagihan.`
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-003 — Tanggal Berakhir ⇄ Banyak Tagihan saling mengisi [P]
- **Prakondisi:** Di form buat, Periode Bulanan, Ditagih Tanggal 5.
- **Langkah:**
  1. Isi Tanggal Berakhir = kemunculan billed ke-3 dari kini → cek field Banyak Tagihan.
  2. Ubah Banyak Tagihan jadi `12` → cek Tanggal Berakhir.
  3. Centang `Buat semua tagihan sekaligus` → baca subtitle → Simpan.
- **Ekspektasi:** Step 1 → Banyak Tagihan terisi `3`. Step 2 → Tanggal Berakhir = tanggal billed ke-12. Subtitle `Akan dibuat 3 tagihan (draft)` (sesuai count). Simpan → 3 draft status `Terjadwal`.
- **Efek samping:** Draft berurutan tanggal, nominal = plan, `reminded = due − H-n`, periode `yyyy-MM` unik.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-004 — Bulk mati walau Tanggal Berakhir terisi [P]
- **Prakondisi:** Di form buat, Tanggal Berakhir terisi (checkbox bulk tampil).
- **Langkah:**
  1. Biarkan checkbox `Buat semua tagihan sekaligus` mati → Simpan.
  2. Buka detail plan.
- **Ekspektasi:** Plan tersimpan, subtitle/count hanya preview. Detail → `Belum ada tagihan.` (Tanggal Berakhir tersimpan sebagai batas generate malas, bukan draft).
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-005 — Nominal kosong / 0 / negatif ditolak [N]
- **Prakondisi:** Di form buat, field lain valid.
- **Langkah:**
  1. Kosongkan nominal → Simpan.
  2. Isi `0` → Simpan.
- **Ekspektasi:** Keduanya ditolak, snackbar prioritas `Nominal tagihan belum diisi` (repo: `Nominal harus lebih dari 0`). Tanpa plan baru, tanpa jurnal.
- **Efek samping:** DB plan count tetap.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-006 — Nama kosong ditolak [N]
- **Langkah:**
  1. Isi nominal valid, kosongkan Nama Tagihan → Simpan.
- **Ekspektasi:** Error `Masukkan nama tagihan terlebih dahulu` (repo: `Nama tagihan belum diisi`).
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-007 — Kategori wajib & hanya Pengeluaran [N]
- **Langkah:**
  1. Kosongkan Kategori → Simpan.
  2. Buka pemilih kategori → cek tipe yang tampil.
- **Ekspektasi:** Step 1 → `Pilih kategori terlebih dahulu`. Step 2 → hanya kategori Pengeluaran (expense) yang bisa dipilih.
- **Integration test**: -
- **Manual test**: -

### TC-BLP-008 — Jadwal tagih & tempo wajib [N]
- **Langkah:**
  1. Kosongkan Jadwal Ditagih → Simpan.
  2. Isi Ditagih, kosongkan Jatuh Tempo → Simpan.
- **Ekspektasi:** `Pilih jadwal tagih dahulu` lalu `Pilih jadwal jatuh tempo dahulu`.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-009 — Monthly: tagih ≥ tempo ditolak [N]
- **Prakondisi:** Periode Bulanan.
- **Langkah:**
  1. Ditagih `Tanggal 10`, Tempo `Tanggal 5` → Simpan.
  2. Ditagih = Tempo (`Tanggal 10` = `Tanggal 10`) → Simpan.
- **Ekspektasi:** Keduanya `Jadwal tagih harus sebelum jatuh tempo` (validasi form + repo, cermin CHECK schema). Tidak tersimpan.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-010 — Monthly: tagih 28 + tempo Hari terakhir lolos [E]
- **Langkah:**
  1. Ditagih `Tanggal 28`, Tempo `Hari terakhir` → Simpan.
- **Ekspektasi:** Berhasil (`28 < last_day`, order pakai `monthlyDayOrder` dengan `last_day=99`).
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-011 — Ganti periode me-reset kedua jadwal [E]
- **Prakondisi:** Periode Bulanan, kedua jadwal sudah terisi.
- **Langkah:**
  1. Ganti Periode ke `Tahunan` → cek kedua field jadwal.
- **Ekspektasi:** Jadwal Ditagih & Jatuh Tempo ter-reset (null) karena format monthly/yearly tidak kompatibel. Wajib pilih ulang sebelum simpan.
- **Integration test**: -
- **Manual test**: -

### TC-BLP-012 — Yearly: tempo boleh lintas tahun [P]
- **Langkah:**
  1. Periode `Tahunan`, Ditagih `20 Desember`, Tempo `5 Januari` → cek tips → Simpan.
- **Ekspektasi:** Berhasil (yearly bebas urutan; due jatuh di tahun billed+1). Tips `pilih awal bulan dari tanggal jatuh tempo...` tampil di bawah Jadwal Ditagih.
- **Efek samping:** Draft/bill periode = tahun billed (`2026`), dueDate tahun+1.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-013 — Yearly picker dua tahap tanpa Hari Terakhir [P]
- **Langkah:**
  1. Tap Jadwal Ditagih (mode Tahunan) → pilih bulan Februari → cek grid tanggal.
- **Ekspektasi:** Tahap 1 grid bulan 3 kolom → tahap 2 grid tanggal penuh sesuai bulan. Februari dibatasi 28, tanpa opsi `Hari terakhir`.
- **Integration test**: -
- **Manual test**: -

### TC-BLP-014 — Pengingat: maks = selisih tagih–tempo [E]
- **Prakondisi:** Bulanan, Ditagih Tanggal 5, Tempo Tanggal 10 (selisih 5).
- **Langkah:**
  1. Naikkan stepper hingga mentok → baca label.
  2. Ganti Tempo ke Tanggal 6 (selisih 1) → cek nilai pengingat.
  3. Set Ditagih = Tempo−0 (selisih 0, mis. Ditagih 28 + Tempo `Hari terakhir` dihitung 28→28) → cek switch.
- **Ekspektasi:** Step 1 mentok `H-5 sebelum jatuh tempo • maks H-5`, tombol `+` disabled. Step 2 nilai ter-clamp otomatis ke maks baru. Step 3 switch dipaksa mati (`Tanpa pengingat`, `Tidak tersedia untuk jadwal ini` bila maks 0).
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-015 — Pengingat mati = 0, simpan tanpa pengingat [P]
- **Langkah:**
  1. Matikan switch `Aktifkan Pengingat` → Simpan.
  2. Buka detail plan → cek baris Pengingat.
- **Ekspektasi:** Tersimpan (`reminderDays=0`). Detail tampil `Tanpa pengingat`. Tagihan aktif tidak pernah masuk seksi `Perlu Dibayar` via jendela reminder (hanya bila terlambat).
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-016 — Banyak Tagihan 0 ditolak [N]
- **Langkah:**
  1. Isi Tanggal Berakhir valid, isi Banyak Tagihan `0` → Simpan.
- **Ekspektasi:** Error `Minimal 1 tagihan`, tidak tersimpan.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLP-017 — Tanggal Berakhir lampau diblokir picker [N]
- **Langkah:**
  1. Buka picker Tanggal Berakhir → coba pilih kemarin.
- **Ekspektasi:** Tidak bisa (`firstDate` hari ini). Clear memungkinkan (opsional, tombol clear tampil).
- **Integration test**: -
- **Manual test**: -

### TC-BLP-018 — Satu kategori boleh banyak tagihan rutin [P]
- **Prakondisi:** Kategori `Listrik` sudah dipakai `Listrik Rumah`.
- **Langkah:**
  1. Buat lagi `Listrik Kos` kategori `Listrik` (Penanda beda) → Simpan.
  2. Buka list Tagihan Rutin.
- **Ekspektasi:** Berhasil, keduanya tampil dengan kategori `Listrik`. Tile memakai Penanda bila ada (`IDPEL ... • Bulanan • ...`), jika tidak memakai nama kategori.
- **Integration test**: ✅
- **Manual test**: -

---

## 2. Tagihan Rutin — Daftar, Detail, Ubah, Hapus

### TC-BLL-001 — Daftar + search + empty state [P]
- **Prakondisi:** Ada `Listrik Rumah`, `Pajak Motor`. Dibuka via ikon kalender di halaman Tagihan.
- **Langkah:**
  1. Buka `Tagihan Rutin` → cek urutan & isi tile.
  2. Ketik `lis` → tunggu → clear via tombol clear.
  3. Ketik `xyz-tidak-ada`.
- **Ekspektasi:** Tile: ikon kategori, nama, nominal primer, baris `Penanda/Kategori • Bulanan/Tahunan • 5 → 10`. Search filter nama (debounce ~300ms, case-insensitive). Clear → semua kembali. Tanpa hasil → `Tidak ada tagihan yang cocok. Coba kata kunci lain.` Kosong total → `Belum ada tagihan rutin. Buat dari tombol + di halaman ini.`
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-002 — Plan berakhir bertanda di list & detail [E]
- **Prakondisi:** Plan dengan Tanggal Berakhir kemarin (buat via bulk lalu tunggu / set endedAt lalu).
- **Langkah:**
  1. Lihat tile di list + buka detail → baris `Berakhir`.
- **Ekspektasi:** Tile suffix `• Berakhir`. Detail: tanggal + `• Berakhir`. Tanpa batas → `Tanpa batas akhir`.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-003 — Detail plan: kartu info lengkap [P]
- **Langkah:**
  1. Tap `Listrik Rumah` → cek header + kartu + riwayat + tombol bawah.
- **Ekspektasi:** Header ikon + nama + kategori. Kartu: `Nominal Tagihan` headline primer, `Ditagih setiap: Bulanan • Tanggal 5`, `Jatuh tempo: Tanggal 10`, `Pengingat: H-3 sebelum jatuh tempo`, `Berakhir: ...`. Penanda & Keterangan tampil bila ada (divider). Bawah: `Ubah Tagihan Rutin` (outlined) + `Hapus Tagihan Rutin` (teks merah).
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-004 — Riwayat plan max 5 + Lihat Semua [P]
- **Prakondisi:** Plan dengan >5 tagihan (bulk 6+ / tunggu generate).
- **Langkah:**
  1. Lihat seksi `Tagihan Terbaru`.
  2. Tap `Lihat Semua`.
- **Ekspektasi:** Max 5 terbaru. `Lihat Semua` → halaman `Tagihan • {nama}` (paginasi, empty `Belum ada tagihan.`). Tap tile → detail tagihan.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-005 — Ubah plan: kategori terkunci, info lain bebas [P]
- **Prakondisi:** Detail `Listrik Rumah`.
- **Langkah:**
  1. `Ubah Tagihan Rutin` → cek field Kategori.
  2. Ganti Nama + Nominal (100.000 → 150.000) → `Simpan Perubahan`.
- **Ekspektasi:** Kategori read-only (tidak bisa diganti). Sukses `Tagihan rutin berhasil diubah`. Nominal/jadwal/pengingat update di detail.
- **Efek samping:** Tagihan aktif (unpaid/paid) nominalnya TETAP (jurnal lama tidak ditulis ulang); hanya draft yang diregenerasi bila bulk.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-006 — Ubah + bulk: draft lama diganti nominal baru [P]
- **Prakondisi:** Plan bulk 2 draft nominal Rp1.000.000.
- **Langkah:**
  1. Ubah nominal jadi Rp1.200.000 + bulk aktif endedAt sama → Simpan.
- **Ekspektasi:** Draft lama (nominal lama) dibuang, 2 draft baru nominal Rp1.200.000. ID plan sama.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-007 — Ubah tanpa bulk: tanpa tagihan baru [P]
- **Langkah:**
  1. Ubah plan tanpa draft (nama saja) → Simpan → cek riwayat.
- **Ekspektasi:** ID sama, tanpa tagihan baru, riwayat tetap.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-008 — Hapus plan: draft ikut, aktif utuh, target unlink [P]
- **Prakondisi:** Plan punya 2 draft + 1 unpaid aktif + 1 target sisihan ter-link (yearly). Catat `T0`, dana target.
- **Langkah:**
  1. `Hapus Tagihan Rutin` → baca dialog → konfirmasi (`Hapus`).
  2. Cek list plan, daftar bayar, dan target.
- **Ekspektasi:** Dialog `Hapus tagihan rutin?` + `"..." akan dihapus. Tagihan terjadwal yang belum aktif ikut dihapus. Tagihan yang sudah aktif tidak akan ikut dihapus.` Sukses → pop ke list, plan hilang.
- **Efek samping:**
  - Plan soft-delete; draft soft-delete
  - unpaid aktif tetap ada & tetap bisa dibayar
  - target sisihan tetap ada sebagai target biasa (link di-null-kan), dana aman
  - Total Uang & saldo tetap.
- **Integration test**: ✅
- **Manual test**: -

### TC-BLL-009 — Batal hapus plan [N]
- **Langkah:**
  1. `Hapus Tagihan Rutin` → pilih `Batal`.
- **Ekspektasi:** Abort, plan + draft + link target utuh.
- **Integration test**: -
- **Manual test**: -

---

## 3. Sinkronisasi Malas & Daftar Bayar

### TC-BIL-001 — Draft tiba waktunya → aktif + jurnal akrual [P]
- **Prakondisi:** Draft billed hari ini (bulk dengan billedSchedule = tanggal hari ini). Catat `T0`, saldo BCA `B0`, `P0`.
- **Langkah:**
  1. Buka halaman Tagihan (memicu `synchronizeBills`).
  2. Cek status tagihan + banner + Total Uang.
- **Ekspektasi:** Draft → `unpaid` + 1 jurnal `bill_generated` posted (desc `Tagihan {nama} • {periode}`, entryDate = billedAt). Banner `Tagihan tertunda` bertambah nominal plan. Total Uang & saldo dompet TETAP (akrual, kas belum keluar).
- **Efek samping:** Panggil ulang sinkronisasi → 0 tersentuh (idempoten, tanpa jurnal ganda).
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-002 — Generate otomatis periode berjalan [P]
- **Prakondisi:** Plan bulanan tanpa tagihan periode ini, billed bulan ini sudah lewat (mis. Ditagih Tanggal 5, kini Tanggal 20).
- **Langkah:**
  1. Buka halaman Tagihan.
- **Ekspektasi:** 1 tagihan `unpaid` periode `yyyy-MM` kini langsung terbuat + jurnal `bill_generated`. Tidak menunggu aksi lain.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-003 — Belum waktunya = belum ada tagihan [E]
- **Prakondisi:** Plan Ditagih Tanggal 20, kini Tanggal 5 (bulan sama).
- **Langkah:**
  1. Buka halaman Tagihan → cek daftar + detail plan.
- **Ekspektasi:** Periode berjalan belum terbuat. Tagihan muncul setelah Tanggal 20 (buka ulang halaman).
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-004 — Plan berakhir tidak generate lagi [E]
- **Prakondisi:** Plan endedAt sebelum billed periode berjalan.
- **Langkah:**
  1. Buka halaman Tagihan.
- **Ekspektasi:** Tidak ada tagihan periode berjalan. Tagihan lama (aktif/lunas) tetap tampil.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-005 — Seksi daftar: Perlu Dibayar / Mendatang / Selesai [P]
- **Prakondisi:** Ada unpaid dalam jendela reminder (H-3 s.d. tempo), unpaid jauh tempo, dan 1 lunas.
- **Langkah:**
  1. Buka halaman Tagihan.
- **Ekspektasi:** Tiga seksi `Perlu Dibayar` (reminder tiba / terlambat), `Mendatang` (sisanya), `Selesai` (max 10 lunas terbaru). Urut billed menaik di seksi aktif.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-006 — Search daftar bayar + empty state [P]
- **Langkah:**
  1. Ketik `lis` → tunggu → clear.
  2. Ketik `xyz-tidak-ada`.
  3. Dengan DB tanpa tagihan sama sekali → buka halaman.
- **Ekspektasi:** Filter nama plan (debounce 300ms, case-insensitive, termasuk seksi Selesai). Clear → fetch ulang penuh. Tanpa hasil → empty search + reset. Kosong total → `Belum ada tagihan.` + `Buat tagihan rutin dulu agar tagihan muncul otomatis.` + CTA `Kelola Tagihan Rutin` → list plan.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-007 — Label status tile & detail [P]
- **Prakondisi:** Ada draft (Terjadwal), unpaid biasa, unpaid jendela reminder, dan lunas.
- **Langkah:**
  1. Bandingkan badge di tile + chip di detail untuk tiap status.
- **Ekspektasi:** `Terjadwal` (netral, drafted), `Belum dibayar` (primer), `Segera dibayar` (primer, reminder tiba & belum tempo), `Lunas` (tersier). Label + warna tile = chip detail.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-008 — Tagihan lewat jatuh tempo: verifikasi label [E]
- **Prakondisi:** Unpaid yang dueDate-nya sudah lewat (ubah jam sistem / tunggu lewat tempo).
- **Langkah:**
  1. Buka daftar + detail tagihan tsb.
  2. Cek seksi daftar (harus di `Perlu Dibayar`) dan label badge.
- **Ekspektasi:** Masuk `Perlu Dibayar` (aturan `isOverdueAt`). Label badge mengikuti cabang status tersimpan — catat label aktual yang tampil vs ekspektasi `Terlambat` bila berbeda, laporkan sebagai temuan UI (status `overdue` turunan waktu, tidak tersimpan di DB).
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-020 — Sync tagihan saat buka aplikasi (splash) [P]
- **Prakondisi:** Plan bulanan tanpa tagihan periode ini, billed bulan ini sudah lewat (mis. Ditagih Tanggal 5, kini Tanggal 20). User belum buka halaman Tagihan sama sekali. Catat `P0`, journal count `bill_generated`.
- **Langkah:**
  1. Tutup lalu buka ulang aplikasi (jalankan `SplashCubit.check()`).
  2. Cek daftar Tagihan + banner `Tagihan tertunda` tanpa membuka halaman Tagihan dulu.
- **Ekspektasi:** Splash `alreadySet` + 1 tagihan `unpaid` periode `yyyy-MM` kini langsung terbuat + 1 jurnal `bill_generated` posted. Banner `P0 + nominal`, Total Uang & saldo dompet tetap (akrual). Idempoten: splash kedua tanpa periode baru → 0 tersentuh.
- **Efek samping:** Bila sync gagal → splash `error` (blokir navigasi, bukan diam-diam lolos) agar ketahuan saat testing. Bila belum ada dompet (`needToBeSet`) → sync tidak jalan.
- **Integration test**: ✅
- **Manual test**: -

---

## 4. Detail Tagihan & Bayar dari Dompet

### TC-BIL-009 — Detail unpaid: kartu + riwayat + tombol bayar [P]
- **Langkah:**
  1. Tap tagihan unpaid tanpa target sisihan.
- **Ekspektasi:** Kartu: nama plan + chip, nominal headline primer, `Periode`, `Ditagih`, `Jatuh tempo`, `Pengingat` (tanggal penuh + hari). Penanda bila ada. Riwayat: `Tagihan dibuat` (ikon kwitansi). Bawah: satu tombol `Catat Pembayaran • RpX`.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-010 — Detail draft: banner Terjadwal, tanpa tombol [P]
- **Langkah:**
  1. Tap tagihan `Terjadwal` (draft, via detail plan).
- **Ekspektasi:** Kartu tetap tampil. Bawah bukan tombol melainkan banner netral `Terjadwal` + `Akan ditagih pada {tanggal}`. Tidak ada cara bayar dari sini.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-011 — Bayar lunas dari Dompet saldo cukup [P]
- **Prakondisi:** Unpaid Rp100.000. BCA `B0`, Total `T0`, banner `P0`. Dana BCA cukup.
- **Langkah:**
  1. `Catat Pembayaran` → sheet `Bayar dari` → pilih BCA → `Bayar Rp100.000`.
- **Ekspektasi:** Loading `Mencatat pembayaran...` → `Pembayaran berhasil dicatat`. Detail refresh → banner `Lunas` + baris `Dibayar pada` + riwayat `Pembayaran`.
- **Efek samping:**
  - BCA = `B0 − 100.000`, Total = `T0 − 100.000`, banner = `P0 − 100.000`
  - 1 jurnal `bill_payment` posted (Dr Tagihan Tertunda / Kr BCA), status bill → paid
  - tanpa jurnal adjustment
  - Laporan/Ringkasan/Anggaran bulan ini tidak berubah (source bill dikecualikan).
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-012 — Bayar saat saldo kurang: auto-adjustment tanpa dialog [E]
- **Prakondisi:** Unpaid Rp100.000, Tunai saldo Rp0. Catat journal count + saldo.
- **Langkah:**
  1. Bayar dari Tunai → Simpan.
- **Ekspektasi:** Berhasil TANPA dialog konfirmasi overdraw (beda dengan Pengeluaran/Transfer). Urutan jurnal: (1) `adjustment` selisih Rp100.000, (2) `bill_payment` penuh. Atomik (gagal tengah = rollback semua).
- **Efek samping:** Saldo Tunai akhir 0 (di-top-up lalu terpotong habis), Total −100.000. Tidak ada saldo negatif.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-013 — Sheet bayar tanpa pilih dompet [N]
- **Langkah:**
  1. `Catat Pembayaran` → langsung tap `Bayar RpX` tanpa pilih Dompet.
- **Ekspektasi:** Sheet tidak tertutup, validasi dompet tampil, tanpa jurnal, status tetap unpaid.
- **Integration test**: -
- **Manual test**: -

### TC-BIL-014 — Tutup sheet = batal bayar [N]
- **Langkah:**
  1. `Catat Pembayaran` → swipe-tutup / back tanpa pilih.
- **Ekspektasi:** Abort, tanpa jurnal, saldo & status tetap.
- **Integration test**: -
- **Manual test**: -

### TC-BIL-015 — Bayar dua kali ditolak [N]
- **Prakondisi:** Tagihan sudah `Lunas`.
- **Langkah:**
  1. Coba bayar lagi (via refresh/state lama / repo langsung).
- **Ekspektasi:** Gagal `Tagihan ini tidak bisa dibayar`. Hanya 1 jurnal `bill_payment` untuk bill tsb. Detail tetap `Lunas`.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-016 — Bayar tagihan terjadwal ditolak [N]
- **Prakondisi:** Draft `Terjadwal`.
- **Langkah:**
  1. Coba bayar via repo/`payBill` langsung (UI tidak menyediakan tombol).
- **Ekspektasi:** Gagal `Tagihan ini tidak bisa dibayar`, tanpa jurnal.
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-017 — Bayar dengan dompet tak dikenal / tagihan hilang [N]
- **Langkah:**
  1. Bayar dengan `assetId` fiktif → cek pesan.
  2. Bayar `billId` fiktif → cek pesan.
- **Ekspektasi:** `Dompet tidak ditemukan` / `Tagihan tidak ditemukan`. Tanpa jurnal parsial (transaksi rollback).
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-018 — Detail lunas: banner + riwayat groei 2 entri [P]
- **Prakondisi:** Setelah TC-BIL-011.
- **Langkah:**
  1. Buka detail tagihan lunas → cek bawah + riwayat.
- **Ekspektasi:** Banner hijau `Lunas` + `Dibayar pada {tanggal}`. Riwayat 2 baris: `Tagihan dibuat` + `Pembayaran` (ikon centang, terbaru dulu).
- **Integration test**: ✅
- **Manual test**: -

### TC-BIL-019 — Nominal bayar selalu penuh, tanpa cicilan [E]
- **Prakondisi:** Unpaid Rp1.200.000.
- **Langkah:**
  1. Buka sheet bayar → verifikasi tidak ada field nominal.
- **Ekspektasi:** Sheet hanya pemilih Dompet; tombol `Bayar Rp1.200.000` fixed. Bayar sebagian tidak didukung — harus lunas sekaligus.
- **Integration test**: ✅
- **Manual test**: -

---

## 5. Target Sisihan & Bayar dari Target (Yearly only)

> Hanya periode Tahunan. Penawaran + seksi sisihan di-gate `period == yearly`.

### TC-SNK-001 — Tawaran sisihan setelah buat yearly baru [P]
- **Prakondisi:** Belum ada target untuk kemunculan terdekat `Pajak Motor`.
- **Langkah:**
  1. Buat plan yearly `Pajak Motor` Rp1.200.000 (tempo ~12 bulan lagi) → Simpan.
  2. Baca dialog → pilih `Buat Target`.
- **Ekspektasi:** Dialog `Sisihkan dana bulanan?` + `"Pajak Motor" Rp1.200.000 jatuh tempo {tgl}. Buat target sisihan sekitar RpX/bulan dan pantau di fitur Target?` (X = ceil(amount/bulan), min 1 bln). `Buat Target` → ganti halaman ke form Target terisi (`Dana Pajak Motor`, nominal = plan, tanggal = due terdekat, `Sisihan Pajak Motor`, ter-link periode terdekat). Back → list (bukan form basi).
- **Integration test**: -
- **Manual test**: -

### TC-SNK-002 — Tolak tawaran / target sudah ada [N/E]
- **Langkah:**
  1. Ulangi TC-SNK-001 tapi pilih `Nanti`.
  2. Buat yearly lain yang kemunculannya sudah punya target → Simpan.
- **Ekspektasi:** Step 1 → pop biasa ke list, tanpa form Target. Step 2 → dialog tidak muncul (sudah ada target ter-link), langsung pop.
- **Integration test**: ✅
- **Manual test**: -

### TC-SNK-003 — CTA sisihan di detail plan & detail tagihan [P]
- **Prakondisi:** Plan yearly tanpa target ter-link.
- **Langkah:**
  1. Detail plan → cek seksi sisihan.
  2. Detail tagihan unpaid plan tsb → cek CTA.
- **Ekspektasi:** Keduanya tampil kartu `Sisihkan dana tiap bulan agar ringan saat jatuh tempo.` + `Buat Target Sisihan` → form Target prefill sama seperti TC-SNK-001. Plan/bill monthly TIDAK menampilkan seksi ini.
- **Integration test**: -
- **Manual test**: -

### TC-SNK-004 — Kartu Dana Sisihan: progres + kebutuhan/bulan + navigasi [P]
- **Prakondisi:** Yearly + target ter-link (sudah alokasi sebagian).
- **Langkah:**
  1. Detail plan → cek kartu `Dana Sisihan • {periode}`.
  2. Tap kartu.
- **Ekspektasi:** Progress bar (clamp 100%), label progres, `Sisa RpX • ±RpY/bulan`. Tap → detail Target. Tanpa target-amount → hanya terkumpul (tanpa rate).
- **Integration test**: ✅
- **Manual test**: -

### TC-SNK-005 — Nominal plan berubah → peringatan + Samakan [P]
- **Prakondisi:** Yearly Rp1.200.000 + target ter-link Rp1.200.000.
- **Langkah:**
  1. Ubah plan jadi Rp1.500.000 → buka detail plan.
  2. Tap `Samakan`.
- **Ekspektasi:** Baris merah `Nominal tagihan berubah menjadi Rp1.500.000.` + tombol `Samakan`. Sukses → `Target disamakan dengan nominal tagihan`, warning hilang, nominal target = Rp1.500.000.
- **Efek samping:** Hanya kolom targetAmount yang berubah; saldo simpanan & link tetap.
- **Integration test**: ✅
- **Manual test**: -

### TC-SNK-006 — Bayar dari Target saldo cukup [P]
- **Prakondisi:** Bill yearly unpaid Rp1.200.000 + target ter-link saldo ≥ Rp1.200.000. Dompet perantara BCA `B0`, Total `T0`, target `G0`.
- **Langkah:**
  1. Detail tagihan → `Bayar dari Target • Rp1.200.000` → pilih BCA → konfirmasi.
  2. Cek ketiga saldo + status + detail target.
- **Ekspektasi:** Sukses `Tagihan dibayar dari {nama target}`. Status → Lunas.
- **Efek samping:**
  - Target = `G0 − 1.200.000`; BCA neto TETAP `B0` (J1 +1.200.000, J2 −1.200.000); Total TETAP `T0`
  - 2 jurnal atomik posted: J1 withdraw saving (pocket→BCA, masuk histori Target), J2 `bill_payment`
  - tanpa adjustment shortfall dompet (kecukupan dicek di pocket, bukan dompet).
- **Integration test**: ✅
- **Manual test**: -

### TC-SNK-007 — Tombol pocket disabled bila saldo kurang [N]
- **Prakondisi:** Target ter-link saldo < nominal tagihan.
- **Langkah:**
  1. Buka detail tagihan → cek tombol + teks.
- **Ekspektasi:** `Bayar dari Target` disabled + teks merah `Saldo {nama} {saldo} belum cukup.` Tombol `Bayar dari Dompet` (outlined) tetap aktif sebagai jalan keluar.
- **Integration test**: -
- **Manual test**: -

### TC-SNK-008 — Paksa bayar pocket saldo kurang → atomik gagal [N]
- **Prakondisi:** Sama TC-SNK-007 (panggil repo langsung / state lama).
- **Langkah:**
  1. Paksa `payBillFromPocket` → cek pesan + saldo + jurnal.
- **Ekspektasi:** Gagal `Saldo target tidak mencukupi`. Target/dompet/Total tetap, 0 jurnal baru, status tetap unpaid.
- **Integration test**: ✅
- **Manual test**: -

### TC-SNK-009 — Target sisihan tidak bisa Belanja [N]
- **Prakondisi:** Target ter-link ada saldo.
- **Langkah:**
  1. Detail Target → coba `Belanja` dari target tsb.
- **Ekspektasi:** Ditolak `Target sisihan tagihan tidak bisa dibelanjakan, gunakan Bayar Tagihan`. Saldo tetap. (Keluar dana hanya via Tarik atau Bayar Tagihan.)
- **Integration test**: ✅
- **Manual test**: -

### TC-SNK-010 — Bayar langsung dari detail Target [P]
- **Prakondisi:** Target ter-link + bill kemunculan tsb sudah unpaid.
- **Langkah:**
  1. Detail Target → seksi `Tagihan Terkait • {periode}` → bayar → pilih dompet perantara.
- **Ekspektasi:** Sukses `Tagihan berhasil dibayar dari target`. Status bill → Lunas di kedua halaman (sinyal Bill+Saving+Account). Efek saldo sama TC-SNK-006.
- **Integration test**: ✅
- **Manual test**: -

### TC-SNK-011 — Bill belum generate di detail Target [E]
- **Prakondisi:** Target ter-link untuk periode yang bill-nya belum tergenerate (draft masa depan / plan tanpa draft).
- **Langkah:**
  1. Buka detail Target → seksi Tagihan Terkait.
- **Ekspektasi:** Teks `Tagihan belum tergenerate.` + nominal rencana. Tanpa tombol bayar hingga bill aktif.
- **Integration test**: ✅
- **Manual test**: -

---

## 6. Integrasi Lintas Fitur

### TC-BINT-001 — Banner Beranda: muncul, nominal, navigasi [P]
- **Prakondisi:** Ada tagihan aktif total RpX. Catat Total Uang `T0`.
- **Langkah:**
  1. Buka Beranda → cek bawah Total Uang.
  2. Lunasi semua → cek lagi.
  3. Tap banner (saat ada).
- **Ekspektasi:** Banner `Tagihan tertunda` + `RpX menunggu dibayar` hanya bila X > 0 (nol → hilang total, bukan Rp0). Total Uang TIDAK dikurangi X (akrual). Tap → halaman Tagihan. Refresh otomatis via sinyal setelah bayar/sinkronisasi.
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-002 — Tab Tagihan di Shell [P]
- **Langkah:**
  1. Pindah tab Beranda/Aktivitas/Tagihan/Anggaran/Target → cek AppBar + FAB.
- **Ekspektasi:** Label tab `Tagihan`, judul halaman `Tagihan`. FAB konteks tab lain tidak berubah.
- **Integration test**: -
- **Manual test**: -

### TC-BINT-003 — Aktivitas: generated tampil Pengeluaran, payment tampil Tagihan [P]
- **Prakondisi:** Ada jurnal `bill_generated` (periode ini) + 1 `bill_payment` lunas.
- **Langkah:**
  1. Tab Aktivitas → filter `Semua` → cari `Tagihan {nama} • {periode}` dan `Pembayaran ...`.
  2. Filter `Tagihan` → cek isi.
  3. Filter `Pengeluaran` → cek apakah generated ikut.
- **Ekspektasi:** Keduanya tampil di `Semua` (generated sebagai Pengeluaran merah, payment sebagai Tagihan). Filter `Tagihan` hanya payment. Filter `Pengeluaran` hanya `source=transaction` (generated TIDAK ikut — catat perilaku aktual).
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-004 — Anggaran: tagihan ditagih memakan sisa [P]
- **Prakondisi:** Anggaran `Listrik` aktif sisa `R0` (periode mencakup billedAt). Belum ada spend lain periode tsb.
- **Langkah:**
  1. Biarkan sinkronisasi mengaktifkan tagihan `Listrik` periode berjalan.
  2. Buka Detail Anggaran `Listrik`.
- **Ekspektasi:** `actualSpend +nominal plan`, sisa = `R0 − nominal`. Pembayaran (`bill_payment`) TIDAK menambah spend lagi (tidak double-count). Verifikasi angka persis.
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-005 — Laporan & Ringkasan mengecualikan Tagihan [P]
- **Prakondisi:** Bulan ini ada bill_generated + bill_payment + 1 Pengeluaran biasa Rp50.000.
- **Langkah:**
  1. Cek Ringkasan Hari Ini + Laporan bulan ini (ringkas, per kategori, cashflow, tren).
- **Ekspektasi:** Pemasukan/Pengeluaran/net hanya dari transaksi biasa (Rp50.000). Tagihan Rp0 di semua metrik. `transaction_count` tidak naik oleh bill.
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-006 — Detail Aktivitas pembayaran: read & hapus [P]
- **Prakondisi:** Ada payment lunas (catat saldo dompet `S1`, Total `T1`).
- **Langkah:**
  1. Aktivitas → tap payment → cek judul `Detail Pembayaran Tagihan`, chip + nominal merah.
  2. `Hapus` → konfirmasi → cek saldo + status bill.
- **Ekspektasi:** Detail konsisten (kategori/dompet/keterangan atau info saldo sesuai tipe). Hapus = void jurnal (saldo & Total kembali `+nominal`, bill kembali unpaid & bisa dibayar ulang).
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-007 — Perbaiki disembunyikan untuk pembayaran tagihan [E]
- **Prakondisi:** Ada payment lunas.
- **Langkah:**
  1. Aktivitas → tap payment → cek tombol bawah.
- **Ekspektasi:** Hanya tombol `Hapus`, TANPA `Perbaiki`. Alasan (terverifikasi otomatis): jurnal payment hanya menyentuh payable + asset sehingga `toTransactionForm()` menghasilkan form expense berkategori kosong — edit akan merusak data. Nominal tagihan dikunci plan, jadi tidak ada semantik edit yang valid.
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-008 — Konsistensi Total Uang lintas aksi Tagihan [P]
- **Prakondisi:** Catat `T0`. Dompet BCA cukup.
- **Langkah:**
  1. Generate tagihan Rp100.000 → cek `T0` tetap.
  2. Bayar dari BCA → cek `T0 − 100.000`.
  3. Generate Rp50.000 lain → bayar dari Target (target cukup) → cek tetap.
  4. Hapus payment step 2 (void) → cek kembali `+100.000`.
- **Ekspektasi:** Semua sesuai rumus, tidak ada selisih Rp1 pun.
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-009 — Jurnal ditagih read-only di Aktivitas [E]
- **Prakondisi:** Ada jurnal `bill_generated` periode ini (buka tab Aktivitas → tap `Tagihan {nama} • {periode}`).
- **Langkah:**
  1. Buka detail aktivitas tsb → cek isi + tombol bawah.
- **Ekspektasi:** Detail TERBUKA tanpa crash (kartu generik Kategori/Keterangan, nominal merah `-RpX`). TANPA tombol `Perbaiki` maupun `Hapus` — jurnal sistem, kelola via Tagihan Rutin (hapus plan = draft ikut terhapus). Alasan: void/edit akan memutus simetri Kr Tagihan Tertunda vs bill unpaid.
- **Integration test**: ✅
- **Manual test**: -

### TC-BINT-010 — Kaki withdraw bayar-dari-Target terkunci + void cascade [E]
- **Prakondisi:** Bill yearly unpaid Rp1.200.000 + Target ter-link saldo cukup. Catat BCA `B0`, Target `G0`, Total `T0`, journal count.
- **Langkah:**
  1. Bayar dari Target → cek tombol di detail withdraw J1 (Riwayat Target → tap baris withdraw).
  2. Void J1 (via repo/`deleteJournal`, tombol UI disembunyikan) → cek bill, J2, dan ketiga saldo.
  3. Bayar ulang dari Target.
  4. Kontrol: Tarik biasa 50k → cek tombol + void → cek saldo.
- **Ekspektasi:** Step 1 → TANPA `Perbaiki`/`Hapus` (J1 teridentifikasi via metadata `bill_id`). Step 2 → undo penuh atomik: J1+J2 void, bill unpaid + bisa dibayar ulang, BCA/`G0`/`T0` kembali presisi, journal posted −2. Step 3 → paid lagi. Step 4 → Tarik biasa tetap ada kedua tombol; void-nya simetris (tanpa cascade).
- **Integration test**: ✅
- **Manual test**: -

---

## 7. Jadwal, Bulan Pendek & Edge Global

### TC-BSCH-001 — Februari & bulan 30 hari: clamp otomatis [E]
- **Prakondisi:** Plan Ditagih Tanggal 31 (atauTempo `Hari terakhir`).
- **Langkah:**
  1. Lihat billed aktual Februari (tahun kabisat & non-kabisat) + April/Juni.
  2. Cek dueDate tidak mendahului billed.
- **Ekspektasi:** Tanggal di-clamp ke akhir bulan (`monthlyDate` pakai min(day, daysInMonth)). `last_day` selalu = tanggal terakhir bulan tsb. Tidak ada bill dengan due < billed.
- **Integration test**: ✅
- **Manual test**: -

### TC-BSCH-002 — Yearly 29 Feb & ganti tahun [E]
- **Langkah:**
  1. Coba buat yearly Ditagih `02-29` → cek hasil.
  2. Plan yearly Ditagih `12-20` Tempo `01-05` → cek billed/due 2 tahun berurutan.
- **Ekspektasi:** Step 1 mengikuti konstruktor DateTime (catat tanggal aktual tersimpan). Step 2 due selalu billed+~16 hari lintas tahun, label periode = tahun billed.
- **Integration test**: ✅
- **Manual test**: -

### TC-BSCH-003 — Idempoten sinkronisasi ganda [E]
- **Prakondisi:** Ada draft jatuh hari ini + plan perlu generate.
- **Langkah:**
  1. Buka halaman Tagihan 2x cepat (atau panggil `synchronizeBills` 2x) → hitung jurnal `bill_generated` baru.
- **Ekspektasi:** Panggilan pertama menyentuh N, kedua 0. Tepat 1 bill + 1 jurnal per periode (cek pasangan planId+periode unik, tanpa duplikat).
- **Integration test**: ✅
- **Manual test**: -

### TC-BSCH-004 — Nominal sangat besar [E]
- **Langkah:**
  1. Buat plan nominal `999.999.999.999` → generate → bayar dari dompet berdana cukup.
- **Ekspektasi:** Format benar di tile/detail/banner, tidak overflow/crash, saldo akhir presisi.
- **Integration test**: ✅
- **Manual test**: -

### TC-BSCH-005 — Nama/penanda panjang + emoji [E]
- **Langkah:**
  1. Nama 100 char + emoji, Penanda panjang → Simpan → cek list/detail/Aktivitas.
- **Ekspektasi:** Tersimpan, tidak overflow/crash (ellipsis/scroll rapi).
- **Integration test**: ✅
- **Manual test**: -

### TC-BSCH-006 — Offline penuh tetap bisa kelola Tagihan [P]
- **Prakondisi:** Matikan internet.
- **Langkah:**
  1. Buat/ubah/hapus plan, bayar tagihan dari Dompet & Target.
- **Ekspektasi:** Semua offline-first berhasil (Tagihan tidak memakai Drive).
- **Integration test**: -
- **Manual test**: -

---

## Lampiran: Matriks Efek Samping Tagihan (contekan verifikasi)

| Aksi | Saldo Dompet | Total Uang (cair aktif) | Banner Tertunda | Target | Anggaran (sisa) | Laporan/Ringkasan |
|---|---|---|---|---|---|---|
| Buat/ubah plan (tanpa bulk) | – | – | – | – | – | – |
| Bulk generate draft | – | – | – | – | – | – |
| Draft → aktif (`bill_generated`) | – | tetap | + nominal | – | − nominal (ikut actualSpend) | diabaikan |
| Bayar dari Dompet (`bill_payment` + adjustment bila kurang) | − penuh (floor 0) | − penuh | − nominal | – | – (sudah dihitung saat ditagih) | diabaikan |
| Bayar dari Target (J1 withdraw + J2 payment) | neto 0 | tetap | − nominal | − penuh | – | diabaikan (saving withdraw bukan spend) |
| Hapus plan | – | – | – (draft hilang; aktif tetap) | unlink, dana aman | – | – |
| Ubah nominal plan | – | – | – (bill lama tetap) | stale → `Samakan` | – | – |
| Hapus payment (void) | + penuh | + penuh | + nominal (unpaid lagi) | – | – | – |

**Selesai.** Tandai tiap TC `[x]` saat lolos, catat ID yang gagal + langkah reproduksi + screenshot + saldo sebelum/sesudah (`S0/T0/P0`).
