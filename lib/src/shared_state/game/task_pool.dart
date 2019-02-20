import 'dart:collection';

import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';

/// A list of [Task]s. It represents the problems that need to be solved
/// before the game (mission) is successfully finished.
///
/// There is only one of this per world.
///
/// This is better that `List<Task>` because we can attach behavior
/// to this (like [update]) and only update the widgets once.
class TaskPool extends Aspect with ListMixin<Task> {
  static const _seedQuestNames = [
    "Refactor state management",
    "Add animations",
    "Add tutorial",
    "Find bug #34412",
    "Shorten build time",
    "Add CI",
    "Deploy to TestFlight",
  ];

  final List<Task> list;

  TaskPool() : list = _seedQuestNames.map((name) => Task.sample(name)).toList();

  @override
  int get length => list.length;

  @override
  set length(int newLength) {
    list.length = newLength;
    markDirty();
  }

  @override
  Task operator [](int index) => list[index];

  @override
  void operator []=(int index, Task value) {
    list[index] = value;
    markDirty();
  }

  void update() {
    for (final task in this) {
      task.update();
      if (task.isDirty) markDirty();
    }

    super.update();
  }
}
