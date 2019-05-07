import 'package:auto_size_text/auto_size_text.dart';
import 'package:dev_rpg/src/style_sphinx/breathing_animations.dart';
import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:dev_rpg/src/style_sphinx/question_scaffold.dart';
import 'package:dev_rpg/src/style_sphinx/success_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainAxisStartQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_1';

  const MainAxisStartQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Column,
      expectedMainAxisAlignment: MainAxisAlignment.start,
      instructions:
          '''Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''Start places the children as close to the start of the main axis as possible.''',
    );
  }
}

class MainAxisEndQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_2';

  const MainAxisEndQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Column,
      expectedMainAxisAlignment: MainAxisAlignment.end,
      instructions:
          '''Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''End places the children as close to the end of the main axis as possible.''',
    );
  }
}

class MainAxisCenterQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_3';

  const MainAxisCenterQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Column,
      expectedMainAxisAlignment: MainAxisAlignment.center,
      instructions:
          '''Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''Center places the children as close to the middle of the main axis as possible.''',
    );
  }
}

class MainAxisSpaceAroundQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_4';

  const MainAxisSpaceAroundQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Column,
      expectedMainAxisAlignment: MainAxisAlignment.spaceAround,
      instructions:
          '''Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''SpaceAround places the free space evenly between the children as well as half of that space before and after the first and last child.''',
    );
  }
}

class MainAxisSpaceBetweenQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_5';

  const MainAxisSpaceBetweenQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Column,
      expectedMainAxisAlignment: MainAxisAlignment.spaceBetween,
      instructions:
          '''Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''SpaceBetween places the free space evenly between the children.''',
    );
  }
}

class MainAxisSpaceEvenlyQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_6';

  const MainAxisSpaceEvenlyQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Column,
      expectedMainAxisAlignment: MainAxisAlignment.spaceEvenly,
      instructions:
          '''Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''SpaceEvenly places the free space evenly between the children as well as before and after the first and last child.''',
    );
  }
}

class RowMainAxisStartQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_7';

  const RowMainAxisStartQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Row,
      expectedMainAxisAlignment: MainAxisAlignment.start,
      instructions:
          '''The main axis for a row is horizontal instead of vertical. Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''Start places the children as close to the start of the main axis as possible.''',
    );
  }
}

class RowMainAxisEndQuestion extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_8';

  const RowMainAxisEndQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Row,
      expectedMainAxisAlignment: MainAxisAlignment.end,
      instructions:
          '''The main axis for a row is horizontal instead of vertical. Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''End places the children as close to the end of the main axis as possible.''',
    );
  }
}

class RowMainAxisSpaceBetween extends StatelessWidget {
  static const String routeName = '/sphinx/main_axis_question_9';

  const RowMainAxisSpaceBetween({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MainAxisQuestion(
      flexType: Row,
      expectedMainAxisAlignment: MainAxisAlignment.spaceBetween,
      instructions:
          '''The main axis for a row is horizontal instead of vertical. Select the correct mainAxisAlignment to move the kitties to their beds''',
      successMessage:
          '''SpaceBetween places the free space evenly between the children.''',
    );
  }
}

class _MainAxisQuestion extends StatefulWidget {
  final Type flexType;
  final MainAxisAlignment expectedMainAxisAlignment;
  final CrossAxisAlignment expectedCrossAxisAlignment;
  final String successMessage;
  final String instructions;

  const _MainAxisQuestion({
    @required this.flexType,
    @required this.successMessage,
    @required this.instructions,
    this.expectedMainAxisAlignment = MainAxisAlignment.start,
    this.expectedCrossAxisAlignment = CrossAxisAlignment.center,
    Key key,
  }) : super(key: key);

  @override
  _MainAxisQuestionState createState() => _MainAxisQuestionState();
}

class _MainAxisQuestionState extends State<_MainAxisQuestion> {
  final _kittens = <KittyType>[
    KittyType.orange,
    KittyType.yellow,
  ];
  MainAxisAlignment _alignment;

  bool get _isCorrect => _alignment == widget.expectedMainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    const dropdownTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'MontserratMedium',
    );

