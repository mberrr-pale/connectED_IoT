
class StudentProfile {
  final String name;
  final String nis;
  final String studentClass;
  final String school;

  const StudentProfile({
    required this.name,
    required this.nis,
    required this.studentClass,
    required this.school,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'nis': nis,
      'studentClass': studentClass,
      'school': school,
    };
  }

  factory StudentProfile.fromMap(Map<String, String> map) {
    return StudentProfile(
      name: map['name'] ?? '',
      nis: map['nis'] ?? '',
      studentClass: map['studentClass'] ?? '',
      school: map['school'] ?? '',
    );
  }
}
