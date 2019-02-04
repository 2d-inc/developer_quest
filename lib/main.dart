import 'package:dev_rpg/src/gameloop_screen.dart';
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
  providers.provideValue(world.quests);

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
        "/gameloop": (context) => GameloopScreen(),
      },
    );
  }
}
