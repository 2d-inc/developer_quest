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
  List<Skill> get skillsNeeded => difficulty.keys.toList(growable: false);

  /// The tasks (and their combinations) that the player must have completed
  /// before this task is available.
  final Prerequisite requirements;

  final int userReward;
  final int coinReward;

  const TaskBlueprint(this.name, this.difficulty,
      {@required this.requirements,
      this.userReward = 100,
      this.coinReward = 80})
      : assert(name != null),
        assert(difficulty != null),
        assert(requirements != null);

  /// The task is satisfied if, and only if, it has already been done.
  @override
  bool isSatisfiedIn(Iterable<Prerequisite> done) => done.contains(this);
}
