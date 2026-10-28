import 'package:flutter/material.dart';

import '../data/assessments/meeting_1_post_test.dart';
import '../data/assessments/meeting_2_post_test.dart';
import '../data/assessments/meeting_3_post_test.dart';
import '../data/assessments/meeting_4_post_test.dart';

class PostTestPage extends StatefulWidget {
  final int meetingNumber;

  const PostTestPage({super.key, required this.meetingNumber});

  @override
  State<PostTestPage> createState() => _PostTestPageState();
}

class _PostTestPageState extends State<PostTestPage> {
  int _currentQuestion = 0;

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

    Navigator.pop(context, {
      'completed': true,
      'score': _calculateScore(),
      'answers': List<int?>.from(_answers),
      'questions': _questions,
      'meetingNumber': widget.meetingNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post-test')),
        body: const Center(child: Text('Soal Post-test belum tersedia.')),
      );
    }

    final question = _questions[_currentQuestion];
    final options = List<String>.from(question['options'] as List);
    final isLastQuestion = _currentQuestion == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post-test Pertemuan ${widget.meetingNumber}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestion + 1) / _questions.length,
              ),
              const SizedBox(height: 12),
              Text(
                'Soal ${_currentQuestion + 1} dari ${_questions.length}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Text(
                question['question'] as String,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _answers[_currentQuestion] == index;

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      title: Text(options[index]),
                      leading: RadioGroup<int>(
                        groupValue: _answers[_currentQuestion],
                        onChanged: (value) {
                          setState(() {
                            _answers[_currentQuestion] = value;
                          });
                        },
                        child: Radio<int>(value: index),
                      ),
                      onTap: () {
                        setState(() {
                          _answers[_currentQuestion] = index;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextQuestion,
                  child: Text(isLastQuestion ? 'Selesai' : 'Soal Berikutnya'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
