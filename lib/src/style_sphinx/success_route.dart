import 'dart:math';

import 'package:dev_rpg/src/style_sphinx/question_arguments.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_image.dart';
import 'package:dev_rpg/src/style_sphinx/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SuccessRoute extends PageRoute<Animation<double>> {
  static const _titles = [
    'You\'ve done it!',
    'Hooray!',
    'Congrats!',
    'Nice one!'
  ];
  static const _victory = 'Winner Winner!';

  SuccessRoute({
    @required String message,
    @required this.hasNextQuestion,
    RouteSettings settings,
    this.transitionDuration = const Duration(milliseconds: 1000),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  })  : message = !hasNextQuestion
            ? '$message\n\nRats. You\'ve defeated me!!!'
            : message,
        title = hasNextQuestion
            ? _titles[Random().nextInt(_titles.length)]
            : _victory,
        buttonText = hasNextQuestion ? 'Proceed' : 'Escape the Sphinx',
        assert(barrierDismissible != null),
        assert(maintainState != null),
        assert(opaque != null),
        super(settings: settings);

  final String message;
  final String title;
  final String buttonText;
  final bool hasNextQuestion;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final curveTween = CurveTween(curve: Curves.easeIn).chain(
      CurveTween(
        curve: Interval(
          0,
          1,
        ),
      ),
    );
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(500, -500),
      end: const Offset(
        0,
        24,
      ),
    ).chain(curveTween).animate(animation);

    final scaleAnimation =
        Tween<double>(begin: 0.3, end: 1).chain(curveTween).animate(animation);

    return GestureDetector(
      onTap: () => Navigator.pop(context, animation),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: offsetAnimation.value,
            child: Transform.scale(
              child: child,
              scale: scaleAnimation.value,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                TextBubble(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                      ),
                      const SizedBox(height: 16),
                      ProceedButton(text: buttonText),
                    ],
                  ),
                ),
                const SphinxImage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class ProceedButton extends StatelessWidget {
  final String text;

  const ProceedButton({
    @required this.text,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: FlatButton(
        onPressed: () {},
        color: Colors.black,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Future<void> navigateToNextQuestion(
  BuildContext context,
  String message,
) async {
  // Extract the Arguments from the current Route. Use these to determine
  // whether to navigate to the next question or original screen.
  //
  // If there are no arguments provided to the current route, default to an
  // empty set to exit the game immediately after choosing the correct answer.
  final args = ModalRoute.of(context).settings.arguments as QuestionArguments ??
      QuestionArguments();

  // Push the Success Route and wait for the user to hit the proceed button.
  // When they do, the route will return the "Flying Away" animation.
  final animation = await Navigator.push<Animation<double>>(
    context,
    SuccessRoute(
      message: message,
      hasNextQuestion: args.hasNextQuestion,
    ),
  );

  // Create a listener function that is called every time the animation emits a
  // change. When the animation is complete, it navigates to the next question
  // if one is available or back to the original route if the .
  void listener() {
    if (animation.isDismissed) {
      if (args.hasNextQuestion) {
        final nextQuestion = args.nextQuestion();

        Navigator.pushReplacementNamed(
          context,
          nextQuestion.routeName,
          arguments: nextQuestion,
        );
      } else {
        Navigator.popUntil(
          context,
          (route) => route.settings.name == args.originalRoute,
        );
      }

      // Remove the listener when the animation completes
      animation.removeListener(listener);
    }
  }

  // Register the listener
  animation.addListener(listener);
}
