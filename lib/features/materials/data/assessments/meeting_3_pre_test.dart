const List<Map<String, dynamic>> meeting3PreTestQuestions = [
  {
    'question': 'Apa yang dimaksud dengan cloud dalam sistem IoT?',
    'options': [
      'Komponen yang membaca suhu secara langsung',
      'Pin pada mikrokontroler untuk menghubungkan sensor',
      'Layanan komputasi melalui jaringan yang dapat digunakan untuk menerima atau menyimpan data',
      'Program yang hanya mengatur kedipan LED',
    ],
    'correctAnswer': 2,
  },
  {
    'question': 'Apa tujuan mengirim data sensor ke cloud?',
    'options': [
      'Agar data dapat diakses atau dikelola melalui layanan jaringan sesuai konfigurasi',
      'Agar sensor tidak perlu melakukan pengukuran',
      'Agar ESP32 tidak membutuhkan program',
      'Agar semua data hanya dapat dilihat melalui kabel USB',
    ],
    'correctAnswer': 0,
  },
  {
    'question':
        'Data suhu telah tampil pada Serial Monitor. Hal ini paling kuat menunjukkan bahwa ...',
    'options': [
      'Dashboard pasti sudah menerima data',
      'Cloud sudah menyimpan semua data',
      'Koneksi internet dan broker pasti berjalan',
      'Proses pembacaan data pada perangkat lokal setidaknya telah menghasilkan keluaran yang dapat diamati',
    ],
    'correctAnswer': 3,
  },
  {
    'question':
        'Komponen yang umumnya dibutuhkan ESP32 untuk mengirim data ke layanan cloud melalui internet adalah ...',
    'options': [
      'LED dan resistor saja',
      'Koneksi jaringan serta konfigurasi komunikasi ke layanan tujuan',
      'Sensor kedua yang selalu identik',
      'Program dashboard yang berjalan pada monitor komputer',
    ],
    'correctAnswer': 1,
  },
  {
    'question':
        'Jika data tidak muncul di cloud, langkah awal yang paling membantu adalah ...',
    'options': [
      'Memeriksa seluruh proses secara berurutan dari pembacaan sensor hingga pengiriman data',
      'Mengganti semua komponen tanpa pengujian',
      'Membuat grafik baru dan menganggap data telah terkirim',
      'Menghapus kode pembacaan sensor',
    ],
    'correctAnswer': 0,
  },
  {
    'question':
        'Dalam integrasi IoT, informasi seperti alamat server, port, topik, atau kredensial layanan digunakan untuk ...',
    'options': [
      'Mengukur suhu dan kelembapan',
      'Mengatur nyala LED secara langsung',
      'Mengonfigurasi koneksi dan komunikasi dengan layanan tujuan',
      'Menggantikan fungsi ESP32 sebagai pengendali',
    ],
    'correctAnswer': 2,
  },
  {
    'question':
        'Apa perbedaan utama Serial Monitor dan layanan cloud pada proyek IoT?',
    'options': [
      'Serial Monitor selalu menyimpan data online, sedangkan cloud hanya lokal',
      'Serial Monitor digunakan untuk mengganti sensor, sedangkan cloud mengendalikan pin',
      'Keduanya hanya digunakan untuk mengedit kode',
      'Serial Monitor membantu mengamati keluaran lokal, sedangkan cloud menyediakan layanan data melalui jaringan',
    ],
    'correctAnswer': 3,
  },
];