import 'package:flutter/material.dart';

import 'meeting_detail_page.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/learning_progress.dart';
import '../../../models/student_profile.dart';
import '../../../services/profile_storage.dart';

class HomePage extends StatefulWidget {
  final LearningProgress progress;
  final VoidCallback onProgressChanged;
  final VoidCallback onOpenSimulation;
  final VoidCallback onOpenResult;

  const HomePage({
    super.key,
    required this.progress,
    required this.onProgressChanged,
    required this.onOpenSimulation,
    required this.onOpenResult,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LearningProgress get _progress => widget.progress;

  bool get _isLearningFinished {
    for (int number = 1; number <= LearningProgress.totalMeetings; number++) {
      final meeting = _progress.meetings[number]!;

      if (!meeting.passedPostTest ||
          !LearningStage.values.every(
            (stage) => meeting.isStageCompleted(stage),
          )) {
        return false;
      }
    }

    return true;
  }

  StudentProfile? _profile;
  bool _isLoadingProfile = true;

  static const _meetingTitles = <int, String>{
    1: 'Pengenalan IoT',
    2: 'Komponen dan Sensor',
    3: 'Koneksi dan Komunikasi',
    4: 'Proyek Akhir IoT',
  };

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileStorage.load();

    if (!mounted) return;

    setState(() {
      _profile = profile;
      _isLoadingProfile = false;
    });
  }

  ({int meetingNumber, LearningStage stage})? _getNextStage() {
    for (int number = 1; number <= LearningProgress.totalMeetings; number++) {
      if (!widget.progress.isMeetingUnlocked(number)) {
        continue;
      }

      final meeting = widget.progress.meetings[number]!;

      // Jika wajib mengulang, prioritaskan Materi dan Video.
      if (meeting.requiresReview) {
        if (!meeting.isStageCompleted(LearningStage.material)) {
          return (meetingNumber: number, stage: LearningStage.material);
        }

        if (!meeting.isStageCompleted(LearningStage.video)) {
          return (meetingNumber: number, stage: LearningStage.video);
        }

        if (meeting.canRetryPostTest) {
          return (meetingNumber: number, stage: LearningStage.postTest);
        }

        continue;
      }

      for (final stage in LearningStage.values) {
        if (stage == LearningStage.postTest &&
            !meeting.canRetryPostTest &&
            !meeting.passedPostTest) {
          continue;
        }

        if (!meeting.isStageCompleted(stage)) {
          return (meetingNumber: number, stage: stage);
        }
      }
    }

    return null;
  }

  void _continueLearning() {
    if (_isLearningFinished) {
      widget.onOpenResult();
      return;
    }

    final next = _getNextStage();

    if (next == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Periksa kembali progres belajar sebelum melanjutkan.'),
        ),
      );
      return;
    }

