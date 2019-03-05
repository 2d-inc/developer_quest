import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree.dart';

/// A list of [Task]s. It represents the problems that need to be solved
/// before the game (mission) is successfully finished.
///
/// There is only one of this per world.
///
/// This is better that `List<Task>` because we can attach behavior
/// to this (like [update]) and only update the widgets once.
class TaskPool extends Aspect {
  // The projects that need to or are being worked on.
  final List<Task> workingTasks = [];

  // The projects that are done.
  final List<Task> doneTasks = [];

  TaskPool();

  /// The tasks that should be presented to the player so they can tackle
  /// them next.
  Iterable<TaskBlueprint> get availableTasks => taskTree.where((blueprint) =>
      !doneTasks.any((task) => task.blueprint == blueprint) &&
      !workingTasks.any((task) => task.blueprint == blueprint) &&
      blueprint.requirements.isSatisfiedIn(doneTasks.map((t) => t.blueprint)));

  void startTask(TaskBlueprint projectBlueprint) {
    Task task = Task(projectBlueprint);
    workingTasks.add(task);
    markDirty();
  }

  void update() {
    final List<Task> justCompleted = [];
    for (final task in workingTasks) {
      task.update();
      if (task.isComplete) {
        // TODO: update stats (add happiness, growth, etc.)
        justCompleted.add(task);
      }
    }

    if (justCompleted.isNotEmpty) {
      markDirty();
    }

    for (final task in justCompleted) {
      workingTasks.remove(task);
      doneTasks.add(task);
    }

    super.update();
  }
}
