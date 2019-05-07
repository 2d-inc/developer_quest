import 'package:flutter/widgets.dart';

class SphinxImage extends StatelessWidget {
  static const ImageProvider provider =
      AssetImage('assets/style_sphinx/sphinx.png');

  const SphinxImage();

  @override
  Widget build(BuildContext context) {
    return Image(image: provider);
  }
}

class SphinxWithoutGlassesImage extends StatelessWidget {
  static const ImageProvider provider =
      AssetImage('assets/style_sphinx/sphinx_no_glasses.png');

  const SphinxWithoutGlassesImage();

  @override
  Widget build(BuildContext context) {
    return Image(image: provider);
  }
}

class SphinxGlassesImage extends StatelessWidget {
  static const ImageProvider provider =
      AssetImage('assets/style_sphinx/sunglasses.png');

  const SphinxGlassesImage();

  @override
  Widget build(BuildContext context) {
    return Image(image: provider);
  }
}
