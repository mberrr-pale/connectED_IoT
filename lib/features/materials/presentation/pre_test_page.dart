import 'package:flutter/material.dart';

class PreTestPage extends StatefulWidget {
  final int meetingNumber;

  const PreTestPage({
    super.key,
    required this.meetingNumber,
  });

  @override
  State<PreTestPage> createState() => _PreTestPageState();
}

class _PreTestPageState extends State<PreTestPage> {
  int _currentQuestion = 0;
  final List<int?> _answers = List<int?>.filled(7, null);

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Dashboard IoT berfungsi untuk...',
      'options': [
        'Memantau data perangkat',
        'Membuat sensor',
        'Memasang kabel',
        'Mengisi baterai',
      ],
    },
    {
      'question': 'Apa kepanjangan dari IoT?',
      'options': [
        'Internet of Things',
        'Input of Technology',
        'Integration of Tools',
        'Internet of Technology',
      ],
    },
    {
      'question': 'Sensor dalam sistem IoT digunakan untuk...',
      'options': [
        'Mendeteksi kondisi lingkungan',
        'Mencetak dokumen',
        'Mengisi daya perangkat',
        'Menghapus program',
      ],
    },
    {
      'question': 'Internet of Things menghubungkan perangkat agar dapat...',
      'options': [
        'Menghapus seluruh data',
        'Mencetak dokumen',
        'Bertukar data melalui jaringan',
        'Bekerja tanpa listrik',
      ],
    },
    {
      'question': 'Perangkat yang dapat digunakan untuk membaca suhu adalah...',
      'options': [
        'Sensor suhu',
        'Speaker',
        'Monitor',
        'Keyboard',
      ],
    },
    {
      'question': 'Data dari sensor dapat diproses oleh...',
      'options': [
        'Mikrokontroler',
        'Casing perangkat',
        'Kabel biasa tanpa rangkaian',
        'Dudukan perangkat',
      ],
    },
    {
      'question': 'Salah satu contoh penerapan IoT adalah...',
      'options': [
        'Lampu otomatis berbasis sensor',
        'Buku catatan biasa',
        'Meja tanpa perangkat elektronik',
        'Kertas gambar',
      ],
    },
  ];

  void _nextQuestion() {
    if (_answers[_currentQuestion] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jawaban terlebih dahulu.'),
        ),
      );
      return;
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final options = question['options'] as List<String>;
    final progress = (_currentQuestion + 1) / _questions.length;
    final isLastQuestion = _currentQuestion == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-test'),
        leadingWidth: 150,
        leading: TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('‹ Keluar dari kuis'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pre-test',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${_currentQuestion + 1}/${_questions.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                question['question'] as String,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final isSelected =
                        _answers[_currentQuestion] == index;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _answers[_currentQuestion] = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                          ),
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.08)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade200,
                              ),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(options[index])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    isLastQuestion ? 'Selesai  →' : 'Soal berikutnya  →',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
