import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/student_profile.dart';
import '../../../services/learning_progress_storage.dart';
import '../../../services/profile_storage.dart';
import '../../../widgets/app_page_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StudentProfile? _profile;
  bool _isLoading = true;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileStorage.load();

    if (!mounted) return;

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Akun?'),
        content: const Text(
          'Identitas dan seluruh progres belajar Anda akan '
          'dihapus dari perangkat. Anda harus mendaftar '
          'kembali untuk menggunakan aplikasi.\n\n'
          'Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus Akun'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _deleteAccount();
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await ProfileStorage.clear();
      await LearningProgressStorage.clear();

      if (!mounted) return;

      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppConstants.splashRoute, (route) => false);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus akun. Silakan coba lagi.'),
        ),
      );

      debugPrint('Gagal menghapus akun: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = _profile;

    if (profile == null) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const AppPageHeader(
                title: 'Profil',
                subtitle: 'Informasi akun siswa',
                icon: Icons.person_outline_rounded,
              ),
              const Expanded(
                child: Center(child: Text('Data profil tidak ditemukan.')),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(
              title: 'Profil',
              subtitle: 'Informasi akun siswa',
              icon: Icons.person_outline_rounded,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  // Header profil siswa
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryLight, AppColors.surface],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 48,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'PROFIL SISWA',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile.name,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.school_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Siswa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const _ProfileSectionTitle(
                    title: 'IDENTITAS SISWA',
                    subtitle: 'Informasi identitas yang terdaftar',
                  ),
                  const SizedBox(height: 12),

                  Card(
                    margin: EdgeInsets.zero,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        _ProfileInfoTile(
                          icon: Icons.badge_outlined,
                          label: 'Nama Lengkap',
                          value: profile.name,
                        ),
                        const _ProfileDivider(),
                        _ProfileInfoTile(
                          icon: Icons.numbers_rounded,
                          label: 'NIS',
                          value: profile.nis,
                        ),
                        const _ProfileDivider(),
                        _ProfileInfoTile(
                          icon: Icons.school_outlined,
                          label: 'Kelas',
                          value: profile.studentClass,
                        ),
                        const _ProfileDivider(),
                        _ProfileInfoTile(
                          icon: Icons.apartment_rounded,
                          label: 'Nama Sekolah',
                          value: profile.school,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const _ProfileSectionTitle(
                    title: 'PERAN PENGGUNA',
                    subtitle: 'Peran akun dalam aplikasi',
                  ),
                  const SizedBox(height: 12),

                  Card(
                    margin: EdgeInsets.zero,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      leading: _ProfileIconBox(
                        icon: Icons.school_rounded,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Siswa',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Mengakses materi dan aktivitas belajar'),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const _ProfileSectionTitle(
                    title: 'PENGELOLAAN AKUN',
                    subtitle: 'Kelola data akun pada perangkat ini',
                  ),
                  const SizedBox(height: 12),

                  Card(
                    margin: EdgeInsets.zero,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.45),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      leading: const _ProfileIconBox(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.error,
                      ),
                      title: const Text(
                        'Hapus Akun',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Hapus identitas dan progres belajar',
                      ),
                      trailing: _isDeleting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textSecondary,
                            ),
                      enabled: !_isDeleting,
                      onTap: _isDeleting ? null : _confirmDeleteAccount,
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
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ProfileSectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileIconBox(icon: icon, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.isEmpty ? '-' : value,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ProfileIconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.border,
    );
  }
}
