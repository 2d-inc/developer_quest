import 'dart:async';

import 'package:dev_rpg/src/style_sphinx/feature_discovery/feature_discovery.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class SphinxScreen extends StatelessWidget {
  static const String routeName = '/sphinx';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/style_sphinx/pyramid.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset('assets/style_sphinx/sphinx.png'),
                    const SizedBox(height: 60),
                    const JoystixText(
                      'Welcome, friend. \n\nI am the Style Sphinx. \n\nIn order to proceed, style for me these layouts three!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FlatButton(
                      color: Colors.red,
                      child: const JoystixText('Begin'),
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) {
                              return FeatureDiscovery(child: ColumnQuestion());
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnQuestion extends StatefulWidget {
  @override
  _ColumnQuestionState createState() => _ColumnQuestionState();
}

class _ColumnQuestionState extends State<ColumnQuestion>
    with SingleTickerProviderStateMixin {
  static const _feature1 = 'feature1';

  Type _type;
  AnimationController _controller;
  bool _playFeatureDiscovery = true;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_playFeatureDiscovery) {
      _playFeatureDiscovery = false;
      scheduleMicrotask(() {
        FeatureDiscovery.discoverFeatures(context, [_feature1]);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const Icon(
        Icons.map,
        size: 48,
      ),
      const Icon(
        Icons.email,
        size: 48,
      ),
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
                  Wrap(
                    children: [
                      DescribedFeatureOverlay(
                        featureId: _feature1,
                        color: Colors.red,
                        title: const JoystixText(
                          'Select the correct Widget!',
                          style: TextStyle(fontSize: 18),
                        ),
                        description: const JoystixText(
                            'To proceed, find the correct Widget to align the dark icons with the light icons.'),
                        child: DropdownButton<Type>(
                          hint: const MonoText('Select a widget'),
                          items: const [
                            DropdownMenuItem<Type>(
                              child: MonoText('Column'),
                              value: Column,
                            ),
                            DropdownMenuItem<Type>(
                              child: MonoText('Row'),
                              value: Row,
                            ),
                            DropdownMenuItem<Type>(
                              child: MonoText('Stack'),
                              value: Stack,
                            ),
                          ],
                          value: _type,
                          onChanged: (type) async {
                            setState(() {
                              _type = type;
                            });

                            if (type == Column) {
                              final animation =
                                  await showDialog<Animation<double>>(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('You did it!'),
                                    content: const Text(
                                      'A Column widget places items one on top of the next!',
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: const Text(
                                          'Continue your journey!',
                                        ),
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            ModalRoute.of(context).animation,
                                          );
                                        },
                                      )
                                    ],
                                  );
                                },
                              );

                              animation.addListener(() {
                                if (animation.isDismissed) {
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (context) => RowQuestion(),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                      const MonoText('(')
                    ],
                    crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                  const MonoText('  children: <Widget>['),
                  const MonoText('    Icon(Icons.map)'),
                  const MonoText('    Icon(Icons.email)'),
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
                  child: Container(color: Colors.orange[300]),
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

  Widget _buildResult(List<Widget> children) {
    switch (_type) {
      case Stack:
        return Stack(children: children);
      case Column:
        return Column(children: children);
      case Row:
        return Row(children: children);
      default:
        return StartPosition(children: children);
    }
  }

  Widget _buildExpected(List<Widget> children) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: children,
      ),
    );
  }
}

class RowQuestion extends StatefulWidget {
  @override
  _RowQuestionState createState() => _RowQuestionState();
}

class _RowQuestionState extends State<RowQuestion>
    with SingleTickerProviderStateMixin {
  Type _type;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const Icon(
        Icons.map,
        size: 48,
      ),
      const Icon(
        Icons.email,
        size: 48,
      ),
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
                  Wrap(
                    children: [
                      DropdownButton<Type>(
                        hint: const MonoText('Select a Widget'),
                        items: const [
                          DropdownMenuItem<Type>(
                            child: MonoText('Column'),
                            value: Column,
                          ),
                          DropdownMenuItem<Type>(
                            child: MonoText('Row'),
                            value: Row,
                          ),
                          DropdownMenuItem<Type>(
                            child: MonoText('Stack'),
                            value: Stack,
                          ),
                        ],
                        value: _type,
                        onChanged: (type) async {
                          setState(() {
                            _type = type;
                          });

                          if (type == Row) {
                            final animation =
                                await showDialog<Animation<double>>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('You did it!'),
                                  content: const Text(
                                    'A Row widget places items next to one another.',
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child:
                                          const Text('Continue your journey!'),
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          ModalRoute.of(context).animation,
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            );

                            animation.addListener(() {
                              if (animation.isDismissed) {
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StackQuestion(),
                                  ),
                                );
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
                  const MonoText('    Icon(Icons.map)'),
                  const MonoText('    Icon(Icons.email)'),
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
                  child: Container(color: Colors.orange[300]),
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

  Widget _buildResult(List<Widget> children) {
    switch (_type) {
      case Stack:
        return Stack(children: children);
      case Column:
        return Column(children: children);
      case Row:
        return Row(children: children);
      default:
        return StartPosition(children: children);
    }
  }

  Widget _buildExpected(List<Widget> children) {
    return Opacity(
      opacity: 0.5,
      child: Row(
        children: children,
      ),
    );
  }
}

class StackQuestion extends StatefulWidget {
  @override
  _StackQuestionState createState() => _StackQuestionState();
}

class _StackQuestionState extends State<StackQuestion>
    with SingleTickerProviderStateMixin {
  Type _type;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const Icon(
        Icons.map,
        size: 48,
      ),
      const Icon(
        Icons.email,
        size: 48,
      ),
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
                  Wrap(
                    children: [
                      DropdownButton<Type>(
                        hint: const MonoText('Select a Widget'),
                        items: const [
                          DropdownMenuItem<Type>(
                            child: MonoText('Column'),
                            value: Column,
                          ),
                          DropdownMenuItem<Type>(
                            child: MonoText('Row'),
                            value: Row,
                          ),
                          DropdownMenuItem<Type>(
                            child: MonoText('Stack'),
                            value: Stack,
                          ),
                        ],
                        value: _type,
                        onChanged: (type) async {
                          setState(() {
                            _type = type;
                          });

                          if (type == Stack) {
                            await showDialog<Animation<double>>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('You did it!'),
                                  content: const Text(
                                    'A Stack widget places Widgets one on top of the other. Rats! Now you\'ve defeated me!',
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: const Text('Escape the Sphinx'),
                                      onPressed: () {
                                        Navigator.popUntil(
                                          context,
                                          (route) => route.settings.name == '/',
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                      const MonoText('(')
                    ],
                    crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                  const MonoText('  children: <Widget>['),
                  const MonoText('    Icon(Icons.map)'),
                  const MonoText('    Icon(Icons.email)'),
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
                  child: Container(color: Colors.orange[300]),
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

  Widget _buildResult(List<Widget> children) {
    switch (_type) {
      case Stack:
        return Stack(children: children);
      case Row:
        return Row(children: children);
      case Column:
        return Column(children: children);
      default:
        return StartPosition(children: children);
    }
  }

  Widget _buildExpected(List<Widget> children) {
    return Opacity(
      opacity: 0.5,
      child: Stack(
        children: children,
      ),
    );
  }
}

class JoystixText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final TextAlign textAlign;

  const JoystixText(
    this.data, {
    Key key,
    this.style = const TextStyle(),
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style.copyWith(fontFamily: 'Joystix'),
      textAlign: textAlign,
    );
  }
}

class MonoText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final TextAlign textAlign;

  const MonoText(
    this.data, {
    Key key,
    this.style = const TextStyle(),
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style.copyWith(fontFamily: 'RobotoMono'),
      textAlign: textAlign,
    );
  }
}

class StartPosition extends StatelessWidget {
  final List<Widget> children;

  const StartPosition({
    @required this.children,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
