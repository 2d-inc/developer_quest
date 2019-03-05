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

  List<Skill> get requirements {
    List<Skill> skills = [];
    difficulty.forEach((Skill skill, double amount) {
      skills.add(skill);
    });
    return skills;
  }

  const TaskBlueprint(this.name, this.difficulty, {this.xpReward = 100});
}
