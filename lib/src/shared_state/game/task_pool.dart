import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree/task_tree.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

/// A grouping of tasks necessary to complete to achieve a goal,
/// named by [label]. The tasks can have sub-tasks and are stored
/// recursively in [TaskNode].
class Milestone {
  final String label;
  final List<TaskNode> tasks = [];

  Milestone(this.label, List<TaskNode> taskNodes) {
    tasks.addAll(taskNodes);
  }
}

/// A list of [Task]s. It represents the problems that need to be solved
/// before the game (mission) is successfully finished.
///
/// There is only one of this per world.
///
/// This is better that `List<Task>` because we can attach behavior
/// to this (like [update]) and only update the widgets once.
class TaskPool extends AspectContainer with ChildAspect {
  // The projects that are being worked on.
  final List<WorkItem> workItems = [];

  // The tasks that are done.
  final List<Task> completedTasks = [];

  // The tasks that are archived (user got their rewad).
  final List<Task> archivedTasks = [];

  /// The bugs that should be presented to the player so they can tackle
  /// them next.
  final List<Bug> availableBugs = [];

  // The tasks from the active work items.
  Iterable<Task> get tasks => workItems.whereType<Task>();

  final Milestone alpha;
  final Milestone beta;
  final Milestone v1;
  TaskPool()
      : alpha = Milestone('Alpha', [prototypeTaskNode]),
        beta = Milestone('Beta', alphaTaskNode.children),
        v1 = Milestone('Version 1.0', betaTaskNode.children) {
    // Patch up milestones by adding root task to previous list.
    // N.B. in Guido's designs this is the 'LAUNCH' task which
    // triggers a minigame.
    alphaTaskNode.children.clear();
    alpha.tasks.add(alphaTaskNode);

    betaTaskNode.children.clear();
    beta.tasks.add(betaTaskNode);

    v1.tasks.add(launchTaskNode);
  }

  // The chance that a bug will show up on the next update. Mutate this as you
  // wish when tasks are completed. Consider increasing this more if the player
  // completes an issue faster (by tapping on it).
  double _bugChance = 0;
  static Random bugRandom = Random();
  int _ticksToBugRoll = 0;
  int _numberOfBugsToAdd = 1;
  static const int bugRollTicks = 5;

  // Bug chance after adding a feature.
  static const double featureBugChance = 0.1;
  // Bug chance after a bug hits.
  static const double ambientBugChance = 0.0001;
  // Default number of bugs to add.
  static const int defaultBugNumber = 1;

  /// The tasks that should be presented to the player so they can tackle
  /// them next.
  Iterable<TaskBlueprint> get availableTasks => taskTree.where((blueprint) =>
      !tasks.any((item) => item.blueprint == blueprint) &&
      !completedTasks.any((task) => task.blueprint == blueprint) &&
      !archivedTasks.any((task) => task.blueprint == blueprint) &&
      blueprint.requirements.isSatisfiedIn(
          (completedTasks.followedBy(archivedTasks)).map((t) => t.blueprint)) &&
      blueprint.mutuallyExclusive.every(_hasNotStartedTask));

  Task startTask(TaskBlueprint projectBlueprint) {
    Task task = Task(projectBlueprint);
    addWorkItem(task);
    return task;
  }

  void addWorkItem(WorkItem item) {
    if (item is Bug) {
      // Take the bug out of the available list as it's now being actively
      // worked on.
      assert(availableBugs.contains(item));
      availableBugs.remove(item);
    }

    addAspect(item);
    workItems.add(item);
    markDirty();
  }

  void addBug(Bug bug) {
    get<World>().company.joy.number -= bug.priority.drainOfJoy;
    availableBugs.add(bug);
    markDirty();
  }

  void completeTask(Task task) {
    assert(workItems.contains(task));
    workItems.remove(task);
    completedTasks.add(task);
    markDirty();

    // Sum bug chances from assigned characters and built-in bug chance.
    double totalBugChance = task.assignedTeam
        .fold(featureBugChance, (a, b) => a + b.bugChanceOffset);
    _bugChance += totalBugChance;
    int maxBugsAdded = task.assignedTeam
        .fold(defaultBugNumber, (a, b) => max(a, b.bugQuantity));
    _numberOfBugsToAdd =
        max(defaultBugNumber, bugRandom.nextInt(maxBugsAdded) + 1);
  }

  @override
  void update() {
    super.update();

    // Decrement remaining ticks to the next bugroll and wrap back around
    // when we get to 0.
    _ticksToBugRoll = (_ticksToBugRoll - 1 + bugRollTicks) % bugRollTicks;

    // No ticks left, roll the die.
    if (_ticksToBugRoll == 0 && bugRandom.nextDouble() < _bugChance) {
      // Winner! Well...
      _bugChance = ambientBugChance;
      for (int i = 0; i < _numberOfBugsToAdd; i++) {
        addBug(Bug.random(get<World>().characterPool.availableSkills));
      }
      _numberOfBugsToAdd = defaultBugNumber;
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
    get<World>().company.joy.number += bug.priority.drainOfJoy;
    workItems.remove(bug);
    removeAspect(bug);
    markDirty();
  }

  bool _hasNotStartedTask(String name) {
    for (final task in tasks) {
      if (task.name == name) return false;
    }
    for (final task in completedTasks) {
      if (task.name == name) return false;
    }
    for (final task in archivedTasks) {
      if (task.name == name) return false;
    }
    return true;
  }

  void reset() {
    _ticksToBugRoll = 0;
    _bugChance = 0;
    workItems.clear();
    completedTasks.clear();
    archivedTasks.clear();
    availableBugs.clear();
  }
}
