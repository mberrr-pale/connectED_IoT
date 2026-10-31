import 'package:shared_preferences/shared_preferences.dart';

import '../models/student_profile.dart';
import '../models/teacher_profile.dart';
import '../database/recap_database.dart';

class ProfileStorage {
  ProfileStorage._();

  static const String _nameKey = 'student_name';
  static const String _nisKey = 'student_nis';
  static const String _classKey = 'student_class';
  static const String _schoolKey = 'student_school';

  // Key profil guru
  static const String _teacherNameKey = 'teacher_name';
  static const String _teacherNipKey = 'teacher_nip';
  static const String _teacherSchoolKey = 'teacher_school';

  static Future<void> save(StudentProfile profile) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_nameKey, profile.name);
    await preferences.setString(_nisKey, profile.nis);
    await preferences.setString(_classKey, profile.studentClass);
    await preferences.setString(_schoolKey, profile.school);
  }

  static Future<StudentProfile?> load() async {
    final preferences = await SharedPreferences.getInstance();

    final name = preferences.getString(_nameKey);
    final nis = preferences.getString(_nisKey);
    final studentClass = preferences.getString(_classKey);
    final school = preferences.getString(_schoolKey);

    if (name == null || nis == null || studentClass == null || school == null) {
      return null;
    }

    return StudentProfile(
      name: name,
      nis: nis,
      studentClass: studentClass,
      school: school,
    );
  }

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_nameKey);
    await preferences.remove(_nisKey);
    await preferences.remove(_classKey);
    await preferences.remove(_schoolKey);
  }

  // PROFIL GURU
  static Future<void> saveTeacher(TeacherProfile profile) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_teacherNameKey, profile.name);
    await prefs.setString(_teacherNipKey, profile.nip);
    await prefs.setString(_teacherSchoolKey, profile.school);
  }

  static Future<TeacherProfile?> loadTeacher() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString(_teacherNameKey);
    final nip = prefs.getString(_teacherNipKey);
    final school = prefs.getString(_teacherSchoolKey);

    if (name == null || nip == null || school == null) {
      return null;
    }

    return TeacherProfile(name: name, nip: nip, school: school);
  }

  static Future<void> clearTeacher() async {
    final prefs = await SharedPreferences.getInstance();
    await RecapDatabase.instance.deleteAll();

    await prefs.remove(_teacherNameKey);
    await prefs.remove(_teacherNipKey);
    await prefs.remove(_teacherSchoolKey);
  }
}
