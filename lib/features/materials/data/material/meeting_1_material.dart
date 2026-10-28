import '../../models/lesson_section.dart';

const String meeting1Title = 'Konsep IoT dan Mikrokontroler';

const List<LessonSection> meeting1Sections = [
  LessonSection(
    title: 'Pengertian Internet of Things (IoT)',
    type: LessonSectionType.text,
    content:
        'Internet of Things (IoT) adalah konsep menghubungkan '
        'perangkat fisik ke jaringan agar perangkat dapat '
        'mengumpulkan, bertukar, atau mengirimkan data. Data '
        'tersebut dapat digunakan untuk memantau kondisi atau '
        'menjalankan tindakan tertentu.\n\n'
        'Contohnya, sistem monitoring suhu ruangan dapat '
        'membaca suhu melalui sensor, memproses data menggunakan '
        'ESP32, lalu mengirimkannya ke aplikasi untuk dipantau.',
  ),
  LessonSection(
    title: 'Karakteristik dan Contoh Penerapan IoT',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'Perangkat fisik: memiliki komponen yang dapat membaca kondisi atau melakukan tindakan.',
      'Pengumpulan data: perangkat dapat memperoleh data dari lingkungan melalui sensor.',
      'Konektivitas: perangkat dapat berkomunikasi melalui jaringan.',
      'Pemanfaatan data: data digunakan untuk pemantauan, analisis, atau pengendalian.',
      'Lampu pintar: lampu dapat dikendalikan melalui aplikasi.',
      'Monitoring suhu ruangan: suhu dan kelembapan dapat dipantau melalui perangkat digital.',
      'Penyiraman tanaman otomatis: sistem mengatur penyiraman berdasarkan kondisi tanah.',
      'Monitoring mesin industri: sensor membantu memantau kondisi mesin.',
    ],
  ),
  LessonSection(
    title: 'Komponen Utama Sistem IoT',
    type: LessonSectionType.text,
    content:
        'Sistem IoT terdiri dari beberapa komponen yang saling '
        'terhubung dan bekerja sama untuk mengumpulkan, memproses, '
        'mengirimkan, serta menyajikan data. Komponen utama yang '
        'dibahas meliputi mikrokontroler, sensor, jaringan '
        'komunikasi, cloud, dan dashboard.',
  ),
  LessonSection(
    title: 'Mikrokontroler dalam Sistem IoT',
    type: LessonSectionType.image,
    content:
        'Mikrokontroler berfungsi sebagai pusat kendali yang '
        'menjalankan program untuk menerima masukan, memproses '
        'data, dan mengendalikan komponen lain. ESP32 memiliki '
        'konektivitas Wi-Fi dan Bluetooth pada banyak variannya '
        'sehingga cocok untuk proyek IoT.',
    imagePath: 'assets/images/materials/meeting_1/mikrokontroler.png',
    caption: 'Ilustrasi mikrokontroler sebagai pusat kendali sistem IoT.',
  ),
  LessonSection(
    title: 'Sensor',
    type: LessonSectionType.image,
    content:
        'Sensor adalah komponen yang berfungsi mendeteksi atau '
        'mengukur kondisi fisik di lingkungan, kemudian mengubah '
        'hasil pengukuran menjadi sinyal yang dapat dibaca oleh '
        'sistem. Jenis sensor bergantung pada kondisi yang ingin '
        'diketahui, seperti suhu, kelembapan, cahaya, atau gerakan.\n\n'
        'Dalam proyek connectEdIoT, sensor DHT22 digunakan untuk '
        'membaca suhu dan kelembapan ruangan.',
    imagePath: 'assets/images/materials/meeting_1/sensor.png',
    caption: 'Ilustrasi sensor untuk membaca kondisi lingkungan.',
  ),
  LessonSection(
    title: 'Jaringan Komunikasi',
    type: LessonSectionType.image,
    content:
        'Jaringan komunikasi menjadi jalur untuk mengirimkan '
        'data dari perangkat ke perangkat atau layanan lain. '
        'Salah satu jaringan yang sering digunakan dalam IoT '
        'adalah Wi-Fi.\n\n'
        'Sebagai contoh, ESP32 menggunakan Wi-Fi untuk mengirimkan '
        'data suhu dan kelembapan ke layanan cloud. Pengiriman '
        'data mengikuti protokol komunikasi yang digunakan.',
    imagePath: 'assets/images/materials/meeting_1/jaringan.png',
    caption: 'Ilustrasi jaringan komunikasi pada sistem IoT.',
  ),
  LessonSection(
    title: 'Cloud dan Dashboard',
    type: LessonSectionType.image,
    content:
        'Cloud merupakan layanan yang dapat menerima dan menyimpan '
        'data dari perangkat IoT. Dashboard adalah tampilan yang '
        'menyajikan data agar pengguna lebih mudah membaca dan '
        'memantau kondisi perangkat atau lingkungan.\n\n'
        'Data dapat disajikan dalam bentuk angka, tabel, maupun '
        'grafik sehingga perubahan kondisi lebih mudah dipahami.',
    imagePath: 'assets/images/materials/meeting_1/cloud_dashboard.png',
    caption: 'Ilustrasi cloud dan dashboard monitoring IoT.',
  ),

  LessonSection(
    title: 'Pengertian dan Fungsi Mikrokontroler',
    type: LessonSectionType.text,
    content:
        'Mikrokontroler adalah sirkuit terpadu berukuran kecil '
        'yang dirancang untuk menjalankan fungsi pengendalian '
        'tertentu. Di dalamnya terdapat unit pemroses, memori, '
        'serta antarmuka input/output yang digunakan untuk '
        'menerima masukan dan mengendalikan komponen lain.\n\n'
        'Berbeda dengan komputer pribadi yang dirancang untuk '
        'beragam kebutuhan, mikrokontroler umumnya diprogram '
        'untuk menjalankan tugas tertentu pada sistem elektronik.',
  ),
  LessonSection(
    title: 'Struktur Internal Mikrokontroler',
    type: LessonSectionType.image,
    content:
        'Mikrokontroler mengintegrasikan beberapa bagian penting '
        'dalam satu chip, seperti CPU untuk menjalankan instruksi, '
        'memori untuk menyimpan program dan data, serta port '
        'input/output untuk berkomunikasi dengan komponen luar.\n\n'
        'Mikrokontroler tertentu juga memiliki timer, counter, '
        'ADC, dan antarmuka komunikasi. Ketersediaan fitur '
        'bergantung pada jenis mikrokontrolernya.',
    imagePath: 'assets/images/materials/meeting_1/struktur_mikrokontroler.png',
    caption: 'Ilustrasi struktur internal mikrokontroler.',
  ),
  LessonSection(
    title: 'Fungsi Pendukung Mikrokontroler',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'Timer: mengatur interval waktu atau durasi suatu proses.',
      'Counter: menghitung kejadian atau pulsa yang diterima.',
      'Pembangkit osilasi: menyediakan sumber clock untuk pengaturan waktu kerja sistem.',
      'Decoder dan encoder: mengubah representasi informasi sesuai kebutuhan sistem.',
      'Flip-flop: menyimpan satu bit informasi dalam rangkaian digital.',
      'ADC (Analog-to-Digital Converter): mengubah sinyal analog menjadi nilai digital.',
    ],
  ),

  LessonSection(
    title: 'ESP32',
    type: LessonSectionType.image,
    content:
        'ESP32 adalah keluarga mikrokontroler yang dapat '
        'diprogram untuk mengendalikan perangkat elektronik. '
        'Banyak variannya memiliki Wi-Fi dan Bluetooth sehingga '
        'cocok digunakan untuk proyek IoT yang membutuhkan '
        'koneksi nirkabel.\n\n'
        'Pada connectEdIoT, ESP32 digunakan untuk membaca data '
        'sensor, menjalankan instruksi, dan mengirimkan data '
        'ke layanan lain melalui jaringan.',
    imagePath: 'assets/images/materials/meeting_1/esp32.png',
    caption: 'Contoh papan pengembangan ESP32.',
  ),
  LessonSection(
    title: 'ATmega328P',
    type: LessonSectionType.image,
    content:
        'ATmega328P merupakan mikrokontroler 8-bit yang digunakan '
        'pada Arduino Uno R3 versi klasik. Mikrokontroler ini '
        'memiliki pin input/output untuk membaca masukan dan '
        'mengendalikan komponen seperti LED, buzzer, dan motor.\n\n'
        'ATmega328P cocok untuk proyek elektronik dasar yang '
        'tidak membutuhkan konektivitas jaringan bawaan.',
    imagePath: 'assets/images/materials/meeting_1/atmega328p.png',
    caption: 'Contoh mikrokontroler ATmega328P.',
  ),
  LessonSection(
    title: 'STM32',
    type: LessonSectionType.image,
    content:
        'STM32 adalah keluarga mikrokontroler 32-bit berbasis '
        'ARM Cortex-M yang dikembangkan oleh STMicroelectronics. '
        'Fitur yang tersedia berbeda menurut tipenya dan dapat '
        'mencakup timer, komunikasi serial, serta ADC.\n\n'
        'STM32 banyak digunakan pada sistem kendali, pembacaan '
        'sensor, robotika, dan otomasi yang membutuhkan beragam '
        'kemampuan pemrosesan.',
    imagePath: 'assets/images/materials/meeting_1/stm32.png',
    caption: 'Contoh papan pengembangan STM32.',
  ),

  LessonSection(
    title: 'Mengenal ESP32 sebagai Perangkat Pengendali',
    type: LessonSectionType.text,
    content:
        'ESP32 dapat dipahami sebagai pusat kendali dalam '
        'sebuah sistem elektronik. Perangkat ini menerima input '
        'dari sensor, memproses data sesuai program, lalu '
        'memberikan perintah kepada komponen lain.\n\n'
        'Sebagai contoh, sensor suhu membaca kondisi ruangan. '
        'ESP32 memproses data tersebut, kemudian mengirimkannya '
        'ke aplikasi atau website melalui Wi-Fi.',
  ),
  LessonSection(
    title: 'Fungsi dan Penerapan ESP32',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'Kontrol lampu otomatis: mengendalikan lampu berdasarkan program atau kondisi tertentu.',
      'Pembacaan sensor: menerima data dari sensor suhu, kelembapan, cahaya, dan sensor lainnya.',
      'Absensi RFID: memproses data kartu dari pembaca RFID untuk sistem absensi.',
      'Robotika sederhana: mengatur gerakan atau fungsi robot melalui program.',
      'Monitoring jarak jauh: mengirim data sensor ke layanan digital melalui jaringan.',
      'Otomatisasi: menjalankan tindakan berdasarkan data atau aturan yang telah ditentukan.',
    ],
  ),
  LessonSection(
    title: 'Alur Kerja ESP32 dalam Sistem Monitoring',
    type: LessonSectionType.text,
    content:
        'Pada sistem monitoring ruangan, sensor DHT22 membaca '
        'suhu dan kelembapan. ESP32 menerima data tersebut, '
        'kemudian mengirimkannya melalui Wi-Fi ke layanan cloud. '
        'Dashboard menyajikan data agar pengguna dapat memantau '
        'kondisi ruangan.\n\n'
        'Alur ini menjadi dasar proyek yang akan dikembangkan '
        'secara bertahap pada pertemuan berikutnya.',
  ),

  LessonSection(
    title: 'Dasar Program: setup(), loop(), dan Output',
    type: LessonSectionType.text,
    content:
        'Dalam pemrograman ESP32 menggunakan Arduino framework, '
        'terdapat dua fungsi utama yang perlu dipahami.\n\n'
        'setup() dijalankan satu kali ketika program mulai '
        'berjalan. Fungsi ini biasanya digunakan untuk menyiapkan '
        'pin dan komunikasi serial.\n\n'
        'loop() dijalankan berulang kali selama perangkat aktif. '
        'Fungsi ini digunakan untuk menjalankan instruksi yang '
        'perlu diulang.\n\n'
        'Output merupakan hasil tindakan dari program, misalnya '
        'LED menyala atau mati. ESP32 dapat mengendalikan output '
        'sesuai instruksi yang ditulis pada program.',
  ),
  LessonSection(
    title: 'Contoh Output: LED Berkedip',
    type: LessonSectionType.text,
    content:
        'LED berkedip merupakan contoh sederhana untuk memahami '
        'cara kerja program pada ESP32. Program mengatur pin LED '
        'sebagai output, menyalakan LED selama satu detik, lalu '
        'mematikannya selama satu detik. Proses ini terus '
        'berulang selama perangkat aktif.\n\n'
        'Pada contoh ini, setup() digunakan untuk mengatur pin '
        'LED, sedangkan loop() menjalankan perintah menyalakan '
        'dan mematikan LED secara berulang.',
  ),
];
