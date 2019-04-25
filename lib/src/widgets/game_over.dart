import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style.dart';
import 'buttons/wide_button.dart';

class GameOver extends StatelessWidget {
  void _backToMainMenu(BuildContext context) {
    var world = Provider.of<World>(context);
    world.reset();
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/";
    });
  }

  void _playAgain(BuildContext context) {
    _backToMainMenu(context);
    Navigator.of(context).pushNamed<void>('/gameloop');
  }

  @override
  Widget build(BuildContext context) {
    var world = Provider.of<World>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          child: Container(
            padding: const EdgeInsets.all(15),
            constraints: const BoxConstraints(minWidth: double.infinity),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0.0, 100.0),
                    blurRadius: 100.0),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedOverflowBox(
                  size: const Size.fromHeight(100),
                  child: SizedBox(
                    width: 104,
                    height: 104,
                    child: Transform(
                      transform: Matrix4.translationValues(0, -28, 0),
                      child: const FlareActor("assets/flare/Joy.flr",
                          animation: "happy"),
                    ),
                  ),
                ),
                Text("\"Spectacular!!!\"", style: contentLargeStyle),
                const SizedBox(height: 23),
                Text(
                    "Your purple app with dinosaur mascot shipped to 6.1 millions users and was rated 4/5 stars by ItsAllWidgets Magazine!",
                    style: contentStyle),
                const SizedBox(height: 26.0),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: WideButton(
                          onPressed: () => _backToMainMenu(context),
                          paddingTweak: const EdgeInsets.only(right: -7.0),
                          background: const Color.fromRGBO(84, 114, 239, 1.0),
                          shadowColor: const Color.fromRGBO(84, 114, 244, 0.25),
                          child: Text(
                            "MAIN MENU",
                            style: buttonTextStyle.apply(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: WideButton(
                          onPressed: () => _playAgain(context),
                          paddingTweak: const EdgeInsets.only(right: -7.0),
                          background: const Color.fromRGBO(236, 41, 117, 1.0),
                          shadowColor: const Color.fromRGBO(244, 84, 84, 0.25),
                          child: Text(
                            "PLAY AGAIN",
                            style: buttonTextStyle.apply(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
