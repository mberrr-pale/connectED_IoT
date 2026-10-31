import '../../models/lesson_section.dart';

const String meeting3Title = 'Cloud IoT Integration';

const List<LessonSection> meeting3Sections = [
  LessonSection(
    title: 'Pengertian dan Fungsi Cloud dalam IoT',
    type: LessonSectionType.image,
    content:
        'Cloud merupakan layanan komputasi yang dapat diakses '
        'melalui jaringan untuk menyimpan, mengolah, atau '
        'menyediakan data.\n\n'
        'Dalam sistem IoT, cloud dapat digunakan untuk menerima '
        'data dari perangkat, menyimpan riwayat pembacaan, dan '
        'menyediakan data agar dapat diakses oleh aplikasi lain.\n\n'
        'Contohnya, data suhu yang dibaca ESP32 dikirim ke '
        'layanan cloud. Data tersebut dapat disimpan sehingga '
        'pengguna dapat melihat perubahan suhu dari waktu ke waktu.',
    imagePath: 'assets/images/materials/meeting_3/gambarcloud.png',
    caption: 'Ilustrasi peran cloud dalam sistem monitoring IoT.',
  ),
  LessonSection(
    title: 'Alur Data dari Perangkat ke Cloud',
    type: LessonSectionType.text,
    content:
        'Dalam sistem monitoring, pengiriman data berlangsung '
        'melalui beberapa tahap. Sensor membaca suhu dan '
        'kelembapan, ESP32 mengambil serta mengolah data, '
        'kemudian perangkat terhubung ke jaringan yang diperlukan.\n\n'
        'Program mengirimkan data menggunakan protokol yang '
        'sesuai. Layanan cloud kemudian menerima data dan '
        'menyimpannya jika fitur penyimpanan tersedia.\n\n'
        'Apabila salah satu tahap mengalami masalah, data '
        'mungkin tidak muncul di layanan cloud meskipun sensor '
        'berhasil membaca kondisi lingkungan.\n\n'
        'Alur sederhana: DHT22 → ESP32 → Wi-Fi → Protokol '
        'Komunikasi → Cloud.',
  ),
  LessonSection(
    title: 'Koneksi Perangkat ke Jaringan',
    type: LessonSectionType.text,
    content:
        'Perangkat IoT membutuhkan koneksi jaringan untuk '
        'mengirimkan data ke layanan lain. Pada ESP32 yang '
        'mendukung Wi-Fi, program harus mengatur koneksi ke '
        'jaringan yang sesuai.\n\n'
        'Beberapa hal yang perlu diperiksa ketika koneksi '
        'bermasalah adalah konfigurasi jaringan, status '
        'koneksi, alamat layanan tujuan, dan pengaturan '
        'komunikasi.',
  ),
  LessonSection(
    title: 'Pengiriman Data Menggunakan Protokol',
    type: LessonSectionType.text,
    content:
        'Data dapat dikirim menggunakan protokol komunikasi '
        'yang sesuai dengan layanan yang dipakai. Dua contoh '
        'pendekatan yang sering digunakan dalam sistem IoT '
        'adalah HTTP dan MQTT.\n\n'
        'HTTP (Hypertext Transfer Protocol) digunakan untuk '
        'komunikasi antara klien dan layanan web. ESP32 dapat '
        'mengirimkan data ke endpoint web sesuai aturan layanan.\n\n'
        'MQTT (Message Queuing Telemetry Transport) menggunakan '
        'mekanisme publish-subscribe. Perangkat mengirim pesan '
        'melalui broker, kemudian pesan diteruskan kepada '
        'subscriber yang berlangganan pada topic terkait.\n\n'
        'Pemilihan protokol harus disesuaikan dengan dukungan '
        'dan konfigurasi layanan cloud.',
  ),
  LessonSection(
    title: 'Perbedaan HTTP dan MQTT',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'HTTP: menggunakan pola permintaan dan respons antara klien dan layanan.',
      'MQTT: menggunakan mekanisme publish-subscribe melalui broker.',
      'HTTP: data dikirim ke endpoint layanan web yang sesuai.',
      'MQTT: pesan diterbitkan ke topic dan diterima oleh subscriber yang sesuai.',
      'Keduanya membutuhkan konfigurasi yang sesuai dengan layanan penerima.',
    ],
  ),
  LessonSection(
    title: 'Penerimaan dan Penyimpanan Data',
    type: LessonSectionType.text,
    content:
        'Setelah data dikirim, layanan cloud perlu menerima '
        'data sesuai format dan aturan yang ditentukan. Jika '
        'layanan mendukung penyimpanan, data dapat disimpan '
        'dan digunakan untuk menampilkan riwayat pembacaan '
        'atau melakukan analisis berikutnya.\n\n'
        'Sebagai contoh, data suhu dapat dikirim secara berkala '
        'sehingga perubahan suhu ruangan dapat diamati '
        'sepanjang waktu. Fitur penyimpanan riwayat bergantung '
        'pada kemampuan dan konfigurasi layanan yang digunakan.',
  ),
  LessonSection(
    title: 'Analisis Masalah Pengiriman Data',
    type: LessonSectionType.text,
    content:
        'Data yang tidak muncul pada cloud belum tentu '
        'disebabkan oleh sensor yang rusak. Gangguan dapat '
        'terjadi pada tahap pembacaan sensor, koneksi jaringan, '
        'pengiriman data, maupun penerimaan oleh layanan cloud.\n\n'
        'Pemeriksaan perlu dilakukan secara bertahap agar '
        'sumber masalah dapat diketahui dengan lebih tepat.',
  ),
  LessonSection(
    title: 'Langkah Pemeriksaan Pengiriman Data',
    type: LessonSectionType.bulletList,
    bulletItems: [
      'Pastikan sensor menghasilkan data dengan benar.',
      'Periksa apakah ESP32 berhasil membaca data sensor.',
      'Periksa status koneksi jaringan.',
      'Pastikan alamat layanan atau endpoint sudah sesuai.',
      'Periksa protokol dan format data yang dikirim.',
      'Pastikan autentikasi dan izin akses sudah benar.',
      'Pastikan layanan cloud menerima data yang dikirim.',
    ],
  ),
];
