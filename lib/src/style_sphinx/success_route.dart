import 'package:dev_rpg/src/style_sphinx/fonts.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_image.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class SuccessRoute extends PageRoute<Animation<double>> {
  SuccessRoute({
    @required this.child,
    RouteSettings settings,
    this.transitionDuration = const Duration(milliseconds: 1000),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  })  : assert(barrierDismissible != null),
        assert(maintainState != null),
        assert(opaque != null),
        super(settings: settings);

  final Widget child;

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
                child,
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
  final String message;

  const ProceedButton({
    this.message = 'Proceed',
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: FlatButton(
        onPressed: () {},
        color: Colors.black,
        child: JoystixText(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
