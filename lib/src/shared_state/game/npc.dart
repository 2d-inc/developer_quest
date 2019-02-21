import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

enum BlockingIssueState { none, shown, resolved, unresolved }

/// A single task for the player and her team to complete.
///
/// The definition of the task is in [blueprint]. This class holds the runtime
/// state (like [percentComplete]).
class Npc extends Aspect {
  final String name;

  /// TODO: make this mutable
  final bool isHired = true;

  bool _isBusy = false;

  /// A development-time shortcut for creating tasks.
  @Deprecated('Please create NPCs that differ by more than just name')
  Npc.sample(this.name);

  bool get isBusy => _isBusy;

  set isBusy(bool value) {
    _isBusy = value;
    markDirty();
  }

  @override
  String toString() => name;
}
