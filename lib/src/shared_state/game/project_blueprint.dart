import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:meta/meta.dart';

/// A blueprint of a project.
///
/// This class is immutable. Put runtime state into [Project].
@immutable
class ProjectBlueprint {
  final String name;
  final List<TaskBlueprint> taskBlueprints;
  final int xpReward;

  Set<Skill> get skills {
    Set<Skill> requirements = Set<Skill>();
    for (final TaskBlueprint task in taskBlueprints) {
      task.difficulty.forEach((final Skill skill, double amount) {
        requirements.add(skill);
      });
    }

    return requirements;
  }

  /// Time to complete is based off of the total difficulty of the task.
  /// It's stored in ticks as a difficulty value on each skill of the sum of the tasks.
  double get totalDifficulty {
    return taskBlueprints.fold<double>(0.0, (double value, TaskBlueprint task) {
      task.difficulty.forEach((final Skill skill, double amount) {
        value += amount;
      });
      return value;
    });
  }

  const ProjectBlueprint(this.name, this.xpReward, this.taskBlueprints);
}
