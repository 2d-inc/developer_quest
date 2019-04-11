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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    children: const [
                      Align(
                        alignment: Alignment.topRight,
                        child: TextBubble(
                          child: Text(
                            'I am the Style Sphinx.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextBubble(
                          direction: TextBubbleDirection.right,
                          child: Text(
                            '''In order to proceed,\nstyle for me,\nthese layouts three''',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Flexible(child: SphinxImage()),
              Container(
                height: 130,
                color: const Color.fromRGBO(251, 168, 127, 1),
                child: Center(
                  child: SphinxButton(
                    onPressed: () => _startGame(context),
                    child: const Text('FACE THE SPHINX'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startGame(BuildContext context) {
    // When the user presses the buttons, navigate to the first question by
    // creating the original QuestionArguments.
    //
    // The QuestionArguments are configured up front and then passed from one
    // question screen to the next in order to drive the game forward.
    final arguments = QuestionArguments(
      originalRoute: '${ModalRoute.of(context).settings.arguments}',
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
      arguments.routeName,
      arguments: arguments,
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

class SphinxButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const SphinxButton({
    @required this.onPressed,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);

    return Material(
      shape: RoundedRectangleBorder(borderRadius: radius),
      color: const Color.fromRGBO(242, 124, 78, 1),
      child: InkWell(
        borderRadius: radius,
        splashColor: const Color.fromRGBO(242, 124, 78, 1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: DefaultTextStyle(
            child: child,
            style: TextStyle(
                fontFamily: 'MontserratRegular',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(85, 34, 34, 1)),
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}
