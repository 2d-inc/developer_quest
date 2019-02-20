import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/team.dart';

class Teams extends Aspect {
  final List<Team> _list = [
    Team('Flutter DevRel Team'),
  ];

  /// Right now we only have one team.
  @deprecated
  Team get single => _list.single;

  void update() {
    for (var team in _list) {
      team.update();
    }

    super.update();
  }
}
