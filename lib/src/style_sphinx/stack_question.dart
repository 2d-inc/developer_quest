import 'package:dev_rpg/src/style_sphinx/fonts.dart';
import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:dev_rpg/src/style_sphinx/success_route.dart';
import 'package:dev_rpg/src/style_sphinx/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StackQuestion extends StatefulWidget {
  final EdgeInsets iconPadding;
  final double iconSize;

  const StackQuestion({
    Key key,
    this.iconPadding = const EdgeInsets.all(4),
    this.iconSize = 100,
  }) : super(key: key);

  @override
  _StackQuestionState createState() => _StackQuestionState();
}

class _StackQuestionState extends State<StackQuestion>
    with TickerProviderStateMixin {
  Type _type;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    // Create the animation controller to drive the offset animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create an animation to move icons up and down using a Tween that is
    // driven by the controller
    _offsetAnimation = _controller.drive(Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: const Offset(0, 0.05),
    ));

    // Create an animation to change the color of the Dropdown hint that is
    // driven by the controller
    _colorAnimation = _controller.drive(ColorTween(
      begin: Colors.black12,
      end: Colors.black,
    ));

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
    final children = <KittyType>[
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
                  const JoystixText(
                    '''Select the correct Widget to move both kitties to the same bed''',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    children: [
                      DropdownButton<Type>(
                        underline: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, _) {
                            return Container(
                              height: 1,
                              color: _colorAnimation.value,
                            );
                          },
                        ),
                        hint: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, _) {
                            return MonoText(
                              'Widget',
                              style: TextStyle(
                                color: _colorAnimation.value,
                                fontSize: 22,
                              ),
                            );
                          },
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
                        onChanged: (type) async {
                          setState(() {
                            _type = type;
                          });

                          if (type == Stack) {
                            final animation =
                                await Navigator.push<Animation<double>>(
                              context,
                              SuccessRoute(
                                child: TextBubble(
                                  bottomPadding: 28,
                                  child: Column(
                                    children: const [
                                      JoystixText(
                                        '''Victory!''',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 16),
                                      JoystixText(
                                        '''A Stack widget layers its children one on top of the next.''',
                                      ),
                                      SizedBox(height: 16),
                                      JoystixText(
                                        '''Rats, you've defeated me!!!''',
                                      ),
                                      SizedBox(height: 16),
                                      ProceedButton(
                                        message: 'Escape the Sphinx',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            animation.addListener(() {
                              if (animation.isDismissed) {
                                Navigator.popUntil(context,
                                    (route) => route.settings.name == '/');
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
                    child: _buildExpected(children),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildResult(children),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(List<KittyType> kittens) {
    final bouncingChildren = kittens.map((type) {
      return Padding(
        padding: widget.iconPadding,
        child: SlideTransition(
          position: _offsetAnimation,
          child: SizedBox(
            child: Kitty(type: type),
            width: widget.iconSize,
            height: widget.iconSize,
          ),
        ),
      );
    }).toList();

    switch (_type) {
      case Stack:
        return Stack(children: bouncingChildren);
      case Column:
        return Column(children: bouncingChildren);
      case Row:
        return Row(children: bouncingChildren);
      default:
        return Column(
          children: bouncingChildren,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
    }
  }

  Widget _buildExpected(List<KittyType> kittens) {
    return Stack(
      children: kittens.map((type) {
        return Padding(
          padding: widget.iconPadding,
          child: SizedBox(
            width: widget.iconSize,
            height: widget.iconSize,
            child: KittyBed(
              type: type,
            ),
          ),
        );
      }).toList(),
    );
  }
}
