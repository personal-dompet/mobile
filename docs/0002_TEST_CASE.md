# TEST CASE Fase-2 — Regression Issue + Verifikasi Improvement

> Fase-2 = regression atas `0001_ISSUE.md` (17 issue) + verifikasi `0001_IMPROVEMENT.md` (9 improvement).
> Format ikut `0001_TEST_CASE.md`: Prakondisi → Langkah → Ekspektasi → Efek samping. Tag `[P]` = Positif, `[N]` = Negatif, `[E]` = Edge/Boundary.
> Bahasa UI ikut `DOCUMENT.md`: **Target** (bukan Tabungan/Pocket), **Alokasi / Dialokasikan ke target**, **Ditarik kembali**, **Belanja dari target**, **Pindah Dana**, **Penyesuaian Saldo**, **Anggaran / Rencana Anggaran**, **Cadangan** (bukan Backup).
> Cara pakai: jalankan setelah fix fase-1. Urutan disarankan: Nominal+Backup → Nav → Agregasi → Overdraw+Belanja → Kategori → Search+Term+Snack+Arsip.
>
> Status otomatisasi (`integration_test/phase2_regression_test.dart` — 28 test hijau di device via `flutter test integration_test/phase2_regression_test.dart`):
> `✅` = logika + efek samping (saldo / Total Uang / target / anggaran / laporan) terverifikasi otomatis dan lolos.
> Cakupan: 18 dari 18 TC2 bertanda ✅. Tetap dicek manual: OAuth Google + upload/restore Drive asli (kontrak state terotomasi di TC2-BKP-001), rantai drawer penuh TC2-NAV-001 (replace-edit + dialog tutup terotomasi), dan dialog Batal overdraw di UI (jalur repo Batal = 0 jurnal terotomasi di TC2-OVD-001).
> Catatan harness: tulis via TransactionForm wajib `await settleFormTotal(form, nominal)` (di `integration_test/helpers/fixture.dart`) sebelum panggil repo — recompute total otomatis async bisa membaca transient sum=0 di device dan gagal `Nominal harus lebih dari 0` padahal input valid.

**Setup data dasar (sama 0001):**
- 2 Dompet aktif (`Tunai` Rp1.000.000, `BCA` Rp5.000.000, tambah `GoPay` bila perlu).
- 2 Kategori Pengeluaran (`Makan`, `Transport`), 1 Kategori Pemasukan (`Gaji`).
- 1 Target (`Dana Darurat` / `Laptop`), 1 Rencana Anggaran (`Makan` Rp1.000.000).
- Catat **Total Uang** awal (`T0`), saldo dompet (`S0/B0`), sisa anggaran (`R0`), journal count sebelum tiap aksi saldo.
- Format nominal: bilangan bulat, tanpa desimal, tanpa negatif. Pisahkan ribu dengan titik.

**Keputusan beku yang dipakai plan ini:**
- `min 1` global semua domain uang → `0/null/negatif` ditolak form+repo.
- IMP-7 = Opsi B hybrid: Belanja = 2 jurnal atomik (tarik + pengeluaran), kategori opsional fallback `Lain-Lain`.
- Jurnal `source=setup` (saldo awal): tampil di aktivitas, hilang dari ringkasan/laporan/anggaran/cashflow/trend.
- Snackbar sistem baru dulu (atas, bg seragam, pembeda teks/icon); pesan IMP-4 ikut sistem baru.
- Navigasi arsip + rencana via icon AppBar (bukan drawer).

## Traceability (26/26 tertutup, 18 case, nol redundan)

