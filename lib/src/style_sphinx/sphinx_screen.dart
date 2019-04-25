import 'package:dev_rpg/src/style_sphinx/flex_questions.dart';
import 'package:dev_rpg/src/style_sphinx/question_arguments.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_buttton.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_image.dart';
import 'package:dev_rpg/src/style_sphinx/text_bubble.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class SphinxScreen extends StatefulWidget {
  static const String miniGameRouteName = '/sphinx';
  static const String fullGameRouteName = '/sphinx/complete';
  static const ImageProvider background =
      AssetImage('style_sphinx/start_background.png');
  static const ImageProvider pyramid = AssetImage('style_sphinx/pyramid.png');

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
          child: Image(
            image: SphinxScreen.background,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 75),
            child: Image(
              image: SphinxScreen.pyramid,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ChatBubbles(),
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

class ChatBubbles extends StatelessWidget {
  const ChatBubbles();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        // Like a "SafeArea" Widget, but only applies the top padding
        top: MediaQuery.of(context).padding.top + 16,
      ),
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
    );
  }
}