    return QuestionScaffold(
      expected: _AxisQuestionExpected(
        kittens: _kittens,
        flexType: widget.flexType,
        mainAxisAlignment: widget.expectedMainAxisAlignment,
      ),
      actual: _AxisQuestionActual(
        kittens: _kittens,
        flexType: widget.flexType,
        actualMainAxisAlignment: _alignment,
        expectedCrossAxisAlignment: widget.expectedCrossAxisAlignment,
        expectedMainAxisAlignment: widget.expectedMainAxisAlignment,
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
            Text('${widget.flexType}('),
            Wrap(
              children: [
                const Text('    mainAxisAlignment: '),
                Container(
                  margin: const EdgeInsets.only(right: 10, left: 6),
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
                      child: DropdownButton<MainAxisAlignment>(
                        iconEnabledColor: Colors.white,
                        isDense: true,
                        hint: const Faded(
                          child: Text(
                            'alignment',
                            style: dropdownTextStyle,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<MainAxisAlignment>(
                            child: Text(
                              'start',
                              style: dropdownTextStyle,
                            ),
                            value: MainAxisAlignment.start,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: Text(
                              'center',
                              style: dropdownTextStyle,
                            ),
                            value: MainAxisAlignment.center,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: Text(
                              'end',
                              style: dropdownTextStyle,
                            ),
                            value: MainAxisAlignment.end,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: Text(
                              'spaceAround',
                              style: dropdownTextStyle,
                            ),
                            value: MainAxisAlignment.spaceAround,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: Text(
                              'spaceBetween',
                              style: dropdownTextStyle,
                            ),
                            value: MainAxisAlignment.spaceBetween,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: Text(
                              'spaceEvenly',
                              style: dropdownTextStyle,
                            ),
                            value: MainAxisAlignment.spaceEvenly,
                          ),
                        ],
                        value: _alignment,
                        // When a user selects an option from the Dropdown
                        onChanged: _onDropdownChange,
                      ),
                    ),
                  ),
                ),
                const Text(',')
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

  void _onDropdownChange(MainAxisAlignment alignment) {
    // Update the state to show the change
    setState(() => _alignment = alignment);

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

class _AxisQuestionExpected extends StatelessWidget {
  final List<KittyType> kittens;
  final Type flexType;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets iconPadding;

  const _AxisQuestionExpected({
    @required this.kittens,
    @required this.flexType,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.iconPadding = const EdgeInsets.all(4),
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = kittens.map<Widget>((type) => KittyBed(type: type)).toList();

    switch (flexType) {
      case Column:
        return Column(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        );
      case Row:
      default:
        return Row(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        );
    }
  }
}

class _AxisQuestionActual extends StatelessWidget {
  final List<KittyType> kittens;
  final Type flexType;
  final MainAxisAlignment actualMainAxisAlignment;
  final CrossAxisAlignment actualCrossAxisAlignment;
  final MainAxisAlignment expectedMainAxisAlignment;
  final CrossAxisAlignment expectedCrossAxisAlignment;
  final EdgeInsets iconPadding;
  final bool bouncing;

  const _AxisQuestionActual({
    @required this.kittens,
    @required this.flexType,
    @required this.bouncing,
    @required this.expectedMainAxisAlignment,
    @required this.expectedCrossAxisAlignment,
    this.actualMainAxisAlignment,
    this.actualCrossAxisAlignment,
    this.iconPadding = const EdgeInsets.all(4),
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = kittens.map<Widget>((type) {
      final kitty = Kitty(type: type);

      return Align(child: bouncing ? Bouncy(child: kitty) : kitty);
    }).toList();

    // Ensure the starting mainAxisAlignment is not the same as the expected.
    final mainAxisAlignment = actualMainAxisAlignment ??
        (expectedMainAxisAlignment == MainAxisAlignment.start
            ? MainAxisAlignment.center
            : MainAxisAlignment.start);

    // Ensure the starting crossAxisAlignment is not the same as the expected.
    final crossAxisAlignment = actualCrossAxisAlignment ??
        (expectedCrossAxisAlignment == CrossAxisAlignment.center
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center);

    switch (flexType) {
      case Column:
        return Column(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        );
      case Row:
      default:
        return Row(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        );
    }
  }
}
