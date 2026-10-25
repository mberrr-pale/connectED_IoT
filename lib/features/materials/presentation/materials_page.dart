import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_page.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderPage(
        icon: Icons.menu_book_rounded,
        title: 'Materi Pembelajaran',
        description: 'Empat pertemuan dan tahapan belajar akan ditampilkan di sini.',
      );
}
