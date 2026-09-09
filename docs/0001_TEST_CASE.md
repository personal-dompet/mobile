# TEST CASE Manual — Aplikasi Dompet

> Satu file untuk seluruh manual testing. Bahasa UI mengikuti `DOCUMENT.md` (misal: **Target** bukan Tabungan/Pocket, **Alokasi/Dialokasikan ke target**, **Ditarik kembali**, **Belanja dari target**, **Pindah Dana**, **Penyesuaian Saldo**, **Anggaran**, **Rencana Anggaran**, **Cadangan**).
> Tipe: `[P]` = Positif, `[N]` = Negatif, `[E]` = Edge/Boundary.
> Cara pakai: jalankan berurutan per bagian. Setiap TC berisi Prakondisi → Langkah → Ekspektasi → Efek samping yang wajib dicek.
>
> Status otomatisasi (`integration_test/`, 55 test hijau di device via `flutter test integration_test/<file>`):
> `✅` = logika + efek samping (saldo / Total Uang / target / anggaran / laporan) terverifikasi otomatis dan lolos.
> Tanpa tanda = masih manual. Teks snackbar, layout, dialog, dan interaksi UI murni (date-picker, bottom sheet, dsb.) tetap dicek manual meski TC bertanda ✅.
> Pemetaan file: Onboarding + navigasi Beranda → `onboarding_test.dart`; Dompet → `wallet_flow_test.dart`; Pemasukan/Pengeluaran/Transfer/Penyesuaian/Hapus → `transaction_flow_test.dart`; Target/Anggaran/Laporan/GLB-002 → `saving_budget_flow_test.dart`; Kategori → `category_flow_test.dart`; setup awal + navigasi/dialog/widget → `navigation_setup_test.dart` + `navigation_test.dart` (memakai `TestKeys`).
> Cakupan: 120 dari 191 TC bertanda ✅. Belum otomatis: §9 Kategori (sisa 001,002,008,009,010,011), §12 Laporan (sisa 001,002,011,012), §13 Backup/Pengaturan seluruhnya, dan TC UI-murni / Drive-asli lainnya.

**Setup awal yang disarankan:**
- Install fresh (hapus data / uninstall) untuk bagian 1 (Onboarding).
- Untuk bagian 2 dst, siapkan data dasar: 2 Dompet aktif (`Tunai` saldo Rp1.000.000, `BCA` saldo Rp5.000.000), 2 Kategori Pengeluaran (`Makan`, `Transport`), 1 Kategori Pemasukan (`Gaji`), 1 Target (`Dana Darurat` target Rp10.000.000), 1 Rencana Anggaran (`Makan` Rp1.000.000).
- Catat **Total Uang** awal sebelum tiap aksi yang mengubah saldo agar efek samping bisa diverifikasi.
- Format nominal: bilangan bulat, tanpa desimal, tanpa negatif. Pisahkan ribu dengan titik saat verifikasi tampilan.

---

## 1. Splash & Onboarding (Setup Awal)

### TC-ONB-001 — Fresh install tanpa dompet masuk ke Initial Setup [P]
- **Prakondisi:** Install baru, belum ada Dompet.
- **Langkah:**
  1. Buka aplikasi.
  2. Perhatikan splash lalu halaman berikutnya.
- **Ekspektasi:** Splash tampil sebentar lalu diarahkan ke halaman `Mulai rapikan keuanganmu` (Initial Setup) dengan tombol `Mulai`.
- **Efek samping:** Belum ada Total Uang / dashboard.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ONB-002 — Tombol Mulai masuk ke Wallet Setup [P]
- **Prakondisi:** Di Initial Setup.
- **Langkah:**
  1. Tap `Mulai`.
- **Ekspektasi:** Masuk ke halaman setup dompet (grid preset: Tunai/Bank/E-Wallet/Investasi).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ONB-003 — Tombol Lanjutkan disabled sebelum ada dompet [N]
- **Prakondisi:** Wallet Setup, belum buat dompet.
- **Langkah:**
  1. Cek tombol `Lanjutkan`.
- **Ekspektasi:** Tombol `Lanjutkan` disabled / tidak bisa lanjut ke Beranda.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ONB-004 — Buat dompet pertama via preset [P]
- **Prakondisi:** Wallet Setup, state menunggu setup.
- **Langkah:**
  1. Tap preset misal `Tunai`.
  2. Isi Nama `Tunai`, Jenis `Tunai`, Saldo opsional `500000`.
  3. Simpan.
- **Ekspektasi:** Snackbar `Dompet berhasil ditambahkan.`, grid menampilkan `Tunai Rp500.000`, tombol `Lanjutkan` enabled.
- **Efek samping:**
  - Dompet tersimpan
  - jika isi saldo awal > 0 maka ada jurnal pembuka (saldo dompet = input).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ONB-005 — Buat dompet tanpa saldo awal [P]
- **Prakondisi:** Wallet Setup.
- **Langkah:**
  1. Tambah dompet `BCA`, kosongkan Saldo.
  2. Simpan.
- **Ekspektasi:** Berhasil, saldo `Rp0`, tanpa error.
- **Efek samping:**
  - Tanpa jurnal pembuka
  - Total Uang nanti = 0 + dompet lain.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ONB-006 — Lanjutkan ke Beranda setelah ≥1 dompet [P]
- **Prakondisi:** Sudah ada ≥1 dompet di setup.
- **Langkah:**
  1. Tap `Lanjutkan`.
- **Ekspektasi:** Masuk Beranda (Shell: Beranda/Aktivitas/Tambah/Rencana/Menu). Splash berikutnya langsung ke Shell.
- **Efek samping:** Onboarding tidak muncul lagi (sudah ada asset user).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ONB-007 — Splash langsung ke Beranda jika sudah setup [P]
- **Prakondisi:** Sudah ada dompet, tutup aplikasi total.
- **Langkah:**
  1. Buka ulang aplikasi.
- **Ekspektasi:** Splash → langsung Beranda, tidak ke Initial Setup.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ONB-008 — Seksi Pulihkan Cadangan disembunyikan saat offline [E]
- **Prakondisi:** Fresh install + matikan internet.
- **Langkah:**
  1. Masuk Initial Setup.
- **Ekspektasi:** Seksi restore / `Hubungkan Google` tidak tampil (disembunyikan).
- **Integration test**: -
- **Manual test**: ✅

### TC-ONB-009 — Restore dari Cadangan saat setup (online) [P]
- **Prakondisi:** Fresh install, online, ada cadangan di Google Drive (akun yang benar).
- **Langkah:**
  1. Tap `Hubungkan Google` → login.
  2. Tap `Pulihkan Cadangan` → konfirmasi dialog (`setup akan dilewati`).
  3. Tunggu sukses.
- **Ekspektasi:** Sukses → langsung `ShellRoute` (setup dilewati). Snackbar sukses.
- **Efek samping:**
  - Seluruh DB lokal diganti isi cadangan
  - Total Uang/dompet/target/anggaran mengikuti data cadangan.
- **Integration test**: -
- **Manual test**: ✅

### TC-ONB-010 — Batal login Google saat setup [N]
- **Prakondisi:** Initial Setup online, belum login.
- **Langkah:**
  1. Tap `Hubungkan Google` lalu cancel di halaman Google.
- **Ekspektasi:** Kembali ke setup diam-diam (tetap `initial`), tanpa crash, tanpa navigasi.
- **Integration test**: -
- **Manual test**: ✅

### TC-ONB-011 — Pulihkan dibatalkan pada dialog konfirmasi [N]
- **Prakondisi:** Sudah login Google di setup, meta cadangan ada.
- **Langkah:**
  1. Tap `Pulihkan Cadangan` → pilih `Batal` pada dialog.
- **Ekspektasi:** Tidak terjadi restore, tetap di setup.
- **Integration test**: -
- **Manual test**: ✅

### TC-ONB-012 — Gagal tambah dompet (nama kosong) di setup [N]
- **Prakondisi:** Wallet Setup.
- **Langkah:**
  1. Pilih preset → kosongkan Nama → Simpan.
- **Ekspektasi:** Error `Masukkan nama dompet terlebih dahulu`, dompet tidak bertambah.
- **Integration test**: -
- **Manual test**: ✅

---

## 2. Beranda / Dashboard

### TC-DSH-001 — Struktur Beranda lengkap [P]
- **Prakondisi:** Sudah login ke Shell, ada data.
- **Langkah:**
  1. Buka tab `Beranda`.
- **Ekspektasi:** Urutan tampil: Header sapaan → Total Uang → Mulai Catat (Pemasukan/Pengeluaran/Pindah Dana) → Ringkasan Hari Ini → Aktivitas Terbaru. AppBar sapaan: Pagi (05–11) / Siang (11–15) / Sore (15–18) / Malam.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-002 — Total Uang = jumlah dompet aktif cair [P]
- **Prakondisi:** Tunai Rp1.000.000 + BCA Rp5.000.000 aktif, tidak ada dompet arsip.
- **Langkah:**
  1. Lihat kartu Total Uang.
- **Ekspektasi:** Total `Rp6.000.000`.
- **Efek samping:** Dompet arsip dan Target (pocket non-cair) TIDAK ikut hitung — verifikasi di TC-DMP dan TC-TRG.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-003 — Toggle visibilitas Total Uang [P]
- **Prakondisi:** Di Beranda.
- **Langkah:**
  1. Tap ikon mata pada Total Uang.
  2. Tap lagi.
- **Ekspektasi:** Berubah `Rp6.000.000` ↔ `Rp••••••••••`, persisten selama sesi.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-004 — Subtitle jumlah dompet & alokasi [P]
- **Prakondisi:** 2 dompet, sudah alokasi Rp200.000 ke target.
- **Langkah:**
  1. Lihat subtitle di bawah Total Uang (mode tidak obscure).
- **Ekspektasi:** Tertulis `2 dompet • Rp200.000 dialokasikan ke target`. Jika obscure atau alokasi 0 → hanya `N dompet`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-005 — Quick Action Pemasukan [P]
- **Prakondisi:** Di Beranda.
- **Langkah:**
  1. Tap `Pemasukan` pada Mulai Catat.
- **Ekspektasi:** Dibuka form `Catat Pemasukan`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-006 — Quick Action Pengeluaran [P]
- **Prakondisi:** Di Beranda.
- **Langkah:**
  1. Tap `Pengeluaran`.
- **Ekspektasi:** Dibuka form `Catat Pengeluaran`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-007 — Quick Action Pindah Dana [P]
- **Prakondisi:** Di Beranda.
- **Langkah:**
  1. Tap `Pindah Dana`.
- **Ekspektasi:** Dibuka form `Pindah Dana`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-008 — Ringkasan Hari Ini kosong [P]
- **Prakondisi:** Belum ada transaksi hari ini.
- **Langkah:**
  1. Lihat Ringkasan Hari Ini.
