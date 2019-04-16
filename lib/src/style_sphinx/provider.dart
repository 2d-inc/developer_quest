import 'package:dev_rpg/src/style_sphinx/sphinx_game_state.dart';
import 'package:flutter_web/widgets.dart';

class SphinxGameStateProvider extends InheritedWidget {
  final SphinxGameState state;

  const SphinxGameStateProvider({
    @required Widget child,
    @required this.state,
    Key key,
  })  : assert(child != null),
        super(key: key, child: child);

  static SphinxGameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SphinxGameStateProvider)
            as SphinxGameStateProvider)
        .state;
  }

  @override
  bool updateShouldNotify(SphinxGameStateProvider old) {
    return false;
  }
}
