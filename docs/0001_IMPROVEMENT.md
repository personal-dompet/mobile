## IMPROVEMENT 1
  - **Deskripsi**: Perubahan logika bisnis terkait pengeluaran dan transfer melebihi saldo. Khusus transfer berarti yang terdampak adalah asset sumbernya
  - **Aktual**: Saat user mencatat pengeluaran/transfer yang nominalnya melebihi saldo dari dompet (asset) yang dipilih, maka ketika simpan akan diberikan informasi bahwa saldo dapat menjadi negatif. Tidak ada restriction apapun, jika user tetap melanjutkan, maka jurnal akan tetap tercatat dan saldo dari aset tersebut akan menjadi negatif.
  - **Ekspektasi**: Saat user mencatat pengeluaran yang nominalnya melebihi saldo dari dompet (asset) yang dipilih, maka ketika simpan akan diberikan dialog bahwa jika melanjutkan, maka dia setuju untuk melakukan jurnal 2x:
    1. Jurnal untuk penyesuaian saldo. Saldo akan disesuaikan menjadi sama dengan nominal pengeluaran. Lihat flow penyesuaian saldo.
    2. Jurnal untuk mencatat pengeluaran/transfer seperti biasa.

## IMPROVEMENT 2
  - **Deskripsi**: Menambah halaman grid dompet yang sudah diarsipkan. Halaman ini bertujuan untuk memulihkan dompet yang sudah diarsipkan.
  - **Aktual**: belum ada halaman grid dompet diarsipkan
  - **Ekspektasi**: terdapat halaman grid yang diarsipkan. halaman ini sama dengan halaman grid dompet yang aktif. saat card ditap juga akan redirect ke halaman detail dompet

## IMPROVEMENT 3
  - **Deskripsi**: Menambah halaman list kategori pemasukan dan pengeluaran yang sudah diarsipkan. Halaman ini bertujuan untuk memulihkan kategori yang sudah diarsipkan.
  - **Aktual**: belum ada halaman list kategori diarsipkan
  - **Ekspektasi**: terdapat halaman list kategori yang diarsipkan. halaman ini sama dengan halaman list kategori yang aktif. list item bisa bisa digeser untuk memunculkan tombol pulihkan, sama seperti di list kategori yang section "Kategori Saya"

## IMPROVEMENT 4
  - **Deskripsi**: Perubahan logika bisnis penyesuaian saldo dengan nominal sama dengan saldo sekarang.
  - **Aktual**: Penyesuaian saldo berhasil disimpan, jurnal adjustment dibuat dengan selisih 0
  - **Ekspektasi**: Penyesuaian saldo tidak dilakukan, saat user tekan simpan, akan dikembalikan ke halaman detail dompet dengan menampilkan snackbar dengan warna primary dan bertulisan kurang lebih "Tidak ada perubahan saldo"

## IMPROVEMENT 5
  - **Deskripsi**: riset terkait pemindahan toast/notifikasi/snackbar untuk semua snackbar di aplikasi ini ke bagian atas halaman.
  - **Requirement**:
    - posisi feedback notifikasi berada di atas
    - background dibuat sama untuk semua jenis notifikasi (info/success/error)
    - pembeda untuk jenis notifikasi ada pada warna teks nya
    - gunakan warna yang berbeda dengan warna background aplikasi, atau tambahkan sedikit shadow sehingga bisa membedakannya dari konten di bawahnya

## IMPROVEMENT 6
  - **Deksripsi**: pada halaman form untuk tarik dana target dan juga belanja dana target, bisa ditambahkan alokasi yang terkumpul sekarang, supaya user bisa tahu berapa maksimal nominal yang bisa mereka masukkan
  - **Ekspektasi**: terdapat informasi dengan nada santai dan tidak terlalu mencolok terkait kondisi saldo pada target sekarang
  - **Aktual**: belum terdapat informasi

## IMPROVEMENT 7
  - **Deskripsi**: perubahan logika bisnis terkait fitur "Belanja" pada Target
  - **Ekspektasi**: saldo dari target tidak bisa digunakan untuk pencatatan pengeluaran apapun, sehingga fitur belanja tidak relevan. Jika user mau melakukan pencatatan pengeluaran, maka mereka harus melakukan penarikan saldo ke dompet yang dituju sebelum pencatatan pengeluaran
  - **Aktual**: saldo pada target bisa digunakan untuk mencatat pengeluaran
  - **Diskusi**: Jika kamu merasa ekspektasi dari logika baru tersebut terlalu ketat, bagaimana jika saat "Belanja" dari target, user diminta untuk memilih dari dompet mana mereka melakukan pembayaran? Jika hal ini disetujui, maka ada beberapa poin untuk requirementnya:
    - Belanja dari target akan melakukan 2x jurnal dengan banyak entry
    - jurnal pertama adalah jurnal penarika. debit dompet dan credit target
    - jurnal kedua adalah jurnal pengeluaran. debit expense dan credit dompet
    - kategori pada form belanja dibuat opsional, jika kosong maka akan fallback ke kategori "Lain-Lain"
    - secara ringkas, aksi Belanja ini adalah gabungan dari aksi tarik saldo + transaksi pengeluaran

## IMPROVEMENT 8
  - **Deskripsi**: mengelola dan mengatasi anggaran yang kategorinya diarsipkan oleh user
  - **Syarat**: terdapat kategori Hobi dan anggaran untuk kategori Hobi yang sedang aktif
  - **Requirement**:
    - kategori Hobi bisa dihapus kapan saja
    - anggaran yang masih aktif untuk kategori hobi masih tetap aktif
    - pada list anggaran aktif dan di detail anggaran hobi, beri keterangan bahwa kategori hobi sudah diarsipkan
    - pada samping keterangan itu, beri icon (i) dan jika ditap akan membuka modal informasi bahwa kategori hobi sudah diarsipkan, sehingga anggaran sudah tidak mungkin bisa dilacak lagi
    - sesuaikan wording informasinya dengan tone dompet yang kalem

## IMPROVEMENT 9
  - **Deskripsi**: halaman list rencana anggaran
  - **Ekspektasi**: Perlu penambahan list rencana anggaran untuk mempermudah pengelolaan rencana
  - **Diskusi**: Coba riset berdasarkan konteks kode sekarang, di mana baiknya meletakkan navigasi untuk membuka rencana anggaran. bagaimana jika diletakkan di actions pada AppBar di halaman anggaran, mungkin bentuknya hanya tombol icon saja?