- **Ekspektasi:** Teks `Belum ada transaksi hari ini.`, Pemasukan & Pengeluaran Rp0.
- **Integration test**: -
- **Manual test**: ✅

### TC-DSH-009 — Ringkasan Hari Ini terisi [P]
- **Prakondisi:** Hari ini ada Pemasukan Rp500.000 dan Pengeluaran Rp100.000.
- **Langkah:**
  1. Catat kedua transaksi.
  2. Kembali ke Beranda.
- **Ekspektasi:** Ringkasan menampilkan kedua nominal dengan benar. Tap nominal menampilkan tooltip nominal penuh.
- **Efek samping:**
  - Belanja dari Target hari ini ikut hitung Pengeluaran
  - Topup/Tarik/Pindah Dana/Penyesuaian TIDAK ikut ringkasan.
- **Integration test**: -
- **Manual test**: ✅

### TC-DSH-010 — Aktivitas Terbaru max 5 & navigasi [P]
- **Prakondisi:** Ada >5 aktivitas.
- **Langkah:**
  1. Lihat seksi Aktivitas Terbaru.
  2. Tap salah satu.
  3. Tap `Lihat Semua` (jika ada).
- **Ekspektasi:** Max 5 item terbaru (urut tanggal desc). Tap item → Detail Aktivitas. `Lihat Semua` → tab Aktivitas.
- **Integration test**: -
- **Manual test**: ✅

### TC-DSH-011 — Aktivitas Terbaru kosong [E]
- **Prakondisi:** DB baru hanya dompet (tanpa transaksi; abaikan jurnal setup).
- **Langkah:**
  1. Lihat Aktivitas Terbaru.
- **Ekspektasi:** Empty state `Belum ada aktivitas.` + tombol `Catat Sekarang`.
- **Integration test**: -
- **Manual test**: ✅

### TC-DSH-012 — Kartu Laporan Bulanan [P]
- **Prakondisi:** Bulan ini ada Pemasukan & Pengeluaran.
- **Langkah:**
  1. Lihat kartu laporan bulanan di Beranda.
  2. Tap kartu.
- **Ekspektasi:** Menampilkan ringkas Pemasukan/Pengeluaran + `Lihat laporan`. Tap → halaman Laporan. Saat loading tertulis `Memuat...`.
- **Integration test**: -
- **Manual test**: ✅

### TC-DSH-013 — Dashboard refresh otomatis setelah transaksi [P]
- **Prakondisi:** Catat Total Uang & Ringkasan.
- **Langkah:**
  1. Catat Pengeluaran Rp50.000.
  2. Kembali ke Beranda tanpa restart.
- **Ekspektasi:** Total Uang berkurang Rp50.000, Ringkasan & Aktivitas Terbaru update tanpa pull-to-refresh.
- **Integration test**: -
- **Manual test**: ✅

### TC-DSH-014 — Drawer navigasi [P]
- **Prakondisi:** Di Shell.
- **Langkah:**
  1. Buka drawer.
  2. Tap berurutan: `Dompet` → `Kategori Pemasukan` → `Kategori Pengeluaran` → `Laporan` → `Pengaturan`.
- **Ekspektasi:** Masing-masing membuka halaman yang benar.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DSH-015 — Bottom nav & FAB konteks [P]
- **Prakondisi:** Di Shell.
- **Langkah:**
  1. Pindah tab Beranda/Aktivitas/Anggaran/Tabungan.
  2. Perhatikan FAB.
- **Ekspektasi:**
  - FAB Beranda/Aktivitas = tambah aktivitas
  - di Anggaran = tambah anggaran
  - di Tabungan = tambah target.
- **Integration test**: -
- **Manual test**: ✅

### TC-DSH-016 — Tombol back sistem: konfirmasi tutup [E]
- **Prakondisi:** Di root Shell, tidak ada halaman di atasnya.
- **Langkah:**
  1. Tekan back sistem.
- **Ekspektasi:** Dialog `Tutup aplikasi?` → `Ya, Tutup` keluar, Batal tetap di app.
- **Integration test**: -
- **Manual test**: ✅

---

## 3. Dompet (Daftar, Tambah, Ubah, Detail, Arsip, Pulihkan)

### TC-DMP-001 — Daftar dompet grid + saldo [P]
- **Prakondisi:** 2 dompet aktif via drawer → Dompet.
- **Langkah:**
  1. Buka halaman Dompet.
- **Ekspektasi:** Grid 2 kolom, tiap kartu: ikon, nama, saldo. Tidak dikelompokkan per jenis.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-002 — Search dompet [P]
- **Prakondisi:** Ada `Tunai`, `BCA`, `GoPay`.
- **Langkah:**
  1. Ketik `bca` (lowercase).
  2. Hapus.
  3. Ketik `xyz-tidak-ada`.
- **Ekspektasi:** Filter case-insensitive (debounce ~300ms). Hapus → semua muncul. Tanpa hasil → empty state.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-003 — Tambah dompet tanpa saldo awal [P]
- **Prakondisi:** Di daftar Dompet.
- **Langkah:**
  1. Tap `+`.
  2. Jenis `E-Wallet`, Nama `GoPay`, kosongkan Saldo.
  3. Simpan.
- **Ekspektasi:** Sukses, muncul di grid saldo Rp0.
- **Efek samping:**
  - Total Uang tidak berubah
  - tanpa jurnal.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-004 — Tambah dompet dengan saldo awal [P]
- **Prakondisi:** Total Uang awal `T0`.
- **Langkah:**
  1. Tambah `OVO` saldo `Rp250.000`.
  2. Simpan.
- **Ekspektasi:** Sukses, saldo OVO Rp250.000.
- **Efek samping:**
  - Total Uang = `T0 + 250.000`
  - ada jurnal pembuka (muncul sebagai saldo, bukan sebagai Pemasukan di laporan/ringkasan).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-005 — Tambah dompet nama kosong [N]
- **Langkah:**
  1. Tambah dompet, kosongkan Nama → Simpan.
- **Ekspektasi:** Error `Masukkan nama dompet terlebih dahulu`, tidak tersimpan.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-006 — Tambah dompet tanpa pilih jenis [N]
- **Langkah:**
  1. Tambah dompet, isi Nama tapi kosongkan Jenis → Simpan.
- **Ekspektasi:** Error `Pilih jenis dompet dahulu`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-007 — Tambah dompet saldo negatif / desimal / huruf [N]
- **Langkah:**
  1. Coba isi Saldo `-50000`, lalu `10.500,75`, lalu `abc` (jika keyboard memungkinkan).
- **Ekspektasi:**
  - Ditolak validator / tidak bisa simpan
  - hanya bilangan bulat ≥0 yang lolos.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-008 — Tambah dompet nama duplikat [E]
- **Prakondisi:** Sudah ada `BCA`.
- **Langkah:**
  1. Tambah dompet baru nama `BCA` jenis Bank.
- **Ekspektasi:** Berhasil tersimpan (tidak ada validasi duplikat) dengan kode berbeda — catat sebagai perilaku yang diterima.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-009 — Tambah dompet nama spasi saja [N]
- **Langkah:**
  1. Nama `   ` → Simpan.
- **Ekspektasi:** Ditolak (setara kosong).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-010 — Tambah dompet nama sangat panjang / emoji [E]
- **Langkah:**
  1. Nama 100 karakter + emoji `💰 Liburan Panjang ...` → Simpan.
- **Ekspektasi:**
  - Tersimpan dan tampil tanpa terpotong parah / tanpa crash
  - kartu grid tetap rapi (auto-scroll/ellipsis).
- **Integration test**: -
- **Manual test**: ✅

### TC-DMP-011 — Saldo awal sangat besar [E]
- **Prakondisi:** Catat Total awal.
- **Langkah:**
  1. Tambah dompet saldo `999.999.999.999` → Simpan.
- **Ekspektasi:** Tersimpan, format mata uang benar, Total Uang bertambah sesuai.
- **Efek samping:** Pastikan tidak overflow / tampilan tidak rusak di kartu & Total Uang.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-012 — Ubah nama & jenis dompet [P]
- **Prakondisi:** Ada `GoPay`.
- **Langkah:**
  1. Buka Detail GoPay → overflow → `Ubah`.
  2. Ganti nama `GoPay Baru`, jenis `Bank`.
  3. Simpan.
- **Ekspektasi:** Nama & ikon berubah di list & detail.
- **Efek samping:**
  - Saldo tidak berubah
  - histori aktivitas lama tetap menampilkan nama terbaru (live join)
  - Total Uang tetap.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-013 — Ubah dompet tanpa nama [N]
- **Langkah:**
  1. Ubah dompet → kosongkan nama → Simpan.
- **Ekspektasi:** Error, tidak tersimpan.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-014 — Detail dompet: saldo, aktivitas, Lihat Semua [P]
- **Prakondisi:** Dompet BCA ada transaksi.
- **Langkah:**
  1. Tap BCA dari daftar.
- **Ekspektasi:** Tampil saldo besar saat ini, tombol `Sesuaikan saldo`, `Aktivitas Terbaru` (max 5), tombol `Lihat Semua` → daftar aktivitas terfilter dompet tsb.
- **Integration test**: -
- **Manual test**: ✅

### TC-DMP-015 — Arsip dompet bersaldo: peringatan & efek Total Uang [P]
- **Prakondisi:** Tunai saldo Rp1.000.000, Total `T0`, ada ≥2 dompet aktif.
- **Langkah:**
  1. Detail Tunai → `Arsipkan`.
  2. Baca dialog.
  3. Konfirmasi.
- **Ekspektasi:** Dialog menyebut saldo tidak lagi dihitung di Total Uang, riwayat tetap, bisa dipulihkan. Sukses `Berhasil mengarsip Dompet.`
- **Efek samping:**
  - Tunai hilang dari daftar aktif & Total Uang = `T0 − 1.000.000`
  - histori tetap ada (cek Aktivitas)
  - tidak bisa dipakai transaksi baru (cek TC-TRX).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-016 — Dompet arsip tampil netral + menu terbatas [P]
- **Prakondisi:** Tunai sudah diarsip.
- **Langkah:**
  1. Buka Detail Tunai (via Aktivitas lama / list arsip jika ada).
- **Ekspektasi:** Chip abu-abu netral `Diarsipkan` (bukan merah). Overflow hanya `Pulihkan`. Tombol `Sesuaikan saldo` & FAB transaksi disembunyikan.
- **Integration test**: -
- **Manual test**: ✅

### TC-DMP-017 — Dompet arsip tidak bisa dipilih di form [N]
- **Prakondisi:** Tunai diarsip.
- **Langkah:**
  1. Buka Catat Pengeluaran / Pindah Dana / Alokasi Target → buka pemilih dompet.
