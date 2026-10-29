import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/recap_database.dart';

const Color _primaryBlue = Color(0xFF2878FF);
const Color _background = Color(0xFFF5F8FD);
const Color _textColor = Color(0xFF102A50);
const Color _mutedColor = Color(0xFF7D91AD);
const Color _borderColor = Color(0xFFE4EBF5);

class TeacherRecapPage extends StatefulWidget {
  const TeacherRecapPage({super.key});

  @override
  State<TeacherRecapPage> createState() => _TeacherRecapPageState();
}

class _TeacherRecapPageState extends State<TeacherRecapPage>
    with WidgetsBindingObserver {
  late final MobileScannerController _scannerController;

  List<RecapRecord> _records = [];

  bool _isLoading = true;
  bool _isScanning = false;
  bool _isProcessing = false;
  bool _cameraAvailable = true;
  bool _isStarting = false;
  bool _cameraDisposed = false;

  String? _lastScannedCode;

  // Antrean agar operasi start dan stop tidak bertabrakan.
  Future<void> _cameraQueue = Future<void>.value();

  Future<void> _queueCameraOperation(Future<void> Function() operation) {
    final result = _cameraQueue.then((_) => operation());

    _cameraQueue = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );

    return result;
  }

  Future<void> _startCameraSafely() {
    return _queueCameraOperation(() async {
      if (!mounted || _cameraDisposed || !_isScanning || _isProcessing) {
        return;
      }

      if (_scannerController.value.isRunning) return;

      await _scannerController.start();
    });
  }

  Future<void> _stopCameraSafely() {
    return _queueCameraOperation(() async {
      if (_cameraDisposed) return;

      if (_scannerController.value.isRunning) {
        await _scannerController.stop();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      autoStart: false,
    );

    _loadRecords();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraDisposed = true;

    _cameraQueue = _cameraQueue.then<void>(
      (_) async {
        await _scannerController.dispose();
      },
      onError: (Object error, StackTrace stackTrace) async {
        await _scannerController.dispose();
      },
    );

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _stopCameraSafely();
    } else if (state == AppLifecycleState.resumed && _isScanning) {
      _startCameraSafely();
    }
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _loadRecords() async {
    try {
      final records = await RecapDatabase.instance.getAll();

      if (!mounted) return;

      setState(() {
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _message('Gagal memuat rekap: $e');
    }
  }

  Future<void> _showCameraSettingsDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Izin Kamera Diperlukan'),
        content: const Text(
          'Aplikasi memerlukan izin kamera untuk memindai '
          'QR Code siswa. Silakan aktifkan izin kamera '
          'melalui pengaturan aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  Future<void> _startScanning() async {
    if (_isProcessing || _isScanning || _isStarting) return;

    _isStarting = true;

    try {
      var status = await Permission.camera.status;

      if (!mounted) return;

      if (status.isDenied) {
        status = await Permission.camera.request();
      }

      if (!mounted) return;

      if (!status.isGranted) {
        setState(() {
          _isScanning = false;
          _cameraAvailable = false;
        });

        if (status.isPermanentlyDenied || status.isRestricted) {
          await _showCameraSettingsDialog();
        } else {
          _message(
            'Izin kamera belum diberikan. '
            'Izinkan akses kamera untuk memindai QR Code.',
          );
        }

        return;
      }

      setState(() {
        _isScanning = true;
        _lastScannedCode = null;
        _cameraAvailable = true;
      });

      await WidgetsBinding.instance.endOfFrame;

      if (!mounted || !_isScanning) return;

      await _startCameraSafely();

      if (mounted && _isScanning && !_scannerController.value.isRunning) {
        setState(() {
          _isScanning = false;
          _cameraAvailable = false;
        });

        _message('Kamera belum berhasil dijalankan.');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isScanning = false;
        _cameraAvailable = false;
      });

      _message('Kamera gagal dibuka: $e');
    } finally {
      _isStarting = false;
    }
  }

  Future<void> _stopScanning() async {
    if (!mounted) return;

    setState(() {
      _isScanning = false;
      _lastScannedCode = null;
    });

    try {
      await _stopCameraSafely();
    } catch (e) {
      if (mounted) {
        _message('Gagal menghentikan kamera: $e');
      }
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_isScanning || _isProcessing) return;

    String? raw;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;

      if (value != null && value.trim().isNotEmpty) {
        raw = value.trim();
        break;
      }
    }

    if (raw == null || raw == _lastScannedCode) return;

    _lastScannedCode = raw;

    setState(() => _isProcessing = true);

    try {
      await _stopCameraSafely();

      if (!mounted) return;

      final record = RecapRecord.fromQr(raw);
      final inserted = await RecapDatabase.instance.insert(record);

      if (!mounted) return;

      if (inserted == 0) {
        _message(
          'Data ${record.name} untuk '
          '${record.meeting} sudah ada.',
        );
      } else {
        await _loadRecords();

        if (!mounted) return;

        _message('Data ${record.name} berhasil disimpan.');
      }
    } on FormatException catch (e) {
      if (mounted) {
        _message('QR tidak valid: ${e.message}');
      }
    } catch (e) {
      if (mounted) {
        _message('Gagal menyimpan data: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);

        if (_isScanning) {
          try {
            await _startCameraSafely();
          } catch (e) {
            if (mounted) {
              setState(() {
                _isScanning = false;
                _cameraAvailable = false;
              });

              _message('Gagal melanjutkan pemindaian: $e');
            }
          }
        }
      }
    }
  }

  String _csvEscape(String value) {
    final escaped = value.replaceAll('"', '""');

    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"$escaped"';
    }

    return escaped;
  }

  List<String> get _headers => const [
    'ID',
    'Nama',
    'NIS',
    'Kelas',
    'Sekolah',
    'Pertemuan',
    'Pre-test',
    'Post-test',
    'Post-test Terbaik',
    'N-Gain',
    'Kategori N-Gain',
    'Waktu Scan',
  ];

  List<List<String>> _exportRows(List<RecapRecord> records) {
    return records.map((r) {
      return [
        r.id?.toString() ?? '',
        r.name,
        r.nis,
        r.studentClass,
        r.school,
        r.meeting,
        r.preTest,
        r.postTest,
        r.bestPostTest,
        r.nGain,
        r.nGainCategory,
        r.scannedAt,
      ];
    }).toList();
  }

  Future<List<RecapRecord>?> _prepareExport() async {
    final records = await RecapDatabase.instance.getAll();

    if (!mounted) return null;

    if (records.isEmpty) {
      _message('Belum ada data rekap untuk diekspor.');
      return null;
    }

    return records;
  }

  Future<void> _exportCsv() async {
    try {
      final records = await _prepareExport();

      if (records == null || !mounted) return;

      final rows = <List<String>>[_headers, ..._exportRows(records)];

      final csv =
          '\uFEFF${rows.map((row) => row.map(_csvEscape).join(',')).join('\r\n')}';

      final directory = await getTemporaryDirectory();

      final file = File(
        '${directory.path}/rekap_siswa_'
        '${DateTime.now().millisecondsSinceEpoch}.csv',
      );

      await file.writeAsBytes(utf8.encode(csv), flush: true);

      if (!mounted) return;

      await SharePlus.instance.share(
        ShareParams(
          title: 'Ekspor Rekap Siswa CSV',
          text: 'Rekap hasil belajar siswa',
          files: [XFile(file.path, mimeType: 'text/csv')],
        ),
      );
    } catch (e) {
      if (mounted) {
        _message('Ekspor CSV gagal: $e');
      }
    }
  }

  Future<void> _exportExcel() async {
    try {
      final records = await _prepareExport();

      if (records == null || !mounted) return;

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.appendRow(_headers.map((value) => TextCellValue(value)).toList());

      for (final row in _exportRows(records)) {
        sheet.appendRow(row.map((value) => TextCellValue(value)).toList());
      }

      final bytes = excel.encode();

      if (bytes == null) {
        throw Exception('Gagal membuat file Excel.');
      }

      final directory = await getTemporaryDirectory();

      final file = File(
        '${directory.path}/rekap_siswa_'
        '${DateTime.now().millisecondsSinceEpoch}.xlsx',
      );

      await file.writeAsBytes(Uint8List.fromList(bytes), flush: true);

      if (!mounted) return;

      await SharePlus.instance.share(
        ShareParams(
          title: 'Ekspor Rekap Siswa Excel',
          text: 'Rekap hasil belajar siswa dalam format Excel',
          files: [
            XFile(
              file.path,
              mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        _message('Ekspor Excel gagal: $e');
      }
    }
  }

  Future<void> _deleteRecord(RecapRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus rekap siswa?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus data '
          '${record.name} untuk pertemuan ${record.meeting}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      if (record.id == null) {
        if (mounted) {
          _message('ID data tidak ditemukan.');
        }
        return;
      }
      await RecapDatabase.instance.deleteRecord(record.id!);

      await _loadRecords();

      if (mounted) {
        _message('Data ${record.name} berhasil dihapus.');
      }
    } catch (e) {
      if (mounted) {
        _message('Gagal menghapus data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadRecords,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              const Text(
                'REKAP HASIL SISWA',
                style: TextStyle(
                  fontSize: 10,
                  color: _primaryBlue,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Rekap Hasil Belajar Siswa',
                style: TextStyle(
                  fontSize: 23,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Pindai QR Code siswa untuk menyimpan '
                'hasil belajar secara otomatis ke database lokal.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: Color(0xFF617794),
                ),
              ),
              const SizedBox(height: 20),
              _buildScannerCard(),
              const SizedBox(height: 18),
              _buildSummaryCard(),
              const SizedBox(height: 12),
              _buildExportActions(),
              const SizedBox(height: 20),
              _buildTable(),
              const SizedBox(height: 12),
              if (_records.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _clearRecords,
                    icon: const Icon(Icons.delete_outline, size: 17),
                    label: const Text('Hapus semua rekap'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.qr_code_scanner_rounded,
                color: _primaryBlue,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Pemindai QR Code',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Scanner selalu terpasang agar controller
          // tidak diinisialisasi ulang setiap tombol ditekan.
          SizedBox(
            height: 290,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _scannerController,
                    // autoStart: false,
                    onDetect: _onDetect,
                    errorBuilder: (context, error) {
                      return Container(
                        color: _textColor,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Kamera tidak tersedia.\n'
                          '${error.errorCode.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),

                  // Tampilan ketika kamera belum aktif.
                  if (!_isScanning)
                    Container(
                      color: const Color(0xFFEDF4FF),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _cameraAvailable
                                ? Icons.qr_code_2_rounded
                                : Icons.no_photography_outlined,
                            size: 55,
                            color: _primaryBlue,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _cameraAvailable
                                ? 'Kamera belum diaktifkan'
                                : 'Kamera tidak tersedia',
                            style: const TextStyle(
                              color: _textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Arahkan kamera ke QR Code hasil siswa.',
                            style: TextStyle(color: _mutedColor, fontSize: 10),
                          ),
                        ],
                      ),
                    ),

                  // Bingkai target QR.
                  if (_isScanning)
                    IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),

                  // Tombol flash.
                  if (_isScanning)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton.filledTonal(
                        onPressed: () async {
                          try {
                            await _scannerController.toggleTorch();
                          } catch (e) {
                            if (mounted) {
                              _message('Gagal mengaktifkan flash: $e');
                            }
                          }
                        },
                        icon: const Icon(Icons.flash_on_rounded),
                        tooltip: 'Lampu flash',
                      ),
                    ),

                  // Indikator proses penyimpanan.
                  if (_isProcessing)
                    Container(
                      color: Colors.black45,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _isScanning
                  ? _stopScanning
                  : (_isProcessing || _isStarting)
                  ? null
                  : _startScanning,
              icon: Icon(
                _isScanning
                    ? Icons.stop_circle_outlined
                    : Icons.camera_alt_rounded,
                size: 18,
              ),
              label: Text(
                _isScanning ? 'Hentikan kamera' : 'Mulai Scan QR',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isScanning
                    ? const Color(0xFFE8EDF5)
                    : _primaryBlue,
                foregroundColor: _isScanning ? _textColor : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),

          if (_isScanning) ...[
            const SizedBox(height: 8),
            const Text(
              'Pastikan seluruh QR terlihat di dalam bingkai.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: _mutedColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: _primaryBlue,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total rekap tersimpan',
                  style: TextStyle(fontSize: 11, color: _mutedColor),
                ),
                const SizedBox(height: 3),
                Text(
                  _isLoading ? 'Memuat...' : '${_records.length} data',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: _loadRecords,
            icon: const Icon(Icons.refresh_rounded, color: _primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildExportActions() {
    return Row(
      children: [
        Expanded(
          child: _exportButton(
            label: 'Ekspor CSV',
            icon: Icons.description_outlined,
            onPressed: _exportCsv,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _exportButton(
            label: 'Ekspor Excel',
            icon: Icons.table_chart_rounded,
            onPressed: _exportExcel,
          ),
        ),
      ],
    );
  }

  Widget _exportButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 43,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryBlue,
          side: const BorderSide(color: _borderColor),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 15, 13, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Riwayat hasil siswa',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${_records.length} data',
                  style: const TextStyle(color: _mutedColor, fontSize: 10),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _borderColor),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_records.isEmpty)
            const _EmptyState()
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFFEDF2F8),
                ),
                headingRowHeight: 42,
                dataRowMinHeight: 45,
                dataRowMaxHeight: 58,
                horizontalMargin: 12,
                columnSpacing: 22,
                columns: const [
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('NIS')),
                  DataColumn(label: Text('Kelas')),
                  DataColumn(label: Text('Pertemuan')),
                  DataColumn(label: Text('Pre-test')),
                  DataColumn(label: Text('Post-test')),
                  DataColumn(label: Text('Terbaik')),
                  DataColumn(label: Text('N-Gain')),
                  DataColumn(label: Text('Kategori')),
                  DataColumn(label: Text('Sekolah')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _records.map((record) {
                  return DataRow(
                    cells: [
                      DataCell(_cell(record.name)),
                      DataCell(_cell(record.nis)),
                      DataCell(_cell(record.studentClass)),
                      DataCell(_cell(record.meeting)),
                      DataCell(_cell(record.preTest)),
                      DataCell(_cell(record.postTest)),
                      DataCell(_cell(record.bestPostTest)),
                      DataCell(_cell(record.nGain)),
                      DataCell(_cell(record.nGainCategory)),
                      DataCell(_cell(record.school)),
                      DataCell(
                        IconButton(
                          tooltip: 'Hapus data',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => _deleteRecord(record),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cell(String value) {
    return Text(value, style: const TextStyle(color: _textColor, fontSize: 11));
  }

  Future<void> _clearRecords() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus semua rekap?'),
        content: const Text(
          'Semua data rekap di database lokal '
          'akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus semua'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await RecapDatabase.instance.deleteAll();
      await _loadRecords();

      if (mounted) {
        _message('Semua rekap berhasil dihapus.');
      }
    } catch (e) {
      if (mounted) {
        _message('Gagal menghapus rekap: $e');
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 32, 18, 32),
      child: Column(
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 38,
            color: Color(0xFF879BB8),
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada data rekap',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Mulai scan QR Code siswa untuk menyimpan '
            'hasil belajar ke database.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, height: 1.5, color: _mutedColor),
          ),
        ],
      ),
    );
  }
}
