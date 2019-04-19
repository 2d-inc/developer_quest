import 'package:dev_rpg/src/game_screen.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:dev_rpg/src/style_sphinx/flex_questions.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_screen.dart';
import 'package:dev_rpg/src/welcome_screen.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // Don't prune the Flare cache, keep loaded Flare files warm and ready
  // to be re-displayed.
  FlareCache.doesPrune = false;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final World world = World();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(notifier: User()),
          ChangeNotifierProvider(notifier: widget.world),
          ChangeNotifierProvider(notifier: widget.world.characterPool),
          ChangeNotifierProvider(notifier: widget.world.taskPool),
          ChangeNotifierProvider(notifier: widget.world.company),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
			canvasColor: Colors.transparent
          ),
          routes: {
            "/": (context) => WelcomeScreen(),
            "/gameloop": (context) => GameScreen(),
            SphinxScreen.miniGameRouteName: (context) => const SphinxScreen(),
            SphinxScreen.fullGameRouteName: (context) =>
                const SphinxScreen(fullGame: true),
            ColumnQuestion.routeName: (context) => const ColumnQuestion(),
            RowQuestion.routeName: (context) => const RowQuestion(),
            StackQuestion.routeName: (context) => const StackQuestion(),
          },
        ));
  }

  @override
  void dispose() {
    widget.world.shutdown();
    super.dispose();
  }
}