- **Ekspektasi:** Tunai tidak muncul di pilihan.
- **Integration test**: -
- **Manual test**: ✅

### TC-DMP-018 — Pulihkan dompet arsip [P]
- **Prakondisi:** Tunai diarsip saldo Rp1.000.000, Total `T1`.
- **Langkah:**
  1. Detail Tunai → `Pulihkan`.
- **Ekspektasi:** `Berhasil memulihkan Dompet.`, muncul lagi di daftar.
- **Efek samping:** Total Uang = `T1 + 1.000.000`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-019 — Arsip dompet aktif terakhir dibatalkan [N]
- **Prakondisi:** Arsipkan semua kecuali 1 dompet sehingga tinggal 1 aktif.
- **Langkah:**
  1. Coba arsipkan satu-satunya dompet aktif.
- **Ekspektasi:** Dibatalkan + snackbar `Proses arsip dibatalkan. Setidaknya harus ada satu Dompet aktif.`
- **Efek samping:** Dompet tetap aktif, Total Uang tetap.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-020 — Arsip dompet saldo Rp0 [P]
- **Prakondisi:** Ada dompet `Kosong` Rp0 + dompet lain.
- **Langkah:**
  1. Arsipkan `Kosong`.
- **Ekspektasi:** Berhasil tanpa peringatan saldo berarti.
- **Efek samping:** Total Uang tetap.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-DMP-021 — Urutan dompet: sering dipakai muncul atas [E]
- **Prakondisi:** Ada dompet jarang dipakai `Zzz` dan sering `BCA`.
- **Langkah:**
  1. Catat 3 transaksi memakai `Zzz`.
  2. Kembali ke daftar / pemilih dompet.
- **Ekspektasi:** `Zzz` naik urutan (counter +1 per jurnal posted, sort counter desc lalu nama).
- **Integration test**: ✅
- **Manual test**: ✅

---

## 4. Pemasukan

### TC-IN-001 — Catat pemasukan single kategori [P]
- **Prakondisi:** BCA saldo `S0`, Total `T0`. Kategori `Gaji` ada.
- **Langkah:**
  1. Beranda → `Pemasukan`.
  2. Nominal `500000`, Dompet `BCA`, Kategori `Gaji`, Keterangan `Gaji Jan`, Tanggal hari ini.
  3. Simpan.
- **Ekspektasi:** Snackbar `Pemasukanmu berhasil dicatat`, kembali + list update.
- **Efek samping:**
  - Saldo BCA = `S0 + 500.000`
  - Total Uang = `T0 + 500.000`
  - muncul di Aktivitas & Ringkasan Hari Ini & Laporan Pemasukan
  - tidak menambah sisa Anggaran.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-002 — Pemasukan tanpa kategori (opsional) [P]
- **Prakondisi:** BCA saldo `S0`.
- **Langkah:**
  1. Pemasukan Rp100.000, Dompet BCA, lewati Kategori.
  2. Simpan.
- **Ekspektasi:** Berhasil (kategori opsional).
- **Efek samping:**
  - Saldo +100.000
  - di laporan masuk akun `Lainnya (OtherIncome)`
  - judul aktivitas fallback ke label.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-003 — Pemasukan multi kategori (batch) [P]
- **Prakondisi:** BCA `S0`.
- **Langkah:**
  1. Pemasukan → aktifkan `Catat banyak kategori sekaligus`.
  2. Tambah `Gaji Rp400.000` + `Bonus Rp100.000` (total Rp500.000), Dompet BCA.
  3. Simpan.
- **Ekspektasi:** Total read-only = Rp500.000 (auto-sum). Berhasil.
- **Efek samping:**
  - BCA +500.000
  - tiap kategori tercatat terpisah di laporan
  - di Aktivitas tampil `Pemasukan untuk N kategori` / judul fallback.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-004 — Toggle batch ↔ single [P]
- **Langkah:**
  1. Di form Pemasukan toggle `Catat banyak kategori` ↔ `Catat satu kategori`.
- **Ekspektasi:**
  - Berpindah mode tanpa crash
  - data nominal tidak hilang aneh (total konsisten).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-005 — Pemasukan nominal kosong / nol [N]
- **Langkah:**
  1. Kosongkan nominal → Simpan.
  2. Isi `0` → Simpan.
- **Ekspektasi:** Error `Masukkan nominal pemasukan dulu` (required). Tidak tersimpan.
- **Integration test**: ✅
- **Manual test**: GAGAL

### TC-IN-006 — Pemasukan tanpa dompet [N]
- **Langkah:**
  1. Isi nominal, kosongkan Dompet → Simpan.
- **Ekspektasi:** Error `Pilih salah satu dompet terlebih dahulu.`
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-007 — Pemasukan tanggal masa depan diblokir [N]
- **Langkah:**
  1. Buka picker tanggal → coba pilih besok.
- **Ekspektasi:** Tidak bisa pilih masa depan (`lastDate: now`).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-008 — Pemasukan tanggal masa lalu [P]
- **Langkah:**
  1. Pilih tanggal 3 hari lalu → Simpan.
- **Ekspektasi:**
  - Berhasil
  - muncul di grup tanggal yang sesuai (Nama Hari / tanggal lengkap), tidak di `Hari Ini`
  - masuk laporan bulan tanggal tsb.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-009 — Edit pemasukan (dompet sama) [P]
- **Prakondisi:** Pemasukan BCA Rp500.000 (saldo `S1`).
- **Langkah:**
  1. Aktivitas → Detail → `Perbaiki`.
  2. Ubah nominal jadi Rp700.000 → Simpan.
- **Ekspektasi:** `Pemasukanmu berhasil diperbarui`, detail replace ke jurnal baru.
- **Efek samping:**
  - BCA = `S1 − 500.000 + 700.000` (efek lama dibalik dulu)
  - Total Uang menyesuaikan
  - laporan update.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-010 — Edit pemasukan pindah dompet [E]
- **Prakondisi:** Pemasukan BCA Rp500.000. Tunai `TUN0`, BCA `BCA0`.
- **Langkah:**
  1. Perbaiki → ganti Dompet ke Tunai → Simpan.
- **Ekspektasi:** Berhasil.
- **Efek samping:** BCA = `BCA0 − 500.000`, Tunai = `TUN0 + 500.000` (jurnal lama void + baru). Total Uang tetap (pindah internal + pemasukan tetap).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-011 — Hapus pemasukan mengembalikan saldo [P]
- **Prakondisi:** Pemasukan BCA Rp500.000, saldo `S1`, Total `T1`.
- **Langkah:**
  1. Detail → `Hapus` → konfirmasi (`Saldo dan riwayat terkait akan diperbarui`).
- **Ekspektasi:** `Berhasil menghapus aktivitas.`, kembali ke list.
- **Efek samping:**
  - BCA = `S1 − 500.000`
  - Total = `T1 − 500.000`
  - hilang dari ringkasan/laporan (status void, bukan hapus fisik).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-IN-012 — Batal hapus pemasukan [N]
- **Langkah:**
  1. Detail → Hapus → `Batal`.
- **Ekspektasi:** Tidak terhapus, saldo tetap.
- **Integration test**: -
- **Manual test**: ✅

---

## 5. Pengeluaran

### TC-OUT-001 — Catat pengeluaran single kategori [P]
- **Prakondisi:** BCA `S0`, Total `T0`, Anggaran Makan sisa `R0`.
- **Langkah:**
  1. `Pengeluaran` → Rp50.000, Dompet BCA, Kategori Makan.
  2. Simpan.
- **Ekspektasi:** `Pengeluaranmu berhasil dicatat`.
- **Efek samping:**
  - BCA = `S0 − 50.000`
  - Total = `T0 − 50.000`
  - Anggaran Makan terpakai +50.000 (sisa `R0 − 50.000`)
  - masuk laporan Pengeluaran & hitungan kategori.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-OUT-002 — Pengeluaran multi kategori satu nota [P]
- **Prakondisi:** BCA `S0`.
- **Langkah:**
  1. Aktifkan banyak kategori.
  2. `Makan Rp30.000 (nota makan)` + `Transport Rp20.000`.
  3. Simpan.
- **Ekspektasi:** Total Rp50.000 auto-sum. Berhasil.
- **Efek samping:**
  - BCA −50.000
  - tiap anggaran kategori berkurang masing-masing
  - edit nanti otomatis mode batch (lines>2 atau ada note per line).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-OUT-003 — Satu transaksi hanya satu dompet [E]
- **Prakondisi:** Perlu bayar Rp200.000 via GoPay 50.000 + BCA 150.000.
- **Langkah:**
  1. Coba catat sekali dengan 2 dompet (verifikasi UI tidak memungkinkan).
  2. Catat sebagai 2 transaksi terpisah.
- **Ekspektasi:**
  - UI hanya izinkan 1 dompet per transaksi
  - 2 transaksi berhasil dengan saldo masing-masing berkurang.
- **Efek samping:** Total −200.000.
- **Integration test**: -
- **Manual test**: ✅

### TC-OUT-004 — Pengeluaran melebihi saldo: dialog boleh lanjut [E]
- **Prakondisi:** Tunai saldo Rp10.000.
- **Langkah:**
  1. Pengeluaran Rp100.000 Dompet Tunai → Simpan.
- **Ekspektasi:**
  - Dialog `Saldo mungkin menjadi negatif ... Transaksi tetap dapat disimpan` → `Tetap Simpan` berhasil, `Batal` tidak simpan.
  - **Efek samping jika lanjut:** Saldo Tunai = −90.000
  - Total ikut negatif sebesar itu.
- **Integration test**: -
- **Manual test**: PENDING

### TC-OUT-005 — Pengeluaran nominal nol / kosong [N]
- **Langkah:**
  1. Kosongkan / isi 0 → Simpan.
- **Ekspektasi:** Error `Masukkan nominal pengeluaran dulu`.
- **Integration test**: ✅
- **Manual test**: GAGAL

### TC-OUT-006 — Pengeluaran nominal negatif / desimal [N]
- **Langkah:**
  1. Coba `-10000` / `10500.5`.
- **Ekspektasi:** Ditolak validator (hanya bulat ≥0 + required).
- **Integration test**: -
- **Manual test**: ✅

### TC-OUT-007 — Edit pengeluaran dompet sama memakai effective balance [P]
- **Prakondisi:** Pengeluaran BCA Rp50.000, saldo kini `S1` (sudah dikurangi).
- **Langkah:**
  1. Perbaiki → naikkan jadi Rp80.000 → Simpan.
