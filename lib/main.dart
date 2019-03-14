import 'package:dev_rpg/src/game_screen.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:dev_rpg/src/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
          ChangeNotifierProvider(notifier: widget.world.npcPool),
          ChangeNotifierProvider(notifier: widget.world.taskPool),
          ChangeNotifierProvider(notifier: widget.world.company),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          routes: {
            "/": (context) => WelcomeScreen(),
            "/gameloop": (context) => GameScreen(),
          },
        ));
  }

  @override
  void dispose() {
    widget.world.shutdown();
    super.dispose();
  }
}
