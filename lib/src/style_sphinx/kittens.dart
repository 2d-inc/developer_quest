import 'package:flutter/widgets.dart';

enum KittyType { orange, yellow }

class KittyBed extends StatelessWidget {
  static const ImageProvider redProvider =
      AssetImage('assets/style_sphinx/red_bed.png');
  static const ImageProvider greenProvider =
      AssetImage('assets/style_sphinx/green_bed.png');

  final KittyType type;

  const KittyBed({@required this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      _SizedItem(child: Image(image: _provider));

  ImageProvider get _provider {
    switch (type) {
      case KittyType.orange:
        return redProvider;
      case KittyType.yellow:
      default:
        return greenProvider;
    }
  }
}

class Kitty extends StatelessWidget {
  static const ImageProvider orangeProvider =
      AssetImage('assets/style_sphinx/orange_cat.png');
  static const ImageProvider yellowProvider =
      AssetImage('assets/style_sphinx/yellow_cat.png');

  final KittyType type;

  const Kitty({@required this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      _SizedItem(child: Image(image: _provider));

  ImageProvider get _provider {
    switch (type) {
      case KittyType.orange:
        return orangeProvider;
      case KittyType.yellow:
      default:
        return yellowProvider;
    }
  }
}

class _SizedItem extends StatelessWidget {
  final Widget child;

  const _SizedItem({@required this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width < 600 ? 120 : width < 900 ? 160 : 200,
        maxHeight: height < 600 ? 120 : height < 900 ? 160 : 200,
      ),
      child: child,
    );
  }
}
