import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_prerequisite.dart';
import 'package:meta/meta.dart';

enum MiniGame { none, chomp, sphinx }

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

  final int userReward;

  final int coinReward;

  final MiniGame miniGame;

  /// When sorting several blueprints, the ones with higher priority
  /// come first. This is `0` by default.
  final int priority;

  /// List of names of tasks that, when started, immediately make this task
  /// not selectable. For example, starting a 'Red Design' disallows
  /// 'Blue Design'.
  final List<String> mutuallyExclusive;

  const TaskBlueprint(this.name, this.difficulty,
      {@required this.requirements,
      this.userReward = 100,
      this.coinReward = 80,
      this.priority = 0,
      this.mutuallyExclusive = const [],
      this.miniGame = MiniGame.none})
      : assert(name != null),
        assert(difficulty != null),
        assert(requirements != null),
        assert(priority != null),
        assert(mutuallyExclusive != null);

  List<Skill> get skillsNeeded => difficulty.keys.toList(growable: false);

  /// The task is satisfied if, and only if, it has already been done.
  @override
  bool isSatisfiedIn(Iterable<Prerequisite> done) => done.contains(this);
}
