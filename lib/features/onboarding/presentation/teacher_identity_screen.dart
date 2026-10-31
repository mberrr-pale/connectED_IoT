import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/teacher_profile.dart';
import '../../../services/profile_storage.dart';
import '../../../app/teacher_navigation.dart';

class TeacherIdentityScreen extends StatefulWidget {
  const TeacherIdentityScreen({super.key});

  @override
  State<TeacherIdentityScreen> createState() => _TeacherIdentityScreenState();
}

class _TeacherIdentityScreenState extends State<TeacherIdentityScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nipController = TextEditingController();
  final _classController = TextEditingController();
  final _schoolController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nipController.dispose();
    _classController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }

    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final profile = TeacherProfile(
      name: _nameController.text.trim(),
      nip: _nipController.text.trim(),
      school: _schoolController.text.trim(),
    );

    try {
      await ProfileStorage.saveTeacher(profile);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const TeacherNavigation()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil belum berhasil disimpan. Silakan coba lagi.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identitas Guru')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Lengkapi profilmu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Isi identitasmu untuk menyimpan progress '
                'di perangkat ini.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 28),

              _buildField(
                controller: _nameController,
                label: 'Nama lengkap',
                hint: 'Masukkan nama lengkap',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 18),

              _buildField(
                controller: _nipController,
                label: 'NIP / nomor identitas',
                hint: 'Masukkan NIP',
                icon: Icons.badge_outlined,
                digitsOnly: true,
              ),
              const SizedBox(height: 18),

              _buildField(
                controller: _schoolController,
                label: 'Nama sekolah',
                hint: 'Masukkan nama sekolah',
                icon: Icons.school_outlined,
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Simpan dan lanjutkan'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool digitsOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: digitsOnly ? TextInputType.number : TextInputType.text,
          inputFormatters: digitsOnly
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          textCapitalization: digitsOnly
              ? TextCapitalization.none
              : TextCapitalization.words,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
          ),
          validator: (value) => _validateRequired(value, label),
        ),
      ],
    );
  }
}
