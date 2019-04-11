import 'package:dev_rpg/src/style_sphinx/flex_questions.dart';
import 'package:dev_rpg/src/style_sphinx/question_arguments.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_image.dart';
import 'package:dev_rpg/src/style_sphinx/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SphinxScreen extends StatefulWidget {
  static const String miniGameRouteName = '/sphinx';
  static const String fullGameRouteName = '/sphinx/complete';

  const SphinxScreen({Key key, this.fullGame = false}) : super(key: key);

  final bool fullGame;

  @override
  _SphinxScreenState createState() => _SphinxScreenState();
}

class _SphinxScreenState extends State<SphinxScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'assets/style_sphinx/start_background.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 75),
            child: Image.asset(
              'assets/style_sphinx/pyramid.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: TextBubble(
                        direction: TextBubbleDirection.right,
                        child: Text(
                          'I am the Style Sphinx.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: TextBubble(
                        child: Text(
                          '''In order to proceed\nstyle for me\nthese layouts three''',
                        ),
                      ),
                    ),
                    const Flexible(child: SphinxImage()),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(24),
                      child: FlatButton(
                        color: Colors.red,
                        child: const Text('Face the Sphinx'),
                        onPressed: () {
                          // When the user presses the buttons, navigate to
                          // the first question by creating the original
                          // QuestionArguments.
                          //
                          // The QuestionArguments are configured up front and
                          // then passed from one question screen to the next
                          // in order to drive the game forward.
                          final args = QuestionArguments(
                            originalRoute: ModalRoute.of(context)
                                .settings
                                .arguments as String,
                            questionRoutes: widget.fullGame
                                ? [
                                    ColumnQuestion.routeName,
                                    RowQuestion.routeName,
                                    StackQuestion.routeName,
                                    // Todo: Add real Qs here.
                                    ColumnQuestion.routeName,
                                    RowQuestion.routeName,
                                    StackQuestion.routeName,
                                    ColumnQuestion.routeName,
                                    RowQuestion.routeName,
                                    StackQuestion.routeName,
                                  ]
                                : [
                                    ColumnQuestion.routeName,
                                    RowQuestion.routeName,
                                    StackQuestion.routeName,
                                  ],
                          );

                          Navigator.pushNamed<void>(
                            context,
                            args.routeName,
                            arguments: args,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// A convenience function that will navigate to the Style Sphinx minigame and
// set the "originalRoute" -- the name of the route the game will navigate
// back to after completing the challenge.
Future<void> navigateToSphinxMiniGame(BuildContext context) =>
    _navigateToSphinxScreen(context, SphinxScreen.miniGameRouteName);

// A convenience function that will navigate to the complete Style Sphinx game
// and set the "originalRoute" -- the name of the route the game will navigate
// back to after completing the challenge.
Future<void> navigateToSphinxFullGame(BuildContext context) =>
    _navigateToSphinxScreen(context, SphinxScreen.fullGameRouteName);

Future<void> _navigateToSphinxScreen(BuildContext context, String route) {
  return Navigator.pushNamed(
    context,
    route,
    arguments: ModalRoute.of(context).settings.name,
  );
}
