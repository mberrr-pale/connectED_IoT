import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/final_project_progress.dart';

class FinalProjectStorage {
  FinalProjectStorage._();

  static const String _storageKey = 'final_project_progress_v1';

  static Future<void> save(FinalProjectProgress progress) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_storageKey, jsonEncode(progress.toMap()));
  }

  static Future<FinalProjectProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null) {
      return FinalProjectProgress();
    }

    try {
      final decoded = jsonDecode(savedData);

      if (decoded is Map<String, dynamic>) {
        return FinalProjectProgress.fromMap(decoded);
      }
    } catch (_) {
      // Jika data rusak, mulai dengan checklist kosong.
    }

    return FinalProjectProgress();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
