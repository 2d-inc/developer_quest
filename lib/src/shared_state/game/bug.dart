import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'dart:math';

class BugPriority {
  final double _drainOfJoy;
  double get drainOfJoy => _drainOfJoy;
  final String _name;
  String get name => _name;
  final int _chance;
  int get chance => _chance;

  BugPriority(this._name, this._drainOfJoy, this._chance);
}

List<BugPriority> bugPriorities = [
  BugPriority("P0", 0.9, 1),
  BugPriority("P1", 0.6, 2),
  BugPriority("P2", 0.3, 2),
  BugPriority("P3", 0.2, 3),
  BugPriority("P4", 0.1, 3)
];

// Build weighted list of priorities
List<BugPriority> bugChances = bugPriorities.fold<List<BugPriority>>(
    <BugPriority>[],
    (chances, bug) =>
        (chances + List<BugPriority>.generate(bug.chance, (i) => bug))
            .toList());

// A bug that randomly shows up in the work queue.
class Bug extends WorkItem {
  String get name => _priority.name + " Bug!!";
  final BugPriority _priority;
  final Map<Skill, double> _difficulty;
  static Random _randomizer = Random();

  @override
  Map<Skill, double> get difficulty => _difficulty;

  BugPriority get priority => _priority;

  Bug(this._priority, this._difficulty);

  Bug.random()
      : this(bugChances[_randomizer.nextInt(bugChances.length)],
            randomDifficulty(_randomizer));

  @override
  void onCompleted() {
    get<TaskPool>().squashBug(this);
    super.onCompleted();
  }
}