- **Ekspektasi:** UI tampil `Saldo saat ini S1` tapi validasi pakai `S1 + 50.000`. Berhasil tanpa dialog overdraw yang salah.
- **Efek samping:** BCA = `S1 + 50.000 − 80.000`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-OUT-008 — Edit pengeluaran pindah dompet [E]
- **Prakondisi:** Pengeluaran BCA Rp50.000.
- **Langkah:**
  1. Perbaiki → ganti ke Tunai → Simpan.
- **Ekspektasi:** Berhasil.
- **Efek samping:** BCA kembali +50.000, Tunai −50.000.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-OUT-009 — Edit pengeluaran jadi melebihi saldo efektif [E]
- **Prakondisi:** Tunai Rp20.000, ada pengeluaran Tunai Rp10.000 (saldo kini sudah dikurangi).
- **Langkah:**
  1. Perbaiki pengeluaran tsb jadi Rp100.000 → Simpan.
- **Ekspektasi:** Dialog saldo negatif muncul (karena efektif 20.000+10.000=30.000 < 100.000). Bisa Tetap Simpan / Batal.
- **Integration test**: -
- **Manual test**: PENDING

### TC-OUT-010 — Hapus pengeluaran mengembalikan saldo & anggaran [P]
- **Prakondisi:** Pengeluaran BCA Rp50.000 kategori Makan.
- **Langkah:**
  1. Detail → Hapus → konfirmasi.
- **Ekspektasi:** Berhasil.
- **Efek samping:**
  - BCA +50.000
  - Total +50.000
  - sisa Anggaran Makan +50.000
  - laporan berkurang.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-OUT-011 — Pengeluaran kategori arsip tidak bisa dipakai baru [N]
- **Prakondisi:** Arsipkan kategori `Hiburan`.
- **Langkah:**
  1. Buat Pengeluaran → buka pemilih kategori.
- **Ekspektasi:**
  - `Hiburan` tidak muncul untuk transaksi baru
  - transaksi lama tetap tampil namanya.
- **Integration test**: -
- **Manual test**: ✅

---

## 6. Pindah Dana (Transfer)

### TC-TRF-001 — Pindah dana beda dompet [P]
- **Prakondisi:** BCA `B0`, GoPay `G0`, Total `T0`.
- **Langkah:**
  1. `Pindah Dana` → Dari BCA → Ke GoPay Rp200.000 → Simpan.
- **Ekspektasi:** `Danamu berhasil dipindah`.
- **Efek samping:**
  - BCA = `B0 − 200.000`, GoPay = `G0 + 200.000`
  - Total Uang TETAP `T0`
  - tidak memengaruhi Anggaran
  - tidak masuk laporan Pemasukan/Pengeluaran
  - di Aktivitas global `BCA → GoPay`
  - di Detail BCA `Transfer ke GoPay`, di GoPay `Transfer dari BCA`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRF-002 — Tombol Tukar asal–tujuan [P]
- **Langkah:**
  1. Isi Dari BCA Ke GoPay.
  2. Tap `Tukar`.
- **Ekspektasi:** Berbalik Dari GoPay Ke BCA (nama+saldo ikut tertukar).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRF-003 — Asal = Tujuan dicegah [N]
- **Langkah:**
  1. Pilih Dari BCA.
  2. Buka pilihan Ke → coba pilih BCA.
- **Ekspektasi:** BCA disabled (opacity redup, tidak bisa di-tap).
- **Integration test**: -
- **Manual test**: ✅

### TC-TRF-004 — Nominal kosong / nol / negatif [N]
- **Langkah:**
  1. Coba simpan tanpa nominal, lalu `0`, lalu negatif (jika bisa diketik).
- **Ekspektasi:** Error `Masukkan nominalnya dulu` / ditolak validator.
- **Integration test**: ✅
- **Manual test**: GAGAL

### TC-TRF-005 — Transfer melebihi saldo sumber [E]
- **Prakondisi:** BCA Rp50.000.
- **Langkah:**
  1. Transfer BCA→GoPay Rp100.000 → Simpan.
- **Ekspektasi:**
  - Dialog `Saldo mungkin menjadi negatif ... di BCA. Transfer tetap dapat disimpan.` → bisa Tetap Simpan / Batal.
  - **Efek samping jika lanjut:** BCA −100.000 (negatif), GoPay +100.000, Total tetap.
- **Integration test**: -
- **Manual test**: PENDING

### TC-TRF-006 — Transfer memakai dompet arsip [N]
- **Prakondisi:** Tunai diarsip.
- **Langkah:**
  1. Buka Pindah Dana → cek pilihan Dari/Ke.
- **Ekspektasi:** Tunai tidak muncul di kedua sisi.
- **Integration test**: -
- **Manual test**: ✅

### TC-TRF-007 — Edit transfer [P]
- **Prakondisi:** Transfer BCA→GoPay Rp200.000.
- **Langkah:**
  1. Detail → Perbaiki → ubah jadi Rp250.000 → Simpan.
- **Ekspektasi:** `Pindah dana berhasil diperbarui`.
- **Efek samping:**
  - Koreksi sebesar selisih (BCA −50.000 lagi, GoPay +50.000 lagi)
  - Total tetap.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRF-008 — Hapus transfer mengembalikan kedua sisi [P]
- **Prakondisi:** Setelah TC-TRF-001.
- **Langkah:**
  1. Detail transfer → Hapus → konfirmasi.
- **Ekspektasi:** Berhasil.
- **Efek samping:**
  - BCA kembali +200.000, GoPay −200.000
  - Total tetap
  - hilang dari kedua detail dompet.
- **Integration test**: ✅
- **Manual test**: ✅

---

## 7. Penyesuaian Saldo

### TC-ADJ-001 — Sesuaikan naik (saldo tercatat < sebenarnya) [P]
- **Prakondisi:** BCA tercatat Rp1.000.000, Total `T0`.
- **Langkah:**
  1. Detail BCA → `Sesuaikan saldo`.
  2. Input `Saldo sebenarnya 1.200.000`.
  3. Simpan.
- **Ekspektasi:** `Saldo berhasil disesuaikan`. Selisih otomatis +200.000, deskripsi otomatis rekonsiliasi.
- **Efek samping:**
  - BCA = 1.200.000
  - Total = `T0 + 200.000`
  - ada jurnal adjustment
  - tidak memengaruhi Anggaran/laporan Pemasukan-Pengeluaran (tipe sendiri).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ADJ-002 — Sesuaikan turun [P]
- **Prakondisi:** BCA Rp1.000.000.
- **Langkah:**
  1. Sesuaikan ke Rp800.000 → Simpan.
- **Ekspektasi:** Berhasil.
- **Efek samping:**
  - BCA −200.000
  - Total −200.000.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ADJ-003 — Sesuaikan sama (selisih 0) [E] — UPDATE TC2-ADJ-001 (no-op, bukan jurnal 0)
- **Prakondisi:** BCA Rp1.000.000.
- **Langkah:**
  1. Input sama persis Rp1.000.000 → Simpan.
- **Ekspektasi:** Tanpa jurnal baru, pop ke detail, snackbar info primary `Tidak ada perubahan saldo` (bukan error merah, bukan jurnal Rp0).
- **Efek samping:**
  - Saldo & Total tetap
  - journal count tetap, tanpa entri aktivitas baru.
- **Integration test**: ✅
- **Manual test**: PENDING

### TC-ADJ-004 — Input kosong [N]
- **Langkah:**
  1. Kosongkan Saldo sebenarnya → Simpan.
- **Ekspektasi:** Error `Masukkan saldo yang sebenarnya dulu`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ADJ-005 — Dompet arsip tidak ada entry penyesuaian [N]
- **Prakondisi:** Tunai diarsip.
- **Langkah:**
  1. Buka Detail Tunai.
- **Ekspektasi:** Tombol `Sesuaikan saldo` tidak tampil.
- **Integration test**: -
- **Manual test**: ✅

### TC-ADJ-006 — Penyesuaian tidak bisa diedit [N]
- **Prakondisi:** Ada aktivitas Penyesuaian Saldo.
- **Langkah:**
  1. Buka Detail aktivitas tsb.
- **Ekspektasi:** Tombol `Perbaiki` disembunyikan. Hanya `Hapus` tersedia.
- **Integration test**: -
- **Manual test**: ✅

### TC-ADJ-007 — Hapus penyesuaian mengembalikan saldo [P]
- **Prakondisi:** Setelah TC-ADJ-001 (+200.000).
- **Langkah:**
  1. Detail penyesuaian → Hapus → konfirmasi.
- **Ekspektasi:** Berhasil.
- **Efek samping:** BCA −200.000 (kembali), Total menyesuaikan.
- **Integration test**: ✅
- **Manual test**: ✅

---

## 8. Aktivitas (Daftar, Search, Filter, Detail, Edit, Hapus)

### TC-ACT-001 — Daftar & grouping tanggal [P]
- **Prakondisi:** Ada transaksi hari ini, kemarin, 3 hari lalu, 10 hari lalu.
- **Langkah:**
  1. Buka tab Aktivitas.
- **Ekspektasi:** Grup berurutan: `Hari Ini` → `Kemarin` → Nama Hari (max 7 hari ke belakang) → Tanggal lengkap. Urut entryDate desc.
- **Integration test**: -
- **Manual test**: ✅

### TC-ACT-002 — Search aktivitas [P]
- **Prakondisi:** Ada keterangan `Gaji Jan`, `Kopi`.
- **Langkah:**
  1. Ketik `gaji` → tunggu.
  2. Ketik `xyz-tidak-ada`.
  3. Hapus.
- **Ekspektasi:** Filter deskripsi case-insensitive (debounce 300ms). Tanpa hasil → empty. Hapus → semua kembali.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ACT-003 — Filter tipe [P]
- **Langkah:**
  1. Pilih chip berurutan: `Semua` → `Pengeluaran` → `Pemasukan` → `Pindah dana` → `Penyesuaian saldo` → `Tagihan`.
- **Ekspektasi:**
  - List hanya tampil tipe tsb
  - `Semua` tampil semua (kecuali jurnal setup & void).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ACT-004 — Filter periode [P]
- **Langkah:**
  1. Pilih `Hari ini` → `7 hari terakhir` → `30 hari terakhir` → `Bulan ini` → `Semua`.
- **Ekspektasi:**
  - Rentang benar (7 hari = 6 hari lalu s.d. hari ini
  - 30 hari = 29 hari lalu
  - Bulan ini = 1 s.d. akhir bulan). Kombinasi dengan search & tipe (AND).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ACT-005 — Aktivitas per dompet [P]
- **Prakondisi:** BCA ada transfer & transaksi.
- **Langkah:**
  1. Detail BCA → `Lihat Semua`.
- **Ekspektasi:**
  - Hanya aktivitas yang menyentuh BCA
  - judul transfer dari perspektif BCA (`Pindah dana ke/dari X`, +/- amount).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ACT-006 — Judul fallback [E]
