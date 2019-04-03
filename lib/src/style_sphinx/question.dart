import 'package:dev_rpg/src/style_sphinx/breathing_animations.dart';
import 'package:dev_rpg/src/style_sphinx/fonts.dart';
import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:dev_rpg/src/style_sphinx/kitty_beds.dart';
import 'package:dev_rpg/src/style_sphinx/kitty_results.dart';
import 'package:dev_rpg/src/style_sphinx/success_route.dart';
import 'package:dev_rpg/src/style_sphinx/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlexQuestion extends StatefulWidget {
  final Type type;
  final String successTitle;
  final String successMessage;
  final String instructions;
  final Widget nextQuestion;

  const FlexQuestion({
    @required this.type,
    @required this.successTitle,
    @required this.successMessage,
    @required this.instructions,
    this.nextQuestion,
    Key key,
  }) : super(key: key);

  @override
  _FlexQuestionState createState() => _FlexQuestionState();
}

class _FlexQuestionState extends State<FlexQuestion> {
  Type _type;

  @override
  Widget build(BuildContext context) {
    final kittens = <KittyType>[
      KittyType.blue,
      KittyType.brown,
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 24.0,
                top: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  JoystixText(
                    widget.instructions,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    children: [
                      DropdownButton<Type>(
                        hint: const Faded(
                          child: MonoText(
                            'Widget',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<Type>(
                            child: MonoText(
                              'Row',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: Row,
                          ),
                          DropdownMenuItem<Type>(
                            child: MonoText(
                              'Column',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: Column,
                          ),
                          DropdownMenuItem<Type>(
                            child: MonoText(
                              'Stack',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: Stack,
                          ),
                        ],
                        value: _type,
                        // When a user selects an option from the Dropdown
                        onChanged: (type) async {
                          // Update the state to show the change
                          setState(() {
                            _type = type;
                          });

                          // Then, if the user has selected the correct option,
                          // display the Success Sphinx!
                          //
                          // Furthermore, capture the sphinx flying in
                          // animation. This allows us to navigate to the next
                          // question once the animation has completed.
                          if (type == widget.type) {
                            final animation =
                                await Navigator.push<Animation<double>>(
                              context,
                              SuccessRoute(
                                child: TextBubble(
                                  bottomPadding: 28,
                                  child: Column(
                                    children: [
                                      JoystixText(
                                        widget.successTitle,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 16),
                                      JoystixText(
                                        widget.successMessage,
                                      ),
                                      const SizedBox(height: 16),
                                      const ProceedButton(),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            // Listen to the sphinx flying away animation. When
                            // it is finished, navigate to the next question.
                            animation.addListener(() {
                              if (animation.isDismissed) {
                                if (widget.nextQuestion != null) {
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (context) => widget.nextQuestion,
                                    ),
                                  );
                                } else {
                                  Navigator.popUntil(
                                    context,
                                    (route) => route.settings.name == '/',
                                  );
                                }
                              }
                            });
                          }
                        },
                      ),
                      const MonoText('(')
                    ],
                    crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                  const MonoText('  children: <Widget>['),
                  const MonoText('    Image.asset(\'blue_kitty.png\')'),
                  const MonoText('    Image.asset(\'brown_kitty.png\')'),
                  const MonoText('  ],'),
                  const MonoText('),'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(color: Colors.grey[300]),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: KittyBeds(
                      kittens: kittens,
                      type: widget.type,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: KittyResults(
                      kittens: kittens,
                      type: _type,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
