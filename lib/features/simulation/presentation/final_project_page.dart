import 'package:flutter/material.dart';

import '../data/final_project_criteria.dart';
import '../models/final_project_progress.dart';
import '../services/final_project_storage.dart';

class FinalProjectPage extends StatefulWidget {
  const FinalProjectPage({super.key});

  @override
  State<FinalProjectPage> createState() => _FinalProjectPageState();
}

class _FinalProjectPageState extends State<FinalProjectPage> {
  FinalProjectProgress _progress = FinalProjectProgress();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await FinalProjectStorage.load();

    if (!mounted) return;

    setState(() {
      _progress = progress;
      _isLoading = false;
    });
  }

  Future<void> _toggleCriteria(int index, bool checked) async {
    if (_isSaving) return;

    setState(() {
      _progress.toggleCriteria(index, checked);
      _isSaving = true;
    });

    try {
      await FinalProjectStorage.save(_progress);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan checklist proyek.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proyek Akhir')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Sistem Monitoring Suhu dan Kelembapan '
                  'Ruangan Berbasis IoT',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gunakan checklist berikut untuk memantau '
                  'penyelesaian proyek akhir.',
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progres Proyek',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_progress.completedCount}/'
                      '${finalProjectCriteria.length}',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: _progress.completionRate),
                const SizedBox(height: 20),
                const Text(
                  'Kriteria Ceklis Proyek Akhir',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...List.generate(finalProjectCriteria.length, (index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      value: _progress.isChecked(index),
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              _toggleCriteria(index, value ?? false);
                            },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(finalProjectCriteria[index]),
                    ),
                  );
                }),
                if (_isSaving)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(child: Text('Menyimpan progres...')),
                  ),
              ],
            ),
    );
  }
}
