import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderPage(
        icon: Icons.person_rounded,
        title: 'Profil Siswa',
        description: 'Identitas siswa dan pengaturan profil akan tersedia di sini.',
      );
}
