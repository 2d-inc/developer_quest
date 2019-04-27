import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

import '../style.dart';
import 'buttons/wide_button.dart';

var _starGreeting = [
  'You tried.',
  'Solid effort!',
  'Delightful!',
  'Spectacular!!',
  'PERFECTION!!!'
];

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
    starsAnimation?.apply(0, artboard, 1);
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
    _starController =
        _MixStarValueController(widget.world.company.starRating + 1);
    super.initState();
  }

  void _backToMainMenu() {
    widget.world.reset();
    Navigator.popUntil(context, (route) {
      return route.settings.name == '/';
    });
  }

  void _playAgain(BuildContext context) {
    _backToMainMenu();
    Navigator.of(context).pushNamed<void>('/gameloop');
  }

  @override
  Widget build(BuildContext context) {
    var stars = widget.world.company.starRating;
    assert(stars > 0 && stars <= 4, 'Stars must be between 0 and 5.');

    var successMessage = _starGreeting[stars];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Material(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: modalMaxWidth),
            child: Container(
              padding: const EdgeInsets.all(15),
              constraints: const BoxConstraints(minWidth: double.infinity),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 100),
                      blurRadius: 100),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                        child: FlareActor('assets/flare/Joy.flr',
                            animation: stars < 2
                                ? 'sad'
                                : stars < 3 ? 'neutral' : 'happy'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 248,
                    height: 46,
                    child: FlareActor(
                      'assets/flare/Stars.flr',
                      shouldClip: false,
                      animation: 'Build',
                      controller: _starController,
                    ),
                  ),
                  const SizedBox(height: 23),
                  Text(successMessage, style: contentLargeStyle),
                  const SizedBox(height: 19),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'Your ', style: contentStyle),
                          primaryCharacteristic,
                          const TextSpan(
                              text: ' app with ', style: contentStyle),
                          secondaryCharacteristic,
                          const TextSpan(
                              text: ' shipped to ', style: contentStyle),
                          TextSpan(
                              text: '${widget.world.company.users.value} users',
                              style: contentStyle.apply(
                                  fontFamily: 'MontserratBold')),
                          const TextSpan(
                              text: ' and was rated ', style: contentStyle),
                          TextSpan(
                              text: '${stars + 1}/5 stars',
                              style: contentStyle.apply(
                                  fontFamily: 'MontserratBold')),
                          const TextSpan(
                              text: ' by ItsAllWidgets Magazine!',
                              style: contentStyle),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: WideButton(
                            onPressed: _backToMainMenu,
                            paddingTweak: const EdgeInsets.only(right: -7),
                            background: const Color.fromRGBO(84, 114, 239, 1),
                            shadowColor:
                                const Color.fromRGBO(84, 114, 244, 0.25),
                            child: Text(
                              'MAIN MENU',
                              style: buttonTextStyle.apply(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: WideButton(
                            onPressed: () => _playAgain(context),
                            paddingTweak: const EdgeInsets.only(right: -7),
                            background: const Color.fromRGBO(236, 41, 117, 1),
                            shadowColor:
                                const Color.fromRGBO(244, 84, 84, 0.25),
                            child: Text(
                              'PLAY AGAIN',
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
      ),
    );
  }

  TextSpan get primaryCharacteristic {
    for (final task in widget.world.taskPool.archivedTasks) {
      switch (task.name) {
        case 'Green Theme':
          return TextSpan(
              text: 'green 🎨', style: contentStyle.apply(color: Colors.green));
        case 'Red Theme':
          return TextSpan(
              text: 'red 🎨', style: contentStyle.apply(color: Colors.red));
        case 'Blue Theme':
          return TextSpan(
              text: 'blue 🎨', style: contentStyle.apply(color: Colors.blue));
      }
    }
    return const TextSpan(text: 'basic 😶', style: contentStyle);
  }

  TextSpan get secondaryCharacteristic {
    for (final task in widget.world.taskPool.archivedTasks) {
      switch (task.name) {
        case 'Dinosaur Mascot & Icon':
          return const TextSpan(
              text: 'dinosaur 🦖 mascot', style: contentStyle);
        case 'Bird Mascot & Icon':
          return const TextSpan(text: 'bird 🐦 mascot', style: contentStyle);
        case 'Cat Mascot & Icon':
          return const TextSpan(text: 'cat 🐈 mascot', style: contentStyle);
        case 'Retro Design':
          return const TextSpan(text: 'retro 🕹️ design', style: contentStyle);
        case 'Sci-Fi Design':
          return const TextSpan(text: 'sci-fi 👽 design', style: contentStyle);
        case 'Mainstream Design':
          return const TextSpan(
              text: 'mainstream 💻 design', style: contentStyle);
      }
    }
    return const TextSpan(text: 'simple 😐 design', style: contentStyle);
  }
}
