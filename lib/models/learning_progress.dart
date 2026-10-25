
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

  int? firstPostTestScore;
  int? bestPostTestScore;

  int attemptsInCurrentRound = 0;
  bool requiresReview = false;
  bool _materialReviewedAfterFailure = false;

  MeetingProgress({required this.meetingNumber});

  bool get passedPostTest =>
      bestPostTestScore != null &&
      bestPostTestScore! >= passingScore;

  bool get canRetryPostTest =>
      !passedPostTest &&
      !requiresReview &&
      attemptsInCurrentRound < maxAttemptsPerRound;

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

      // Materi dan video sudah diulang.
      // Buka putaran Post-test berikutnya.
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