| TC2 | Trace | Relasi ke TC1 |
| --- | --- | --- |
| TC2-BKP-001 | ISSUE-1, ISSUE-16, ISSUE-17 | baru (gabung auth Cadangan) |
| TC2-NOM-001 | ISSUE-7, ISSUE-9, ISSUE-10, ISSUE-14 (TC-IN-005, TC-OUT-005, TC-TRF-004, TC-BGT-005) | gabung tolak 0 lintas domain |
| TC2-NAV-001 | ISSUE-8 | baru (back tak jebol setup) |
| TC2-DSH-001 | ISSUE-2 | UPDATE TC-DSH-008 |
| TC2-ACT-001 | ISSUE-5 | baru (jurnal saldo awal) |
| TC2-RPT-001 | ISSUE-6 | baru (card Pemasukan per kategori) |
| TC2-SRCH-001 | ISSUE-4, ISSUE-12 | UPDATE TC-DMP-002, GLB-004/011 |
| TC2-KAT-001 | ISSUE-11 | UPDATE TC-KAT-009 |
| TC2-KAT-002 | IMP-3 | baru (list kategori arsip) |
| TC2-DMP-001 | IMP-2 | baru (grid dompet arsip) |
| TC2-ADJ-001 | IMP-4 | UPDATE TC-ADJ-003 (no-op, bukan jurnal 0) |
| TC2-OVD-001 | IMP-1 | UPDATE TC-OUT-004, TC-TRF-005, TC-OUT-009 |
| TC2-TRG-001 | ISSUE-13, IMP-6 | UPDATE TC-TRG-022, TC-TRG-013, TC-TRG-015 |
| TC2-TRG-002 | IMP-7, ISSUE-15 | REWRITE TC-TRG-015/016, UPDATE TC-BGT-011 |
| TC2-BGT-001 | IMP-8 | baru (anggaran kategori diarsip) |
| TC2-BGT-002 | IMP-9 | baru (list rencana anggaran) |
| TC2-TERM-001 | ISSUE-3 | UPDATE TC-DSH-015, GLB-010 |
| TC2-SNK-001 | IMP-5 | baru (fondasi TC2-ADJ-001) |

---

## TC2-BKP-001 — Auth Cadangan: logout + ganti akun + email [P/E] — trace ISSUE-1,16,17

- **Prakondisi:** Pengaturan online. Akun A punya Cadangan, akun B tanpa Cadangan. Catat meta A.
- **Langkah:**
  1. Login A → lihat section Cadangan.
  2. Buka Initial Setup → lihat section pulihkan.
  3. Pengaturan → `Keluar dari Google`.
  4. Login B → lihat section Cadangan.
  5. Logout → lihat section.
- **Ekspektasi:**
  1. Meta A tampil + email A eksplisit.
  2. Setup tampil email aktual, bukan teks generik `Ada cadangan Dompet dari akun Google ini.`
  3. Meta hilang, ganti teks `belum ada akun login`, bukan meta basi A.
  4. State kosong `belum ada cadangan di akun ini`, bukan meta A.
  5. Sama step 3, lokal utuh.
- **Efek samping:** DB lokal tak berubah kecuali restore eksplisit. `lastBackup=null` + `accountEmail=null` saat logout. Ganti A→B tanpa logout eksplisit tetap refresh.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-NOM-001 — Tolak nominal 0 lintas domain [N] — trace ISSUE-7,9,10,14 (TC-IN-005,OUT-005,TRF-004,BGT-005)

- **Prakondisi:** BCA ada. Kategori Makan, Gaji ada. Rencana Makan ada. Catat saldo BCA `S0`, Total `T0`.
- **Langkah:**
  1. Pemasukan BCA Rp0 → Simpan. Ulangi kosong → Simpan.
  2. Pengeluaran BCA-Makan Rp0 → Simpan (single + batch).
  3. Pindah Dana BCA→GoPay Rp0 → Simpan.
  4. Rencana Anggaran Rp0 → Simpan.
  5. Ulangi 1-3 via Perbaiki (edit naik/turun ke 0).
- **Ekspektasi:** Semua ditolak form (`Masukkan nominal...` / `Nominal harus lebih dari 0`), tak panggil cubit/repo, tak ada jurnal, dialog overdraw tak muncul.
- **Efek samping:** Saldo, Total, anggaran, laporan tetap `S0/T0`. DB journal count tetap.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-NAV-001 — Back tak jebol ke setup setelah perbaiki [E] — trace ISSUE-8

- **Prakondisi:** Ada dompet + aktivitas pemasukan/pengeluaran.
- **Langkah:**
  1. Buka app → drawer → Dompet.
  2. Pilih dompet beraktivitas → buka detail aktivitas → Perbaiki → ubah → Simpan.
  3. Back → detail dompet.
  4. Back → list dompet.
  5. Back → Beranda.
  6. Back sistem.
- **Ekspektasi:** Step 3-5 sesuai stack, step 6 dialog `Tutup aplikasi?` → Ya tutup, Batal diam. Tak pernah ke setup.
- **Efek samping:** Edit tetap tersimpan sekali. Tak ada duplikat jurnal.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-DSH-001 — Ringkasan kosong tanpa teks [P] — trace ISSUE-2 (UPDATE TC-DSH-008)

