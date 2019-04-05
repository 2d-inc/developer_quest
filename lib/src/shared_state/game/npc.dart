import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

/// A single task for the player and her team to complete.
///
/// The definition of the task is in [blueprint]. This class holds the runtime
/// state (like [percentComplete]).
class Npc extends Aspect with ChildAspect {
  final String id;

  final Map<Skill, int> prowess;

  // basically a upgrade counter
  int _level = 1;
  int get level => _level;

  bool _isHired;
  bool get isHired => _isHired;

  bool _isBusy = false;

  Npc(this.id, this.prowess, [this._isHired = false]);

  bool get isBusy => _isBusy;

  set isBusy(bool value) {
    _isBusy = value;
    markDirty();
  }

  @override
  String toString() => id;

  int get upgradeCost =>
      prowess.values.fold(0, (int previous, int value) => previous + value) *
      (_isHired ? 110 : 220);

  bool get canUpgrade {
    Company company = get<World>().company;
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
