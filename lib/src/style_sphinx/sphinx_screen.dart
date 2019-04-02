import 'package:dev_rpg/src/style_sphinx/fonts.dart';
import 'package:dev_rpg/src/style_sphinx/question.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_image.dart';
import 'package:dev_rpg/src/style_sphinx/text_bubble.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class SphinxScreen extends StatelessWidget {
  static const String routeName = '/sphinx';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('pyramid.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: TextBubble(
                    child: Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: JoystixText(
                            'Welcome, friend.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: JoystixText(
                            'I am the Style Sphinx.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        JoystixText(
                          'To proceed, solve for me these layouts three!',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SphinxImage()),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: FlatButton(
                    color: Colors.red,
                    child: const JoystixText('Face the Sphinx'),
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) {
                            return const FlexQuestion(
                              type: Column,
                              instructions:
                                  '''Select the correct Widget to move the kitties to their beds''',
                              successTitle: 'You\'ve done it!',
                              successMessage:
                                  '''A Column widget displays its children one after the next in a vertical direction.''',
                              nextQuestion: FlexQuestion(
                                type: Row,
                                instructions:
                                    '''Select the correct Widget to move the kitties to their beds''',
                                successTitle: 'Nice one!',
                                successMessage:
                                    '''A Row widget displays its children side by side in a horizontal direction.''',
                                nextQuestion: FlexQuestion(
                                  type: Stack,
                                  instructions:
                                      '''Select the correct Widget to position on kitty on top of the other''',
                                  successTitle: 'Victory!',
                                  successMessage:
                                      '''A Stack widget layers its children one on top of the next.''',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
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
