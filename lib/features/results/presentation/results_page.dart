import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_page.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderPage(
        icon: Icons.bar_chart_rounded,
        title: 'Hasil Belajar',
        description: 'Nilai dan progres akan tampil setelah data pembelajaran tersedia.',
      );
}
