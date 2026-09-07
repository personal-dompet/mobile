# Dompet — Project Context & Product Decisions

## Ringkasan Produk

Dompet adalah aplikasi personal finance offline-first yang menggunakan mesin akuntansi double-entry di belakang layar, tetapi menghadirkan pengalaman pengguna yang sederhana dan mudah dipahami oleh pengguna non-akuntansi.

Tujuan utama aplikasi adalah membantu pengguna mencatat, memahami, dan mengelola uang mereka tanpa harus mempelajari konsep akuntansi.

---

# Filosofi Produk

## Prinsip Utama

* Offline-first
* Cepat dan ringan
* Minim friksi onboarding
* Tidak menghakimi pengguna
* Tidak memaksa pengguna memahami akuntansi
* Fokus pada kebiasaan mencatat uang sehari-hari

## Tone

Dompet harus terasa:

* Tenang
* Profesional
* Ramah
* Sederhana
* Tidak menggurui
* Tidak teknis

## Bahasa Produk (istilah baku UI)

Gunakan bahasa aksi pengguna, bukan mekanisme sistem.
Nama kode/internal (`pocket`, `saving`, `backup`, `neto`) tidak boleh bocor ke UI.

| Gunakan di UI | Jangan gunakan | Catatan |
| --- | --- | --- |
| Target | Tabungan, Pocket | Tempat tujuan uang |
| Alokasi / Dialokasikan ke target | Ditabung, Masuk pocket | Uang yang dimasukkan ke target |
| Ditarik kembali | Kembali cair | Penarikan dari target ke dompet |
| Belanja dari target | Belanja dari pocket | Sudah termasuk pengeluaran |
| Uang yang tersedia berubah | Perubahan uang aktif | Rekonsiliasi Laporan vs Beranda |
| Pengeluaran melebihi pemasukan | Defisit | Insight Laporan |
| Saran alokasi | Perlu (kecuali overdue) | Kebutuhan bulanan ber-deadline |
| Anggaran | Budget harian | Instance bulanan per kategori |
| Rencana Anggaran | — | Template berulang; Aktifkan = buat anggaran bulan ini |
| Cadangan | Backup | Seluruh UI setup + pengaturan |
| Sekitar N bulan menuju target | Sekitar N bulan lagi (deadline) | Label durasi deadline |

---

# Prioritas Pengembangan

Saat menentukan prioritas fitur:

1. Bangun fondasi/core feature terlebih dahulu.
2. Bangun fitur dengan dependency paling sedikit terlebih dahulu.
3. Pilih fitur yang lebih sederhana sebelum fitur yang lebih kompleks jika prioritasnya setara.

Karena Dompet direncanakan dirilis sebagai produk yang utuh, bukan bertahap per fitur.

---

# Arsitektur Domain

## Dompet

Dompet bukan entitas khusus.

Secara teknis:

Dompet = Account dengan jenis Asset

Contoh:

* Tunai
* BCA
* Mandiri
* GoPay
* OVO
* Bibit

Dompet merepresentasikan tempat uang asli berada.

---

## Budget

Budget digunakan untuk membantu pengguna mengatur batas pengeluaran per kategori.

Contoh:

* Makan Rp1.000.000
* Transportasi Rp500.000
* Hiburan Rp300.000

Budget terhubung dengan kategori pengeluaran.

Saat transaksi dicatat, penggunaan budget akan dihitung otomatis berdasarkan kategori yang dipilih.

Tujuan utama fitur ini adalah membantu pengguna memantau dan mengendalikan pengeluaran selama periode tertentu.

Budget tidak menyimpan uang dan tidak memindahkan saldo dari Dompet.

---

## Target Keuangan

Target Keuangan digunakan untuk membantu pengguna merencanakan dan memantau tujuan finansial.

Contoh:

* Dana Darurat
* Liburan
* Laptop Baru

Target menampilkan:

* Nama target
* Nominal tujuan
* Progress saat ini
* Persentase pencapaian

Target Keuangan berfokus pada kemajuan menuju tujuan, bukan pada lokasi penyimpanan uang.

