enum LearningStage {
  preTest('Pre-test'),
  material('Materi'),
  video('Video'),
  postTest('Post-test'),
  reflection('Refleksi'),
  preview('Preview');

  final String label;

  const LearningStage(this.label);
}

class MeetingProgress {
  static const int passingScore = 70;
  static const int maxAttemptsPerRound = 2;

  final int meetingNumber;
  final Set<LearningStage> completedStages = {};

  List<Map<String, dynamic>> lastPostTestQuestions = [];
  List<int?> lastPostTestAnswers = [];

  int? preTestScore;
  int? firstPostTestScore;
  int? bestPostTestScore;

  int attemptsInCurrentRound = 0;
  bool requiresReview = false;
  bool _materialReviewedAfterFailure = false;

  MeetingProgress({required this.meetingNumber});

  MeetingProgress.fromMap(Map<String, dynamic> map)
    : meetingNumber = (map['meetingNumber'] as num?)?.toInt() ?? 1 {
    final savedStages = map['completedStages'];

    if (savedStages is List) {
      for (final value in savedStages) {
        if (value is String) {
          for (final stage in LearningStage.values) {
            if (stage.name == value) {
              completedStages.add(stage);
              break;
            }
          }
        }
      }
    }

    preTestScore = (map['preTestScore'] as num?)?.toInt();
    firstPostTestScore = (map['firstPostTestScore'] as num?)?.toInt();
    bestPostTestScore = (map['bestPostTestScore'] as num?)?.toInt();

    attemptsInCurrentRound =
        (map['attemptsInCurrentRound'] as num?)?.toInt() ?? 0;

    requiresReview = map['requiresReview'] as bool? ?? false;

    _materialReviewedAfterFailure =
        map['materialReviewedAfterFailure'] as bool? ?? false;

    final savedQuestions = map['lastPostTestQuestions'];

    if (savedQuestions is List) {
      lastPostTestQuestions = savedQuestions
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    final savedAnswers = map['lastPostTestAnswers'];

    if (savedAnswers is List) {
      lastPostTestAnswers = savedAnswers.map<int?>((answer) {
        return answer is num ? answer.toInt() : null;
      }).toList();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'meetingNumber': meetingNumber,
      'completedStages': completedStages.map((stage) => stage.name).toList(),
      'preTestScore': preTestScore,
      'firstPostTestScore': firstPostTestScore,
      'bestPostTestScore': bestPostTestScore,
      'attemptsInCurrentRound': attemptsInCurrentRound,
      'requiresReview': requiresReview,
      'materialReviewedAfterFailure': _materialReviewedAfterFailure,
      'lastPostTestQuestions': lastPostTestQuestions,
      'lastPostTestAnswers': lastPostTestAnswers,
    };
  }

  bool get passedPostTest =>
      bestPostTestScore != null && bestPostTestScore! >= passingScore;
  
  bool get isMeetingCompleted =>
    LearningStage.values.every((stage) => completedStages.contains(stage));

  bool get canRetryPostTest =>
      !passedPostTest &&
      !requiresReview &&
      attemptsInCurrentRound < maxAttemptsPerRound;

  void recordPreTestResult({required int score}) {
    if (score < 0 || score > 100) {
      throw ArgumentError.value(
        score,
        'score',
        'Nilai harus berada pada rentang 0–100.',
      );
    }

    preTestScore = score;
  }

  bool isStageCompleted(LearningStage stage) {
    return completedStages.contains(stage);
  }

  void completeStage(LearningStage stage) {
    if (stage == LearningStage.postTest) {
      return;
    }

    if (stage == LearningStage.material && requiresReview) {
      completedStages.add(LearningStage.material);
      completedStages.remove(LearningStage.video);
      _materialReviewedAfterFailure = true;
      return;
    }

    if (stage == LearningStage.video && requiresReview) {
      if (!_materialReviewedAfterFailure) {
        return;
      }

      completedStages.add(LearningStage.video);

      attemptsInCurrentRound = 0;
      requiresReview = false;
      _materialReviewedAfterFailure = false;
      return;
    }

    completedStages.add(stage);
  }

  void recordPostTestResult({required int score}) {
    if (score < 0 || score > 100) {
      throw ArgumentError.value(
        score,
        'score',
        'Nilai harus berada pada rentang 0–100.',
      );
    }

    if (passedPostTest) {
      return;
    }

    if (requiresReview) {
      throw StateError(
        'Siswa harus mengulang Materi dan Video sebelum Post-test.',
      );
    }

    if (attemptsInCurrentRound >= maxAttemptsPerRound) {
      throw StateError(
        'Kesempatan Post-test habis. Siswa harus mengulang Materi dan Video.',
      );
    }

    attemptsInCurrentRound++;
    firstPostTestScore ??= score;

    if (bestPostTestScore == null || score > bestPostTestScore!) {
      bestPostTestScore = score;
    }

    if (score >= passingScore) {
      completedStages.add(LearningStage.postTest);
      return;
    }

    completedStages.remove(LearningStage.postTest);

    if (attemptsInCurrentRound >= maxAttemptsPerRound) {
      // Dua percobaan gagal: wajib mengulang Materi dan Video.
      requiresReview = true;
      _materialReviewedAfterFailure = false;

      completedStages.remove(LearningStage.material);
      completedStages.remove(LearningStage.video);
    }
  }
}

class LearningProgress {
  static const int totalMeetings = 4;
  static const int stagesPerMeeting = 6;
  static const int totalStages = totalMeetings * stagesPerMeeting;

  final Map<int, MeetingProgress> meetings;

  LearningProgress.initial()
    : meetings = {
        for (int i = 1; i <= totalMeetings; i++)
          i: MeetingProgress(meetingNumber: i),
      };

  LearningProgress.fromMap(Map<String, dynamic> map)
    : meetings = _meetingsFromMap(map['meetings']);

  static Map<int, MeetingProgress> _meetingsFromMap(dynamic savedMeetings) {
    final result = <int, MeetingProgress>{
      for (int i = 1; i <= totalMeetings; i++)
        i: MeetingProgress(meetingNumber: i),
    };

    if (savedMeetings is Map) {
      for (final entry in savedMeetings.entries) {
        final meetingNumber = int.tryParse(entry.key.toString());
        final data = entry.value;

        if (meetingNumber != null &&
            meetingNumber >= 1 &&
            meetingNumber <= totalMeetings &&
            data is Map) {
          result[meetingNumber] = MeetingProgress.fromMap(
            Map<String, dynamic>.from(data),
          );
        }
      }
    }

    return result;
  }

  Map<String, dynamic> toMap() {
    return {
      'meetings': {
        for (final entry in meetings.entries)
          entry.key.toString(): entry.value.toMap(),
      },
    };
  }

  int get completedStageCount {
    return meetings.values.fold(
      0,
      (total, meeting) => total + meeting.completedStages.length,
    );
  }

  double get completionRate => completedStageCount / totalStages;

  bool isMeetingUnlocked(int meetingNumber) {
    if (meetingNumber < 1 || meetingNumber > totalMeetings) {
      return false;
    }

    if (meetingNumber == 1) {
      return true;
    }

    return meetings[meetingNumber - 1]!.passedPostTest;
  }
}
