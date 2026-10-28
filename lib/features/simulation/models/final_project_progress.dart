class FinalProjectProgress {
  static const int totalCriteria = 10;

  final Set<int> checkedCriteria;

  FinalProjectProgress({Set<int>? checkedCriteria})
    : checkedCriteria = checkedCriteria ?? {};

  bool isChecked(int index) => checkedCriteria.contains(index);

  void toggleCriteria(int index, bool checked) {
    if (index < 0 || index >= totalCriteria) return;

    if (checked) {
      checkedCriteria.add(index);
    } else {
      checkedCriteria.remove(index);
    }
  }

  int get completedCount => checkedCriteria.length;

  double get completionRate => completedCount / totalCriteria;

  Map<String, dynamic> toMap() {
    return {'checkedCriteria': checkedCriteria.toList()..sort()};
  }

  factory FinalProjectProgress.fromMap(Map<String, dynamic> map) {
    final saved = map['checkedCriteria'];

    return FinalProjectProgress(
      checkedCriteria: saved is List
          ? saved
                .whereType<num>()
                .map((value) => value.toInt())
                .where((index) => index >= 0 && index < totalCriteria)
                .toSet()
          : <int>{},
    );
  }
}
