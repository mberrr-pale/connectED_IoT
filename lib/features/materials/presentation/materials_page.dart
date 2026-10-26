
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_progress.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({
    super.key,
    required this.progress,
    required this.onOpenMeeting,
  });

  final LearningProgress progress;
  final ValueChanged<int> onOpenMeeting;

  static const List<_MeetingInfo> _meetings = [
    _MeetingInfo(
      title: 'Mengenal Internet of Things',
      description: 'Konsep, cara kerja, dan penerapan IoT.',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF2563EB),
      background: Color(0xFFEAF2FF),
    ),
    _MeetingInfo(
      title: 'Mikrokontroler & Sensor',
      description: 'ESP32, aktuator, dan data lingkungan.',
      icon: Icons.memory_rounded,
      color: Color(0xFF0891B2),
      background: Color(0xFFE1FAFA),
    ),
    _MeetingInfo(
      title: 'Protokol & Cloud IoT',
      description: 'MQTT, komunikasi, dan layanan cloud.',
      icon: Icons.cloud_outlined,
      color: Color(0xFF7C5CFA),
      background: Color(0xFFF0EBFF),
    ),
    _MeetingInfo(
      title: 'Integrasi dan Proyek IoT',
      description: 'Mengintegrasikan komponen menjadi sistem IoT.',
      icon: Icons.build_circle_outlined,
      color: Color(0xFFC56B13),
      background: Color(0xFFFFF0E2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Text(
              'KATALOG PEMBELAJARAN',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Materi IoT',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pelajari empat pertemuan secara berurutan. '
              'Pertemuan berikutnya terbuka setelah kamu lulus post-test.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 20),
            _buildSummary(context),
            const SizedBox(height: 20),
            ...List.generate(
              _meetings.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMeetingCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(
              alpha: 0.55,
            ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4 pertemuan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('24 langkah belajar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingCard(BuildContext context, int index) {
    final meetingNumber = index + 1;
    final info = _meetings[index];
    final meeting = progress.meetings[meetingNumber]!;
    final isUnlocked = progress.isMeetingUnlocked(meetingNumber);
    final completedCount = meeting.completedStages.length;
    final isComplete = completedCount == LearningProgress.stagesPerMeeting;

    final status = isComplete
        ? 'SELESAI'
        : !isUnlocked
            ? 'TERKUNCI'
            : completedCount > 0
                ? 'SEDANG DIPELAJARI'
                : 'TERBUKA';

    return Opacity(
      opacity: isUnlocked ? 1 : 0.72,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            if (isUnlocked) {
              onOpenMeeting(meetingNumber);
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Lulus post-test pertemuan sebelumnya untuk membuka materi ini.',
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 76,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: info.background,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          meetingNumber.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: info.color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          isUnlocked ? info.icon : Icons.lock_outline_rounded,
                          color: info.color,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status,
                            style: TextStyle(
                              color: isUnlocked
                                  ? info.color
                                  : AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            info.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            info.description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$completedCount/${LearningProgress.stagesPerMeeting} langkah',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      isUnlocked
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.lock_outline_rounded,
                      size: 17,
                      color: isUnlocked
                          ? AppColors.textSecondary
                          : AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MeetingInfo {
  const _MeetingInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color background;
}
