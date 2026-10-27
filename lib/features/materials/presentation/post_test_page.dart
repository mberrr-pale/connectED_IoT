import 'package:flutter/material.dart';

class PostTestPage extends StatefulWidget {
  final int meetingNumber;

  const PostTestPage({super.key, required this.meetingNumber});

  @override
  State<PostTestPage> createState() => _PostTestPageState();
}

class _PostTestPageState extends State<PostTestPage> {
  int _currentQuestion = 0;

  // Data sementara untuk menguji alur halaman.
  // Nanti akan diganti dengan bank soal sebenarnya.
  final List<Map<String, dynamic>> _questions = [
    {
      'id': 1,
      'question': 'Sebuah sekolah ingin mengetahui suhu laboratorium tanpa harus selalu datang ke ruangan. Rancangan yang paling sesuai dengan konsep IoT adalah ...',
      'options': [
        'Menggunakan termometer biasa dan mencatat hasilnya setiap hari',
        'Memasang sensor suhu yang terhubung ke mikrokontroler dan mengirimkan data melalui jaringan',
        'Menggunakan komputer untuk mengetik suhu yang diperkirakan',
        'Menyimpan foto termometer di komputer tanpa mengolah datanya',
      ],
      'correctAnswer': 1,
      'explanation': 'Rancangan yang sesuai yaitu memasang sensor suhu yang terhubung ke mikrokontroler dan mengirimkan data melalui jaringan, karena sistem IoT memungkinkan kondisi ruangan dipantau dari jarak jauh tanpa harus melakukan pemeriksaan secara langsung.',
    },
    {
      'id': 2,
      'question': 'Pada sistem monitoring ruangan, sensor DHT22 membaca suhu, ESP32 mengolah data, dan data ditampilkan pada aplikasi. Peran ESP32 dalam alur tersebut adalah ...',
      'options': [
        'Membaca kondisi fisik tanpa bantuan sensor',
        'Menyimpan tampilan dashboard sebagai gambar',
        'Menggantikan fungsi jaringan internet',
        'Memproses data sensor dan menjalankan instruksi pengiriman data',
      ],
      'correctAnswer': 3,
      'explanation': 'Peran ESP32 yaitu memproses data sensor dan menjalankan instruksi pengiriman data, karena DHT22 hanya bertugas membaca suhu, sedangkan ESP32 yang mengolah hasil bacaan itu dan menjalankan program untuk meneruskannya ke layanan lain.',
    },
    {
      'id': 3,
      'question': 'Sebuah perangkat dapat membaca suhu melalui sensor, tetapi hasilnya tidak dapat dilihat dari perangkat lain. Komponen yang perlu diperiksa agar data dapat dikirim melalui jaringan adalah ...',
      'options': [
        'Konektivitas jaringan dan konfigurasi komunikasi perangkat',
        'Warna dan bentuk sensor suhu',
        'Ukuran tampilan LED',
        'Nama variabel yang tidak digunakan program',
      ],
      'correctAnswer': 0,
      'explanation': 'Komponen yang perlu diperiksa yaitu konektivitas jaringan dan konfigurasi komunikasi perangkat, karena data yang berhasil dibaca sensor belum tentu dapat diterima perangkat lain jika koneksi atau pengaturan komunikasinya belum sesuai. Jadi, bila data hanya terlihat di satu perangkat, yang diperiksa adalah jalur pengirimannya, bukan sensornya.',
    },
    {
      'id': 4,
      'question': 'Apa urutan alur kerja yang paling tepat pada sistem monitoring IoT sederhana?',
      'options': [
        'Dashboard → sensor → ESP32 → jaringan',
        'ESP32 → dashboard → sensor → cloud',
        'Sensor → ESP32 → jaringan/cloud → dashboard',
        'Cloud → sensor → dashboard → ESP32',
      ],
      'correctAnswer': 2,
      'explanation': 'Urutan yang paling tepat yaitu sensor → ESP32 → jaringan/cloud → dashboard, karena sensor membaca kondisi lingkungan, ESP32 memproses data tersebut, jaringan meneruskannya ke layanan tujuan, dan dashboard menampilkan informasinya kepada pengguna. Setiap tahap bergantung pada hasil tahap sebelumnya, sehingga urutannya tidak dapat dibalik.',
    },
    {
      'id': 5,
      'question': 'Dalam simulasi Wokwi, LED harus menyala selama satu detik lalu mati selama satu detik secara berulang. Pendekatan program yang paling sesuai adalah ...',
      'options': [
        'Menyalakan LED sekali di `setup()` tanpa instruksi lanjutan',
        'Mengatur keluaran LED dan mengulang instruksi nyala, jeda, mati, dan jeda dalam `loop()`',
        'Mengatur LED sebagai masukan dan menghapus seluruh jeda',
        'Menjalankan instruksi mati saja di dalam `loop()`',
      ],
      'correctAnswer': 1,
      'explanation': 'Pendekatan yang sesuai yaitu mengatur keluaran LED, lalu mengulang instruksi nyala, jeda, mati, dan jeda di dalam loop(), karena fungsi loop() menjalankan instruksi secara berulang selama program berjalan, sedangkan pengaturan pin LED sebagai keluaran cukup dilakukan sekali di setup().',
    },
    {
      'id': 6,
      'question': 'Program LED hanya menjalankan rangkaian instruksi berkedip satu kali setelah ESP32 dinyalakan, lalu tidak mengulangnya. Bagian program yang paling mungkin perlu diperiksa adalah ...',
      'options': [
        'Nama proyek Wokwi',
        'Jenis browser yang digunakan',
        'Warna LED pada diagram rangkaian',
        'Penempatan instruksi berkedip antara `setup()` dan `loop()`',
      ],
      'correctAnswer': 3,
      'explanation': 'Bagian yang perlu diperiksa yaitu penempatan instruksi berkedip, apakah berada di setup() atau loop(), karena setup() hanya dijalankan sekali saat program dimulai, sedangkan loop() digunakan untuk menjalankan instruksi berulang kali. Jika instruksi berkedip berada di setup(), LED hanya berkedip satu kali lalu berhenti.',
    },
    {
      'id': 7,
      'question': 'Ketika LED tidak menyala meskipun simulasi sudah dijalankan, langkah pemeriksaan awal yang paling tepat adalah ...',
      'options': [
        'Memeriksa sambungan pin, konfigurasi pin program, dan instruksi pengendalian LED',
        'Langsung mengganti ESP32 dengan sensor suhu',
        'Membuat dashboard sebelum memeriksa rangkaian',
        'Menghapus semua kode tanpa memeriksa penyebabnya',
      ],
      'correctAnswer': 0,
      'explanation': 'Langkah awal yang tepat yaitu memeriksa sambungan pin, konfigurasi pin pada program, dan instruksi pengendalian LED, karena LED yang tidak menyala dapat disebabkan oleh kesalahan pada rangkaian maupun pada program yang mengendalikannya. Pemeriksaan sebaiknya berurutan dari yang paling dasar, yaitu sambungan kaki LED, nomor pin di program, lalu instruksi menyalakan LED.',
    },
    {
      'id': 8,
      'question': 'Mengapa pengujian LED sederhana dilakukan sebelum menambahkan sensor ke proyek monitoring?',
      'options': [
        'Agar perangkat tidak membutuhkan program lagi',
        'Agar cloud dapat menyimpan data tanpa jaringan',
        'Untuk memastikan peserta didik memahami dasar pengendalian output oleh ESP32',
        'Untuk membuktikan bahwa LED dapat mengukur suhu',
      ],
      'correctAnswer': 2,
      'explanation': 'Pengujian LED dilakukan lebih dulu untuk memastikan pemahaman dasar pengendalian output oleh ESP32, karena pengujian ini membantu peserta didik memahami hubungan antara instruksi program dan respons perangkat sebelum menambahkan komponen lain. Dengan dasar tersebut, kesalahan yang muncul setelah sensor ditambahkan lebih mudah ditelusuri.',
    },
    {
      'id': 9,
      'question': 'Sebuah perangkat memiliki sensor dan mikrokontroler, tetapi belum mempunyai koneksi jaringan. Pernyataan yang paling tepat adalah ...',
      'options': [
        'Perangkat tersebut pasti sudah dapat dipantau dari mana saja',
        'Perangkat dapat membaca dan memproses data lokal, tetapi pemantauan melalui jaringan memerlukan konektivitas yang sesuai',
        'Sensor akan otomatis mengirimkan data ke semua dashboard',
        'Mikrokontroler tidak dapat menjalankan program tanpa cloud',
      ],
      'correctAnswer': 1,
      'explanation': 'Pernyataan yang paling tepat yaitu perangkat dapat membaca dan memproses data lokal, tetapi pemantauan melalui jaringan memerlukan konektivitas yang sesuai, karena sensor dan mikrokontroler dapat bekerja secara lokal tanpa internet, tetapi pengiriman data ke perangkat lain membutuhkan koneksi jaringan.',
    },
    {
      'id': 10,
      'question': 'Pada proyek akhir, peserta didik ingin mengembangkan simulasi LED menjadi sistem monitoring suhu dan kelembapan. Langkah pengembangan yang paling logis adalah ...',
      'options': [
        'Mengganti LED dengan dashboard dan menghapus ESP32',
        'Membuat grafik terlebih dahulu tanpa sumber data',
        'Menghubungkan sensor langsung ke dashboard tanpa pengendali',
        'Mempertahankan dasar proyek ESP32, menambahkan sensor, lalu mengembangkan komunikasi data dan dashboard',
      ],
      'correctAnswer': 3,
      'explanation': 'Langkah yang paling logis yaitu mempertahankan dasar proyek ESP32, menambahkan sensor, lalu mengembangkan komunikasi data dan dashboard, karena sistem IoT dibangun secara bertahap, mulai dari pengendalian perangkat, pembacaan sensor, pengiriman data, hingga penyajian informasi. Setiap tahap diuji terlebih dahulu sebelum melanjutkan, sehingga kesalahan lebih mudah dilacak.',
    },
  ];

