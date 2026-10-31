class TeacherProfile {
  final String name;
  final String nip;
  final String school;

  const TeacherProfile({
    required this.name,
    required this.nip,
    required this.school,
  });

  Map<String, String> toMap() {
    return {'name': name, 'nip': nip, 'school': school};
  }

  factory TeacherProfile.fromMap(Map<String, String> map) {
    return TeacherProfile(
      name: map['name'] ?? '',
      nip: map['nip'] ?? '',
      school: map['school'] ?? '',
    );
  }
}
