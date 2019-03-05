import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// A single task for the player and her team to complete.
///
/// The definition of the task is in [blueprint]. This class holds the runtime
/// state (like [percentComplete]).
class Npc extends Aspect {
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
}
