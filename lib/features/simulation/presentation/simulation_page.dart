
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SimulationPage extends StatelessWidget {
  final int meetingNumber;

  const SimulationPage({
    super.key,
    this.meetingNumber = 1,
  });

  static const Color _accent = Color(0xFF087E8B);

  static const String _wokwiUrl =
      'https://wokwi.com/projects/new/esp32';

  @override
  Widget build(BuildContext context) {
    if (meetingNumber != 1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Simulasi')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Materi simulasi Pertemuan $meetingNumber '
              'akan ditambahkan setelah Pertemuan 1 selesai.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'SIMULASI · PERTEMUAN 1',
            style: TextStyle(
              color: _accent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Indikator Aktivitas Sistem Monitoring Ruangan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selesaikan studi kasus dengan membuat indikator LED '
            'berkedip menggunakan ESP32.',
          ),
          const SizedBox(height: 24),

          _buildSection(
            icon: Icons.assignment_outlined,
            title: 'Studi kasus dan target',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Situasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Sebuah ruangan akan dilengkapi sistem monitoring '
                  'suhu. Sebelum menambahkan sensor, kamu diminta '
                  'mengenal ESP32 sebagai perangkat pengendali '
                  'dengan membuat indikator aktivitas menggunakan LED.',
                ),
                SizedBox(height: 16),
                Text(
                  'Tugas kamu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _TaskItem(
                  number: '1',
                  text: 'Buka proyek baru ESP32 di Wokwi.',
                ),
                _TaskItem(
                  number: '2',
                  text: 'Identifikasi ESP32, LED, dan hubungan pin.',
                ),
                _TaskItem(
                  number: '3',
                  text: 'Buat program agar LED menyala satu detik '
                      'dan mati satu detik secara berulang.',
                ),
                _TaskItem(
                  number: '4',
                  text: 'Jalankan simulasi dan amati LED.',
                ),
                _TaskItem(
                  number: '5',
                  text: 'Jelaskan fungsi ESP32 dan hubungan program '
                      'dengan output LED.',
                ),
                SizedBox(height: 16),
                Text(
                  'Target hasil',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Simulasi LED berkedip berhasil dijalankan dan '
                  'kamu memahami bagaimana ESP32 mengendalikan '
                  'output melalui program.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildSection(
            icon: Icons.format_list_numbered,
            title: 'Petunjuk penyelesaian',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StepItem(
                  number: '1',
                  title: 'Buat proyek ESP32',
                  description:
                      'Buka Wokwi dan pilih proyek baru menggunakan '
                      'board ESP32.',
                ),
                _StepItem(
                  number: '2',
                  title: 'Siapkan LED',
                  description:
                      'Tambahkan LED dan resistor yang sesuai. '
                      'Hubungkan LED ke pin GPIO yang dipilih dan '
                      'GND melalui rangkaian yang benar.',
                ),
                _StepItem(
                  number: '3',
                  title: 'Tulis program',
                  description:
                      'Atur pin LED sebagai OUTPUT, kemudian gunakan '
                      'digitalWrite() dan delay() untuk mengatur '
                      'LED menyala dan mati.',
                ),
                _StepItem(
                  number: '4',
                  title: 'Jalankan simulasi',
                  description:
                      'Tekan tombol Start Simulation. Periksa apakah '
                      'LED menyala dan mati bergantian setiap satu detik.',
                ),
                _StepItem(
                  number: '5',
                  title: 'Evaluasi hasil',
                  description:
                      'Jika LED belum berkedip, periksa kembali '
                      'hubungan pin, kode program, dan konfigurasi LED.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildSection(
            icon: Icons.code_rounded,
            title: 'Referensi kode program',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gunakan kode berikut sebagai referensi setelah '
                  'mencoba menulis program sendiri.',
                ),
                SizedBox(height: 12),
                _CodeReference(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildSection(
            icon: Icons.open_in_new_rounded,
            title: 'Praktik di Wokwi',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buka Wokwi untuk membuat proyek ESP32 sendiri. '
                  'Terapkan petunjuk di atas, lalu jalankan '
                  'simulasi untuk memeriksa hasilnya.',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _openWokwi,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Buka Wokwi ESP32'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Hasil praktik: proyek ESP32 dengan rangkaian LED '
            'dan program output sederhana untuk dikembangkan '
            'pada pertemuan berikutnya.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _openWokwi() async {
    final uri = Uri.parse(_wokwiUrl);

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        debugPrint('Wokwi tidak dapat dibuka.');
      }
    } catch (error) {
      debugPrint('Gagal membuka Wokwi: $error');
    }
  }
}

class _TaskItem extends StatelessWidget {
  final String number;
  final String text;

  const _TaskItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: const Color(0xFFE6F7F8),
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF087E8B),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xFFE6F7F8),
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF087E8B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeReference extends StatelessWidget {
  const _CodeReference();

  static const String _code = '''
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
''';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SelectableText(
        _code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }
}
