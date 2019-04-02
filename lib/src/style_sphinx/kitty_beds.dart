import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:flutter_web/widgets.dart';

class KittyBeds extends StatelessWidget {
  final List<KittyType> kittens;
  final Type type;
  final EdgeInsets iconPadding;
  final double iconSize;

  const KittyBeds({
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
