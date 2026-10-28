import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../materials/models/lesson_section.dart';
import '../../materials/data/material/meeting_1_material.dart';
import '../../materials/data/material/meeting_2_material.dart';
import '../../materials/data/material/meeting_3_material.dart';
import '../../materials/data/material/meeting_4_material.dart';

class LearningContentPage extends StatefulWidget {
  final int meetingNumber;

  const LearningContentPage({super.key, required this.meetingNumber});

  @override
  State<LearningContentPage> createState() => _LearningContentPageState();
}

class _LearningContentPageState extends State<LearningContentPage> {
  int _currentStep = 0;

  late final List<_MaterialStep> _steps;

  @override
  void initState() {
    super.initState();

    _steps = switch (widget.meetingNumber) {
      1 => _buildMeetingOneSteps(),
      2 => _buildMeetingTwoSteps(),
      3 => _buildMeetingThreeSteps(),
      4 => _buildMeetingFourSteps(),
      _ => _buildPlaceholderSteps(),
    };
  }

  List<_MaterialStep> _buildPlaceholderSteps() {
    return [
      _MaterialStep.notice(
        title: 'Materi belum tersedia',
        content:
            'Materi Pertemuan ${widget.meetingNumber} sedang '
            'disiapkan. Silakan kembali nanti.',
      ),
    ];
  }

  List<_MaterialStep> _buildMeetingOneSteps() {
    final sections = meeting1Sections;
    final steps = <_MaterialStep>[];

    for (var i = 0; i < sections.length; i++) {
      steps.add(_MaterialStep.content(sections[i]));

      if (sections[i].title == 'Pengertian dan Fungsi Mikrokontroler') {
        steps.add(
          const _MaterialStep.quiz(
            title: 'Cek Pemahaman Pertemuan 1',
            question: 'Apa fungsi utama mikrokontroler dalam sistem IoT?',
            options: [
              'Mendeteksi suhu dan kelembapan secara langsung',
              'Menampilkan data monitoring dalam bentuk grafik',
              'Menjalankan program untuk memproses data dan '
                  'mengendalikan komponen',
              'Menyimpan seluruh data monitoring ke dalam cloud',
            ],
            correctAnswerIndex: 2,
            explanation:
                'Mikrokontroler berfungsi menjalankan program untuk '
                'menerima masukan, memproses data, dan mengendalikan '
                'komponen lain. Contohnya, ESP32 dapat membaca data '
                'dari sensor dan mengirimkannya melalui jaringan Wi-Fi.',
          ),
        );
      }
    }

    return steps;
  }

  List<_MaterialStep> _buildMeetingTwoSteps() {
    final sections = meeting2Sections;
    final steps = <_MaterialStep>[];

    for (var i = 0; i < sections.length; i++) {
      steps.add(_MaterialStep.content(sections[i]));

      if (sections[i].title == 'Sensor yang Digunakan dalam Proyek') {
        steps.add(
          const _MaterialStep.quiz(
            title: 'Cek Pemahaman Pertemuan 2',
            question:
                'Sensor manakah yang digunakan untuk mengukur '
                'suhu dan kelembapan udara?',
            options: [
              'Sensor LDR',
              'Sensor PIR',
              'Sensor DHT22',
              'Sensor HC-SR04',
            ],
            correctAnswerIndex: 2,
            explanation:
                'DHT22 digunakan untuk membaca suhu dan kelembapan '
                'udara. LDR mendeteksi cahaya, PIR mendeteksi gerakan, '
                'sedangkan HC-SR04 digunakan untuk mengukur jarak.',
          ),
        );
      }
    }

    return steps;
  }

  List<_MaterialStep> _buildMeetingThreeSteps() {
    final sections = meeting3Sections;
    final steps = <_MaterialStep>[];

    for (var i = 0; i < sections.length; i++) {
      steps.add(_MaterialStep.content(sections[i]));

      if (sections[i].title == 'Perbedaan HTTP dan MQTT') {
        steps.add(
          const _MaterialStep.quiz(
            title: 'Cek Pemahaman Pertemuan 3',
            question:
                'Apa perbedaan utama antara HTTP dan MQTT '
                'dalam komunikasi IoT?',
            options: [
              'HTTP menggunakan broker, sedangkan MQTT '
                  'menggunakan endpoint web.',
              'HTTP menggunakan pola permintaan dan respons, '
                  'sedangkan MQTT menggunakan publish-subscribe.',
              'HTTP hanya mengirim data sensor, sedangkan MQTT '
                  'hanya menerima data.',
              'HTTP tidak membutuhkan konfigurasi, sedangkan '
                  'MQTT membutuhkannya.',
            ],
            correctAnswerIndex: 1,
            explanation:
                'HTTP menggunakan pola permintaan dan respons, '
                'sedangkan MQTT menggunakan mekanisme '
                'publish-subscribe melalui broker. Keduanya perlu '
                'disesuaikan dengan konfigurasi layanan penerima.',
          ),
        );
      }
    }

    return steps;
  }

  List<_MaterialStep> _buildMeetingFourSteps() {
    final sections = meeting4Sections;
    final steps = <_MaterialStep>[];

    for (var i = 0; i < sections.length; i++) {
      steps.add(_MaterialStep.content(sections[i]));

      if (sections[i].title == 'Bentuk Penyajian Data') {
        steps.add(
          const _MaterialStep.quiz(
            title: 'Cek Pemahaman Pertemuan 4',
            question:
                'Apa fungsi utama dashboard monitoring '
                'dalam sistem IoT?',
            options: [
              'Mengubah sensor menjadi perangkat mikrokontroler.',
              'Menampilkan data agar kondisi sistem mudah diamati.',
              'Menggantikan koneksi antara perangkat dan cloud.',
              'Mengirim data tanpa membutuhkan perangkat IoT.',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Dashboard monitoring menampilkan data dari perangkat '
                'atau layanan cloud sehingga pengguna dapat mengamati '
                'kondisi sistem dan perubahan data dari waktu ke waktu.',
          ),
        );
      }
    }

    return steps;
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
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
        Text(step.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(step.content, style: const TextStyle(fontSize: 16, height: 1.6)),
      ],
    );
  }

  Widget _buildQuiz(_MaterialStep step) {
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
          _buildAnswerOption(
            option: step.options[i],
            index: i,
            correctAnswerIndex: step.correctAnswerIndex!,
          ),

        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildAnswerLegend(
              color: Colors.green,
              icon: Icons.check_circle,
              label: 'Jawaban benar',
            ),
            _buildAnswerLegend(
              color: Colors.red,
              icon: Icons.cancel,
              label: 'Jawaban salah',
            ),
          ],
        ),
        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pembahasan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                step.explanation!,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerOption({
    required String option,
    required int index,
    required int correctAnswerIndex,
  }) {
    final isCorrect = index == correctAnswerIndex;
    final color = isCorrect ? Colors.green : Colors.red;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.7),
          width: isCorrect ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilihan ${String.fromCharCode(65 + index)}'
                  '${isCorrect ? ' • BENAR' : ' • SALAH'}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(option, style: const TextStyle(fontSize: 15, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerLegend({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
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
