import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/quest.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

final _random = Random();

/// A ragtag bunch of misfits that do all the work.
class Team extends Aspect {
  /// The task that this team is currently working on, if any.
  Quest _assignedTo;

  final String name;

  Team(this.name);

  /// The maximum number of percentage points done in a single game update.
  int get maxHit => 5;

  void assignTo(Quest quest) {
    _assignedTo?.assignTeam(null);

    _assignedTo = quest;
    quest.assignTeam(this);
    markDirty();
  }

  @override
  toString() => name;

  void update() {
    if (_assignedTo == null) return;

    var progress = _random.nextInt(maxHit);
    _assignedTo.makeProgress(progress);
    super.update();
  }
}
