import 'dart:math';

import 'package:dev_rpg/src/style_sphinx/question_arguments.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_buttton.dart';
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
    this.transitionDuration = const Duration(milliseconds: 2500),
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
    final screenSize = MediaQuery.of(context).size;
    final offsetTween = Tween<Offset>(
      begin: Offset(screenSize.width, -screenSize.height),
      end: const Offset(0, 24),
    );
    final scaleTween = Tween<double>(begin: 0, end: 1);

    // Setup the Scale and Offset animations. This requires different
    // animations for the forward and reverse operations to give the appropriate
    // animation depending on whether the sphinx is animating on or off the
    // screen.
    final forwardCurveTween = CurveTween(curve: Curves.easeIn)
        .chain(CurveTween(curve: Interval(0, 0.4)));
    final forwardOffsetAnimation =
        offsetTween.chain(forwardCurveTween).animate(animation);
    final forwardScaleAnimation =
        scaleTween.chain(forwardCurveTween).animate(animation);

    // Play the offset and scale animations immediately when the sphinx is
    // dismissed
    final reverseCurveTween = CurveTween(curve: Curves.easeIn)
        .chain(CurveTween(curve: Interval(0.6, 1)));
    final reverseOffsetAnimation =
        offsetTween.chain(reverseCurveTween).animate(animation);
    final reverseScaleAnimation =
        scaleTween.chain(reverseCurveTween).animate(animation);

    // Setup the animations for the glasses
    final glassesOpacityAnimation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Interval(0.4, 0.6)))
        .animate(animation);
    final glassesOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, -50), end: const Offset(0, 0))
            .chain(CurveTween(curve: Interval(0.6, 1)))
            .animate(animation);

    void proceed() => Navigator.pop(context, animation);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: animation.status == AnimationStatus.forward
              ? forwardOffsetAnimation.value
              : reverseOffsetAnimation.value,
          child: Transform.scale(
            child: child,
            scale: animation.status == AnimationStatus.forward
                ? forwardScaleAnimation.value
                : reverseScaleAnimation.value,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextBubble(
                child: Column(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    Text(message),
                    const SizedBox(height: 16),
                    SphinxButton(child: Text(buttonText), onPressed: proceed),
                  ],
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    const Positioned.fill(child: SphinxWithoutGlassesImage()),
                    AnimatedBuilder(
                      animation: glassesOpacityAnimation,
                      builder: (context, _) {
                        return Opacity(
                          opacity: animation.status == AnimationStatus.forward
                              ? glassesOpacityAnimation.value
                              : 1,
                          child: Transform.translate(
                            offset: animation.status == AnimationStatus.forward
                                ? glassesOffsetAnimation.value
                                : const Offset(0, 0),
                            child: const SphinxGlassesImage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
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
    if (animation.status == AnimationStatus.reverse && animation.value < 0.6) {
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
          (route) => !route.settings.name.contains('sphinx'),
        );
      }

      // Remove the listener when the animation completes
      animation.removeListener(listener);
    }
  }

  // Register the listener
  animation.addListener(listener);
}
