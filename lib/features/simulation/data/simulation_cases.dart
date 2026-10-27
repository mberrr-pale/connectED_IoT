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
      'Identifikasi ESP32, LED, dan hubungan pin.',
      'Buat program agar LED menyala satu detik dan mati satu detik '
          'secara berulang.',
      'Jalankan simulasi dan amati LED.',
      'Jelaskan fungsi ESP32 dan hubungan program dengan output LED.',
    ],
    targetResult:
        'Simulasi LED berkedip berhasil dijalankan dan kamu memahami '
        'bagaimana ESP32 mengendalikan output melalui program.',
    steps: [
      SimulationStep(
        title: 'Buat proyek ESP32',
        description:
            'Buka Wokwi dan pilih proyek baru menggunakan board ESP32.',
      ),
      SimulationStep(
        title: 'Siapkan LED',
        description:
            'Tambahkan LED dan resistor yang sesuai. Hubungkan LED '
            'ke pin GPIO yang dipilih dan GND melalui rangkaian '
            'yang benar.',
      ),
      SimulationStep(
        title: 'Tulis program',
        description:
            'Atur pin LED sebagai OUTPUT, kemudian gunakan '
            'digitalWrite() dan delay() untuk mengatur LED menyala '
            'dan mati.',
      ),
      SimulationStep(
        title: 'Jalankan simulasi',
        description:
            'Tekan Start Simulation. Periksa apakah LED menyala '
            'dan mati bergantian setiap satu detik.',
      ),
      SimulationStep(
        title: 'Evaluasi hasil',
        description:
            'Jika LED belum berkedip, periksa kembali hubungan pin, '
            'kode program, dan konfigurasi LED.',
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
    id: 'meeting1_led_control',
    meetingNumber: 1,
    title: 'Kontrol LED dengan Program',
    description:
        'Memahami bagaimana perintah program mengendalikan '
        'kondisi LED pada ESP32.',
    scenario:
        'Kamu diminta membuat indikator yang dapat dinyalakan '
        'dan dimatikan melalui perubahan program.',
    tasks: [
      'Buat proyek ESP32 di Wokwi.',
      'Hubungkan LED ke GPIO dan GND dengan rangkaian yang sesuai.',
      'Buat program untuk menyalakan LED.',
      'Ubah program agar LED mati.',
      'Bandingkan hasil kedua program.',
    ],
    targetResult:
        'LED dapat dikendalikan melalui perubahan nilai output '
        'dalam program.',
    steps: [
      SimulationStep(
        title: 'Siapkan rangkaian',
        description: 'Tambahkan ESP32 dan LED, lalu periksa hubungan pin.',
      ),
      SimulationStep(
        title: 'Atur pin output',
        description: 'Gunakan pinMode() untuk menetapkan GPIO sebagai OUTPUT.',
      ),
      SimulationStep(
        title: 'Atur kondisi LED',
        description:
            'Gunakan digitalWrite() dengan HIGH dan LOW untuk '
            'mengubah kondisi output.',
      ),
      SimulationStep(
        title: 'Uji program',
        description: 'Jalankan simulasi dan amati perubahan kondisi LED.',
      ),
    ],
    code: '''
const int ledPin = 13;

void setup() {
  pinMode(ledPin, OUTPUT);
}

void loop() {
  digitalWrite(ledPin, HIGH);
}
''',
    wokwiUrl: 'https://wokwi.com/projects/new/esp32',
  ),
];
