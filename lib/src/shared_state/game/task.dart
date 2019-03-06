import 'dart:collection';
import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

enum TaskState { working, completed, rewarded }

/// A single task for the player and her team to complete.
///
/// The definition of the task is in [blueprint]. This class holds the runtime
/// state (like [percentComplete]).
class Task extends Aspect with ChildAspect {
  final TaskBlueprint blueprint;
  final Map<Skill, double> completion = {};
  double boost = 1.0;

  List<Npc> _assignedTeam;
  TaskState _state = TaskState.working;
  TaskState get state => _state;

  Task(this.blueprint) {
    for (final skill in blueprint.skillsNeeded) {
      completion[skill] = 0;
    }
  }

  UnmodifiableListView<Npc> get assignedTeam =>
      _assignedTeam == null ? null : UnmodifiableListView(_assignedTeam);

  bool get isComplete => percentComplete == 1.0;

  /// Get progress of this task.
  double get percentComplete {
    double required = 0.0;
    double completed = 0.0;

    // accumulate the required skills and the amount completed for each one
    blueprint.difficulty.forEach((Skill skill, double amount) {
      required += amount;
      // Make sure to not count one skill overworking as another :)
      completed += min(amount, completion[skill] ?? 0.0);
    });

    return completed / required;
  }

  void assignTeam(Iterable<Npc> team) {
    _assignedTeam = team.toList(growable: false);
    _assignedTeam.forEach((npc) => npc.isBusy = true);
    markDirty();
  }

  void freeTeam() {
    if (_assignedTeam == null) {
      return;
    }
    _assignedTeam.forEach((npc) => npc.isBusy = false);
    _assignedTeam = null;
  }

  @override
  void update() {
    if (_assignedTeam == null) {
      super.update();
      return;
    }

    for (final npc in _assignedTeam) {
      for (final skill in npc.prowess.keys) {
        if (!blueprint.skillsNeeded.contains(skill)) continue;
        var prowess = npc.prowess[skill];
        completion[skill] += prowess * boost;
      }
    }
    boost = 1.0;
    if (percentComplete >= 1.0) {
      // Free up the workers if they are done!
      _state = TaskState.completed;
      freeTeam();
	  get<TaskPool>().completeTask(this);
    }

    markDirty();
    super.update();
  }

  void collectReward() {
    if (_state == TaskState.completed) {
      _state = TaskState.rewarded;
      markDirty();

	  get<World>().collectReward(this);	  
	  get<TaskPool>().archiveTask(this);
    }
  }
}
