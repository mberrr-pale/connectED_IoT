
class SimulationCase {
  final String id;
  final int meetingNumber;
  final String title;
  final String description;
  final String scenario;
  final List<String> tasks;
  final String targetResult;
  final List<SimulationStep> steps;
  final String code;
  final String wokwiUrl;

  const SimulationCase({
    required this.id,
    required this.meetingNumber,
    required this.title,
    required this.description,
    required this.scenario,
    required this.tasks,
    required this.targetResult,
    required this.steps,
    required this.code,
    required this.wokwiUrl,
  });
}

class SimulationStep {
  final String title;
  final String description;

  const SimulationStep({
    required this.title,
    required this.description,
  });
}
