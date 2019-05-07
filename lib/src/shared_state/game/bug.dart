import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';

/// Build weighted list of priorities. Put each BugPriority type in the list
/// n times, where n is the value in bugFrequency.
List<BugPriority> bugChances = bugFrequency.keys
    .expand((bug) => List.generate(bugFrequency[bug], (_) => bug))
    .toList();

/// Map of Bug types to the frequency that they appear.
Map<BugPriority, int> bugFrequency = {
  BugPriority('P0', 0.9): 1,
  BugPriority('P1', 0.6): 2,
  BugPriority('P2', 0.3): 2,
  BugPriority('P3', 0.2): 3,
  BugPriority('P4', 0.1): 3,
};

/// A bug that randomly shows up in the work queue.
class Bug extends WorkItem {
  static Random randomizer = Random();
  final BugPriority priority;

  Bug(this.priority, Map<Skill, double> difficulty)
      : super(priority.name + ' Bug!!', difficulty);

  Bug.random(Set<Skill> availableSkills)
      : this(bugChances[randomizer.nextInt(bugChances.length)],
            randomDifficulty(randomizer, availableSkills));

  @override
  void onCompleted() {
    get<TaskPool>().squashBug(this);
    super.onCompleted();
    markDirty();
  }
}

class BugPriority {
  final double drainOfJoy;
  final String name;

  BugPriority(this.name, this.drainOfJoy);

  @override
  String toString() => 'BugPriority($drainOfJoy, $name)';
}
