import 'package:flutter/material.dart';

class ReflectionPage extends StatelessWidget {
  final int meetingNumber;

  const ReflectionPage({super.key, required this.meetingNumber});

  static const Map<int, String> _summaries = {
    1:
        'IoT merupakan teknologi yang menghubungkan perangkat fisik '
        'melalui jaringan untuk mengumpulkan dan mengirimkan data. '
        'Dalam sistem monitoring, sensor membaca kondisi lingkungan, '
        'ESP32 memproses data dan mengendalikan keluaran sesuai program, '
        'sedangkan jaringan dan cloud berperan dalam pengiriman serta '
        'penyimpanan data untuk ditampilkan pada dashboard. Pada simulasi '
        'Wokwi, LED dikendalikan melalui pengaturan pin dan instruksi '
        'program, dengan setup() untuk inisialisasi awal dan loop() '
        'untuk menjalankan perintah secara berulang. Jika sistem tidak '
        'berjalan sesuai tujuan, pemeriksaan dilakukan pada rangkaian, '
        'program, koneksi jaringan, dan proses pengiriman data.',
    2:
        'DHT22 berfungsi mengukur suhu dan kelembapan lingkungan, '
        'sedangkan ESP32 membaca dan memproses hasil pengukuran sesuai '
        'program. Serial Monitor digunakan untuk memastikan data sensor '
        'berhasil dibaca sebelum dikirim melalui jaringan. Pada protokol '
        'MQTT, publisher mengirim pesan ke broker melalui topik tertentu, '
        'kemudian broker meneruskan pesan kepada subscriber yang '
        'berlangganan pada topik tersebut. Jika data berhasil muncul '
        'di Serial Monitor tetapi tidak diterima oleh aplikasi, '
        'pemeriksaan perlu dilakukan pada koneksi jaringan, konfigurasi '
        'broker, alamat dan port, autentikasi jika diperlukan, serta '
        'kesesuaian topik MQTT.',
    3:
        'Integrasi cloud menghubungkan ESP32 dengan layanan daring agar '
        'data sensor dapat dikirim dan diterima untuk keperluan monitoring. '
        'Keberhasilan pembacaan sensor melalui Serial Monitor belum '
        'menjamin data berhasil sampai ke cloud, sehingga koneksi jaringan, '
        'konfigurasi layanan, alamat dan port, autentikasi, serta proses '
        'pengiriman perlu diperiksa. Pada komunikasi MQTT, kesesuaian '
        'topik dan konfigurasi publisher, broker, serta subscriber juga '
        'perlu diperhatikan. Selain itu, format data harus sesuai dengan '
        'kebutuhan layanan penerima agar dapat diproses dan ditampilkan '
        'pada dashboard. Pengujian secara bertahap dari pembacaan sensor '
        'hingga penerimaan data membantu menemukan sumber masalah '
        'dengan lebih tepat.',
    4:
        'Dashboard monitoring digunakan untuk menampilkan data sensor '
        'dalam bentuk nilai terkini dan grafik perubahan dari waktu ke '
        'waktu. Agar data yang ditampilkan sesuai dengan kondisi sebenarnya, '
        'dashboard harus mengambil data terbaru dari layanan cloud, '
        'memetakan data dengan benar, dan memperbarui tampilannya secara '
        'berkala. Pengujian dilakukan dengan membandingkan hasil pembacaan '
        'sensor pada Serial Monitor, data yang diterima layanan cloud, '
        'dan nilai yang ditampilkan pada dashboard, termasuk memastikan '
        'data suhu, kelembapan, serta waktu pengukuran tercatat dengan '
        'tepat. Jika integrasi cloud belum tersedia, data contoh tetap '
        'dapat digunakan untuk mempelajari visualisasi dashboard, tetapi '
        'belum membuktikan bahwa pemantauan berjalan secara langsung.',
  };

  String get _summary {
    return _summaries[meetingNumber] ??
        'Rangkuman untuk pertemuan ini belum tersedia.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refleksi Pembelajaran')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Refleksi Pembelajaran',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pelajari kembali rangkuman materi berikut untuk '
            'memperkuat pemahamanmu.',
          ),
          const SizedBox(height: 20),
          _buildSummaryCard(context),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rangkuman Pembelajaran',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(_summary, style: const TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
