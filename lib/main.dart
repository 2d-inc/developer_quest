import 'package:dev_rpg/src/game_screen.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:dev_rpg/src/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  var world = World();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(notifier: User()),
        ChangeNotifierProvider(notifier: world),
        ChangeNotifierProvider(notifier: world.npcPool),
        ChangeNotifierProvider(notifier: world.taskPool),
        ChangeNotifierProvider(notifier: world.company),
      ],
      child: MyApp(),
    ),
  );
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
