import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_progress.dart';
import '../../materials/data/meeting_learning_objectives.dart';
import '../../materials/presentation/pre_test_page.dart';
import '../../materials/presentation/learning_content_page.dart';
import '../../materials/presentation/learning_video_page.dart';
import '../../materials/presentation/post_test_page.dart';
import '../../materials/presentation/reflection_page.dart';
import '../../materials/presentation/preview_page.dart';

class MeetingDetailPage extends StatefulWidget {
  final int meetingNumber;
  final String meetingTitle;
  final MeetingProgress progress;
  final bool isUnlocked;
  final VoidCallback onProgressChanged;
  final VoidCallback onOpenSimulation;

  final LearningStage? initialStage;

  const MeetingDetailPage({
    super.key,
    required this.meetingNumber,
    required this.meetingTitle,
    required this.progress,
    required this.isUnlocked,
    required this.onProgressChanged,
    required this.onOpenSimulation,
    this.initialStage,
  });

  @override
  State<MeetingDetailPage> createState() => _MeetingDetailPageState();
}

class _MeetingDetailPageState extends State<MeetingDetailPage> {
  bool _initialStageOpened = false;

  List<Map<String, dynamic>> get _lastQuestions =>
      widget.progress.lastPostTestQuestions;
  List<int?> get _lastAnswer =>
      widget.progress.lastPostTestAnswers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialStageOpened) return;
    _initialStageOpened = true;

    final stage = widget.initialStage;
    if (stage == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openStage(stage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stages = LearningStage.values;
    final completed = widget.progress.completedStages.length;
    final objective =
        meetingLearningObjectives[widget.meetingNumber] ??
        'Tujuan pembelajaran untuk pertemuan ini belum tersedia.';

    return Scaffold(
      appBar: AppBar(title: Text('Pertemuan ${widget.meetingNumber}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.meetingTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tujuan Pembelajaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  objective,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completed dari ${stages.length} langkah selesai',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: completed / stages.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),
          const Text(
            'Langkah Pembelajaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < stages.length; i++) _buildStageTile(stages[i], i),
        ],
      ),
    );
  }

  bool _isStageAvailable(LearningStage stage) {
    if (!widget.isUnlocked) return false;

    final index = LearningStage.values.indexOf(stage);
    if (index == 0) return true;

    return widget.progress.isStageCompleted(LearningStage.values[index - 1]);
  }

  String _getStageSubtitle(
    LearningStage stage,
    bool isCompleted,
    bool isStageAvailable,
  ) {
    if (stage == LearningStage.postTest) {
      if (widget.progress.passedPostTest) {
        return 'Lulus • Nilai terbaik: '
            '${widget.progress.bestPostTestScore}';
      }

      if (widget.progress.requiresReview) {
        return 'Ulangi Materi dan Video terlebih dahulu';
      }

      if (widget.progress.attemptsInCurrentRound > 0) {
        return 'Percobaan ${widget.progress.attemptsInCurrentRound} '
            'dari ${MeetingProgress.maxAttemptsPerRound} • '
            'Nilai terbaik: ${widget.progress.bestPostTestScore}';
      }
    }

    if (isCompleted) return 'Selesai';
    if (isStageAvailable) return 'Siap dipelajari';
    return 'Selesaikan langkah sebelumnya';
  }

  Widget _buildStageTile(LearningStage stage, int index) {
    final isCompleted = widget.progress.isStageCompleted(stage);
    final isStageAvailable = _isStageAvailable(stage);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? AppColors.primaryLight
              : const Color(0xFFF0F2F5),
          child: Icon(
            isCompleted
                ? Icons.check_circle_rounded
                : isStageAvailable
                ? Icons.play_arrow_rounded
                : Icons.lock_outline_rounded,
            color: isCompleted ? AppColors.primary : AppColors.textMuted,
          ),
        ),
        title: Text(stage.label),
        subtitle: Text(_getStageSubtitle(stage, isCompleted, isStageAvailable)),
        trailing: const Icon(Icons.chevron_right_rounded),
        enabled: isStageAvailable,
        onTap: isStageAvailable ? () => _openStage(stage) : null,
      ),
    );
  }

  Future<void> _openStage(LearningStage stage) async {
    if (!mounted) return;

    if (!_isStageAvailable(stage)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selesaikan langkah sebelumnya terlebih dahulu.'),
        ),
      );
      return;
    }

    if (stage == LearningStage.preTest) {
      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (_) => PreTestPage(meetingNumber: widget.meetingNumber),
        ),
      );

      if (result != null && result['completed'] == true && mounted) {
        final score = result['score'] as int;

        setState(() {
          widget.progress.recordPreTestResult(score: score);
          widget.progress.completeStage(LearningStage.preTest);
        });

        widget.onProgressChanged();
      }
      return;
    }

    if (stage == LearningStage.material) {
      final completed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              LearningContentPage(meetingNumber: widget.meetingNumber),
        ),
      );

      if (completed == true && mounted) {
        setState(() {
          widget.progress.completeStage(LearningStage.material);
        });
        widget.onProgressChanged();
      }
      return;
    }

    if (stage == LearningStage.video) {
      final completed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              LearningVideoPage(meetingNumber: widget.meetingNumber),
        ),
      );

      if (completed == true && mounted) {
        setState(() {
          widget.progress.completeStage(LearningStage.video);
        });
        widget.onProgressChanged();
      }
      return;
    }

    if (stage == LearningStage.postTest) {
      await _openPostTest();
      return;
    }

    if (stage == LearningStage.reflection) {
      await _openReflection(
        questions: _lastQuestions, 
        answers: _lastAnswer);
      return;
    }

    if (stage == LearningStage.preview) {
      final openSimulation = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewPage(
            meetingNumber: widget.meetingNumber,
            onOpenSimulation: () {
              Navigator.pop(context, true);
            },
          ),
        ),
      );

      if (!mounted) return;

      if (openSimulation == true) {
        setState(() {
          widget.progress.completeStage(LearningStage.preview);
        });
        widget.onProgressChanged();

        // Pindah ke tab Simulasi.
        widget.onOpenSimulation();

        // Tutup halaman detail pertemuan.
        Navigator.pop(context);
      }
      return;
    }
  }

  Future<void> _openPostTest() async {
    final navigator = Navigator.of(context);

    while (mounted && widget.progress.canRetryPostTest) {
      final attemptNumber = widget.progress.attemptsInCurrentRound + 1;

      final result = await navigator.push<Map<String, dynamic>>(
        MaterialPageRoute(
          builder: (_) => PostTestPage(meetingNumber: widget.meetingNumber),
        ),
      );

      if (result == null || !mounted) return;

      final score = result['score'] as int;
      final answers = List<int?>.from(result['answers'] as List);
      final questions = List<Map<String, dynamic>>.from(
        result['questions'] as List,
      );

      setState(() {
        widget.progress.recordPostTestResult(score: score);
        widget.progress.lastPostTestQuestions = questions;
        widget.progress.lastPostTestAnswers = answers;
      });
      widget.onProgressChanged();

      final passed = score >= MeetingProgress.passingScore;
      final canRetry = widget.progress.canRetryPostTest;
      final requiresReview = widget.progress.requiresReview;

      final retryNow = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(passed ? 'Post-test Lulus!' : 'Hasil Post-test'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nilai kamu: $score'),
                const SizedBox(height: 8),
                Text(
                  passed
                      ? 'Selamat! Kamu memenuhi nilai minimum '
                            '${MeetingProgress.passingScore} dan dapat '
                            'melanjutkan ke Refleksi.'
                      : requiresReview
                      ? 'Kamu belum mencapai nilai minimum '
                            '${MeetingProgress.passingScore}. '
                            'Silakan pelajari kembali Materi dan tonton '
                            'Video sebelum mencoba Post-test lagi.'
                      : 'Nilai minimum kelulusan adalah '
                            '${MeetingProgress.passingScore}. '
                            'Kamu masih memiliki satu kesempatan lagi.',
                ),
                const SizedBox(height: 8),
                Text(
                  'Percobaan: $attemptNumber dari '
                  '${MeetingProgress.maxAttemptsPerRound}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            actions: [
              if (canRetry)
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Nanti'),
                ),
              if (canRetry)
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Ulangi Post-test'),
                ),
              if (!canRetry)
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(passed ? 'Lanjut' : 'Mengerti'),
                ),
            ],
          );
        },
      );

      if (!mounted) return;

      if (passed) {
        if (retryNow == false) {
          await _openReflection(questions: questions, answers: answers);
        }
        return;
      }

      if (retryNow != true) return;
    }
  }

  Future<void> _openReflection({
    required List<Map<String, dynamic>> questions,
    required List<int?> answers,
  }) async {
    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReflectionPage(
          meetingNumber: widget.meetingNumber,
          questions: questions,
          answers: answers,
        ),
      ),
    );

    if (completed == true && mounted) {
      setState(() {
        widget.progress.completeStage(LearningStage.reflection);
      });
      widget.onProgressChanged();
    }
  }
}
