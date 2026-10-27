import '../models/lesson_section.dart';

const String meeting1Title = 'Konsep IoT dan Mikrokontroler';

const List<String> meeting1Objectives = [
  'Menjelaskan pengertian dan karakteristik Internet of Things (IoT).',
  'Mengidentifikasi komponen utama dalam sistem IoT.',
  'Menjelaskan pengertian dan fungsi mikrokontroler.',
  'Mengenal ESP32 sebagai perangkat dalam sistem IoT.',
  'Memahami dasar program setup(), loop(), dan output sederhana.',
];

const List<LessonSection> meeting1Sections = [
  LessonSection(
    title: 'Pengertian dan Karakteristik IoT',
    type: LessonSectionType.text,
    content:
        'Internet of Things (IoT) adalah konsep yang memungkinkan '
        'perangkat fisik terhubung ke jaringan untuk mengumpulkan, '
        'mengirim, dan bertukar data. Sistem IoT dapat digunakan untuk '
        'pemantauan maupun pengendalian perangkat dari jarak jauh.',
  ),
  LessonSection(
    title: 'Karakteristik dan Penerapan IoT',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'Konektivitas: perangkat dapat terhubung melalui jaringan.',
      'Sensor: sistem dapat membaca kondisi lingkungan.',
      'Pertukaran data: data dapat dikirim dan diolah.',
      'Otomatisasi: tindakan dapat dijalankan berdasarkan kondisi tertentu.',
      'Contoh: pemantauan suhu, lampu pintar, dan penyiraman tanaman otomatis.',
    ],
  ),
  LessonSection(
    title: 'Komponen Utama Sistem IoT',
    type: LessonSectionType.image,
    content:
        'Sistem IoT umumnya melibatkan sensor atau aktuator, '
        'mikrokontroler, konektivitas jaringan, serta aplikasi '
        'atau platform untuk memantau data.',
    imagePath: 'assets/images/materials/meeting_1/komponen_iot.png',
    caption: 'Ilustrasi komponen utama sistem IoT.',
  ),
  LessonSection(
    title: 'Pengertian dan Fungsi Mikrokontroler',
    type: LessonSectionType.image,
    content:
        'Mikrokontroler adalah rangkaian terpadu yang dapat diprogram '
        'untuk membaca masukan, memproses instruksi, dan mengendalikan '
        'keluaran. Mikrokontroler sering digunakan sebagai pengendali '
        'utama pada perangkat IoT.',
    imagePath: 'assets/images/materials/meeting_1/struktur_mikrokontroler.png',
    caption: 'Ilustrasi struktur mikrokontroler.',
  ),
  LessonSection(
    title: 'Mengenal ESP32',
    type: LessonSectionType.text,
    content:
        'ESP32 adalah keluarga mikrokontroler yang banyak digunakan '
        'dalam proyek IoT. Varian ESP32 tertentu menyediakan konektivitas '
        'Wi-Fi dan Bluetooth sehingga dapat digunakan untuk mengirim '
        'data sensor atau menerima perintah dari aplikasi.',
  ),
  LessonSection(
    title: 'Dasar Program: setup() dan loop()',
    type: LessonSectionType.text,
    content:
        'Dalam pemrograman ESP32 menggunakan Arduino '
        'framework, terdapat dua fungsi utama yang perlu '
        'dipahami.\n\n'
        '• setup() dijalankan satu kali ketika program '
        'mulai berjalan. Fungsi ini biasanya digunakan '
        'untuk menyiapkan pin dan komunikasi serial.\n\n'
        '• loop() dijalankan berulang kali selama perangkat '
        'aktif. Fungsi ini digunakan untuk menjalankan '
        'instruksi yang perlu diulang.\n\n'
        '• Output merupakan hasil tindakan dari program, '
        'misalnya LED menyala atau mati.\n\n'
        'Sebagai contoh, ESP32 dapat diprogram untuk '
        'menyalakan LED selama satu detik, kemudian '
        'mematikannya selama satu detik. Proses tersebut '
        'berulang sehingga LED berkedip.',
  ),
];