- **Prakondisi:** Hari ini nol transaksi (termasuk abaikan jurnal setup).
- **Langkah:**
  1. Buka Beranda → lihat Ringkasan Hari Ini.
- **Ekspektasi:** Teks `Belum ada transaksi hari ini.` hilang. Dua kartu Pemasukan/Pengeluaran Rp0 tetap tampil.
- **Efek samping:** Jurnal saldo awal tak picu isi (lihat TC2-ACT-001).
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-ACT-001 — Jurnal saldo awal tampil eksklusif agregat [P] — trace ISSUE-5

- **Prakondisi:** Total `T0`. Buat dompet `OVO` saldo Rp250.000.
- **Langkah:**
  1. Cek Aktivitas global, Beranda Terbaru, Detail OVO, list aktivitas OVO.
  2. Cek Ringkasan Hari Ini, Laporan bulan ini (ringkas + per kategori + cashflow), Anggaran Makan.
  3. Cek warna/tanda.
- **Ekspektasi:** Muncul di 4 list, gaya success hijau seperti pemasukan, prefix `+Rp250.000`, judul fallback `Saldo awal`. Tak masuk ringkasan/laporan/anggaran.
- **Efek samping:** Saldo OVO=250k, Total=`T0+250k`. `transaction_count` tak naik. Report income/expense tetap.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-RPT-001 — Card Pemasukan per kategori [P] — trace ISSUE-6

- **Prakondisi:** Bulan ini ada pemasukan Gaji+Bonus, pengeluaran Makan+Transport, +1 saldo awal.
- **Langkah:**
  1. Drawer → Laporan → lihat seksi Kategori.
- **Ekspektasi:** Ada card `Pemasukan per kategori`, style sama `Pengeluaran per kategori` (top 6 + Lainnya). Angka = summary. Saldo awal eksklusif. Kosong → `Belum ada pemasukan bulan ini.`
- **Efek samping:** Tak ganda hitung topup/withdraw/spend.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-SRCH-001 — Clear global + empty Dompet [P/E] — trace ISSUE-4,12 (UPDATE TC-DMP-002, GLB-004/011)

- **Prakondisi:** Ada Tunai, BCA, GoPay.
- **Langkah:**
  1. Tiap search (Dompet, Aktivitas, Target, Anggaran, Kategori, pemilih kategori): ketik 1 char → cek tombol clear.
  2. Tap clear → cek isi + list.
  3. Dompet ketik `xyz-tidak-ada` → cek.
  4. Ketik `bca` lowercase.
- **Ekspektasi:** Clear muncul jika ≥1 char, tap → field bersih + fetch ulang tanpa keyword (tanpa ketik ulang). Tanpa hasil → empty state ramah (bukan blank), ada saran/CTA reset. Filter case-insensitive, debounce ~300ms, tak freeze.
- **Efek samping:** Tak ubah data. CTA reset kembalikan semua.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-KAT-001 — Buat cepat langsung terpilih [P] — trace ISSUE-11 (UPDATE TC-KAT-009)

- **Prakondisi:** Form Pengeluaran + Pemasukan (single + batch).
- **Langkah:**
  1. Pengeluaran → Kategori → `+` → buat `Minum` → Simpan.
  2. Ulangi di Pemasukan → buat `BonusX` → Simpan.
  3. Ulangi mode batch.
- **Ekspektasi:** Kembali ke form dengan field terisi kategori baru langsung. Badge Terencana/Anggaran Aktif ikut jika ada.
- **Efek samping:** Kategori tersimpan di `Kategori Saya`, bisa dipakai Rencana Anggaran.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-KAT-002 — List kategori arsip per tipe [P] — trace IMP-3

- **Prakondisi:** Ada kategori `Hobi` expense + `Freelance` income. Arsipkan keduanya.
- **Langkah:**
  1. Buka halaman arsip via AppBar icon di Kategori Pengeluaran/Pemasukan.
  2. Cek isi vs list aktif.
  3. Swipe item → Pulihkan.
  4. Coba pakai arsip di form baru.
- **Ekspektasi:** List arsip mirror aktif per tipe. Swipe muncul Pulihkan seperti `Kategori Saya`. Pulihkan → kembali ke aktif. Arsip tak muncul di pemilih transaksi/anggaran baru, histori lama tetap nama.
- **Efek samping:** Tanpa hapus fisik. Counter/saldo tak berubah.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-DMP-001 — Grid dompet arsip [P] — trace IMP-2

