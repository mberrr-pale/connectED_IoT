import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_page_header.dart';

class TeacherMaterialsPage extends StatelessWidget {
  final ValueChanged<int> onOpenMeeting;

  const TeacherMaterialsPage({super.key, required this.onOpenMeeting});
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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(
              title: 'Materi',
              subtitle: 'Jelajahi materi pembelajaran IoT',
              icon: Icons.menu_book_rounded,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Text(
                    'REFERENSI PENGAJAR',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Katalog Materi',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tinjau isi pembelajaran yang akan diakses siswa pada setiap pertemuan.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 22),
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
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final info = _meetings[index];
    final meetingNumber = index + 1;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          onOpenMeeting(meetingNumber);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.colorScheme.outlineVariant),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(info.icon, color: info.color, size: 25),
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
                          info.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          info.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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
