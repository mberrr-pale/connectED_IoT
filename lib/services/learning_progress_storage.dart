import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/learning_progress.dart';

class LearningProgressStorage {
  LearningProgressStorage._();

  static const String _storageKey = 'learning_progress_v1';

  static Future<void> save(LearningProgress progress) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_storageKey, jsonEncode(progress.toMap()));
  }

  static Future<LearningProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null) {
      return LearningProgress.initial();
    }

    try {
      final decoded = jsonDecode(savedData);

      if (decoded is Map<String, dynamic>) {
        return LearningProgress.fromMap(decoded);
      }
    } catch (_) {
      // Jika data tersimpan rusak, mulai dengan progres baru.
    }

    return LearningProgress.initial();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
