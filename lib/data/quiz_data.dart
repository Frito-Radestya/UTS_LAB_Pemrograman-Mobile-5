import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';

const categories = <QuizCategory>[
  QuizCategory(
    id: CategoryId.sains,
    name: 'Sains',
    shortName: 'Sains',
    description: 'Jelajahi misteri alam semesta, tubuh manusia, dan fenomena sains lainnya.',
    tags: ['Antariksa', 'Tubuh manusia', 'Energi', 'Lingkungan'],
    color: AppColors.sains,
    iconAsset: 'assets/svg/icon_sains.svg',
    gradientInner: Color(0xFF3A2A20),
    gradientOuter: Color(0xFF14121A),
  ),
  QuizCategory(
    id: CategoryId.teknologi,
    name: 'Teknologi',
    shortName: 'Teknologi',
    description: 'Kenali internet, kecerdasan buatan, keamanan digital, dan inovasi masa kini.',
    tags: ['Internet', 'AI', 'Keamanan digital', 'Inovasi'],
    color: AppColors.teknologi,
    iconAsset: 'assets/svg/icon_teknologi.svg',
    gradientInner: Color(0xFF1F3358),
    gradientOuter: Color(0xFF10162B),
  ),
  QuizCategory(
    id: CategoryId.sejarah,
    name: 'Sejarah',
    shortName: 'Sejarah',
    description:
        'Telusuri peradaban, penemuan besar, dan jejak sejarah Indonesia.',
    tags: ['Peradaban', 'Penemuan', 'Sejarah Indonesia'],
    color: AppColors.sejarah,
    iconAsset: 'assets/svg/icon_sejarah.svg',
    gradientInner: Color(0xFF3A3020),
    gradientOuter: Color(0xFF14121A),
  ),
  QuizCategory(
    id: CategoryId.logika,
    name: 'Logika',
    shortName: 'Logika',
    description:
        'Latih pola angka, deduksi, dan penalaran untuk berpikir lebih tajam.',
    tags: ['Pola angka', 'Deduksi', 'Penalaran'],
    color: AppColors.logika,
    iconAsset: 'assets/svg/icon_logika.svg',
    gradientInner: Color(0xFF2D2650),
    gradientOuter: Color(0xFF10102A),
  ),
  QuizCategory(
    id: CategoryId.umum,
    name: 'Pengetahuan Umum',
    shortName: 'Umum',
    description:
        'Perluas wawasan geografi, budaya, dan fakta dunia yang menarik.',
    tags: ['Geografi', 'Budaya', 'Fakta dunia'],
    color: AppColors.umum,
    iconAsset: 'assets/svg/icon_umum.svg',
    gradientInner: Color(0xFF1C3A33),
    gradientOuter: Color(0xFF0F1A1E),
  ),
];

