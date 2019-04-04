import 'package:dev_rpg/src/widgets/buttons/wide_button.dart';
import 'package:flutter/material.dart';

class WelcomeButton extends StatefulWidget {
  final Widget child;
  final Color background;
  final IconData icon;
  final String label;
  @required
  final VoidCallback onPressed;
  const WelcomeButton(
      {this.child, this.onPressed, this.background, this.icon, this.label});

  @override
  _WelcomeButtonState createState() => _WelcomeButtonState();
}

class _WelcomeButtonState extends State<WelcomeButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorTween;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: widget.background, end: widget.background)
        .animate(_animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(WelcomeButton oldWidget) {
    setState(() {
      _colorTween = ColorTween(begin: _colorTween.value, end: widget.background)
          .animate(_animationController);
      _animationController.reset();
      _animationController.forward();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => WideButton(
              onPressed: widget.onPressed,
              background: _colorTween.value,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 16,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 13),
                    Text(widget.label.toUpperCase(),
                        style: TextStyle(
                            fontFamily: "MontserratMedium", fontSize: 16))
                  ],
                ),
              ),
            ));
  }
}
