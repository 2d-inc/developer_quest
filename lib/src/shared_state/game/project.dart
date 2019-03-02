import 'package:dev_rpg/src/shared_state/game/project_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';

enum ProjectState { Started, Failed, Completed }

class Project extends Aspect {
  final ProjectBlueprint blueprint;

  // Want this to be final, but need a reference to this for the task to store the project.
  // Hmmmm... (see constructor).
  List<Task> tasks;

  double ticksRemaining;
  double totalTicks;
  int bonusXp = 0;

  Project(this.blueprint) {
    tasks = blueprint.taskBlueprints
        .map((taskBlueprint) => Task(this, taskBlueprint))
        .toList();
    // Give the player the difficulty value for number of ticks.
	// This means that if you immediately assign the minmimum resources
	// you will barely make it. Effectively, you have to assign better people
	// or boost the tasks by tapping them.
    ticksRemaining = totalTicks = blueprint.totalDifficulty;
  }

  bool get isComplete =>
      tasks.firstWhere((task) => task.percentComplete < 1.0,
          orElse: () => null) ==
      null;
  double get percentComplete =>
      tasks.fold<double>(
          0.0, (double value, Task task) => value + task.percentComplete) /
      tasks.length;

  ProjectState get state => isComplete
      ? ProjectState.Completed
      : percentTimeLeft > 0.0 ? ProjectState.Started : ProjectState.Failed;

  @override
  void update() {
    super.update();

    // Project started?
    if (ticksRemaining != null && ticksRemaining > 0) {
      ticksRemaining--;
      for (Task task in tasks) {
        task.update();
      }

      markDirty();
    }
  }

  double get percentTimeLeft => ticksRemaining / totalTicks;
}