- **Prakondisi:** Buat Pemasukan tanpa kategori & tanpa keterangan; Pengeluaran batch 2 kategori; Transfer.
- **Langkah:**
  1. Lihat judul di list.
- **Ekspektasi:** Kosong → `Tanpa keterangan` / `Pemasukan untuk N kategori` / `Pindah dana dari A ke B` (tidak kosong/crash).
- **Integration test**: -
- **Manual test**: ✅

### TC-ACT-007 — Detail semua tipe [P]
- **Langkah:**
  1. Buka detail masing-masing: Pemasukan, Pengeluaran, Transfer, Penyesuaian, Alokasi/Tarik/Belanja Target.
- **Ekspektasi:** Kartu sesuai tipe (Kategori/Dompet/Keterangan atau info saldo), nominal +/− dengan warna benar (+ hijau/tertiary, − merah), tanggal & riwayat benar.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ACT-008 — Edit dari detail (Pemasukan/Pengeluaran/Transfer) [P]
- **Langkah:**
  1. Detail → `Perbaiki` → ubah → Simpan.
- **Ekspektasi:**
  - Untuk transaksi pindah ke detail jurnal baru (replace)
  - transfer sama. Lihat TC-IN/TRF/OUT untuk efek saldo.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ACT-009 — Hapus dari detail (semua tipe bisa dihapus) [P]
- **Langkah:**
  1. Detail → `Hapus` → baca teks `Saldo dan riwayat terkait akan diperbarui` → konfirmasi.
- **Ekspektasi:** `Berhasil menghapus aktivitas.`, pop ke list, list refresh.
- **Efek samping:** Saldo/Total/laporan/anggaran terkoreksi otomatis (void, bukan hapus fisik).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-ACT-010 — Warna & tanda nominal [P]
- **Langkah:**
  1. Perhatikan list: Pemasukan/Tarik (+), Pengeluaran/Belanja/Alokasi (−), Transfer (+/− tergantung konteks).
- **Ekspektasi:** Konsisten + pembeda visual jelas.
- **Integration test**: -
- **Manual test**: ✅

### TC-ACT-011 — Empty aktivitas + CTA [E]
- **Prakondisi:** Filter yang menghasilkan kosong (misal search unik + periode Hari ini).
- **Langkah:**
  1. Terapkan filter kosong.
- **Ekspektasi:** `Belum ada aktivitas. / Mulai dengan mencatat…` + `Catat Sekarang` membuka bottom sheet tambah.
- **Integration test**: -
- **Manual test**: ✅

---

## 9. Kategori

### TC-KAT-001 — Daftar terpisah Pemasukan vs Pengeluaran [P]
- **Langkah:**
  1. Drawer → `Kategori Pengeluaran`.
  2. Drawer → `Kategori Pemasukan`.
- **Ekspektasi:**
  - AppBar `Kategori Pengeluaran/Pemasukan`, isi tidak tercampur
  - bawaan vs `Kategori Saya` terpisah.
- **Integration test**: -
- **Manual test**: ✅

### TC-KAT-002 — Search kategori [P]
- **Langkah:**
  1. Ketik `mak` di Kategori Pengeluaran.
- **Ekspektasi:** Hasil filter (debounce 300ms), case-insensitive.
- **Integration test**: -
- **Manual test**: ✅

### TC-KAT-003 — Buat kategori baru [P]
- **Prakondisi:** Di Kategori Pengeluaran.
- **Langkah:**
  1. Tap `+`.
  2. Nama `Hobi`, pilih ikon.
  3. Simpan.
- **Ekspektasi:** `Berhasil menambah kategori Hobi.`, muncul di `Kategori Saya`.
- **Efek samping:** Langsung bisa dipilih di form Pengeluaran & Rencana Anggaran.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-KAT-004 — Buat kategori tanpa nama [N]
- **Langkah:**
  1. `+` → kosongkan Nama → Simpan.
- **Ekspektasi:** Error `Masukkan nama kategori terlebih dahulu`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-KAT-005 — Buat kategori tanpa ikon [P]
- **Langkah:**
  1. Nama `Tanpa Ikon`, lewati ikon → Simpan.
- **Ekspektasi:** Berhasil dengan ikon default (dompet untuk expense, pembayaran untuk income).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-KAT-006 — Ubah kategori (nama+ikon, tipe immutable) [P]
- **Prakondisi:** Ada `Hobi` (expense).
- **Langkah:**
  1. Swipe → `Ubah`.
  2. Ganti nama `Hobi Baru` + ikon lain.
  3. Simpan.
- **Ekspektasi:** `Berhasil memperbarui Kategori.`
- **Efek samping:**
  - Transaksi lama ikut nama baru (live)
  - tipe tetap expense (tidak bisa jadi income).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-KAT-007 — Arsip kategori [P]
- **Prakondisi:** Ada `Hobi`, belum/tidak dipakai.
- **Langkah:**
  1. Swipe → `Arsip` → konfirmasi (`tidak muncul di daftar. Aktivitas dan riwayatnya tetap tersimpan`).
- **Ekspektasi:**
  - Hilang dari daftar & pemilih
  - snackbar arsip.
- **Efek samping:**
  - Transaksi lama tetap tampil nama
  - tidak bisa dipakai transaksi/anggaran baru.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-KAT-008 — Pemilih kategori di form transaksi [P]
- **Prakondisi:** Di form Pengeluaran.
- **Langkah:**
  1. Tap Kategori → pilih `Makan`.
- **Ekspektasi:**
  - Field terisi id+nama
  - badge `Terencana`/`Anggaran Aktif` tampil jika ada rencana/anggaran (warna primer/tersier).
- **Integration test**: -
- **Manual test**: ✅

### TC-KAT-009 — Buat cepat dari pemilih (+ tombol) [P]
- **Langkah:**
  1. Di pemilih kategori tap `+` → buat `Jajan` → Simpan.
- **Ekspektasi:** Kembali dengan `Jajan` langsung terpilih.
- **Integration test**: -
- **Manual test**: GAGAL

### TC-KAT-010 — Kategori kosong (user belum buat) [E]
- **Prakondisi:** Akun baru tanpa kategori user (hanya bawaan).
- **Langkah:**
  1. Buka Kategori.
- **Ekspektasi:** Seksi `Kategori Saya` empty `Belum ada kategori baru.` + `Tambah Kategori`.
- **Integration test**: -
- **Manual test**: ✅

### TC-KAT-011 — Search ikon saat buat kategori [P]
- **Langkah:**
  1. Form kategori → ketik di `Cari ikon...`.
- **Ekspektasi:**
  - Grid ikon terfilter by keyword
  - pilih highlight primer.
- **Integration test**: -
- **Manual test**: ✅

---

## 10. Target (Tabungan) — Buat, Alokasi, Tarik, Belanja, Edit, Hapus

> Prinsip saldo: Target = pocket non-cair, **tidak masuk Total Uang**. Alokasi = Dompet cair −, Target +. Tarik = sebaliknya. Belanja = Target −, Dompet cair tetap, tapi tambah Pengeluaran laporan & pemakaian Anggaran (jika kategori+periode cocok).

### TC-TRG-001 — Buat target dengan nominal + deadline [P]
- **Prakondisi:** Di tab Tabungan.
- **Langkah:**
  1. FAB → isi Nama `Laptop`, Nominal `10.000.000`, Tanggal (misal 6 bulan lagi), Catatan, Ikon.
  2. `Simpan`.
- **Ekspektasi:** Muncul di list dengan progress 0%, `Sekitar N bulan menuju target`.
- **Efek samping:**
  - Saldo target 0
  - Total Uang & dompet tidak berubah.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-002 — Buat target tanpa nominal (tanpa target) [P]
- **Langkah:**
  1. Buat `Dana Fleksibel`, kosongkan nominal & tanggal → Simpan.
- **Ekspektasi:**
  - Berhasil
  - insight `tanpa target` (hanya terkumpul, tanpa %/sisa/ETA).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-003 — Buat target nama kosong [N]
- **Langkah:**
  1. Kosongkan Nama → Simpan.
- **Ekspektasi:** Snackbar `Nama target belum diisi` / `Masukkan nama target terlebih dahulu`, tidak tersimpan.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-004 — Buat target nominal 0 / negatif [N]
- **Langkah:**
  1. Isi nominal `0` lalu `−10000` (jika bisa) → Simpan.
- **Ekspektasi:** Error `Target harus lebih dari 0` / `Masukkan nominalnya dulu`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-005 — Buat target tanggal lampau [N]
- **Langkah:**
  1. Buka picker tanggal target → coba pilih kemarin.
- **Ekspektasi:** Tidak bisa (firstDate hari ini). Clear tanggal memungkinkan (opsional).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-006 — Nama duplikat diizinkan [E]
- **Prakondisi:** Sudah ada `Laptop`.
- **Langkah:**
  1. Buat lagi `Laptop` nominal beda → Simpan.
- **Ekspektasi:**
  - Berhasil (tidak ada cek duplikat
  - kode `101.0006.NNNN` monotonik, soft-delete tetap dihitung).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-007 — Search target [P]
- **Prakondisi:** Ada `Laptop`, `Dana Darurat`.
- **Langkah:**
  1. Ketik `lap` → hapus → ketik `tidak-ada`.
- **Ekspektasi:**
  - Filter nama (debounce 300ms)
  - kosong → empty.
- **Integration test**: -
- **Manual test**: ✅

### TC-TRG-008 — Detail target awal [P]
- **Langkah:**
  1. Tap `Laptop`.
- **Ekspektasi:** Header, kartu `Terkumpul`, tombol `Alokasi/Belanja/Tarik`, `Insight Target`, `Riwayat Target` kosong, tombol `Edit Target` & `Hapus Target` di bawah.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-009 — Alokasi ke target (uang tersedia berkurang) [P]
- **Prakondisi:** BCA `B0`, Target `Laptop S0=0`, Total cair `T0`.
- **Langkah:**
  1. Detail → `Alokasi` → Dari Dompet `BCA`, Nominal `200.000`, Tanggal kini → Simpan.
- **Ekspektasi:** Sukses.
- **Efek samping:**
  - BCA = `B0 − 200.000`
  - Target = `+200.000`
  - Total Uang cair = `T0 − 200.000` (uang terkunci)
  - total semua-aset tetap
  - progress % naik
  - riwayat + `Terkumpul` running balance bertambah
  - subtitle Beranda `dialokasikan` bertambah.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-010 — Alokasi melebihi saldo dompet [N]
- **Prakondisi:** BCA Rp50.000, Target 0.
- **Langkah:**
  1. Alokasi Rp100.000 dari BCA → Simpan.
