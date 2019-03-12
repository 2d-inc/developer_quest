import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';

List<BugPriority> bugChances = bugFrequency.keys
    .expand((bug) => List.generate(bugFrequency[bug], (_) => bug))
    .toList();

/// Map of Bug types to the frequency that they appear.
Map<BugPriority, int> bugFrequency = {
  BugPriority("P0", 0.9): 1,
  BugPriority("P1", 0.6): 2,
  BugPriority("P2", 0.3): 2,
  BugPriority("P3", 0.2): 3,
  BugPriority("P4", 0.1): 3,
};

// Build weighted list of priorities. Put each BugPriority type in the list
// n times, where n is the value in bugFrequency.
class Bug extends WorkItem {
  static final Random _randomizer = Random();
  final BugPriority priority;

  Bug(this.priority, Map<Skill, double> difficulty)
      : super(priority.name + " Bug!!", difficulty);

  Bug.random()
      : this(bugChances[_randomizer.nextInt(bugChances.length)],
            randomDifficulty(_randomizer));

  @override
  void onCompleted() {
    get<TaskPool>().squashBug(this);
    super.onCompleted();
  }
}

// A bug that randomly shows up in the work queue.
class BugPriority {
  final double drainOfJoy;
  final String name;

  BugPriority(this.name, this.drainOfJoy);

  @override
  String toString() => 'BugPriority($drainOfJoy, $name)';
}
