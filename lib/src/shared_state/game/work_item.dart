import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';

/// An item that a set of [Character]s with specific [Skill]s can work on.
abstract class WorkItem extends Aspect with ChildAspect {
  final String name;
  final Map<Skill, double> difficulty;
  final Map<Skill, double> completion;

  List<Character> _assignedTeam;
  List<Character> get assignedTeam => _assignedTeam;

  bool get isComplete => percentComplete == 1;
  List<Skill> get skillsNeeded => difficulty.keys.toList(growable: false);

  bool get isBeingWorkedOn => _assignedTeam?.isNotEmpty ?? false;

  /// Reduce the length of time to complete a task with a boost.
  double _boost = 1;

  WorkItem(this.name, this.difficulty)
      : completion = difficulty.map((Skill s, _) => MapEntry(s, 0));

  void assignTeam(List<Character> team) {
    if (_assignedTeam != null) {
      // First, mark member who were unassigned as not busy.
      _assignedTeam.forEach((character) => character.isBusy = false);
    }
    _assignedTeam = team;
    _assignedTeam.forEach((character) => character.isBusy = true);
    markDirty();
  }

  void freeTeam() {
    if (_assignedTeam == null) {
      return;
    }
    for (final character in _assignedTeam) {
      character.isBusy = false;
    }
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

    for (final character in _assignedTeam) {
      for (final skill in character.prowess.keys) {
        if (!skillsNeeded.contains(skill)) continue;
        var prowess = character.prowess[skill];
        completion[skill] += prowess * _boost;
      }
    }
    _boost = 1;
    if (percentComplete >= 1) {
      onCompleted();
    }

    markDirty();
    super.update();
  }

  bool addBoost() {
    if (!isBeingWorkedOn) {
      return false;
    }
    _boost += 2.5;
    return true;
  }

  /// Get progress of this task.
  double get percentComplete {
    double required = 0;
    double completed = 0;

    // accumulate the required skills and the amount completed for each one
    difficulty.forEach((Skill skill, double amount) {
      required += amount;
      // Make sure to not count one skill overworking as another :)
      completed += min(amount, completion[skill] ?? 0);
    });

    return completed / required;
  }
}