- **Ekspektasi:** Error `Saldo tidak mencukupi`, tidak tersimpan.
- **Efek samping:** Semua saldo tetap.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-011 — Alokasi nominal 0 / kosong / desimal [N]
- **Langkah:**
  1. Coba `0`, kosong, desimal.
- **Ekspektasi:** Error `Nominal harus lebih dari 0` / `Masukkan nominalnya dulu`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-012 — Alokasi tanggal masa depan diblokir [N]
- **Langkah:**
  1. Alokasi → buka picker tanggal → coba besok.
- **Ekspektasi:** Tidak bisa (lastDate kini). Tanggal lampau diizinkan.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-013 — Tarik kembali ke dompet (uang tersedia bertambah) [P]
- **Prakondisi:** Laptop Rp200.000, BCA `B1`, Total `T1`.
- **Langkah:**
  1. Detail → `Tarik` → Ke Dompet BCA Rp50.000 → Simpan.
- **Ekspektasi:** Sukses.
- **Efek samping:**
  - Target = 150.000
  - BCA = `B1 + 50.000`
  - Total = `T1 + 50.000`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-014 — Tarik melebihi saldo target [N]
- **Prakondisi:** Target Rp150.000.
- **Langkah:**
  1. Tarik Rp200.000 → Simpan.
- **Ekspektasi:** `Saldo tidak mencukupi`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-015 — Belanja dari target (dompet tidak berubah, laporan + anggaran terpengaruh) [P]
- **Prakondisi:** Laptop Rp150.000, BCA `B1`, Total `T1`, Anggaran Makan sisa `R0`, Kategori Makan.
- **Langkah:**
  1. Detail → `Belanja` → Kategori Makan Rp30.000 → Simpan.
- **Ekspektasi:** Sukses.
- **Efek samping:**
  - Target = 120.000
  - BCA TETAP `B1`
  - Total cair TETAP `T1`
  - Laporan Pengeluaran +30.000 (kategori Makan)
  - Anggaran Makan sisa = `R0 − 30.000`
  - Ringkasan Hari Ini +30.000
  - muncul di Aktivitas sebagai Belanja.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-016 — Belanja tanpa kategori [N]
- **Langkah:**
  1. Belanja → kosongkan Kategori → Simpan.
- **Ekspektasi:** Error kategori wajib (`Nominal belanja belum diisi` / kategori required), tidak tersimpan.
- **Integration test**: ✅
- **Manual test**: ADJUSTMENT

### TC-TRG-017 — Belanja melebihi saldo target [N]
- **Prakondisi:** Target Rp120.000.
- **Langkah:**
  1. Belanja Rp200.000 → Simpan.
- **Ekspektasi:** `Saldo tidak mencukupi`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-018 — Insight: tercapai & over-target [E]
- **Prakondisi:** Target Rp100.000.
- **Langkah:**
  1. Alokasi total Rp100.000 → cek.
  2. Alokasi lagi Rp20.000 (over).
- **Ekspektasi:** Status `Target tercapai`, progress bar clamp 100% walau ratio >1, remaining ≤0.
- **Integration test**: -
- **Manual test**: ✅

### TC-TRG-019 — Insight: butuh ≥2 topup untuk proyeksi [E]
- **Langkah:**
  1. Target baru + 1x topup → cek Insight.
  2. Tambah topup ke-2 → cek lagi.
- **Ekspektasi:** 1 topup → `notEnoughData` (tanpa ETA). ≥2 topup & avg>0 → `projected` + ETA & `Saran alokasi` (neededPerMonth = ceil(sisa*30/hari)). Withdraw/belanja diabaikan untuk laju.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-020 — Insight: overdue menang atas proyeksi [E]
- **Prakondisi:** Target deadline kemarin (buat via edit tanggal jika memungkinkan / tunggu lewat).
- **Langkah:**
  1. Lewatkan deadline dengan sisa >0 → buka Detail.
- **Ekspektasi:**
  - `Tenggat telah lewat` + `X belum terkumpul`
  - ETA tidak tampil menyesatkan. Jika <30 hari, hero hanya sisa + hitung mundur (tanpa rate)
  - ≥30 hari tampil rate.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-021 — Insight: tanpa target [E]
- **Prakondisi:** Target tanpa nominal (TC-TRG-002) + topup 1x.
- **Langkah:**
  1. Buka Detail.
- **Ekspektasi:** Hanya Terkumpul, tanpa %, sisa, ETA.
- **Integration test**: -
- **Manual test**: ✅

### TC-TRG-022 — Riwayat target running balance [P]
- **Prakondisi:** Target dengan Topup 200.000 → Tarik 50.000 → Belanja 30.000.
- **Langkah:**
  1. Lihat Riwayat Target.
- **Ekspektasi:** Urut grup tanggal (Hari Ini/Kemarin/dst), tiap baris tipe benar (Alokasi/Tarik/Belanja), `Terkumpul X` running dari tertua ke terbaru konsisten (0→200→150→120).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-023 — Edit target hanya ubah info [P]
- **Prakondisi:** Laptop saldo Rp120.000.
- **Langkah:**
  1. `Edit Target` → ganti Nama, Nominal jadi 15.000.000, Tanggal, Catatan → `Simpan Perubahan`.
- **Ekspektasi:** Berhasil.
- **Efek samping:**
  - Saldo/progress nominal tetap 120.000 (hanya % yang recompute)
  - dompet/Total tidak berubah.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-024 — Hapus target saldo kosong [P]
- **Prakondisi:** Buat target `Kosong` tanpa topup.
- **Langkah:**
  1. Detail → `Hapus Target` → konfirmasi (`Riwayat alokasi tidak terpengaruh`).
- **Ekspektasi:** Hilang dari list, tanpa pilih dompet.
- **Efek samping:**
  - Tanpa jurnal
  - Total/dompet tetap.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-025 — Hapus target bersaldo wajib tarik ke dompet [P]
- **Prakondisi:** Laptop Rp120.000, BCA `B1`, Total `T1`.
- **Langkah:**
  1. Detail → Hapus → pilih Ke Dompet BCA → `Hapus & Tarik`.
- **Ekspektasi:** `Target dihapus, sisa kembali ke dompet.`, hilang dari list.
- **Efek samping:**
  - BCA = `B1 + 120.000`
  - Total = `T1 + 120.000`
  - ada jurnal withdraw full + soft-delete
  - tanpa pilih dompet tombol disabled
  - jika tidak ada dompet cair → error `Tidak ada dompet cair...`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-TRG-026 — Batal hapus target bersaldo [N]
- **Langkah:**
  1. Hapus → pada dropdown dompet tekan back/cancel (null).
- **Ekspektasi:** Abort, target tetap ada, saldo tetap.
- **Integration test**: -
- **Manual test**: ✅

### TC-TRG-027 — Target selesai/COMPLETED tidak auto [E]
- **Prakondisi:** Target tercapai (TC-TRG-018).
- **Langkah:**
  1. Cek list Tabungan & DB status.
- **Ekspektasi:**
  - Tetap `ACTIVE` di list (tidak ada auto-COMPLETED/close)
  - hanya tampilan `Target tercapai`.
- **Integration test**: -
- **Manual test**: ✅

---

## 11. Anggaran & Rencana Anggaran

> Prinsip: Anggaran **tidak menyimpan/memindah uang**. `actualSpend` = sum jurnal posted kategori tsb dalam periode. `actualBudget = budgeted + carry`, `remaining = actual − spend`.

### TC-BGT-001 — Daftar anggaran hanya aktif [P]
- **Prakondisi:** Ada anggaran aktif Makan + anggaran bulan lalu sudah ditutup.
- **Langkah:**
  1. Buka tab Rencana → Anggaran.
- **Ekspektasi:** Hanya yang `closedAt NULL` tampil (bulan lama tertutup tidak tampil).
- **Integration test**: -
- **Manual test**: ✅

### TC-BGT-002 — Search anggaran [P]
- **Langkah:**
  1. Ketik nama kategori → hapus → ketik tidak-ada.
- **Ekspektasi:** Filter nama kategori, empty state jika kosong.
- **Integration test**: -
- **Manual test**: ✅

### TC-BGT-003 — Buat Rencana Anggaran baru [P]
- **Prakondisi:** Kategori `Transport` belum punya rencana.
- **Langkah:**
  1. FAB → pilih `Transport` → isi Besar Rencana Rp500.000 + Catatan → `Simpan`.
- **Ekspektasi:** Masuk ke halaman Rencana (`Besar Rencana` + tanggal buat).
- **Efek samping:**
  - Tanpa jurnal/saldo
  - badge `Terencana` muncul di pemilih kategori.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-004 — Buat rencana nominal kosong [N]
- **Langkah:**
  1. FAB → pilih kategori → kosongkan nominal → Simpan.
- **Ekspektasi:** Error `Nominal rencana belum diisi`.
- **Integration test**: -
- **Manual test**: ✅

### TC-BGT-005 — Buat rencana nominal 0 [E]
- **Langkah:**
  1. Isi `0` → Simpan.
- **Ekspektasi:** Lolos validasi form (hanya required) dan tersimpan — verifikasi kartu tidak crash pembagian nol (pace `noData`, % aneh ditoleransi tapi tidak crash). Catat sebagai edge yang harus tidak crash.
- **Integration test**: -
- **Manual test**: ADJUSTMENT

### TC-BGT-006 — Pilih kategori yang sudah punya rencana → ke detail rencana [P]
- **Prakondisi:** `Makan` sudah punya rencana.
- **Langkah:**
  1. FAB → pilih `Makan`.
- **Ekspektasi:** Langsung ke `BudgetPlanRoute` (detail rencana), bukan form baru.
- **Integration test**: -
- **Manual test**: ✅

### TC-BGT-007 — Ganti kategori saat buat mengecek duplikat [E]
- **Prakondisi:** Di form rencana baru untuk `A`, sudah ada rencana `B`.
- **Langkah:**
  1. Ganti kategori ke `B` → Simpan / lanjut.
- **Ekspektasi:** Di-replace ke detail rencana `B` (tidak duplikat).
- **Integration test**: -
- **Manual test**: ✅

### TC-BGT-008 — Aktifkan rencana (buat anggaran bulan ini) [P]
- **Prakondisi:** Rencana Transport Rp500.000, belum ada anggaran aktif bulan ini.
- **Langkah:**
  1. Detail Rencana → `Aktifkan`.
- **Ekspektasi:** Terbentuk anggaran periode 1–akhir bulan ini, muncul di list Anggaran.
- **Efek samping:**
  - Tanpa jurnal
  - `BudgetSignal` refresh list.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-009 — Tombol disabled saat anggaran berjalan [P]
- **Prakondisi:** Baru aktifkan bulan ini, `now <= periodEnd`.
- **Langkah:**
  1. Buka Detail Rencana.
