
import 'package:flutter/material.dart';

import 'meeting_detail_page.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/learning_progress.dart';

class HomePage extends StatefulWidget {
  final LearningProgress progress;
  final VoidCallback onProgressChanged;
  final VoidCallback onOpenSimulation;

  const HomePage({
    super.key,
    required this.progress,
    required this.onProgressChanged,
    required this.onOpenSimulation,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LearningProgress get _progress => widget.progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Halo, Siswa! 👋',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Siap melanjutkan perjalanan belajar IoT?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressCard(),
          const SizedBox(height: 28),
          Text(
            'Peta Perjalanan Belajar',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 12),
          _buildMeetingCard(
            number: 1,
            title: 'Pengenalan IoT',
            subtitle: 'Tahap belajar Pertemuan 1',
            color: AppColors.primaryLight,
            progress: _progress.meetings[1]!,
            isUnlocked: _progress.isMeetingUnlocked(1),
          ),
          const SizedBox(height: 12),
          _buildMeetingCard(
            number: 2,
            title: 'Komponen dan Sensor',
            subtitle: 'Tahap belajar Pertemuan 2',
            color: AppColors.cyanLight,
            progress: _progress.meetings[2]!,
            isUnlocked: _progress.isMeetingUnlocked(2),
          ),
          const SizedBox(height: 12),
          _buildMeetingCard(
            number: 3,
            title: 'Koneksi dan Komunikasi',
            subtitle: 'Tahap belajar Pertemuan 3',
            color: AppColors.violetLight,
            progress: _progress.meetings[3]!,
            isUnlocked: _progress.isMeetingUnlocked(3),
          ),
          const SizedBox(height: 12),
          _buildMeetingCard(
            number: 4,
            title: 'Proyek Akhir IoT',
            subtitle: 'Tahap belajar Pertemuan 4',
            color: AppColors.warningLight,
            progress: _progress.meetings[4]!,
            isUnlocked: _progress.isMeetingUnlocked(4),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progres Belajar',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_progress.completionRate * 100).round()}%',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress.completionRate,
                minHeight: 8,
                backgroundColor: AppColors.primaryLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_progress.completedStageCount} dari '
              '${LearningProgress.totalStages} tahap selesai.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard({
    required int number,
    required String title,
    required String subtitle,
    required Color color,
    required MeetingProgress progress,
    required bool isUnlocked,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (!isUnlocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Selesaikan post-test pertemuan sebelumnya terlebih dahulu.',
                ),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MeetingDetailPage(
                meetingNumber: number,
                meetingTitle: title,
                progress: progress,
                isUnlocked: isUnlocked,
                onProgressChanged: widget.onProgressChanged,
                onOpenSimulation: widget.onOpenSimulation,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isUnlocked
                          ? '$subtitle • '
                              '${progress.completedStages.length}/6 tahap'
                          : 'Terkunci • Selesaikan post-test sebelumnya',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isUnlocked
                    ? Icons.chevron_right_rounded
                    : Icons.lock_outline_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
