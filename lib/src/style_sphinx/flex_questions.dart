import 'package:auto_size_text/auto_size_text.dart';
import 'package:dev_rpg/src/style_sphinx/breathing_animations.dart';
import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:dev_rpg/src/style_sphinx/question_scaffold.dart';
import 'package:dev_rpg/src/style_sphinx/success_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColumnQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/vertical_positioning';

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
  static const String routeName = '/sphinx/horizontal_positioning';

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
  static const String routeName = '/sphinx/layer_widgets';

  const StackQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _FlexQuestion(
      type: Stack,
      instructions:
          '''Select the correct Widget to position both kitties on the same bed''',
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
  final _kittens = <KittyType>[
    KittyType.orange,
    KittyType.yellow,
  ];
  Type _type;

  bool get _isCorrect => _type == widget.type;

  @override
  Widget build(BuildContext context) {
    const dropdownTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'MontserratMedium',
    );

    return QuestionScaffold(
      expected: _FlexQuestionExpected(
        kittens: _kittens,
        type: widget.type,
      ),
      actual: _FlexQuestionActual(
        kittens: _kittens,
        actualType: _type,
        expectedType: widget.type,
        bouncing: !_isCorrect,
      ),
      question: DefaultTextStyle(
        style: const TextStyle(
          color: Color.fromRGBO(85, 34, 34, 1),
          fontFamily: 'MontserratMedium',
          fontSize: 16,
          height: 1.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            AutoSizeText(
              widget.instructions,
              style: const TextStyle(fontSize: 24, height: 1),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 6,
                    top: 4,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: const Color.fromRGBO(85, 34, 34, 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color.fromRGBO(85, 34, 34, 1),
                      ),
                      child: DropdownButton<Type>(
                        iconEnabledColor: Colors.white,
                        isDense: true,
                        hint: const Faded(
                          child: Text(
                            'Widget',
                            style: dropdownTextStyle,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<Type>(
                            child: Text(
                              'Row',
                              style: dropdownTextStyle,
                            ),
                            value: Row,
                          ),
                          DropdownMenuItem<Type>(
                            child: Text(
                              'Column',
                              style: dropdownTextStyle,
                            ),
                            value: Column,
                          ),
                          DropdownMenuItem<Type>(
                            child: Text(
                              'Stack',
                              style: dropdownTextStyle,
                            ),
                            value: Stack,
                          ),
                        ],
                        value: _type,
                        // When a user selects an option from the Dropdown
                        onChanged: _onDropdownChange,
                      ),
                    ),
                  ),
                ),
                const Text('(')
              ],
            ),
            const Text('    children: <Widget>['),
            const Text('        Image.asset(\'orange_kitty.png\')'),
            const Text('        Image.asset(\'yellow_kitty.png\')'),
            const Text('    ],'),
            const Text(');'),
          ],
        ),
      ),
    );
  }

  void _onDropdownChange(Type type) {
    // Update the state to show the change
    setState(() => _type = type);

    // Then, if the user has selected the correct option, display the Success
    // Sphinx!
    if (_isCorrect) {
      navigateToNextQuestion(
        context,
        widget.successMessage,
      );
    }
  }
}

class _FlexQuestionExpected extends StatelessWidget {
  final List<KittyType> kittens;
  final Type type;
  final EdgeInsets iconPadding;

  const _FlexQuestionExpected({
    @required this.kittens,
    @required this.type,
    this.iconPadding = const EdgeInsets.all(4),
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = kittens.map<Widget>((type) => KittyBed(type: type)).toList();

    if (type == Column || type == Row) {
      children = children
          .map((child) => Expanded(child: Align(child: child)))
          .toList();
    }

    switch (type) {
      case Column:
        return Column(children: children);
      case Row:
        return Row(children: children);
      case Stack:
      default:
        return Stack(children: [children.first]);
    }
  }
}

class _FlexQuestionActual extends StatelessWidget {
  final List<KittyType> kittens;
  final Type actualType;
  final Type expectedType;
  final EdgeInsets iconPadding;
  final bool bouncing;

  const _FlexQuestionActual({
    @required this.kittens,
    @required this.actualType,
    @required this.expectedType,
    @required this.bouncing,
    this.iconPadding = const EdgeInsets.all(4),
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = kittens.map<Widget>((type) {
      final kitty = Kitty(type: type);
      final child = bouncing ? Bouncy(child: kitty) : kitty;

      return _shouldExpand ? Expanded(child: Align(child: child)) : child;
    }).toList();

    switch (actualType) {
      case Stack:
        return Stack(children: children);
      case Column:
        return Column(children: children);
      case Row:
        return Row(children: children);
      default:
        return _StartingPosition(
          children: children,
          type: expectedType,
        );
    }
  }

  bool get _shouldExpand {
    switch (actualType) {
      case Stack:
        return false;
      default:
        return true;
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
      case Row:
        return Column(
          children: children,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
      case Column:
      default:
        return Row(
          children: children,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
    }
  }
}
