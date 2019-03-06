import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_prerequisite.dart';
import 'package:meta/meta.dart';

/// A blueprint of a task.
///
/// This class is immutable. Put runtime state into [Task].
@immutable
class TaskBlueprint implements Prerequisite {
  final String name;

  final Map<Skill, double> difficulty;

  /// The tasks (and their combinations) that the player must have completed
  /// before this task is available.
  final Prerequisite requirements;

  final int xpReward;
  final int coinReward;

  const TaskBlueprint(this.name, this.difficulty,
      {@required this.requirements, this.xpReward = 100, this.coinReward = 300})
      : assert(name != null),
        assert(difficulty != null),
        assert(requirements != null);

  List<Skill> get skillsNeeded => difficulty.keys.toList(growable: false);

  /// The task is satisfied if, and only if, it has already been done.
  @override
  bool isSatisfiedIn(Iterable<Prerequisite> done) => done.contains(this);
}