- **Ekspektasi:** Tombol `Anggaran sedang berjalan` disabled (action null).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-010 — Pengeluaran mengurangi sisa anggaran [P]
- **Prakondisi:** Anggaran Makan Rp1.000.000, sisa `R0`, BCA `B0`.
- **Langkah:**
  1. Catat Pengeluaran Makan Rp100.000 BCA.
  2. Buka Detail Anggaran.
- **Ekspektasi:** `actualSpend +100.000`, `X tersisa = R0−100.000`, `%` & bar naik, `N hari lagi`, `Saran pengeluaran/hari = sisa ~/ hari`, statistik Transaksi +1.
- **Efek samping:** Saldo BCA −100.000 juga (ganda: uang & anggaran). Pemasukan/Transfer/Topup tidak memengaruhi.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-011 — Belanja dari Target memengaruhi anggaran [P]
- **Prakondisi:** Anggaran Makan sisa `R0`.
- **Langkah:**
  1. Belanja dari Target Rp30.000 kategori Makan (periode berjalan).
  2. Cek Detail Anggaran.
- **Ekspektasi:** Sisa = `R0 − 30.000` (saving SPEND ikut actualSpend).
- **Integration test**: ✅
- **Manual test**: GAGAL REFRESH

### TC-BGT-012 — Over-budget [E]
- **Prakondisi:** Anggaran Rp100.000, sudah terpakai Rp80.000.
- **Langkah:**
  1. Pengeluaran Rp50.000 kategori sama.
  2. Buka Detail.
- **Ekspektasi:** `Melebihi Rp30.000`, bar merah, `%` >100% (clamp 999), pace `noData`/over, banner sesuai.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-013 — Tutup dicegah sebelum periode lewat [N]
- **Prakondisi:** Anggaran bulan berjalan, `now <= periodEnd`.
- **Langkah:**
  1. Coba `Tutup` dari Detail Rencana / Detail Anggaran.
- **Ekspektasi:** Snackbar `Anggaran belum melewati periode, belum bisa ditutup`, tombol disabled.
- **Integration test**: -
- **Manual test**: ✅

### TC-BGT-014 — Tutup saja (closeOnly) setelah expired [P]
- **Prakondisi:** Ubah tanggal sistem / tunggu hingga `now > periodEnd` (atau pakai data bulan lalu yang masih aktif).
- **Langkah:**
  1. Detail Rencana → `Tutup Anggaran` → `Tutup saja`.
- **Ekspektasi:** Anggaran hilang dari list aktif (`closedAt` terisi, `leftover = remaining` bisa negatif jika over).
- **Efek samping:**
  - Tanpa jurnal
  - histori bulan lama hanya via Laporan.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-015 — Tutup & Buka Baru tanpa sisa (remaining ≤0) [P]
- **Prakondisi:** Anggaran expired & over/remaining 0.
- **Langkah:**
  1. `Tutup Anggaran` → `Tutup & Buka Baru`.
- **Ekspektasi:** Langsung `carry=0` (skip bottom sheet), terbentuk anggaran bulan berjalan `total = planAmount`.
- **Efek samping:** List tampil anggaran baru sisa penuh.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-016 — Tutup & Buka Baru dengan sisa (rollover) [P]
- **Prakondisi:** Anggaran expired sisa Rp200.000, rencana Rp500.000.
- **Langkah:**
  1. `Tutup & Buka Baru` → bottom sheet → `Bawa sisa (+Rp200.000)`.
- **Ekspektasi:** Anggaran baru `total Rp700.000` + footnote `termasuk Rp200.000 sisa bulan lalu` + tanda `*`.
- **Efek samping:** `carry=200.000`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-017 — Rollover Tanpa sisa & Batal [P]
- **Langkah:**
  1. Ulangi TC-BGT-016 tapi pilih `Tanpa sisa` → cek total = Rp500.000.
  2. Ulangi tapi `Batal`.
- **Ekspektasi:** Tanpa sisa → carry 0. Batal → abort, anggaran lama tetap (belum tertutup) / tidak ada anggaran baru.
- **Integration test**: -
- **Manual test**: ✅

### TC-BGT-018 — Upsert bulan sama (tidak duplikat error) [E]
- **Prakondisi:** Sudah ada anggaran bulan ini Rp500.000.
- **Langkah:**
  1. `Aktifkan` lagi / createBudget periode sama.
- **Ekspektasi:** Tidak error duplikat — di-overwrite/re-open (budgeted/carry/leftover reset, closedAt NULL).
- **Integration test**: ✅
- **Manual test**: TIDAK REACHABLE

### TC-BGT-019 — Edit Rencana tidak sentuh anggaran aktif [P]
- **Prakondisi:** Rencana Makan Rp1.000.000 + anggaran aktif Rp1.000.000.
- **Langkah:**
  1. Detail Rencana → `Edit Rencana` → ubah jadi Rp2.000.000 → Simpan.
- **Ekspektasi:**
  - Rencana berubah
  - anggaran aktif tetap Rp1.000.000 (baru dipakai periode berikutnya).
- **Efek samping:** Tanpa jurnal.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-020 — Hapus Rencana tidak hapus anggaran aktif [P]
- **Prakondisi:** Ada rencana + anggaran aktif.
- **Langkah:**
  1. Detail Rencana → `Hapus Rencana` → baca dialog (`Anggaran yang sudah aktif tidak terpengaruh`) → konfirmasi.
- **Ekspektasi:** Rencana hilang (soft-delete), anggaran aktif tetap di list.
- **Efek samping:** Badge `Terencana` hilang, `Anggaran Aktif` tetap.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-BGT-021 — Detail: ritme, overdue banner, riwayat [P]
- **Prakondisi:** Anggaran dengan spend sebagian & salah satu overdue/expired.
- **Langkah:**
  1. Buka Detail Anggaran.
- **Ekspektasi:** Header periode `d – d MMM yyyy`, pill %, bar + marker elapsed, `N hari lagi`/`Selesai`, ritme (`Sesuai/Sedikit di atas/...` threshold 0.05/0.10/0.25), banner overdue + tombol Tutup jika bisa, Riwayat Pengeluaran terfilter akun+periode.
- **Integration test**: -
- **Manual test**: ✅

---

## 12. Laporan

### TC-RPT-001 — Buka laporan bulan berjalan [P]
- **Langkah:**
  1. Drawer → Laporan (atau tap kartu bulanan di Beranda).
- **Ekspektasi:**
  - Urutan: PeriodSelector, Ringkasan, ComparisonBanner, Insight, Alokasi Target, CashflowBar, Kategori, Anggaran, Tren. Spinner penuh hanya jika summary null
  - ganti bulan tampil data lama + linear progress.
- **Integration test**: -
- **Manual test**: ✅

### TC-RPT-002 — Navigasi bulan & blokir masa depan [P]
- **Langkah:**
  1. Tap `<` ke bulan lalu → cek label.
  2. Tap `>` kembali.
  3. Coba `>` ke bulan depan dari bulan berjalan.
- **Ekspektasi:**
  - Bisa mundur bebas
  - maju diblokir di currentMonth/masa depan.
- **Integration test**: -
- **Manual test**: ✅

### TC-RPT-003 — Ringkasan: net & uang tersedia [P]
- **Prakondisi:** Bulan ini Pemasukan 1.000.000, Pengeluaran 400.000, Topup 200.000, Withdraw 50.000, Spend 30.000.
- **Langkah:**
  1. Lihat Ringkasan.
- **Ekspektasi:**
  - `net = 600.000`
  - `netSaving (dialokasikan) = 200−50−30 = 120.000`
  - `perubahan uang tersedia = net − netSaving`
  - Transfer/Adjustment/Tagihan tidak masuk metrik.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-004 — Comparison vs bulan lalu [P]
- **Prakondisi:** Ada data 2 bulan.
- **Langkah:**
  1. Lihat banner perbandingan.
- **Ekspektasi:**
  - Label naik/turun/tetap + % benar. Jika baseline 0 & kini >0 → % disembunyikan (netral, jangan tampilkan % menyesatkan)
  - 0→0 = tetap/sama.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-005 — Insight [P]
- **Langkah:**
  1. Baca InsightCard.
- **Ekspektasi:**
  - Aturan: surplus vs `Pengeluaran melebihi pemasukan`
  - vs rata-rata ≤3 histori non-empty
  - top kategori %
  - income MoM %
  - `dialokasikan` netSaving. Bulan kosong → tunggal `Belum ada transaksi bulan ini…`.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-006 — Kartu alokasi disembunyikan jika tanpa aktivitas target [E]
- **Prakondisi:** Bulan tanpa topup/withdraw/spend.
- **Langkah:**
  1. Buka laporan bulan tsb.
- **Ekspektasi:** `SavingAllocationCard` hidden.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-007 — Kategori top 6 + Lainnya [P]
- **Prakondisi:** >6 kategori ada pengeluaran bulan ini.
- **Langkah:**
  1. Lihat CategorySpendingCard.
- **Ekspektasi:**
  - 6 teratas + `Lainnya`
  - kosong → `Belum ada pengeluaran bulan ini.`
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-008 — Anggaran section hidden jika kosong [E]
- **Prakondisi:** Bulan tanpa anggaran.
- **Langkah:**
  1. Buka laporan.
- **Ekspektasi:** `BudgetSectionCard` hidden. Jika ada → spent=actualSpend, budget=actualBudget, usage%, over flag, MoM label (baru/sama/naik-turun).
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-009 — Tren 6 bulan [P]
- **Langkah:**
  1. Lihat TrendCard.
- **Ekspektasi:**
  - 6 titik bulanan zona lokal (hindari geser UTC)
  - kosong → `Belum ada data tren.`
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-010 — Bulan kosong [E]
- **Prakondisi:** Pilih bulan tanpa transaksi sama sekali.
- **Langkah:**
  1. Navigasi ke bulan tsb.
- **Ekspektasi:** `Belum ada data bulan ini`, semua kartu empty yang sesuai, tidak crash.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-RPT-011 — Refresh & cache [P]
- **Langkah:**
  1. Pull-to-refresh di Laporan.
  2. Pindah bulan bolak-balik cepat.
- **Ekspektasi:**
  - Data refresh (cache dibuang lalu load dengan data lama tetap tampil)
  - tidak kedip spinner penuh
  - prefetch prev/next diam-diam.
- **Integration test**: -
- **Manual test**: ✅

### TC-RPT-012 — Error + Coba lagi [N]
- **Prakondisi:** Simulasikan gagal load (misal DB terkunci / matikan paksa saat load — jika sulit, cukup verifikasi UI).
- **Langkah:**
  1. Picu error saat summary null.
- **Ekspektasi:** Tampil error + `Coba lagi`.
- **Integration test**: -
- **Manual test**: BACKLOG AKSES

---

