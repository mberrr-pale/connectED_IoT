import 'package:flutter/material.dart';
import 'package:connected_iot/models/learning_progress.dart';

import 'meeting_detail_page.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/student_profile.dart';
import '../../../services/profile_storage.dart';
import '../../../widgets/app_page_header.dart';

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

  StudentProfile? _profile;
  bool _isLoadingProfile = true;

  static const _meetingTitles = <int, String>{
    1: 'Mengenal Internet of Things',
    2: 'Mikrokontroler & Sensor',
    3: 'Protokol & Cloud IoT',
    4: 'Dashboard & Proyek Akhir',
  };

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
      if (!_progress.isMeetingUnlocked(number)) continue;

      final meeting = _progress.meetings[number]!;

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

  void _openMeeting(int number) {
    final unlocked = _progress.isMeetingUnlocked(number);

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

    final meeting = _progress.meetings[number]!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MeetingDetailPage(
          meetingNumber: number,
          meetingTitle: _meetingTitles[number]!,
          progress: meeting,
          isUnlocked: true,
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
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(
              title: 'Beranda',
              subtitle: 'Ringkasan aktivitas belajar',
              icon: Icons.dashboard_rounded,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 22),
                  _buildProgressCard(),
                  const SizedBox(height: 16),
                  _buildContinueCard(next),
                  const SizedBox(height: 28),
                  _buildSectionHeading(
                    title: 'Peta Perjalanan Belajar',
                    subtitle:
                        'Empat pertemuan untuk menguasai Internet of Things.',
                  ),
                  const SizedBox(height: 18),
                  _buildLearningMap(),
                  const SizedBox(height: 28),
                  _buildSectionHeading(
                    title: 'Aktivitas Belajar Terakhir',
                    subtitle: 'Lihat perkembangan aktivitas belajarmu.',
                  ),
                  const SizedBox(height: 12),
                  _buildRecentActivityCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
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
          'Selamat datang, $firstName! 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
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
    final percentage = (rate * 100).round();

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progres Belajar',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Terus lanjutkan perjalananmu!',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 82,
                  height: 82,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: rate,
                          strokeWidth: 7,
                          strokeCap: StrokeCap.round,
                          backgroundColor: AppColors.primaryLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'selesai',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tahap pembelajaran',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${_progress.completedStageCount}/${LearningProgress.totalStages}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: rate,
                minHeight: 8,
                backgroundColor: AppColors.primaryLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
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

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  isFinished
                      ? Icons.emoji_events_outlined
                      : Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isFinished
                ? 'Semua pembelajaran selesai!'
                : next != null
                ? 'Pertemuan ${next.meetingNumber} · '
                      '${_meetingTitles[next.meetingNumber]}'
                : 'Progres belajar perlu diperiksa',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            isFinished
                ? 'Hebat! Kamu telah menyelesaikan semua pertemuan.'
                : next != null
                ? 'Tahap berikutnya: ${next.stage.label}'
                : 'Periksa progres belajar sebelum melanjutkan.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _continueLearning,
              icon: Icon(
                isFinished
                    ? Icons.assessment_outlined
                    : Icons.arrow_forward_rounded,
              ),
              label: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningMap() {
    return Stack(
      children: [
        // Garis penghubung seperti tali di sisi kiri peta.
        Positioned(
          left: 13,
          top: 25,
          bottom: 25,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Column(
          children: [
            for (
              int number = 1;
              number <= LearningProgress.totalMeetings;
              number++
            ) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    child: Center(child: _buildTimelineDot(number)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _buildMeetingCard(number)),
                ],
              ),
              if (number < LearningProgress.totalMeetings)
                const SizedBox(height: 12),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineDot(int number) {
    final meeting = _progress.meetings[number]!;
    final unlocked = _progress.isMeetingUnlocked(number);
    final completed =
        meeting.passedPostTest &&
        LearningStage.values.every((stage) => meeting.isStageCompleted(stage));

    final Color dotColor;
    if (completed) {
      dotColor = AppColors.success;
    } else if (unlocked) {
      dotColor = number == 1 ? AppColors.primary : AppColors.cyan;
    } else {
      dotColor = AppColors.border;
    }

    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        color: unlocked ? dotColor : AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: dotColor, width: 2),
      ),
    );
  }

  Widget _buildMeetingCard(int number) {
    final meeting = _progress.meetings[number]!;
    final unlocked = _progress.isMeetingUnlocked(number);
    final completedStages = meeting.completedStages.length;

    final completed =
        meeting.passedPostTest &&
        LearningStage.values.every((stage) => meeting.isStageCompleted(stage));

    final Color accentColor;
    if (completed) {
      accentColor = AppColors.success;
    } else if (unlocked) {
      accentColor = AppColors.primary;
    } else {
      accentColor = AppColors.textMuted;
    }

    final String status;
    if (completed) {
      status = 'Selesai';
    } else if (!unlocked) {
      status = 'Terkunci';
    } else if (completedStages > 0) {
      status = 'Sedang dipelajari';
    } else {
      status = 'Tersedia';
    }

    final Color statusBackground;
    if (completed) {
      statusBackground = AppColors.successLight;
    } else if (!unlocked) {
      statusBackground = AppColors.disabledSurface;
    } else {
      statusBackground = AppColors.primaryLight;
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: unlocked ? accentColor : AppColors.border,
          width: unlocked && !completed ? 1.2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openMeeting(number),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: number == 1
                      ? AppColors.primaryLight
                      : number == 2
                      ? AppColors.cyanLight
                      : number == 3
                      ? AppColors.violetLight
                      : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : unlocked
                      ? Icons.auto_awesome_rounded
                      : Icons.lock_outline_rounded,
                  color: unlocked ? accentColor : AppColors.textMuted,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pertemuan $number',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _meetingTitles[number]!,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      unlocked
                          ? '$completedStages dari '
                                '${LearningProgress.stagesPerMeeting} tahap selesai'
                          : 'Lulus post-test pertemuan sebelumnya',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    unlocked
                        ? Icons.chevron_right_rounded
                        : Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? _getCurrentActivityMeetingNumber() {
    for (int number = 1; number <= LearningProgress.totalMeetings; number++) {
      final meeting = _progress.meetings[number]!;

      final isMeetingCompleted =
          meeting.passedPostTest &&
          LearningStage.values.every(
            (stage) => meeting.isStageCompleted(stage),
          );

      if (!isMeetingCompleted) {
        return number;
      }
    }

    return null;
  }

  Widget _buildRecentActivityCard() {
    final meetingNumber = _getCurrentActivityMeetingNumber();

    if (meetingNumber == null) {
      return Card(
        margin: EdgeInsets.zero,
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
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onOpenResult,
                  child: const Text('Lihat Semua Hasil'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final meeting = _progress.meetings[meetingNumber]!;
    final hasActivity =
        meeting.completedStages.isNotEmpty ||
        meeting.preTestScore != null ||
        meeting.firstPostTestScore != null ||
        meeting.bestPostTestScore != null;

    final completedStages = meeting.completedStages.length;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasActivity
                        ? 'Pertemuan $meetingNumber'
                        : 'Yuk, Mulai Belajar!',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              hasActivity
                  ? 'Progres belajar: $completedStages dari '
                        '${LearningProgress.stagesPerMeeting} tahap selesai.'
                  : meetingNumber == 1
                  ? 'Belum ada aktivitas belajar. Yuk, mulai '
                        'perjalanan belajar pertamamu!'
                  : 'Pertemuan sebelumnya sudah selesai. '
                        'Sekarang lanjutkan ke Pertemuan $meetingNumber!',
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
                fontSize: 13,
              ),
            ),
            if (hasActivity) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (completedStages / LearningProgress.stagesPerMeeting)
                      .clamp(0.0, 1.0),
                  minHeight: 7,
                  backgroundColor: AppColors.primaryLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              if (meeting.preTestScore != null) ...[
                const SizedBox(height: 14),
                _buildActivityScore('Nilai Pre-test', meeting.preTestScore!),
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
                child: Text(hasActivity ? 'Lihat Hasil' : 'Mulai Belajar'),
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
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(
          '$score/100',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
