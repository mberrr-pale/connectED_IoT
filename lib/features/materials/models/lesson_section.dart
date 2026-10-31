enum LessonSectionType { text, image, bulletList }

class LessonSection {
  final String title;
  final LessonSectionType type;
  final String content;
  final String? imagePath;
  final String? caption;
  final List<String> bulletItems;

  const LessonSection({
    required this.title,
    required this.type,
    this.content = '',
    this.imagePath,
    this.caption,
    this.bulletItems = const [],
  });
}