Implementasi internal dapat menggunakan akun khusus, tetapi konsep tersebut tidak ditampilkan kepada pengguna.

---

# Navigasi Utama

Bottom Navigation:

1. Beranda
2. Aktivitas
3. Tambah (FAB)
4. Rencana
5. Menu

---

# Rencana

Halaman Rencana menjadi pusat fitur perencanaan keuangan.

Mencakup:

* Budget
* Target Keuangan

Fitur-fitur perencanaan lain di masa depan dapat ditempatkan di area ini jika masih relevan dengan tujuan membantu pengguna merencanakan penggunaan uang mereka.

---

# Dashboard

Urutan komponen:

1. Header
2. Total Uang
3. Mulai Catat
4. Ringkasan Hari Ini
5. Aktivitas Terbaru

---

## Total Uang

Menampilkan total saldo dari seluruh Dompet aktif.

Fitur:

* Visibility toggle

Tidak termasuk:

* Dompet yang diarsipkan

---

## Mulai Catat

Quick actions:

* Pemasukan
* Pengeluaran
* Pindah Dana

---

# Onboarding

Onboarding dibuat sesingkat mungkin.

Pengguna hanya perlu membuat Dompet pertama.

Contoh:

* Tunai
* BCA
* GoPay

Kategori tidak wajib saat onboarding.

---

# Sistem Akuntansi

Dompet menggunakan mesin double-entry accounting.

Pengguna tidak perlu melihat konsep debit/kredit.

Semua aktivitas tetap dicatat sebagai jurnal di belakang layar.

---

# Jenis Aktivitas

Jenis aktivitas yang tersedia:

1. Pemasukan
2. Pengeluaran
3. Transfer
4. Pembayaran Tagihan
5. Penyesuaian Saldo

---

# Aktivitas

## Judul Aktivitas

Fallback:

1. Deskripsi
2. Kategori
3. Label aktivitas

---

## Grouping Tanggal

Urutan:

* Hari Ini
* Kemarin
* Nama Hari (maksimal 7 hari ke belakang)
* Tanggal lengkap

---

## Filter

Aktivitas mendukung:

* Search
* Filter tipe aktivitas
* Filter tanggal

---

# Pengeluaran

## Sumber Dana

Satu transaksi pengeluaran hanya dapat menggunakan satu Dompet.

Jika pengeluaran dibayar menggunakan beberapa Dompet sekaligus, pengguna harus mencatatnya sebagai beberapa transaksi terpisah.

Contoh:

Pembayaran:

* GoPay Rp50.000
* BCA Rp150.000

Dicatat sebagai:

Pengeluaran 1:

* Rp50.000
* GoPay

Pengeluaran 2:

* Rp150.000
* BCA

Keputusan ini diambil untuk menjaga kesederhanaan model data dan pengalaman pengguna.

---

## Kategori

Satu transaksi pengeluaran dapat memiliki satu atau lebih kategori.

Dukungan multi kategori diberikan untuk mengakomodasi transaksi yang berasal dari satu nota tetapi mencakup beberapa jenis pengeluaran.

---

# Dompet

## Struktur Konsep

Dompet adalah Account bertipe Asset.

Tidak ada entitas Wallet terpisah.

---

## Jenis Dompet

Jenis dompet disediakan sistem dan tidak dapat ditambah pengguna.

Contoh:

* Tunai
* Bank
* E-Wallet
* Investasi

---

## Saldo Awal

Saldo awal bersifat opsional.

Jika diisi saat pembuatan Dompet, sistem membuat jurnal pembuka.

Contoh:

Asset:BCA               +5.000.000
Equity:Saldo Awal       +5.000.000

Saldo awal tidak disimpan sebagai angka khusus di tabel account.

---

## Daftar Dompet

Bentuk:

* Flat Grid

Menampilkan:

* Icon
* Nama Dompet
* Saldo

Tidak dikelompokkan berdasarkan jenis.

---

## Pengurutan Dompet

Menggunakan kombinasi:

1. Nama
2. Frekuensi penggunaan

Account memiliki kolom:

