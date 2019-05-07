import 'package:flutter/material.dart';

/// A progress bar with rounded corners and custom colors.
class ProwessProgress extends StatefulWidget {
  const ProwessProgress(
      {@required this.progress,
      Key key,
      this.color,
      this.background = const Color.fromRGBO(0, 0, 0, 0.06),
      this.height = 7,
      this.borderRadius,
      this.innerPadding = const EdgeInsets.all(0)})
      : super(key: key);

  final double progress;
  final Color background;
  final Color color;
  final double height;
  final EdgeInsets innerPadding;
  final BorderRadius borderRadius;

  @override
  _ProwessProgressState createState() => _ProwessProgressState();
}

class _ProwessProgressState extends State<ProwessProgress>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _progressTween;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _progressTween = Tween<double>(begin: widget.progress, end: widget.progress)
        .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProwessProgress oldWidget) {
    setState(() {
      _progressTween =
          Tween<double>(begin: _progressTween.value, end: widget.progress)
              .animate(_animationController);
      _animationController.reset();
      _animationController.forward();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Container(
              decoration: BoxDecoration(
                  color: widget.background, borderRadius: widget.borderRadius),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => FractionallySizedBox(
                  widthFactor: _progressTween.value,
                  child: Padding(
                    padding: widget.innerPadding,
                    child: Container(
                      height: widget.height,
                      decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: widget.borderRadius),
                    ),
                  ),
                ),
          )
        ],
      ),
    );
  }
}
