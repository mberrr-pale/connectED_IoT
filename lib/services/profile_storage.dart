
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student_profile.dart';

class ProfileStorage {
  ProfileStorage._();

  static const String _nameKey = 'student_name';
  static const String _nisKey = 'student_nis';
  static const String _classKey = 'student_class';
  static const String _schoolKey = 'student_school';

  static Future<void> save(StudentProfile profile) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_nameKey, profile.name);
    await preferences.setString(_nisKey, profile.nis);
    await preferences.setString(
      _classKey,
      profile.studentClass,
    );
    await preferences.setString(_schoolKey, profile.school);
  }

  static Future<StudentProfile?> load() async {
    final preferences = await SharedPreferences.getInstance();

    final name = preferences.getString(_nameKey);
    final nis = preferences.getString(_nisKey);
    final studentClass = preferences.getString(_classKey);
    final school = preferences.getString(_schoolKey);

    if (name == null ||
        nis == null ||
        studentClass == null ||
        school == null) {
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
}
