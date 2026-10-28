import 'package:flutter/material.dart';

import '../../../models/learning_progress.dart';
import '../../../widgets/app_page_header.dart';
import '../data/simulation_cases.dart';
import '../models/simulation_case.dart';
import 'simulation_detail_page.dart';

class SimulationPage extends StatelessWidget {
  final LearningProgress progress;

  const SimulationPage({super.key, required this.progress});

  static const Color _accent = Color(0xFF087E8B);

  bool get _isUnlocked {
    final meetingOne = progress.meetings[1];

    if (meetingOne == null) return false;

    return LearningStage.values.every(
      (stage) => meetingOne.isStageCompleted(stage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cases = [...simulationCases]
      ..sort((a, b) {
        final meetingComparison = a.meetingNumber.compareTo(b.meetingNumber);

        if (meetingComparison != 0) {
          return meetingComparison;
        }

        return a.title.compareTo(b.title);
      });

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
              child: !_isUnlocked
                  ? _buildLockedContent(context)
                  : _buildCatalog(context, cases),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedContent(BuildContext context) {
    final meetingOne = progress.meetings[1]!;

    final completedCount = LearningStage.values
        .where((stage) => meetingOne.isStageCompleted(stage))
        .length;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 42,
                color: _accent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Simulasi Belum Terbuka',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Selesaikan seluruh 6 tahap pembelajaran Pertemuan 1 '
              'untuk membuka katalog simulasi IoT.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: completedCount / LearningProgress.stagesPerMeeting,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: _accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$completedCount dari ${LearningProgress.stagesPerMeeting} '
              'tahap selesai',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tahap yang perlu diselesaikan:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...LearningStage.values.map((stage) {
              final isCompleted = meetingOne.isStageCompleted(stage);

              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isCompleted ? Colors.green : Colors.grey,
                ),
                title: Text(stage.label),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalog(BuildContext context, List<SimulationCase> cases) {
    return ListView(
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
          'Katalog Studi Kasus',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pilih studi kasus dari pertemuan mana pun yang tersedia, '
          'pelajari petunjuknya, lalu praktikkan di Wokwi.',
        ),
        const SizedBox(height: 20),
        if (cases.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Belum ada studi kasus yang tersedia.',
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
  static const Map<int, String> _meetingTitles = {
    1: 'Pengenalan IoT',
    2: 'Komponen dan Sensor',
    3: 'Koneksi dan Komunikasi',
    4: 'Proyek Akhir IoT',
  };
  
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
                    child: const Icon(Icons.memory_rounded, color: Color(0xFF087E8B),),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PERTEMUAN ${simulationCase.meetingNumber} · '
                          '${_meetingTitles[simulationCase.meetingNumber] ?? ''}'
                              .trim(),
                          style: const TextStyle(
                            color: Color(0xFF087E8B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          simulationCase.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
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