- **Prakondisi:** Arsipkan Tunai bersaldo (sisakan ≥1 aktif).
- **Langkah:**
  1. Buka arsip via AppBar icon di Dompet.
  2. Tap card Tunai → cek detail.
  3. Pulihkan → cek list + Total.
  4. Coba pilih arsip di form Pindah Dana/Alokasi.
- **Ekspektasi:** Grid 2 kolom mirror aktif (ikon,nama,saldo). Tap → detail (chip abu `Diarsipkan`, hanya Pulihkan, tanpa Sesuaikan/FAB). Pulihkan → `Berhasil memulihkan`, Total += saldo. Tak bisa dipakai transaksi baru.
- **Efek samping:** Total saat arsip = `T0-saldo`, pulih = kembali. Histori tetap.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-ADJ-001 — Adjustment selisih 0 no-op [E] — trace IMP-4 (UPDATE TC-ADJ-003)

- **Prakondisi:** BCA Rp1.000.000. Catat journal count. Total `T0`.
- **Langkah:**
  1. Detail BCA → Sesuaikan → input sama Rp1.000.000 → Simpan.
- **Ekspektasi:** Tanpa jurnal baru, pop ke detail, snackbar info primary `Tidak ada perubahan saldo` (posisi/bg ikut TC2-SNK-001). Bukan error merah.
- **Efek samping:** Saldo + Total tetap. Count jurnal tetap.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-OVD-001 — Overdraw 2 jurnal atomik [E] — trace IMP-1 (UPDATE TC-OUT-004,TRF-005,OUT-009)

- **Prakondisi:** Tunai Rp10.000, BCA Rp50.000. Catat saldo.
- **Langkah:**
  1. Pengeluaran Tunai Rp10.000 (==saldo) → Simpan.
  2. Pengeluaran Tunai Rp100.000 (>saldo) → Simpan → baca dialog → Batal. Ulangi → Tetap Lanjut.
  3. Pindah Dana BCA→GoPay ==saldo → Simpan.
  4. Pindah Dana BCA→GoPay >saldo sumber → dialog → Lanjut/Batal.
  5. Edit pengeluaran naikkan hingga > efektif (ingat effective = kini + lama jika dompet sama).
- **Ekspektasi:** ==saldo → 1 jurnal biasa, tanpa dialog. >saldo → dialog baru sebut 2 jurnal + angka selisih (`nominal-effective`): (1) penyesuaian selisih, (2) transaksi biasa. Lanjut → 2 jurnal posted atomik, saldo akhir benar. Batal → 0 jurnal. Dialog lama `mungkin negatif` hilang. Transfer cek sumber saja.
- **Efek samping:** Adjustment selisih = `nominal-effective`, bukan penuh. 1 sinyal Budget untuk expense (tak ganda). Gagal tengah → rollback semua.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-TRG-001 — UI Target: repos + info terkumpul [P] — trace ISSUE-13, IMP-6 (UPDATE TC-TRG-022,013,015)

- **Prakondisi:** Target Laptop ada Topup 200k → Tarik 50k → Belanja 30k.
- **Langkah:**
  1. Buka Detail → Riwayat Target.
  2. Buka form Tarik + Belanja.
- **Ekspektasi:** `Terkumpul RpX` di dalam card item, bawah nominal, sejajar waktu (bukan luar card). Running balance 0→200→150→120 benar, urut tanggal. Form ada info santai tak mencolok `Terkumpul sekarang RpX • maksimal ...`.
- **Efek samping:** Perhitungan balance tak berubah. Info baca balance, bukan query berat.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-TRG-002 — Belanja 2 jurnal + refresh anggaran [P] — trace IMP-7, ISSUE-15 (REWRITE TC-TRG-015/016, UPDATE TC-BGT-011)

- **Prakondisi:** Target Rp150.000, BCA `B0`, Total cair `T0`, Anggaran Makan sisa `R0`. Pastikan akun `Lain-Lain` ada/tak ada (uji fallback).
- **Langkah:**
  1. Detail → Belanja → cek field: nominal, Dari Dompet (wajib), Kategori (opsional), info terkumpul.
  2. Belanja Makan Rp30.000 via BCA → Simpan.
  3. Cek list Anggaran + Detail Makan.
  4. Cek Laporan + Ringkasan + Aktivitas.
  5. Ulangi tanpa kategori → Simpan.
  6. Coba melebihi target → Simpan.