    final meeting = _progress.meetings[next.meetingNumber]!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MeetingDetailPage(
          meetingNumber: next.meetingNumber,
          meetingTitle: _meetingTitles[next.meetingNumber]!,
          progress: meeting,
          isUnlocked: true,
          initialStage: next.stage,
          onProgressChanged: () {
            widget.onProgressChanged();
            if (mounted) setState(() {});
          },
          onOpenSimulation: widget.onOpenSimulation,
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final next = _getNextStage();

    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildGreeting(),
          const SizedBox(height: 24),
          _buildProgressCard(),
          const SizedBox(height: 20),
          _buildContinueCard(next),
          const SizedBox(height: 28),
          Text(
            'Peta Perjalanan Belajar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildMeetingCard(
            number: 1,
            title: _meetingTitles[1]!,
            color: AppColors.primaryLight,
          ),
          _buildMeetingCard(
            number: 2,
            title: _meetingTitles[2]!,
            color: AppColors.cyanLight,
          ),
          _buildMeetingCard(
            number: 3,
            title: _meetingTitles[3]!,
            color: AppColors.violetLight,
          ),
          _buildMeetingCard(
            number: 4,
            title: _meetingTitles[4]!,
            color: AppColors.warningLight,
          ),
          const SizedBox(height: 28),
          Text(
            'Aktivitas Belajar Terakhir',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          _buildRecentActivityCard(),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    if (_isLoadingProfile) {
      return const LinearProgressIndicator();
    }

    final profile = _profile;

    if (profile == null) {
      return const Text(
        'Identitas siswa belum tersedia.',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    final firstName = profile.name.trim().split(RegExp(r'\s+')).first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang, $firstName! 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Semangat belajar IoT hari ini. '
          'Terus berkembang dan coba hal baru!',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    final rate = _progress.completionRate.clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progres Belajar',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  '${(rate * 100).round()}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: rate,
                minHeight: 8,
                backgroundColor: AppColors.primaryLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_progress.completedStageCount} dari '
              '${LearningProgress.totalStages} tahap selesai.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueCard(({int meetingNumber, LearningStage stage})? next) {
    final isFinished = _isLearningFinished;
    final hasStarted = _progress.completedStageCount > 0;

    final buttonLabel = isFinished
        ? 'Lihat Hasil Belajar'
        : hasStarted
        ? 'Lanjutkan Belajar'
        : 'Mulai Belajar';

    return Card(
      color: AppColors.primaryLight.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle_outline_rounded),
                const SizedBox(width: 8),
                Text(
                  buttonLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isFinished
                  ? 'Semua pembelajaran selesai!'
                  : next != null
                  ? 'Pertemuan ${next.meetingNumber} • '
                        '${_meetingTitles[next.meetingNumber]}'
                  : 'Progres belajar perlu diperiksa',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              isFinished
                  ? 'Hebat! Kamu telah menyelesaikan semua pertemuan.'
                  : next != null
                  ? 'Tahap berikutnya: ${next.stage.label}'
                  : 'Periksa progres belajar sebelum melanjutkan.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _continueLearning,
                icon: Icon(
                  isFinished
                      ? Icons.assessment_outlined
                      : hasStarted
                      ? Icons.arrow_forward_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard({
    required int number,
    required String title,
    required Color color,
  }) {
    final meeting = _progress.meetings[number]!;
    final unlocked = _progress.isMeetingUnlocked(number);
    final completed = meeting.completedStages.length;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (!unlocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Lulus post-test pertemuan sebelumnya '
                  'untuk membuka pertemuan ini.',
                ),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MeetingDetailPage(
                meetingNumber: number,
                meetingTitle: title,
                progress: meeting,
                isUnlocked: unlocked,
                onProgressChanged: () {
                  widget.onProgressChanged();
                  if (mounted) setState(() {});
                },
                onOpenSimulation: widget.onOpenSimulation,
              ),
            ),
          ).then((_) {
            if (mounted) setState(() {});
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      unlocked
                          ? '$completed/6 tahap selesai'
                          : 'Terkunci • Lulus post-test sebelumnya',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                unlocked
                    ? Icons.chevron_right_rounded
                    : Icons.lock_outline_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
  int? _getCurrentActivityMeetingNumber() {
  for (int number = 1;
      number <= LearningProgress.totalMeetings;
      number++) {
    final meeting = _progress.meetings[number]!;

    final isMeetingCompleted = meeting.passedPostTest &&
        LearningStage.values.every(
          (stage) => meeting.isStageCompleted(stage),
        );

    if (!isMeetingCompleted) {
      return number;
    }
  }

  return null;
}

bool _hasActivity(MeetingProgress meeting) {
  return meeting.completedStages.isNotEmpty ||
      meeting.preTestScore != null ||
      meeting.firstPostTestScore != null ||
      meeting.bestPostTestScore != null;
}

Widget _buildRecentActivityCard() {
  final meetingNumber = _getCurrentActivityMeetingNumber();

  if (meetingNumber == null) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Semua Pertemuan Selesai! 🎉',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamu telah menyelesaikan seluruh perjalanan belajar. '
              'Lihat hasil belajarmu untuk mengetahui pencapaianmu.',
            ),
            TextButton(
              onPressed: widget.onOpenResult,
              child: const Text('Lihat Semua Hasil'),
            ),
          ],
        ),
      ),
    );
  }

  final meeting = _progress.meetings[meetingNumber]!;
  final hasActivity = _hasActivity(meeting);
  final completedStages = meeting.completedStages.length;

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasActivity
                ? 'Pertemuan $meetingNumber'
                : 'Yuk, Mulai Belajar!',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasActivity
                ? 'Progres belajar: $completedStages dari '
                    '${LearningProgress.stagesPerMeeting} tahap selesai.'
                : meetingNumber == 1
                    ? 'Belum ada aktivitas belajar. Yuk, mulai '
                        'perjalanan belajar pertamamu!'
                    : 'Pertemuan sebelumnya sudah selesai. '
                        'Sekarang lanjutkan ke Pertemuan $meetingNumber!',
          ),
          if (hasActivity) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: completedStages /
                  LearningProgress.stagesPerMeeting,
            ),
            if (meeting.preTestScore != null) ...[
              const SizedBox(height: 12),
              _buildActivityScore(
                'Nilai Pre-test',
                meeting.preTestScore!,
              ),
            ],
            if (meeting.firstPostTestScore != null) ...[
              const SizedBox(height: 8),
              _buildActivityScore(
                'Nilai Post-test',
                meeting.firstPostTestScore!,
              ),
            ],
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: hasActivity
                  ? widget.onOpenResult
                  : _continueLearning,
              child: Text(
                hasActivity ? 'Lihat Hasil' : 'Mulai Belajar',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildActivityScore(String label, int score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '$score/100',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
