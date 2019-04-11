import 'package:dev_rpg/src/style_sphinx/breathing_animations.dart';
import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:dev_rpg/src/style_sphinx/question_scaffold.dart';
import 'package:dev_rpg/src/style_sphinx/success_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColumnQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/column';

  const ColumnQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _FlexQuestion(
      type: Column,
      instructions:
          '''Select the correct Widget to move the kitties to their beds''',
      successMessage:
          '''A Column widget displays its children one after the next in a vertical direction.''',
    );
  }
}

class RowQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/row';

  const RowQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _FlexQuestion(
      type: Row,
      instructions:
          '''Select the correct Widget to move the kitties to their beds''',
      successMessage:
          '''A Row widget displays its children side by side in a horizontal direction.''',
    );
  }
}

class StackQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/stack';

  const StackQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _FlexQuestion(
      type: Stack,
      instructions:
          '''Select the correct Widget to position on kitty on top of the other''',
      successMessage:
          '''A Stack widget layers its children one on top of the next.''',
    );
  }
}

class _FlexQuestion extends StatefulWidget {
  final Type type;
  final String successMessage;
  final String instructions;

  const _FlexQuestion({
    @required this.type,
    @required this.successMessage,
    @required this.instructions,
    Key key,
  }) : super(key: key);

  @override
  _FlexQuestionState createState() => _FlexQuestionState();
}

class _FlexQuestionState extends State<_FlexQuestion> {
  Type _type;
  final _kittens = <KittyType>[
    KittyType.blue,
    KittyType.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      expected: FlexQuestionExpected(
        kittens: _kittens,
        type: widget.type,
      ),
      actual: FlexQuestionActual(
        kittens: _kittens,
        type: _type,
      ),
      question: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            widget.instructions,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Wrap(
            children: [
              DropdownButton<Type>(
                hint: const Faded(
                  child: Text(
                    'Widget',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
                items: const [
                  DropdownMenuItem<Type>(
                    child: Text(
                      'Row',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    value: Row,
                  ),
                  DropdownMenuItem<Type>(
                    child: Text(
                      'Column',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    value: Column,
                  ),
                  DropdownMenuItem<Type>(
                    child: Text(
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
                onChanged: onDropdownChange,
              ),
              const Text('(')
            ],
            crossAxisAlignment: WrapCrossAlignment.center,
          ),
          const Text('  children: <Widget>['),
          const Text('    Image.asset(\'blue_kitty.png\')'),
          const Text('    Image.asset(\'brown_kitty.png\')'),
          const Text('  ],'),
          const Text('),'),
        ],
      ),
    );
  }

  void onDropdownChange(Type type) {
    // Update the state to show the change
    setState(() {
      _type = type;
    });

    // Then, if the user has selected the correct option, display the Success
    // Sphinx!
    if (type == widget.type) {
      navigateToNextQuestion(
        context,
        widget.successMessage,
      );
    }
  }
}

class FlexQuestionExpected extends StatelessWidget {
  final List<KittyType> kittens;
  final Type type;
  final EdgeInsets iconPadding;
  final double iconSize;

  const FlexQuestionExpected({
    @required this.kittens,
    @required this.type,
    this.iconPadding = const EdgeInsets.all(4),
    this.iconSize = 100,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = kittens.map((type) {
      return Padding(
        padding: iconPadding,
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: KittyBed(
            type: type,
          ),
        ),
      );
    }).toList();

    switch (type) {
      case Column:
        return Column(children: children);
      case Row:
        return Row(children: children);
      case Stack:
      default:
        return Stack(
          children: List.generate(
            children.length,
            (i) {
              return Padding(
                padding: EdgeInsets.all(i * 8.0),
                child: children[i],
              );
            },
          ),
        );
    }
  }
}

class FlexQuestionActual extends StatelessWidget {
  final List<KittyType> kittens;
  final Type type;
  final EdgeInsets iconPadding;
  final double iconSize;

  const FlexQuestionActual({
    @required this.kittens,
    @required this.type,
    this.iconPadding = const EdgeInsets.all(4),
    this.iconSize = 100,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bouncingChildren = kittens.map((type) {
      return Padding(
        padding: iconPadding,
        child: Bouncy(
          child: SizedBox(
            child: Kitty(type: type),
            width: iconSize,
            height: iconSize,
          ),
        ),
      );
    }).toList();

    switch (type) {
      case Stack:
        return Stack(
          children: List.generate(
            bouncingChildren.length,
            (i) {
              return Padding(
                padding: EdgeInsets.all(i * 8.0),
                child: bouncingChildren[i],
              );
            },
          ),
        );
      case Column:
        return Column(children: bouncingChildren);
      case Row:
        return Row(children: bouncingChildren);
      default:
        return _StartingPosition(
          children: bouncingChildren,
          type: type,
        );
    }
  }
}

class _StartingPosition extends StatelessWidget {
  final List<Widget> children;
  final Type type;

  const _StartingPosition({
    @required this.children,
    @required this.type,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case Column:
        return Row(
          children: children,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
      case Row:
      default:
        return Column(
          children: children,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
    }
  }
}
