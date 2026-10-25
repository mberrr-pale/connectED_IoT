
import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  final int meetingNumber;
  final VoidCallback? onOpenSimulation;

  const PreviewPage({
    super.key,
    required this.meetingNumber,
    this.onOpenSimulation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            size: 52,
            color: Color(0xFF087E8B),
          ),
          const SizedBox(height: 16),

          const Text(
            'PREVIEW Pertemuan 2',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Gambaran materi selanjutnya'),
          const SizedBox(height: 8),
          const Text(
            'Pada pertemuan berikutnya, kamu akan mempelajari '
            'bagaimana ESP32 membaca kondisi lingkungan menggunakan '
            'sensor DHT22. Kamu juga akan mengenal cara menampilkan '
            'data suhu dan kelembapan melalui Serial Monitor serta '
            'memahami dasar komunikasi IoT menggunakan protokol MQTT '
            'untuk pertukaran data antarperangkat.',
          ),

          const SizedBox(height: 24),

          _buildSectionTitle(
            'Studi Kasus materi pertemuan 1 : '
            'Membuat LED Berkedip dengan ESP32',
          ),
          const SizedBox(height: 8),
          const Text(
            'Sebuah ruangan akan dilengkapi dengan sistem monitoring '
            'suhu. Sebelum menggunakan sensor untuk membaca suhu '
            'ruangan, kamu akan mengenal ESP32 sebagai perangkat '
            'pengendali melalui proyek sederhana menggunakan LED.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Pada proyek ini, kamu akan membuat LED menyala dan mati '
            'secara bergantian melalui program yang dijalankan pada '
            'ESP32. Proyek ini menjadi langkah awal sebelum kamu '
            'menambahkan sensor pada pertemuan berikutnya.',
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Apa yang akan kamu pelajari?'),
          const SizedBox(height: 12),
          _buildBullet(
            'Mengenali ESP32, LED, dan hubungan pin yang digunakan.',
          ),
          _buildBullet(
            'Membuat program untuk menyalakan dan mematikan LED '
            'secara berulang.',
          ),
          _buildBullet(
            'Menjalankan simulasi dan mengamati perubahan kondisi LED.',
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Hasil yang diharapkan'),
          const SizedBox(height: 8),
          const Text(
            'LED menyala selama satu detik dan mati selama satu detik '
            'secara berulang. Kamu juga dapat menjelaskan fungsi ESP32 '
            'dan hubungan antara program dengan kondisi LED.',
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7F8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF087E8B),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Buka menu Simulasi kemudian pilih Pertemuan 1 '
                    'untuk mengikuti petunjuk merangkai komponen, '
                    'menulis program, dan menjalankan simulasi di Wokwi.',
                    style: TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpenSimulation,
              icon: const Icon(Icons.science_outlined),
              label: const Text('Buka Simulasi Pertemuan 1'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 20,
              color: Color(0xFF087E8B),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
