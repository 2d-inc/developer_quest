import 'package:dev_rpg/src/style_sphinx/breathing_animations.dart';
import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:dev_rpg/src/style_sphinx/starting_position.dart';
import 'package:flutter/widgets.dart';

class KittyResults extends StatelessWidget {
  final List<KittyType> kittens;
  final Type type;
  final EdgeInsets iconPadding;
  final double iconSize;

  const KittyResults({
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
        return StartPosition(
          children: bouncingChildren,
          type: type,
        );
    }
  }
}
