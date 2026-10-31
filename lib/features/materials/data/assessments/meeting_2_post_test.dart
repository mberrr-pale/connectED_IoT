const List<Map<String, dynamic>> meeting2PostTestQuestions = [
  {
    'id': 1,
    'question':
        'Dalam sistem monitoring ruangan, DHT22 menunjukkan nilai suhu dan kelembapan. Data tersebut merupakan ...',
    'options': [
      'Perintah untuk menyalakan sensor',
      'Data hasil pengukuran kondisi fisik',
      'Alamat IP ESP32',
      'Informasi autentikasi cloud',
    ],
    'correctAnswer': 1,
    'explanation':
        'Data tersebut merupakan hasil pengukuran kondisi fisik lingkungan, karena DHT22 membaca suhu dan kelembapan udara lalu menghasilkan nilai yang dapat dibaca dan diproses oleh ESP32.',
  },
  {
    'id': 2,
    'question':
        'ESP32 berjalan, tetapi Serial Monitor tidak menampilkan nilai dari DHT22. Pemeriksaan yang paling relevan adalah ...',
    'options': [
      'Warna latar belakang dashboard',
      'Nama pengguna pada cloud',
      'Kesesuaian pin sensor, konfigurasi program, dan inisialisasi sensor',
      'Ukuran layar komputer',
    ],
    'correctAnswer': 2,
    'explanation':
        'Pemeriksaan perlu difokuskan pada kesesuaian pin sensor, konfigurasi program, dan inisialisasi DHT22, karena kesalahan pada rangkaian atau pengaturan program dapat menyebabkan ESP32 gagal membaca data dari sensor.',
  },
  {
    'id': 3,
    'question':
        'Apa yang paling tepat menjelaskan hubungan antara sensor dan ESP32?',
    'options': [
      'Sensor mengukur kondisi fisik, kemudian ESP32 membaca dan memproses hasilnya sesuai program',
      'ESP32 mengukur suhu secara langsung tanpa sensor',
      'Sensor menyimpan program yang dijalankan ESP32',
      'ESP32 hanya berfungsi untuk menampilkan grafik',
    ],
    'correctAnswer': 0,
    'explanation':
        'Sensor bertugas mengukur kondisi fisik lingkungan, sedangkan ESP32 membaca dan memproses hasil pengukuran sesuai instruksi program. Data dari sensor menjadi masukan bagi ESP32 untuk diolah lebih lanjut.',
  },
  {
    'id': 4,
    'question':
        'Mengapa nilai sensor perlu diperiksa terlebih dahulu melalui Serial Monitor sebelum dikirim ke cloud?',
    'options': [
      'Agar perangkat tidak perlu menggunakan jaringan',
      'Agar data otomatis tersimpan di dashboard',
      'Agar MQTT dapat dihapus dari program',
      'Untuk memastikan proses pembacaan sensor bekerja sebelum menelusuri masalah komunikasi jaringan',
    ],
    'correctAnswer': 3,
    'explanation':
        'Nilai sensor perlu diperiksa melalui Serial Monitor untuk memastikan proses pembacaan data berjalan dengan baik sebelum menguji komunikasi jaringan. Dengan begitu, jika data tidak sampai ke cloud, pemeriksaan dapat difokuskan pada proses pengiriman tanpa mengabaikan kemungkinan masalah pada pembacaan sensor.',
  },
  {
    'id': 5,
    'question':
        'Dalam MQTT, perangkat yang menerbitkan data suhu ke topik tertentu disebut ...',
    'options': [
      'Subscriber',
      'Publisher',
      'Dashboard designer',
      'Database administrator',
    ],
    'correctAnswer': 1,
    'explanation':
        'Perangkat tersebut disebut publisher, karena publisher merupakan pihak yang mengirimkan pesan, misalnya data suhu dari ESP32 ke broker MQTT melalui topik yang ditentukan.',
  },
  {
    'id': 6,
    'question': 'Pada arsitektur MQTT, fungsi broker adalah ...',
    'options': [
      'Mengukur suhu dan kelembapan secara langsung',
      'Mengubah rangkaian ESP32 menjadi sensor',
      'Menerima pesan dari publisher dan meneruskannya kepada subscriber yang sesuai',
      'Menggantikan semua program pada mikrokontroler',
    ],
    'correctAnswer': 2,
    'explanation':
        'Broker berfungsi menerima pesan dari publisher dan meneruskannya kepada subscriber yang sesuai. Broker menjadi perantara komunikasi sehingga perangkat penerima tidak harus berkomunikasi secara langsung dengan perangkat pengirim.',
  },
  {
    'id': 7,
    'question':
        'Sebuah aplikasi berlangganan pada topik ruangan/suhu. Data suhu dapat diterima jika ...',
    'options': [
      'Publisher mengirim pesan pada topik yang sesuai dan broker meneruskannya kepada subscriber',
      'Sensor terhubung ke LED tanpa ESP32',
      'Dashboard hanya membuka gambar statis',
      'Publisher dan subscriber menggunakan nama topik yang berbeda',
    ],
    'correctAnswer': 0,
    'explanation':
        'Data suhu dapat diterima ketika publisher mengirimkan pesan melalui topik ruangan/suhu dan broker meneruskannya kepada aplikasi yang berlangganan pada topik tersebut. Kesamaan topik penting agar pesan dapat disalurkan kepada penerima yang tepat.',
  },
  {
    'id': 8,
    'question':
        'ESP32 berhasil membaca data DHT22, tetapi aplikasi MQTT tidak menerima data. Penyebab yang paling masuk akal adalah ...',
    'options': [
      'Suhu ruangan terlalu rendah untuk dibaca sensor',
      'LED tidak berkedip satu detik sekali',
      'Nama variabel suhu terlalu pendek',
      'Konfigurasi broker, koneksi jaringan, topik, atau proses publish bermasalah',
    ],
    'correctAnswer': 3,
    'explanation':
        'Masalah kemungkinan terdapat pada konfigurasi broker, koneksi jaringan, topik, atau proses publish, karena keberhasilan membaca sensor belum menjamin data berhasil dikirim. Komunikasi MQTT juga bergantung pada koneksi dan konfigurasi pengiriman pesan yang tepat.',
  },
  {
    'id': 9,
    'question':
        'Mengapa nama topik MQTT perlu diperhatikan ketika mengirim dan menerima data?',
    'options': [
      'Topik menentukan warna grafik yang digunakan',
      'Topik membantu mengelompokkan pesan agar publisher dan subscriber menggunakan kanal pesan yang sesuai',
      'Topik menggantikan alamat jaringan dan koneksi broker',
      'Topik menentukan pin fisik sensor pada ESP32',
    ],
    'correctAnswer': 1,
    'explanation':
        'Topik membantu mengelompokkan pesan agar publisher dan subscriber menggunakan kanal pesan yang sesuai. Topik menjadi acuan bagi broker untuk meneruskan pesan kepada subscriber yang berlangganan pada topik tersebut.',
  },
  {
    'id': 10,
    'question':
        'Dalam simulasi monitoring, nilai suhu berubah di Serial Monitor tetapi tidak muncul pada layanan penerima MQTT. Urutan pemeriksaan yang paling tepat adalah ...',
    'options': [
      'Membuat dashboard baru tanpa memeriksa komunikasi',
      'Mengganti DHT22 meskipun pembacaannya benar',
      'Memeriksa koneksi jaringan, alamat dan port broker, autentikasi jika diperlukan, serta nama topik',
      'Menghapus semua data sensor dan menghentikan simulasi',
    ],
    'correctAnswer': 2,
    'explanation':
        'Pemeriksaan sebaiknya dimulai dari koneksi jaringan, dilanjutkan dengan alamat dan port broker, autentikasi jika diperlukan, serta kesesuaian nama topik dan proses publish. Karena perubahan nilai suhu sudah terlihat di Serial Monitor, pembacaan sensor telah menghasilkan data sehingga pemeriksaan selanjutnya perlu difokuskan pada jalur komunikasi MQTT.',
  },
];