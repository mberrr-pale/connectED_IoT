import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/meeting_1_material.dart';
import '../models/lesson_section.dart';

class LearningContentPage extends StatefulWidget {
  final int meetingNumber;

  const LearningContentPage({super.key, required this.meetingNumber});

  @override
  State<LearningContentPage> createState() => _LearningContentPageState();
}

class _LearningContentPageState extends State<LearningContentPage> {
  int _currentStep = 0;
  int? _selectedAnswer;
  bool _answerChecked = false;

  late final List<_MaterialStep> _steps;

  @override
  void initState() {
    super.initState();

    _steps = widget.meetingNumber == 1
        ? _buildMeetingOneSteps()
        : _buildPlaceholderSteps();
  }

  List<_MaterialStep> _buildMeetingOneSteps() {
    final sections = meeting1Sections;

    return [
      _MaterialStep.content(sections[0]),
      _MaterialStep.content(sections[1]),
      const _MaterialStep.quiz(
        title: 'Cek pemahaman IoT',
        question: 'Apa fungsi utama sistem Internet of Things?',
        options: [
          'Menghubungkan perangkat untuk bertukar data',
          'Menggantikan semua perangkat keras',
          'Menjalankan program tanpa perangkat',
          'Menyimpan data hanya di layar',
        ],
        correctAnswerIndex: 0,
        explanation:
            'IoT memungkinkan perangkat terhubung untuk '
            'mengumpulkan, mengirim, dan bertukar data.',
      ),
      _MaterialStep.content(sections[2]),
      _MaterialStep.content(sections[3]),
      _MaterialStep.content(sections[4]),
      _MaterialStep.content(sections[5]),
    ];
  }

  List<_MaterialStep> _buildPlaceholderSteps() {
    return [
      _MaterialStep.notice(
        title: 'Materi belum tersedia',
        content:
            'Materi Pertemuan ${widget.meetingNumber} sedang '
            'disiapkan. Materi Pertemuan 1 sudah dapat dipelajari '
            'melalui halaman ini.',
      ),
    ];
  }

  void _nextStep() {
    final step = _steps[_currentStep];

    if (step.isQuiz && !_answerChecked) {
      if (_selectedAnswer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih jawaban terlebih dahulu.')),
        );
        return;
      }

      setState(() {
        _answerChecked = true;
      });
      return;
    }

    if (step.isQuiz && _selectedAnswer != step.correctAnswerIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pelajari kembali penjelasannya sebelum melanjutkan.'),
        ),
      );
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _selectedAnswer = null;
        _answerChecked = false;
      });
      return;
    }

    Navigator.pop(context, true);
  }

  void _previousStep() {
    if (_currentStep == 0) {
      Navigator.pop(context, false);
      return;
    }

    setState(() {
      _currentStep--;
      _selectedAnswer = null;
      _answerChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final progress = (_currentStep + 1) / _steps.length;

    return Scaffold(
      appBar: AppBar(title: Text('Materi Pertemuan ${widget.meetingNumber}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Langkah ${_currentStep + 1} dari ${_steps.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: SingleChildScrollView(
                key: ValueKey(_currentStep),
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(step),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _previousStep,
                    child: Text(_currentStep == 0 ? 'Keluar' : 'Sebelumnya'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _nextStep,
                      child: Text(
                        _currentStep == _steps.length - 1
                            ? 'Selesaikan Materi'
                            : step.isQuiz && !_answerChecked
                            ? 'Periksa Jawaban'
                            : 'Berikutnya',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(_MaterialStep step) {
    if (step.isQuiz) {
      return _buildQuiz(step);
    }

    if (step.section != null) {
      return _buildSection(step.section!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.menu_book_rounded, size: 42, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          step.title,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(step.content, style: const TextStyle(fontSize: 16, height: 1.6)),
      ],
    );
  }

  Widget _buildSection(LessonSection section) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          section.content,
          style: const TextStyle(fontSize: 16, height: 1.6),
        ),
        if (section.type == LessonSectionType.bulletList)
          ...section.bulletItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (section.type == LessonSectionType.image &&
            section.imagePath != null) ...[
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              section.imagePath!,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Text(
                  'Gambar belum ditemukan. Periksa assets dan '
                  'pubspec.yaml.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (section.caption != null) ...[
            const SizedBox(height: 8),
            Text(section.caption!, style: theme.textTheme.bodySmall),
          ],
        ],
      ],
    );
  }

  Widget _buildQuiz(_MaterialStep step) {
    final isCorrect = _selectedAnswer == step.correctAnswerIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.quiz_outlined, size: 42, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          step.title,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(step.question!, style: const TextStyle(fontSize: 17, height: 1.5)),
        const SizedBox(height: 20),
        for (int i = 0; i < step.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _answerChecked
                  ? null
                  : () {
                      setState(() {
                        _selectedAnswer = i;
                      });
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _answerChecked && i == step.correctAnswerIndex
                        ? Colors.green
                        : _selectedAnswer == i
                        ? AppColors.primary
                        : Theme.of(context).dividerColor,
                    width:
                        _selectedAnswer == i ||
                            (_answerChecked && i == step.correctAnswerIndex)
                        ? 2
                        : 1,
                  ),
                  color: _selectedAnswer == i
                      ? AppColors.primaryLight.withValues(alpha: 0.25)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      _answerChecked && i == step.correctAnswerIndex
                          ? Icons.check_circle
                          : _selectedAnswer == i
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _answerChecked && i == step.correctAnswerIndex
                          ? Colors.green
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step.options[i],
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_answerChecked)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.green.withValues(alpha: 0.10)
                  : Colors.orange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${isCorrect ? 'Jawaban benar.' : 'Belum tepat.'} '
              '${step.explanation}',
              style: const TextStyle(height: 1.5),
            ),
          ),
      ],
    );
  }
}

class _MaterialStep {
  final String title;
  final String content;
  final LessonSection? section;
  final bool isQuiz;
  final String? question;
  final List<String> options;
  final int? correctAnswerIndex;
  final String? explanation;

  const _MaterialStep.content(this.section)
    : title = '',
      content = '',
      isQuiz = false,
      question = null,
      options = const [],
      correctAnswerIndex = null,
      explanation = null;

  const _MaterialStep.quiz({
    required this.title,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  }) : section = null,
       content = '',
       isQuiz = true;

  const _MaterialStep.notice({required this.title, required this.content})
    : section = null,
      isQuiz = false,
      question = null,
      options = const [],
      correctAnswerIndex = null,
      explanation = null;
}
