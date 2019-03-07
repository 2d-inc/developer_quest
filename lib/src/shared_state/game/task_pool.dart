import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
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
class TaskPool extends AspectContainer with ChildAspect {
  // The projects that need to or are being worked on.
  final List<Task> workingTasks = [];

  // The tasks that are done.
  final List<Task> completedTasks = [];

  // The tasks that are archived (user got their rewad).
  final List<Task> archivedTasks = [];

  TaskPool();

  /// The tasks that should be presented to the player so they can tackle
  /// them next.
  Iterable<TaskBlueprint> get availableTasks => taskTree.where((blueprint) =>
      !completedTasks.any((task) => task.blueprint == blueprint) &&
      !workingTasks.any((task) => task.blueprint == blueprint) &&
      !archivedTasks.any((task) => task.blueprint == blueprint) &&
      blueprint.requirements.isSatisfiedIn(
          (completedTasks + archivedTasks).map((t) => t.blueprint)));

  void startTask(TaskBlueprint projectBlueprint) {
    Task task = Task(projectBlueprint);
    addAspect(task);
    workingTasks.add(task);
    markDirty();
  }

  void completeTask(Task task) {
    // sanity check, only complete tasks that we were working on
    if (!workingTasks.contains(task)) {
      return;
    }
    workingTasks.remove(task);
    completedTasks.add(task);
  }

  void archiveTask(Task task) {
    // sanity check, archive tasks only after they are complete
    if (!completedTasks.contains(task)) {
      return;
    }
    completedTasks.remove(task);
    archivedTasks.add(task);
    removeAspect(task);
  }
}
