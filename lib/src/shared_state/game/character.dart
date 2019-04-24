import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

/// A single task for the player and her team to complete.
///
/// The definition of the task is in [blueprint]. This class holds the runtime
/// state (like [percentComplete]).
class Character extends Aspect with ChildAspect {
  static const int maxSkillProwess = 5;

  final String id;

  final Map<Skill, int> prowess;

  // basically a upgrade counter
  int _level = 1;
  int get level => _level;

  bool _isHired = false;
  bool get isHired => _isHired;

  final int customHiringCost;
  final int costMultiplier;

  bool _isBusy = false;

  Character(this.id, this.prowess,
      {this.customHiringCost, this.costMultiplier = 1});

  bool get isBusy => _isBusy;

  set isBusy(bool value) {
    _isBusy = value;
    markDirty();
  }

  double getProwessProgress(Skill skill) =>
      (prowess[skill] ?? 0.0) / maxSkillProwess;

  bool contributes(List<Skill> skills) {
    for (final Skill skill in skills) {
      if (prowess.containsKey(skill)) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() => id;

  int get upgradeCost => !_isHired && customHiringCost != null
      ? customHiringCost
      : prowess.values.fold(0, (int previous, int value) => previous + value) *
          (_isHired ? 110 : 220) * costMultiplier;

  bool get canUpgrade {
    Company company = get<World>().company;
    // Make sure there's some skill that's below max (meaning we can bump
    // it up).
    if (prowess.values.firstWhere((value) => value < maxSkillProwess,
            orElse: () => maxSkillProwess) ==
        maxSkillProwess) {
      return false;
    }
    return company.coin.number >= upgradeCost;
  }

  bool hire() {
    assert(!_isHired);
    Company company = get<World>().company;
    if (!company.spend(upgradeCost)) {
      return false;
    }
    _isHired = true;
    markDirty();
    return true;
  }

  bool upgrade() {
    if (!_isHired) {
      return hire();
    }
    Company company = get<World>().company;
    if (!company.spend(upgradeCost)) {
      return false;
    }
    for (final Skill skill in prowess.keys) {
      prowess[skill] += 1;
    }
    _level++;
    markDirty();
    return true;
  }
}
