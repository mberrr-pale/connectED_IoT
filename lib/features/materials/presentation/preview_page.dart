import 'package:flutter/material.dart';

import '../data/previews/meeting_preview_data.dart';
import '../../simulation/data/final_project_criteria.dart';
import '../../simulation/models/final_project_progress.dart';
import '../../simulation/services/final_project_storage.dart';

class PreviewPage extends StatefulWidget {
  final int meetingNumber;
  final VoidCallback? onOpenSimulation;

  const PreviewPage({
    super.key,
    required this.meetingNumber,
    this.onOpenSimulation,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  static const Color _primary = Color(0xFF087E8B);
  static const Color _background = Color(0xFFF5F8FA);

  FinalProjectProgress _projectProgress = FinalProjectProgress();
  bool _projectProgressLoaded = false;
  bool _isSavingProjectProgress = false;

  @override
  void initState() {
    super.initState();

    if (widget.meetingNumber == 4) {
      _loadProjectProgress();
    }
  }

  Future<void> _loadProjectProgress() async {
    try {
      final progress = await FinalProjectStorage.load();

      if (!mounted) return;

      setState(() {
        _projectProgress = progress;
        _projectProgressLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _projectProgressLoaded = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checklist tugas akhir gagal dimuat.')),
      );
    }
  }

  Future<void> _toggleProjectCriteria(int index, bool checked) async {
    if (_isSavingProjectProgress) return;

    setState(() {
      _projectProgress.toggleCriteria(index, checked);
      _isSavingProjectProgress = true;
    });

    try {
      await FinalProjectStorage.save(_projectProgress);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _projectProgress.toggleCriteria(index, !checked);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checklist gagal disimpan. Coba lagi.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingProjectProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pertemuan 4 menggunakan halaman Tugas Akhir.
    // Periksa ini sebelum mengambil data Preview pertemuan.
    if (widget.meetingNumber == 4) {
      return _buildFinalProjectPage();
    }

    final content = meetingPreviewData[widget.meetingNumber];

    if (content == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview Pembelajaran')),
        body: const Center(child: Text('Preview pembelajaran belum tersedia.')),
      );
    }

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Preview Pembelajaran'),
        backgroundColor: _background,
        foregroundColor: _primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(content.title),
          const SizedBox(height: 24),

          _buildSectionHeading('Materi Selanjutnya'),
          _buildContentCard(
            child: Text(
              content.nextMaterialOverview,
              style: const TextStyle(height: 1.6),
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionHeading('Studi Kasus'),
          _buildContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.caseStudyTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content.caseStudyDescription,
                  style: const TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionHeading('Tujuan Pembelajaran'),
          _buildContentCard(
            child: Column(
              children: content.learningPoints
                  .map((point) => _buildLearningPoint(point))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionHeading('Hasil yang Diharapkan'),
          _buildContentCard(
            child: Text(
              content.expectedResult,
              style: const TextStyle(height: 1.6),
            ),
          ),
          const SizedBox(height: 24),

          _buildSimulationButton(
            title: 'Siap untuk praktik?',
            description: content.simulationInstruction,
            buttonLabel: 'Buka Simulasi Pertemuan ${widget.meetingNumber}',
          ),
        ],
      ),
    );
  }

  Widget _buildFinalProjectPage() {
    final completed = _projectProgress.completedCount;
    final total = finalProjectCriteria.length;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Tugas Akhir'),
        backgroundColor: _background,
        foregroundColor: _primary,
        elevation: 0,
      ),
      body: !_projectProgressLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(
                  'Sistem Monitoring Suhu dan Kelembapan Ruangan Berbasis IoT',
                ),
                const SizedBox(height: 20),

                _buildContentCard(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi Tugas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Buat simulasi sistem monitoring suhu dan kelembapan '
                        'menggunakan ESP32 dan sensor DHT22 di Wokwi. '
                        'Kirim data ke ThingSpeak, lalu periksa hasilnya '
                        'melalui dashboard dan grafik.',
                        style: TextStyle(height: 1.6),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Petunjuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Centang kriteria setelah kamu memeriksa bahwa '
                        'kriteria tersebut sudah terpenuhi. Checklist ini '
                        'merupakan pemeriksaan mandiri, bukan penilaian otomatis.',
                        style: TextStyle(height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionHeading('Checklist Tugas Akhir'),
                _buildContentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progres pengerjaan',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$completed dari $total',
                            style: const TextStyle(
                              color: _primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: total == 0 ? 0 : completed / total,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE3ECEF),
                        color: _primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                ...List.generate(finalProjectCriteria.length, (index) {
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFE4ECEF)),
                    ),
                    child: CheckboxListTile(
                      value: _projectProgress.isChecked(index),
                      onChanged: _isSavingProjectProgress
                          ? null
                          : (checked) {
                              if (checked != null) {
                                _toggleProjectCriteria(index, checked);
                              }
                            },
                      activeColor: _primary,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      title: Text(
                        '${index + 1}. ${finalProjectCriteria[index]}',
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
                _buildSimulationButton(
                  title: 'Siap menguji proyek?',
                  description:
                      'Buka simulasi Pertemuan 4 untuk mengerjakan '
                      'proyek akhir dan menguji sistem monitoring.',
                  buttonLabel: 'Buka Simulasi Pertemuan 4',
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: _primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4ECEF)),
      ),
      child: child,
    );
  }

  Widget _buildLearningPoint(String point) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: _primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(point, style: const TextStyle(height: 1.5))),
        ],
      ),
    );
  }

  Widget _buildSimulationButton({
    required String title,
    required String description,
    required String buttonLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F4F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(height: 1.6)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onOpenSimulation,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