- **Ekspektasi:** Simpan → 2 jurnal atomik: J1 tarik (debit dompet credit target), J2 expense (debit expense credit dompet). List + detail anggaran segar sama `R0-30k`. Laporan Pengeluaran +30k Makan, Ringkasan +30k, Aktivitas Belanja. Tanpa kategori → fallback `Lain-Lain`, tetap sukses (bukan error wajib). Melebihi target → `Saldo tidak mencukupi`.
- **Efek samping:** Target -30k, BCA net tetap (`+30-30`), Total cair tetap. Hanya J2 masuk expense/budget. 4 sinyal fire (Saving+Account+Activity+Budget).
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-BGT-001 — Anggaran kategori diarsip [P/E] — trace IMP-8

- **Prakondisi:** Kategori Hobi + anggaran aktif Hobi.
- **Langkah:**
  1. Arsipkan Hobi kapan saja.
  2. Buka list Anggaran + Detail Hobi.
  3. Tap icon (i) samping badge.
  4. Coba catat pengeluaran Hobi baru.
- **Ekspektasi:** Arsip sukses. Anggaran tetap aktif + terhitung. Badge `Kategori diarsipkan` + icon (i) di list+detail → modal kalem `anggaran tak bisa dilacak lagi`. Tak crash null. Transaksi baru ditolak lembut (arahkan buat baru), histori lama jalan.
- **Efek samping:** Tanpa hapus anggaran. Spent lama tetap.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-BGT-002 — List rencana anggaran [P] — trace IMP-9

- **Prakondisi:** Ada rencana Makan + Transport.
- **Langkah:**
  1. Buka Anggaran → tap icon AppBar (rencana).
  2. Cek list rencana vs detail rencana existing.
- **Ekspektasi:** Icon tunggal buka list rencana. Isi = `Besar Rencana` + tanggal buat per kategori, konsisten TC-BGT-003..009. Tap item → detail rencana.
- **Efek samping:** Tanpa jurnal. Badge Terencana tetap.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-TERM-001 — Judul Target baku [P] — trace ISSUE-3 (UPDATE TC-DSH-015, GLB-010)

- **Prakondisi:** Di Shell.
- **Langkah:**
  1. Pindah tab Beranda/Aktivitas/Anggaran/Tabungan → cek AppBar.
  2. Grep `Tabungan|Pocket|saving|backup|neto` di UI.
- **Ekspektasi:** Judul `Target` (bukan Tabungan). FAB konteks tetap (Beranda/Aktivitas=tambah aktivitas, Anggaran=tambah anggaran, Target=tambah target). Nol bocor istilah teknis; tampil hanya Target, Alokasi, Ditarik kembali, Belanja dari target, Cadangan, Anggaran/Rencana Anggaran.
- **Efek samping:** Route name tak berubah, hanya label.
- **Integration test**: ✅
- **Manual test**: ✅

## TC2-SNK-001 — Snackbar atas global [P/E] — trace IMP-5 (fondasi TC2-ADJ-001)

- **Prakondisi:** Tema Terang + Gelap. Siap picu success/error/info (simpan transaksi, gagal validasi, no-op adjustment).
- **Langkah:**
  1. Picu tiap tipe di transaksi/transfer/adjustment/setup/settings/saving/budget.
  2. Cek posisi, bg, teks/icon, shadow di terang+gelap.
- **Ekspektasi:** Semua di atas halaman, satu bg sama semua tipe, pembeda hanya warna teks/icon, kontras dari app bg + shadow jelas. API `DompetSnackbar` tetap, durasi/action tak berubah.
- **Efek samping:** Tak ubah logika simpan. QA semua call-site.
- **Integration test**: ✅
- **Manual test**: Perubahan requirement, tetap menggunakan material design, hanya warnanya saja yang disesuaikan

---

## Catatan risiko QA

- Nav ISSUE-8 akar scope `replace` belum 100% tanpa log stack → TC2-NAV-001 bisa flaky.
- Drive cache kredensial lama → TC2-BKP-001 butuh verifikasi scope akun aktif.
- Query budget spent J2 belum verifikasi penuh → TC2-TRG-002 cek `WHERE source` sekali.
- Fallback `Lain-Lain` cari-vs-buat belum beku → catat pilihan saat eksekusi.
- Predicate clear + snackbar atas sentuh banyak halaman → QA global wajib.
- `==saldo` vs `>saldo` salah hitung effective saat edit pindah dompet → TC2-OVD-001 step 5 kritis.
