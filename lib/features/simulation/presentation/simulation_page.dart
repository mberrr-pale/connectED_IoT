import 'package:flutter/material.dart';

import '../data/simulation_cases.dart';
import '../models/simulation_case.dart';
import 'simulation_detail_page.dart';
import '../../../widgets/app_page_header.dart';

class SimulationPage extends StatelessWidget {
  final int meetingNumber;

  const SimulationPage({super.key, this.meetingNumber = 1});

  static const Color _accent = Color(0xFF087E8B);

  static const Map<int, String> _meetingTitles = {
    1: 'Pengenalan IoT',
    2: 'Komponen dan Sensor',
    3: 'Koneksi dan Komunikasi',
    4: 'Proyek Akhir IoT',
  };

  @override
  Widget build(BuildContext context) {
    final cases = simulationCases
        .where((item) => item.meetingNumber == meetingNumber)
        .toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(
              title: 'Simulasi',
              subtitle: 'Praktik dan eksplorasi IoT',
              icon: Icons.memory_rounded,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                  const SizedBox(height: 8),
                  Text(
                    _meetingTitles[meetingNumber] ?? 'Pertemuan $meetingNumber',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih studi kasus, pelajari tantangannya, lalu '
                    'praktikkan program menggunakan simulasi Wokwi.',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.assignment_outlined, color: _accent),
                      const SizedBox(width: 8),
                      Text(
                        '${cases.length} studi kasus tersedia',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (cases.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Studi kasus untuk pertemuan ini belum tersedia.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...cases.map(
                      (item) => _SimulationCaseCard(
                        simulationCase: item,
                        onTap: () => _openDetail(context, item),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, SimulationCase item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SimulationDetailPage(
          meetingNumber: item.meetingNumber,
          simulationCase: item,
        ),
      ),
    );
  }
}

class _SimulationCaseCard extends StatelessWidget {
  final SimulationCase simulationCase;
  final VoidCallback onTap;

  const _SimulationCaseCard({
    required this.simulationCase,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.memory_rounded,
                      color: Color(0xFF087E8B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      simulationCase.title,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 12),
              Text(simulationCase.description),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Icon(
                    Icons.play_circle_outline_rounded,
                    size: 18,
                    color: Color(0xFF087E8B),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Praktik ESP32 · Wokwi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF087E8B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onTap,
                  child: const Text('Buka Studi Kasus'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
