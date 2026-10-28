import 'package:flutter/material.dart';

class ReflectionPage extends StatelessWidget {
  final int meetingNumber;
  final List<Map<String, dynamic>> questions;
  final List<int?> answers;

  const ReflectionPage({
    super.key,
    required this.meetingNumber,
    required this.questions,
    required this.answers,
  });

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
    final correctCount = questions.asMap().entries.where((entry) {
      final index = entry.key;
      return index < answers.length &&
          answers[index] == entry.value['correctAnswer'];
    }).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Refleksi Pembelajaran')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Pembahasan Post-test',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pelajari jawaban dan penjelasan berikut untuk memperkuat '
            'pemahamanmu.',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.fact_check_outlined, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hasil jawabanmu'),
                        Text(
                          '$correctCount dari ${questions.length} soal benar',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < questions.length; i++)
            _buildQuestionCard(context, i),
          const SizedBox(height: 12),
          _buildSummaryCard(context),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Saya Sudah Memahami'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, int index) {
    final question = questions[index];
    final options = List<String>.from(question['options'] as List);
    final correctAnswer = question['correctAnswer'] as int;
    final selectedAnswer = index < answers.length ? answers[index] : null;

    final isCorrect = selectedAnswer != null && selectedAnswer == correctAnswer;

    final statusColor = isCorrect
        ? const Color(0xFF16834A)
        : const Color(0xFFC0392B);

    final statusBackground = isCorrect
        ? const Color(0xFFE4F6EC)
        : const Color(0xFFFCE8E6);

    final answerText = selectedAnswer == null
        ? 'Jawabanmu: Belum dijawab'
        : selectedAnswer >= 0 && selectedAnswer < options.length
        ? 'Jawabanmu: '
              '${String.fromCharCode(65 + selectedAnswer)}. '
              '${options[selectedAnswer]}'
        : 'Jawabanmu: -';

    final explanation =
        question['explanation'] as String? ??
        'Pembahasan untuk soal ini belum tersedia.';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Soal ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
                Text(
                  isCorrect ? 'Benar' : 'Salah',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(question['question'] as String),
            const SizedBox(height: 12),
            Text(
              answerText,
              style: TextStyle(
                color: statusColor,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pembahasan jawaban',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(explanation, style: const TextStyle(height: 1.5)),
                ],
              ),
            ),
          ],
        ),
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
