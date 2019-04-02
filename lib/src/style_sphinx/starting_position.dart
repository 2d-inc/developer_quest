import 'package:flutter/widgets.dart';

class StartPosition extends StatelessWidget {
  final List<Widget> children;
  final Type type;

  const StartPosition({
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
