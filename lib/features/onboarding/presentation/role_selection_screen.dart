import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'student_identity_screen.dart';
import 'teacher_identity_screen.dart';
import '../../../widgets/app_page_header.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 24),
          children: [
            const AppPageHeader(
              title: 'Pilih Peran',
              subtitle: 'Masuk sebagai Guru atau Siswa',
              icon: Icons.memory_rounded
            ),
            Text(
              'Selamat datang!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Pilih peranmu untuk melanjutkan ke ConnectED IoT.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 32),

            _RoleCard(
              icon: Icons.school_rounded,
              title: 'Siswa',
              description:
                  'Pelajari materi, kerjakan tes, dan pantau '
                  'progres belajarmu.',
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentIdentityScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            _RoleCard(
              icon: Icons.person_outline_rounded,
              title: 'Guru',
              description:
                  'Akses materi pembelajaran dan informasi '
                  'rekap hasil siswa.',
              color: AppColors.violet,
              backgroundColor: AppColors.violetLight,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TeacherIdentityScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 32),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
