import 'package:flutter/material.dart';

import '../../materials/data/assessments/meeting_1_post_test.dart';
import '../../materials/data/assessments/meeting_2_post_test.dart';
import '../../materials/data/assessments/meeting_3_post_test.dart';
import '../../materials/data/assessments/meeting_4_post_test.dart';

class PostTestPage extends StatefulWidget {
  final int meetingNumber;

  const PostTestPage({super.key, required this.meetingNumber});

  @override
  State<PostTestPage> createState() => _PostTestPageState();
}

class _PostTestPageState extends State<PostTestPage> {
  late final List<Map<String, dynamic>> _questions;
  late final List<int?> _answers;

  @override
  void initState() {
    super.initState();

    _questions = switch (widget.meetingNumber) {
      1 => meeting1PostTestQuestions,
      2 => meeting2PostTestQuestions,
      3 => meeting3PostTestQuestions,
      4 => meeting4PostTestQuestions,
      _ => <Map<String, dynamic>>[],
    };

    _answers = List<int?>.filled(_questions.length, null);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post-test')),
        body: const Center(child: Text('Soal Post-test belum tersedia.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Post-test Pertemuan ${widget.meetingNumber}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: _questions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 20),
                itemBuilder: (context, questionIndex) {
                  final question = _questions[questionIndex];

                  final options = List<String>.from(
                    question['options'] as List,
                  );

                  final correctAnswer = question['correctAnswer'] as int;

                  final selectedAnswer = _answers[questionIndex];

                  final explanation =
                      question['explanation']?.toString().trim() ?? '';

                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pertanyaan
                          Text(
                            '${questionIndex + 1}. '
                            '${question['question']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Semua opsi jawaban
                          ...List.generate(options.length, (optionIndex) {
                            final isCorrect = optionIndex == correctAnswer;

                            final isSelected = optionIndex == selectedAnswer;

                            final borderColor = isCorrect
                                ? Colors.green
                                : isSelected
                                ? Colors.red
                                : Colors.grey.shade300;

                            final backgroundColor = isCorrect
                                ? Colors.green.withValues(alpha: 0.08)
                                : isSelected
                                ? Colors.red.withValues(alpha: 0.08)
                                : null;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: borderColor,
                                  width: isCorrect || isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Material(
                                color: backgroundColor ?? Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                clipBehavior: Clip.antiAlias,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  leading: isCorrect
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : Radio<int>(
                                          value: optionIndex,
                                          groupValue: selectedAnswer,
                                          onChanged: (value) {
                                            setState(() {
                                              _answers[questionIndex] = value;
                                            });
                                          },
                                        ),
                                  title: Text(options[optionIndex]),
                                  trailing: isCorrect
                                      ? const Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                        )
                                      : isSelected
                                      ? const Icon(
                                          Icons.radio_button_checked,
                                          color: Colors.red,
                                        )
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _answers[questionIndex] = optionIndex;
                                    });
                                  },
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 12),
                          // Penjelasan jika tersedia
                          if (explanation.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.lightbulb_outline, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Penjelasan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(explanation),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
