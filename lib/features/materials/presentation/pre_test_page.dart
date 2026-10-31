import 'package:flutter/material.dart';

import '../data/assessments/meeting_1_pre_test.dart';
import '../data/assessments/meeting_2_pre_test.dart';
import '../data/assessments/meeting_3_pre_test.dart';
import '../data/assessments/meeting_4_pre_test.dart';

class PreTestPage extends StatefulWidget {
  final int meetingNumber;

  const PreTestPage({super.key, required this.meetingNumber});

  @override
  State<PreTestPage> createState() => _PreTestPageState();
}

class _PreTestPageState extends State<PreTestPage> {
  int _currentQuestion = 0;

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

  int _calculateScore() {
    var correctAnswers = 0;

    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }

    return (correctAnswers * 100 / _questions.length).round();
  }

  void _nextQuestion() {
    if (_answers[_currentQuestion] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jawaban terlebih dahulu.')),
      );
      return;
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
      return;
    }

    final score = _calculateScore();

    Navigator.pop(context, {
      'completed': true,
      'score': score,
      'meetingNumber': widget.meetingNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pre-test')),
        body: const Center(child: Text('Soal Pre-test belum tersedia.')),
      );
    }

    final question = _questions[_currentQuestion];
    final options = List<String>.from(question['options'] as List);
    final progress = (_currentQuestion + 1) / _questions.length;
    final isLastQuestion = _currentQuestion == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pre-test - Pertemuan ${widget.meetingNumber}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(value: progress, minHeight: 6),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pre-test', style: TextStyle(fontSize: 12)),
                  Text(
                    '${_currentQuestion + 1}/${_questions.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                question['question'] as String,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _answers[_currentQuestion] == index;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _answers[_currentQuestion] = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                          ),
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                                    .withValues(alpha: 0.08)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade200,
                              ),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(options[index])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    isLastQuestion ? 'Selesai  →' : 'Soal berikutnya  →',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
