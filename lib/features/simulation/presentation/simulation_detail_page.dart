import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/simulation_case.dart';

class SimulationDetailPage extends StatelessWidget {
  final int meetingNumber;
  final SimulationCase simulationCase;

  const SimulationDetailPage({
    super.key,
    required this.meetingNumber,
    required this.simulationCase,
  });

  static const Color _accent = Color(0xFF087E8B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Studi Kasus • Pertemuan $meetingNumber')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'PRAKTIK IoT',
            style: TextStyle(
              color: _accent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            simulationCase.title,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(simulationCase.description),
          const SizedBox(height: 24),

          _buildSection(
            icon: Icons.assignment_outlined,
            title: 'Studi kasus dan target',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Situasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(simulationCase.scenario),
                const SizedBox(height: 16),
                const Text(
                  'Tugas kamu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...simulationCase.tasks.asMap().entries.map(
                  (entry) =>
                      _TaskItem(number: '${entry.key + 1}', text: entry.value),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Target hasil',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(simulationCase.targetResult),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildSection(
            icon: Icons.format_list_numbered,
            title: 'Petunjuk penyelesaian',
            child: simulationCase.steps.isEmpty
                ? const Text('Petunjuk belum tersedia.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: simulationCase.steps
                        .asMap()
                        .entries
                        .map(
                          (entry) => _StepItem(
                            number: '${entry.key + 1}',
                            title: entry.value.title,
                            description: entry.value.description,
                          ),
                        )
                        .toList(),
                  ),
          ),

          const SizedBox(height: 16),

          _buildSection(
            icon: Icons.code_rounded,
            title: 'Referensi kode program',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coba tulis program sendiri terlebih dahulu, '
                  'kemudian gunakan kode berikut sebagai referensi.',
                ),
                const SizedBox(height: 12),
                _CodeReference(code: simulationCase.code),
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
                  'Buka proyek ESP32 di Wokwi, terapkan petunjuk, '
                  'dan jalankan simulasi untuk menguji hasilnya.',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _openWokwi(context),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Buka Wokwi ESP32'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Pastikan hasil simulasi sesuai dengan target studi kasus.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
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

  Future<void> _openWokwi(BuildContext context) async {
    final uri = Uri.tryParse(simulationCase.wokwiUrl);

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host != 'wokwi.com') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tautan Wokwi tidak valid.')),
      );
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!context.mounted) return;

      if (!opened) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wokwi tidak dapat dibuka.')),
        );
      }
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat membuka Wokwi.')),
      );
    }
  }
}

class _TaskItem extends StatelessWidget {
  final String number;
  final String text;

  const _TaskItem({required this.number, required this.text});

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
  final String code;

  const _CodeReference({required this.code});

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
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }
}