counter

Counter bertambah ketika jurnal berubah status menjadi:

posted

Semua akun yang terlibat dalam jurnal tersebut akan mendapatkan penambahan counter.

Tujuan:

* Akun yang sering digunakan muncul lebih tinggi.
* Mempercepat pemilihan akun.

---

# Detail Dompet

Fokus halaman:

1. Saldo saat ini
2. Akurasi saldo
3. Aktivitas terbaru

Bukan halaman laporan.

---

## Aksi Utama

* Penyesuaian Saldo

---

## Overflow Menu

* Ubah Nama
* Ubah Jenis
* Arsipkan
* Pulihkan

Dan metadata lain yang relevan.

---

## Aktivitas

Menampilkan preview aktivitas terbaru.

Menyediakan tombol:

Lihat Semua

---

# Transfer

## Di Detail Dompet

Transfer ditampilkan dari perspektif dompet yang sedang dibuka.

Contoh:

Transfer ke GoPay

Transfer dari BCA

---

## Di Aktivitas Global

Menampilkan kedua sisi transaksi.

Contoh:

BCA → GoPay

---

# Arsip Dompet

## Konsep

User hanya mengenal istilah:

Arsip

Secara teknis menggunakan soft delete.

Contoh implementasi:

is_deleted

---

## Efek Arsip

Dompet yang diarsipkan:

* Tidak muncul di daftar aktif
* Tidak bisa dipakai transaksi baru
* Tidak bisa dipilih transfer
* Tidak bisa penyesuaian saldo

Tetapi:

* Seluruh histori tetap dipertahankan
* Aktivitas lama tetap menampilkan nama dompet

---

## Total Uang

Dompet arsip tidak ikut dihitung.

Alasan:

Total Uang harus merepresentasikan uang aktif yang sedang dikelola pengguna saat ini.

---

## UX Arsip

Saat mengarsipkan dompet yang masih memiliki saldo:

Pengguna harus diberi tahu bahwa:

* Saldo tidak ikut Total Uang
* Riwayat tetap tersimpan
* Dompet dapat dipulihkan kapan saja

Jika dompet yang akan diarsipkan merupakan dompet aktif terakhir, proses pengarsipan dibatalkan.

Aplikasi harus selalu memiliki setidaknya satu Dompet aktif.

---

## Tampilan Status Arsip

Gunakan chip netral berwarna abu-abu.

Bukan warning atau error.

---

# Penyesuaian Saldo

## Bentuk UI

Dedicated Full Page.

Bukan Bottom Sheet.

---

## Alur

Pengguna memasukkan:

Saldo sebenarnya saat ini

Sistem menghitung:

Selisih penyesuaian

secara otomatis.

---

## Deskripsi

Dibuat otomatis oleh sistem.

Karakteristik:

* Singkat
* Jelas
* Fokus pada rekonsiliasi

---

# Edit Transaksi

Saat mengedit transaksi:

UI menampilkan:

Saldo saat ini

Tetapi validasi menggunakan:

Effective Balance

yaitu saldo setelah efek transaksi lama dibalik terlebih dahulu.

---

# Subtype Akun

Dapat diperluas pengguna:

* Income Subtype
* Expense Subtype

Dikontrol sistem:

* Asset Subtype
* Liability Subtype
* Equity Subtype

---

# Status Proyek Saat Ini

## Sudah Matang / Final

* Visi Produk
* Filosofi UX
* Terminologi Dompet
* Navigasi Utama
* Dashboard
* Onboarding
* Model Akuntansi
* Aktivitas
* Manajemen Dompet
* Arsip Dompet
* Penyesuaian Saldo
* Transfer
* Sorting Dompet
* Saldo Awal
* Edit Transaction Validation
* Single Asset Account per Expense Transaction

## Belum Dibahas Mendalam

* Budget Kategori
* Target Keuangan
* Kategori
* Form Transaksi Lengkap
* Detail Aktivitas
* Tagihan Berulang
* Laporan & Analytics
* Backup & Sync
* Export / Import
* Attachment
* Multi Currency
