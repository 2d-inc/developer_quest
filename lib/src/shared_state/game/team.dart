import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/quest.dart';
import 'package:flutter/foundation.dart';

final _random = Random();

/// A ragtag bunch of misfits that do all the work.
class Team extends ChangeNotifier {
  /// The task that this team is currently working on, if any.
  Quest _assignedTo;

  /// The maximum number of percentage points done in a single game update.
  int get maxHit => 5;

  void assignTo(Quest quest) => _assignedTo = quest;

  void update() {
    if (_assignedTo == null) return;

    var progress = _random.nextInt(maxHit);
    _assignedTo.makeProgress(progress);

    // The team currently doesn't get changed, ever. So we don't call
    // notifyListeners here.
  }
}
