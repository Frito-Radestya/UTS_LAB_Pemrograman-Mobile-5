import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/question.dart';

/// Soal kategori "Flutter Dasar".
const List<Question> flutterQuestions = [
  Question(
    text: 'Bahasa pemrograman yang digunakan Flutter adalah...',
    options: ['Kotlin', 'Dart', 'Swift', 'JavaScript'],
    correctIndex: 1,
  ),
  Question(
    text: 'Widget yang tampilannya tidak berubah setelah dibuat disebut...',
    options: [
      'StatefulWidget',
      'InheritedWidget',
      'StatelessWidget',
      'StatefulBuilder',
    ],
    correctIndex: 2,
  ),
  Question(
    text: 'Method yang dipanggil untuk memperbarui tampilan pada StatefulWidget adalah...',
    options: ['setState()', 'build()', 'update()', 'refresh()'],
    correctIndex: 0,
  ),
  Question(
    text: 'File yang digunakan untuk mendaftarkan aset dan font di Flutter adalah...',
    options: [
      'main.dart',
      'pubspec.yaml',
      'AndroidManifest.xml',
      'analysis_options.yaml',
    ],
    correctIndex: 1,
  ),
  Question(
    text: 'Widget yang menyusun anak-anaknya secara vertikal adalah...',
    options: ['Row', 'Stack', 'Column', 'ListView.horizontal'],
    correctIndex: 2,
  ),
  Question(
    text: 'Class yang dipakai untuk mendapatkan ukuran layar adalah...',
    options: ['MediaQuery', 'Navigator', 'Theme', 'Scaffold'],
    correctIndex: 0,
  ),
  Question(
    text: 'Perintah untuk menjalankan aplikasi Flutter adalah...',
    options: [
      'flutter build',
      'flutter run',
      'flutter start',
      'flutter launch',
    ],
    correctIndex: 1,
  ),
  Question(
    text: 'Widget yang menumpuk anak-anaknya satu di atas yang lain adalah...',
    options: ['Column', 'Row', 'Stack', 'Wrap'],
    correctIndex: 2,
  ),
  Question(
    text: 'Method untuk berpindah ke halaman baru adalah...',
    options: [
      'Navigator.push()',
      'Navigator.pop()',
      'Navigator.exit()',
      'Navigator.open()',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'Paket yang umum dipakai untuk state management sederhana adalah...',
    options: ['http', 'provider', 'path', 'intl'],
    correctIndex: 1,
  ),
];

/// Soal kategori "Dart & Pemrograman".
const List<Question> dartQuestions = [
  Question(
    text: 'Tipe data untuk bilangan bulat di Dart adalah...',
    options: ['double', 'String', 'int', 'bool'],
    correctIndex: 2,
  ),
  Question(
    text: 'Kata kunci untuk variabel yang hanya boleh diberi nilai satu kali adalah...',
    options: ['var', 'final', 'dynamic', 'late'],
    correctIndex: 1,
  ),
  Question(
    text: 'Simbol untuk komentar satu baris di Dart adalah...',
    options: ['//', '/* */', '#', '--'],
    correctIndex: 0,
  ),
  Question(
    text: 'Bagian class yang dipanggil saat objek dibuat adalah...',
    options: ['destructor', 'main', 'initState', 'constructor'],
    correctIndex: 3,
  ),
  Question(
    text: 'Operator untuk memeriksa apakah dua nilai sama adalah...',
    options: ['=', '==', '!=', '=>'],
    correctIndex: 1,
  ),
  Question(
    text: 'Tipe data Dart yang menyimpan pasangan key-value adalah...',
    options: ['List', 'Set', 'Map', 'Queue'],
    correctIndex: 2,
  ),
  Question(
    text: 'Perulangan yang minimal dijalankan satu kali adalah...',
    options: ['for', 'while', 'for-in', 'do-while'],
    correctIndex: 3,
  ),
  Question(
    text: 'Tipe data untuk nilai benar atau salah adalah...',
    options: ['bool', 'int', 'String', 'double'],
    correctIndex: 0,
  ),
  Question(
    text: 'Method List untuk menambah elemen di akhir adalah...',
    options: ['push()', 'append()', 'add()', 'insertLast()'],
    correctIndex: 2,
  ),
  Question(
    text: 'Kata kunci untuk membuat class turunan adalah...',
    options: ['implements', 'extends', 'with', 'override'],
    correctIndex: 1,
  ),
];

/// Soal kategori "Sains".
const List<Question> sainsQuestions = [
  Question(
    text: 'Planet yang dikenal sebagai Planet Merah adalah...',
    options: ['Venus', 'Mars', 'Jupiter', 'Merkurius'],
    correctIndex: 1,
  ),
  Question(
    text: 'Rumus kimia air adalah...',
    options: ['CO2', 'NaCl', 'H2O', 'O2'],
    correctIndex: 2,
  ),
  Question(
    text: 'Pusat tata surya kita adalah...',
    options: ['Bumi', 'Bulan', 'Matahari', 'Mars'],
    correctIndex: 2,
  ),
  Question(
    text: 'Gas yang digunakan manusia untuk bernapas adalah...',
    options: ['Nitrogen', 'Karbon dioksida', 'Hidrogen', 'Oksigen'],
    correctIndex: 3,
  ),
  Question(
    text: 'Proses tumbuhan membuat makanan dengan bantuan cahaya disebut...',
    options: ['Respirasi', 'Fotosintesis', 'Fermentasi', 'Transpirasi'],
    correctIndex: 1,
  ),
  Question(
    text: 'Organ tubuh yang memompa darah adalah...',
    options: ['Paru-paru', 'Hati', 'Jantung', 'Ginjal'],
    correctIndex: 2,
  ),
  Question(
    text: 'Partikel atom yang bermuatan negatif disebut...',
    options: ['Proton', 'Neutron', 'Elektron', 'Inti'],
    correctIndex: 2,
  ),
  Question(
    text: 'Pada tekanan 1 atmosfer, air mendidih pada suhu...',
    options: ['0°C', '50°C', '100°C', '212°C'],
    correctIndex: 2,
  ),
  Question(
    text: 'Cahaya merambat lebih cepat daripada...',
    options: ['Gelombang radio', 'Suara', 'Sinar X', 'Sinar gamma'],
    correctIndex: 1,
  ),
  Question(
    text: 'Satuan SI untuk suhu adalah...',
    options: ['Celsius', 'Fahrenheit', 'Kelvin', 'Reamur'],
    correctIndex: 2,
  ),
];

/// Soal kategori "Teknologi".
const List<Question> teknologiQuestions = [
  Question(
    text: 'Bagian komputer yang disebut "otak" pemroses adalah...',
    options: ['RAM', 'CPU', 'GPU', 'SSD'],
    correctIndex: 1,
  ),
  Question(
    text: 'Jaringan global yang menghubungkan komputer di seluruh dunia adalah...',
    options: ['Intranet', 'Bluetooth', 'Internet', 'LAN'],
    correctIndex: 2,
  ),
  Question(
    text: 'Sistem operasi ponsel yang dikembangkan Google bernama...',
    options: ['iOS', 'Windows', 'Android', 'Linux'],
    correctIndex: 2,
  ),
  Question(
    text: 'Satuan penyimpanan data terkecil adalah...',
    options: ['Byte', 'Bit', 'Kilobyte', 'Megabyte'],
    correctIndex: 1,
  ),
  Question(
    text: 'Perangkat yang dipakai untuk mengetik teks adalah...',
    options: ['Monitor', 'Speaker', 'Keyboard', 'Printer'],
    correctIndex: 2,
  ),
  Question(
    text: 'Alamat halaman situs web biasanya disebut...',
    options: ['IP', 'URL', 'DNS', 'HTML'],
    correctIndex: 1,
  ),
  Question(
    text: 'Penyimpanan data melalui internet sering disebut...',
    options: ['Cache', 'Cloud', 'Cookie', 'Buffer'],
    correctIndex: 1,
  ),
  Question(
    text: 'Program untuk membuka halaman web disebut...',
    options: ['Compiler', 'Browser', 'Server', 'Editor'],
    correctIndex: 1,
  ),
  Question(
    text: 'Perangkat yang menampilkan gambar dari komputer adalah...',
    options: ['Mouse', 'Monitor', 'Router', 'Modem'],
    correctIndex: 1,
  ),
  Question(
    text: 'Kode rahasia untuk masuk ke akun disebut...',
    options: ['Username', 'Password', 'Cache', 'Token publik'],
    correctIndex: 1,
  ),
];

/// Soal kategori "Sejarah".
const List<Question> sejarahQuestions = [
  Question(
    text: 'Proklamasi Kemerdekaan Indonesia dibacakan pada...',
    options: [
      '17 Agustus 1945',
      '1 Juni 1945',
      '10 November 1945',
      '28 Oktober 1928',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'Presiden pertama Republik Indonesia adalah...',
    options: ['Soeharto', 'Soekarno', 'Hatta', 'Habibie'],
    correctIndex: 1,
  ),
  Question(
    text: 'Candi Buddha terbesar di Magelang bernama...',
    options: ['Prambanan', 'Mendut', 'Borobudur', 'Sewu'],
    correctIndex: 2,
  ),
  Question(
    text: 'Piramida Giza berada di negara...',
    options: ['Irak', 'Mesir', 'Yunani', 'Meksiko'],
    correctIndex: 1,
  ),
  Question(
    text: 'Kerajaan maritim besar di Sumatera pada abad ke-7 adalah...',
    options: ['Majapahit', 'Mataram', 'Sriwijaya', 'Tarumanegara'],
    correctIndex: 2,
  ),
  Question(
    text: 'Perang Dunia II berakhir pada tahun...',
    options: ['1939', '1942', '1945', '1950'],
    correctIndex: 2,
  ),
  Question(
    text: 'Naskah Proklamasi diketik oleh...',
    options: ['Soekarno', 'Mohammad Hatta', 'Sayuti Melik', 'Ahmad Soebardjo'],
    correctIndex: 2,
  ),
  Question(
    text: 'Ibukota Indonesia saat ini adalah...',
    options: ['Bandung', 'Surabaya', 'Yogyakarta', 'Jakarta'],
    correctIndex: 3,
  ),
  Question(
    text: 'Tembok besar yang terkenal di Asia Timur berada di...',
    options: ['Jepang', 'Tiongkok', 'Korea', 'Mongolia'],
    correctIndex: 1,
  ),
  Question(
    text: 'Sumpah Pemuda diikrarkan pada...',
    options: [
      '17 Agustus 1945',
      '28 Oktober 1928',
      '20 Mei 1908',
      '10 November 1945',
    ],
    correctIndex: 1,
  ),
];

/// Soal kategori "Logika".
const List<Question> logikaQuestions = [
  Question(
    text: 'Pola 2, 4, 8, 16, ... angka berikutnya adalah...',
    options: ['18', '20', '24', '32'],
    correctIndex: 3,
  ),
  Question(
    text: 'Hasil dari 5 + 3 × 2 adalah...',
    options: ['16', '11', '13', '10'],
    correctIndex: 1,
  ),
  Question(
    text: 'Sebuah segitiga memiliki jumlah sisi...',
    options: ['2', '3', '4', '5'],
    correctIndex: 1,
  ),
  Question(
    text: 'Jika hari ini Senin, dua hari kemudian adalah...',
    options: ['Selasa', 'Rabu', 'Kamis', 'Minggu'],
    correctIndex: 1,
  ),
  Question(
    text: 'Jika A lebih besar dari B dan B lebih besar dari C, maka...',
    options: [
      'A lebih kecil dari C',
      'A sama dengan C',
      'A lebih besar dari C',
      'Tidak dapat disimpulkan',
    ],
    correctIndex: 2,
  ),
  Question(
    text: 'Semua burung dapat terbang. Pernyataan ini...',
    options: [
      'Selalu benar',
      'Tidak selalu benar',
      'Tidak pernah benar',
      'Tidak masuk akal',
    ],
    correctIndex: 1,
  ),
  Question(
    text: 'Urutan waktu yang benar adalah...',
    options: [
      'Siang, pagi, malam, sore',
      'Pagi, siang, sore, malam',
      'Malam, siang, pagi, sore',
      'Sore, pagi, malam, siang',
    ],
    correctIndex: 1,
  ),
  Question(
    text: 'Angka ganjil di antara 8, 11, 14, dan 20 adalah...',
    options: ['8', '11', '14', '20'],
    correctIndex: 1,
  ),
  Question(
    text: 'Kebalikan dari kata "benar" adalah...',
    options: ['Tepat', 'Yakin', 'Salah', 'Jelas'],
    correctIndex: 2,
  ),
  Question(
    text: 'Jika semua mawar adalah bunga, dan ini adalah mawar, maka ini adalah...',
    options: ['Pohon', 'Bunga', 'Daun', 'Akar'],
    correctIndex: 1,
  ),
];

/// Soal kategori "Pengetahuan Umum".
const List<Question> umumQuestions = [
  Question(
    text: 'Ibukota Jepang adalah...',
    options: ['Osaka', 'Kyoto', 'Tokyo', 'Nagoya'],
    correctIndex: 2,
  ),
  Question(
    text: 'Benua terluas di Bumi adalah...',
    options: ['Afrika', 'Amerika', 'Eropa', 'Asia'],
    correctIndex: 3,
  ),
  Question(
    text: 'Mata uang resmi Indonesia adalah...',
    options: ['Ringgit', 'Rupiah', 'Yen', 'Baht'],
    correctIndex: 1,
  ),
  Question(
    text: 'Matahari terbit di arah...',
    options: ['Barat', 'Utara', 'Timur', 'Selatan'],
    correctIndex: 2,
  ),
  Question(
    text: 'Bahasa resmi negara Indonesia adalah...',
    options: ['Jawa', 'Inggris', 'Melayu', 'Bahasa Indonesia'],
    correctIndex: 3,
  ),
  Question(
    text: 'Planet terdekat dengan Matahari adalah...',
    options: ['Venus', 'Bumi', 'Merkurius', 'Mars'],
    correctIndex: 2,
  ),
  Question(
    text: 'Jumlah hari pada tahun biasa adalah...',
    options: ['364', '365', '366', '360'],
    correctIndex: 1,
  ),
  Question(
    text: 'Alat yang dipakai untuk mengukur waktu adalah...',
    options: ['Penggaris', 'Timbangan', 'Jam', 'Kompas'],
    correctIndex: 2,
  ),
  Question(
    text: 'Selat yang memisahkan Pulau Jawa dan Sumatera adalah...',
    options: ['Selat Malaka', 'Selat Sunda', 'Selat Bali', 'Selat Lombok'],
    correctIndex: 1,
  ),
  Question(
    text: 'Bendera Indonesia terdiri dari warna...',
    options: [
      'Merah dan putih',
      'Merah dan kuning',
      'Putih dan biru',
      'Hijau dan putih',
    ],
    correctIndex: 0,
  ),
];

/// Kategori kuis dummy yang dipakai aplikasi.
const List<Category> quizCategories = [
  Category(
    id: 'flutter-dasar',
    title: 'Flutter Dasar',
    description: 'Widget, layout, dan alur dasar aplikasi Flutter.',
    icon: Icons.phone_android_rounded,
    imageAsset: 'assets/images/categories/category_flutter.jpg',
    questions: flutterQuestions,
  ),
  Category(
    id: 'dart-pemrograman',
    title: 'Dart & Pemrograman',
    description: 'Tipe data, fungsi, dan logika dasar bahasa Dart.',
    icon: Icons.code_rounded,
    imageAsset: 'assets/images/categories/category_dart.jpg',
    questions: dartQuestions,
  ),
  Category(
    id: 'sains',
    title: 'Sains',
    description: 'Menjelajahi alam, energi, dan fenomena ilmiah.',
    icon: Icons.science_rounded,
    imageAsset: 'assets/images/categories/category_science.jpg',
    questions: sainsQuestions,
  ),
  Category(
    id: 'teknologi',
    title: 'Teknologi',
    description: 'Mengenal komputer, pemrograman, dan inovasi digital.',
    icon: Icons.memory_rounded,
    imageAsset: 'assets/images/categories/category_technology.jpg',
    questions: teknologiQuestions,
  ),
  Category(
    id: 'sejarah',
    title: 'Sejarah',
    description: 'Menelusuri peristiwa dan peradaban masa lalu.',
    icon: Icons.account_balance_rounded,
    imageAsset: 'assets/images/categories/category_history.jpg',
    questions: sejarahQuestions,
  ),
  Category(
    id: 'logika',
    title: 'Logika',
    description: 'Melatih penalaran dan kemampuan memecahkan masalah.',
    icon: Icons.extension_rounded,
    imageAsset: 'assets/images/categories/category_logic.jpg',
    questions: logikaQuestions,
  ),
  Category(
    id: 'pengetahuan-umum',
    title: 'Pengetahuan Umum',
    description: 'Memperluas wawasan dari berbagai bidang.',
    icon: Icons.public_rounded,
    imageAsset: 'assets/images/categories/category_general.jpg',
    questions: umumQuestions,
  ),
];
