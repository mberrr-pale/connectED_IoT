import '../../models/lesson_section.dart';

const String meeting2Title = 'Sensor dan Komunikasi IoT';

const List<LessonSection> meeting2Sections = [
  LessonSection(
    title: 'Pengertian dan Fungsi Sensor',
    type: LessonSectionType.text,
    content:
        'Sensor merupakan komponen yang mendeteksi kondisi '
        'fisik lingkungan dan menghasilkan data yang dapat '
        'dibaca oleh perangkat elektronik.\n\n'
        'Dalam sistem IoT, sensor berfungsi sebagai sumber '
        'data. Data yang dihasilkan digunakan oleh '
        'mikrokontroler untuk memantau kondisi atau menentukan '
        'tindakan tertentu.',
  ),
  LessonSection(
    title: 'Jenis-jenis Sensor',
    type: LessonSectionType.text,
    content:
        'Beberapa sensor yang umum digunakan dalam proyek IoT '
        'antara lain sensor suhu dan kelembapan, sensor cahaya, '
        'sensor jarak, dan sensor gerak. Setiap sensor memiliki '
        'fungsi dan cara kerja yang berbeda sesuai dengan '
        'kondisi yang ingin diketahui.',
  ),
  LessonSection(
    title: 'Sensor Suhu dan Kelembapan',
    type: LessonSectionType.image,
    content:
        'Sensor suhu digunakan untuk mengukur tingkat panas '
        'atau dinginnya suatu lingkungan, sedangkan sensor '
        'kelembapan digunakan untuk mengukur kadar uap air '
        'di udara atau kandungan air pada media tertentu, '
        'bergantung pada jenis sensornya.\n\n'
        'Contoh sensor suhu dan kelembapan udara adalah DHT22. '
        'Sensor ini memberikan data suhu dan kelembapan kepada '
        'mikrokontroler untuk diproses lebih lanjut.',
    imagePath: 'assets/images/materials/meeting_2/sensor_dht22.png',
    caption: 'Ilustrasi sensor DHT22 untuk membaca suhu dan kelembapan udara.',
  ),
  LessonSection(
    title: 'Sensor Cahaya',
    type: LessonSectionType.image,
    content:
        'Sensor cahaya merupakan komponen yang mendeteksi '
        'tingkat cahaya yang diterima dari lingkungan '
        'sekitarnya. Salah satu contohnya adalah LDR '
        '(Light Dependent Resistor), yaitu komponen yang '
        'nilai resistansinya berubah sesuai dengan intensitas '
        'cahaya.\n\n'
        'Perubahan tersebut dapat dibaca oleh rangkaian '
        'elektronik atau mikrokontroler. Sensor cahaya sering '
        'digunakan pada lampu otomatis yang menyala ketika '
        'lingkungan mulai gelap.',
    imagePath: 'assets/images/materials/meeting_2/sensor_ldr.png',
    caption: 'Ilustrasi LDR sebagai sensor pendeteksi intensitas cahaya.',
  ),
  LessonSection(
    title: 'Sensor Jarak',
    type: LessonSectionType.image,
    content:
        'Sensor jarak digunakan untuk mengukur jarak antara '
        'sensor dan suatu objek. Salah satu contohnya adalah '
        'HC-SR04, yang menggunakan gelombang ultrasonik untuk '
        'memperkirakan jarak objek berdasarkan waktu tempuh '
        'gelombang yang dipantulkan kembali.\n\n'
        'Hasil pengukuran dapat dibaca dan diproses oleh '
        'mikrokontroler. Sensor ini digunakan pada robot '
        'penghindar rintangan, alat ukur jarak, dan sistem parkir.',
    imagePath: 'assets/images/materials/meeting_2/sensor_hc_sr04.png',
    caption: 'Ilustrasi sensor ultrasonik HC-SR04.',
  ),
  LessonSection(
    title: 'Sensor Gerak',
    type: LessonSectionType.image,
    content:
        'Sensor gerak digunakan untuk mendeteksi adanya '
        'pergerakan di area tertentu. Salah satu contohnya '
        'adalah PIR (Passive Infrared), yang mendeteksi '
        'perubahan radiasi inframerah dari objek, seperti '
        'manusia, di sekitarnya.\n\n'
        'Sensor ini tidak mengukur jarak secara langsung, '
        'tetapi memberikan sinyal ketika mendeteksi perubahan '
        'yang sesuai dengan karakteristiknya.',
    imagePath: 'assets/images/materials/meeting_2/sensor_pir.png',
    caption: 'Ilustrasi sensor PIR untuk mendeteksi pergerakan.',
  ),
  LessonSection(
    title: 'Sensor yang Digunakan dalam Proyek',
    type: LessonSectionType.text,
    content:
        'Pada proyek pembelajaran connectEdIoT, sensor yang '
        'digunakan adalah DHT22 untuk membaca suhu dan '
        'kelembapan udara. Data tersebut akan diproses oleh '
        'ESP32 dan menjadi dasar sistem monitoring ruangan '
        'yang dikembangkan pada pertemuan berikutnya.',
  ),
  LessonSection(
    title: 'Cara Sensor Membaca Kondisi Lingkungan',
    type: LessonSectionType.text,
    content:
        'Sensor membaca kondisi tertentu dan mengubahnya '
        'menjadi data yang dapat diproses oleh mikrokontroler. '
        'Jenis data dan cara pembacaannya bergantung pada '
        'sensor yang digunakan.\n\n'
        'Pada sensor DHT22, data suhu dan kelembapan dapat '
        'dibaca oleh ESP32 melalui koneksi pin dan program '
        'yang sesuai.',
  ),
  LessonSection(
    title: 'Alur Pembacaan Data Sensor',
    type: LessonSectionType.image,
    content:
        'Alur sederhana pembacaan data pada proyek ini adalah '
        'sensor DHT22 membaca suhu dan kelembapan, ESP32 '
        'memproses hasil pembacaan, kemudian data ditampilkan '
        'melalui Serial Monitor.\n\n'
        'Alur pembacaan sensor: DHT22 → ESP32 → Serial Monitor.',
    imagePath: 'assets/images/materials/meeting_2/alur_sensor.png',
    caption: 'Contoh Ilustrasi Alur Pembacaan Suhu menggunakan Arduino.',    
  ),
  LessonSection(
    title: 'Mengenal Serial Monitor',
    type: LessonSectionType.text,
    content:
        'Serial Monitor merupakan fasilitas pada Arduino IDE '
        'yang digunakan untuk menampilkan pesan atau data '
        'dari program saat perangkat berjalan.\n\n'
        'Fasilitas ini membantu peserta didik memeriksa '
        'apakah sensor dan program bekerja dengan benar. '
        'Contohnya, nilai suhu dan kelembapan dari DHT22 '
        'dapat ditampilkan untuk memastikan proses pembacaan '
        'sensor berjalan sesuai harapan.',
  ),
  LessonSection(
    title: 'Pengertian Protokol Komunikasi IoT',
    type: LessonSectionType.text,
    content:
        'Protokol komunikasi adalah aturan yang digunakan '
        'perangkat untuk bertukar data. Protokol membantu '
        'menentukan bagaimana data dikirim, diterima, dan '
        'dipahami oleh perangkat yang berkomunikasi.\n\n'
        'Salah satu protokol yang banyak digunakan dalam IoT '
        'adalah MQTT (Message Queuing Telemetry Transport). '
        'MQTT dirancang untuk pertukaran pesan dengan '
        'mekanisme publish-subscribe.',
  ),
  LessonSection(
    title: 'Ilustrasi Komunikasi MQTT',
    type: LessonSectionType.image,
    content:
        'MQTT menggunakan mekanisme publish-subscribe. '
        'Publisher mengirim pesan ke broker melalui topic '
        'tertentu. Broker kemudian meneruskan pesan tersebut '
        'kepada subscriber yang berlangganan pada topic '
        'yang sesuai.\n\n'
        'Sebagai contoh, ESP32 dapat mengirimkan data suhu '
        'ke topic ruangan/suhu. Aplikasi yang berlangganan '
        'pada topic tersebut dapat menerima pesan yang dikirimkan.',
        imagePath: 'assets/images/materials/meeting_2/ilustrasi_MQTT.png',
    caption: 'Ilustrasi komunikasi MQTT.',
  ),
  LessonSection(
    title: 'Komponen Utama pada Komunikasi MQTT',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'Publisher: perangkat atau aplikasi yang mengirim pesan.',
      'Broker: pihak perantara yang menerima dan meneruskan pesan.',
      'Subscriber: perangkat atau aplikasi yang berlangganan untuk menerima pesan.',
      'Topic: nama atau jalur pesan yang digunakan untuk mengelompokkan informasi.',
    ],
  ),
  LessonSection(
    title: 'Contoh Penggunaan MQTT pada Sistem Monitoring',
    type: LessonSectionType.text,
    content:
        'Pada sistem monitoring ruangan, ESP32 dapat '
        'mengirimkan data suhu ke topic ruangan/suhu melalui '
        'broker MQTT. Aplikasi yang berlangganan pada topic '
        'tersebut dapat menerima data untuk ditampilkan '
        'pada dashboard.\n\n'
        'Perlu dibedakan bahwa membaca sensor dan menampilkan '
        'data pada Serial Monitor belum berarti data sudah '
        'dikirim melalui MQTT. Pengiriman MQTT membutuhkan '
        'koneksi jaringan dan konfigurasi broker yang sesuai.',
  ),
];
