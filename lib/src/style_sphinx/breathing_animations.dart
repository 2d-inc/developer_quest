import 'package:flutter/widgets.dart';

// The base class for Breathing animations. Creates the necessary animation
// controller that can be configured using a provided tween.
class _BreathingBase<T> extends StatefulWidget {
  final Widget Function(BuildContext, Animation<T>) builder;
  final Tween<T> tween;

  const _BreathingBase({
    @required this.builder,
    @required this.tween,
    Key key,
  }) : super(key: key);

  @override
  _BreathingBaseState createState() => _BreathingBaseState<T>();
}

class _BreathingBaseState<T> extends State<_BreathingBase<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<T> _animation;

  @override
  void initState() {
    // Create the animation controller to drive the offset animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create an animation using the provided tween
    _animation =
        widget.tween.chain(CurveTween(curve: Curves.ease)).animate(_controller);

    // Start the animation and ensure it repeats indefinitely
    _controller
      ..forward()
      ..repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _animation);
  }
}

// Creates a Bouncing "Breathing Animation." It does so using an Offset Tween
// and a SlideTransition.
class Bouncy extends StatelessWidget {
  final Widget child;

  const Bouncy({@required this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BreathingBase<Offset>(
      tween: Tween<Offset>(
        begin: const Offset(0, -0.05),
        end: const Offset(0, 0.05),
      ),
      builder: (context, animation) {
        return SlideTransition(
          position: animation,
          child: child,
        );
      },
    );
  }
}

// Creates a Breathing animation that fades a Widget in and out. It does so
// using a Tween<double> with a FadeTransition Widget
class Faded extends StatelessWidget {
  final Widget child;
  final double begin;
  final double end;

  const Faded({
    @required this.child,
    this.begin = 1,
    this.end = 0.8,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BreathingBase<double>(
      tween: Tween<double>(
        begin: begin,
        end: end,
      ),
      builder: (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
