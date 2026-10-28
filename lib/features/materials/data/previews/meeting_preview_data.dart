class PreviewContent {
  final String title;
  final String nextMaterialOverview;
  final String caseStudyTitle;
  final String caseStudyDescription;
  final List<String> learningPoints;
  final String expectedResult;
  final String simulationInstruction;

  const PreviewContent({
    required this.title,
    required this.nextMaterialOverview,
    required this.caseStudyTitle,
    required this.caseStudyDescription,
    required this.learningPoints,
    required this.expectedResult,
    required this.simulationInstruction,
  });
}

const Map<int, PreviewContent> meetingPreviewData = {
  1: PreviewContent(
    title: 'Preview Pertemuan 2',
    nextMaterialOverview: 
      'Pada pertemuan berikutnya, kamu akan mempelajari bagaimana '
      'ESP32 membaca kondisi lingkungan menggunakan sensor DHT22. '
      'Kamu juga akan mengenal cara menampilkan data suhu dan '
      'kelembapan melalui Serial Monitor serta memahami dasar '
      'komunikasi IoT menggunakan protokol MQTT untuk pertukaran '
      'data antarperangkat.',
    caseStudyTitle: 'Membuat LED Berkedip dengan ESP32',
    caseStudyDescription: 
      'Sebuah ruangan akan dilengkapi dengan sistem monitoring suhu. '
      'Sebelum menggunakan sensor untuk membaca suhu ruangan, kamu '
      'akan mengenal ESP32 sebagai perangkat pengendali melalui '
      'proyek sederhana menggunakan LED.\n\n'
      'Pada proyek ini, kamu akan membuat LED menyala dan mati '
      'secara bergantian melalui program yang dijalankan pada ESP32. '
      'Proyek ini menjadi langkah awal sebelum kamu menambahkan '
      'sensor pada pertemuan berikutnya.',
    learningPoints: [
      'Mengenali ESP32, LED, dan hubungan pin yang digunakan.',
      'Membuat program untuk menyalakan dan mematikan LED secara berulang.',
      'Menjalankan simulasi dan mengamati perubahan kondisi LED.',
    ],
    expectedResult:
      'LED menyala selama satu detik dan mati selama satu detik '
      'secara berulang. Kamu juga dapat menjelaskan fungsi ESP32 '
      'dan hubungan antara program dengan kondisi LED.',
    simulationInstruction: 
      'Buka menu Simulasi, kemudian pilih Pertemuan 1 untuk mengikuti '
      'petunjuk merangkai komponen, menulis program, dan menjalankan '
      'simulasi di Wokwi.',
  ),

  2: PreviewContent(
    title: 'Preview Pertemuan 3',
    nextMaterialOverview: 
      'Pada pertemuan berikutnya, kamu akan mempelajari cara '
      'mengirimkan data suhu dan kelembapan dari ESP32 ke layanan '
      'cloud melalui jaringan. Kamu juga akan mengenal proses '
      'komunikasi antarperangkat menggunakan protokol IoT serta '
      'memahami bagaimana data sensor dapat diterima dan disimpan '
      'oleh layanan cloud untuk dipantau lebih lanjut.',
    caseStudyTitle: 'Membaca Suhu dan Kelembapan dengan DHT22',
    caseStudyDescription: 
      'Pada pertemuan sebelumnya, kamu telah menggunakan ESP32 '
      'untuk mengendalikan LED. Sekarang, proyek tersebut akan '
      'dikembangkan dengan menambahkan sensor DHT22 agar ESP32 '
      'dapat membaca suhu dan kelembapan ruangan.\n\n'
      'Kamu akan mempelajari cara menghubungkan sensor ke ESP32, '
      'membaca data yang dihasilkan, dan menampilkannya melalui '
      'Serial Monitor.',
    learningPoints: [
      'Mengenali fungsi sensor DHT22 untuk membaca suhu dan kelembapan.',
      'Menambahkan DHT22 ke rangkaian ESP32 yang sudah dibuat.',
      'Menampilkan data suhu dan kelembapan melalui Serial Monitor.',
      'Mengamati perubahan data ketika kondisi sensor diubah.',
      'Memahami alur data dari sensor hingga ditampilkan oleh ESP32.',
    ],
    expectedResult: 
      'ESP32 dapat membaca suhu dan kelembapan dari DHT22, '
      'kemudian menampilkan hasil pembacaannya melalui Serial Monitor.',
    simulationInstruction: 
      'Buka menu Simulasi Pertemuan 2 untuk mengikuti langkah '
      'penambahan sensor DHT22, menyesuaikan program, dan menguji '
      'pembacaan data di Wokwi.',
  ),

  3: PreviewContent(
  title: 'Preview Pertemuan 4',
  nextMaterialOverview:
      'Pada pertemuan berikutnya, kamu akan mempelajari cara '
      'menyajikan data suhu dan kelembapan yang telah dikirim ke '
      'cloud melalui dashboard monitoring. Kamu akan mengenal cara '
      'menampilkan data dalam bentuk angka, tabel, atau grafik serta '
      'memahami bagaimana dashboard membantu pengguna memantau '
      'kondisi ruangan dengan lebih mudah.',
  caseStudyTitle: 'Mengirim Data Sensor ke Cloud',
  caseStudyDescription:
      'Pada pertemuan sebelumnya, kamu telah berhasil membaca '
      'suhu dan kelembapan menggunakan ESP32 dan DHT22. Namun, '
      'data tersebut masih ditampilkan melalui Serial Monitor. '
      'Pada proyek ini, kamu akan mempelajari cara mengirimkan '
      'data sensor melalui jaringan ke layanan cloud agar data '
      'dapat diterima dan dipantau melalui layanan tersebut.',
  learningPoints: [
    'Memahami alur pengiriman data dari sensor, ESP32, jaringan, hingga cloud.',
    'Mengenal konfigurasi koneksi dan protokol komunikasi yang digunakan.',
    'Menyesuaikan program agar data sensor dapat dikirim ke layanan cloud.',
    'Memeriksa apakah data berhasil diterima oleh layanan tujuan.',
    'Mengidentifikasi kemungkinan penyebab kegagalan pengiriman data.',
  ],
  expectedResult:
      'Proyek monitoring suhu dan kelembapan yang dapat membaca '
      'data dari sensor DHT22 dan mengirimkannya ke layanan cloud '
      'untuk diterima dan dipantau.',
  simulationInstruction:
      'Buka menu Simulasi Pertemuan 3 untuk mempelajari konfigurasi '
      'koneksi, mencoba pengiriman data, dan memeriksa hasilnya '
      'sesuai fasilitas simulasi yang disediakan.',
  ),

  4: PreviewContent(
    title: 'Tugas Akhir Pertemuan 4',
  nextMaterialOverview:
      'Pada tugas akhir ini, kamu akan menggabungkan materi '
      'dari Pertemuan 1 hingga Pertemuan 4 untuk mengembangkan '
      'sistem monitoring suhu dan kelembapan ruangan berbasis IoT. '
      'Proyek mencakup penggunaan ESP32 dan DHT22, pengiriman data '
      'ke layanan cloud, serta penyajian hasil pemantauan melalui '
      'dashboard monitoring.',
  caseStudyTitle: 'Sistem Monitoring Suhu dan Kelembapan Ruangan Berbasis IoT',
  caseStudyDescription:
      'Sebuah ruangan membutuhkan sistem pemantauan suhu dan '
      'kelembapan agar kondisinya dapat diamati dengan lebih mudah. '
      'Untuk memenuhi kebutuhan tersebut, kamu akan mengembangkan '
      'sistem monitoring berbasis IoT menggunakan ESP32 dan sensor DHT22.\n\n'
      'Proyek ini merupakan kelanjutan dari kegiatan pada empat '
      'pertemuan sebelumnya. Kamu akan menggabungkan pengendalian '
      'LED, pembacaan data sensor, pengiriman data ke layanan cloud, '
      'dan penyajian informasi melalui dashboard monitoring menjadi '
      'satu sistem yang saling terhubung.',
  learningPoints: [
    'Menggabungkan rangkaian ESP32 dan DHT22 untuk membaca suhu dan kelembapan.',
    'Mengintegrasikan pengendalian LED sesuai program yang dibuat.',
    'Menerapkan alur pengiriman data sensor ke layanan cloud.',
    'Menyajikan data pemantauan melalui dashboard.',
    'Menguji kesesuaian pembacaan sensor dan tampilan data.',
    'Menjelaskan alur kerja sistem monitoring yang dikembangkan.',
  ],
  expectedResult:
      'Satu proyek sistem monitoring suhu dan kelembapan ruangan '
      'berbasis IoT yang dikembangkan secara bertahap dari '
      'Pertemuan 1 hingga Pertemuan 4, dilengkapi rangkaian ESP32 '
      'dan DHT22, alur pengiriman data, dashboard monitoring, '
      'serta hasil pengujian sistem.',
  simulationInstruction:
      'Buka menu Simulasi Pertemuan 4 untuk mengembangkan dan '
      'menguji proyek akhir berdasarkan materi yang telah dipelajari. '
      'Periksa pembacaan sensor, alur pengiriman data, tampilan '
      'dashboard, dan kesesuaian hasil pengujian.',
  ),
};