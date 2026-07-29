import 'package:dompet_app/core/models/account_icon_option.dart';
import 'package:flutter/material.dart';

final List<AccountIconOption> incomeCategoryIconOptions = accountIconOptions
    .where((option) => option.type == .income)
    .toList();

final List<AccountIconOption> expenseCategoryIconOptions = accountIconOptions
    .where((option) => option.type == .expense)
    .toList();

AccountIconOption? categoryIconOptionFromCode({int? iconCode}) {
  return accountIconOptions
      .where((option) => option.icon.codePoint == iconCode)
      .firstOrNull;
}

const List<AccountIconOption> accountIconOptions = [
  AccountIconOption(
    icon: Icons.work_rounded,
    type: .income,
    keywords: [
      'kerja',
      'pekerjaan',
      'gaji',
      'kantor',
      'profesi',
      'salary',
      'income',
      'job',
      'work',
    ],
  ),

  AccountIconOption(
    icon: Icons.storefront_rounded,
    type: .income,
    keywords: [
      'usaha',
      'bisnis',
      'toko',
      'dagang',
      'jualan',
      'freelance',
      'store',
      'shop',
      'business',
    ],
  ),

  AccountIconOption(
    icon: Icons.paid_rounded,
    type: .income,
    keywords: [
      'uang',
      'bayaran',
      'pendapatan',
      'keuntungan',
      'profit',
      'income',
      'paid',
      'money',
    ],
  ),

  AccountIconOption(
    icon: Icons.payments_rounded,
    type: .income,
    keywords: [
      'uang',
      'dana',
      'cash',
      'pendapatan',
      'pembayaran',
      'money',
      'payment',
    ],
  ),

  AccountIconOption(
    icon: Icons.monetization_on_rounded,
    type: .income,
    keywords: [
      'bonus',
      'insentif',
      'reward',
      'uang',
      'pendapatan',
      'income',
      'money',
    ],
  ),

  AccountIconOption(
    icon: Icons.card_giftcard_rounded,
    type: .income,
    keywords: ['hadiah', 'gift', 'reward', 'bonus', 'kado', 'pemberian'],
  ),

  AccountIconOption(
    icon: Icons.sell_rounded,
    type: .income,
    keywords: [
      'jual',
      'penjualan',
      'sales',
      'produk',
      'barang',
      'dagangan',
      'sell',
    ],
  ),

  AccountIconOption(
    icon: Icons.shopping_bag_rounded,
    type: .income,
    keywords: [
      'belanja',
      'shopping',
      'toko',
      'produk',
      'barang',
      'retail',
      'penjualan',
    ],
  ),

  AccountIconOption(
    icon: Icons.account_balance_rounded,
    type: .income,
    keywords: [
      'bank',
      'tabungan',
      'deposito',
      'dividen',
      'rekening',
      'finance',
      'banking',
    ],
  ),

  AccountIconOption(
    icon: Icons.savings_rounded,
    type: .income,
    keywords: ['tabungan', 'saving', 'simpanan', 'deposit', 'uang', 'bank'],
  ),

  AccountIconOption(
    icon: Icons.trending_up_rounded,
    type: .income,
    keywords: [
      'investasi',
      'profit',
      'keuntungan',
      'saham',
      'naik',
      'growth',
      'investment',
    ],
  ),

  AccountIconOption(
    icon: Icons.assignment_rounded,
    type: .income,
    keywords: [
      'proyek',
      'project',
      'kontrak',
      'tugas',
      'freelance',
      'pekerjaan',
    ],
  ),

  AccountIconOption(
    icon: Icons.groups_rounded,
    type: .income,
    keywords: [
      'komunitas',
      'crowdfunding',
      'tim',
      'kelompok',
      'group',
      'community',
    ],
  ),

  AccountIconOption(
    icon: Icons.replay_rounded,
    type: .income,
    keywords: [
      'refund',
      'pengembalian',
      'retur',
      'kembali',
      'cashback',
      'return',
    ],
  ),

  AccountIconOption(
    icon: Icons.south_west_rounded,
    type: .income,
    keywords: [
      'masuk',
      'transfer masuk',
      'income',
      'receive',
      'deposit',
      'uang masuk',
    ],
  ),

  // =========================
  // EXPENSE
  // =========================
  AccountIconOption(
    icon: Icons.restaurant_rounded,
    type: .expense,
    keywords: [
      'makan',
      'minum',
      'kuliner',
      'restoran',
      'food',
      'drink',
      'meal',
    ],
  ),

  AccountIconOption(
    icon: Icons.shopping_cart_rounded,
    type: .expense,
    keywords: [
      'belanja',
      'shopping',
      'groceries',
      'kebutuhan',
      'market',
      'supermarket',
    ],
  ),

  AccountIconOption(
    icon: Icons.directions_car_rounded,
    type: .expense,
    keywords: ['mobil', 'kendaraan', 'transportasi', 'car', 'vehicle'],
  ),

  AccountIconOption(
    icon: Icons.two_wheeler_rounded,
    type: .expense,
    keywords: ['motor', 'sepeda motor', 'bike', 'motorbike', 'transportasi'],
  ),

  AccountIconOption(
    icon: Icons.local_gas_station_rounded,
    type: .expense,
    keywords: [
      'bbm',
      'bensin',
      'solar',
      'fuel',
      'gas',
      'pertalite',
      'pertamax',
    ],
  ),

  AccountIconOption(
    icon: Icons.train_rounded,
    type: .expense,
    keywords: ['kereta', 'train', 'commuter', 'transportasi', 'travel'],
  ),

  AccountIconOption(
    icon: Icons.flight_rounded,
    type: .expense,
    keywords: ['pesawat', 'flight', 'airplane', 'travel', 'liburan'],
  ),

  AccountIconOption(
    icon: Icons.house_rounded,
    type: .expense,
    keywords: ['rumah', 'tempat tinggal', 'hunian', 'house', 'home'],
  ),

  AccountIconOption(
    icon: Icons.home_work_rounded,
    type: .expense,
    keywords: ['sewa', 'kpr', 'properti', 'rumah', 'property', 'housing'],
  ),

  AccountIconOption(
    icon: Icons.bolt_rounded,
    type: .expense,
    keywords: ['listrik', 'electricity', 'power', 'pln', 'tagihan'],
  ),

  AccountIconOption(
    icon: Icons.wifi_rounded,
    type: .expense,
    keywords: ['internet', 'wifi', 'broadband', 'network', 'tagihan'],
  ),

  AccountIconOption(
    icon: Icons.call_rounded,
    type: .expense,
    keywords: ['telepon', 'pulsa', 'call', 'phone', 'komunikasi'],
  ),

  AccountIconOption(
    icon: Icons.receipt_long_rounded,
    type: .expense,
    keywords: ['tagihan', 'bill', 'invoice', 'struk', 'pembayaran'],
  ),

  AccountIconOption(
    icon: Icons.medical_services_rounded,
    type: .expense,
    keywords: ['kesehatan', 'klinik', 'dokter', 'medical', 'healthcare'],
  ),

  AccountIconOption(
    icon: Icons.medication_rounded,
    type: .expense,
    keywords: ['obat', 'medicine', 'apotek', 'pharmacy', 'kesehatan'],
  ),

  AccountIconOption(
    icon: Icons.school_rounded,
    type: .expense,
    keywords: ['pendidikan', 'sekolah', 'education', 'kuliah', 'belajar'],
  ),

  AccountIconOption(
    icon: Icons.menu_book_rounded,
    type: .expense,
    keywords: ['buku', 'kursus', 'ebook', 'belajar', 'study', 'course'],
  ),

  AccountIconOption(
    icon: Icons.movie_rounded,
    type: .expense,
    keywords: ['film', 'bioskop', 'movie', 'cinema', 'hiburan'],
  ),

  AccountIconOption(
    icon: Icons.music_note_rounded,
    type: .expense,
    keywords: ['musik', 'music', 'lagu', 'audio', 'hiburan'],
  ),

  AccountIconOption(
    icon: Icons.sports_esports_rounded,
    type: .expense,
    keywords: ['game', 'gaming', 'esports', 'hiburan', 'main'],
  ),

  AccountIconOption(
    icon: Icons.live_tv_rounded,
    type: .expense,
    keywords: ['streaming', 'netflix', 'youtube', 'tv', 'langganan'],
  ),

  AccountIconOption(
    icon: Icons.beach_access_rounded,
    type: .expense,
    keywords: ['liburan', 'travel', 'wisata', 'vacation', 'holiday'],
  ),

  AccountIconOption(
    icon: Icons.checkroom_rounded,
    type: .expense,
    keywords: ['pakaian', 'baju', 'fashion', 'clothes', 'apparel'],
  ),

  AccountIconOption(
    icon: Icons.smartphone_rounded,
    type: .expense,
    keywords: ['hp', 'ponsel', 'smartphone', 'gadget', 'android', 'iphone'],
  ),

  AccountIconOption(
    icon: Icons.devices_rounded,
    type: .expense,
    keywords: ['elektronik', 'device', 'komputer', 'laptop', 'teknologi'],
  ),

  AccountIconOption(
    icon: Icons.volunteer_activism_rounded,
    type: .expense,
    keywords: ['donasi', 'amal', 'sosial', 'charity', 'sedekah', 'zakat'],
  ),

  AccountIconOption(
    icon: Icons.family_restroom_rounded,
    type: .expense,
    keywords: ['keluarga', 'family', 'orang tua', 'anak', 'rumah tangga'],
  ),

  AccountIconOption(
    icon: Icons.child_care_rounded,
    type: .expense,
    keywords: ['anak', 'bayi', 'child', 'baby', 'parenting'],
  ),

  AccountIconOption(
    icon: Icons.pets_rounded,
    type: .expense,
    keywords: ['hewan', 'peliharaan', 'pet', 'kucing', 'anjing'],
  ),

  AccountIconOption(
    icon: Icons.fitness_center_rounded,
    type: .expense,
    keywords: ['olahraga', 'gym', 'fitness', 'workout', 'kesehatan'],
  ),

  AccountIconOption(
    icon: Icons.spa_rounded,
    type: .expense,
    keywords: ['spa', 'relaksasi', 'wellness', 'perawatan', 'kecantikan'],
  ),

  AccountIconOption(
    icon: Icons.gavel_rounded,
    type: .expense,
    keywords: ['pajak', 'tax', 'legal', 'hukum', 'pemerintah'],
  ),

  AccountIconOption(
    icon: Icons.credit_card_rounded,
    type: .expense,
    keywords: ['kartu kredit', 'cicilan', 'card', 'credit', 'utang'],
  ),

  AccountIconOption(
    icon: Icons.account_balance_wallet_rounded,
    type: .expense,
    keywords: ['biaya admin', 'wallet', 'saldo', 'rekening', 'keuangan'],
  ),

  AccountIconOption(
    icon: Icons.request_quote_rounded,
    type: .expense,
    keywords: ['utang', 'pinjaman', 'loan', 'debt', 'cicilan'],
  ),

  AccountIconOption(
    icon: Icons.construction_rounded,
    type: .expense,
    keywords: ['renovasi', 'perbaikan', 'alat', 'bangunan', 'construction'],
  ),

  AccountIconOption(
    icon: Icons.chair_rounded,
    type: .expense,
    keywords: ['furnitur', 'mebel', 'kursi', 'rumah', 'furniture'],
  ),

  AccountIconOption(
    icon: Icons.local_laundry_service_rounded,
    type: .expense,
    keywords: ['laundry', 'cuci', 'pakaian', 'kebersihan'],
  ),

  AccountIconOption(
    icon: Icons.water_drop_rounded,
    type: .expense,
    keywords: ['air', 'pdam', 'minum', 'water', 'tagihan'],
  ),

  AccountIconOption(
    icon: Icons.north_east_rounded,
    type: .expense,
    keywords: [
      'keluar',
      'transfer keluar',
      'expense',
      'send',
      'withdraw',
      'uang keluar',
    ],
  ),
];
