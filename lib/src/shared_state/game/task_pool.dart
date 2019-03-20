import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree/task_tree.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

/// A list of [Task]s. It represents the problems that need to be solved
/// before the game (mission) is successfully finished.
///
/// There is only one of this per world.
///
/// This is better that `List<Task>` because we can attach behavior
/// to this (like [update]) and only update the widgets once.
class TaskPool extends AspectContainer with ChildAspect {
  // The projects that need to or are being worked on.
  final List<WorkItem> workItems = [];

  // The tasks that are done.
  final List<Task> completedTasks = [];

  // The tasks that are archived (user got their rewad).
  final List<Task> archivedTasks = [];

  // The bugs that are in the active work items.
  // Consider storing these in their own list if performance becomes an issue.
  Iterable<Bug> get bugs => workItems.whereType<Bug>();

  // The tasks from the active work items.
  Iterable<Task> get tasks => workItems.whereType<Task>();

  TaskPool();

  // The chance that a bug will show up on the next update. Mutate this as you
  // wish when tasks are completed. Consider increasing this more if the player
  // completes an issue faster (by tapping on it).
  double _bugChance = 0.0;
  static final Random _bugRandom = Random();
  int _ticksToBugRoll = 0;
  static const int bugRollTicks = 5;

  // Bug chance after adding a feature.
  static const double featureBugChance = 0.1;
  // Bug chance after a bug hits.
  static const double ambientBugChance = 0.0001;

  /// The tasks that should be presented to the player so they can tackle
  /// them next.
  Iterable<TaskBlueprint> get availableTasks => taskTree.where((blueprint) =>
      !completedTasks.any((task) => task.blueprint == blueprint) &&
      !workItems.any((item) => item is Task && item.blueprint == blueprint) &&
      !archivedTasks.any((task) => task.blueprint == blueprint) &&
      blueprint.requirements.isSatisfiedIn(
          (completedTasks + archivedTasks).map((t) => t.blueprint)));

  void startTask(TaskBlueprint projectBlueprint) {
    Task task = Task(projectBlueprint);
    addWorkItem(task);
  }

  void addWorkItem(WorkItem item) {
    addAspect(item);
    workItems.add(item);
    if (item is Bug) {
      // Dark days ahead...
      get<World>().company.joy -= item.priority.drainOfJoy;
    }
    markDirty();
  }

  void completeTask(Task task) {
    assert(workItems.contains(task));
    workItems.remove(task);
    completedTasks.add(task);
    markDirty();

    // For now we simply slightly increase the chance of a bug as a task
    // completes, consider using the time taken as a factor
    _bugChance += featureBugChance;
  }

  @override
  void update() {
    super.update();

    // Decrement remaining ticks to the next bugroll and wrap back around
    // when we get to 0.
    _ticksToBugRoll = (_ticksToBugRoll - 1 + bugRollTicks) % bugRollTicks;

    // No ticks left, roll the die.
    if (_ticksToBugRoll == 0 && _bugRandom.nextDouble() < _bugChance) {
      // Winner! Well...
      _bugChance = ambientBugChance;
      addWorkItem(Bug.random(get<World>().npcPool.availableSkills));
    }
  }

  void archiveTask(Task task) {
    assert(completedTasks.contains(task));
    completedTasks.remove(task);
    archivedTasks.add(task);
    removeAspect(task);
    markDirty();
  }

  void squashBug(Bug bug) {
    // Give back the joy.
    get<World>().company.joy += bug.priority.drainOfJoy;
    workItems.remove(bug);
    removeAspect(bug);
    markDirty();
  }
}
