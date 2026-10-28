import '../models/simulation_case.dart';

const List<SimulationCase> simulationCases = [
  SimulationCase(
    id: 'meeting1_led_blink',
    meetingNumber: 1,
    title: 'Indikator Aktivitas Sistem Monitoring Ruangan',
    description:
        'Membuat LED berkedip menggunakan ESP32 sebagai '
        'pengenalan output pada sistem IoT.',
    scenario:
        'Sebuah ruangan akan dilengkapi sistem monitoring suhu. '
        'Sebelum menambahkan sensor, kamu diminta mengenal ESP32 '
        'sebagai perangkat pengendali dengan membuat indikator '
        'aktivitas menggunakan LED.',
    tasks: [
      'Buka proyek baru ESP32 di Wokwi.',
      'Identifikasi ESP32, LED, dan hubungan pin yang digunakan.',
      'Buat program agar LED menyala selama satu detik dan mati '
          'selama satu detik secara berulang.',
      'Jalankan simulasi dan amati perubahan kondisi LED.',
      'Jelaskan fungsi ESP32 serta hubungan program dengan output LED.',
    ],
    targetResult:
        'Simulasi LED berkedip berhasil dijalankan. Kamu memahami '
        'cara ESP32 mengendalikan output melalui program.',
    steps: [
      SimulationStep(
        title: '1. Membuat proyek ESP32',
        description:
            'Buka Wokwi melalui tautan yang tersedia, pilih proyek '
            'baru ESP32, lalu kenali area rangkaian dan editor kode. '
            'Pastikan board ESP32 sudah tersedia sebelum melanjutkan.',
      ),
      SimulationStep(
        title: '2. Menambahkan dan menghubungkan LED',
        description:
            'Tambahkan LED dan resistor ke rangkaian. Hubungkan '
            'anoda LED melalui resistor ke GPIO 13 dan katodanya '
            'ke GND. Periksa kembali jalur koneksi sebelum menjalankan '
            'simulasi.',
      ),
      SimulationStep(
        title: '3. Memahami dan menulis program',
        description:
            'Buat konstanta ledPin dengan nilai 13. Pada setup(), '
            'atur pin tersebut sebagai OUTPUT. Pada loop(), gunakan '
            'digitalWrite(HIGH) untuk menyalakan LED, delay(1000) '
            'untuk menunggu satu detik, kemudian digitalWrite(LOW) '
            'dan delay(1000) untuk mematikannya selama satu detik.',
      ),
      SimulationStep(
        title: '4. Menjalankan simulasi',
        description:
            'Tekan Start Simulation. Amati LED selama beberapa '
            'siklus. LED seharusnya menyala selama satu detik dan '
            'mati selama satu detik secara berulang.',
      ),
      SimulationStep(
        title: '5. Memeriksa hasil dan memperbaiki kesalahan',
        description:
            'Jika LED tidak berkedip, periksa apakah GPIO pada '
            'program sesuai dengan pin rangkaian, apakah LED dan '
            'resistor terhubung dengan benar, serta apakah program '
            'berhasil dijalankan tanpa kesalahan.',
      ),
      SimulationStep(
        title: '6. Menyimpulkan hasil',
        description:
            'Jelaskan bahwa ESP32 menjalankan instruksi program '
            'untuk mengatur output. LED menjadi indikator visual '
            'bahwa perintah pada program sedang dijalankan.',
      ),
    ],
    code: '''
const int ledPin = 13;

void setup() {
  pinMode(ledPin, OUTPUT);
}

void loop() {
  digitalWrite(ledPin, HIGH);
  delay(1000);

  digitalWrite(ledPin, LOW);
  delay(1000);
}
''',
    wokwiUrl: 'https://wokwi.com/projects/new/esp32',
  ),

  SimulationCase(
    id: 'meeting2_dht22_monitoring',
    meetingNumber: 2,
    title: 'Menambahkan Sensor Suhu dan Kelembapan',
    description:
        'Mengembangkan proyek ESP32 sebelumnya dengan sensor '
        'DHT22 untuk membaca suhu dan kelembapan ruangan.',
    scenario:
        'Pada pertemuan sebelumnya, kamu telah menggunakan ESP32 '
        'untuk mengendalikan LED. Selanjutnya, sistem dikembangkan '
        'dengan menambahkan sensor DHT22 agar perangkat dapat '
        'membaca kondisi suhu dan kelembapan ruangan.',
    tasks: [
      'Buka kembali proyek ESP32 dari pertemuan pertama.',
      'Tambahkan sensor DHT22 pada rangkaian.',
      'Sesuaikan hubungan pin dan program agar ESP32 dapat '
          'membaca data sensor.',
      'Jalankan simulasi dan tampilkan nilai suhu serta '
          'kelembapan pada Serial Monitor.',
      'Ubah kondisi suhu atau kelembapan pada simulasi, '
          'kemudian amati perubahan data.',
      'Jelaskan alur pembacaan data dari sensor DHT22 '
          'hingga ditampilkan oleh ESP32.',
    ],
    targetResult:
        'Kamu berhasil mengembangkan proyek sebelumnya dengan '
        'menambahkan sensor DHT22 dan menampilkan data suhu serta '
        'kelembapan melalui Serial Monitor.',
    steps: [
      SimulationStep(
        title: '1. Membuka proyek sebelumnya',
        description:
            'Buka proyek ESP32 dari Pertemuan 1 di Wokwi. '
            'Pertahankan rangkaian LED dan program yang sudah dibuat. '
            'Jika proyek belum tersimpan, buat kembali rangkaian '
            'ESP32 dan LED seperti pada pertemuan sebelumnya.',
      ),
      SimulationStep(
        title: '2. Menambahkan sensor DHT22',
        description:
            'Tambahkan komponen DHT22 melalui menu pemilihan '
            'komponen Wokwi. Sensor ini memiliki pin VCC, GND, '
            'dan DATA. Kenali fungsi setiap pin sebelum '
            'menghubungkannya ke ESP32.',
      ),
      SimulationStep(
        title: '3. Menghubungkan sensor ke ESP32',
        description:
            'Hubungkan VCC DHT22 ke sumber tegangan yang sesuai, '
            'GND ke GND ESP32, dan DATA ke GPIO 15. Pastikan '
            'nomor GPIO pada rangkaian sama dengan pin yang '
            'digunakan dalam program.',
      ),
      SimulationStep(
        title: '4. Menyiapkan program pembacaan sensor',
        description:
            'Tambahkan pustaka DHT dan buat objek sensor dengan '
            'tipe DHT22. Pada setup(), jalankan Serial.begin(115200) '
            'dan dht.begin(). Pada loop(), gunakan '
            'readTemperature() untuk membaca suhu dan readHumidity() '
            'untuk membaca kelembapan.',
      ),
      SimulationStep(
        title: '5. Menampilkan data di Serial Monitor',
        description:
            'Gunakan Serial.print() dan Serial.println() untuk '
            'menampilkan nilai suhu dalam derajat Celsius dan '
            'kelembapan dalam persen. Buka Serial Monitor dengan '
            'baud rate 115200 agar sesuai dengan program.',
      ),
      SimulationStep(
        title: '6. Menjalankan dan menguji simulasi',
        description:
            'Jalankan simulasi, kemudian amati nilai suhu dan '
            'kelembapan yang muncul. Ubah kondisi sensor melalui '
            'kontrol komponen DHT22 jika tersedia. Periksa apakah '
            'nilai pada Serial Monitor ikut berubah.',
      ),
      SimulationStep(
        title: '7. Memeriksa kesalahan',
        description:
            'Jika data tidak muncul atau terbaca tidak valid, '
            'periksa koneksi VCC, GND, dan DATA, nomor GPIO, '
            'pustaka DHT, tipe sensor, serta baud rate Serial Monitor. '
            'Pastikan pembacaan sensor diperiksa sebelum nilainya '
            'ditampilkan.',
      ),
      SimulationStep(
        title: '8. Menyimpulkan hasil',
        description:
            'Jelaskan alur data: DHT22 mengukur kondisi lingkungan, '
            'ESP32 membaca data melalui pin DATA, kemudian program '
            'menampilkan hasilnya pada Serial Monitor. Simpan '
            'proyek ini untuk dikembangkan pada Pertemuan 3.',
      ),
    ],
    code: '''
  #include <DHT.h>

  const int ledPin = 13;
  const int dhtPin = 15;

  #define DHTTYPE DHT22

  DHT dht(dhtPin, DHTTYPE);

  void setup() {
    Serial.begin(115200);

    pinMode(ledPin, OUTPUT);
    dht.begin();
  }

  void loop() {
    float suhu = dht.readTemperature();
    float kelembapan = dht.readHumidity();

    if (isnan(suhu) || isnan(kelembapan)) {
      Serial.println("Gagal membaca sensor DHT22");
      delay(2000);
      return;
    }

    Serial.print("Suhu: ");
    Serial.print(suhu);
    Serial.println(" C");

    Serial.print("Kelembapan: ");
    Serial.print(kelembapan);
    Serial.println(" %");

    delay(2000);
  }
  ''',
    wokwiUrl: 'https://wokwi.com/projects/new/esp32',
  ),

  SimulationCase(
    id: 'meeting3_cloud_integration',
    meetingNumber: 3,
    title: 'Mengintegrasikan Sistem Monitoring dengan Cloud',
    description:
        'Mengembangkan sistem monitoring agar data sensor '
        'dapat dikirim melalui jaringan ke layanan cloud.',
    scenario:
        'Sistem monitoring pada pertemuan kedua telah mampu '
        'membaca suhu dan kelembapan. Namun, data masih ditampilkan '
        'melalui Serial Monitor sehingga belum dapat dipantau '
        'melalui layanan cloud. Kamu diminta mengembangkan sistem '
        'agar data dapat dikirim ke layanan penerima melalui jaringan.',
    tasks: [
      'Buka kembali proyek ESP32 dan DHT22 dari pertemuan kedua.',
      'Pelajari alur pengiriman data dari sensor, ESP32, jaringan, '
          'hingga layanan cloud.',
      'Sesuaikan program dan konfigurasi koneksi agar data sensor '
          'dapat dikirim ke layanan yang telah disediakan.',
      'Jalankan simulasi dan periksa apakah data berhasil diterima '
          'oleh layanan cloud.',
      'Jika data tidak diterima, identifikasi kemungkinan '
          'penyebabnya, seperti koneksi jaringan, konfigurasi layanan, '
          'protokol, atau format data.',
      'Catat hasil pengujian dan buat diagram alur pengiriman '
          'data dari perangkat ke cloud.',
    ],
    targetResult:
        'Kamu dapat menjelaskan alur pengiriman data dan melakukan '
        'pengujian koneksi ke layanan cloud. Jika integrasi telah '
        'disiapkan, data sensor juga berhasil dikirim ke layanan '
        'tersebut.',
    steps: [
      SimulationStep(
        title: '1. Membuka proyek monitoring',
        description:
            'Buka kembali proyek ESP32 dan DHT22 dari Pertemuan 2. '
            'Jalankan proyek dan pastikan nilai suhu serta kelembapan '
            'masih muncul pada Serial Monitor sebelum menambahkan '
            'fitur komunikasi jaringan.',
      ),
      SimulationStep(
        title: '2. Memahami alur data',
        description:
            'Pelajari urutan pengiriman data: DHT22 membaca kondisi '
            'ruangan, ESP32 mengolah data, jaringan mengirimkan '
            'data, kemudian layanan cloud menerima dan menyimpannya. '
            'Catat fungsi setiap bagian dalam diagram sederhana.',
      ),
      SimulationStep(
        title: '3. Menentukan layanan cloud dan protokol',
        description:
            'Gunakan layanan cloud dan protokol yang disediakan '
            'dalam pembelajaran, misalnya broker MQTT. Siapkan '
            'alamat server, port, nama topik, dan kredensial '
            'jika diperlukan. Jangan mengarang alamat atau '
            'kredensial karena nilainya harus sesuai layanan yang '
            'benar-benar digunakan.',
      ),
      SimulationStep(
        title: '4. Menyiapkan koneksi jaringan',
        description:
            'Tambahkan konfigurasi Wi-Fi dan pustaka komunikasi '
            'yang diperlukan. Pada Wokwi, gunakan jaringan simulasi '
            'yang sesuai, seperti jaringan Wi-Fi virtual yang '
            'disediakan untuk proyek tersebut. Periksa status '
            'koneksi sebelum mencoba mengirimkan data.',
      ),
      SimulationStep(
        title: '5. Menyiapkan pengiriman data',
        description:
            'Pertahankan pembacaan DHT22 yang sudah berfungsi. '
            'Setelah data suhu dan kelembapan diperoleh, susun '
            'data sesuai format yang diterima layanan, kemudian '
            'kirim melalui protokol yang telah ditentukan. '
            'Untuk MQTT, pastikan topik dan format pesan sesuai '
            'dengan konfigurasi penerima.',
      ),
      SimulationStep(
        title: '6. Menguji penerimaan data',
        description:
            'Jalankan simulasi dan periksa status koneksi serta '
            'pesan yang dikirim. Buka layanan cloud atau klien '
            'penerima yang digunakan untuk memastikan data benar-benar '
            'diterima. Pesan pada Serial Monitor yang menyatakan '
            'pengiriman berhasil saja belum membuktikan bahwa '
            'layanan cloud menerima data.',
      ),
      SimulationStep(
        title: '7. Menangani kendala',
        description:
            'Jika data tidak diterima, periksa koneksi Wi-Fi, '
            'alamat server, port, autentikasi, nama topik, '
            'protokol, dan format pesan. Uji setiap bagian secara '
            'bertahap agar sumber masalah lebih mudah ditemukan.',
      ),
      SimulationStep(
        title: '8. Mendokumentasikan pengujian',
        description:
            'Catat data yang dikirim, status koneksi, hasil '
            'penerimaan, dan kendala yang ditemukan. Buat diagram '
            'alur DHT22 → ESP32 → jaringan → layanan cloud. '
            'Simpan konfigurasi proyek untuk digunakan pada '
            'Pertemuan 4.',
      ),
    ],
    code: '''
  // Kerangka pembelajaran integrasi cloud.
  // Kode ini belum mengirim data ke cloud.
  // Lengkapi berdasarkan layanan dan protokol
  // yang benar-benar digunakan.

  #include <WiFi.h>
  #include <DHT.h>

  const int dhtPin = 15;
  #define DHTTYPE DHT22

  DHT dht(dhtPin, DHTTYPE);

  void setup() {
    Serial.begin(115200);
    dht.begin();

    // Tambahkan konfigurasi Wi-Fi.
    // Inisialisasi klien cloud atau MQTT.
  }

  void loop() {
    float suhu = dht.readTemperature();
    float kelembapan = dht.readHumidity();

    if (isnan(suhu) || isnan(kelembapan)) {
      Serial.println("Gagal membaca sensor DHT22");
      delay(2000);
      return;
    }

    Serial.print("Suhu: ");
    Serial.print(suhu);
    Serial.print(" C | Kelembapan: ");
    Serial.print(kelembapan);
    Serial.println(" %");

    // Tambahkan proses pengiriman data ke cloud.
    // Periksa hasil pengiriman dan status koneksi.

    delay(5000);
  }
  ''',
    wokwiUrl: 'https://wokwi.com/projects/new/esp32',
  ),

  SimulationCase(
    id: 'meeting4_final_monitoring',
    meetingNumber: 4,
    title: 'Menyelesaikan Sistem Monitoring melalui Dashboard',
    description:
        'Menggabungkan pembacaan sensor, pengiriman data, '
        'dan visualisasi dashboard dalam satu proyek IoT.',
    scenario:
        'Pada pertemuan sebelumnya, kamu telah mengembangkan '
        'sistem yang dapat membaca suhu dan kelembapan serta '
        'mempelajari proses pengiriman datanya ke cloud. '
        'Tahap berikutnya adalah menyelesaikan sistem monitoring '
        'dengan menyajikan data melalui dashboard agar kondisi '
        'ruangan lebih mudah dipantau.',
    tasks: [
      'Buka kembali proyek monitoring ESP32 dan DHT22 dari '
          'pertemuan ketiga.',
      'Pastikan data suhu dan kelembapan dapat dibaca oleh ESP32 '
          'dan periksa status pengiriman data ke layanan cloud.',
      'Hubungkan data yang diterima layanan cloud dengan dashboard '
          'monitoring menggunakan platform yang telah disediakan.',
      'Buat tampilan dashboard yang menyajikan nilai suhu dan '
          'kelembapan dalam bentuk angka, tabel, atau grafik.',
      'Jalankan simulasi dan amati perubahan data sensor serta '
          'tampilannya pada dashboard. Jika integrasi langsung belum '
          'tersedia, gunakan data contoh yang disediakan.',
      'Uji sistem dengan mengubah nilai sensor, kemudian periksa '
          'apakah data dan visualisasi menunjukkan perubahan yang sesuai.',
      'Susun diagram keseluruhan sistem dan jelaskan hubungan '
          'antara sensor, ESP32, jaringan, cloud, dan dashboard.',
    ],
    targetResult:
        'Kamu menyelesaikan proyek sistem monitoring suhu dan '
        'kelembapan ruangan berbasis IoT yang terdiri atas rangkaian '
        'ESP32 dan DHT22, pembacaan data sensor, alur pengiriman data, '
        'serta dashboard untuk menyajikan hasil monitoring.',
    steps: [
      SimulationStep(
        title: '1. Membuka proyek dari Pertemuan 3',
        description:
            'Buka kembali proyek ESP32 dan DHT22 beserta konfigurasi '
            'cloud yang sudah dibuat. Jalankan proyek dan pastikan '
            'pembacaan sensor masih berjalan sebelum melanjutkan '
            'ke pembuatan dashboard.',
      ),
      SimulationStep(
        title: '2. Memeriksa sumber data',
        description:
            'Periksa nilai suhu dan kelembapan pada Serial Monitor. '
            'Jika menggunakan integrasi cloud langsung, periksa '
            'juga apakah layanan menerima data terbaru. Jika cloud '
            'belum terhubung, gunakan data contoh yang disediakan '
            'dan beri label bahwa data tersebut merupakan data contoh.',
      ),
      SimulationStep(
        title: '3. Menyiapkan dashboard',
        description:
            'Buka platform dashboard (Thinkspeak). Buat '
            'halaman monitoring baru dan tentukan komponen yang '
            'dibutuhkan, misalnya kartu nilai suhu, kartu kelembapan, '
            'tabel riwayat, atau grafik perubahan data.',
      ),
      SimulationStep(
        title: '4. Menghubungkan dashboard dengan sumber data',
        description:
            'Konfigurasikan dashboard agar membaca data dari layanan '
            'cloud menggunakan konektor atau mekanisme yang didukung '
            'platform. Pastikan nama variabel atau field suhu, '
            'kelembapan, dan waktu pengukuran sesuai dengan data '
            'yang diterima.',
      ),
      SimulationStep(
        title: '5. Menyusun visualisasi',
        description:
            'Tampilkan suhu dalam derajat Celsius dan kelembapan '
            'dalam persen. Tambahkan grafik atau tabel jika tersedia '
            'agar perubahan nilai dari waktu ke waktu lebih mudah '
            'diamati. Berikan label yang jelas pada setiap komponen.',
      ),
      SimulationStep(
        title: '6. Menguji perubahan data',
        description:
            'Ubah nilai sensor pada simulasi atau gunakan data uji '
            'yang telah disediakan. Amati apakah nilai pada sumber '
            'data berubah dan apakah dashboard menampilkan perubahan '
            'yang sesuai. Catat jika terdapat keterlambatan atau '
            'nilai yang tidak cocok.',
      ),
      SimulationStep(
        title: '7. Memeriksa keseluruhan sistem',
        description:
            'Bandingkan pembacaan sensor, data yang diterima cloud, '
            'dan nilai yang ditampilkan dashboard. Pastikan kamu '
            'dapat membedakan data sensor langsung dengan data contoh '
            'yang digunakan untuk merancang tampilan.',
      ),
      SimulationStep(
        title: '8. Membuat diagram sistem',
        description:
            'Gambarkan alur keseluruhan: sensor DHT22 → ESP32 → '
            'jaringan → layanan cloud → dashboard. Jelaskan fungsi '
            'setiap bagian dan bagaimana data berpindah dari sensor '
            'hingga dapat dilihat pengguna.',
      ),
      SimulationStep(
        title: '9. Menyelesaikan proyek akhir',
        description:
            'Simpan proyek, dokumentasikan rangkaian dan dashboard, '
            'serta catat hasil pengujian. Hasil akhirnya adalah satu '
            'proyek monitoring yang dikembangkan secara bertahap '
            'dari Pertemuan 1 hingga Pertemuan 4, bukan empat proyek '
            'yang terpisah.',
      ),
    ],
    code: '''
  // Data contoh untuk menguji konsep visualisasi.
  // Kode ini hanya mencetak data contoh pada Serial Monitor.
  // Kode ini belum menghubungkan ESP32 ke dashboard.

  float suhuContoh = 28.5;
  float kelembapanContoh = 65.0;

  void setup() {
    Serial.begin(115200);
    Serial.println("Sistem Monitoring Ruangan");
    Serial.println("Status: Data Contoh");
  }

  void loop() {
    Serial.print("Suhu: ");
    Serial.print(suhuContoh);
    Serial.println(" C");

    Serial.print("Kelembapan: ");
    Serial.print(kelembapanContoh);
    Serial.println(" %");

    delay(5000);
  }
  ''',
    wokwiUrl: 'https://wokwi.com/projects/new/esp32',
  ),
];
