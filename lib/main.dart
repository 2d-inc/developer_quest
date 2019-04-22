import 'package:dev_rpg/src/style_sphinx/flex_questions.dart';
import 'package:dev_rpg/src/style_sphinx/provider.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_game_state.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_screen.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart';

void main() {
  window.webOnlyLocationStrategy = const HashLocationStrategy();

  runApp(MyApp(
    state: SphinxGameState(),
  ));
}

class MyApp extends StatelessWidget {
  final SphinxGameState state;

  const MyApp({Key key, this.state}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return SphinxGameStateProvider(
      state: state,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'MontserratMedium',
        ),
        navigatorObservers: [WebOnlyNavigatorObserver()],
        routes: {
          "/": (context) => const SphinxScreen(),
          SphinxScreen.miniGameRouteName: (context) => const SphinxScreen(),
          SphinxScreen.fullGameRouteName: (context) =>
              const SphinxScreen(fullGame: true),
          ColumnQuestion.routeName: (context) => const ColumnQuestion(),
          RowQuestion.routeName: (context) => const RowQuestion(),
          StackQuestion.routeName: (context) => const StackQuestion(),
        },
      ),
    );
  }
}
