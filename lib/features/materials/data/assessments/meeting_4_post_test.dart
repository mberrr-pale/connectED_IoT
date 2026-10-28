const List<Map<String, dynamic>> meeting4PostTestQuestions = [
  {
    'id': 1,
    'question':
        'Dashboard monitoring menampilkan suhu saat ini sebesar 30 °C dan grafik perubahan suhu selama satu jam terakhir. Informasi yang dapat diperoleh dari grafik adalah ...',
    'options': [
      'Jenis mikrokontroler yang digunakan tanpa informasi tambahan',
      'Perubahan suhu sepanjang periode yang ditampilkan',
      'Kepastian bahwa sensor tidak pernah mengalami kesalahan',
      'Jumlah pin yang digunakan pada ESP32',
    ],
    'correctAnswer': 1,
    'explanation':
        'Grafik tersebut menunjukkan perubahan suhu sepanjang periode yang ditampilkan, sehingga pengguna dapat mengamati pola kenaikan dan penurunan suhu dari waktu ke waktu. Informasi ini membantu pengguna memahami kondisi ruangan, bukan hanya mengetahui suhu pada saat tertentu.',
  },
  {
    'id': 2,
    'question':
        'Data dari sensor telah diterima layanan cloud, tetapi dashboard tidak menampilkan nilai terbaru. Bagian yang paling tepat diperiksa berikutnya adalah ...',
    'options': [
      'Sambungan LED yang tidak digunakan dashboard',
      'Warna casing ESP32',
      'Proses pengambilan data dari layanan cloud, pemetaan data, dan pembaruan tampilan dashboard',
      'Jenis sensor lain yang tidak terpasang',
    ],
    'correctAnswer': 2,
    'explanation':
        'Pemeriksaan perlu difokuskan pada proses pengambilan data dari layanan cloud, pemetaan data, dan pembaruan tampilan dashboard. Data yang sudah diterima cloud masih perlu diambil dan diolah dengan benar agar nilai terbaru dapat ditampilkan kepada pengguna.',
  },
  {
    'id': 3,
    'question':
        'Pada dashboard, nilai suhu terus sama meskipun nilai sensor diubah dalam simulasi. Salah satu pemeriksaan yang paling relevan adalah ...',
    'options': [
      'Memastikan dashboard menerima dan memperbarui data terbaru, bukan hanya menggunakan nilai statis',
      'Mengganti judul dashboard',
      'Mengubah warna grafik tanpa memeriksa sumber data',
      'Menghapus label kelembapan',
    ],
    'correctAnswer': 0,
    'explanation':
        'Pemeriksaan perlu memastikan bahwa dashboard menerima dan memperbarui data terbaru, bukan hanya menampilkan nilai statis. Jika nilai tidak berubah meskipun sensor menunjukkan hasil berbeda, dashboard mungkin belum terhubung dengan sumber data terbaru atau belum melakukan pembaruan tampilan.',
  },
  {
    'id': 4,
    'question':
        'Sebuah dashboard menggunakan data contoh untuk menunjukkan bentuk grafik, sedangkan integrasi cloud belum tersedia. Pernyataan yang paling tepat adalah ...',
    'options': [
      'Dashboard sudah terbukti menerima data sensor secara real-time',
      'Seluruh sistem IoT sudah berhasil terhubung ke internet',
      'Data contoh dapat dianggap sebagai hasil pengukuran langsung',
      'Dashboard dapat digunakan untuk mempelajari visualisasi, tetapi belum membuktikan integrasi data secara langsung',
    ],
    'correctAnswer': 3,
    'explanation':
        'Dashboard tersebut dapat digunakan untuk mempelajari cara menyajikan data dalam bentuk grafik, tetapi belum membuktikan bahwa integrasi data berlangsung secara langsung. Data contoh hanya menggambarkan bentuk visualisasi, bukan hasil pengiriman data nyata dari sensor melalui layanan cloud.',
  },
  {
    'id': 5,
    'question':
        'Peserta didik ingin menunjukkan bahwa sistem monitoring bekerja sesuai rancangan. Bukti pengujian yang paling kuat adalah ...',
    'options': [
      'Tampilan halaman awal aplikasi saja',
      'Hasil simulasi sensor, data yang diterima layanan tujuan, dan dashboard yang sesuai dengan data tersebut',
      'Daftar komponen tanpa hasil pengujian',
      'Kode program tanpa menjalankan simulasi',
    ],
    'correctAnswer': 1,
    'explanation':
        'Bukti pengujian mencakup hasil simulasi sensor, data yang diterima layanan tujuan, dan dashboard yang sesuai dengan data tersebut. Bukti dari setiap tahap dapat menunjukkan bahwa proses pembacaan, pengiriman, penerimaan, dan penyajian data berjalan sesuai rancangan.',
  },
  {
    'id': 6,
    'question':
        'Jika nilai kelembapan pada sensor berubah, tetapi grafik dashboard hanya menampilkan suhu, perbaikan yang paling sesuai adalah ...',
    'options': [
      'Menghapus sensor kelembapan dari rangkaian',
      'Mengganti seluruh sistem dengan LED',
      'Memastikan data kelembapan dikirim, diterima, dan ditambahkan sebagai variabel atau seri pada dashboard',
      'Mengubah nama perangkat tanpa mengubah konfigurasi data',
    ],
    'correctAnswer': 2,
    'explanation':
        'Perbaikan yang paling sesuai adalah memastikan data kelembapan dikirim, diterima, dan ditambahkan sebagai variabel atau seri pada dashboard. Data kelembapan perlu melewati proses pengiriman dan pengolahan, kemudian ditampilkan pada dashboard agar perubahan nilainya dapat diamati.',
  },
  {
    'id': 7,
    'question':
        'Mengapa informasi waktu pengukuran berguna pada dashboard monitoring?',
    'options': [
      'Untuk membantu mengetahui kapan data dicatat dan menafsirkan perubahan dari waktu ke waktu',
      'Untuk menggantikan nilai suhu yang diukur',
      'Untuk menentukan pin sensor yang harus digunakan',
      'Untuk membuat koneksi cloud tidak diperlukan',
    ],
    'correctAnswer': 0,
    'explanation':
        'Informasi waktu pengukuran membantu pengguna mengetahui kapan data dicatat dan menghubungkannya dengan perubahan kondisi ruangan. Dengan mencocokkan nilai sensor dan waktu pencatatannya, pengguna dapat mengamati pola perubahan suhu maupun kelembapan selama periode tertentu.',
  },
  {
    'id': 8,
    'question':
        'Dalam pengujian sistem, angka pada dashboard berbeda dari nilai yang terlihat pada Serial Monitor. Langkah yang paling tepat adalah ...',
    'options': [
      'Langsung menyimpulkan bahwa dashboard tidak diperlukan',
      'Mengubah seluruh nilai sensor secara manual',
      'Menghapus grafik dan menghentikan pengujian',
      'Menelusuri kesesuaian data pada proses pengiriman, penerimaan, pemetaan, dan pembaruan dashboard',
    ],
    'correctAnswer': 3,
    'explanation':
        'Pemeriksaan perlu dilakukan dengan menelusuri kesesuaian data pada proses pengiriman, penerimaan, pemetaan, hingga pembaruan dashboard. Perbedaan nilai dapat terjadi ketika data yang dikirim tidak sesuai, data yang diterima belum diperbarui, atau dashboard menampilkan informasi yang berbeda dari hasil pembacaan sensor.',
  },
  {
    'id': 9,
    'question':
        'Manakah urutan alur sistem monitoring suhu dan kelembapan yang paling tepat?',
    'options': [
      'Dashboard → cloud → sensor → ESP32',
      'ESP32 → dashboard → sensor → cloud',
      'Sensor DHT22 → ESP32 → jaringan dan layanan data → dashboard',
      'Cloud → dashboard → sensor → ESP32',
    ],
    'correctAnswer': 2,
    'explanation':
        'Urutan alur sistem monitoring adalah sensor DHT22 → ESP32 → jaringan dan layanan data → dashboard. DHT22 membaca kondisi lingkungan, ESP32 memproses hasil pengukuran, jaringan meneruskan data ke layanan tujuan, lalu dashboard menyajikan informasi tersebut agar dapat dipantau pengguna.',
  },
  {
    'id': 10,
    'question':
        'Peserta didik telah membuat ESP32 membaca DHT22 dan mengirim data ke cloud. Agar proyek akhirnya lebih lengkap, tindakan berikut yang paling tepat adalah ...',
    'options': [
      'Menghentikan pengujian setelah data sensor berhasil dibaca',
      'Membuat dashboard, menguji kesesuaian data yang ditampilkan, dan menjelaskan alur kerja sistem secara keseluruhan',
      'Mengganti semua komponen meskipun sudah berfungsi',
      'Menampilkan gambar rangkaian tanpa data monitoring',
    ],
    'correctAnswer': 1,
    'explanation':
        'Tahap selanjutnya adalah membuat dashboard, menguji kesesuaian data yang ditampilkan, dan menjelaskan alur kerja sistem secara keseluruhan. Dengan demikian, proyek tidak hanya menghasilkan pembacaan dan pengiriman data, tetapi juga menyajikan informasi yang mudah dipahami serta menunjukkan hubungan antara sensor, mikrokontroler, layanan cloud, dan dashboard.',
  },
];