## 13. Cadangan (Backup) & Pengaturan

### TC-SET-001 — Ganti tema [P]
- **Prakondisi:** Drawer → Pengaturan.
- **Langkah:**
  1. Pilih `Terang` → `Gelap` → `Ikuti Sistem`.
- **Ekspektasi:** Tema global berubah instan + subtitle label aktif + note persist. Tutup-buka app tetap tersimpan.
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-001 — Status Google & metadata [P]
- **Prakondisi:** Pengaturan online, belum login.
- **Langkah:**
  1. Lihat tile `Google Drive` (`Belum terhubung`) & `Cadangan terakhir` (`Belum ada cadangan` / `Memuat...`).
- **Ekspektasi:**
  - Refresh spinner saat `isLoadingMeta`
  - subtitle benar.
- **Integration test**: -
- **Manual test**: SKIP

### TC-BKP-002 — Cadangkan Sekarang (dengan konfirmasi timpa) [P]
- **Prakondisi:** Online, sudah login Google, ada data.
- **Langkah:**
  1. Tap `Cadangkan Sekarang`.
  2. Jika ada meta → dialog `Timpa Cadangan? (info meta) … tidak dapat dibatalkan` → konfirmasi.
  3. Tunggu overlay `Memproses...`.
- **Ekspektasi:** `Backup berhasil`, metadata update (waktu • size). Hanya 1 cadangan terbaru (`dompet_backup.db` + meta di appDataFolder privat).
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-003 — Pulihkan Cadangan menimpa lokal [P]
- **Prakondisi:** Online, login, ada cadangan. Catat Total/dompet kini.
- **Langkah:**
  1. Tap `Pulihkan Cadangan` → dialog `Data saat ini akan diganti… tidak dapat dibatalkan` → konfirmasi.
- **Ekspektasi:** `Restore berhasil. Data telah dipulihkan.` + seluruh UI refresh (signal account/activity/budget/saving).
- **Efek samping:**
  - DB lokal = isi cadangan (irreversibel kecuali safety copy internal sesaat)
  - Total/dompet/target/anggaran mengikuti cadangan.
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-004 — Batal timpa / batal pulihkan [N]
- **Langkah:**
  1. Picu dialog timpa/pulihkan → `Batal`.
- **Ekspektasi:** Tidak terjadi upload/restore.
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-005 — Offline menonaktifkan Drive [N]
- **Prakondisi:** Matikan internet.
- **Langkah:**
  1. Buka Pengaturan → lihat banner `Tidak ada koneksi…` + tombol `Cadangkan/Pulihkan/refresh` disabled.
  2. Coba sign-out (harus tetap enabled).
- **Ekspektasi:**
  - Sesuai
  - subtitle meta `Perlu koneksi internet untuk memeriksa` jika meta null.
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-006 — Batal login saat backup [N]
- **Prakondisi:** Belum login, online.
- **Langkah:**
  1. Tap `Cadangkan Sekarang` → cancel login Google.
- **Ekspektasi:** Kembali diam ke `initial`, tanpa snackbar sukses, tanpa crash.
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-007 — Keluar dari Google [P]
- **Prakondisi:** Sudah login.
- **Langkah:**
  1. Tap `Keluar dari Google`.
- **Ekspektasi:**
  - Kembali `Belum terhubung`
  - data lokal UTUH (hanya sesi Drive putus).
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-008 — Restore tanpa cadangan [N]
- **Prakondisi:** Akun Google baru tanpa backup.
- **Langkah:**
  1. Tap `Pulihkan Cadangan`.
- **Ekspektasi:** Error `Backup tidak ditemukan`, data lokal tidak berubah.
- **Integration test**: -
- **Manual test**: ✅

### TC-BKP-009 — File rusak / integrity gagal [E]
- **Prakondisi:** Jika bisa simulasikan (staging korup / download korup).
- **Langkah:**
  1. Picu restore dengan file rusak.
- **Ekspektasi:** Error `File backup rusak…` / `Integrity check gagal…`, rollback ke safety copy, DB tetap bisa dibuka (reopen + verify).
- **Integration test**: -
- **Manual test**: BACKLOG AKSES

---

## 14. Lintas Fitur, Navigasi & Edge Global

### TC-GLB-001 — FAB Tambah (tengah) [P]
- **Prakondisi:** Di Shell.
- **Langkah:**
  1. Tap FAB tengah (`+`).
- **Ekspektasi:** Bottom sheet tambah aktivitas (Pemasukan/Pengeluaran/Pindah Dana) terbuka.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-GLB-002 — Konsistensi Total Uang lintas aksi [P]
- **Prakondisi:** Catat `T0`.
- **Langkah:**
  1. Pemasukan +100.000 → cek `T0+100k`.
  2. Pengeluaran −40.000 → cek.
  3. Transfer → cek tetap.
  4. Alokasi −50.000 → cek berkurang.
  5. Tarik +20.000 → cek bertambah.
  6. Belanja target → cek tetap.
  7. Penyesuaian +10.000 → cek bertambah.
  8. Hapus semua satu per satu → cek kembali ke `T0`.
- **Ekspektasi:**
  - Semua sesuai rumus
  - tidak ada selisih Rp1 pun.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-GLB-003 — Hapus lalu buat ulang tidak pakai ulang kode [E]
- **Prakondisi:** Buat Target `X` → hapus → buat `X` lagi; sama untuk Dompet/Kategori.
- **Langkah:**
  1. Lakukan siklus hapus-buat.
- **Ekspektasi:**
  - Kode child monotonik naik (max suffix +1 termasuk soft-deleted), tidak dipakai ulang
  - tidak ada konflik unik.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-GLB-004 — Search debounce & case-insensitive global [E]
- **Langkah:**
  1. Ketik cepat di search Dompet/Aktivitas/Target/Anggaran/Kategori.
- **Ekspektasi:** Tidak freeze, hasil update ~300ms setelah berhenti, lowercase = uppercase.
- **Integration test**: -
- **Manual test**: ✅

### TC-GLB-005 — Nominal besar lintas form [E]
- **Langkah:**
  1. Input `999.999.999.999` di Pemasukan, Transfer, Alokasi, Rencana.
- **Ekspektasi:**
  - Semua format benar, tidak overflow/crash
  - Total & progress benar.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-GLB-006 — Teks panjang/emoji di Nama/Keterangan/Catatan [E]
- **Langkah:**
  1. Isi nama dompet/kategori/target 100 char + emoji + keterangan panjang.
- **Ekspektasi:** Tersimpan, list/detail tidak overflow, tidak crash.
- **Integration test**: ✅
- **Manual test**: ✅

### TC-GLB-007 — Tanggal batas: hari ini & awal bulan [E]
- **Langkah:**
  1. Transaksi tanggal hari ini jam 00:00 & 23:59 → cek masuk Hari Ini & laporan bulan ini.
  2. Transaksi tanggal 1 awal bulan → cek Anggaran & Laporan periode benar (startOfMonth–endOfMonth epoch lokal).
- **Integration test**: -
- **Manual test**: SKIP

### TC-GLB-008 — Ganti bulan/tahun di Laporan & Anggaran [E]
- **Langkah:**
  1. Laporan Desember → Januari tahun berikut.
  2. Anggaran Desember expired → tutup & buka Januari.
- **Ekspektasi:** Periode & carry benar, tidak bocor antar tahun.
- **Integration test**: -
- **Manual test**: SKIP

### TC-GLB-009 — Offline penuh (kecuali Drive) tetap bisa transaksi [P]
- **Prakondisi:** Matikan internet.
- **Langkah:**
  1. Catat Pemasukan/Pengeluaran/Transfer/Alokasi/Belanja/Anggaran/Kategori/Dompet.
- **Ekspektasi:** Semua offline-first berhasil (hanya Drive yang disabled).
- **Integration test**: -
- **Manual test**: SKIP

### TC-GLB-010 — Istilah UI baku (tidak bocor istilah teknis) [P]
- **Langkah:**
  1. Jelajahi semua halaman, catat kata `pocket/saving/backup/neto/budget harian/kembali cair/ditabung`.
- **Ekspektasi:**
  - Tidak ditemukan
  - yang tampil: `Target`, `Alokasi/Dialokasikan ke target`, `Ditarik kembali`, `Belanja dari target`, `Cadangan`, `Anggaran/Rencana Anggaran`, `Saran alokasi`, `Sekitar N bulan menuju target`, `Pengeluaran melebihi pemasukan`.
- **Integration test**: -
- **Manual test**: SKIP

### TC-GLB-011 — Empty state semua list [E]
- **Langkah:**
  1. Dengan filter/search yang kosongkan hasil di Dompet/Aktivitas/Target/Anggaran/Kategori/Laporan, verifikasi tiap empty message + CTA.
- **Ekspektasi:** Pesan ramah, tidak layar putih/crash, CTA berfungsi.
- **Integration test**: -
- **Manual test**: ADA YANG TERLEWAT

### TC-GLB-012 — Batal di setiap dialog konfirmasi [N]
- **Langkah:**
  1. Picu dialog Hapus/Arsip/Tutup/Timpa/Pulihkan/Tetap Simpan → pilih Batal/Kembali.
- **Ekspektasi:** Tidak ada perubahan data/saldo di semua kasus.
- **Integration test**: ✅
- **Manual test**: ✅

---

## Lampiran: Matriks Efek Samping (contekan verifikasi)

| Aksi | Saldo Dompet | Total Uang (cair aktif) | Target | Anggaran (sisa) | Laporan |
|---|---|---|---|---|---|
| Pemasukan | + | + | – | – | Pemasukan + |
| Pengeluaran | − | − | – | − (kategori+periode cocok) | Pengeluaran + |
| Transfer | asal −, tujuan + | tetap | – | – | diabaikan |
| Penyesuaian naik/turun | = input | ± selisih | – | – | tipe sendiri, diabaikan di income/expense |
| Hapus (void) | dibalik | dibalik | dibalik jika saving | dibalik jika expense | dibalik |
| Alokasi ke Target | − | − (terkunci) | + | – | diabaikan (bukan expense) |
| Tarik kembali | + | + | − | – | diabaikan |
| Belanja dari Target | tetap | tetap | − | − | Pengeluaran + |
| Hapus Target bersaldo | + full | + full | hilang | – | – |
| Buat/Edit Rencana, Aktifkan, Tutup | – | – | – | sisa/aktif berubah | section anggaran berubah |
| Arsip Dompet | hilang dari list | − saldo tsb | – | – | histori tetap, baru tidak bisa |
| Arsip Kategori | – | – | – | tidak bisa baru | histori tetap |

**Selesai.** Tandai tiap TC `[x]` saat lolos, catat ID yang gagal + langkah reproduksi + screenshot + saldo sebelum/sesudah.