const questionsByCategory = <CategoryId, List<Question>>{
  CategoryId.sains: [
    Question(
      prompt: 'Apa nama planet yang dikenal sebagai Planet Merah?',
      options: ['Jupiter', 'Mars', 'Venus', 'Saturnus'],
      correctIndex: 1,
      explanation: 'Mars adalah planet keempat dari Matahari dan dikenal sebagai Planet Merah karena warnanya yang khas akibat oksida besi pada permukaannya.',
      funFact: 'Mars memiliki gunung tertinggi di tata surya, yaitu Olympus Mons, yang tingginya sekitar 22 km.',
    ),
    Question(
      prompt: 'Planet terbesar di tata surya adalah…',
      options: ['Bumi', 'Saturnus', 'Jupiter', 'Neptunus'],
      correctIndex: 2,
      explanation: 'Jupiter adalah raksasa gas dengan massa lebih besar dari semua planet lain digabung.',
      funFact: 'Satu hari di Jupiter hanya sekitar 10 jam.',
    ),
    Question(
      prompt: 'Gas yang paling banyak dihirup manusia untuk bernapas adalah…',
      options: ['Karbon dioksida', 'Nitrogen', 'Oksigen', 'Helium'],
      correctIndex: 2,
      explanation: 'Manusia membutuhkan oksigen untuk respirasi sel, meskipun udara paling banyak berisi nitrogen.',
      funFact: 'Udara kering mengandung sekitar 21% oksigen.',
    ),
    Question(
      prompt: 'Organ yang memompa darah ke seluruh tubuh adalah…',
      options: ['Paru-paru', 'Hati', 'Ginjal', 'Jantung'],
      correctIndex: 3,
      explanation: 'Jantung adalah otot berongga yang memompa darah melalui sistem peredaran.',
      funFact: 'Jantung orang dewasa berdetak sekitar 100.000 kali sehari.',
    ),
    Question(
      prompt: 'Satuan SI untuk suhu adalah…',
      options: ['Celsius', 'Fahrenheit', 'Kelvin', 'Joule'],
      correctIndex: 2,
      explanation: 'Dalam Sistem Internasional, suhu diukur dalam kelvin (K).',
      funFact: 'Nol mutlak setara dengan −273,15 °C.',
    ),
    Question(
      prompt: 'Proses tumbuhan membuat makanan dengan bantuan cahaya disebut…',
      options: ['Respirasi', 'Fotosintesis', 'Transpirasi', 'Fermentasi'],
      correctIndex: 1,
      explanation: 'Fotosintesis mengubah karbon dioksida dan air menjadi glukosa dengan bantuan cahaya.',
      funFact:
          'Oksigen yang kita hirup sebagian besar berasal dari fotosintesis.',
    ),
    Question(
      prompt: 'Bumi mengelilingi Matahari dalam waktu sekitar…',
      options: ['24 jam', '28 hari', '365 hari', '12 jam'],
      correctIndex: 2,
      explanation: 'Satu revolusi Bumi mengelilingi Matahari berlangsung sekitar 365,25 hari.',
      funFact: 'Seperempat hari extra itulah alasan adanya tahun kabisat.',
    ),
    Question(
      prompt: 'Bagian mata yang mengatur jumlah cahaya yang masuk adalah…',
      options: ['Kornea', 'Iris', 'Lensa', 'Retina'],
      correctIndex: 1,
      explanation: 'Iris mengatur ukuran pupil sehingga cahaya yang masuk tetap seimbang.',
      funFact: 'Warna mata ditentukan oleh pigmen di iris.',
    ),
    Question(
      prompt: 'Manakah yang merambat lebih cepat di udara?',
      options: ['Suara', 'Cahaya', 'Angin', 'Gelombang air'],
      correctIndex: 1,
      explanation: 'Cahaya merambat jauh lebih cepat daripada suara, sekitar 300.000 km/s.',
      funFact: 'Itulah sebabnya kilat terlihat lebih dulu daripada guntur.',
    ),
    Question(
      prompt: 'Air murni mendidih pada tekanan 1 atm di suhu…',
      options: ['90°C', '0°C', '50°C', '100°C'],
      correctIndex: 3,
      explanation: 'Pada tekanan atmosfer standar, air mendidih pada 100 derajat Celsius.',
      funFact: 'Di puncak gunung, air bisa mendidih di bawah 100°C karena tekanan lebih rendah.',
    ),
    Question(
      prompt: 'Satuan SI untuk gaya adalah…',
      options: ['Joule', 'Newton', 'Watt', 'Pascal'],
      correctIndex: 1,
      explanation:
          'Gaya diukur dalam newton (N), sesuai nama fisikawan Isaac Newton.',
      funFact: 'Satu newton setara dengan gaya yang mempercepat 1 kg sebesar 1 m/s².',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Planet yang memiliki satu hari lebih lama daripada satu tahunnya adalah…',
      options: ['Merkurius', 'Venus', 'Mars', 'Jupiter'],
      correctIndex: 1,
      explanation: 'Venus berotasi sangat lambat: satu hari Venus sekitar 243 hari Bumi, sedangkan revolusinya sekitar 225 hari Bumi.',
      funFact: 'Venus juga berputar berlawanan arah dibandingkan sebagian besar planet lain.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Basa nitrogen yang berpasangan dengan adenin pada DNA adalah…',
      options: ['Guanin', 'Sitosin', 'Timin', 'Urasil'],
      correctIndex: 2,
      explanation: 'Pada DNA, adenin (A) selalu berpasangan dengan timin (T) melalui dua ikatan hidrogen.',
      funFact: 'RNA menggunakan urasil sebagai pengganti timin.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Kecepatan cahaya di ruang hampa mendekati…',
      options: ['3.000 km/s', '30.000 km/s', '300.000 km/s', '3.000.000 km/s'],
      correctIndex: 2,
      explanation: 'Cahaya merambat sekitar 299.792 kilometer per detik, sering dibulatkan menjadi 300.000 km/s.',
      funFact: 'Cahaya Matahari membutuhkan sekitar 8 menit 20 detik untuk mencapai Bumi.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Sel darah yang berperan utama mengangkut oksigen adalah…',
      options: ['Leukosit', 'Trombosit', 'Eritrosit', 'Plasma'],
      correctIndex: 2,
      explanation: 'Eritrosit atau sel darah merah mengandung hemoglobin yang mengikat oksigen.',
      funFact: 'Satu tetes darah mengandung jutaan sel darah merah.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'pH air murni pada suhu 25°C adalah…',
      options: ['0', '5', '7', '14'],
      correctIndex: 2,
      explanation: 'Air murni bersifat netral dengan pH 7 pada suhu 25°C.',
      funFact: 'Skala pH mengukur konsentrasi ion hidrogen secara logaritmik.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Lapisan atmosfer tempat sebagian besar cuaca terjadi adalah…',
      options: ['Stratosfer', 'Troposfer', 'Mesosfer', 'Termosfer'],
      correctIndex: 1,
      explanation: 'Troposfer adalah lapisan paling bawah atmosfer dan menjadi tempat terbentuknya awan serta cuaca.',
      funFact:
          'Semakin tinggi di troposfer, suhu udara umumnya semakin rendah.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Satuan terkecil suatu unsur yang masih memiliki sifat unsur tersebut adalah…',
      options: ['Molekul', 'Atom', 'Sel', 'Proton'],
      correctIndex: 1,
      explanation: 'Atom adalah satuan dasar unsur. Molekul terbentuk dari gabungan atom.',
      funFact: 'Atom tersusun dari proton, neutron, dan elektron.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Manakah sumber energi yang termasuk terbarukan?',
      options: ['Batu bara', 'Gas alam', 'Energi surya', 'Minyak bumi'],
      correctIndex: 2,
      explanation: 'Energi surya berasal dari Matahari dan terus tersedia, sehingga termasuk sumber terbarukan.',
      funFact: 'Panel surya mengubah energi cahaya menjadi energi listrik melalui efek fotovoltaik.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Hukum Newton III menyatakan bahwa…',
      options: [
        'Benda diam akan tetap diam',
        'Gaya aksi menimbulkan reaksi sama besar dan berlawanan arah',
        'Percepatan sebanding dengan gaya',
        'Energi tidak dapat diciptakan',
      ],
      correctIndex: 1,
      explanation: 'Setiap gaya aksi menghasilkan gaya reaksi yang sama besar namun berlawanan arah.',
      funFact: 'Roket dapat meluncur karena gas yang disemburkan ke bawah menghasilkan reaksi ke atas.',
      difficulty: Difficulty.menengah,
    ),
    Question(
      prompt: 'Dalam sistem terisolasi, entropi cenderung…',
      options: ['Tetap', 'Berkurang', 'Bertambah', 'Menjadi nol'],
      correctIndex: 2,
      explanation: 'Hukum kedua termodinamika menyatakan entropi sistem terisolasi cenderung bertambah.',
      funFact: 'Entropi sering dipahami sebagai ukuran ketidakteraturan suatu sistem.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Organel yang menjadi tempat utama produksi ATP adalah…',
      options: ['Ribosom', 'Mitokondria', 'Lisosom', 'Badan Golgi'],
      correctIndex: 1,
      explanation: 'Mitokondria menghasilkan ATP melalui respirasi sel dan sering disebut rumah energi sel.',
      funFact: 'Mitokondria memiliki DNA sendiri yang diwariskan dari ibu.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Partikel subatom yang bermuatan negatif adalah…',
      options: ['Proton', 'Neutron', 'Elektron', 'Foton'],
      correctIndex: 2,
      explanation: 'Elektron bermuatan negatif, proton positif, sedangkan neutron netral.',
      funFact: 'Massa elektron jauh lebih kecil daripada proton atau neutron.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Teori relativitas khusus menyatakan bahwa kecepatan cahaya di ruang hampa…',
      options: [
        'Bergantung pada pengamat',
        'Konstan untuk semua pengamat inersia',
        'Bertambah di dekat gravitasi',
        'Menjadi nol di ruang hampa',
      ],
      correctIndex: 1,
      explanation: 'Kecepatan cahaya dalam ruang hampa sama bagi semua pengamat dalam kerangka inersia.',
      funFact: 'Konsep ini menjadi dasar persamaan terkenal E = mc².',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Penggabungan inti atom ringan menjadi inti yang lebih berat disebut…',
      options: ['Fisi nuklir', 'Fusi nuklir', 'Peluruhan alfa', 'Ionisasi'],
      correctIndex: 1,
      explanation: 'Fusi nuklir menggabungkan inti ringan, sedangkan fisi memecah inti berat.',
      funFact:
          'Matahari menghasilkan energi melalui fusi hidrogen menjadi helium.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Hukum kekekalan energi menyatakan bahwa energi…',
      options: [
        'Dapat diciptakan dari ketiadaan',
        'Tidak dapat diciptakan atau dimusnahkan',
        'Selalu berkurang setiap saat',
        'Hanya dimiliki benda bergerak',
      ],
      correctIndex: 1,
      explanation: 'Energi dapat berubah bentuk, tetapi total energi dalam sistem tertutup tetap.',
      funFact: 'Energi potensial dapat berubah menjadi energi kinetik saat benda jatuh.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Planet dengan medan magnet terkuat di tata surya adalah…',
      options: ['Bumi', 'Saturnus', 'Jupiter', 'Neptunus'],
      correctIndex: 2,
      explanation: 'Jupiter memiliki medan magnet sangat besar, jauh lebih kuat daripada medan magnet Bumi.',
      funFact: 'Medan magnet Jupiter menciptakan aurora raksasa di kutubnya.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Enzim mempercepat reaksi kimia dengan cara…',
      options: [
        'Menaikkan suhu reaksi',
        'Menurunkan energi aktivasi',
        'Mengubah pH larutan',
        'Menambah jumlah substrat',
      ],
      correctIndex: 1,
      explanation: 'Enzim menyediakan jalur reaksi dengan energi aktivasi lebih rendah sehingga reaksi berlangsung lebih cepat.',
      funFact: 'Enzim bersifat spesifik terhadap substrat tertentu.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Peristiwa penguraian cahaya putih saat melewati prisma disebut…',
      options: ['Refleksi', 'Difraksi', 'Dispersi', 'Polarisasi'],
      correctIndex: 2,
      explanation: 'Dispersi terjadi karena setiap warna cahaya dibiaskan dengan sudut berbeda.',
      funFact:
          'Pelangi terbentuk dari dispersi cahaya Matahari oleh tetesan air.',
      difficulty: Difficulty.ahli,
    ),
    Question(
      prompt: 'Usia alam semesta diperkirakan sekitar…',
      options: [
        '4,6 miliar tahun',
        '9,8 miliar tahun',
        '13,8 miliar tahun',
        '20 miliar tahun',
      ],
      correctIndex: 2,
      explanation: 'Pengamatan kosmologi modern memperkirakan usia alam semesta sekitar 13,8 miliar tahun.',
      funFact: 'Angka ini berasal antara lain dari pengukuran radiasi latar belakang kosmik.',
      difficulty: Difficulty.ahli,
    ),
  ],
  CategoryId.teknologi: [
    Question(
      prompt: 'Siapa yang mencetuskan World Wide Web?',
      options: ['Bill Gates', 'Tim Berners-Lee', 'Steve Jobs', 'Larry Page'],
      correctIndex: 1,
      explanation: 'Tim Berners-Lee merancang WWW di CERN pada 1989 sebagai cara berbagi informasi.',
      funFact: 'Halaman web pertama masih diarsipkan oleh CERN.',
    ),
    Question(
      prompt: 'AI adalah singkatan dari…',
      options: [
        'Automatic Internet',
        'Analog Input',
        'Artificial Intelligence',
        'Advanced Interface',
      ],
      correctIndex: 2,
      explanation: 'Artificial Intelligence merujuk pada sistem yang meniru kecerdasan manusia.',
      funFact: 'Istilah AI dipopulerkan pada konferensi Dartmouth tahun 1956.',
    ),
    Question(
      prompt: 'Kode HTTP 404 berarti…',
      options: [
        'Server error',
        'Tidak ditemukan',
        'Akses ditolak',
        'Pengalihan',
      ],
      correctIndex: 1,
      explanation:
          '404 menandakan sumber yang diminta tidak ditemukan di server.',
      funFact: 'Nama “404” berasal dari ruangan di CERN yang pernah dikaitkan dengan web awal.',
    ),
    Question(
      prompt: 'RAM pada komputer berfungsi sebagai…',
      options: [
        'Penyimpanan permanen',
        'Pendingin prosesor',
        'Memori kerja sementara',
        'Kartu grafis',
      ],
      correctIndex: 2,
      explanation: 'RAM menyimpan data yang sedang diproses agar CPU dapat mengaksesnya cepat.',
      funFact: 'Isi RAM hilang ketika komputer dimatikan.',
    ),
    Question(
      prompt: 'Protokol aman untuk situs web adalah…',
      options: ['HTTP', 'FTP', 'HTTPS', 'SMTP'],
      correctIndex: 2,
      explanation:
          'HTTPS menambahkan enkripsi TLS pada HTTP untuk melindungi data.',
      funFact: 'Gembok di bilah alamat menandakan koneksi HTTPS.',
    ),
    Question(
      prompt: 'Perangkat yang meneruskan data antar jaringan disebut…',
      options: ['Monitor', 'Router', 'Speaker', 'Scanner'],
      correctIndex: 1,
      explanation: 'Router menentukan jalur paket data dari satu jaringan ke jaringan lain.',
      funFact: 'Nama “router” berasal dari kata route, yaitu rute atau jalur.',
    ),
    Question(
      prompt: 'Satuan penyimpanan data yang lebih besar dari gigabyte adalah…',
      options: ['Megabyte', 'Kilobyte', 'Terabyte', 'Byte'],
      correctIndex: 2,
      explanation: '1 terabyte setara dengan 1.024 gigabyte.',
      funFact: 'Banyak layanan cloud kini mengukur kuota dalam terabyte.',
    ),
    Question(
      prompt: 'Sistem operasi sumber terbuka yang populer adalah…',
      options: ['Windows', 'macOS', 'Linux', 'iPadOS'],
      correctIndex: 2,
      explanation: 'Linux adalah kernel sumber terbuka yang menjadi dasar banyak distribusi.',
      funFact: 'Android dibangun di atas kernel Linux.',
    ),
    Question(
      prompt: 'Phishing adalah upaya…',
      options: [
        'Mempercepat internet',
        'Mencuri data dengan tipuan',
        'Memperbaiki virus',
        'Mencadangkan file',
      ],
      correctIndex: 1,
      explanation: 'Phishing menipu pengguna agar menyerahkan kata sandi atau data pribadi.',
      funFact: 'Nama phishing meniru “fishing”: memancing korban dengan umpan.',
    ),
    Question(
      prompt: 'CPU adalah kependekan dari…',
      options: [
        'Central Processing Unit',
        'Computer Personal Utility',
        'Core Program Upload',
        'Control Power Unit',
      ],
      correctIndex: 0,
      explanation:
          'CPU adalah unit pemroses pusat yang menjalankan instruksi program.',
      funFact: 'Kecepatan CPU sering diukur dalam gigahertz (GHz).',
    ),
  ],
  CategoryId.sejarah: [
    Question(
      prompt: 'Proklamasi kemerdekaan Indonesia dibacakan pada…',
      options: [
        '1 Juni 1945',
        '17 Agustus 1945',
        '10 November 1945',
        '28 Oktober 1928',
      ],
      correctIndex: 1,
      explanation: 'Soekarno dan Hatta memproklamasikan kemerdekaan pada 17 Agustus 1945.',
      funFact: 'Naskah proklamasi diketik oleh Sayuti Melik.',
    ),
    Question(
      prompt: 'Candi Borobudur terletak di provinsi…',
      options: ['Jawa Timur', 'Bali', 'Jawa Tengah', 'Yogyakarta'],
      correctIndex: 2,
      explanation: 'Borobudur berada di Magelang, Jawa Tengah.',
      funFact: 'Borobudur adalah candi Buddha terbesar di dunia.',
    ),
    Question(
      prompt: 'Kerajaan maritim besar di Nusantara yang berpusat di Sumatera adalah…',
      options: ['Majapahit', 'Sriwijaya', 'Mataram', 'Tarumanegara'],
      correctIndex: 1,
      explanation:
          'Sriwijaya adalah kerajaan maritim yang menguasai selat Malaka.',
      funFact: 'Prasasti Kedukan Bukit menjadi salah satu bukti Sriwijaya.',
    ),
    Question(
      prompt: 'Penemu mesin cetak di Eropa adalah…',
      options: ['Galileo', 'Johannes Gutenberg', 'Newton', 'Leonardo da Vinci'],
      correctIndex: 1,
      explanation:
          'Gutenberg mengembangkan mesin cetak bergerak sekitar 1440-an.',
      funFact: 'Alkitab Gutenberg termasuk buku cetak paling terkenal.',
    ),
    Question(
      prompt: 'Sumpah Pemuda diikrarkan pada tahun…',
      options: ['1908', '1928', '1945', '1998'],
      correctIndex: 1,
      explanation:
          'Kongres Pemuda II menghasilkan Sumpah Pemuda pada 28 Oktober 1928.',
      funFact:
          'Lagu Indonesia Raya pertama kali diperdengarkan saat kongres itu.',
    ),
    Question(
      prompt: 'Piramida Giza dibangun oleh peradaban…',
      options: ['Yunani', 'Romawi', 'Mesir Kuno', 'Maya'],
      correctIndex: 2,
      explanation: 'Piramida Giza dibangun sebagai makam firaun Mesir Kuno.',
      funFact: 'Piramida Khufu adalah satu-satunya Keajaiban Dunia Kuno yang masih berdiri.',
    ),
    Question(
      prompt: 'VOC didirikan oleh pedagang dari…',
      options: ['Inggris', 'Spanyol', 'Belanda', 'Portugal'],
      correctIndex: 2,
      explanation:
          'Vereenigde Oostindische Compagnie adalah kongsi dagang Belanda.',
      funFact: 'VOC sering disebut perusahaan multinasional pertama di dunia.',
    ),
    Question(
      prompt: 'Ibukota Majapahit berada di daerah yang kini disebut…',
      options: ['Solo', 'Trowulan', 'Banten', 'Palembang'],
      correctIndex: 1,
      explanation:
          'Pusat Majapahit diperkirakan berada di Trowulan, Jawa Timur.',
      funFact: 'Kitab Negarakertagama menggambarkan kejayaan Majapahit.',
    ),
    Question(
      prompt: 'Perang Dunia II berakhir pada tahun…',
      options: ['1918', '1939', '1945', '1950'],
      correctIndex: 2,
      explanation:
          'Perang Dunia II berakhir tahun 1945 setelah kekalahan Poros.',
      funFact: 'Hari kemenangan di Eropa diperingati setiap 8 Mei.',
    ),
    Question(
      prompt: 'Aksara yang digunakan kerajaan Jawa kuno antara lain…',
      options: ['Hieroglif', 'Hanacaraka / Jawa', 'Rune', 'Sirilik'],
      correctIndex: 1,
      explanation:
          'Aksara Jawa berkembang dari aksara Brahmi melalui Pallawa dan Kawi.',
      funFact: 'Aksara Jawa juga disebut hanacaraka.',
    ),
  ],
  CategoryId.logika: [
    Question(
      prompt: 'Lanjutkan pola: 2, 4, 8, 16, …',
      options: ['18', '24', '32', '20'],
      correctIndex: 2,
      explanation: 'Setiap suku dikalikan 2, sehingga suku berikutnya 32.',
      funFact: 'Pola ini disebut barisan geometri dengan rasio 2.',
    ),
    Question(
      prompt:
          'Jika semua kucing adalah hewan, dan Mimi adalah kucing, maka Mimi…',
      options: [
        'Bukan hewan',
        'Adalah hewan',
        'Adalah anjing',
        'Tidak bisa disimpulkan',
      ],
      correctIndex: 1,
      explanation: 'Ini silogisme valid: premis universal plus premis khusus menghasilkan kesimpulan.',
      funFact: 'Aristoteles merumuskan dasar logika silogisme.',
    ),
    Question(
      prompt: 'Berapakah 15% dari 200?',
      options: ['15', '20', '30', '35'],
      correctIndex: 2,
      explanation: '15/100 × 200 = 30.',
      funFact: 'Persen berarti “per seratus”.',
    ),
    Question(
      prompt: 'Mana yang ganjil di antara: 3, 9, 15, 21, 24?',
      options: ['3', '15', '21', '24'],
      correctIndex: 3,
      explanation: '24 adalah satu-satunya bilangan genap dalam daftar itu.',
      funFact: 'Bilangan genap habis dibagi 2.',
    ),
    Question(
      prompt: 'Jika hari ini Senin, maka 10 hari lagi adalah…',
      options: ['Kamis', 'Jumat', 'Sabtu', 'Rabu'],
      correctIndex: 0,
      explanation: '10 mod 7 = 3, Senin plus 3 hari adalah Kamis.',
      funFact: 'Siklus hari selalu berulang setiap 7 hari.',
    ),
    Question(
      prompt: 'Jumlah sudut dalam segitiga adalah…',
      options: ['90°', '180°', '270°', '360°'],
      correctIndex: 1,
      explanation: 'Jumlah ketiga sudut segitiga datar selalu 180 derajat.',
      funFact:
          'Pada permukaan bola, jumlah sudut segitiga bisa lebih dari 180°.',
    ),
    Question(
      prompt: 'Pola huruf: A, C, F, J, … Huruf berikutnya?',
      options: ['K', 'M', 'N', 'O'],
      correctIndex: 2,
      explanation: 'Posisi huruf: A(1), C(3)=+2, F(6)=+3, J(10)=+4. Selisih berikutnya +5 sehingga 15 = O.',
      funFact: 'Pola selisih yang naik sering muncul di tes penalaran.',
    ),
    Question(
      prompt: 'Sebuah jam menunjukkan 3:00. Sudut antara jarum jam dan menit adalah…',
      options: ['60°', '90°', '120°', '180°'],
      correctIndex: 1,
      explanation: 'Pada pukul 3:00 jarum jam di angka 3 dan menit di 12, membentuk sudut siku-siku.',
      funFact: 'Setiap angka jam berjarak 30 derajat.',
    ),
    Question(
      prompt: 'Jika 4 pensil seharga 12.000, harga 1 pensil adalah…',
      options: ['2.000', '3.000', '4.000', '6.000'],
      correctIndex: 1,
      explanation: '12.000 dibagi 4 hasilnya 3.000.',
      funFact: 'Ini contoh perbandingan senilai yang sederhana.',
    ),
    Question(
      prompt: 'Manakah pernyataan yang merupakan kontradiksi?',
      options: [
        'Semua burung bisa terbang',
        'Hujan atau tidak hujan',
        'Hari ini Senin dan bukan Senin',
        'Jika hujan, jalan basah',
      ],
      correctIndex: 2,
      explanation: 'Suatu pernyataan dan negasinya tidak bisa benar bersamaan.',
      funFact: 'Dalam logika, kontradiksi selalu bernilai salah.',
    ),
  ],
  CategoryId.umum: [
    Question(
      prompt: 'Ibu kota Jepang adalah…',
      options: ['Osaka', 'Kyoto', 'Tokyo', 'Hokkaido'],
      correctIndex: 2,
      explanation: 'Tokyo adalah ibu kota dan kota terbesar di Jepang.',
      funFact: 'Tokyo sebelumnya bernama Edo.',
    ),
    Question(
      prompt: 'Benua terbesar di Bumi adalah…',
      options: ['Afrika', 'Amerika', 'Asia', 'Eropa'],
      correctIndex: 2,
      explanation:
          'Asia memiliki luas daratan terbesar dan populasi terbanyak.',
      funFact: 'Sekitar 60% penduduk dunia tinggal di Asia.',
    ),
    Question(
      prompt: 'Lambang negara Indonesia adalah…',
      options: ['Garuda Pancasila', 'Harimau', 'Komodo', 'Elang Jawa'],
      correctIndex: 0,
      explanation: 'Garuda Pancasila merujuk pada burung mitologis yang membawa perisai Pancasila.',
      funFact: 'Semboyan di pita Garuda adalah Bhinneka Tunggal Ika.',
    ),
    Question(
      prompt: 'Samudra terluas di dunia adalah…',
      options: ['Atlantik', 'Hindia', 'Pasifik', 'Arktik'],
      correctIndex: 2,
      explanation:
          'Samudra Pasifik mencakup lebih dari sepertiga permukaan Bumi.',
      funFact: 'Nama Pasifik berarti “damai”, diberikan Magellan.',
    ),
    Question(
      prompt:
          'Alat musik tradisional Jawa yang dimainkan dengan dipukul adalah…',
      options: ['Suling', 'Gamelan / gong', 'Angklung saja', 'Piano'],
      correctIndex: 1,
      explanation:
          'Gamelan terdiri dari gong, saron, dan instrumen pukul lain.',
      funFact: 'UNESCO mengakui gamelan sebagai warisan budaya takbenda.',
    ),
    Question(
      prompt: 'Mata uang Malaysia adalah…',
      options: ['Rupiah', 'Baht', 'Ringgit', 'Peso'],
      correctIndex: 2,
      explanation: 'Mata uang resmi Malaysia adalah ringgit (MYR).',
      funFact: 'Satu ringgit dibagi menjadi 100 sen.',
    ),
    Question(
      prompt: 'Gunung tertinggi di Indonesia adalah…',
      options: ['Semeru', 'Rinjani', 'Kerinci', 'Puncak Jaya'],
      correctIndex: 3,
      explanation:
          'Puncak Jaya (Carstensz) di Papua mencapai lebih dari 4.800 mdpl.',
      funFact: 'Puncak Jaya adalah satu-satunya puncak bersalju di Indonesia.',
    ),
    Question(
      prompt: 'Hari Kemerdekaan Indonesia diperingati setiap…',
      options: ['1 Juni', '17 Agustus', '21 April', '10 November'],
      correctIndex: 1,
      explanation: '17 Agustus adalah hari proklamasi kemerdekaan.',
      funFact: 'Upacara negara biasanya diadakan di Istana Merdeka.',
    ),
    Question(
      prompt: 'Planet yang paling dekat dengan Matahari adalah…',
      options: ['Venus', 'Merkurius', 'Bumi', 'Mars'],
      correctIndex: 1,
      explanation: 'Merkurius adalah planet terdalam di tata surya.',
      funFact: 'Satu tahun di Merkurius hanya sekitar 88 hari Bumi.',
    ),
    Question(
      prompt: 'Bahasa resmi Perserikatan Bangsa-Bangsa yang berasal dari Asia adalah…',
      options: ['Jepang', 'Hindi', 'Tionghoa (Mandarin)', 'Korea'],
      correctIndex: 2,
      explanation: 'Enam bahasa resmi PBB: Arab, Tionghoa, Inggris, Prancis, Rusia, Spanyol.',
      funFact:
          'Bahasa Indonesia bukan bahasa resmi PBB, meski banyak penuturnya.',
    ),
  ],
};

QuizCategory categoryById(CategoryId id) =>
    categories.firstWhere((c) => c.id == id);

/// Soal untuk kategori dan tingkat tertentu. Tingkat tanpa soal mengembalikan
/// daftar kosong agar UI dapat menandainya sebagai "Segera hadir".
List<Question> questionsFor(CategoryId id, Difficulty difficulty) {
  final bank = questionsByCategory[id] ?? const <Question>[];
  return List<Question>.unmodifiable(
    bank.where((question) => question.difficulty == difficulty),
  );
}

bool hasQuestionsFor(CategoryId id, Difficulty difficulty) =>
    questionsFor(id, difficulty).isNotEmpty;

int questionCountFor(CategoryId id) =>
    (questionsByCategory[id] ?? const <Question>[]).length;

List<Difficulty> difficultiesWithQuestions(CategoryId id) => [
  for (final difficulty in Difficulty.values)
    if (hasQuestionsFor(id, difficulty)) difficulty,
];
