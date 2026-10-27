import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_progress.dart';

class ResultsPage extends StatelessWidget {
  final LearningProgress progress;

  const ResultsPage({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final completed = progress.completedStageCount;
    final total = LearningProgress.totalStages;
    final rate = progress.completionRate.clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Belajar')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProgressCard(completed, total, rate),
          const SizedBox(height: 24),
          Text(
            'Perbandingan Nilai',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Perbandingan nilai Pre-test dan Post-test pertama '
            'pada setiap pertemuan.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 12),
          ...List.generate(LearningProgress.totalMeetings, (index) {
            final number = index + 1;
            final meeting = progress.meetings[number]!;

            return _buildMeetingResult(number: number, meeting: meeting);
          }),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int completed, int total, double rate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progres Pembelajaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${(rate * 100).round()}%',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(value: rate, minHeight: 8),
            ),
            const SizedBox(height: 8),
            Text('$completed dari $total tahap selesai'),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingResult({
    required int number,
    required MeetingProgress meeting,
  }) {
    final preTest = meeting.preTestScore;
    final postTest = meeting.firstPostTestScore;
    final nGain = _calculateNGain(preTest, postTest);
    final nGainMassage = _getNGainCategory(preTest, postTest, nGain);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertemuan $number',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            _buildScoreBar(
              label: 'Pre-test',
              score: preTest,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            _buildScoreBar(
              label: 'Post-test pertama',
              score: postTest,
              color: Colors.teal,
            ),

            const Divider(height: 32),

            _buildInfoRow(
              'Post-test terbaik',
              meeting.bestPostTestScore == null
                  ? 'Belum ada'
                  : '${meeting.bestPostTestScore}/100',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Status kelulusan',
              meeting.passedPostTest ? 'Lulus' : 'Belum lulus',
              valueColor: meeting.passedPostTest
                  ? Colors.green.shade700
                  : AppColors.textSecondary,
            ),

            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'N-Gain',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nGain == null ? '-' : nGain.toStringAsFixed(3),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nGainMassage,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar({
    required String label,
    required int? score,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label)),
            Text(
              score == null ? 'Belum ada' : '$score/100',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: score == null ? 0 : score / 100,
            minHeight: 12,
            color: score == null ? Colors.grey.shade400 : color,
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  double? _calculateNGain(int? preTest, int? postTest) {
    if (preTest == null || postTest == null) {
      return null;
    }

    if (preTest < 0 || preTest >= 100 || postTest < 0 || postTest > 100) {
      return null;
    }

    return (postTest - preTest) / (100 - preTest);
  }

  String _getNGainCategory(int? preTest, int? postTest, double? nGain) {
    if (preTest == null || postTest == null) {
      return 'N-Gain belum tersedia karena nilai tes belum lengkap';
    }

    if (preTest < 0 || preTest > 100 || postTest < 0 || postTest > 100) {
      return 'Nilai tes tidak valid.';
    }

    if (preTest == 100 && postTest == 100) {
      return 'Skor Anda pada pertemuan ini mencapai maksimum.';
    }

    if (postTest < preTest) {
      return 'Anda mengalami penurunan nilai dibandingkan Pre-test.';
    }

    if (preTest == 100) {
      return 'Pre-test Anda telah mencapai skor maksimum.';
    }

    if (postTest == preTest) {
      return 'Skor Anda belum mengalami peningkatan.';
    }

    if (nGain == null) {
      return 'N-Gain belum tersedia.';
    }

    if (nGain >= 0.7) {
      return 'Kategori peningkatan: Tinggi';
    }

    if (nGain >= 0.3) {
      return 'Kategori peningkatan: Sedang';
    }

    return 'Kategori peningkatan: Rendah';
  }
}
