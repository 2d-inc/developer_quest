import 'package:flutter/widgets.dart';

enum KittyType { blue, brown, purple }

class KittyBed extends StatelessWidget {
  final KittyType type;

  const KittyBed({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case KittyType.blue:
        return Image.asset('assets/style_sphinx/kitty_bed_blue.png');
      case KittyType.brown:
        return Image.asset('assets/style_sphinx/kitty_bed_brown.png');
      case KittyType.purple:
      default:
        return Image.asset('assets/style_sphinx/kitty_bed_purple.png');
    }
  }
}

class Kitty extends StatelessWidget {
  final KittyType type;

  const Kitty({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case KittyType.blue:
        return Image.asset('assets/style_sphinx/kitty_blue.png');
      case KittyType.brown:
        return Image.asset('assets/style_sphinx/kitty_brown.png');
      case KittyType.purple:
      default:
        return Image.asset('assets/style_sphinx/kitty_purple.png');
    }
  }
}
