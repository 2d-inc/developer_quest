import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Provide<User>(
              builder: (context, child, value) => Text("Welcome, $value!"),
            ),
            FlatButton(
              onPressed: () {
                Provide.value<User>(context).signIn();
                Provide.value<World>(context).start();
                return Navigator.of(context).pushNamed('/gameloop');
              },
              color: Colors.orangeAccent,
              child: Text("Start"),
            )
          ],
        ),
      ),
    );
  }
}
