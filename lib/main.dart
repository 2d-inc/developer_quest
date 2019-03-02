import 'package:dev_rpg/src/game_screen.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:dev_rpg/src/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  var providers = Providers();
  providers.provideValue(User());

  var world = World();
  providers.provideValue(world);

  // Provide specific parts of the world separately so that widgets that
  // only care about quests, for example, can only listen to those.
  providers.provideValue(world.npcPool);
  providers.provideValue(world.projectPool);

  runApp(ProviderNode(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        "/": (context) => WelcomeScreen(),
        "/gameloop": (context) => GameScreen(),
      },
    );
  }
}
