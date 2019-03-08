import 'dart:collection';
import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';

/// An item that a set of [Npc]s with specific [Skill]s can work on.
abstract class WorkItem extends Aspect with ChildAspect {
  String get name;
  Map<Skill, double> get difficulty;
  List<Skill> get skillsNeeded => difficulty.keys.toList(growable: false);
  final Map<Skill, double> completion = {};
  double boost = 1.0;

  List<Npc> _assignedTeam;
  UnmodifiableListView<Npc> get assignedTeam =>
      _assignedTeam == null ? null : UnmodifiableListView(_assignedTeam);

  bool get isComplete => percentComplete == 1.0;

  WorkItem() {
    for (final skill in skillsNeeded) {
      completion[skill] = 0;
    }
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

  void onCompleted() {
    // Free up the workers if they are done!
    freeTeam();
  }

  @override
  void update() {
    if (_assignedTeam == null) {
      super.update();
      return;
    }

    for (final npc in _assignedTeam) {
      for (final skill in npc.prowess.keys) {
        if (!skillsNeeded.contains(skill)) continue;
        var prowess = npc.prowess[skill];
        completion[skill] += prowess * boost;
      }
    }
    boost = 1.0;
    if (percentComplete >= 1.0) {
      onCompleted();
    }

    markDirty();
    super.update();
  }

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
