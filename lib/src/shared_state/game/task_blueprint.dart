import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:meta/meta.dart';

/// A blueprint of a task.
///
/// This class is immutable. Put runtime state into [Task].
@immutable
class TaskBlueprint {
  final String name;

  final Map<Skill, double> difficulty;

  final int xpReward;

  List<Skill> get skillsNeeded => difficulty.keys.toList(growable: false);

  const TaskBlueprint(this.name, this.difficulty, {this.xpReward = 100});
}
