import 'package:flutter/widgets.dart';

enum KittyType { orange, yellow }

class KittyBed extends StatelessWidget {
  final KittyType type;

  const KittyBed({@required this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case KittyType.orange:
        return Image.asset('assets/style_sphinx/normalized/red_bed.png');
      case KittyType.yellow:
      default:
        return Image.asset('assets/style_sphinx/normalized/green_bed.png');
    }
  }
}

class Kitty extends StatelessWidget {
  final KittyType type;

  const Kitty({@required this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case KittyType.orange:
        return Image.asset('assets/style_sphinx/normalized/orange_cat.png');
      case KittyType.yellow:
      default:
        return Image.asset('assets/style_sphinx/normalized/yellow_cat.png');
    }
  }
}
