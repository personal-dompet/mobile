## ISSUE 1
  - **Deskripsi**: Section pulihkan di initial setup tidak menampilkan email akun yang digunakan untuk login
  - **File**: [InitialSetupPage](lib\features\setup\pages\initial_setup_page.dart)
  - **Saran**: Ganti text "Ada cadangan Dompet dari akun Google ini." dengan email dari akun yang login

## ISSUE 2
  - **Deskripsi**: section Ringkasan Hari Ini di beranda tidak sesuai.
  - **File**: [DashboardPage](lib\features\dashboard\pages\dashboard_page.dart)
  - **Saran**: saat belum ada aktivitas apapun hari ini, hapus teks "Belum ada transaksi hari ini."

## ISSUE 3
  - **Deskripsi**: wording title pada AppBar halaman tabungan belum sesuai
  - **Ekspektasi**: "Target"
  - **Aktual**: "Tabungan"
  - **File**: [SavingPage](lib\features\savings\pages\saving_page.dart)

## ISSUE 4
  - **Deskripsi**: pada halaman Dompet, saat pencarian tidak ditemukan, perlu ditambahkan semacam empty state untuk komunikasi ke user
  - **Ekspektasi**: ada empty state
  - **Aktual**: di bawah field pencarian masih blank
  - **File**: [AssetPage](lib\features\assets\pages\asset_page.dart)

## ISSUE 5
  - **Deskripsi**: jurnal/aktivitas saldo awal tidak tampil
  - **Ekspektasi**: penjurnalan saat pembuatan dompet dengan saldo awal ditampilkan di list aktivitas di halaman manapun (dashboard, aktivitas, detail dompet, list aktivitas tiap dompet)
  - **Aktual**: aktivitas saldo awal belum tampil
  - **Saran**: tone warna dibuat success seperti pemasukan, dan nominalnya juga ditambah "+" di depannya.
  - **Catatan**: jurnal saldo awal hanya muncul di aktivitas saja, tidak mempengaruhi ringkasan dan laporan cash flow

## ISSUE 6
  - **Deskripsi**: section/card "Pemasukan per kategori" di halaman laporan
  - **Saran**: tambah section/card "Pemasukan per kategori" di halaman laporan. style sama dengan "Pengeluaran per kategori"
  - **File**: [ReportPage](lib\features\reports\pages\report_page.dart)

## ISSUE 7 | TC-IN-005
  - **Deskripsi**: TC-IN-005 gagal saat manual test
  - **Aktual**: berhasil simpan pemasukan dengan nominal 0

## ISSUE 8
  - **Deskripsi**: navigasi jebol ke halaman setup padahal sudah ada dompet dan banyak aktivitas. issue ini hanya terjadi ketika melakukan perubahan melalui list dompet -> detail dompet -> detail aktivitas -> perbaiki
  - **Langkah**: 
    1. buka app 
    2. buka drawer. pilih dompet
    3. pilih dompet yang memiliki aktivitas pemasukan/pengeluaran
    4. buka salah satu detail aktivitas 
    5. tap perbaiki
    6. lakukan perbaikan
    7. tap simpan
    8. kembali -> ke halaman detail dompet
    9. kembali -> ke halaman list dompet
    10. kembali -> ke halaman beranda
    11. kembali -> ke halaman setup
  - **Ekspektasi**: pada langkah 11, seharusnya tidak ke halaman setup, tapi menampilkan dialog konfirmasi tutup aplikasi

## ISSUE 9 | TC-OUT-005
  - **Deskripsi**: TC-OUT-005 gagal saat manual test
  - **Aktual**: berhasil simpan pengeluaran dengan nominal 0

## ISSUE 10 | TC-TRF-004
  - **Deskripsi**: TC-TRF-004 gagal saat manual test
  - **Aktual**: berhasil pindah dana dengan nominal 0

## ISSUE 11 | TC-KAT-009
  - **Deskripsi**: Kategori baru yang dibuat dari pilih kategori pada flow pengeluaran/pemasukan tidak langsung terpilih
  - **Langkah**: 
    1. buka app 
    2. tap pengeluaran
    3. tap field kategori
    4. tap "+"
    5. isi nama "Minum", simpan
    6. redirect ke halaman form pengeluaran. field masih kosong
  - **Ekspektasi**: setelah membuat kategori baru, field kategori seharusnya otomatis terpilih kategori baru tersebut

## ISSUE 12
  - **Deskripsi**: tombol clear pada field pencarian tidak muncul
  - **Ekspektasi**: tombol clear muncul saat field memiliki paling tidak 1 karakter valu, dan saat ditap akan melakukan pembersihan field sekaligus fetch ulang data tersebut tanpa keyword. berlaku untuk semua search field di seluruh halaman.

## ISSUE 13
  - **Deskripsi**: reposisi teks "Terkumpul Rpxxxx" pada list riwayat target di halaman detail target
  - **Ekspektasi**: pindahkan teks tersebut ke dalam card list item di bawah nominal, dan sejajar dengan keterangan waktu
  - **Aktual**: teks masih di luar card

## ISSUE 14 | TC-BGT-005
  - **Deskripsi**: perubahan logika validasi
  - **Aktual**: nominal minimal adalah 1. 0 harusnya tidak bisa disimpan

## ISSUE 15 | TC-BGT-011
  - **Deskripsi**: list anggaran tidak tersegarkan setelah melakukan pencatatan belanja dari target untuk kategori yang punya anggaran aktif
  - **Ekspektasi**: list tersegarkan dengan data terbaru
  - **Aktual**: list masih menampilkan sisa anggaran lama, hanya di detail yang menampilkan data terbaru

## ISSUE 16
  - **Deskripsi**: data cadangan terakhir tidak sesuai ketika logout
  - **Langkah**:
    1. buka pengaturan
    2. login google ke email yang punya cadangan
    3. terlihat meta cadangan
    4. keluar dari google
  - **Ekspektasi**: meta cadangan hilang, section diganti dengan keterangan kalau belum ada akun yang login
  - **Aktual**: meta cadangan dari akun seblumnya masih terlihat

## ISSUE 17
  - **Deskripsi**: data cadangan terakhir tidak sesuai dengan akun yang digunakan login
  - **Langkah**:
    1. Lanjutkan langkah dari ISSUE 16
    2. login dengan akun berbeda
  - **Ekspektasi**: meta cadangan hilang, section diganti dengan keterangan kalau belum ada cadangan yang tersimpan di akun tersebut
  - **Aktual**: meta cadangan dari akun seblumnya masih terlihat