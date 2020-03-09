import 'dart:async';

import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/rpg_layout_builder.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/warmup_flare.dart';
import 'package:dev_rpg/src/widgets/buttons/welcome_button.dart';
import 'package:dev_rpg/src/widgets/flare/start_screen_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

const double _horizontalPadding = 33;

class _WelcomeScreenState extends State<WelcomeScreen> {
  CharacterStyle hero;
  Timer _swapHeroTimer;
  final Timer _warmupTimer =
      Timer(const Duration(milliseconds: 1500), warmupFlare);
  @override
  void initState() {
    _chooseHero();
    super.initState();
  }

  void _chooseHero() {
    setState(() {
      hero = CharacterStyle.random();
    });
    _startTimer();
  }

  void _startTimer() {
    _swapHeroTimer?.cancel();
    _swapHeroTimer = Timer(const Duration(seconds: 10), _chooseHero);
  }

  @override
  void dispose() {
    super.dispose();
    _swapHeroTimer?.cancel();
    _warmupTimer.cancel();
  }

  Future<void> _pressStartGame() async {
    Provider.of<World>(context, listen: false).reset();
    // Stop the hero cycling.
    _swapHeroTimer?.cancel();
    await Navigator.of(context).pushNamed('/gameloop');
    // Back to cycling.
    _startTimer();
  }

  Future<void> _pressAbout() async {
    // Stop the hero cycling.
    _swapHeroTimer?.cancel();
    await Navigator.of(context).pushNamed('/about');
    // Back to cycling.
    _startTimer();
  }

  bool _initialized = false;
  @override
  Widget build(BuildContext context) {
    // Hide window chrome.
    var query = MediaQuery.of(context);
    var width = query.size.width;
    if (!_initialized && width != 0 && width < blockLandscapeThreshold) {
      // Disallow rotating to landscape.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: contentColor,
        child: RpgLayoutBuilder(
          builder: (context, layout) => layout != RpgLayout.slim
              ? _WelcomeScreenWide(
                  hero,
                  start: _pressStartGame,
                  about: _pressAbout,
                )
              : _WelcomeScreenSlim(
                  hero,
                  start: _pressStartGame,
                  about: _pressAbout,
                ),
        ),
      ),
    );
  }
}

/// Builds the slim version of the welcome screen (usually shown
/// on portrait mobile devices).
class _WelcomeScreenSlim extends StatelessWidget {
  final CharacterStyle hero;
  final VoidCallback start;
  final VoidCallback about;
  const _WelcomeScreenSlim(this.hero, {this.start, this.about});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 83,
          bottom: 56,
          left: _horizontalPadding,
          right: _horizontalPadding),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: modalMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StartScreenHero(
                  filename: hero.flare,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.contain,
                  gradient: contentColor),
            ),
            _Title(),
            Padding(
              padding: const EdgeInsets.only(top: 29, bottom: 15),
              child: WelcomeButton(
                  key: const Key('start_game'),
                  onPressed: start,
                  background: hero.accent,
                  icon: Icons.chevron_right,
                  label: 'Start'),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: WelcomeButton(
                  onPressed: about,
                  background: Colors.white.withOpacity(0.15),
                  icon: Icons.settings,
                  label: 'About'),
            )
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RpgLayoutBuilder(
      builder: (context, layout) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FLUTTER\nDEVELOPER QUEST',
                style: TextStyle(
                    fontFamily: 'RobotoCondensedBold',
                    fontSize: layout == RpgLayout.ultrawide ? 48 : 30,
                    letterSpacing: 5),
              ),
              SizedBox(height: layout == RpgLayout.ultrawide ? 24 : 12),
              Container(
                height: 2,
                color: Colors.white.withOpacity(0.19),
              ),
              SizedBox(height: layout == RpgLayout.ultrawide ? 28 : 12),
              Text(
                layout == RpgLayout.ultrawide
                    ? 'Build your team, slay bugs, don\'t get fired.'
                    : 'Build your team, slay bugs,\ndon\'t get fired.',
                style: TextStyle(
                    fontFamily: 'RobotoRegular',
                    fontSize: layout == RpgLayout.ultrawide ? 24 : 20),
              ),
              const SizedBox(height: 25),
              layout == RpgLayout.ultrawide
                  ? Image.asset('assets/images/2.0x/2dimensions.png',
                      scale: 1.75)
                  : Image.asset('assets/images/2dimensions.png')
            ],
          ),
    );
  }
}

/// Builds the wide version of the welcome screen which is better
/// suited to TV, desktop, and tablets.
class _WelcomeScreenWide extends StatelessWidget {
  final VoidCallback start;
  final VoidCallback about;
  final CharacterStyle hero;
  const _WelcomeScreenWide(this.hero, {this.start, this.about});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var thirdWidth = size.width / 3;
    var thirdHeight = size.height / 3;

    return RpgLayoutBuilder(
      builder: (context, layout) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: thirdWidth,
                height: thirdHeight * 2,
                child: StartScreenHero(
                    filename: hero.flare,
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,
                    gradient: contentColor),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: layout == RpgLayout.ultrawide
                    ? thirdWidth * 0.702
                    : thirdWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Title(),
                    SizedBox(height: layout == RpgLayout.ultrawide ? 87 : 29),
                    Row(
                      children: [
                        Expanded(
                          child: WelcomeButton(
                              key: const Key('start_game'),
                              fontSize: layout == RpgLayout.ultrawide ? 20 : 16,
                              onPressed: start,
                              background: hero.accent,
                              icon: Icons.chevron_right,
                              label: 'Start'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: WelcomeButton(
                              fontSize: layout == RpgLayout.ultrawide ? 20 : 16,
                              onPressed: about,
                              background: Colors.white.withOpacity(0.15),
                              icon: Icons.settings,
                              label: 'About'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
