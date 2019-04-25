import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

import '../style.dart';
import 'buttons/wide_button.dart';

/// A super simple Flare Controller that mixes the star value
/// animation on top of our Build animation
class _MixStarValueController extends FlareController {
  final int stars;
  _MixStarValueController(this.stars);
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    return false;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    ActorAnimation starsAnimation = artboard.getAnimation(stars.toString());
    if (starsAnimation != null) {
      starsAnimation.apply(0.0, artboard, 1.0);
    }
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}

class GameOver extends StatefulWidget {
  final World world;
  const GameOver(this.world);
  @override
  _GameOverState createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  _MixStarValueController _starController;
  @override
  void initState() {
    _starController = _MixStarValueController(4);
    super.initState();
  }

  void _backToMainMenu() {
    widget.world.reset();
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/";
    });
  }

  void _playAgain(BuildContext context) {
    _backToMainMenu();
    Navigator.of(context).pushNamed<void>('/gameloop');
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  width: 248,
                  height: 46,
                  child: FlareActor(
                    "assets/flare/Stars.flr",
                    shouldClip: false,
                    animation: "Build",
                    controller: _starController,
                  ),
                ),
                const SizedBox(height: 23),
                Text("\"Spectacular!!!\"", style: contentLargeStyle),
                const SizedBox(height: 19),
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
                          onPressed: _backToMainMenu,
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
