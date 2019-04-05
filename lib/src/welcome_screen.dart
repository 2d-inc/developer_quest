import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<User>(
              builder: (context, value) => Text("Welcome, $value!"),
            ),
            FlatButton(
              key: const Key('start_game'),
              onPressed: () {
                Provider.of<World>(context, listen: false).start();
                Navigator.of(context).pushNamed('/gameloop');
              },
              color: Colors.orangeAccent,
              child: const Text("Start"),
            ),
            FlatButton(
              onPressed: () => navigateToSphinxMiniGame(context),
              color: Colors.orangeAccent,
              child: const Text("Face the Style Sphinx"),
            )
          ],
        ),
      ),
    );
  }
}
