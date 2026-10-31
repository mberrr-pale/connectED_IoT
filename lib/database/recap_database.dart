import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RecapRecord {
  final int? id;
  final String name;
  final String nis;
  final String studentClass;
  final String school;
  final String meeting;
  final String preTest;
  final String postTest;
  final String bestPostTest;
  final String nGain;
  final String nGainCategory;
  final String scannedAt;

  const RecapRecord({
    this.id,
    required this.name,
    required this.nis,
    required this.studentClass,
    required this.school,
    required this.meeting,
    required this.preTest,
    required this.postTest,
    required this.bestPostTest,
    required this.nGain,
    required this.nGainCategory,
    required this.scannedAt,
  });

  factory RecapRecord.fromQr(String raw) {
    final parts = raw.split('//').map((e) => e.trim()).toList();

    if (parts.length != 10 || parts.any((e) => e.isEmpty)) {
      throw const FormatException(
        'QR harus berisi 10 kolom yang dipisahkan dengan //.',
      );
    }

    if (!parts[4].toLowerCase().startsWith('pertemuan ')) {
      throw const FormatException('Format pertemuan tidak valid.');
    }

    return RecapRecord(
      name: parts[0],
      nis: parts[1],
      studentClass: parts[2],
      school: parts[3],
      meeting: parts[4],
      preTest: parts[5],
      postTest: parts[6],
      bestPostTest: parts[7],
      nGain: parts[8],
      nGainCategory: parts[9],
      scannedAt: DateTime.now().toIso8601String(),
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'nis': nis,
    'student_class': studentClass,
    'school': school,
    'meeting': meeting,
    'pre_test': preTest,
    'post_test': postTest,
    'best_post_test': bestPostTest,
    'n_gain': nGain,
    'n_gain_category': nGainCategory,
    'scanned_at': scannedAt,
  };

  factory RecapRecord.fromMap(Map<String, Object?> map) {
    return RecapRecord(
      id: map['id'] as int,
      name: map['name'] as String,
      nis: map['nis'] as String,
      studentClass: map['student_class'] as String,
      school: map['school'] as String,
      meeting: map['meeting'] as String,
      preTest: map['pre_test'] as String,
      postTest: map['post_test'] as String,
      bestPostTest: map['best_post_test'] as String,
      nGain: map['n_gain'] as String,
      nGainCategory: map['n_gain_category'] as String,
      scannedAt: map['scanned_at'] as String,
    );
  }
}

class RecapDatabase {
  RecapDatabase._();

  static final RecapDatabase instance = RecapDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = join(await getDatabasesPath(), 'teacher_recap.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recaps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            nis TEXT NOT NULL,
            student_class TEXT NOT NULL,
            school TEXT NOT NULL,
            meeting TEXT NOT NULL,
            pre_test TEXT NOT NULL,
            post_test TEXT NOT NULL,
            best_post_test TEXT NOT NULL,
            n_gain TEXT NOT NULL,
            n_gain_category TEXT NOT NULL,
            scanned_at TEXT NOT NULL,
            UNIQUE(nis, meeting)
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> insert(RecapRecord record) async {
    final db = await database;

    return db.insert(
      'recaps',
      record.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<RecapRecord>> getAll() async {
    final db = await database;
    final rows = await db.query('recaps', orderBy: 'id DESC');

    return rows.map(RecapRecord.fromMap).toList();
  }

  Future<int> deleteAll() async {
    final db = await database;
    return db.delete('recaps');
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;

    return db.delete('recaps', where: 'id = ?', whereArgs: [id]);
  }
}
