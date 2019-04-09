import 'dart:async';

import 'package:dev_rpg/src/game_screen/npc_style.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_screen.dart';
import 'package:dev_rpg/src/widgets/buttons/welcome_button.dart';
import 'package:dev_rpg/src/widgets/flare/start_screen_hero.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  NpcStyle hero;
  Timer _swapHeroTimer;
  static const Color backgroundColor = Color.fromRGBO(38, 38, 47, 1.0);
  @override
  void initState() {
    chooseHero();
    super.initState();
  }

  void chooseHero() {
    setState(() {
      hero = NpcStyle.random();
    });
    _swapHeroTimer?.cancel();
    _swapHeroTimer = Timer(const Duration(seconds: 10), chooseHero);
  }

  @override
  void dispose() {
    super.dispose();
    _swapHeroTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
                  filename: hero.flare,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.cover,
                  gradient: backgroundColor,
                ),
              ),
              const Text(
                "FLUTTER FANTASY",
                style: TextStyle(
                    fontFamily: "GothamXNarrow",
                    fontSize: 22.0,
                    letterSpacing: 7.5),
              ),
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
                    key: const Key('start_game'),
                    onPressed: () async {
                      Provider.of<World>(context, listen: false).start();
                      // Stop the hero cycling.
                      _swapHeroTimer?.cancel();
                      await Navigator.of(context).pushNamed('/gameloop');
                      // Back to cycling.
                      chooseHero();
                    },
                    background: hero.accent,
                    icon: Icons.chevron_right,
                    label: "Start"),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: WelcomeButton(
                    onPressed: () async {
                      // Stop the hero cycling.
                      _swapHeroTimer?.cancel();
                      await Navigator.of(context)
                          .pushNamed(SphinxScreen.routeName);
                      // Back to cycling.
                      chooseHero();
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
