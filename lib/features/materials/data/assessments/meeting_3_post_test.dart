const List<Map<String, dynamic>> meeting3PostTestQuestions = [
  {
    'id': 1,
    'question':
        'ESP32 berhasil membaca suhu 29 °C dan kelembapan 70% pada Serial Monitor, tetapi data tidak ditemukan pada cloud. Kesimpulan awal yang paling tepat adalah ...',
    'options': [
      'Sensor pasti rusak karena cloud tidak menerima data',
      'Pembacaan lokal berhasil, sehingga pemeriksaan dilanjutkan ke proses koneksi dan pengiriman data',
      'Dashboard harus dibuat ulang sebelum memeriksa koneksi',
      'Nilai suhu terlalu tinggi untuk dikirim ke cloud',
    ],
    'correctAnswer': 1,
    'explanation':
        'Pembacaan sensor secara lokal telah berhasil, sehingga pemeriksaan selanjutnya perlu difokuskan pada koneksi dan proses pengiriman data. Nilai yang tampil pada Serial Monitor menunjukkan bahwa ESP32 sudah memperoleh data dari sensor, tetapi belum membuktikan bahwa data tersebut berhasil dikirim dan diterima oleh layanan cloud.',
  },
  {
    'id': 2,
    'question':
        'Dalam alur integrasi cloud, mengapa koneksi jaringan harus diperiksa sebelum menyimpulkan bahwa layanan cloud bermasalah?',
    'options': [
      'Karena sensor hanya bekerja ketika dashboard dibuka',
      'Karena cloud selalu memerlukan koneksi USB',
      'Karena gangguan jaringan dapat menghalangi data mencapai layanan tujuan',
      'Karena koneksi jaringan menentukan nilai suhu yang dibaca sensor',
    ],
    'correctAnswer': 2,
    'explanation':
        'Koneksi jaringan perlu diperiksa karena gangguan pada jaringan dapat menghalangi ESP32 mengirimkan data ke layanan tujuan. Meskipun konfigurasi cloud sudah benar, data tetap tidak akan sampai apabila perangkat tidak terhubung ke jaringan dengan baik.',
  },
  {
    'id': 3,
    'question':
        'ESP32 terhubung ke broker MQTT, tetapi data tidak diterima oleh aplikasi yang berlangganan. Pemeriksaan yang paling relevan adalah ...',
    'options': [
      'Kesesuaian topik publish dan subscribe serta konfigurasi broker',
      'Warna kabel USB',
      'Nama file gambar dashboard',
      'Ukuran huruf pada Serial Monitor',
    ],
    'correctAnswer': 0,
    'explanation':
        'Pemeriksaan perlu difokuskan pada kesesuaian topik publish dan subscribe serta konfigurasi broker MQTT. Koneksi ke broker saja belum menjamin pesan diterima oleh aplikasi karena pesan harus dikirim melalui topik yang sesuai dan diteruskan kepada subscriber yang tepat.',
  },
  {
    'id': 4,
    'question':
        'Sebuah layanan cloud menolak koneksi dari ESP32. Informasi yang paling relevan untuk diperiksa adalah ...',
    'options': [
      'Jenis grafik yang akan digunakan',
      'Warna LED pada simulasi',
      'Nama variabel yang hanya digunakan untuk komentar',
      'Alamat dan port layanan, status koneksi, serta autentikasi yang disyaratkan',
    ],
    'correctAnswer': 3,
    'explanation':
        'Informasi yang perlu diperiksa meliputi alamat dan port layanan, status koneksi, serta autentikasi yang disyaratkan. Layanan cloud memiliki pengaturan koneksi tertentu yang harus dipenuhi agar ESP32 dapat terhubung dan mengirimkan data.',
  },
  {
    'id': 5,
    'question':
        'Mengapa pengujian integrasi sebaiknya dilakukan dari sensor hingga layanan cloud secara bertahap?',
    'options': [
      'Agar semua bagian dapat dilewati jika satu bagian berhasil',
      'Agar lokasi kegagalan dapat diidentifikasi dengan lebih tepat',
      'Agar data sensor tidak perlu divalidasi',
      'Agar dashboard dapat bekerja tanpa sumber data',
    ],
    'correctAnswer': 1,
    'explanation':
        'Pengujian bertahap membantu menemukan lokasi kegagalan dengan lebih tepat karena setiap bagian memiliki fungsi yang berbeda. Pemeriksaan dapat dimulai dari pembacaan sensor, dilanjutkan ke koneksi jaringan dan pengiriman data, kemudian memastikan data benar-benar diterima oleh layanan cloud.',
  },
  {
    'id': 6,
    'question':
        'Data telah dipublikasikan oleh ESP32, tetapi dashboard tetap kosong. Langkah analisis berikutnya yang paling tepat adalah ...',
    'options': [
      'Mengubah nilai sensor berulang kali tanpa memeriksa layanan penerima',
      'Menghapus program ESP32 yang sudah bekerja',
      'Memastikan cloud atau layanan penerima benar-benar menerima dan menyediakan data yang dibutuhkan dashboard',
      'Mengganti semua pin sensor',
    ],
    'correctAnswer': 2,
    'explanation':
        'Pemeriksaan perlu dilanjutkan dengan memastikan bahwa layanan penerima benar-benar menerima dan menyediakan data yang dibutuhkan dashboard. Status pengiriman dari ESP32 belum menjamin data sudah tersedia untuk ditampilkan, sehingga alur penerimaan data dan penghubung antara layanan cloud dengan dashboard juga perlu diperiksa.',
  },
  {
    'id': 7,
    'question':
        'Dalam pengujian pengiriman data, mengapa format dan struktur data perlu diperiksa?',
    'options': [
      'Karena layanan penerima mungkin mengharapkan format atau nama field tertentu',
      'Karena format data menentukan apakah ESP32 memiliki pin Wi-Fi',
      'Karena data yang benar selalu ditolak jika berbentuk angka',
      'Karena struktur data menggantikan koneksi jaringan',
    ],
    'correctAnswer': 0,
    'explanation':
        'Layanan penerima mungkin mengharapkan format atau nama field tertentu, karena data yang dikirim harus sesuai dengan struktur yang dapat dibaca oleh layanan tujuan. Format yang tidak sesuai dapat menyebabkan data gagal diproses atau ditampilkan.',
  },
  {
    'id': 8,
    'question':
        'Jika layanan cloud memerlukan kunci API atau kredensial, tindakan yang paling tepat adalah ...',
    'options': [
      'Menampilkan kredensial di dashboard publik agar mudah diperiksa',
      'Mengirim kredensial melalui nama topik tanpa pengamanan',
      'Menghapus autentikasi meskipun diwajibkan layanan',
      'Menggunakan konfigurasi yang benar dan menjaga kredensial agar tidak dibagikan secara terbuka',
    ],
    'correctAnswer': 3,
    'explanation':
        'Kunci API atau kredensial perlu dikonfigurasi sesuai ketentuan layanan dan dijaga agar tidak dibagikan secara terbuka. Informasi tersebut digunakan untuk autentikasi, sehingga pengelolaannya perlu diperhatikan agar akses ke layanan tidak disalahgunakan oleh pihak lain.',
  },
  {
    'id': 9,
    'question':
        'Integrasi cloud langsung belum tersedia pada simulasi Wokwi yang digunakan. Cara pembelajaran yang tetap mengukur pemahaman secara tepat adalah ...',
    'options': [
      'Menganggap data telah terkirim tanpa bukti',
      'Meminta peserta didik menganalisis skenario kegagalan dan menyusun alur pengiriman data atau menggunakan data contoh yang ditandai dengan jelas',
      'Menilai peserta didik hanya dari warna rangkaian',
      'Melewati pembahasan jaringan dan cloud',
    ],
    'correctAnswer': 1,
    'explanation':
        'Pemahaman integrasi cloud tetap dapat dinilai melalui analisis skenario kegagalan, penyusunan alur pengiriman data, atau penggunaan data contoh yang diberi label dengan jelas. Pendekatan ini membantu peserta didik memahami proses komunikasi dan pemecahan masalah tanpa menganggap bahwa pengiriman data sungguhan telah berhasil dilakukan.',
  },
  {
    'id': 10,
    'question':
        'Urutan diagnosis yang paling sistematis ketika data tidak sampai ke cloud adalah ...',
    'options': [
      'Mendesain dashboard, mengganti sensor, lalu menghapus program',
      'Mengganti ESP32, mengubah tampilan, lalu memeriksa Serial Monitor',
      'Memastikan pembacaan sensor, memeriksa koneksi dan konfigurasi pengiriman, lalu memverifikasi data pada layanan penerima',
      'Mengubah grafik, mengganti topik, lalu mengabaikan status jaringan',
    ],
    'correctAnswer': 2,
    'explanation':
        'Diagnosis sebaiknya dimulai dengan memastikan pembacaan sensor berhasil, kemudian memeriksa koneksi jaringan dan konfigurasi pengiriman, lalu memverifikasi penerimaan data pada layanan cloud. Urutan ini membantu menemukan sumber masalah secara bertahap dari perangkat hingga layanan tujuan tanpa melewatkan bagian penting dalam proses integrasi.',
  },
];