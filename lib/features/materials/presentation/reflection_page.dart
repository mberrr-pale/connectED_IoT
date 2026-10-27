import 'package:flutter/material.dart';

class ReflectionPage extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final List<int?> answers;

  const ReflectionPage({
    super.key,
    required this.questions,
    required this.answers,
  });

  static const String _summary =
      'Sistem IoT memungkinkan kondisi lingkungan dipantau dari jarak jauh. '
      'Sensor seperti DHT22 membaca kondisi fisik, kemudian mikrokontroler '
      'seperti ESP32 mengolah data dan menjalankan instruksi. Data dapat '
      'diteruskan melalui jaringan agar bisa ditampilkan pada aplikasi.';

  @override
  Widget build(BuildContext context) {
    final correctCount = questions.asMap().entries.where((entry) {
      final index = entry.key;
      return index < answers.length &&
          answers[index] == entry.value['correctAnswer'];
    }).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Refleksi Pembelajaran')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Pembahasan Post-test',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pelajari jawaban dan penjelasan berikut untuk memperkuat '
            'pemahamanmu.',
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.fact_check_outlined, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hasil jawabanmu'),
                        Text(
                          '$correctCount dari ${questions.length} soal benar',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          for (int i = 0; i < questions.length; i++)
            _buildQuestionCard(context, i),

          const SizedBox(height: 12),
          _buildSummaryCard(context),
          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Saya Sudah Memahami'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, int index) {
    final question = questions[index];
    final options = List<String>.from(question['options'] as List);
    final correctAnswer = question['correctAnswer'] as int;

    final selectedAnswer = index < answers.length ? answers[index] : null;

    final isCorrect = selectedAnswer != null && selectedAnswer == correctAnswer;

    final statusColor = isCorrect
        ? const Color(0xFF16834A)
        : const Color(0xFFC0392B);

    final statusBackground = isCorrect
        ? const Color(0xFFE4F6EC)
        : const Color(0xFFFCE8E6);

    final answerText = selectedAnswer == null
        ? 'Jawabanmu: Belum dijawab'
        : 'Jawabanmu: '
              '${String.fromCharCode(65 + selectedAnswer)}. '
              '${options[selectedAnswer]}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Soal ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
                Text(
                  isCorrect ? 'Benar' : 'Salah',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(question['question'] as String),
            const SizedBox(height: 12),

            Text(
              answerText,
              style: TextStyle(
                color: statusColor,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pembahasan jawaban',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    question['explanation'] as String,
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rangkuman Pembelajaran',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(_summary, style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
