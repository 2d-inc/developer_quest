import 'dart:collection';
import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/blocking_issue.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';

final _random = Random();

enum BlockingIssueState { none, shown, resolved, unresolved }

/// A single task for the player and her team to complete.
///
/// The definition of the task is in [blueprint]. This class holds the runtime
/// state (like [percentComplete]).
class Task extends Aspect {
  final TaskBlueprint blueprint;

  int _percentComplete = 0;

  DateTime _blockingIssueStartTime;

  BlockingIssueState _blockingIssueState = BlockingIssueState.none;

  List<Npc> _assignedTeam;

  Task(this.blueprint) {
    UnimplementedError();
  }

  /// A development-time shortcut for creating tasks.
  @Deprecated('Please create tasks that differ by more than just name')
  Task.sample(String name)
      : blueprint = TaskBlueprint(name, 100, BlockingIssue.sample());

  UnmodifiableListView<Npc> get assignedTeam =>
      _assignedTeam == null ? null : UnmodifiableListView(_assignedTeam);

  bool get isBlocked => _blockingIssueState == BlockingIssueState.shown;

  /// The maximum number of percentage points done in a single game update
  /// by the [_assignedTeam].
  int get maxHit => (_assignedTeam?.length ?? 0) + 1;

  double get percentComplete => _percentComplete / 100;

  void assignTeam(Iterable<Npc> team) {
    _assignedTeam = team.toList(growable: false);
    _assignedTeam.forEach((npc) => npc.isBusy = true);
    markDirty();
  }

  /// Resolves the blocking issue.
  void resolveIssue() {
    assert(_blockingIssueState == BlockingIssueState.shown);
    _blockingIssueState = BlockingIssueState.resolved;
    markDirty();
  }

  @override
  void update() {
    if (_blockingIssueState == BlockingIssueState.shown) {
      var blockingIssueEnd =
          _blockingIssueStartTime.add(blueprint.blockingIssue.duration);
      if (blockingIssueEnd.isBefore(DateTime.now())) {
        _blockingIssueState = BlockingIssueState.unresolved;
        markDirty();
      }
    }

    if (_assignedTeam != null) {
      int progress;
      if (isBlocked) {
        // Seriously limit progress when the task is blocked.
        progress = _random.nextInt(2);
      } else {
        progress = _random.nextInt(maxHit);
      }
      _makeProgress(progress);
    }

    super.update();
  }

  /// Makes progress by [percent]. The task can change [isBlocked]
  /// during this call if [BlockingIssue.startsAtProgressLevel] is reached.
  void _makeProgress(int percent) {
    assert(percent >= 0);
    if (percent == 0) return;
    if (_percentComplete == 100) return;
    _percentComplete += percent;
    if (_blockingIssueStartTime == null &&
        _percentComplete > blueprint.blockingIssue.startsAtProgressLevel) {
      _blockingIssueState = BlockingIssueState.shown;
      _blockingIssueStartTime = DateTime.now().toUtc();
    }
    if (_percentComplete >= 100) {
      _percentComplete = 100;
      if (_blockingIssueState != BlockingIssueState.resolved) {
        _blockingIssueState = BlockingIssueState.unresolved;
      }
      _assignedTeam.forEach((npc) => npc.isBusy = false);
      _assignedTeam = null;
    }
    markDirty();
  }
}
