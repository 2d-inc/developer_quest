import 'package:dev_rpg/src/shared_state/game/team.dart';
import 'package:flutter/foundation.dart';

class Teams extends ChangeNotifier {
  final List<Team> _list = [
    Team('Flutter DevRel'),
  ];

  /// Right now we only have one team.
  @deprecated
  Team get single => _list.single;

  void updateAll() {
    for (var team in _list) {
      team.update();
    }

    // The teams list currently doesn't get changed, ever. So we don't call
    // notifyListeners here.
  }
}
