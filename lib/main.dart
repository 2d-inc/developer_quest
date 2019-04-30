import 'package:dev_rpg/src/basic_game_screen.dart';
import 'package:dev_rpg/src/three_column_game_screen.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  // Don't prune the Flare cache, keep loaded Flare files warm and ready
  // to be re-displayed.
  FlareCache.doesPrune = false;

  runApp(DeveloperQuest());
}

class DeveloperQuest extends StatelessWidget {
  final World world = World();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => User()),
          ChangeNotifierProvider.value(notifier: world),
          ChangeNotifierProvider.value(notifier: world.characterPool),
          ChangeNotifierProvider.value(notifier: world.taskPool),
          ChangeNotifierProvider.value(notifier: world.company),
        ],
        child: MaterialApp(
          title: 'Developer Quest',
          theme: ThemeData(
            brightness: Brightness.dark,
            canvasColor: Colors.transparent,
          ),
          routes: {
            '/': (context) =>  BasicGameScreen(),
          },
        ));
  }
}

