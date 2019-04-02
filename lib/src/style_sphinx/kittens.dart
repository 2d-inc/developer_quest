import 'package:flutter_web/widgets.dart';

enum KittyType { blue, brown, purple }

class KittyBed extends StatelessWidget {
  final KittyType type;

  const KittyBed({@required this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case KittyType.blue:
        return Image.asset('kitty_bed_blue.png');
      case KittyType.brown:
        return Image.asset('kitty_bed_brown.png');
      case KittyType.purple:
      default:
        return Image.asset('kitty_bed_purple.png');
    }
  }
}

class Kitty extends StatelessWidget {
  final KittyType type;

  const Kitty({@required this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case KittyType.blue:
        return Image.asset('kitty_blue.png');
      case KittyType.brown:
        return Image.asset('kitty_brown.png');
      case KittyType.purple:
      default:
        return Image.asset('kitty_purple.png');
    }
  }
}
