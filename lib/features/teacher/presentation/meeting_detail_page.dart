import 'package:flutter/material.dart';
import 'package:connected_iot/models/learning_progress.dart';

import '../../../core/theme/app_colors.dart';
import '../../materials/data/meeting_learning_objectives.dart';
import 'pre_test_page.dart';
import 'learning_content_page.dart';
import 'learning_video_page.dart';
import 'post_test_page.dart';
import 'reflection_page.dart';
import 'preview_page.dart';

class MeetingDetailPage extends StatefulWidget {
  final int meetingNumber;
  final String meetingTitle;
  final VoidCallback onOpenSimulation;
  final VoidCallback onBack;
  final LearningStage? initialStage;

  const MeetingDetailPage({
    super.key,
    required this.meetingNumber,
    required this.meetingTitle,
    required this.onOpenSimulation,
    required this.onBack,
    this.initialStage,
  });

  @override
  State<MeetingDetailPage> createState() => _MeetingDetailPageState();
}

class _MeetingDetailPageState extends State<MeetingDetailPage> {
  bool _initialStageOpened = false;

  // Data post-test disimpan sementara untuk halaman Refleksi.
  List<Map<String, dynamic>> _lastQuestions = [];
  List<int?> _lastAnswers = [];

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

    final objective =
        meetingLearningObjectives[widget.meetingNumber] ??
        'Tujuan pembelajaran untuk pertemuan ini belum tersedia.';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text('Pertemuan ${widget.meetingNumber}'),
      ),
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

          // Tujuan pembelajaran.
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

          const SizedBox(height: 24),

          const Text(
            'Langkah Pembelajaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          for (int i = 0; i < stages.length; i++) _buildStageTile(stages[i]),
        ],
      ),
    );
  }

  Widget _buildStageTile(LearningStage stage) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(_getStageIcon(stage), color: AppColors.primary),
        ),
        title: Text(stage.label),
        // subtitle: const Text('Bisa diakses kapan saja'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _openStage(stage),
      ),
    );
  }

  IconData _getStageIcon(LearningStage stage) {
    switch (stage) {
      case LearningStage.preTest:
        return Icons.quiz_outlined;
      case LearningStage.material:
        return Icons.menu_book_rounded;
      case LearningStage.video:
        return Icons.play_circle_outline_rounded;
      case LearningStage.postTest:
        return Icons.fact_check_outlined;
      case LearningStage.reflection:
        return Icons.rate_review_outlined;
      case LearningStage.preview:
        return Icons.visibility_outlined;
    }
  }

  Future<void> _openStage(LearningStage stage) async {
    if (!mounted) return;

    switch (stage) {
      case LearningStage.preTest:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PreTestPage(meetingNumber: widget.meetingNumber),
          ),
        );
        break;

      case LearningStage.material:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LearningContentPage(meetingNumber: widget.meetingNumber),
          ),
        );
        break;

      case LearningStage.video:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LearningVideoPage(meetingNumber: widget.meetingNumber),
          ),
        );
        break;

      case LearningStage.postTest:
        await _openPostTest();
        break;

      case LearningStage.reflection:
        await _openReflection(questions: _lastQuestions, answers: _lastAnswers);
        break;

      case LearningStage.preview:
        final openSimulation = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => PreviewPage(
              meetingNumber: widget.meetingNumber,
              showSimulationButton: false,
              onOpenSimulation: () {
                Navigator.pop(context, true);
              },
            ),
          ),
        );

        if (!mounted) return;

        if (openSimulation == true) {
          widget.onOpenSimulation();

          // Tutup halaman detail setelah membuka simulasi.
          Navigator.pop(context);
        }
        break;
    }
  }

  Future<void> _openPostTest() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => PostTestPage(meetingNumber: widget.meetingNumber),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _lastQuestions = List<Map<String, dynamic>>.from(
        result['questions'] as List? ?? [],
      );

      _lastAnswers = List<int?>.from(result['answers'] as List? ?? []);
    });
  }

  Future<void> _openReflection({
    required List<Map<String, dynamic>> questions,
    required List<int?> answers,
  }) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReflectionPage(meetingNumber: widget.meetingNumber),
      ),
    );
  }
}