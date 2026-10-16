import 'package:flutter/material.dart';

import '../models/quiz_models.dart';

final List<QuizCategory> quizCategories = List.unmodifiable([
  QuizCategory(
    id: 'flutter-dart',
    title: 'Flutter & Dart',
    subtitle: 'Widget, state, dan dasar bahasa Dart',
    icon: Icons.flutter_dash,
    difficulty: 'Mudah',
    estimatedMinutes: 8,
    questions: [
      QuizQuestion(
        prompt: 'Widget apa yang menyusun anak-anaknya secara vertikal?',
        options: ['Row', 'Stack', 'Column', 'Wrap'],
        correctIndex: 2,
        explanation:
            'Column menyusun anak dari atas ke bawah pada sumbu utama.',
      ),
      QuizQuestion(
        prompt: 'Apa keluaran kode Dart berikut?',
        code: 'final angka = [2, 4, 6];\nprint(angka.map((n) => n ~/ 2).toList());',
        options: ['[1, 2, 3]', '[2, 4, 6]', '[1.0, 2.0, 3.0]', '[4, 8, 12]'],
        correctIndex: 0,
        explanation: 'Operator ~/ membagi dan menghasilkan bilangan bulat.',
      ),
      QuizQuestion(
        prompt: 'Apa arti tipe String? dalam Dart dengan null safety?',
        options: [
          'String wajib kosong',
          'String yang tidak bisa berubah',
          'Daftar String',
          'String yang boleh bernilai null',
        ],
        correctIndex: 3,
        explanation: 'Tanda ? mengizinkan sebuah tipe memiliki nilai null.',
      ),
      QuizQuestion(
        prompt: 'Kapan setState digunakan pada State sebuah StatefulWidget?',
        options: [
          'Untuk memasang paket',
          'Saat perubahan state perlu ditampilkan ulang',
          'Untuk menghapus semua widget',
          'Hanya saat aplikasi ditutup',
        ],
        correctIndex: 1,
        explanation:
            'setState menandai State agar framework menjadwalkan build ulang.',
      ),
      QuizQuestion(
        prompt: 'Apa kegunaan await pada operasi Future?',
        options: [
          'Mengubah Future menjadi Stream',
          'Memblokir seluruh UI sampai selesai',
          'Menunggu hasil secara asinkron dalam fungsi async',
          'Menjalankan fungsi tanpa menunggu hasil',
        ],
        correctIndex: 2,
        explanation:
            'await menangguhkan fungsi async, bukan memblokir event loop UI.',
      ),
      QuizQuestion(
        prompt: 'Apa perbedaan utama final dan const?',
        options: [
          'final diisi sekali; const harus bernilai konstan saat kompilasi',
          'final hanya untuk angka',
          'const dapat diisi ulang',
          'Keduanya selalu dievaluasi saat runtime',
        ],
        correctIndex: 0,
        explanation: 'final dapat menerima nilai runtime, sedangkan const memerlukan konstanta kompilasi.',
      ),
      QuizQuestion(
        prompt: 'Apa yang dihasilkan ekspresi berikut?',
        code: 'String? nama;\nfinal sapaan = nama ?? "Tamu";',
        options: ['null', 'Error kompilasi', 'String kosong', 'Tamu'],
        correctIndex: 3,
        explanation:
            'Operator ?? menggunakan nilai kanan ketika nilai kiri null.',
      ),
      QuizQuestion(
        prompt: 'Widget mana yang membuat isi dapat digulir sebagai daftar?',
        options: ['Padding', 'ListView', 'Center', 'SizedBox'],
        correctIndex: 1,
        explanation: 'ListView menampilkan daftar anak yang dapat digulir.',
      ),
    ],
  ),
  QuizCategory(
    id: 'algoritma',
    title: 'Algoritma Pemrograman',
    subtitle: 'Struktur data, pencarian, dan kompleksitas',
    icon: Icons.account_tree_outlined,
    difficulty: 'Sedang',
    estimatedMinutes: 10,
    questions: [
      QuizQuestion(
        prompt: 'Apa syarat utama binary search pada sebuah array?',
        options: [
          'Array harus sudah terurut',
          'Jumlah elemen harus genap',
          'Semua elemen harus unik',
          'Array hanya berisi teks',
        ],
        correctIndex: 0,
        explanation: 'Binary search memanfaatkan urutan untuk membuang separuh ruang pencarian.',
      ),
      QuizQuestion(
        prompt: 'Berapa kompleksitas waktu terburuk pencarian linear pada n elemen?',
        options: ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
        correctIndex: 2,
        explanation: 'Pada kasus terburuk, setiap elemen diperiksa satu kali.',
      ),
      QuizQuestion(
        prompt: 'Struktur data apa yang mengikuti prinsip FIFO?',
        options: ['Stack', 'Queue', 'Tree', 'Set'],
        correctIndex: 1,
        explanation:
            'Queue mengeluarkan elemen yang pertama masuk terlebih dahulu.',
      ),
      QuizQuestion(
        prompt: 'Berapa nilai hasil setelah perulangan ini?',
        code:
            'hasil = 0\nfor i = 1 sampai 4 (inklusif):\n    hasil = hasil + i',
        options: ['4', '6', '24', '10'],
        correctIndex: 3,
        explanation: 'Penjumlahan 1 + 2 + 3 + 4 menghasilkan 10.',
      ),
      QuizQuestion(
        prompt: 'Apa fungsi base case pada rekursi?',
        options: [
          'Menghentikan pemanggilan rekursif pada kondisi tertentu',
          'Membuat rekursi selalu lebih cepat',
          'Mengurutkan argumen fungsi',
          'Menggandakan setiap pemanggilan',
        ],
        correctIndex: 0,
        explanation: 'Base case menghentikan rekursi agar tidak terus memanggil dirinya sendiri.',
      ),
      QuizQuestion(
        prompt: 'Algoritma mana yang menemukan jalur terpendek berdasarkan jumlah sisi pada graf tanpa bobot?',
        options: [
          'Bubble sort',
          'DFS tanpa modifikasi',
          'BFS',
          'Pencarian linear',
        ],
        correctIndex: 2,
        explanation:
            'BFS mengunjungi simpul per lapisan jarak dari simpul awal.',
      ),
      QuizQuestion(
        prompt: 'Berapa kali pernyataan proses dijalankan?',
        code: 'for i = 1 sampai n:\n    for j = 1 sampai n:\n        proses()',
        options: ['n', 'n × n', '2 × n', 'log n'],
        correctIndex: 1,
        explanation: 'Setiap n iterasi luar menjalankan n iterasi dalam, sehingga total n².',
      ),
      QuizQuestion(
        prompt: 'Apa hasil pop setelah push(A), push(B), push(C) pada stack kosong?',
        options: ['A', 'B', 'Stack kosong', 'C'],
        correctIndex: 3,
        explanation: 'Stack bersifat LIFO: elemen terakhir masuk adalah yang pertama keluar.',
      ),
    ],
  ),
  QuizCategory(
    id: 'basis-data',
    title: 'Basis Data SQL/NoSQL',
    subtitle: 'Query, relasi, transaksi, dan dokumen',
    icon: Icons.storage_rounded,
    difficulty: 'Sedang',
    estimatedMinutes: 10,
    questions: [
      QuizQuestion(
        prompt: 'Klausa SQL apa yang menyaring baris sebelum pengelompokan?',
        options: ['ORDER BY', 'WHERE', 'HAVING', 'GROUP BY'],
        correctIndex: 1,
        explanation:
            'WHERE menyaring baris; HAVING menyaring hasil pengelompokan.',
      ),
      QuizQuestion(
        prompt: 'Apa yang dihitung query berikut?',
        code: 'SELECT COUNT(*) FROM mahasiswa WHERE angkatan = 2024;',
        options: [
          'Jumlah seluruh kolom',
          'Jumlah angkatan berbeda',
          'Jumlah mahasiswa angkatan 2024',
          'Nilai angkatan terbesar',
        ],
        correctIndex: 2,
        explanation: 'COUNT(*) menghitung baris yang lolos kondisi WHERE.',
      ),
      QuizQuestion(
        prompt: 'Apa sifat utama primary key?',
        options: [
          'Unik dan tidak null',
          'Boleh duplikat',
          'Harus bertipe teks',
          'Selalu mengacu ke tabel lain',
        ],
        correctIndex: 0,
        explanation: 'Primary key mengidentifikasi setiap baris secara unik dan tidak boleh null.',
      ),
      QuizQuestion(
        prompt: 'Apa hasil LEFT JOIN jika sebuah baris kiri tidak memiliki pasangan kanan?',
        options: [
          'Baris kiri dihapus',
          'Seluruh query gagal',
          'Baris kanan digandakan',
          'Baris kiri tetap ada dengan kolom kanan null',
        ],
        correctIndex: 3,
        explanation: 'LEFT JOIN mempertahankan semua baris kiri, termasuk yang tidak memiliki pasangan.',
      ),
      QuizQuestion(
        prompt: 'Apa arti atomicity dalam transaksi ACID?',
        options: [
          'Data selalu diurutkan',
          'Semua operasi berhasil bersama atau dibatalkan bersama',
          'Setiap tabel hanya memiliki satu kolom',
          'Transaksi tidak membutuhkan kunci',
        ],
        correctIndex: 1,
        explanation: 'Atomicity menjamin transaksi berlaku seluruhnya atau tidak sama sekali.',
      ),
      QuizQuestion(
        prompt: 'Model data utama MongoDB adalah apa?',
        options: [
          'Graf piksel',
          'Tabel SQL wajib berskema tetap',
          'Dokumen BSON',
          'Berkas CSV saja',
        ],
        correctIndex: 2,
        explanation:
            'MongoDB menyimpan dokumen BSON dengan struktur yang fleksibel.',
      ),
      QuizQuestion(
        prompt: 'Apa trade-off umum penambahan indeks basis data?',
        options: [
          'Pencarian tertentu lebih cepat, tetapi penulisan dan penyimpanan bertambah',
          'Semua operasi pasti lebih cepat',
          'Data tidak lagi memerlukan validasi',
          'Indeks menghapus kebutuhan primary key',
        ],
        correctIndex: 0,
        explanation: 'Indeks mempercepat akses tertentu, tetapi perlu ruang dan pembaruan saat menulis.',
      ),
      QuizQuestion(
        prompt: 'Bagaimana memeriksa nilai null dalam SQL?',
        code: 'SELECT * FROM pengguna WHERE email ...;',
        options: ['= NULL', '== NULL', 'EQUALS NULL', 'IS NULL'],
        correctIndex: 3,
        explanation: 'SQL menggunakan IS NULL karena perbandingan biasa dengan NULL menghasilkan UNKNOWN.',
      ),
    ],
  ),
  QuizCategory(
    id: 'jaringan-keamanan',
    title: 'Jaringan & Keamanan',
    subtitle: 'Protokol, enkripsi, dan keamanan aplikasi',
    icon: Icons.shield_outlined,
    difficulty: 'Sedang',
    estimatedMinutes: 9,
    questions: [
      QuizQuestion(
        prompt: 'Apa fungsi utama DNS?',
        options: [
          'Mengenkripsi semua berkas',
          'Mengganti alamat MAC',
          'Menerjemahkan nama domain menjadi alamat IP',
          'Mengompresi gambar',
        ],
        correctIndex: 2,
        explanation: 'DNS memetakan nama domain ke record, termasuk alamat IP.',
      ),
      QuizQuestion(
        prompt: 'Apa yang ditambahkan HTTPS dibanding HTTP biasa?',
        options: [
          'Perlindungan komunikasi dengan TLS',
          'Jaminan situs tidak pernah berbahaya',
          'Penghapusan semua cookie',
          'Akses tanpa koneksi internet',
        ],
        correctIndex: 0,
        explanation: 'TLS menyediakan enkripsi, integritas, dan autentikasi server melalui sertifikat.',
      ),
      QuizQuestion(
        prompt: 'Protokol transport mana yang menyediakan aliran byte berurutan dan andal?',
        options: ['UDP', 'IP', 'ARP', 'TCP'],
        correctIndex: 3,
        explanation: 'TCP memakai pengurutan, acknowledgment, dan retransmisi untuk pengiriman andal.',
      ),
      QuizQuestion(
        prompt: 'Manakah contoh alamat IPv4 privat?',
        options: ['8.8.8.8', '192.168.1.10', '1.1.1.1', '208.67.222.222'],
        correctIndex: 1,
        explanation:
            'Rentang 192.168.0.0/16 dicadangkan untuk jaringan privat.',
      ),
      QuizQuestion(
        prompt: 'Cara paling tepat mengurangi risiko SQL injection adalah apa?',
        options: [
          'Menyembunyikan tombol login',
          'Menggunakan nama tabel panjang',
          'Menggunakan query berparameter',
          'Menghapus pesan bantuan',
        ],
        correctIndex: 2,
        explanation:
            'Parameter memisahkan data masukan dari struktur perintah SQL.',
      ),
      QuizQuestion(
        prompt: 'Bagaimana sebaiknya kata sandi disimpan di server?',
        options: [
          'Hash lambat dengan salt unik, misalnya Argon2id',
          'Teks biasa dalam tabel tersembunyi',
          'Base64 tanpa salt',
          'Enkripsi dengan kunci yang dikirim ke semua pengguna',
        ],
        correctIndex: 0,
        explanation: 'Hash khusus kata sandi dengan salt unik memperberat serangan tebakan offline.',
      ),
      QuizQuestion(
        prompt:
            'Apa contoh autentikasi dua faktor yang memakai faktor berbeda?',
        options: [
          'Dua kata sandi',
          'Kata sandi dan PIN hafalan',
          'Nama pengguna dan email',
          'Kata sandi dan kode dari aplikasi autentikator',
        ],
        correctIndex: 3,
        explanation: 'Kata sandi adalah faktor pengetahuan, perangkat autentikator adalah faktor kepemilikan.',
      ),
      QuizQuestion(
        prompt: 'Apa arti prinsip least privilege?',
        options: [
          'Semua pengguna menjadi admin',
          'Memberikan hanya izin minimum yang dibutuhkan',
          'Menonaktifkan seluruh autentikasi',
          'Memakai satu akun bersama',
        ],
        correctIndex: 1,
        explanation:
            'Izin minimum membatasi dampak kesalahan atau akun yang disusupi.',
      ),
    ],
  ),
  QuizCategory(
    id: 'logika-matematika',
    title: 'Logika Matematika',
    subtitle: 'Proposisi, himpunan, dan penalaran',
    icon: Icons.functions_rounded,
    difficulty: 'Sulit',
    estimatedMinutes: 10,
    questions: [
      QuizQuestion(
        prompt: 'Kapan implikasi p → q bernilai salah?',
        options: [
          'p salah, q salah',
          'p benar, q salah',
          'p salah, q benar',
          'p benar, q benar',
        ],
        correctIndex: 1,
        explanation: 'Implikasi hanya salah ketika premis benar tetapi kesimpulannya salah.',
      ),
      QuizQuestion(
        prompt: 'Menurut hukum De Morgan, negasi dari p ∧ q adalah apa?',
        options: ['¬p ∧ ¬q', 'p ∨ q', '¬p ∨ ¬q', 'p → q'],
        correctIndex: 2,
        explanation: 'Negasi konjungsi sama dengan disjungsi negasi masing-masing proposisi.',
      ),
      QuizQuestion(
        prompt: 'Jika A = {1, 2, 3} dan B = {3, 4}, berapa A ∩ B?',
        options: ['{3}', '{1, 2, 3, 4}', '{1, 2}', '{}'],
        correctIndex: 0,
        explanation:
            'Irisan berisi elemen yang ada di kedua himpunan, yaitu 3.',
      ),
      QuizQuestion(
        prompt: 'Berapa banyak susunan berbeda dari tiga huruf A, B, C tanpa pengulangan?',
        options: ['3', '9', '27', '6'],
        correctIndex: 3,
        explanation: 'Ada 3! = 3 × 2 × 1 = 6 permutasi.',
      ),
      QuizQuestion(
        prompt: 'Apa negasi dari “Semua mahasiswa lulus”?',
        options: [
          'Semua mahasiswa tidak lulus',
          'Ada mahasiswa yang tidak lulus',
          'Ada mahasiswa yang lulus',
          'Tidak ada mahasiswa',
        ],
        correctIndex: 1,
        explanation: 'Negasi pernyataan universal adalah adanya setidaknya satu contoh penyangkal.',
      ),
      QuizQuestion(
        prompt: 'Jika p → q benar dan p benar, kesimpulan validnya adalah apa?',
        options: ['¬q', '¬p', 'q', 'p salah'],
        correctIndex: 2,
        explanation: 'Ini adalah aturan inferensi modus ponens.',
      ),
      QuizQuestion(
        prompt: 'Berapa nilai desimal bilangan biner 1011?',
        options: ['11', '9', '13', '10'],
        correctIndex: 0,
        explanation: '1011₂ = 8 + 0 + 2 + 1 = 11.',
      ),
      QuizQuestion(
        prompt: 'Jika p benar dan q benar, berapa nilai p XOR q?',
        options: ['Benar', 'Tidak terdefinisi', 'Sama dengan p', 'Salah'],
        correctIndex: 3,
        explanation:
            'XOR benar hanya jika tepat satu operand benar, bukan keduanya.',
      ),
    ],
  ),
  QuizCategory(
    id: 'teknologi-web',
    title: 'Teknologi Web',
    subtitle: 'HTML, CSS, JavaScript, dan HTTP',
    icon: Icons.language_rounded,
    difficulty: 'Mudah',
    estimatedMinutes: 8,
    questions: [
      QuizQuestion(
        prompt: 'Elemen HTML mana yang paling semantik untuk navigasi utama?',
        options: ['<span>', '<b>', '<nav>', '<br>'],
        correctIndex: 2,
        explanation: 'Elemen nav menandai bagian berisi tautan navigasi.',
      ),
      QuizQuestion(
        prompt: 'Properti CSS apa yang mengatur ruang di dalam batas elemen?',
        options: ['padding', 'margin', 'outline', 'gap saja'],
        correctIndex: 0,
        explanation: 'Padding adalah ruang antara konten dan border; margin berada di luar border.',
      ),
      QuizQuestion(
        prompt: 'Apa hasil ekspresi JavaScript berikut?',
        code: 'console.log(2 === "2");',
        options: ['true', '2', 'undefined', 'false'],
        correctIndex: 3,
        explanation:
            '=== membandingkan tanpa konversi tipe; number dan string berbeda.',
      ),
      QuizQuestion(
        prompt:
            'Kode status HTTP apa yang menunjukkan resource tidak ditemukan?',
        options: ['200', '404', '201', '301'],
        correctIndex: 1,
        explanation: '404 Not Found menunjukkan server tidak menemukan resource yang diminta.',
      ),
      QuizQuestion(
        prompt: 'Metode HTTP mana yang semestinya hanya mengambil representasi resource?',
        options: ['DELETE', 'PATCH', 'GET', 'POST'],
        correctIndex: 2,
        explanation: 'GET memiliki semantik pengambilan data dan tidak semestinya mengubah state server.',
      ),
      QuizQuestion(
        prompt: 'Apa yang dimaksud responsive web design?',
        options: [
          'Tata letak menyesuaikan ukuran layar dan perangkat',
          'Situs hanya untuk desktop',
          'Semua gambar selalu berukuran tetap',
          'Server membalas tanpa HTTP',
        ],
        correctIndex: 0,
        explanation: 'Desain responsif memakai tata letak fleksibel dan media query sesuai viewport.',
      ),
      QuizQuestion(
        prompt: 'Apa tujuan kebijakan CORS pada browser?',
        options: [
          'Mengenkripsi database',
          'Menggantikan login pengguna',
          'Menyimpan semua respons selamanya',
          'Mengatur izin akses respons lintas origin',
        ],
        correctIndex: 3,
        explanation: 'Header CORS menentukan origin mana yang boleh membaca respons lintas origin.',
      ),
      QuizQuestion(
        prompt: 'Apa hasil kode JavaScript berikut?',
        code:
            'const nilai = [1, 2, 3];\nconsole.log(nilai.filter(n => n > 1));',
        options: ['[1]', '[2, 3]', '[1, 2, 3]', '6'],
        correctIndex: 1,
        explanation: 'filter membentuk array baru berisi elemen yang memenuhi kondisi n > 1.',
      ),
    ],
  ),
]);
