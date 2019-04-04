import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/theme.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_screen.dart';
import 'package:dev_rpg/src/theme.dart';
import 'package:dev_rpg/src/widgets/buttons/welcome_button.dart';
import 'package:dev_rpg/src/widgets/flare/start_screen_hero.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flare_flutter/flare_actor.dart";

class WelcomeHero {
  final String filename;
  final Color accent;
  WelcomeHero(this.filename, this.accent);
}

List<WelcomeHero> heros = [
  WelcomeHero(
      "assets/flare/TheRefactorer.flr", const Color.fromRGBO(75, 58, 185, 1.0)),
  WelcomeHero(
      "assets/flare/TheArchitect.flr", const Color.fromRGBO(236, 41, 117, 1.0))
];

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  WelcomeHero hero;

  @override
  void initState() {
    setNextHero();
    super.initState();
  }

  void setNextHero() {
    int index = heros.indexOf(hero);
    setState(() {
      hero = heros[(index + 1) % heros.length];
    });
    Timer(Duration(seconds: 10), setNextHero);
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Consumer<User>(
    //           builder: (context, value) => Text("Welcome, $value!"),
    //         ),
    //         FlatButton(
    //           onPressed: () {
    //             Provider.of<World>(context, listen: false).start();
    //             Navigator.of(context).pushNamed('/gameloop');
    //           },
    //           color: Colors.orangeAccent,
    //           child: const Text("Start"),
    //         ),
    //         FlatButton(
    //           onPressed: () {
    //             Navigator.of(context).pushNamed(SphinxScreen.routeName);
    //           },
    //           color: Colors.orangeAccent,
    //           child: const Text("Face the Style Sphinx"),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 83.0,
              bottom: 56.0,
              left: 35.0,
              right: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StartScreenHero(
                  filename: hero.filename,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.cover,
                  gradient: backgroundColor,
                ),

                //     child: FlareActor("assets/flare/TheRefactorer.flr",
                //         alignment: Alignment.bottomCenter,
                //         shouldClip: false,
                //         fit: BoxFit.cover,
                //         animation: "idle"),
              ),
              Text("FLUTTER FANTASY", style: titleStyle),
              Padding(
                padding: const EdgeInsets.only(top: 11, bottom: 15),
                child: Container(
                  height: 2,
                  color: Colors.white.withOpacity(0.19),
                ),
              ),
              Image.asset('assets/images/2dimensions.png'),
              Padding(
                padding: const EdgeInsets.only(top: 56.0, bottom: 15),
                child: WelcomeButton(
                    onPressed: () {
                      Provider.of<World>(context, listen: false).start();
                      Navigator.of(context).pushNamed('/gameloop');
                    },
                    background: hero.accent,
                    icon: Icons.chevron_right,
                    label: "Start"),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: WelcomeButton(
                    onPressed: () {
                      Provider.of<World>(context, listen: false).start();
                      Navigator.of(context).pushNamed('/gameloop');
                    },
                    background: Colors.white.withOpacity(0.15),
                    icon: Icons.settings,
                    label: "Settings"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
