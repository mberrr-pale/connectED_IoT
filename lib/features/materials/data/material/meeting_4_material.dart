import '../../models/lesson_section.dart';

const String meeting4Title = 'Dashboard Monitoring IoT';

const List<LessonSection> meeting4Sections = [
  LessonSection(
    title: 'Pengertian dan Fungsi Dashboard Monitoring',
    type: LessonSectionType.image,
    content:
        'Dashboard monitoring merupakan antarmuka yang digunakan '
        'untuk menampilkan data dari suatu sistem agar mudah '
        'diamati oleh pengguna.\n\n'
        'Dalam sistem IoT, dashboard dapat menampilkan data '
        'yang diterima dari perangkat atau layanan cloud. '
        'Pengguna dapat memanfaatkan informasi tersebut untuk '
        'memahami kondisi yang sedang dipantau dan melihat '
        'perubahan data dari waktu ke waktu.',
    imagePath: 'assets/images/materials/meeting_4/dashboard.png',
    caption: 'Contoh tampilan dashboard monitoring suhu dan kelembapan.',
  ),
  LessonSection(
    title: 'Bentuk Penyajian Data',
    type: LessonSectionType.image,
    content:
        'Data monitoring dapat ditampilkan melalui beberapa '
        'bentuk sesuai kebutuhan pengguna.\n\n'
        '• Angka: menampilkan nilai terbaru, misalnya suhu 28 °C.\n\n'
        '• Tabel: menampilkan sejumlah data beserta waktu '
        'pembacaannya.\n\n'
        '• Grafik garis: menunjukkan perubahan data dari waktu '
        'ke waktu.\n\n'
        '• Indikator: memberikan gambaran kondisi berdasarkan '
        'batas yang telah ditentukan.\n\n'
        'Angka cocok untuk melihat nilai saat ini, sedangkan '
        'grafik membantu pengguna memahami kecenderungan '
        'perubahan data.',
    imagePath: 'assets/images/materials/meeting_4/db_monitoring.png',
    caption: 'Contoh tampilan dashboard monitoring suhu dan kelembapan.',
  ),
  LessonSection(
    title: 'Membaca dan Menafsirkan Data Monitoring',
    type: LessonSectionType.text,
    content:
        'Data pada dashboard perlu dipahami, bukan hanya '
        'dilihat. Pengguna perlu mengamati nilai, waktu '
        'pembacaan, serta perubahan yang terjadi.\n\n'
        'Contohnya, apabila grafik suhu menunjukkan peningkatan '
        'dari 26 °C menjadi 29 °C, pengguna dapat menyimpulkan '
        'bahwa suhu meningkat pada rentang waktu yang ditampilkan.\n\n'
        'Namun, penyebab peningkatan suhu tidak dapat dipastikan '
        'hanya berdasarkan grafik tanpa informasi tambahan.',
  ),
  LessonSection(
    title: 'Hubungan Perangkat, Cloud, dan Dashboard',
    type: LessonSectionType.text,
    content:
        'Sistem monitoring IoT menghubungkan beberapa komponen '
        'yang memiliki fungsi berbeda.\n\n'
        '1. Sensor membaca suhu dan kelembapan.\n\n'
        '2. ESP32 membaca dan memproses data sensor.\n\n'
        '3. Jaringan dan protokol komunikasi mengirimkan data.\n\n'
        '4. Cloud atau layanan penerima mengelola data sesuai '
        'kemampuannya.\n\n'
        '5. Dashboard menampilkan data agar dapat diamati pengguna.\n\n'
        'Dengan demikian, dashboard bukanlah sensor atau '
        'mikrokontroler. Dashboard merupakan bagian penyajian '
        'informasi dari sistem monitoring.',
  ),
  LessonSection(
    title: 'Evaluasi dan Pemecahan Masalah',
    type: LessonSectionType.text,
    content:
        'Ketika dashboard tidak menampilkan data, pemeriksaan '
        'perlu dilakukan secara berurutan. Pastikan sensor '
        'menghasilkan data, ESP32 dapat membacanya, koneksi '
        'dan pengiriman berjalan, layanan penerima mendapatkan '
        'data, lalu dashboard menggunakan sumber data yang tepat.\n\n'
        'Langkah ini membantu peserta didik membedakan masalah '
        'pada pembacaan sensor, pengiriman data, penyimpanan, '
        'dan penyajian informasi.',
  ),
  LessonSection(
    title: 'Tahapan Pemeriksaan Sistem Monitoring',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'Periksa apakah sensor menghasilkan data suhu dan kelembapan.',
      'Pastikan ESP32 membaca data sensor dengan benar.',
      'Periksa koneksi jaringan dan proses pengiriman data.',
      'Pastikan layanan penerima mendapatkan data.',
      'Periksa apakah dashboard menggunakan sumber data yang tepat.',
      'Amati apakah nilai yang ditampilkan sesuai dengan data yang diterima.',
    ],
  ),
];
