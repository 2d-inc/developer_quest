import 'dart:async';

import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/warmup_flare.dart';
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
  CharacterStyle hero;
  Timer _swapHeroTimer;
  final Timer _warmupTimer =
      Timer(const Duration(milliseconds: 1500), warmupFlare);
  @override
  void initState() {
    chooseHero();
    super.initState();
  }

  void chooseHero() {
    setState(() {
      hero = CharacterStyle.random();
    });
    _swapHeroTimer?.cancel();
    _swapHeroTimer = Timer(const Duration(seconds: 10), chooseHero);
  }

  @override
  void dispose() {
    super.dispose();
    _swapHeroTimer?.cancel();
    _warmupTimer.cancel();
  }

  static const double _horizontalPadding = 33.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: contentColor,
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 83.0,
              bottom: 56.0,
              left: _horizontalPadding,
              right: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StartScreenHero(
                    filename: hero.flare,
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.cover,
                    gradient: contentColor,
                    horizontalPadding: _horizontalPadding),
              ),
              const Text(
                "FLUTTER\nDEVELOPER QUEST",
                style: TextStyle(
                    fontFamily: "RobotoCondensedBold",
                    fontSize: 30.0,
                    letterSpacing: 5),
              ),
              const SizedBox(height: 12),
              Container(
                height: 2,
                color: Colors.white.withOpacity(0.19),
              ),
              const SizedBox(height: 12),
              const Text(
                "Build your team, slay bugs,\ndon't get fired.",
                style: TextStyle(fontFamily: "RobotoRegular", fontSize: 20.0),
              ),
              const SizedBox(height: 25),
              Image.asset('assets/images/2dimensions.png'),
              Padding(
                padding: const EdgeInsets.only(top: 29.0, bottom: 15),
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
                      await Navigator.pushNamed(
                        context,
                        SphinxScreen.miniGameRouteName,
                      );
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
