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
  final String name;

  final Map<Skill, int> prowess;

  final bool isHired = true;

  bool _isBusy = false;

  Npc(this.name, this.prowess);

  bool get isBusy => _isBusy;

  set isBusy(bool value) {
    _isBusy = value;
    markDirty();
  }

  @override
  String toString() => name;

  int get upgradeCost =>
      prowess.values.fold(0, (int previous, int value) => previous + value) *
      110;

  bool get canUpgrade {
    Company company = get<World>().company;
    return company.coin >= upgradeCost;
  }

  bool upgrade() {
    Company company = get<World>().company;
    if (!company.spend(upgradeCost)) {
      return false;
    }
    prowess.forEach((Skill skill, int value) {
      prowess[skill] += 1;
    });
    markDirty();
    return true;
  }
}
