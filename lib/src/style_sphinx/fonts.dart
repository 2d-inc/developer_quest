import 'package:flutter/widgets.dart';

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
      style: style.copyWith(
        fontFamily: 'RobotoMono',
        fontSize: style.fontSize ?? 15,
      ),
      textAlign: textAlign,
    );
  }
}
