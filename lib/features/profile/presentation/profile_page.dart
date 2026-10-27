import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../models/student_profile.dart';
import '../../../services/learning_progress_storage.dart';
import '../../../services/profile_storage.dart';

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
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
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
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Data profil tidak ditemukan.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_rounded,
                      size: 46,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Siswa',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Identitas siswa
            Text(
              'Identitas Siswa',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _ProfileInfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Nama Lengkap',
                    value: profile.name,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoTile(
                    icon: Icons.numbers_rounded,
                    label: 'NIS',
                    value: profile.nis,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoTile(
                    icon: Icons.school_outlined,
                    label: 'Kelas',
                    value: profile.studentClass,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoTile(
                    icon: Icons.apartment_rounded,
                    label: 'Nama Sekolah',
                    value: profile.school,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Pengelolaan akun
            Text(
              'Pengelolaan Akun',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  'Hapus Akun',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('Hapus identitas dan progres belajar'),
                trailing: _isDeleting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right_rounded),
                enabled: !_isDeleting,
                onTap: _isDeleting ? null : _confirmDeleteAccount,
              ),
            ),
          ],
        ),
      ),
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
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
