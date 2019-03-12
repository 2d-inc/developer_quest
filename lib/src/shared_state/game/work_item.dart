import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';

/// An item that a set of [Npc]s with specific [Skill]s can work on.
abstract class WorkItem extends Aspect with ChildAspect {
  final String name;
  final Map<Skill, double> difficulty;
  final Map<Skill, double> completion;

  List<Npc> _assignedTeam;
  List<Npc> get assignedTeam => _assignedTeam;

  bool get isComplete => percentComplete == 1.0;
  List<Skill> get skillsNeeded => difficulty.keys.toList(growable: false);

  /// Reduce the length of time to complete a task with a boost.
  double _boost = 1.0;

  WorkItem(this.name, this.difficulty)
      : completion = difficulty.map((Skill s, _) => MapEntry(s, 0));

  void assignTeam(List<Npc> team) {
    if (_assignedTeam != null) {
      // First, mark member who were unassigned as not busy.
      _assignedTeam.forEach((npc) => npc.isBusy = false);
    }
    _assignedTeam = team;
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

  void onCompleted() {
    // Free up the workers if they are done!
    freeTeam();
  }

  @override
  void update() {
    if (isComplete || _assignedTeam == null) {
      super.update();
      return;
    }

    for (final npc in _assignedTeam) {
      for (final skill in npc.prowess.keys) {
        if (!skillsNeeded.contains(skill)) continue;
        var prowess = npc.prowess[skill];
        completion[skill] += prowess * _boost;
      }
    }
    _boost = 1.0;
    if (percentComplete >= 1.0) {
      onCompleted();
    }

    markDirty();
    super.update();
  }

  addBoost() => _boost += 2.5;

  /// Get progress of this task.
  double get percentComplete {
    double required = 0.0;
    double completed = 0.0;

    // accumulate the required skills and the amount completed for each one
    difficulty.forEach((Skill skill, double amount) {
      required += amount;
      // Make sure to not count one skill overworking as another :)
      completed += min(amount, completion[skill] ?? 0.0);
    });

    return completed / required;
  }
}
