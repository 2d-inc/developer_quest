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

  // The tasks that are done.
  final List<Task> doneTasks = [];

  // The tasks that are archived (user got their rewad).
  final List<Task> archivedTasks = [];

  TaskPool();

  /// The tasks that should be presented to the player so they can tackle
  /// them next.
  Iterable<TaskBlueprint> get availableTasks => taskTree.where((blueprint) =>
      !doneTasks.any((task) => task.blueprint == blueprint) &&
      !workingTasks.any((task) => task.blueprint == blueprint) &&
      !archivedTasks.any((task) => task.blueprint == blueprint) &&
      blueprint.requirements.isSatisfiedIn((doneTasks+archivedTasks).map((t) => t.blueprint)));

  void startTask(TaskBlueprint projectBlueprint) {
    Task task = Task(projectBlueprint);
    workingTasks.add(task);
    markDirty();
  }

  void update() {
    final List<Task> justCompleted = [];
    for (final task in workingTasks) {
      task.update();
      if (task.state == TaskState.completed) {
        // TODO: update stats (add happiness, growth, etc.)
        justCompleted.add(task);
      }
    }

    for (final task in justCompleted) {
      workingTasks.remove(task);
      doneTasks.add(task);
    }

    // we also update the done tasks (the ones we're waiting for the user to collect their reward from).
    final List<Task> justArchived = [];
    for (final task in doneTasks) {
      task.update();
      if (task.state == TaskState.rewarded) {
        justArchived.add(task);
      }
    }

    for (final task in justArchived) {
      doneTasks.remove(task);
      archivedTasks.add(task);
    }

    if ((justCompleted + justArchived).isNotEmpty) {
      markDirty();
    }

    super.update();
  }
}
