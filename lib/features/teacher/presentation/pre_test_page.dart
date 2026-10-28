import 'package:flutter/material.dart';

import '../../materials/data/assessments/meeting_1_pre_test.dart';
import '../../materials/data/assessments/meeting_2_pre_test.dart';
import '../../materials/data/assessments/meeting_3_pre_test.dart';
import '../../materials/data/assessments/meeting_4_pre_test.dart';

class PreTestPage extends StatefulWidget {
  final int meetingNumber;

  const PreTestPage({super.key, required this.meetingNumber});

  @override
  State<PreTestPage> createState() => _PreTestPageState();
}

class _PreTestPageState extends State<PreTestPage> {
  late final List<Map<String, dynamic>> _questions;
  late final List<int?> _answers;

  @override
  void initState() {
    super.initState();

    _questions = switch (widget.meetingNumber) {
      1 => meeting1PreTestQuestions,
      2 => meeting2PreTestQuestions,
      3 => meeting3PreTestQuestions,
      4 => meeting4PreTestQuestions,
      _ => <Map<String, dynamic>>[],
    };

    _answers = List<int?>.filled(_questions.length, null);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pre-test')),
        body: const Center(child: Text('Soal Pre-test belum tersedia.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-test - Pertemuan ${widget.meetingNumber}'),
        leadingWidth: 150,
        leading: TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('‹ Keluar dari kuis'),
        ),
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
                          Text(
                            '${questionIndex + 1}. '
                            '${question['question']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          ...List.generate(options.length, (optionIndex) {
                            final isCorrect = optionIndex == correctAnswer;

                            final isSelected = optionIndex == selectedAnswer;

                            final themeColor = Theme.of(context)
                                .colorScheme
                                .primary;

                            final borderColor = isCorrect
                                ? Colors.green
                                : isSelected
                                ? themeColor
                                : Colors.grey.shade300;

                            final backgroundColor = isCorrect
                                ? Colors.green.withValues(alpha: 0.08)
                                : isSelected
                                ? themeColor.withValues(alpha: 0.08)
                                : Colors.transparent;

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
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _answers[questionIndex] = optionIndex;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 34,
                                          height: 34,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                            color: isCorrect
                                                ? Colors.green
                                                : isSelected
                                                ? themeColor
                                                : Colors.grey.shade200,
                                          ),
                                          child: Text(
                                            String.fromCharCode(
                                              65 + optionIndex,
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isCorrect || isSelected
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(options[optionIndex]),
                                        ),
                                        if (isCorrect)
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
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