  final List<int?> _answers = List<int?>.filled(10, null);

  void _nextQuestion() {
    if (_answers[_currentQuestion] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jawaban terlebih dahulu.')),
      );
      return;
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
      return;
    }

    var correctAnswers = 0;

    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }

    final score = (correctAnswers * 100 / _questions.length).round();

    Navigator.pop(context, {
      'score': score,
      'answers': List<int?>.from(_answers),
      'questions': _questions,
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final options = question['options'] as List<String>;
    final isLastQuestion = _currentQuestion == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post-test Pertemuan ${widget.meetingNumber}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestion + 1) / _questions.length,
              ),
              const SizedBox(height: 12),
              Text(
                'Soal ${_currentQuestion + 1} dari ${_questions.length}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Text(
                question['question'] as String,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RadioGroup<int>(
                  groupValue: _answers[_currentQuestion],
                  onChanged: (value) {
                    setState(() {
                      _answers[_currentQuestion] = value;
                    });
                  },
                  child: ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final isSelected = _answers[_currentQuestion] == index;

                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        title: Text(options[index]),
                        leading: Radio<int>(value: index),
                        onTap: () {
                          setState(() {
                            _answers[_currentQuestion] = index;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextQuestion,
                  child: Text(isLastQuestion ? 'Selesai' : 'Soal Berikutnya'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
